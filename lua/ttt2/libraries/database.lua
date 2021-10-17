---
-- A shared database to handle synchronization of data between client and server
-- as well as handling the storage in an sql database
-- @author ZenBre4ker
-- @module database

database = database or {}

if SERVER then
	util.AddNetworkString("ttt2_synchronize_database")
end

local maxBytesPerMessage = 32 * 1000 -- Can be up to 65.533KB see: https://wiki.facepunch.com/gmod/net.Start
local uIntBits = 8 -- we can synchronize up to 2 ^ uIntBits - 1 different sqlTables

local databaseCount = 0

local registeredDatabases = {}
local nameToIndex = {}

local identifierStrings = {
	Register = "Register"
}

if CLIENT then
	local receiveStoredDataFunctions = {
		Register = function()
				local index = net.ReadUInt(uIntBits)
				local accessName = net.ReadString()
				local savingKeys = net.ReadTable()
				local additionalData = net.ReadTable()

				nameToIndex[accessName] = index
				registeredDatabases[index] = {
					name = accessName,
					savingKeys = savingKeys,
					additionalData = additionalData
				}
			end
	}

	local function receiveUpdates()
		local bytesLeft = net.BytesLeft()

		while bytesLeft > 0 do
			local identifier = net.ReadString()
			local readNextValue = net.ReadBool()

			while readNextValue do
				receiveStoredDataFunctions[identifier]()
				readNextValue = net.ReadBool()
			end

			bytesLeft = net.BytesLeft()
		end
	end

	net.Receive("ttt2_synchronize_database", receiveUpdates())
end

if not SERVER then return end

local sendUpdatesNextTick = false

local dataStore = {}

local sendStoredDataFunctions = {
	-- data contains the databaseIndex here
	Register = function(data)
			local databaseInfo = registeredDatabases[data]
			net.WriteUInt(data, uIntBits)
			net.WriteString(databaseInfo.accessName)
			net.WriteTable(databaseInfo.savingKeys)
			net.WriteTable(databaseInfo.additionalData)
		end
}

local function SendUpdatesNow()
	sendUpdatesNextTick = false
	local stopSending = false
	local deleteIdentifiers = {}

	if table.IsEmpty(dataStore) then return end

	net.Start("ttt2_synchronize_database")

	for identifier, indexedData in pairs(dataStore) do
		net.WriteString(identifier)
		net.WriteBool(#indexedData > 0)

		for i = #indexedData, 1, -1 do
			sendStoredDataFunctions[identifier](indexedData[i])
			indexedData[i] = nil

			stopSending = net.BytesWritten() >= maxBytesPerMessage

			net.WriteBool( not (stopSending or i == 1))

			if stopSending then break end
		end

		if #indexedData <= 0 then
			deleteIdentifiers[identifier] = true
		end

		if stopSending then break end
	end

	net.Broadcast()

	for identifier in pairs(deleteIdentifiers) do
		dataStore[identifier] = nil
	end

	if stopSending then
		sendUpdatesNextTick = true
		timer.Simple(0, SendUpdatesNow())
	end
end

local function SendUpdateNextTick(identifier, data)
	if not sendUpdatesNextTick then
		sendUpdatesNextTick = true
		timer.Simple(0, SendUpdatesNow())
	end

	-- Store data
	local tempStore = dataStore[identifier] or {}
	tempStore[#tempStore + 1] = data

	dataStore[identifier] = tempStore
end

function database.Register(accessName, databaseName, savingKeys, additionalData)
	if not sql.CreateSqlTable(databaseName, savingKeys) or not isstring(accessName) then
		return false
	end

	if nameToIndex[accessName] then
		return true
	end

	databaseCount = databaseCount + 1

	registeredDatabases[databaseCount] = {
		name = accessName,
		orm = orm.Make(databaseName),
		keys = savingKeys,
		data = additionalData
	}

	nameToIndex[accessName] = databaseCount

	SendUpdateNextTick(identifierStrings.Register, databaseCount)

	return true
end


