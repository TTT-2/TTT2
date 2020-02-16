---
-- This file contains all networking functions, to sync and manage the information between server and clients
-- The system is intended for syncing data from the server to the client only.
-- So a client will only be able to read / get data and will receive updates from the server.
--
-- <h2>Overview:<h2>
-- The system has two types of predefined storages:
--  - data on specific players (like NWVars)
--  - global data known to every client (like roundtime or settings etc)
--
-- And for each path, regardless if it is data on a player or global data, the server can override the default value for any
-- given path per client. So that for example the server can tell client X about data on all players (eg their roles) and send other data
-- for the same players to another client Y (eg. to let him know of his traitor team members). While doing that, the server still knows what each client
-- currently knows and can adjust to that.
--
-- @module TTT2NET
-- @author saibotk

-- Only send to clients, that already requested a full state update,
-- which indirectly shows that they are ready to receive and are not
-- loading the gamemode anymore.
local initialized_clients = {}

-- The meta data table to store information about the type of the data (used to correctly send the data)
local data_store_metadata = {}

-- The general value storage
local data_store = {}

-- Register network message names
util.AddNetworkString(TTT2NET.NETMSG_META_UPDATE)
util.AddNetworkString(TTT2NET.NETMSG_DATA_UPDATE)
util.AddNetworkString(TTT2NET.NETMSG_REQUEST_FULL_STATE_UPDATE)

---
-- Checks if two meta data tables are equal.
--
-- @param table meta1 first meta table
-- @param table meta2 second meta table
-- @return bool Returns true if they are equal false if not
function TTT2NET:NetworkMetaDataTableEqual(meta1, meta2)
	if meta1 == nil and meta2 == nil then
		return true
	end

	return meta1 and meta2 and meta1.type == meta2.type and meta1.bits == meta2.bits and meta1.unsigned == meta2.unsigned
end

---
-- This will set the meta data for a path.
-- The meta data is used to describe the type of the table entry (the data).
--
-- A valid metadata table should provide at least the type field, which is a string with one of the
-- following values: ["string", "int", "bool", "float"]. For the "int" type there is also the "unsigned"
-- field, which can be set to true. There is also the "bits" field, which can be used to synchronize data more efficiently
-- as this will only impact the transport/synchronization of the data and describe how many bits are needed to sync this number.
-- This can also be used to remove an entry, by passing nil as the metadata.
-- This will also automatically synchronize the new metadata information to the clients (only if it differs from before).
-- @note Setting the metadata will also set the data to nil on its path (only if it is a different meta data object than before).
--
-- @param any|table path The path that this meta data is associated with
-- @param table|nil metadata The metadata table
function TTT2NET:SetMetaData(path, metadata)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Retrieve the stored metadata
	local storedMetaData = table.GetWithPath(data_store_metadata, path)

	-- If the metadata is already stored, do nothing
	if self:NetworkMetaDataTableEqual(storedMetaData, metadata) then return end

	-- Insert data to metadata table
	table.SetWithPath(data_store_metadata, path, metadata)
	-- Set value of the data field to nil
	table.SetWithPath(data_store, path, nil)

	-- Sync new meta information to all clients that are already connected and received a full state!
	self:SendMetaDataUpdate(path)
end

---
-- This will set the metadata for a specific path and prepend the path with the "global" keyword.
-- For more information look at {@TTT2NET:SetMetaData}.
--
-- @param any|table path The path this meta data is associated with (already includes the "global" keyword)
-- @param table|nil metadata The metadata table
function TTT2NET:SetMetaDataGlobal(path, metadata)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table
	table.insert(path, 1, "global")

	self:SetMetaData(path, metadata)
end

---
-- This will set the metadata for a specific path on a player and prepend needed keywords.
-- For more information look at {@TTT2NET:SetMetaData}.
--
-- @param any|table path The path this meta data is associated with (already includes the needed keywords)
-- @param table|nil metadata The metadata table
function TTT2NET:SetMetaDataOnPlayer(path, metadata, ply)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table with the specific player
	table.insert(path, 1, "players")
	table.insert(path, 2, ply:EntIndex())

	self:SetMetaData(path, metadata)
end

---
-- This is used to set a value in the data table for a specific path, it can take an additional meta data object,
-- which represents the type of the data to be set. This will automatically create the metadata entry if it does not
-- exist and is provided as a parameter. This can only be left empty, when the path already has a valid metadata entry.
-- This will automatically synchronize the new data to the clients.
-- When the additional client parameter is set, the data will be saved as an override for that specific client/entity.
--
-- @param any|table path The path to set the data for
-- @param table|nil meta The metadata for the path
-- @param any value The value to save
-- @param Entity|nil client The client/entity to set this value for (overrides the default value)
function TTT2NET:Set(path, meta, value, client)
	local clientId = client and client:EntIndex() or nil

	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	local metadata = meta or table.GetWithPath(data_store_metadata, path)

	assert(metadata, "[TTT2NET] Set() called but no metadata entry or metadata parameter found!")

	-- Set the meta data, this will only send / update if the meta data has changed
	self:SetMetaData(path, metadata)

	-- Add the identifier for the default value for all clients or the clientId if specified
	path[#path + 1] = clientId or "default"

	-- Skip if the value is already present or nil
	if table.GetWithPath(data_store, path) == value then return end

	-- Save the value
	table.SetWithPath(data_store, path, value)

	-- Remove last key eg. "default" or the player id, as this does not belong to the base path
	path[#path] = nil

	-- Sync the new value
	self:SendDataUpdate(path, client)
end

---
-- This will be used to clear out all client specific overrides for a path, so that only the
-- default value is set.
-- This will also automatically sync the new value to the clients that previously had an override value.
--
-- @param table path The path to clear out all overrides on.
function TTT2NET:RemoveOverrides(path)
	-- Convert single key to table
	if not istable(path) then
		path = { path }
	end

	local currentDataTable = data_store

	if currentDataTable == nil then return end

	-- Traverse the path in the data_store table.
	-- This will be done until the second last table is reached, so we still have a reference to the parent table.
	for i = 1, (#path - 1) do
		currentDataTable = currentDataTable[path[i]]

		if currentDataTable == nil then return end
	end

	local lastKey = path[#path]

	-- If the table does not have the last key, then exit
	if currentDataTable[lastKey] == nil then return end

	local defaultValue = currentDataTable[lastKey].default

	-- Collect all players that had an override value set
	local playerIds = table.GetKeys(currentDataTable[lastKey])
	local receivers = {}

	-- Check all keys if they are a valid EntIndex and resolve them to the player instance
	for i = 1, #playerIds do
		local ply = Entity(playerIds[i])
		-- ply will be nil if no entity is found

		if IsEntity(ply) and ply:IsPlayer() then
			receivers[#receivers + 1] = ply
		end
	end

	-- Replace the existing table with a new table that just contains the default value
	currentDataTable[lastKey] = { default = defaultValue }

	-- Send update to all players that previously had an override
	self:SendDataUpdate(path, receivers)
end

---
-- This will be used to clear out all client specific overrides for a path, so that only the
-- default value is set. This will also prepend the "global" keyword to the path, otherwise
-- it will do the same as {@TTT2NET:RemoveOverrides}.
--
-- @param table path The path to clear out all overrides on.
function TTT2NET:RemoveOverridesGlobal(path)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table
	table.insert(path, 1, "global")

	self:RemoveOverrides(path)
end

---
-- This will be used to clear out all client specific overrides for a path on a player/entity object, so that only the
-- default value is set. This will also prepend the needed keywords to the path, otherwise
-- it will do the same as {@TTT2NET:RemoveOverrides}.
--
-- @param table path The path to clear out all overrides on.
function TTT2NET:RemoveOverridesOnPlayer(path, ply)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table with the specific player
	table.insert(path, 1, "players")
	table.insert(path, 2, ply:EntIndex())

	self:RemoveOverrides(path)
end

---
-- Returns the currently saved value for a given path.
-- When no client parameter is given, this will return the default value, otherwise
-- it will return the override value or nil, when no override is found.
--
-- @param any|table path The path to get the value from
-- @param Entity|nil client The client/entity to get the value for
-- @return any|nil The value found at the given path
function TTT2NET:Get(path, client)
	local clientId = client and client:EntIndex() or nil

	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the identifier for the default value for all clients or the clientId if specified
	path[#path + 1] = clientId or "default"

	return table.GetWithPath(data_store, path)
end

---
-- Returns the currently saved value for a given path.
-- When no client parameter is given, this will return the default value, otherwise
-- it will first look for an override value and only return the default value, when no override is found.
--
-- @param any|table path The path to get the value from
-- @param Entity|nil client The client/entity to get the value for
-- @return any|nil The value that a client knows
function TTT2NET:GetWithOverride(path, client)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	local clientId = client:EntIndex()

	local overridePath = table.Copy(path)
	overridePath[#overridePath + 1] = clientId

	local defaultPath = table.Copy(path)
	defaultPath[#defaultPath + 1] = "default"

	-- Get the overwrite value if available
	local overrideValue = table.GetWithPath(data_store, overridePath)
	if overrideValue ~= nil then
		return overrideValue
	else
		return table.GetWithPath(data_store, defaultPath)
	end
end

---
-- Returns the currently saved value for a given path.
-- This will do the same as {@TTT2NET:Get} but will first prepend the "global" keyword to the path.
--
-- @param any|table path The path to get the value from
-- @param Entity|nil client The client/entity to get the value for
-- @return any|nil The value for the given path
function TTT2NET:GetGlobal(path, client)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table
	table.insert(path, 1, "global")

	return self:Get(path, client)
end

---
-- This is used to set a value in the data table for a specific path and works the same as {@TTT2NET:Set},
-- but it will prepend the "global" keyword to the path.
--
-- @param any|table path The path to set the data for
-- @param table|nil meta The metadata for the path
-- @param any value The value to save
-- @param Entity|nil client The client/entity to set this value for (overrides the default value)
function TTT2NET:SetGlobal(path, meta, value, client)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table
	table.insert(path, 1, "global")

	self:Set(path, meta, value, client)
end

---
-- This is used to set a value in the data table for a specific path on a specific player/entity and works the same as {@TTT2NET:Set},
-- but it will prepend the needed keywords to the path.
--
-- @param any|table path The path to set the data for
-- @param table|nil meta The metadata for the path
-- @param any value The value to save
-- @param Entity ply The player/entity that this data is associated to
-- @param Entity|nil client The client/entity to set this value for (as an override for the default value)
function TTT2NET:SetOnPlayer(path, meta, value, ply, client)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table with the specific player
	table.insert(path, 1, "players")
	table.insert(path, 2, ply:EntIndex())

	self:Set(path, meta, value, client)
end

---
-- Returns the currently saved value for a given path on a specific player.
-- This will do the same as {@TTT2NET:Get} but will first prepend the needed keywords to the path.
--
-- @param any|table path The path to get the value from
-- @param Entity ply The client/entity to save the value on
-- @param Entity|nil client The client/entity to get the value for
-- @return any|nil The value for the given path
function TTT2NET:GetOnPlayer(path, ply, client)
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
	print("Initialized clients:")
	PrintTable(initialized_clients)
	print("Meta data table:")
	PrintTable(data_store_metadata)
	print("Data store table:")
	PrintTable(data_store)
end

---
-- This will send a metadata update for the specified path to all
-- initialized clients.
--
-- @param any|table path The path to send a metadata update for
function TTT2NET:SendMetaDataUpdate(path)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Check for a metadata entry
	local metadata = table.GetWithPath(data_store_metadata, path)

	-- Write meta data
	net.Start(TTT2NET.NETMSG_META_UPDATE)

	self:NetWritePath(path)
	self:NetWriteMetaData(metadata)

	net.Send(initialized_clients)
end

---
-- This is used to clear out all overrides that a specific client has, based on the given metadata tree.
-- It will traverse the whole data tree and remove all override entries for the client.
-- This will work recursively!
-- The curTable param is mapped directly to the data storage layout, so when you only want to clear overrides on a subtree, you have to provide a
-- path to that starting point, to allow the function to work correctly. Otherwise leave the path empty, when the whole metadata table is given.
--
-- @param Entity client The client/entity to clear all overrides for
-- @param table curTable This is the current metadata table. This should start with the complete metadata table, otherwise the path has to be adjusted, see the description.
-- @param table|nil path The current path to the curTable based on the root of the data table
function TTT2NET:RemoveOverridesForClient(client, curTable, path)
	path = not istable(path) and {path} or path or {}

	-- Visit all keys in the current tree
	for key in pairs(curTable) do
		local nextNode = curTable[key]
		local nextPath = table.Copy(path)
		nextPath[#nextPath + 1] = key

		-- Check if we reached a leaf node (a node with metadata)
		if nextNode.type then
			-- Remove the override from this key
			self:Set(nextPath, nil, nil, client)
		else
			-- Descend a level deeper
			self:RemoveOverridesForClient(client, curTable[key], nextPath)
		end
	end
end

---
-- This will reset all known data for a client and remove all entries related to this client.
--
-- @param Entity client The client to remove
function TTT2NET:ResetClient(client)
	assert(IsEntity(client), "[TTT2NET] ResetClient() client is not a valid Entity!")

	table.RemoveByValue(initialized_clients, client)

	-- Clear up the player specific data table
	self:SetMetaDataOnPlayer(nil, nil, client)

	-- Clear up all left over overrides
	self:RemoveOverridesForClient(client, data_store_metadata)
end

---
-- This will send a data update to either the specified client/list of clients or all known initialized clients.
--
-- @param any|table path The path to send the update for
-- @param Player|table|nil client The client/list of clients or nil to send this to all knwon clients
function TTT2NET:SendDataUpdate(path, client)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Check for a valid metadata entry
	local metadata = table.GetWithPath(data_store_metadata, path)

	assert(metadata, "[TTT2NET] SendDataUpdate(): Metadata table is not initialized for this path.")

	-- Only send to the client (or table of clients) that was specified or the already initialized clients
	-- This will check if client is a table or a single client and format it to a table and otherwise use
	-- the initialized_clients list.
	local receivers = istable(client) and client or client and { client } or initialized_clients

	-- For each receiver send the data
	for i = 1, #receivers do
		local receiver = receivers[i]
		local value = self:GetWithOverride(path, receiver)

		net.Start(TTT2NET.NETMSG_DATA_UPDATE)

		self:NetWritePath(path)
		self:NetWriteData(metadata, value)

		net.Send(receiver)
	end
end

---
-- This will return the data table as the given client would receive it.
-- This will build up a data tree as it would be found on the client, with the overrides for the specific client.
-- This will work recursively!
-- @note The curTable param is mapped directly to the data storage layout, so when you only want to get data for a subtree, you have to provide a
-- path to that starting point, to allow the function to work correctly. Otherwise leave the path empty, when the whole metadata table is given.
--
-- @param Entity client The client/entity to get the data for
-- @param table curTable This is the current metadata table. This should start with the complete metadata table, otherwise the path has to be adjusted, see the description.
-- @param table|nil path The current path to the curTable based on the root of the data table
function TTT2NET:DataTableWithOverrides(client, curTable, path)
	path = not istable(path) and {path} or path or {}
	local newTable = table.Copy(curTable)

	-- Visit all keys in the current tree
	for key in pairs(curTable) do
		local nextNode = curTable[key]
		local nextPath = table.Copy(path)
		nextPath[#nextPath + 1] = key

		-- Check if we reached a leaf node (a node with metadata)
		if nextNode.type then
			-- Replace the metadata with the data
			newTable[key] = self:GetWithOverride(nextPath, client)
		else
			-- Descend a level deeper
			newTable[key] = self:DataTableWithOverrides(client, curTable[key], nextPath)
		end
	end

	return newTable
end

---
-- Send a full state update to the client/list of clients or all known clients if not specified.
-- This will send the metadata table and the specific data table (with respect to the overrides) to the clients.
-- @note This will also set all reveivers as initialized.
--
-- @param Player|table|nil client The client/list of clients or nil for all known clients, to send the update to
function TTT2NET:SendFullStateUpdate(client)
	-- Wrap the given receivers to a table
	local receivers = not istable(client) and { client } or initialized_clients

	-- For each receiver create the custom data table with respect to the override values and send it
	for i = 1, #receivers do
		local receiver = receivers[i]
		local data = {
			meta = data_store_metadata,
			data = self:DataTableWithOverrides(receiver, data_store_metadata)
		}

		net.SendStream(TTT2NET.NET_STREAM_FULL_STATE_UPDATE, data, receiver)

		-- Set the client as initialized (so it will receive future data updates)
		if not table.HasValue(initialized_clients, receiver) then
			initialized_clients[#initialized_clients + 1] = receiver
		end
	end
end

---
-- This is the callback for clients requesting a full state update.
-- It will just send a full state update to the client that requested it.
--
-- @param number len The length of the network message
-- @param Player client the client that made the request
-- @internal
local function ClientRequestFullStateUpdate(len, client)
	TTT2NET:SendFullStateUpdate(client)
end
net.Receive(TTT2NET.NETMSG_REQUEST_FULL_STATE_UPDATE, ClientRequestFullStateUpdate)

---
-- This is used to write a path table to the current network message.
--
-- @param table path The path table to send
function TTT2NET:NetWritePath(path)
	net.WriteString(pon.encode(path))
end

---
-- This is used to write a metadata table to the current network message.
--
-- @param table metadata The metadata to send
function TTT2NET:NetWriteMetaData(metadata)
	local isMetadataNil = metadata == nil

	net.WriteBool(isMetadataNil)

	if isMetadataNil then return end

	net.WriteString(metadata.type)

	if metadata.type == "int" then
		net.WriteUInt(metadata.bits, 6) -- 6 bits, so we can safely send the maximum bit count of 32 bits
		net.WriteBool(metadata.unsigned)
	end
end

---
-- This is used to write a value to the current network message,
-- based on the given metadata.
-- @note Nil values are preserved and can be "sent".
--
-- @param table metadata The metadata for the given value
-- @param any|nil val The value to send, can also be nil
function TTT2NET:NetWriteData(metadata, val)
	-- Check if the value is nil, to also allow setting a value to nil
	local isValNil = val == nil

	net.WriteBool(isValNil)

	if isValNil then return end

	-- Decide on how to send the data, or fallback to string
	if metadata.type == "int" then
		if metadata.unsigned then
			net.WriteUInt(val, metadata.bits or 32)
		else
			net.WriteInt(val, metadata.bits or 32)
		end
	elseif metadata.type == "bool" then
		net.WriteBool(val)
	elseif metadata.type == "float" then
		net.WriteFloat(val)
	else
		net.WriteString(val)
	end
end

---
-- Player extensions
-- Some simple functions on the player class, to simplify the use of this system.
-- They will automatically set the metadata.

local plymeta = assert(FindMetaTable("Player"), "[TTT2NET] FAILED TO FIND PLAYER TABLE")

---
-- Sets a bool value at the given path on the player.
--
-- @param any|table path The path to set the value for
-- @param bool|nil value The value to set
function plymeta:TTT2NETSetBool(path, value)
	TTT2NET:SetOnPlayer(path, { type = "bool" }, value, self)
end

---
-- Sets an int value at the given path on the player.
--
-- @param any|table path The path to set the value for
-- @param int|nil value The value to set
-- @param int|nil bits The bits that this int needs to be stored (optional, otherwise a default of 32 is used)
function plymeta:TTT2NETSetInt(path, value, bits)
	TTT2NET:SetOnPlayer(path, {
		type = "int",
		bits = bits
	}, value, self)
end

---
-- Sets an unsigned int value at the given path on the player.
--
-- @param any|table path The path to set the value for
-- @param uint|nil value The value to set
-- @param int|nil bits The bits that this int needs to be stored (optional, otherwise a default of 32 is used)
function plymeta:TTT2NETSetUInt(path, value, bits)
	TTT2NET:SetOnPlayer(path, {
		type = "int",
		unsigned = true,
		bits = bits
	}, value, self)
end

---
-- Sets a float value at the given path on the player.
--
-- @param any|table path The path to set the value for
-- @param float|nil value The value to set
function plymeta:TTT2NETSetFloat(path, value)
	TTT2NET:SetOnPlayer(path, { type = "float" }, value, self)
end

---
-- Sets a string value at the given path on the player.
--
-- @param any|table path The path to set the value for
-- @param string|nil value The value to set
function plymeta:TTT2NETSetString(path, value)
	TTT2NET:SetOnPlayer(path, { type = "string" }, value, self)
end
