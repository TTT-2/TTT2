---
-- This file contains all shared networking functions, to sync and manage the information between server and clients
-- @author saibotk

local data_store_metadata = {}
local data_store = {}
local data_listeners = {}

function TTT2NET:Get(path)
	return table.GetWithPath(data_store, path)
end

function TTT2NET:GetGlobal(path)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table
	table.insert(path, 1, "global")

	return self:Get(path)
end

function TTT2NET:GetOnPlayer(path, ply)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table with the specific player
	table.insert(path, 1, "players")
	table.insert(path, 2, ply:SteamID64())

	return self:Get(path, client)
end

function TTT2NET:Debug()
	print("[TTT2NET DEBUG: Global data table]")
	PrintTable(data_listeners)
	PrintTable(data_store_metadata)
	PrintTable(data_store)
end

-- TODO this will not call any callback method
local function ReceiveFullStateUpdate(result)
	print("Received data:")
	PrintTable(result)
	data_store_metadata = result.meta
	data_store = result.data
end

net.ReceiveStream(TTT2NET.NET_STREAM_FULL_STATE_UPDATE, ReceiveFullStateUpdate)

local function ReceiveMetaDataUpdate()
	local path = TTT2NET:NetReadPath()
	local metadata = TTT2NET:NetReadMetaData()

	print("Received Meta data update")
	PrintTable(path)
	PrintTable(metadata)

	-- Set the new metadata
	table.SetWithPath(data_store_metadata, path, metadata)

	-- Store the old value if there is any known
	local oldval = table.GetWithPath(data_store, path)

	-- Clear the saved value, as the metadata changed
	table.SetWithPath(data_store, path, nil)

	-- Call callbacks that registered on data updates
	TTT2NET:CallOnUpdate(path, oldval, nil)
end

net.Receive(TTT2NET.NETMSG_META_UPDATE, ReceiveMetaDataUpdate)

local function ReceiveDataUpdate()
	local path = TTT2NET:NetReadPath()
	local metadata = table.GetWithPath(data_store_metadata, path)
	local newval = TTT2NET:NetReadData(metadata)
	local oldval = TTT2NET:Get(path)

	print("Received data update")
	PrintTable(path)
	print(newval)

	table.SetWithPath(data_store, path, newval)

	TTT2NET:CallOnUpdate(path, oldval, newval)
end

net.Receive(TTT2NET.NETMSG_DATA_UPDATE, ReceiveDataUpdate)

function TTT2NET:CallOnUpdate(path, oldval, newval)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	local currentPath = table.Copy(path)
	local reversePath = {}

	-- traverse the path tree up from the bottom and also call their listeners
	for y = 1, #path do
		local callbacks = table.GetWithPath(data_listeners, currentPath) or {}

		-- call all registered callbacks for the current path
		for i = 1, #callbacks do
			callbacks[i](oldval, newval, reversePath)
		end

		-- remove the last path element and save in reversePath to let the parent callbacks know which value has changed
		table.insert(reversePath, 1, currentPath[#currentPath])
		currentPath[#currentPath] = nil
	end
end



function TTT2NET:RequestFullStateUpdate()
	net.Start(TTT2NET.NETMSG_REQUEST_FULL_STATE_UPDATE)
	net.SendToServer()
end

function TTT2NET:NetReadPath()
	local result = net.ReadString()

	return spon.decode(result)
end

function TTT2NET:NetReadMetaData()
	local metadata = {}
	metadata.type = net.ReadString()

	if metadata.type == "int" then
		metadata.bits = net.ReadUInt(6)
		metadata.unsigned = net.ReadBool()
	end

	return metadata
end

function TTT2NET:NetReadData(metadata)
	-- If the null flag is set, then return null
	if net.ReadBool() then
		return
	end
	if metadata.type == "int" then
		if metadata.unsigned then
			return net.ReadUInt(metadata.bits or 32)
		else
			return net.ReadInt(metadata.bits or 32)
		end
	elseif metadata.type == "bool" then
		return net.ReadBool()
	elseif metadata.type == "float" then
		return net.ReadFloat()
	else
		return net.ReadString()
	end
end

---
-- Registers a callback for a specific path.
-- The callback is called, when the value on that path was updated.
--
-- @param the path to watch for changes
-- @param function func
function TTT2NET:OnUpdate(path, func)
	assert(isfunction(func), "OnUpdate called with an invalid function.")

	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	local registeredCallbacks = table.GetWithPath(data_listeners, path) or {}

	if not table.HasValue(registeredCallbacks, func) then
		registeredCallbacks[#registeredCallbacks + 1] = func
	end

	table.SetWithPath(data_listeners, path, registeredCallbacks)
end

function TTT2NET:OnUpdateGlobal(path, func)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table
	table.insert(path, 1, "global")

	self:OnUpdate(path, func)
end

function TTT2NET:OnUpdateOnPlayer(path, ply, func)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table with the specific player
	table.insert(path, 1, "players")
	table.insert(path, 2, ply:SteamID64())

	self:OnUpdate(path, func)
end
