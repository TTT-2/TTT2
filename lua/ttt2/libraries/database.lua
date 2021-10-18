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

-- Identifier strings to determine which player gets the information
local sendToPly = {
	all = "all",
	registered = "registered",
	server = "server"
}

-- Stores the data and the players it is send to
local dataStore = {}

local sendDataFunctions = {}

local receiveDataFunctions = {}

local sendRequestsNextUpdate = false
local requestCacheSize = 0
local requestCache = {}
local functionCache = {}

local playersCache = {}
local registeredPlayersTable = {}

-- Saves all ID64 of players that sent a message
local playerID64Cache = {}

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
		GetValue = function()
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
		GetValue = function(plyID64)
				local data = {
					plyID64 = plyID64,
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

	local plyID64

	if SERVER and ply:IsValid() then
		plyID64 = ply:SteamID64()
		playerID64Cache[plyID64] = ply
	elseif SERVER then
		return
	end

	local bytesLeft = net.BytesLeft()

	while bytesLeft > 0 do
		local identifier = net.ReadString()
		local readNextValue = net.ReadBool()

		while readNextValue do
			receiveDataFunctions[identifier](plyID64)
			readNextValue = net.ReadBool()
		end

		bytesLeft = net.BytesLeft()
	end
end
net.Receive("TTT2SynchronizeDatabase", SynchronizeStates)

local function SendUpdatesNow()
	sendRequestsNextUpdate = false

	if table.IsEmpty(dataStore) then return end

	local plyDeleteIdentifiers = {}

	for plyIdentifier, identifierList in pairs(dataStore) do
		net.Start("TTT2SynchronizeDatabase")

		local stopSending = false
		local deleteIdentifiers = {}

		for identifier, indexedData in pairs(identifierList) do
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
			if plyIdentifier == sendToPly.all then
				net.Broadcast()
			elseif plyIdentifier == sendToPly.registered then
				net.Send(registeredPlayersTable)
			elseif IsPlayer(playerID64Cache[plyIdentifier]) then
				net.Send(playerID64Cache[plyIdentifier])
			end
		elseif CLIENT then
			net.SendToServer()
		end

		for identifier in pairs(deleteIdentifiers) do
			dataStore[plyIdentifier][identifier] = nil
		end

		if #identifierList <= 0 then
			plyDeleteIdentifiers[plyIdentifier] = true
		end

		if stopSending and not sendRequestsNextUpdate then
			sendRequestsNextUpdate = true
			timer.Simple(0, SendUpdatesNow())
		end
	end

	for plyIdentifier in pairs(plyDeleteIdentifiers) do
		dataStore[plyIdentifier] = nil
	end
end

local function SendUpdateNextTick(identifier, data, plyIdentifier)
	if not sendRequestsNextUpdate then
		sendRequestsNextUpdate = true
		timer.Simple(0, SendUpdatesNow())
	end

	if not isstring(plyIdentifier) then
		if CLIENT then
			plyIdentifier = sendToPly.server
		elseif SERVER then
			plyIdentifier = sendToPly.registered
		end
	end

	-- Store data
	local tempStore = dataStore[plyIdentifier] or {}
	tempStore[identifier] = tempStore[identifier] or {}
	tempStore[identifier][#tempStore[identifier] + 1] = data

	dataStore[plyIdentifier] = tempStore
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
	function database.RegisterPlayer(plyID64)
		if not playersCache[plyId] then
			playersCache[plyId] = true
			registeredPlayersTable[#registeredPlayersTable + 1] = playerID64Cache[plyID64]
		end
	end

	function database.SyncRegisteredDatabases(plyIdentifier)
		for databaseNumber = 1, #registeredDatabases do
			SendUpdateNextTick(identifierStrings.Register, databaseNumber, plyIdentifier)
		end
	end

	function database.RegisterDatabase(accessName, databaseName, savingKeys, additionalData)
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

		SendUpdateNextTick(identifierStrings.Register, databaseCount, sendToPly.all)

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

		database.RegisterPlayer(requestData.plyID64)

		SendUpdateNextTick(identifierStrings.GetValue, serverData, requestData.plyID64)
	end

	hook.Add("PlayerAuthed", "TTT2SyncDatabaseIndexTableToAuthorizedPlayers", function(ply, plyID64, uniqueID)
		if not IsValid(ply) then return end

		playerID64Cache[plyID64] = ply
		database.SyncRegisteredDatabases(plyID64)
	end)

	hook.Add("PlayerDisconnected", "TTT2RemovePlayerOfRegisteredPlayersTable", function(ply)
		if not IsValid(ply) or not playersCache[ply:SteamID64()] then return end

		playersCache[ply:SteamID64()] = nil
		table.RemoveByValue(registeredPlayersTable, ply)
	end)
end
