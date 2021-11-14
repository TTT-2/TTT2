---
-- A shared database to handle synchronization of data between client and server
-- as well as handling the storage in an sql database
-- @author ZenBre4ker
-- @module database

database = database or {}

if SERVER then
	AddCSLuaFile()

	util.AddNetworkString("TTT2SynchronizeDatabase")
end

local messageIdentifier = 0
local maxBytesPerMessage = 32 * 1000 -- Can be up to 65.533KB see: https://wiki.facepunch.com/gmod/net.Start
local uIntBits = 8 -- we can synchronize up to 2 ^ uIntBits - 1 different sqlTables
local maxUInt = 2 ^ uIntBits - 1

local databaseCount = 0

local registeredDatabases = {}
local receivedValues = {}
local nameToIndex = {}

-- Identifier enums to determine the message to send or receive
local MESSAGE_REGISTER = 1
local MESSAGE_GET_VALUE = 2
local MESSAGE_SET_VALUE = 3
local MESSAGE_GET_DEFAULTVALUE = 4

-- Identifier strings to determine which player gets the information
local SEND_TO_PLY_ALL = "all"
local SEND_TO_PLY_REGISTERED = "registered"
local SEND_TO_PLY_SERVER = "server"


-- Stores the data and the players it is send to
local dataStore = {}

local sendDataFunctions = {}

local receiveDataFunctions = {}

local sendRequestsNextUpdate = false

local waitForRegisteredDatabases = {}
local triedToGetRegisteredDatabases = {}
local onWaitReceiveFunctionCache = {}

local requestCache = {}
local functionCache = {}

local playersCache = {}
local registeredPlayersTable = {}

local allCallbackString = "__allCallbacks"
local callbackCache = {}
local callbackIdentifiers = {}

-- Saves all ID64 of players that sent a message
local playerID64Cache = {}

--
-- General Shared functions
--

local function valueReceived(accessName, itemName, key)
	local receiver = receivedValues[accessName] or {}

	receiver[itemName] = receiver[itemName] or {}
	receiver[itemName][key] = true

	receivedValues[accessName] = receiver
end

local function isValueReceived(accessName, itemName, key)
	return receivedValues[accessName]
		and receivedValues[accessName][itemName]
		and receivedValues[accessName][itemName][key]
		or false
end

function database.GetDefaultValue(accessName, itemName, key)
	local index = nameToIndex[accessName]

	if not index then return end

	local dataTable = registeredDatabases[index].defaultData
	local defaultTable = dataTable.defaultData

	local defaultValue = defaultTable[itemName] and defaultTable[itemName][key]

	if defaultValue == nil then
		defaultValue = dataTable.keys[key].default
	end

	return defaultValue
end

---
-- Called on change of values over the database-library
-- @param number index the local index of the database
-- @param string itemName the name of the item in the database
-- @param string key the name of the key in the database
-- @param any newValue the value it got changed to
-- @realm shared
-- @internal
local function OnChange(index, itemName, key, newValue)
	local tempDatabase = registeredDatabases[index]
	local storedData = tempDatabase.storedData

	local dataEntry = storedData[itemName] or {}
	local oldValue = dataEntry[key]
	dataEntry[key] = newValue
	storedData[itemName] = dataEntry

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
			for identifier, functions in pairs(funcCache) do
				for k = 1, #functions do
					functions[k](accessName, itemName, key, oldValue, newValue)
				end
			end
		end
	end

	valueReceived(accessName, itemName, key)
end

---
-- Adds a callback to be called when the given sql table entries change
-- @note itemName and key can both be `nil`. The callback function then gets called on a change of every item or every key
-- @param string accessName the chosen accessName registered for a given database. HAS NOT TO BE the real database-name!
-- @param string itemName the name of the item in the database. Leave `nil` if you want a callback for every item
-- @param string key the name of the key in the database. Leave `nil` if you want a callback for every key
-- @param function The callback function(accessName, itemName, key, oldValue, newValue), its only called if the value actually changed
-- @param[opt] string identifier a chosen identifier if you want to remove the callback
-- @realm shared
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

---
-- Removes a callback if an identifier was registered
-- @note itemName and key can both be `nil`. The callback function then gets removed for all items or keys with that identifier
-- @param string accessName the chosen accessName registered for a given database. HAS NOT TO BE the real database-name!
-- @param string itemName the name of the item in the database. Leave `nil` if you want to remove callbacks for every item with given identifier
-- @param string key the name of the key in the database. Leave `nil` if you want to remove callbacks for every key with given identifier
-- @param[opt] string identifier a chosen identifier if you want to remove the callback
-- @realm shared
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

		table.remove(callbacks, i)

		if not istable(cache[cItemName]) or not istable(cache[cItemName][cKey]) then continue end
		cache[cItemName][cKey][identifier] = nil

		-- Delete empty table entries in callbackCache
		if not table.IsEmpty(cache[cItemName][cKey]) then continue end
		cache[cItemName][cKey] = nil

		if not table.IsEmpty(cache[cItemName]) then continue end
		cache[cItemName] = nil

		if not table.IsEmpty(cache) then continue end
		callbackCache[accessName] = nil
	end

	if #callbacks < 1 then
		callbackIdentifiers[identifier] = nil
	end
end

---
-- Converts the given value of a database with its key
-- @warning this function should only be internally used and shall be removed and replaced with orm conversion. 
-- `sql.GetParsedData` is not compatible with orm as sql.SQLStr is used (e.g. converts `false` => "false"
-- while the other uses "0" and "1" for booleans
-- @param string value the value to convert with a key
-- @param string accessName the chosen accessName registered for a given database.
-- @param string key the name of the key in the database
-- @return any value after conversion, `nil` if not convertible or "nil" or "NULL"
-- @realm shared
-- @internal
function database.ConvertValueWithKey(value, accessName, key)
	if not value or value == "nil" or value == "NULL" then return end

	local index = nameToIndex[accessName]

	if not index then return end

	local data = registeredDatabases[index].keys[key]

	if data.typ == "bool" then
		value = tobool(value)
	elseif data.typ == "number" then
		value = tonumber(value)
	end

	return value
end

---
-- Converts the given table of a database
-- @warning this function should only be internally used and shall be removed and replaced with orm conversion. 
-- `sql.GetParsedData` is not compatible with orm as sql.SQLStr is used (e.g. converts `false` => "false"
-- while the other uses "0" and "1" for booleans
-- @param table dataTable the table to convert with their respective keys
-- @param string accessName the chosen accessName registered for a given database.
-- @realm shared
-- @internal
function database.ConvertTable(dataTable, accessName)
	if not istable(dataTable) then return end

	local index = nameToIndex[accessName]

	if not index then return end

	local keys = registeredDatabases[index].keys

	for key, data in pairs(keys) do
		dataTable[key] = database.ConvertValueWithKey(dataTable[key], accessName, key)
	end
end

-- Client send and receive functions
if CLIENT then
	-- The used functions to send Data from the client to server
	sendDataFunctions = {
		-- data contains the messageIdentifier here
		[MESSAGE_REGISTER] = function(data)
			net.WriteUInt(data, uIntBits)
		end,
		-- data contains the messageIdentifier here
		[MESSAGE_GET_VALUE] = function(data)
			local request = requestCache[data]

			net.WriteUInt(data, uIntBits)
			net.WriteUInt(request.index, uIntBits)

			net.WriteString(request.itemName)
			net.WriteString(request.key)
		end,
		-- data contains index, itemName, key and value here
		[MESSAGE_SET_VALUE] = function(data)
			net.WriteUInt(data.index, uIntBits)

			net.WriteString(data.itemName)
			net.WriteString(data.key)
			net.WriteString(tostring(data.value))
		end
	}

	-- The used functions to receive Data from the server on the client
	receiveDataFunctions = {
		[MESSAGE_REGISTER] = function()
			local index = net.ReadUInt(uIntBits)
			local accessName = net.ReadString()
			local savingKeys = net.ReadTable()
			local additionalData = net.ReadTable()

			nameToIndex[accessName] = index
			registeredDatabases[index] = {
				accessName = accessName,
				keys = savingKeys,
				data = additionalData,
				storedData = {},
				defaultData = {}
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
		[MESSAGE_GET_VALUE] = function()
			local identifier = net.ReadUInt(uIntBits)
			local isSuccess = net.ReadBool()
			local request = requestCache[identifier]
			local value

			if isSuccess then
				value = net.ReadString()
				value = database.ConvertValueWithKey(value, request.accessName, request.key)

				local storedData = registeredDatabases[request.index].storedData

				local storedItemData = storedData[request.itemName] or {}
				storedItemData[request.key] = value

				storedData[request.itemName] = storedItemData
			end

			valueReceived(request.accessName, request.itemName, request.key)
			functionCache[identifier](isSuccess, value)
		end,
		[MESSAGE_SET_VALUE] = function()
			local index = net.ReadUInt(uIntBits)
			local itemName = net.ReadString()
			local key = net.ReadString()
			local value = net.ReadString()

			value = database.ConvertValueWithKey(value, registeredDatabases[index].accessName, key)

			OnChange(index, itemName, key, value)
		end,
		[MESSAGE_GET_DEFAULTVALUE] = function()
			local index = net.ReadUInt(uIntBits)
			local dataTable = registeredDatabases[index]

			local sentTable = net.ReadBool()

			if sentTable then
				dataTable.defaultData = net.ReadTable()
			else
				local itemName = net.ReadString()
				local key = net.ReadString()
				local value = database.ConvertValueWithKey(net.ReadString(), dataTable.accessName, key)
				local defaultData = dataTable.defaultData
				defaultData[itemName] = defaultData[itemName] or {}
				defaultData[itemName][key] = value
			end
		end
	}
end

-- Server send and receive functions
if SERVER then
	-- The used functions to send Data from the server to client
	sendDataFunctions = {
		-- data contains identifier, tableCount, index here
		[MESSAGE_REGISTER] = function(data)
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
		[MESSAGE_GET_VALUE] = function(data)
			net.WriteUInt(data.identifier, uIntBits)
			net.WriteBool(data.isSuccess)

			if data.isSuccess then
				net.WriteString(tostring(data.value))
			end
		end,
		-- data contains index, itemName, key, value here
		[MESSAGE_SET_VALUE] = function(data)
			net.WriteUInt(data.index, uIntBits)
			net.WriteString(data.itemName)
			net.WriteString(data.key)
			net.WriteString(tostring(data.value))
		end,
		-- data contains index, itemName, key, value here
		[MESSAGE_GET_DEFAULTVALUE] = function(data)
			net.WriteUInt(data.index, uIntBits)
			net.WriteBool(data.sendTable or false)
			if data.sendTable then
				net.WriteTable(data.defaultData)
			else
				net.WriteString(data.itemName)
				net.WriteString(data.key)
				net.WriteString(tostring(data.value))
			end
		end
	}

	-- The used functions to receive Data from the client on the server
	receiveDataFunctions = {
		[MESSAGE_REGISTER] = function(plyID64)
			database.SyncRegisteredDatabases(plyID64, net.ReadUInt(uIntBits))
		end,
		[MESSAGE_GET_VALUE] = function(plyID64)
			local data = {
				plyID64 = plyID64,
				identifier = net.ReadUInt(uIntBits),
				index = net.ReadUInt(uIntBits)
			}

			data.itemName = net.ReadString()
			data.key = net.ReadString()

			database.ReturnGetValue(data)
		end,
		[MESSAGE_SET_VALUE] = function(plyID64)
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

--
-- Shared combined send and receive functions
--

---
-- The function to be called on received synchronisation messages between server and client
-- @param number len length of the message
-- @param Player ply player that the message is received, `nil` on the client
-- @realm shared
-- @internal
local function SynchronizeStates(len, ply)
	print("\nReceived Synchronization with len of " .. len .. " from player: " .. tostring(ply))
	if len < 1 then return end

	local plyID64

	if SERVER and ply:IsValid() then
		plyID64 = ply:SteamID64()
		playerID64Cache[plyID64] = ply
	elseif SERVER then
		return
	end

	local continueReading = net.ReadBool()
	while continueReading do
		local identifier = net.ReadUInt(uIntBits)
		local readNextValue = net.ReadBool()

		print("identifier is: " .. identifier .. " and readnextvalue? " .. tostring(readNextValue))
		while readNextValue do
			receiveDataFunctions[identifier](plyID64)
			print("Readnextvalue? " .. tostring(readNextValue))
			readNextValue = net.ReadBool()
		end

		continueReading = net.ReadBool()
		print("Continue reading? " .. tostring(continueReading) .. "\n")
	end
end
net.Receive("TTT2SynchronizeDatabase", SynchronizeStates)

---
-- The function to call when synchronizing all messages between server and client
-- @realm shared
-- @internal
local function SendUpdatesNow()
	sendRequestsNextUpdate = false

	if table.IsEmpty(dataStore) then return end

	local plyDeleteIdentifiers = {}
	print("\nSynchronize!")
	for plyIdentifier, identifierList in pairs(dataStore) do
		net.Start("TTT2SynchronizeDatabase")
		print("Send to " .. plyIdentifier)

		local stopSending = false
		local deleteIdentifiers = {}
		for identifier, indexedData in pairs(identifierList) do
			net.WriteBool(true)
			net.WriteUInt(identifier, uIntBits)
			net.WriteBool(#indexedData > 0)
			print("Sending identifier: " .. identifier)
			print("Data available: " .. #indexedData)

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
		net.WriteBool(false)

		if SERVER then
			if plyIdentifier == SEND_TO_PLY_ALL then
				net.Broadcast()
			elseif plyIdentifier == SEND_TO_PLY_REGISTERED then
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

---
-- The function to call when you want to queue a message to be sent next tick
-- @note on the client plyIdentifier is unused and always sends to the server
-- @param number identifier the identifiers used in send and receive messages, defined in `MESSAGE_`-enums
-- @param any data the data for the send method. Can contain anything and is defined above each send or receive method itself
-- @param string plyIdentifier the player identifier to determine who receives the message, defined in `SEND_TO_PLY_`-enums or can be a plyID64
-- @realm shared
-- @internal
local function SendUpdateNextTick(identifier, data, plyIdentifier)
	if not sendRequestsNextUpdate then
		sendRequestsNextUpdate = true
		timer.Simple(0, SendUpdatesNow)
	end

	if CLIENT then
		plyIdentifier = SEND_TO_PLY_SERVER
	end

	if not isstring(plyIdentifier) and SERVER then
		plyIdentifier = SEND_TO_PLY_REGISTERED
	end

	-- Store data
	local tempStore = dataStore[plyIdentifier] or {}
	tempStore[identifier] = tempStore[identifier] or {}
	tempStore[identifier][#tempStore[identifier] + 1] = data

	dataStore[plyIdentifier] = tempStore
end

-- Public Client only functions
if CLIENT then
	---
	-- Is automatically called when a client joins, can be called by a player to force an update, but is normally not necessary
	-- @param function OnReceiveFunc() the function that is called when the registered databases are received
	-- @realm client
	-- @internal
	function database.GetRegisteredDatabases(OnReceiveFunc)
		messageIdentifier = messageIdentifier % maxUInt + 1
		functionCache[messageIdentifier] = OnReceiveFunc

		SendUpdateNextTick(MESSAGE_REGISTER, messageIdentifier)
	end

	---
	-- Is called after databases are received. All pending getRequests are sent.
	-- @realm client
	-- @internal
	local function cleanUpWaitReceiveCache()
		for i = 1, #onWaitReceiveFunctionCache do
			local data = onWaitReceiveFunctionCache[i]

			waitForRegisteredDatabases[data.accessName] = false
			triedToGetRegisteredDatabases[data.accessName] = true

			database.GetValue(data.accessName, data.itemName, data.key, data.OnReceiveFunc)
		end

		onWaitReceiveFunctionCache = {}
	end

	---
	-- Get the stored key value of the given database if it exists on the server or was already cached
	-- @param string accessName the chosen networkable name of the sql table
	-- @param string itemName the name or primaryKey of the item inside of the sql table
	-- @param string key the name of the key in the database
	-- @param function OnReceiveFunc(databaseExists, value) The function that gets called with the results if the database exists
	-- @realm client
	function database.GetValue(accessName, itemName, key, OnReceiveFunc)
		local index = nameToIndex[accessName]

		if not index then
			if triedToGetRegisteredDatabases[accessName] then
				ErrorNoHalt("[TTT2] database.GetValue failed. The registered Database of " .. accessName .. " is not available or synced.")
				OnReceiveFunc(false)

				return
			end

			if not waitForRegisteredDatabases[accessName] then
				waitForRegisteredDatabases[accessName] = true
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

		local dataTable = registeredDatabases[index]

		if not dataTable.keys[key] then
			ErrorNoHalt("[TTT2] database.GetValue failed. The registered Database of " .. accessName .. " doesnt have a key named " .. key)

			return
		end

		if isValueReceived(accessName, itemName, key) then
			OnReceiveFunc(true, dataTable.storedData[itemName] and dataTable.storedData[itemName][key])

			return
		end

		messageIdentifier = messageIdentifier % maxUInt + 1
		functionCache[messageIdentifier] = OnReceiveFunc

		requestCache[messageIdentifier] = {
			accessName = accessName,
			itemName = itemName,
			key = key,
			index = index
		}

		SendUpdateNextTick(MESSAGE_GET_VALUE, messageIdentifier)
	end

	---
	-- @param string accessName the chosen networkable name of the sql table
	-- @param string itemName the name or primaryKey of the item inside of the sql table
	-- @param string key the name of the key in the database
	-- @param any value the value you want to set in the database
	-- @realm client
	function database.SetValue(accessName, itemName, key, value)
		local index = nameToIndex[accessName]

		if not index then
			ErrorNoHalt("[TTT2] database.SetValue failed. The registered Database of " .. accessName .. " is not available or synced.")

			return
		end

		if not registeredDatabases[index].keys[key] then
			ErrorNoHalt("[TTT2] database.SetValue failed. The registered Database of " .. accessName .. " doesnt have a key named " .. key)

			return
		end

		SendUpdateNextTick(MESSAGE_SET_VALUE, {index = index, itemName = itemName, key = key, value = value})
	end
end

-- Public Server only functions
if SERVER then
	---
	-- Registers players that are notified of all changes
	-- @note this function is called when a player makes a request to the server
	-- @param string plyID64 the player steam ID 64
	-- @realm server
	-- @internal
	local function RegisterPlayer(plyID64)
		if not playersCache[plyID64] then
			playersCache[plyID64] = true
			registeredPlayersTable[#registeredPlayersTable + 1] = playerID64Cache[plyID64]
		end
	end

	---
	-- Synchronizes all registered Databases with the given players defined by the plyIdentifier
	-- @param string plyIdentifier the player identifier to determine who receives the message, defined in `SEND_TO_PLY_`-enums or can be a plyID64
	-- @param[opt] string identifier the identifier used to get correct onreceive functions
	-- @realm server
	-- @internal
	function database.SyncRegisteredDatabases(plyIdentifier, identifier)
		local tableCount = #registeredDatabases

		for databaseNumber = 1, tableCount do
			--contains additional data in case an identifier is given
			local dataRegister = {
				index = databaseNumber,
				identifier = identifier,
				tableCount = tableCount
			}
			SendUpdateNextTick(MESSAGE_REGISTER, dataRegister, plyIdentifier)

			local defaultData = registeredDatabases[databaseNumber].defaultData

			if table.IsEmpty(defaultData) then continue end

			local dataDefault = {
				index = databaseNumber,
				sendTable =  true,
				defaultData = defaultData
			}
			SendUpdateNextTick(MESSAGE_GET_DEFAULTVALUE, dataDefault, plyIdentifier)
		end
	end

	---
	-- @param string databaseName the real name of the database
	-- @param string accessName the name to quickly access databases and differentiate between a pseudo used accessName and the migrated actual databaseName
	-- @param table savingKeys the savingKeys = {keyName = {typ, bits, default, ..}, ..} defining the keyNames and their information
	-- @param[opt] table additionalData the data that doesnt belong to a database but might be needed for other purposes like enums
	-- @return bool isSuccessful if the database exists and is successfully registered
	-- @realm server
	function database.Register(databaseName, accessName, savingKeys, additionalData)
		print("\nRegistering " .. databaseName .. " as " .. accessName .. " with Keys:")
		PrintTable(savingKeys)
		PrintTable(additionalData or {})
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
			keys = savingKeys or {},
			data = additionalData or {},
			storedData = {},
			defaultData = {}
		}
		print("\nCurrent registered Database")
		PrintTable(registeredDatabases)
		nameToIndex[accessName] = databaseCount

		local data = {index = databaseCount}

		SendUpdateNextTick(MESSAGE_REGISTER, data, SEND_TO_PLY_ALL)

		return true
	end

	---
	-- This is called upon receiving a get request from a player to send a value back
	-- @warning Dont use this function if you want to get a value from the database, this is meant to be used internally
	-- @param table requestData = {plyID64, identifier, index, itemName, key} contains player and the data they requested
	-- @realm server
	-- @internal
	function database.ReturnGetValue(requestData)
		local index = requestData.index
		local accessName = index and registeredDatabases[index] and registeredDatabases[index].accessName
		local value
		local isSuccess = false

		if accessName then
			isSuccess, value = database.GetValue(accessName, requestData.itemName, requestData.key)
		end

		local serverData = {
			identifier = requestData.identifier,
			isSuccess = isSuccess,
			value = value
		}

		RegisterPlayer(requestData.plyID64)

		SendUpdateNextTick(MESSAGE_GET_VALUE, serverData, requestData.plyID64)
	end

	---
	-- Get the stored key value of the given database if it exists and was registered
	-- @param string accessName the chosen networkable name of the sql table
	-- @param[opt] string itemName the name or primaryKey of the item inside of the sql table, if not given selects whole sql table
	-- @param[opt] string key the name of the key in the database, is ignored when no itemName is given, if not given selects whole item
	-- @return bool, any value that was saved in the database and if it successfully reached the sql datatable
	-- @realm server
	function database.GetValue(accessName, itemName, key)
		local index = nameToIndex[accessName]

		print("\nGetting " .. accessName .. " database for item " .. tostring(itemName) .. " and key " .. tostring(key))
		if not index then
			ErrorNoHalt("[TTT2] database.GetValue failed. The registered Database of " .. accessName .. " is not registered.")

			return false
		end

		local dataTable = index and registeredDatabases[index]

		-- If itemName and key are given but the key not registered throw an error
		if itemName and key and not dataTable.keys[key] then
			ErrorNoHalt("[TTT2] database.GetValue failed. The registered Database of " .. accessName .. " doesnt have a key named " .. key)

			return false
		end

		local storedValue = itemName and dataTable.storedData[itemName] and dataTable.storedData[itemName][key]

		if storedValue ~= nil then
			return true, storedValue
		end

		local sqlData

		if itemName then
			sqlData = dataTable.orm:Find(itemName)

			if not sqlData then
				return false
			end

			if key then
				local value = database.ConvertValueWithKey(sqlData[key], accessName, key)

				if value == nil then
					value = database.GetDefaultValue(accessName, itemName, key)
				end

				dataTable.storedData[itemName] = dataTable.storedData[itemName] or {}
				dataTable.storedData[itemName][key] = value

				print("\nFetched itemValue is: " .. tostring(value))
				return value ~= nil, value
			end

			database.ConvertTable(sqlData, accessName)
			dataTable.storedData[itemName] = sqlData
		else
			sqlData = dataTable.orm:All()

			if not istable(sqlData) then
				return false
			end

			for _, item in pairs(sqlData) do
				database.ConvertTable(item, accessName)
			end

			-- Convert numerical indices to string indices with the itemName
			local hashableData = {}

			for i = 1, #sqlData do
				local sqlTable = sqlData[i]
				hashableData[sqlTable.name] = sqlTable
				hashableData[sqlTable.name].name = nil
			end

			sqlData = hashableData

			dataTable.storedData = table.Copy(sqlData)
		end

		print("\nFetched sqlData is: ")
		PrintTable(sqlData)

		return istable(sqlData), sqlData
	end

	---
	-- Get the stored table database if it exists and was registered
	-- @param string accessName the chosen networkable name of the sql table
	-- @return bool, table datatable that was saved, and if it successfully reached the sql datatable
	-- @realm server
	function database.GetTable(accessName)
		return database.GetValue(accessName)
	end

	---
	-- @param string accessName the chosen networkable name of the sql table
	-- @param string itemName the name or primaryKey of the item inside of the sql table
	-- @param string key the name of the key in the database
	-- @param any value the value you want to set in the database
	-- @param[opt] string plyID64 the player steam ID 64. Leave this empty when calling on the server. This only makes sure values are only set by superadmins
	-- @realm server
	function database.SetValue(accessName, itemName, key, value, plyID64)
		print("\nSetting " .. accessName .. " database for item " .. tostring(itemName) .. " and key " .. tostring(key) .. " with value " .. tostring(value))
		if plyID64 and not playerID64Cache[plyID64]:IsSuperAdmin() then return end

		local index = nameToIndex[accessName]

		if not index then
			ErrorNoHalt("[TTT2] database.SetValue failed. The registered Database of " .. accessName .. " is not registered.")

			return
		end

		local dataTable = registeredDatabases[index]

		if not dataTable.keys[key] then
			ErrorNoHalt("[TTT2] database.SetValue failed. The registered Database of " .. accessName .. " doesnt have a key named " .. key)

			return
		end

		local itemPoolModel = dataTable.orm

		local item = itemPoolModel:Find(itemName)

		if not item then
			item = itemPoolModel:New({
				name = itemName,
			})
		end

		item[key] = value

		print("\nSet  itemData is: ")
		PrintTable(item)
		if value ~= nil then
			item:Save()
		else
			database.ConvertTable(item, accessName)

			local isNil = true

			for curKey in pairs(dataTable.keys) do
				if item[curKey] ~= nil then
					isNil = false

					break
				end
			end

			if isNil then
				item:Delete()
			end
		end

		OnChange(index, itemName, key, value)

		SendUpdateNextTick(MESSAGE_SET_VALUE, {index = index, itemName = itemName, key = key, value = value}, SEND_TO_PLY_REGISTERED)
	end

	---
	-- @param string accessName the chosen networkable name of the sql table
	-- @param string itemName the name or primaryKey of the item inside of the sql table
	-- @param string key the name of the key in the database
	-- @param any value the value you want to set in the database
	-- @realm server
	function database.SetDefaultValue(accessName, itemName, key, value)
		print("\nSetting " .. accessName .. " database for item " .. tostring(itemName) .. " and key " .. tostring(key) .. " with default value " .. tostring(value))

		local index = nameToIndex[accessName]

		if not index then
			ErrorNoHalt("[TTT2] database.SetDefaultValue failed. The registered Database of " .. accessName .. " is not registered.")

			return
		end

		local dataTable = registeredDatabases[index]

		if not dataTable.keys[key] then
			ErrorNoHalt("[TTT2] database.SetDefaultValue failed. The registered Database of " .. accessName .. " doesnt have a key named " .. key)

			return
		end

		local defaultData = dataTable.defaultData
		defaultData[itemName] = defaultData[itemName] or {}
		defaultData[itemName][key] = value

		dataTable.defaultData = defaultData

		SendUpdateNextTick(MESSAGE_GET_DEFAULTVALUE, {index = index, itemName = itemName, key = key, value = value, sendTable = false}, SEND_TO_PLY_REGISTERED)
	end

	-- Sync databases to all authenticated players
	hook.Add("PlayerAuthed", "TTT2SyncDatabaseIndexTableToAuthorizedPlayers", function(ply, plyID64, uniqueID)
		if not IsValid(ply) then return end

		playerID64Cache[plyID64] = ply
		database.SyncRegisteredDatabases(plyID64)
	end)

	-- Remove disconnected players, that were additionally registered due to requesting or setting data
	hook.Add("PlayerDisconnected", "TTT2RemovePlayerOfRegisteredPlayersTable", function(ply)
		if not IsValid(ply) or not playersCache[ply:SteamID64()] then return end

		playersCache[ply:SteamID64()] = nil
		table.RemoveByValue(registeredPlayersTable, ply)
	end)
end
