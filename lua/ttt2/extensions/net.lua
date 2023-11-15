---
-- net stream extension
-- @author saibotk
-- @module net

local net = net
local util = util
local table = table
local tostring = tostring
local isfunction = isfunction

-- Stream network message name constant
local NETMSG_STREAM = "TTT2_NET_STREAM"

if SERVER then
	AddCSLuaFile()

	-- Add the network string for streaming data
	util.AddNetworkString(NETMSG_STREAM)
end

-- Size to split the network stream at (currently a bit lower than the max value, just to have some buffer)
net.STREAM_FRAGMENTATION_SIZE = 65400

-- Stream cache variables
net.stream_cache = {}
net.stream_callbacks = {}

---
-- Initiates a stream message, usually for data that can be longer than
-- the 64kb limit of a single net message. This will split up the data and send them in
-- smaller fragments. The data will be converted (with sPON) to an encoded string during this process.
--
-- @param string messageId A unique message id similar to the network strings
-- @param table data The data table to send, this will be reconstructed at the client.
-- @param[opt] table|player client SERVERSIDE only! Optional, use it to send a stream to a single client or a group of clients.
-- @realm shared
function net.SendStream(messageId, data, client)
	local encodedString = pon.encode(data)
	local split = string.SplitAtSize(encodedString, net.STREAM_FRAGMENTATION_SIZE)
	local splitSize = #split

	for i = 1, splitSize do
		net.Start(NETMSG_STREAM)
		-- Write the messageId
		net.WriteUInt(util.CRC(messageId), 32)
		-- Write if there are still fragments coming after this one
		net.WriteBool(i < splitSize)
		-- Write the actual data fragment as a string, which internally will also send its size
		net.WriteString(split[i])

		if SERVER then
			if client then
				net.Send(client)
			else
				net.Broadcast()
			end
		else
			net.SendToServer()
		end
	end
end

---
-- Receive a stream message, usually for data that can be longer than
-- the 64kb limit of a single net message. This will register a callback
-- for a specific messageId and execute it when the stream was received and
-- the data is reconstructed from all fragments.
--
-- @param string messageId a unique message id similar to the network strings
-- @param function callback This is the function that is called after the data was received.
-- @realm shared
function net.ReceiveStream(messageId, callback)
	-- has to be saved as string, otherwise the key lookups will fail on the table
	local msg = tostring(util.CRC(messageId))

	net.stream_callbacks[msg] = callback
end

---
-- Receive the internal stream message and add it to the cache
-- If all fragments have arrived, reconstruct the data and call
-- the registered callback.
-- @internal
local function ReceiveStream()
	local messageId = tostring(net.ReadUInt(32))
	local fragmented = net.ReadBool()
	local data = net.ReadString()

	-- Create cache table if it does not exist yet for this message
	net.stream_cache[messageId] = net.stream_cache[messageId] or {}
	-- Write data to cache table
	net.stream_cache[messageId][#net.stream_cache[messageId] + 1] = data

	-- Check if there are still fragments on their way
	if not fragmented then
		-- Otherwise this was the last packet, so reconstruct the data
		local encodedStr = table.concat(net.stream_cache[messageId])
		local callback = net.stream_callbacks[messageId]

		-- Clear cache
		net.stream_cache[messageId] = nil

		-- Check if a callback is registered
		if isfunction(callback) then
			callback(pon.decode(encodedStr))
		end
	end
end
net.Receive(NETMSG_STREAM, ReceiveStream)
