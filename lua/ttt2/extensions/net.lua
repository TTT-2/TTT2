---
-- net stream extension
-- @author saibotk
-- @module net

local net = net
local util = util
local table = table
local isfunction = isfunction

-- Stream network message name constant
local NETMSG_STREAM = "TTT2_NET_STREAM"
local NETMSG_SPLIT_CONFIRM = "TTT2_NET_SPLIT_CONFIRM"

if SERVER then
	AddCSLuaFile()

	-- Add the network string for streaming data
	util.AddNetworkString(NETMSG_STREAM)
	-- Add the network string for confirming single splits
	util.AddNetworkString(NETMSG_SPLIT_CONFIRM)
end

-- Size to split the network stream at (currently a bit lower than the max value, just to have some buffer)
-- Can be up to 65.533KB see: https://wiki.facepunch.com/gmod/net.Start
net.STREAM_FRAGMENTATION_SIZE = 65400

-- Stream cache variables
local wait_stream_cache = {}
local current_split_id = {}
local backup_Plys = {}
local waiting_Plys = {}

net.stream_cache = {}
net.stream_callbacks = {}

--- 
-- Sends next part of the stream
-- @param string messageId a unique message id similar to the network strings
-- @param number streamId the current stream number the split is requested for
-- @param number split the part of the Stream that should be sent
-- @note This split number is inversed, so split = 1 of 4 is actually 4th and last entry of the data
-- It is done to save some calculations to see if the last entry is reached. 1 is the last in every stream
-- @realm shared
-- @internal
local function sendNextStream(messageId, streamId, split)
	net.Start(NETMSG_STREAM)
	-- Write the messageId
	net.WriteString(messageId)
	-- Write the streamId
	net.WriteUInt(streamId, 32)

	local sendMoreSplits = split > 1
	-- Write if there are still fragments coming after this one
	net.WriteBool(sendMoreSplits)

	local data = wait_stream_cache[messageId][streamId]
	-- Write the actual data fragment as a string, which internally will also send its size
	net.WriteString(data.splits[#data.splits + 1 - split])

	if SERVER then
		if data.plys then
			net.Send(data.plys)
		else
			net.Broadcast()
		end
	else
		net.SendToServer()
	end

	if not sendMoreSplits then
		local confirmations = current_split_id[messageId]
		confirmations[streamId] = 1

		-- Check if all outstanding streams are handled before reset
		for i = 1, #confirmations do
			if confirmations[i] > 1 then return end
		end

		-- Reset all caches
		wait_stream_cache[messageId] = {}
		current_split_id[messageId] = {}
		waiting_Plys[messageId] = {}
		backup_Plys[messageId] = {}
	end
end

---
-- Sends the next split and removes overrideTimers if given
-- @param string messageId a unique message id similar to the network strings
-- @param number streamId the current stream number the split is requested for
-- @param bool timerOverride if the timer called this function instead of the normal way
local function SendNextSplit(messageId, streamId, timerOverride)
	if timerOverride then
		waiting_Plys[messageId][streamId] = table.Copy(backup_Plys[messageId][streamId])
	else
		local timerName = messageId .. streamId
		if timer.Exists(timerName) then
			timer.Remove(timerName)
		end
	end

	local splitId = current_split_id[messageId][streamId] - 1
	current_split_id[messageId][streamId] = splitId

	sendNextStream(messageId, streamId, splitId)
end

---
-- Checks if all players in the cached players list have received it before 
-- it sends the next part of the stream
-- @param number len Length of message in Bits
-- @param Player ply player that the message has received, `nil` on the client
-- @realm shared
-- @internal
local function CheckConfirmedSplit(len, ply)
	local messageId = net.ReadString()
	local streamId = net.ReadUInt(32)

	-- Check if all plys of the given list have the info received
	local cPlys = waiting_Plys[messageId] and waiting_Plys[messageId][streamId]
	if cPlys then
		local plyID64 = ply:SteamID64()
		table.RemoveByValue(cPlys, plyID64)

		if #cPlys > 0 then
			local timerName = messageId .. streamId

			-- If some players timeout or the given playerList is faulty, just send the next update after some time anyways
			if not timer.Exists(timerName) then
				timer.Create(timerName, 5, 1, function() SendNextSplit(messageId, splitId, true) end)
			end

			return
		end

		waiting_Plys[messageId][streamId] = table.Copy(backup_Plys[messageId][streamId])
	end

	SendNextSplit(messageId, streamId, false)
end
net.Receive(NETMSG_SPLIT_CONFIRM, CheckConfirmedSplit)

---
-- Initiates a stream message, usually for data that can be longer than
-- the 64kb limit of a single net message. This will split up the data and send them in
-- smaller fragments. The data will be converted (with sPON) to an encoded string during this process.
--
-- @param string messageId A unique message id similar to the network strings
-- @param table data The data table to send, this will be reconstructed at the player.
-- @param[opt] table|player plys SERVERSIDE only! Optional, use it to send a stream to a single player or a group of players.
-- @realm shared
function net.SendStream(messageId, data, plys)
	local encodedString = pon.encode(data)
	local splits = string.SplitAtSize(encodedString, net.STREAM_FRAGMENTATION_SIZE)

	wait_stream_cache[messageId] = wait_stream_cache[messageId] or {}
	current_split_id[messageId] = current_split_id[messageId] or {}

	local streamId = #wait_stream_cache[messageId] + 1

	wait_stream_cache[messageId][streamId] = {splits = splits, plys = plys}
	current_split_id[messageId][streamId] = #splits

	if istable(plys) and #plys > 1 then
		local plyIDs64 = {}

		for i = 1, #plys do
			plyIDs64[i] = plys[i]:SteamID64()
		end

		waiting_Plys[messageId] = waiting_Plys[messageId] or {}
		waiting_Plys[messageId][streamId] = plyIDs64
		backup_Plys[messageId] = backup_Plys[messageId] or {}
		backup_Plys[messageId][streamId] = table.Copy(plyIDs64)
	end

	-- Send first stream directly
	sendNextStream(messageId, streamId, #splits)
end

---
-- Request the next part of the stream
-- @param string messageId a unique message id similar to the network strings
-- @param number streamId the current stream number the split is requested for
-- @param[opt] table|player plys SERVERSIDE only! Optional, use it to send a stream to a single player or a group of players.
-- @realm shared
-- @internal
local function RequestNextSplit(messageId, streamId, plys)
	net.Start(NETMSG_SPLIT_CONFIRM)

	net.WriteString(messageId)
	net.WriteUInt(streamId, 32)

	if SERVER then
		if plys then
			net.Send(plys)
		else
			net.Broadcast()
		end
	else
		net.SendToServer()
	end
end

---
-- Receive a stream message, usually for data that can be longer than
-- the 64kb limit of a single net message. This will register a callback
-- for a specific messageId and execute it when the stream was received and
-- the data is reconstructed from all fragments.
--
-- @param string messageId a unique message id similar to the network strings
-- @param function callback(receivedTable, ply) This is the function that is called with the received table.
-- @realm shared
function net.ReceiveStream(messageId, callback)
	-- has to be saved as string, otherwise the key lookups will fail on the table
	local msg = messageId

	net.stream_callbacks[msg] = callback
end

---
-- Receive the internal stream message and add it to the cache
-- If all fragments have arrived, reconstruct the data and call
-- the registered callback.
-- @param number len Length of message in Bits
-- @param Player ply player that the message has received, `nil` on the client
-- @realm shared
-- @internal
local function ReceiveStream(len, ply)
	local messageId = net.ReadString()
	local streamId = net.ReadUInt(32)
	local fragmented = net.ReadBool()
	local data = net.ReadString()

	-- Create cache table if it does not exist yet for this message
	net.stream_cache[messageId] = net.stream_cache[messageId] or {}
	net.stream_cache[messageId][streamId] = net.stream_cache[messageId][streamId] or {}
	-- Write data to cache table
	net.stream_cache[messageId][streamId][#net.stream_cache[messageId][streamId] + 1] = data

	-- Check if there are still fragments on their way
	if not fragmented then
		-- Otherwise this was the last packet, so reconstruct the data
		local encodedStr = table.concat(net.stream_cache[messageId][streamId])
		local callback = net.stream_callbacks[messageId]

		-- Clear cache
		net.stream_cache[messageId][streamId] = nil

		-- Check if a callback is registered
		if isfunction(callback) then
			callback(pon.decode(encodedStr), ply)
		end
	else
		RequestNextSplit(messageId, streamId, ply)
	end
end
net.Receive(NETMSG_STREAM, ReceiveStream)
