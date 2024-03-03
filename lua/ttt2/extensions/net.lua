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
local NETMSG_REQUEST_NEXT_SPLIT = "TTT2_NET_REQUEST_NEXT_SPLIT"

if SERVER then
    AddCSLuaFile()

    -- Add the network string for streaming data
    util.AddNetworkString(NETMSG_STREAM)
    -- Add the network string for requesting single splits
    util.AddNetworkString(NETMSG_REQUEST_NEXT_SPLIT)
end

-- Size to split the network stream at (currently a bit lower than the max value, just to have some buffer)
-- Can be up to 65.533KB see: https://wiki.facepunch.com/gmod/net.Start
net.STREAM_FRAGMENTATION_SIZE = 65400

-- Stream cache variables
net.send_stream_cache = {}
net.receiving_players = {}
net.receive_stream_cache = {}
net.stream_callbacks = {}

---
-- Sends next part of the stream
-- @param string messageId a unique message id similar to the network strings
-- @param number streamId the current stream number the split is requested for
-- @param number split the part of the Stream that should be sent
-- @realm shared
-- @internal
local function SendNextStream(messageId, streamId, split, plys)
    net.Start(NETMSG_STREAM)
    -- Write the messageId
    net.WriteString(messageId)
    -- Write the streamId
    net.WriteUInt(streamId, 32)
    -- Write the current split
    net.WriteUInt(split, 8)

    local data = net.send_stream_cache[messageId][streamId]
    -- Write the actual data fragment as a string, which internally will also send its size
    net.WriteString(data[split])

    if SERVER then
        if plys then
            net.Send(plys)
        else
            net.Broadcast()
        end
    else
        net.SendToServer()
    end

    -- Delete cache if all players requested the last split
    local receivingPlayerList = net.receiving_players[messageId][streamId]
    if split <= 1 and (receivingPlayerList == nil or next(receivingPlayerList) == nil) then
        net.receiving_players[messageId][streamId] = nil
        net.send_stream_cache[messageId][streamId] = nil
    end
end

---
-- It sends the next requested part of the stream and checks if the player is eligible for it
-- @param number len Length of message in Bits
-- @param Player ply player that the message has received, `nil` on the client
-- @realm shared
-- @internal
local function SendNextSplit(len, ply)
    local messageId = net.ReadString()
    local streamId = net.ReadUInt(32)
    local nextSplit = net.ReadUInt(8)

    local receivingPlayerList = net.receiving_players[messageId][streamId]

    if nextSplit < 1 or receivingPlayerList and not receivingPlayerList[ply:SteamID64()] then
        return
    end

    -- Remove players that requested the last split
    if nextSplit <= 1 then
        receivingPlayerList[ply:SteamID64()] = nil
    end

    SendNextStream(messageId, streamId, nextSplit, ply)
end
net.Receive(NETMSG_REQUEST_NEXT_SPLIT, SendNextSplit)

---
-- Initiates a stream message, usually for data that can be longer than
-- the 64kb limit of a single net message. This will split up the data and send them in
-- smaller fragments. The data will be converted (with sPON) to an encoded string during this process.
--
-- @param string messageId A unique message id similar to the network strings
-- @param table data The data table to send, this will be reconstructed at the destination.
-- @param[opt] table|player plys SERVERSIDE only! Optional, use it to send a stream to a single player or a group of players otherwise it's broadcasted.
-- @realm shared
function net.SendStream(messageId, data, plys)
    local encodedString = pon.encode(data)
    local splits = string.SplitAtSize(encodedString, net.STREAM_FRAGMENTATION_SIZE)

    net.send_stream_cache[messageId] = net.send_stream_cache[messageId] or {}
    net.receiving_players[messageId] = net.receiving_players[messageId] or {}

    local streamId = #net.send_stream_cache[messageId] + 1

    net.send_stream_cache[messageId][streamId] = splits

    if SERVER and plys and #splits > 1 then
        net.receiving_players[messageId][streamId] = {}
        plys = istable(plys) and plys or { plys }

        for i = 1, #plys do
            net.receiving_players[messageId][streamId][plys[i]:SteamID64()] = true
        end
    end

    -- Send first stream directly
    SendNextStream(messageId, streamId, #splits, plys)
end

---
-- Request the next part of the stream
-- @param string messageId a unique message id similar to the network strings
-- @param number streamId the current stream number the split is requested for
-- @param number split the part of the Stream that should be sent
-- @param[opt] table|player plys SERVERSIDE only! Optional, use it to send a stream to a single player or a group of players.
-- @realm shared
-- @internal
local function RequestNextSplit(messageId, streamId, split, plys)
    net.Start(NETMSG_REQUEST_NEXT_SPLIT)

    net.WriteString(messageId)
    net.WriteUInt(streamId, 32)
    net.WriteUInt(split, 8)

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
    local msg = tostring(messageId)

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
    local split = net.ReadUInt(8)
    local data = net.ReadString()

    -- Create cache table if it does not exist yet for this message
    net.receive_stream_cache[messageId] = net.receive_stream_cache[messageId] or {}
    net.receive_stream_cache[messageId][streamId] = net.receive_stream_cache[messageId][streamId]
        or {}
    -- Write data to cache table
    net.receive_stream_cache[messageId][streamId][split] = data

    -- Check if this was the last fragment
    if split <= 1 then
        -- Otherwise this was the last packet, so reconstruct the data
        local encodedStr = table.concat(net.receive_stream_cache[messageId][streamId])
        local callback = net.stream_callbacks[messageId]

        -- Clear cache
        net.receive_stream_cache[messageId][streamId] = nil

        -- Check if a callback is registered
        if isfunction(callback) then
            callback(pon.decode(encodedStr), ply)
        end
    else
        RequestNextSplit(messageId, streamId, split - 1, ply)
    end
end
net.Receive(NETMSG_STREAM, ReceiveStream)
