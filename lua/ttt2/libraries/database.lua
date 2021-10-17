---
-- A shared database to handle synchronization of data between client and server
-- as well as handling the storage in an sql database
-- @author ZenBre4ker
-- @module database

database = database or {}

if SERVER then
	util.AddNetworkString("TTT2SynchronizeDatabase")
end

local messageIdentifier = -1
local maxBytesPerMessage = 32 * 1000 -- Can be up to 65.533KB see: https://wiki.facepunch.com/gmod/net.Start
local uIntBits = 8 -- we can synchronize up to 2 ^ uIntBits - 1 different sqlTables
local maxUInt = 2 ^ uIntBits

local databaseCount = 0

local registeredDatabases = {}
local nameToIndex = {}

local identifierStrings = {
	Register = "Register",
	GetValue = "GetValue"
}

local dataStore = {}

local sendDataFunctions = {}

local receiveDataFunctions = {}

local sendRequestsNextUpdate = false
local requestCacheSize = 0
local requestCache = {}
local functionCache = {}

-- Shared functions Part 1

-- Client data and functions Part 1
if CLIENT then
	sendDataFunctions = {
		-- data contains the syncCacheIndex here
		GetValue = function(data)
				local request = requestCache[data]

				net.WriteUInt(request.identifier, uIntBits)
				net.WriteUInt(request.index, uIntBits)

				if request.index == 0 then
					net.WriteString(request.accessName)
				end

				net.WriteString(request.name)
				net.WriteString(request.key)
			end
	}

	receiveDataFunctions = {
		Register = function()
				local index = net.ReadUInt(uIntBits)
				local accessName = net.ReadString()
				local savingKeys = net.ReadTable()
				local additionalData = net.ReadTable()

				nameToIndex[accessName] = index
				registeredDatabases[index] = {
					name = accessName,
					savingKeys = savingKeys,
					additionalData = additionalData,
					storedData = {}
				}
			end,
		-- data contains identifier, isSuccess and value here
		GetValue = function(data)
				local identifier = net.ReadUInt(uIntBits)
				local isSuccess = net.ReadBool()

				functionCache[identifier](isSuccess, isSuccess and net.ReadString())
			end
	}
end

-- Server data and functions Part 1
if SERVER then
	sendDataFunctions = {
		-- data is the databaseIndex here
		Register = function(data)
				local databaseInfo = registeredDatabases[data]
				net.WriteUInt(data, uIntBits)
				net.WriteString(databaseInfo.accessName)
				net.WriteTable(databaseInfo.savingKeys)
				net.WriteTable(databaseInfo.additionalData)
			end,
		-- data contains identifier, isSuccess and value here
		GetValue = function(data)
				net.WriteUInt(data.identifier, uIntBits)
				net.WriteBool(data.isSuccess)

				if data.isSuccess then
					net.WriteString(data.value)
				end
			end
	}

	receiveDataFunctions = {
		GetValue = function(ply)
				local data = {
					identifier = net.ReadUInt(uIntBits),
					index = net.ReadUInt(uIntBits)
				}

				if data.index == 0 then
					data.index = nameToIndex[net.ReadString()]
				end

				data.name = net.ReadString()
				data.key = net.ReadString()

				database.ReturnGetValue(data)
			end
	}
end

-- Shared functions Part 2

local function SynchronizeStates(len, ply)
	if len < 1 then return end

	if SERVER and not ply:IsValid() then return end

	local bytesLeft = net.BytesLeft()

	while bytesLeft > 0 do
		local identifier = net.ReadString()
		local readNextValue = net.ReadBool()

		while readNextValue do
			receiveDataFunctions[identifier](SERVER and ply)
			readNextValue = net.ReadBool()
		end

		bytesLeft = net.BytesLeft()
	end
end
net.Receive("TTT2SynchronizeDatabase", SynchronizeStates)

local function SendUpdatesNow()
	sendRequestsNextUpdate = false
	local stopSending = false
	local deleteIdentifiers = {}

	if table.IsEmpty(dataStore) then return end

	net.Start("TTT2SynchronizeDatabase")

	for identifier, indexedData in pairs(dataStore) do
		net.WriteString(identifier)
		net.WriteBool(#indexedData > 0)

		for i = #indexedData, 1, -1 do
			sendDataFunctions[identifier](indexedData[i])
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

	if SERVER then
		net.Broadcast()
	elseif CLIENT then
		net.SendToServer()
	end

	for identifier in pairs(deleteIdentifiers) do
		dataStore[identifier] = nil
	end

	if stopSending then
		sendRequestsNextUpdate = true
		timer.Simple(0, SendUpdatesNow())
	end
end

local function SendUpdateNextTick(identifier, data)
	if not sendRequestsNextUpdate then
		sendRequestsNextUpdate = true
		timer.Simple(0, SendUpdatesNow())
	end

	-- Store data
	local tempStore = dataStore[identifier] or {}
	tempStore[#tempStore + 1] = data

	dataStore[identifier] = tempStore
end

-- Client data and functions Part 2
if CLIENT then
	---
	-- Get the stored key value of the given database if it exists on the server or was already cached
	-- @param string accessName the chosen networkable name of the sql table
	-- @param string name the name or primaryKey of the item inside of the sql table
	-- @param function OnReceiveFunc(databaseExists, value) The function that gets called with the results if the database exists
	-- @realm client
	function database.GetValue(accessName, name, key, OnReceiveFunc)
		local index = nameToIndex[accessName]
		local dataTable = index and registeredDatabases[index]

		if dataTable and dataTable.storedData[key] then
			OnReceiveFunc(true, dataTable.storedData[key])

			return
		end

		messageIdentifier = (messageIdentifier + 1) % maxUInt
		functionCache[messageIdentifier] = OnReceiveFunc

		requestCacheSize = requestCacheSize + 1
		requestCache[requestCacheSize] = {
			identifier = messageIdentifier,
			accessName = accessName,
			name = name,
			key = key,
			index = index or 0
		}

		SendUpdateNextTick(identifierStrings.GetValue, requestCacheSize)
	end
end

-- Server data and functions Part 2
if SERVER then
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

	function database.ReturnGetValue(requestData)
		local index = requestData.index
		local data = index and registeredDatabases[index]
		local sqlData

		if data then
			sqlData = data.orm:Find(requestData.name)
		end

		local isSuccess = tobool(sqlData)

		local serverData = {
			identifier = requestData.identifier,
			isSuccess = isSuccess
		}

		isSuccess = isSuccess and istable(data.keys[requestData.key])

		if isSuccess then
			serverData.value = sqlData[requestData.key]
		end

		SendUpdateNextTick(identifierStrings.GetValue, serverData)
	end
end