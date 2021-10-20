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
	GetValue = "GetValue",
	SetValue = "SetValue"
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

local waitForRegisteredDatabases = false
local triedToGetRegisteredDatabases = false
local onWaitReceiveFunctionCache = {}

local requestCacheSize = 0
local requestCache = {}
local functionCache = {}

local playersCache = {}
local registeredPlayersTable = {}

local allCallbackString = "__allCallbacks"
local callbackCache = {}
local callbackIdentifiers = {}

-- Saves all ID64 of players that sent a message
local playerID64Cache = {}

-- Shared functions Part 1

local function OnChange(index, itemName, key, newValue)
	local tempDatabase = registeredDatabases[index]
	local storedData = tempDatabase.storedData

	local dataEntry = storedData[itemName] or {}
	local oldValue = dataEntry[key]
	dataEntry[key] = newValue
	storedData[itemName] = dataEntry

	-- TODO: Implement Callbacks
	if oldValue == newValue then return end

	local accessName = tempDatabase.accessName

	-- Call all callbacks
	local cache = callbackCache[accessName]
	if not cache then return end

	local tempItemName = itemName
	for i = 1, 2 do
		if i == 2 then
			tempItemName = allCallbackString
		end

		local funcCache = cache[tempItemName]

		if not funcCache then continue end

		local tempKey = key
		for j = 1, 2 do
			if j == 2 then
				tempKey = allCallbackString
			end

			funcCache = funcCache[tempKey]

			if not funcCache then continue end

			-- Execute callbacks
			for k = 1, #funcCache do
				funcCache[k](accessName, itemName, key, oldValue, newValue)
			end
		end
	end

end

function database.AddChangeCallback(accessName, itemName, key, callback, identifier)
	if not isstring(accessName) or not isfunction(callback) then return end

	-- If no itemName is given, subscribe to changes of all items
	if not isstring(itemName) then
		itemName = allCallbackString
	end

	-- If no key is given, subscribe to changes of all keys of the item	
	if not isstring(key) then
		key = allCallbackString
	end

	-- If no identifier is given just choose one	
	if not isstring(identifier) then
		identifier = allCallbackString
	end

	local cache = callbackCache[accessName] or {}
	cache[itemName] = cache[itemName] or {}
	cache[itemName][key] = cache[itemName][key] or {}
	cache[itemName][key][identifier] = cache[itemName][key][identifier] or {}
	cache[itemName][key][identifier][#cache[itemName][key][identifier] + 1] = callback

	callbackCache[accessName] = cache
	callbackIdentifiers[identifier] = callbackIdentifiers[identifier] or {}
	callbackIdentifiers[identifier][#callbackIdentifiers[identifier] + 1] = {
			accessName = accessName,
			itemName = itemName,
			key = key
	}
end

function database.RemoveChangeCallback(accessName, itemName, key, identifier)
	callbacks = callbackIdentifiers[identifier]

	if not accessName or not callbacks then return end

	local cache = callbackCache[accessName]

	if not cache then return end

	-- If no itemName is given, remove callbacks of all items
	local skipItemName = false
	if not isstring(itemName) then
		skipItemName = true
	end

	-- If no key is given, remove callbacks of all keys of the item	
	local skipKey = false
	if not isstring(key) then
		skipKey = true
	end

	for i = #callbacks, 1, -1  do
		callback = callbacks[i]

		-- AccesName has to be the same as registration for all sql tables is not allowed
		if callback.accessName ~= accessName then continue end

		-- If neither itemName nor the key fit, skip that callback
		local cItemName = callback.itemName
		if cItemName ~= itemName and not skipItemName then continue end

		local cKey = callback.key
		if cKey ~= key and not skipKey then continue end

		cache[cItemName][cKey][identifier] = nil
		table.remove(callbacks, i)

		-- Delete empty table entries in callbackCache
		if not table.IsEmpty(cache[callback.itemName][callback.key]) then continue end
		cache[callback.itemName][callback.key] = nil

		if not table.IsEmpty(cache[callback.itemName]) then continue end
		cache[callback.itemName] = nil

		if not table.IsEmpty(cache) then continue end
		callbackCache[accessName] = nil
	end

	if #callbacks < 1 then
		callbackIdentifiers[identifier] = nil
	end
end

function database.ConvertValueWithKeys(value, accessName, key)
	if value == "nil" or value == "NULL" then return end

	local index = nameToIndex[accessName]

	if not index then return end

	local info = registeredDatabases[index].keys[key]

	if info.typ == "bool" then
		value = tobool(value)
	elseif info.typ == "number" then
		value = tonumber(value)
	end

	return value
end

-- Client data and functions Part 1
if CLIENT then
	sendDataFunctions = {
		-- data contains the messageIdentifier here
		Register = function(data)
				net.WriteUInt(data, uIntBits)
			end,
		-- data contains the syncCacheIndex here
		GetValue = function(data)
				local request = requestCache[data]

				net.WriteUInt(request.identifier, uIntBits)
				net.WriteUInt(request.index, uIntBits)

				net.WriteString(request.itemName)
				net.WriteString(request.key)
			end,
		-- data contains index, itemName, key and value here
		SetValue = function(data)
				net.WriteUInt(data.index, uIntBits)

				net.WriteString(data.itemName)
				net.WriteString(data.key)
				net.WriteString(tostring(data.value))
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
					accessName = accessName,
					keys = savingKeys,
					data = additionalData,
					storedData = {}
				}

				local sentAdditionalInfo = net.ReadBool()

				if sentAdditionalInfo then
					local identifier = net.ReadUInt(uIntBits)
					local tableCount = net.ReadUInt(uIntBits)

					if table.Count(registeredDatabases) == tableCount then
						functionCache[identifier]()
					end
				end
			end,
		GetValue = function()
				local identifier = net.ReadUInt(uIntBits)
				local isSuccess = net.ReadBool()
				local value

				if isSuccess then
					local request = requestCache[identifier]
					value = net.ReadString()
					value = database.ConvertValueWithKeys(value, request.accessName, request.key)
					registeredDatabases[request.index].storedData[request.itemName] = value
				end

				functionCache[identifier](isSuccess, value)
			end,
		SetValue = function()
				local index = net.ReadUInt(uIntBits)
				local itemName = net.ReadString()
				local key = net.ReadString()
				local value = net.ReadString()

				OnChange(index, itemName, key, value)
			end
	}
end

-- Server data and functions Part 1
if SERVER then
	sendDataFunctions = {
		-- data contains identifier, tableCount, index here
		Register = function(data)
				local databaseInfo = registeredDatabases[data.index]
				net.WriteUInt(data.index, uIntBits)
				net.WriteString(databaseInfo.accessName)
				net.WriteTable(databaseInfo.keys)
				net.WriteTable(databaseInfo.data)

				local sendAdditionalInfo = tobool(data.identifier)
				net.WriteBool(sendAdditionalInfo)

				if sendAdditionalInfo then
					net.WriteUInt(data.identifier, uIntBits)
					net.WriteUInt(data.tableCount, uIntBits)
				end
			end,
		-- data contains identifier, isSuccess and value here
		GetValue = function(data)
				net.WriteUInt(data.identifier, uIntBits)
				net.WriteBool(data.isSuccess)

				if data.isSuccess then
					net.WriteString(data.value)
				end
			end,
		-- data contains index, itemName, key, value here
		SetValue = function(data)
				net.WriteUInt(data.index, uIntBits)
				net.WriteString(data.itemName)
				net.WriteString(data.key)
				net.WriteString(data.value)
			end
	}

	receiveDataFunctions = {
		Register = function(plyID64)
				database.SyncRegisteredDatabases(plyID64, net.ReadUInt(uIntBits))
			end,
		GetValue = function(plyID64)
				local data = {
					plyID64 = plyID64,
					identifier = net.ReadUInt(uIntBits),
					index = net.ReadUInt(uIntBits)
				}

				data.itemName = net.ReadString()
				data.key = net.ReadString()

				database.ReturnGetValue(data)
			end,
		SetValue = function(plyID64)
				local data = {
					index = net.ReadUInt(uIntBits),
					itemName = net.ReadString(),
					key = net.ReadString(),
					value = net.ReadString()
				}

				database.SetValue(registeredDatabases[data.index].accessName, data.itemName, data.key, data.value, plyID64)
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
	function database.GetRegisteredDatabases(OnReceiveFunc)
		waitForRegisteredDatabases = true

		messageIdentifier = (messageIdentifier + 1) % maxUInt
		functionCache[messageIdentifier] = OnReceiveFunc

		SendUpdateNextTick(identifierStrings.Register, messageIdentifier)
	end

	local function cleanUpWaitReceiveCache()
		waitForRegisteredDatabases = false
		triedToGetRegisteredDatabases = true

		for i = 1, #onWaitReceiveFunctionCache do
			local data = onWaitReceiveFunctionCache[i]

			database.GetValue(data.accessName, data.itemName, data.key, data.OnReceiveFunc)
		end

		onWaitReceiveFunctionCache = {}
	end

	---
	-- Get the stored key value of the given database if it exists on the server or was already cached
	-- @param string accessName the chosen networkable name of the sql table
	-- @param string itemName the name or primaryKey of the item inside of the sql table
	-- @param function OnReceiveFunc(databaseExists, value) The function that gets called with the results if the database exists
	-- @realm client
	function database.GetValue(accessName, itemName, key, OnReceiveFunc)
		local index = nameToIndex[accessName]

		if not index then
			if triedToGetRegisteredDatabases then
				ErrorNoHalt("[TTT2] database.GetValue failed. The registered Database of " .. accessName .. " is not available or synced.")
				OnReceiveFunc(false)

				return
			end

			if not waitForRegisteredDatabases then
				database.GetRegisteredDatabases(cleanUpWaitReceiveCache)
			end

			onWaitReceiveFunctionCache[#onWaitReceiveFunctionCache + 1] = {
				accessName = accessName,
				itemName = itemName,
				key = key,
				OnReceiveFunc = OnReceiveFunc
			}

			return
		end

		local dataTable = index and registeredDatabases[index]

		if not registeredDatabases.keys[key] then
			ErrorNoHalt("[TTT2] database.GetValue failed. The registered Database of " .. accessName .. " doesnt have a key named " .. key)

			return
		end

		local storedValue = dataTable and dataTable.storedData[itemName] and dataTable.storedData[itemName][key]

		if storedValue then
			OnReceiveFunc(true, storedValue)

			return
		end

		messageIdentifier = (messageIdentifier + 1) % maxUInt
		functionCache[messageIdentifier] = OnReceiveFunc

		requestCacheSize = requestCacheSize + 1
		requestCache[requestCacheSize] = {
			identifier = messageIdentifier,
			accessName = accessName,
			itemName = itemName,
			key = key,
			index = index
		}

		SendUpdateNextTick(identifierStrings.GetValue, requestCacheSize)
	end

	function database.SetValue(accessName, itemName, key, value)
		local index = nameToIndex[accessName]

		if not index then
			ErrorNoHalt("[TTT2] database.SetValue failed. The registered Database of " .. accessName .. " is not available or synced.")

			return
		end

		if not registeredDatabases.keys[key] then
			ErrorNoHalt("[TTT2] database.SetValue failed. The registered Database of " .. accessName .. " doesnt have a key named " .. key)

			return
		end

		SendUpdateNextTick(identifierStrings.SetValue, {index = index, itemName = itemName, key = key, value = value})
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

	function database.SyncRegisteredDatabases(plyIdentifier, identifier)
		local tableCount = #registeredDatabases

		local data = {
			identifier = identifier,
			tableCount = tableCount
		}

		for databaseNumber = 1, tableCount do
			data.index = databaseNumber
			SendUpdateNextTick(identifierStrings.Register, data, plyIdentifier)
		end
	end

	function database.RegisterDatabase(databaseName, accessName, savingKeys, additionalData)
		if not sql.CreateSqlTable(databaseName, savingKeys) or not isstring(accessName) then
			return false
		end

		if nameToIndex[accessName] then
			return true
		end

		databaseCount = databaseCount + 1

		registeredDatabases[databaseCount] = {
			accessName = accessName,
			orm = orm.Make(databaseName),
			keys = savingKeys,
			data = additionalData,
			storedData = {}
		}

		nameToIndex[accessName] = databaseCount

		local data = {index = databaseCount}

		SendUpdateNextTick(identifierStrings.Register, data, sendToPly.all)

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
			serverData.value = tostring(sqlData[requestData.key])
		end

		database.RegisterPlayer(requestData.plyID64)

		SendUpdateNextTick(identifierStrings.GetValue, serverData, requestData.plyID64)
	end

	function database.SetValue(accessName, itemName, key, value, plyID64)
		if plyID64 and not playerID64Cache[plyID64]:IsSuperAdmin() then return end

		local index = nameToIndex[accessName]

		if not index then
			ErrorNoHalt("[TTT2] database.SetValue failed. The registered Database of " .. accessName .. " is not registered.")

			return
		end

		if not registeredDatabases.keys[key] then
			ErrorNoHalt("[TTT2] database.SetValue failed. The registered Database of " .. accessName .. " doesnt have a key named " .. key)

			return
		end

		local itemPoolModel = registeredDatabases[index].orm

		local item = itemPoolModel:Find(itemName)

		if not item then
			item = itemPoolModel:New({
				name = itemName,
			})
		end

		item[key] = value

		itemPoolModel:Save()

		OnChange(index, itemName, key, value)

		SendUpdateNextTick(identifierStrings.SetValue, {index = index, itemName = itemName, key = key, value = value}, sendToPly.registered)
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
