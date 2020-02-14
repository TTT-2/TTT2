---
-- This file contains all networking functions, to sync and manage the information between server and clients
-- @author saibotk

-- Only send to clients, that already requested a full state update,
-- which indirectly shows that they are ready to receive and are not
-- loading the gamemode anymore.
local initialized_clients = {}

-- Global data tables
-- The meta data table to store information about the type of the data (used to correctly send the data)
local data_store_metadata = {}

-- The general value storage
local data_store = {}

-- Register network message names
util.AddNetworkString(TTT2NET.NETMSG_META_UPDATE)
util.AddNetworkString(TTT2NET.NETMSG_DATA_UPDATE)
util.AddNetworkString(TTT2NET.NETMSG_REQUEST_FULL_STATE_UPDATE)

---
-- Checks if two networkdata meta tables are equal.
--
-- @param table meta1 first meta table
-- @param table meta2 second meta table
function TTT2NET:NetworkMetaDataTableEqual(meta1, meta2)
	if meta1 == nil and meta2 == nil then
		return true
	end

	return meta1 and meta2 and meta1.type == meta2.type and meta1.bits == meta2.bits and meta1.unsigned == meta2.unsigned
end

---
-- This will set the network meta data for a path.
-- The network meta data is used to describe the type of the table entry (the data).
-- A valid metadata table should provide at least the type field, which is a string with one of the
-- following values: ["string", "int", "bool", "float"]
--
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

function TTT2NET:SetMetaDataGlobal(path, metadata)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table
	table.insert(path, 1, "global")

	self:SetMetaData(path, metadata)
end

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
-- This is used to set a value in the data table, it can take an additional meta data object,
-- which represents the type of the data to be set.
--
-- @Note This meta data information is only used to to
function TTT2NET:Set(path, meta, value, client)
	local clientId = client and client:EntIndex() or nil

	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	local metadata = meta or table.GetWithPath(data_store_metadata, path)
	assert(metadata, "[TTT2NET] Set function called but no metadata entry or metadata parameter found!")

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
-- This will be used to clear out all client specific overrides for a path.
--
-- @param table path the path
function TTT2NET:RemoveOverrides(path)
	assert(path, "RemoveOverrides(..) missing path parameter.")

	-- Convert single key to table
	if not istable(path) then
		path = { path }
	end

	local currentDataTable = data_store

	-- Traverse the path in the data_store table.
	-- This will be done until the second last table is reached, so we still have a reference to the parent table.
	for i = 1, (#path - 1) do
		if currentDataTable == nil then return end
		currentDataTable = currentDataTable[path[i]]
	end

	local lastKey = path[#path]

	-- if the table does not even exist, then exit
	if currentDataTable == nil or currentDataTable[lastKey] == nil then return end

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

function TTT2NET:RemoveOverridesGlobal(path)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table
	table.insert(path, 1, "global")

	self:RemoveOverrides(path)
end

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

function TTT2NET:GetGlobal(path, client)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table
	table.insert(path, 1, "global")

	return self:Get(path, client)
end

function TTT2NET:SetGlobal(path, meta, value, client)
	-- Convert path with single key to table
	if not istable(path) then
		path = { path }
	end

	-- Add the prefix for the correct table
	table.insert(path, 1, "global")

	self:Set(path, meta, value, client)
end

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

local function NWVarSyncProxyCallback(ent, name, oldval, newval, path, meta)
	TTT2NET:SetOnPlayer(path or name, meta, newval, ent)
end

-- TODO
function TTT2NET:SyncWithNWVar(meta, nwent, nwkey, path)
	assert(IsEntity(nwent), "SyncWithNWVar() received an invalid entity!")

	-- React to changes to nwvars
	nwent:SetNWVarProxy(nwkey, function (ent, name, oldval, newval)
		NWVarSyncProxyCallback(ent, name, oldval, newval, path, meta)
	end)

	-- React to changes in the TTT2NET data table
	-- TODO
end

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

function TTT2NET:RemoveOverride(client, curTable, path)
	path = not istable(path) and {path} or path or {}

	for key in pairs(curTable) do
		local leafNode = curTable[key]
		local nextpath = table.Copy(path)
		nextpath[#nextpath + 1] = key
		if leafNode.type then
			-- remove the override from this key
			self:Set(nextpath, nil, nil, client)
		else
			-- descend a level deeper
			self:RemoveOverride(client, curTable[key], nextpath)
		end
	end
end

function TTT2NET:ResetClient(client)
	assert(IsEntity(client), "ResetClient() client is not a valid Entity!")

	table.RemoveByValue(initialized_clients, client)

	-- Clear up the player specific data table
	self:SetMetaDataOnPlayer(nil, nil, client)

	-- Clear up all left over overrides
	self:RemoveOverride(client, data_store_metadata)
end

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

-- TODO efficiency
function TTT2NET:DataTableWithOverrides(client, curTable, path)
	path = not istable(path) and {path} or path or {}
	local newTable = table.Copy(curTable)

	for key in pairs(curTable) do
		local leafNode = curTable[key]
		local nextpath = table.Copy(path)
		nextpath[#nextpath + 1] = key
		if leafNode.type then
			-- replace the metadata with the data
			newTable[key] = self:GetWithOverride(nextpath, client)
		else
			-- descend a level deeper
			newTable[key] = self:DataTableWithOverrides(client, curTable[key], nextpath)
		end
	end

	return newTable
end

-- TODO add ratelimit?
function TTT2NET:SendFullStateUpdate(client)
	print("[TTT2NET] Sending full state update...")

	if IsPlayer(client) and not table.HasValue(initialized_clients, client) then
		initialized_clients[#initialized_clients + 1] = client
	end

	local receivers = IsPlayer(client) and { client } or client ~= nil and client or initialized_clients

	for i = 1, #receivers do
		local data = {
			meta = data_store_metadata,
			data = self:DataTableWithOverrides(receivers[i], data_store_metadata)
		}

		net.SendStream(TTT2NET.NET_STREAM_FULL_STATE_UPDATE, data, receivers[i])
	end


end

local function ClientRequestFullStateUpdate(len, client)
	TTT2NET:SendFullStateUpdate(client)
end

net.Receive(TTT2NET.NETMSG_REQUEST_FULL_STATE_UPDATE, ClientRequestFullStateUpdate)

function TTT2NET:NetWritePath(path)
	net.WriteString(pon.encode(path))
end

function TTT2NET:NetWriteMetaData(metadata)
	net.WriteBool(metadata == nil)
	if metadata == nil then
		return
	end

	net.WriteString(metadata.type)
	if metadata.type == "int" then
		net.WriteUInt(metadata.bits, 6) -- max 32 bits
		net.WriteBool(metadata.unsigned)
	end
end

function TTT2NET:NetWriteData(metadata, val)
	-- Check if the value is nil, to also allow setting a value to nil
	net.WriteBool(val == nil)
	if val == nil then
		return
	end

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

-- Player extensions
local plymeta = assert(FindMetaTable("Player"), "FAILED TO FIND PLAYER TABLE")

function plymeta:TTT2NETGetBool(path, fallback)
	return TTT2NET:GetOnPlayer(path, self) or fallback
end

function plymeta:TTT2NETGetInt(path, fallback)
	return tonumber(TTT2NET:GetOnPlayer(path, self) or fallback)
end

function plymeta:TTT2NETGetUInt(path, fallback)
	return tonumber(TTT2NET:GetOnPlayer(path, self) or fallback)
end

function plymeta:TTT2NETGetFloat(path, fallback)
	return tonumber(TTT2NET:GetOnPlayer(path, self) or fallback)
end

function plymeta:TTT2NETGetString(path, fallback)
	return tostring(TTT2NET:GetOnPlayer(path, self) or fallback)
end

function plymeta:TTT2NETSetBool(path, value)
	TTT2NET:SetOnPlayer(path, { type = "bool" }, value, self)
end

function plymeta:TTT2NETSetInt(path, value)
	TTT2NET:SetOnPlayer(path, { type = "int" }, value, self)
end

function plymeta:TTT2NETSetUInt(path, value)
	TTT2NET:SetOnPlayer(path, { type = "int", unsigned = true }, value, self)
end

function plymeta:TTT2NETSetFloat(path, value)
	TTT2NET:SetOnPlayer(path, { type = "float" }, value, self)
end

function plymeta:TTT2NETSetString(path, value)
	TTT2NET:SetOnPlayer(path, { type = "string" }, value, self)
end
