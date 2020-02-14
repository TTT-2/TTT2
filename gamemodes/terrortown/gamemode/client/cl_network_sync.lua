---
-- This file contains all shared networking functions, to sync and manage the information between server and clients.
-- The system is intended for syncing data from the server to the client only.
-- So a client will only be able to read / get data and will receive updates from the server.
--
-- @module TTT2NET
-- @author saibotk

-- The meta data table to store information about the type of the data
local data_store_metadata = {}
-- The value data table to store the actual data
local data_store = {}
-- The table that cotains all registered callback functions
local data_listeners = {}

---
-- Get the current value of a specific path. This path starts at the root of the data_storage table and thus does not include the
-- "global"/"players" key to descend into these subtrees.
--
-- @param any|table path The path to get the value from (this is the absolute path from the root so "global"/"players" etc is not yet included)
-- @return any The value at the given path or nil if the path does not exist, the value is actually nil or there is no metadata entry for the path
function TTT2NET:Get(path)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Prevent wrong data being returned, when no metadata entry exists
	if table.GetWithPath(data_store_metadata, path) == nil then
		return
	end

	return table.GetWithPath(data_store, path)
end

---
-- The same as {@TTT2NET:Get} but this will take care of prepending the key
-- to access the global values. Global values are generally accessible synced values,
-- that the server sends to its clients.
--
-- @param any|table path The path to get the value from (no need to prepend a "global" as this will be done already)
-- @return any The value at the given path or nil if the path does not exist, the value is actually nil or there is no metadata entry for the path
function TTT2NET:GetGlobal(path)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table
	table.insert(path, 1, "global")

	return self:Get(path)
end

---
-- The same as {@TTT2NET:Get} but this will take care of prepending the key to access the player specific values.
-- Player specific values are synced values on player entities (can be thought of as data per player that this client knows of),
-- that the server sends to its clients.
--
-- @param any|table path The path to get the value from (no need to prepend a "players" etc. as this will be done already)
-- @param Entity The player from which we want to get the data
-- @return any The value at the given path or nil if the path does not exist, the value is actually nil or there is no metadata entry for the path
function TTT2NET:GetOnPlayer(path, ply)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table with the specific player
	table.insert(path, 1, "players")
	table.insert(path, 2, ply:EntIndex())

	return self:Get(path, client)
end

---
-- Prints out all TTT2NET related tables, for debugging purposes.
function TTT2NET:Debug()
	print("[TTT2NET] Debug:")
	print("Registered listeners:")
	PrintTable(data_listeners)
	print("Meta data table:")
	PrintTable(data_store_metadata)
	print("Data store table:")
	PrintTable(data_store)
end

---
-- This will go through the whole meta data table.
-- For each metadata entry it will call the update listeners.
-- @note This may lead to some listeners being called multiple times, when an entry changes that is in a deeper path. It will be called for each metadata object that is below its registered path.a
--
-- @internal
local function CallCallbacksOnTree(oldData, curPath)
	curPath = not istable(curPath) and { curPath } or curPath or {}
	local curNode = table.GetWithPath(data_store_metadata, curPath)

	-- Go through all keys that the current node has
	for key in pairs(curNode) do
		local nextNode = curNode[key]
		local nextPath = table.Copy(curPath)
		nextPath[#nextPath + 1] = key

		if nextNode.type then
			-- The node is a leaf node -> is a node with meta data
			local oldval = table.GetWithPath(oldData, nextPath)
			local newval = TTT2NET:Get(nextPath)

			-- Call the listeners for this change
			TTT2NET:CallOnUpdate(nextPath, oldval, newval)
		else
			-- Descend a level deeper
			CallCallbacksOnTree(oldData, nextPath)
		end
	end
end

---
-- This is the callback that is executed when a full state update message was received from the server.
-- This will replace the meta data table and the data table. This will then attempt to call possible
-- listeners for each path.
--
-- @param table result This is the table that was received from the stream message
-- @internal
local function ReceiveFullStateUpdate(result)
	-- Temporarily save the old tables, to use let the update callbacks know of the previous value
	local oldData = data_store
	local oldMetaData = data_store_metadata

	-- Replace tables with the result
	data_store_metadata = result.meta
	data_store = result.data

	-- Call all callback functions for all paths
	CallCallbacksOnTree(oldData, oldMetaData)
end
net.ReceiveStream(TTT2NET.NET_STREAM_FULL_STATE_UPDATE, ReceiveFullStateUpdate)

---
-- This is the callback that is executed when a meta data update message was received from the server.
-- This will set the meta data entry and will also set the current data table entry to "nil".
-- Also this will trigger all registered listeners, as the data was reset.
--
-- @internal
local function ReceiveMetaDataUpdate()
	local path = TTT2NET:NetReadPath()
	local metadata = TTT2NET:NetReadMetaData()

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

---
-- This is the callback that is executed when a data update message was received from the server.
-- This will set the data on the data table and will also call all registered listeners for the
-- path.
--
-- @internal
local function ReceiveDataUpdate()
	local path = TTT2NET:NetReadPath()

	-- Get the metadata for the path, this will also error if there is no metadata entry for the path
	local metadata = table.GetWithPath(data_store_metadata, path)

	-- Read the new value based on the metadata entry
	local newval = TTT2NET:NetReadData(metadata)

	-- Save the old value as we need to tell the update listeners about it
	local oldval = TTT2NET:Get(path)

	-- Save the new data
	table.SetWithPath(data_store, path, newval)

	-- Call the update listeners
	TTT2NET:CallOnUpdate(path, oldval, newval)
end
net.Receive(TTT2NET.NETMSG_DATA_UPDATE, ReceiveDataUpdate)

---
-- This will call all registered listeners for a specific path.
-- The function will exit if oldval and newval are the same.
--
-- @param any|table path The path that this update was executed on
-- @param any oldval The old value, before the update
-- @param any newval The new value, after the update
function TTT2NET:CallOnUpdate(path, oldval, newval)
	-- Skip if the value did not change
	if oldval == newval then return end

	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	local currentPath = table.Copy(path)
	local reversePath = {}

	-- Traverse the path tree up from the bottom and call all their listeners
	for y = 1, #path do
		-- Add the special key for the "callbacks" to the path
		currentPath[#currentPath + 1] = "__callbacks"

		-- Get all registered callbacks
		local callbacks = table.GetWithPath(data_listeners, currentPath) or {}

		-- Call all registered callbacks for the current path
		for i = 1, #callbacks do
			callbacks[i](oldval, newval, reversePath)
		end

		-- Remove the "callbacks" path entry
		currentPath[#currentPath] = nil

		-- Remove the last path element and save in reversePath to let the parent callbacks know which value has changed
		table.insert(reversePath, 1, currentPath[#currentPath])
		currentPath[#currentPath] = nil
	end
end

---
-- Request a full state update from the server.
function TTT2NET:RequestFullStateUpdate()
	net.Start(TTT2NET.NETMSG_REQUEST_FULL_STATE_UPDATE)
	net.SendToServer()
end

---
-- Reads a path table from the current network message.
--
-- @return table The path table
function TTT2NET:NetReadPath()
	local result = net.ReadString()

	return spon.decode(result)
end

---
-- Reads a meta data table from the current network message.
--
-- @return table The metadata table
function TTT2NET:NetReadMetaData()
	-- If the null flag is set, then return null
	if net.ReadBool() then
		return
	end

	local metadata = {}
	metadata.type = net.ReadString()

	-- The int type has some extra information
	if metadata.type == "int" then
		metadata.bits = net.ReadUInt(6)
		metadata.unsigned = net.ReadBool()
	end

	return metadata
end

---
-- This will read the data from the current network message
-- efficiently based on the metadata parameter.
--
-- @param table metadata The meta data table for the data that is expected
-- @return any The data that was read
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

	-- Add the special callback key to the path
	path[#path + 1] = "__callbacks"

	-- Get the registered callbacks table for the given path
	local registeredCallbacks = table.GetWithPath(data_listeners, path) or {}

	-- Check if this function is not already registered, to avoid duplicates
	if table.HasValue(registeredCallbacks, func) then return end

	-- Add the function to the callback table
	registeredCallbacks[#registeredCallbacks + 1] = func

	-- Set the callback table again
	table.SetWithPath(data_listeners, path, registeredCallbacks)
end

---
-- This will register a callback for updates to a global data entry.
--
-- @param any|table path The path to register the callback on
-- @param function func The callback function that should be executed
function TTT2NET:OnUpdateGlobal(path, func)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table
	table.insert(path, 1, "global")

	self:OnUpdate(path, func)
end

---
-- This will register a callback for updates to a player specific data entry.
--
-- @param any|table path The path to register the callback on
-- @param Entity ply The player that this data entry is from
-- @param function func The callback function that should be executed
function TTT2NET:OnUpdateOnPlayer(path, ply, func)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table with the specific player
	table.insert(path, 1, "players")
	table.insert(path, 2, ply:EntIndex())

	self:OnUpdate(path, func)
end
