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

-- Identifier enums to determine protection level of database-access
TTT2_DATABASE_ACCESS_ANY = 10
TTT2_DATABASE_ACCESS_ADMIN = 0
TTT2_DATABASE_ACCESS_SERVER = -1

-- Identifier enums to determine the message to send or receive
local MESSAGE_REGISTER = 1
local MESSAGE_GET_VALUE = 2
local MESSAGE_SET_VALUE = 3
local MESSAGE_GET_DEFAULTVALUE = 4
local MESSAGE_RESET = 5

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

---
-- Call this function if a value was received
-- @param number index The local index of the database
-- @param string itemName The name of the item in the database
-- @param string key The name of the key in the database
-- @realm shared
-- @internal
local function ValueReceived(index, itemName, key)
	local receiver = receivedValues[index] or {}

	receiver[itemName] = receiver[itemName] or {}
	receiver[itemName][key] = true

	receivedValues[index] = receiver
end

---
-- Check if a value was already received via network
-- @param number index the local index of the database
-- @param string itemName the name of the item in the database
-- @param string key the name of the key in the database
-- @realm shared
-- @internal
local function IsValueReceived(index, itemName, key)
	return receivedValues[index]
		and receivedValues[index][itemName]
		and receivedValues[index][itemName][key]
		or false
end

---
-- Gets either an item-specific or key-specific default value
-- @param string accessName the chosen accessName registered for a given database. HAS NOT TO BE the real database-name!
-- @param string itemName the name of the item in the database
-- @param string key the name of the key in the database
-- @return any the defaultValue
-- @realm shared
function database.GetDefaultValue(accessName, itemName, key)
	local index = nameToIndex[accessName]

	if not index then
		ErrorNoHalt("[TTT2] database.GetDefaultValue failed. The registered Database of " .. accessName .. " is not available or is not synced.")

		return
	end

	local dataTable = registeredDatabases[index]
	local defaultTable = dataTable.defaultData

	-- Try to get an item-specific default value
	local defaultValue = defaultTable[itemName] and defaultTable[itemName][key]

	-- Otherwise get the key-specific default value
	if defaultValue == nil then
		local savingKey = dataTable.keys[key]

		if not istable(savingKey) then
			ErrorNoHalt("[TTT2] database.GetDefaultValue failed. The registered Database of " .. accessName .. " doesnt have a key named " .. key)

			return
		end

		defaultValue = savingKey.default
	end

	return defaultValue
end

---
-- Called internally on change of values over the database-library and then calls all registered Callbacks if a change occured
-- @param number index the local index of the database
-- @param string itemName the name of the item in the database
-- @param string key the name of the key in the database
-- @param any newValue the value it got changed to
-- @realm shared
-- @internal
local function OnChange(index, itemName, key, newValue)
	local dataTable = registeredDatabases[index]

	-- Cache the old Value and store the newValue instead
	local storedData = dataTable.storedData
	local dataEntry = storedData[itemName] or {}
	local oldValue = dataEntry[key]
	dataEntry[key] = newValue
	storedData[itemName] = dataEntry

	if oldValue == newValue then return end

	-- Get all callbacks
	local accessName = dataTable.accessName
	local cache = callbackCache[accessName]

	if not cache then return end

	-- Call all callbacks
	local itemNameTable = {itemName, allCallbackString}
	for i = 1, #itemNameTable do
		local tempItemName = itemNameTable[i]

		local funcCache = cache[tempItemName]

		if not istable(funcCache) then continue end

		local keyTable = {key, allCallbackString}
		for j = 1, #keyTable do
			local tempKey = keyTable[j]

			local funcKeyCache = funcCache[tempKey]

			if not istable(funcKeyCache) then continue end

			-- Execute callbacks
			for identifier, functions in pairs(funcKeyCache) do
				for k = 1, #functions do
					local func = functions[k]

					if not isfunction(func) then continue end

					func(accessName, itemName, key, oldValue, newValue)
				end
			end
		end
	end
end

---
-- Resets the database by returning all values to the default
-- This is called when a global reset for the given database is done.
-- @param number index the local index of the database
-- @realm shared
-- @internal
local function ResetDatabase(index)
	local dataTable = registeredDatabases[index]

	if dataTable and not table.IsEmpty(dataTable.storedData) then
		for itemName, keys in pairs(dataTable.storedData) do
			for key in pairs(keys) do
				OnChange(index, itemName, key, database.GetDefaultValue(dataTable.accessName, itemName, key))
			end
		end
	end
end

---
-- Adds a callback to be called when the given sql table entries change
-- @note itemName and key can both be `nil`. The callback function then gets called on a change of every item or every key
-- @param string accessName the chosen accessName registered for a given database. HAS NOT TO BE the real database-name! And does not have to be registered yet!
-- @param[opt] string itemName The name of the item in the database. Leave `nil` if you want a callback for every item
-- @param[opt] string key The name of the key in the database. Leave `nil` if you want a callback for every key
-- @param function The callback function(accessName, itemName, key, oldValue, newValue), it's only called if the value actually changed
-- @param[opt] string identifier An identifier by which you can remove the callback more granular
-- @realm shared
function database.AddChangeCallback(accessName, itemName, key, callback, identifier)
	-- Allow every accessName in case the database is only later registered
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

	-- Save callback in cache
	local cache = callbackCache[accessName] or {}

	cache[itemName] = cache[itemName] or {}
	cache[itemName][key] = cache[itemName][key] or {}
	cache[itemName][key][identifier] = cache[itemName][key][identifier] or {}
	cache[itemName][key][identifier][#cache[itemName][key][identifier] + 1] = callback

	callbackCache[accessName] = cache

	-- Index identifiers for faster removal access later
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
-- @param[opt] string itemName The name of the item in the database. Leave `nil` if you want to remove callbacks for every item with the given identifier
-- @param[opt] string key The name of the key in the database. Leave `nil` if you want to remove callbacks for every key with the given identifier
-- @param[opt] string identifier The identifier by which the callbacks to remove are filtered
-- @realm shared
function database.RemoveChangeCallback(accessName, itemName, key, identifier)
	callbacks = callbackIdentifiers[identifier]

	if not accessName or not istable(callbacks) then return end

	local cache = callbackCache[accessName]

	if not istable(cache) then return end

	-- If no itemName is given, remove callbacks of all items
	local skipWrongItemName = true
	if not isstring(itemName) then
		skipWrongItemName = false
	end

	-- If no key is given, remove callbacks of all keys of the item	
	local skipWrongKey = true
	if not isstring(key) then
		skipWrongKey = false
	end

	for i = #callbacks, 1, -1  do
		callback = callbacks[i]

		-- AccesName has to be the same, because registrating callbacks for all sql tables is not allowed
		if callback.accessName ~= accessName then continue end

		-- If neither itemName nor the key fit, skip that callback unless you want to remove all
		local cItemName = callback.itemName
		if cItemName ~= itemName and skipWrongItemName then continue end

		local cKey = callback.key
		if cKey ~= key and skipWrongKey then continue end

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

	-- If no callbacks for that identifier are left, delete it
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

---
-- Send and receive functions ordered by message Enums
-- To be able to directly see message sending- and receive-structure between server and client
-- They are always paired by either client-Send and server-Receive or server-Send and client-Receive

-- Client send and receive functions
local clientSendFunctions = {}
local clientReceiveFunctions = {}

-- Server send and receive functions
local serverSendFunctions = {}
local serverReceiveFunctions = {}

---
-- Send query for registered databases to server
-- @param table data contains only the messageIdentifier here
-- @realm client
-- @internal
clientSendFunctions[MESSAGE_REGISTER] = function(data)
	net.WriteUInt(data, uIntBits)
end

---
-- Receive query for registered databases from client
-- and sync them
-- @param string plyID64 the playerID64 of the player who sent the message
-- @realm server
-- @internal
serverReceiveFunctions[MESSAGE_REGISTER] = function(plyID64)
	database.SyncRegisteredDatabases(plyID64, net.ReadUInt(uIntBits))
end

---
-- Send requested registered databases to client
-- @param table data contains identifier, tableCount, index here
-- @realm server
-- @internal
serverSendFunctions[MESSAGE_REGISTER] = function(data)
	local databaseInfo = registeredDatabases[data.index]

	net.WriteUInt(data.index, uIntBits)
	net.WriteString(databaseInfo.accessName)
	net.WriteTable(databaseInfo.keys)
	net.WriteTable(databaseInfo.data)

	-- AdditionalInfo determines if there is more than one database registered and sent
	-- This makes sure, that the client doesnt start to use the databases before all databases are received
	local sendAdditionalInfo = data.identifier ~= nil

	net.WriteBool(sendAdditionalInfo)

	if sendAdditionalInfo then
		net.WriteUInt(data.identifier, uIntBits)
		net.WriteUInt(data.tableCount, uIntBits)
	end
end

---
-- Receive requested registered databases from server
-- and cache them as well as call all cached functions, that are waiting for the databases
-- @realm client
-- @internal
clientReceiveFunctions[MESSAGE_REGISTER] = function()
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

	-- If more than one database will be send, then sentAdditionalInfo is true
	local sentAdditionalInfo = net.ReadBool()

	if sentAdditionalInfo then
		local identifier = net.ReadUInt(uIntBits)
		local tableCount = net.ReadUInt(uIntBits)

		-- Only call the cached functions, when all databases are succesfully registered clientside
		if table.Count(registeredDatabases) == tableCount then
			functionCache[identifier]()
		end
	end
end

---
-- Send query for getting a value to server
-- @param table data contains only the messageIdentifier here
-- @realm client
-- @internal
clientSendFunctions[MESSAGE_GET_VALUE] = function(data)
	local request = requestCache[data]

	net.WriteUInt(data, uIntBits)
	net.WriteUInt(request.index, uIntBits)

	net.WriteString(request.itemName)
	net.WriteString(request.key)
end

---
-- Receive query for getting a value from client
-- and returning it
-- @param string plyID64 the playerID64 of the player who sent the message
-- @realm server
-- @internal
serverReceiveFunctions[MESSAGE_GET_VALUE] = function(plyID64)
	local data = {
		plyID64 = plyID64,
		identifier = net.ReadUInt(uIntBits),
		index = net.ReadUInt(uIntBits)
	}

	data.itemName = net.ReadString()
	data.key = net.ReadString()

	database.ReturnGetValue(data)
end

---
-- Send requested value to client
-- if available/isSuccess
-- @param table data contains identifier, isSuccess and value here
-- @realm server
-- @internal
serverSendFunctions[MESSAGE_GET_VALUE] = function(data)
	net.WriteUInt(data.identifier, uIntBits)
	net.WriteBool(data.isSuccess)

	if data.isSuccess then
		net.WriteString(tostring(data.value))
	end
end

---
-- Receive requested value from server
-- Store it, mark value as received and call function cache
-- @realm client
-- @internal
clientReceiveFunctions[MESSAGE_GET_VALUE] = function()
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

	ValueReceived(request.index, request.itemName, request.key)
	functionCache[identifier](isSuccess, value)
end

---
-- Send query for setting a value to server
-- @param table data contains index, itemName, key and value here
-- @realm client
-- @internal
clientSendFunctions[MESSAGE_SET_VALUE] = function(data)
	net.WriteUInt(data.index, uIntBits)
	net.WriteString(data.itemName)
	net.WriteString(data.key)
	net.WriteString(tostring(data.value))
end

---
-- Receive query for setting a value from client
-- and set that value in the database if player is a superadmin
-- @param string plyID64 the playerID64 of the player who sent the message
-- @realm server
-- @internal
serverReceiveFunctions[MESSAGE_SET_VALUE] = function(plyID64)
	local index = net.ReadUInt(uIntBits)
	local itemName = net.ReadString()
	local key = net.ReadString()
	local value = net.ReadString()

	local accessName = registeredDatabases[index].accessName
	value = database.ConvertValueWithKey(value, accessName, key)

	database.SetValue(accessName, itemName, key, value, plyID64)
end

---
-- Send set value to client
-- @param table data contains index, itemName, key, value here
-- @realm server
-- @internal
serverSendFunctions[MESSAGE_SET_VALUE] = function(data)
	net.WriteUInt(data.index, uIntBits)
	net.WriteString(data.itemName)
	net.WriteString(data.key)
	net.WriteString(tostring(data.value))
end

clientReceiveFunctions[MESSAGE_SET_VALUE] = function()
	local index = net.ReadUInt(uIntBits)
	local itemName = net.ReadString()
	local key = net.ReadString()
	local value = net.ReadString()

	value = database.ConvertValueWithKey(value, registeredDatabases[index].accessName, key)
	OnChange(index, itemName, key, value)
	ValueReceived(index, itemName, key)
end

---
-- Send query for resetting the database to server
-- @param table data contains index
-- @realm client
-- @internal
clientSendFunctions[MESSAGE_RESET] = function(data)
	net.WriteUInt(data.index, uIntBits)
end

---
-- Receive query for resetting the database from client
-- @param string plyID64 the playerID64 of the player who sent the message
-- @realm server
-- @internal
serverReceiveFunctions[MESSAGE_RESET] = function(plyID64)
	database.Reset(registeredDatabases[net.ReadUInt(uIntBits)].accessName, plyID64)
end

---
-- Send reset command to client
-- To make sure the client resets all stored values to the default
-- @param table data contains index
-- @realm server
-- @internal
serverSendFunctions[MESSAGE_RESET] = function(data)
	net.WriteUInt(data.index, uIntBits)
end

---
-- Receive reset command from server
-- Reset all stored values back to the defaults
-- @realm client
-- @internal
clientReceiveFunctions[MESSAGE_RESET] = function()
	ResetDatabase(net.ReadUInt(uIntBits))
end

---
-- Send query for getting a default value to server
-- @warning This function is not yet implemented
-- as currently all key- and item-specific default values are automatically synced
-- @param table data contains nothing yet
-- @realm client
-- @internal
clientSendFunctions[MESSAGE_GET_DEFAULTVALUE] = function(data)
	ErrorNoHalt("[TTT2] MESSAGE_GET_DEFAULTVALUE as client send function to request default values is not implemented yet.")
end

---
-- Receive query for getting a default value from client
-- @warning This function is not yet implemented
-- as currently all key- and item-specific default values are automatically synced
-- @param string plyID64 the playerID64 of the player who sent the message
-- @realm server
-- @internal
serverReceiveFunctions[MESSAGE_GET_DEFAULTVALUE] = function(plyID64)
	ErrorNoHalt("[TTT2] MESSAGE_GET_DEFAULTVALUE as server receive function for requested default values is not implemented yet.")
end

---
-- Send requested default values to client
-- Can either be a single value or a table
-- @param table data contains index, itemName, key, value, sendTable and defaultData here
-- @realm server
-- @internal
serverSendFunctions[MESSAGE_GET_DEFAULTVALUE] = function(data)
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

---
-- Receive requested default values from server
-- and cache it
-- @realm client
-- @internal
clientReceiveFunctions[MESSAGE_GET_DEFAULTVALUE] = function()
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

-- Put local functions into global table clientside
if CLIENT then
	sendDataFunctions = clientSendFunctions
	receiveDataFunctions = clientReceiveFunctions
end

-- Put local functions into global table serverside
if SERVER then
	sendDataFunctions = serverSendFunctions
	receiveDataFunctions = serverReceiveFunctions
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
	if len < 1 then return end

	local plyID64

	if SERVER and ply:IsValid() then
		plyID64 = ply:SteamID64()
		playerID64Cache[plyID64] = ply
	elseif SERVER then
		return
	end

	-- As size is unclear at start of the message and `net.BytesLeft` is not working
	-- we instead always check if there is more to send with booleans
	local continueReading = net.ReadBool()

	while continueReading do
		local identifier = net.ReadUInt(uIntBits)
		local readNextValue = net.ReadBool()

		while readNextValue do
			receiveDataFunctions[identifier](plyID64)
			readNextValue = net.ReadBool()
		end

		continueReading = net.ReadBool()
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

	-- Send one message per plyIdentifier
	-- This can either be a limited playerList or just one player
	local plyDeleteIdentifiers = {}
	for plyIdentifier, identifierList in pairs(dataStore) do
		net.Start("TTT2SynchronizeDatabase")

		-- Then go through all message identifiers and their cached data
		-- and send them accordingly
		local stopSending = false
		local deleteIdentifiers = {}
		for identifier, indexedData in pairs(identifierList) do
			net.WriteBool(true)
			net.WriteUInt(identifier, uIntBits)
			net.WriteBool(#indexedData > 0)

			-- Add data to one message as long as `net.BytesWritten` are not exceeding the limit
			-- Use bools to determine the end as `net.BytesLeft` is not working and we dont know the size before this loop
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

		-- Delete the cache of data that was already sent
		for identifier in pairs(deleteIdentifiers) do
			dataStore[plyIdentifier][identifier] = nil
		end

		if #identifierList <= 0 then
			plyDeleteIdentifiers[plyIdentifier] = true
		end

		-- If data was left, send them next frame
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
-- @param[opt] string plyIdentifier (serverside-only) the player identifier to determine who receives the message, defined in `SEND_TO_PLY_`-enums or can be a plyID64
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
	-- Is automatically called internally when a client joins, can be called by a player to force an update, but is normally not necessary
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

			-- In case the database wasnt registered, try to get it and then send the requests again later
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

		-- Use cached data if value was received from the server
		if IsValueReceived(index, itemName, key) then
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
	-- Request to set the value for a key of an item of an sql-table on the server
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

	---
	-- Request to reset the database on the server
	-- @param string accessName the chosen networkable name of the sql table
	-- @realm client
	function database.Reset(accessName)
		local index = nameToIndex[accessName]

		if not index then
			ErrorNoHalt("[TTT2] database.Reset failed. The registered Database of " .. accessName .. " is not available or synced.")

			return
		end

		SendUpdateNextTick(MESSAGE_RESET, {index = index})
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
	-- Checks if the player has the necessary accessLevel
	-- @note Only Admins can write to the database, no matter the accessLevel
	-- @param number index the local index of the database
	-- @param[opt] string plyID64 the player steam ID 64. Leave this empty when calling on the server. This only makes sure values are only set by superadmins
	-- @return bool, bool hasReadAccess, hasWriteAccess, if the player can read from or write to the database
	-- @realm server
	-- @internal
	local function hasAccessToDatabase(index, plyID64)
		local isAdmin = false
		local isServer = true

		if plyID64 and playerID64Cache[plyID64] then
			---
			-- @realm server
			isAdmin = hook.Run("TTT2AdminCheck", playerID64Cache[plyID64])
			isServer = false
		end

		if isServer then return true, true end

		local accessLevelNeeded = registeredDatabases[index].accessLevel

		local hasAdminAccess = isAdmin and accessLevelNeeded >= TTT2_DATABASE_ACCESS_ADMIN
		local hasReadAccess = hasAdminAccess or accessLevelNeeded > TTT2_DATABASE_ACCESS_ADMIN

		return hasReadAccess, hasAdminAccess
	end

	---
	-- Synchronizes all registered Databases with the given players defined by the plyIdentifier
	-- @note This is used internally to sync between server and client, you dont need to call it manually
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

			-- Also sync registered item-specific defaults if available
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
	-- Call this when you want to setup a database that needs to be accessible by server and client
	-- If you dont call this function before anything else, it wont work. Choose any name as accessName so that others can easily use it.
	-- @param string databaseName the real name of the database
	-- @param string accessName the name to quickly access databases and differentiate between a pseudo used accessName and the migrated actual databaseName
	-- @param table savingKeys the savingKeys = {keyName = {typ, bits, default, ..}, ..} defining the keyNames and their information
	-- @param[default = TTT2_DATABASE_ACCESS_ADMIN] number accessLevel the access level needed to get values of a database, defined in `TTT2_DATABASE_ACCESS_`-enums (_ANY, _ADMIN, _SERVER)
	-- @note If accessLevel is set to TTT2_DATABASE_ACCESS_SERVER it fully prevents any client read- and write-access, whereas TTT2_DATABASE_ACCESS_ANY only gives read-, but not write-access to anyone
	-- @param[opt] table additionalData the data that doesnt belong to a database but might be needed for other purposes like enums
	-- @return bool isSuccessful if the database exists and is successfully registered
	-- @realm server
	function database.Register(databaseName, accessName, savingKeys, accessLevel, additionalData)
		accessLevel = accessLevel or TTT2_DATABASE_ACCESS_ADMIN

		-- Create Sql table if not already done
		if not sql.CreateSqlTable(databaseName, savingKeys) or not isstring(accessName) then
			return false
		end

		-- Return if already registered
		if nameToIndex[accessName] then
			return true
		end

		databaseCount = databaseCount + 1

		registeredDatabases[databaseCount] = {
			accessName = accessName,
			accessLevel = accessLevel,
			databaseName = databaseName,
			orm = orm.Make(databaseName),
			keys = savingKeys or {},
			data = additionalData or {},
			storedData = {},
			defaultData = {}
		}
		nameToIndex[accessName] = databaseCount

		local data = {index = databaseCount}

		SendUpdateNextTick(MESSAGE_REGISTER, data, SEND_TO_PLY_ALL)

		return true
	end

	---
	-- This is called upon receiving a get request from a player to send a value back
	-- @warning Dont use this function if you want to get a value from the database, this is meant to be used internally for a client request
	-- @param table requestData = {plyID64, identifier, index, itemName, key} contains player and the data they requested
	-- @realm server
	-- @internal
	function database.ReturnGetValue(requestData)
		local index = requestData.index
		local accessName = index and registeredDatabases[index] and registeredDatabases[index].accessName

		local plyID64 = requestData.plyID64
		local hasReadAccess, _ = hasAccessToDatabase(index, plyID64)

		local value
		local isSuccess = false

		if hasReadAccess and accessName then
			isSuccess, value = database.GetValue(accessName, requestData.itemName, requestData.key)
		end

		local serverData = {
			identifier = requestData.identifier,
			isSuccess = isSuccess,
			value = value
		}

		RegisterPlayer(plyID64)

		SendUpdateNextTick(MESSAGE_GET_VALUE, serverData, plyID64)
	end

	---
	-- Get the stored key value of the given database if it exists and was registered
	-- @note While itemName and key are optional, leaving them out only gets the saved and converted sql Tables, they dont include every possible item with their default values.
	-- So to get default Values you have to specify itemName and key. This is designed to be used for single requests.
	-- @param string accessName the chosen networkable name of the sql table
	-- @param[opt] string itemName the name or primaryKey of the item inside of the sql table, if not given selects whole sql table
	-- @param[opt] string key the name of the key in the database, is ignored when no itemName is given, if not given selects whole item
	-- @return bool, if the requested item and/or key was successfully registered in the sql datatable
	-- @return any, the value that was saved in the database or the default
	-- @realm server
	function database.GetValue(accessName, itemName, key)
		local index = nameToIndex[accessName]

		if not index then
			ErrorNoHalt("[TTT2] database.GetValue failed. The registered Database of " .. accessName .. " is not registered.")

			return false
		end

		local dataTable = index and registeredDatabases[index]

		-- If itemName and key are given but the key is not registered, throw an error
		if itemName and key and not dataTable.keys[key] then
			ErrorNoHalt("[TTT2] database.GetValue failed. The registered Database of " .. accessName .. " doesnt have a key named " .. key)

			return false
		end

		-- Get storedValues first if a concrete item-key pair is given
		if isstring(itemName) and isstring(key) then
			local storedValue = dataTable.storedData[itemName] and dataTable.storedData[itemName][key]

			if storedValue ~= nil then
				return true, storedValue
			end
		end

		local sqlData

		if itemName then
			-- Find saved item data
			sqlData = dataTable.orm:Find(itemName)

			if key then
				-- Get the specific key data
				local value = sqlData and database.ConvertValueWithKey(sqlData[key], accessName, key)

				-- Get default values if no value was saved
				if value == nil then
					value = database.GetDefaultValue(accessName, itemName, key)
				end

				dataTable.storedData[itemName] = dataTable.storedData[itemName] or {}
				dataTable.storedData[itemName][key] = value

				return true, value
			end

			database.ConvertTable(sqlData, accessName)
			dataTable.storedData[itemName] = sqlData
		else
			-- Get all data, convert and return it
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

		return istable(sqlData), sqlData
	end

	---
	-- Get the stored table database if it exists and was registered
	-- @note Only gets the saved and converted sql Tables, they dont include every possible item with their default values.
	-- @param string accessName the chosen networkable name of the sql table
	-- @return bool, if the requested table was successfully registered in the sql datatable
	-- @return table datatable that was saved
	-- @realm server
	function database.GetTable(accessName)
		return database.GetValue(accessName)
	end

	---
	-- Set the value for a key of an item of an sql-table
	-- also sends it to the clients
	-- @note It is restricted to players with TTT2_DATABASE_ACCESS_ADMIN or higher at all times
	-- @param string accessName the chosen networkable name of the sql table
	-- @param string itemName the name or primaryKey of the item inside of the sql table
	-- @param string key the name of the key in the database
	-- @param any value the value you want to set in the database
	-- @param[opt] string plyID64 the player steam ID 64. Leave this empty when calling on the server. This only makes sure values are only set by superadmins
	-- @realm server
	function database.SetValue(accessName, itemName, key, value, plyID64)
		local index = nameToIndex[accessName]

		if not index then
			ErrorNoHalt("[TTT2] database.SetValue failed. The registered Database of " .. accessName .. " is not registered.")

			return
		end

		local _, hasWriteAccess = hasAccessToDatabase(index, plyID64)

		if not hasWriteAccess then
			ErrorNoHalt("[TTT2] database.SetValue failed. The player with the ID64 " .. plyID64 .. " has no write access to the database " .. accessName .. " .")

			return
		end

		local dataTable = registeredDatabases[index]

		if not dataTable.keys[key] then
			ErrorNoHalt("[TTT2] database.SetValue failed. The registered Database of " .. accessName .. " doesnt have a key named " .. key)

			return
		end

		local saveValue = value

		-- If the value is just the default, then delete it from the sql database by setting it nil
		if saveValue == database.GetDefaultValue(accessName, itemName, key) then
			saveValue = nil
		end

		local itemPoolModel = dataTable.orm

		local item = itemPoolModel:Find(itemName)

		if not item then
			item = itemPoolModel:New({
				name = itemName,
			})
		end

		item[key] = saveValue

		if saveValue ~= nil then
			item:Save()
		else
			database.ConvertTable(item, accessName)

			local isNil = true

			-- Check if there is still a value saved for any of the keys
			for curKey in pairs(dataTable.keys) do
				if item[curKey] ~= nil then
					isNil = false

					break
				end
			end

			-- Delete the item if there is nothing to save
			if isNil then
				item:Delete()
			end
		end

		OnChange(index, itemName, key, value)

		SendUpdateNextTick(MESSAGE_SET_VALUE, {index = index, itemName = itemName, key = key, value = value}, SEND_TO_PLY_REGISTERED)
	end

	---
	-- Use this to set item-specific defaults, to save storage space in the sql database
	-- also syncs this to the clients
	-- @note You dont need to check manually if it is a key-specific default. They are excluded anyways
	-- @param string accessName the chosen networkable name of the sql table
	-- @param string itemName the name or primaryKey of the item inside of the sql table
	-- @param string key the name of the key in the database
	-- @param any value the value you want to set in the database
	-- @realm server
	function database.SetDefaultValue(accessName, itemName, key, value)
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

		-- Ignore it if this is the key-default anyways
		if value == dataTable.keys[key].default then return end

		local defaultData = dataTable.defaultData
		defaultData[itemName] = defaultData[itemName] or {}
		defaultData[itemName][key] = value

		dataTable.defaultData = defaultData

		SendUpdateNextTick(MESSAGE_GET_DEFAULTVALUE, {index = index, itemName = itemName, key = key, value = value, sendTable = false}, SEND_TO_PLY_REGISTERED)
	end

	---
	-- Reset the database and send a message to the client
	-- @note It is restricted to players with TTT2_DATABASE_ACCESS_ADMIN or higher at all times
	-- @param string accessName the chosen networkable name of the sql table
	-- @param[opt] string plyID64 the player steam ID 64. Leave this empty when calling on the server. This only makes sure values are only set by superadmins 
	-- @realm server
	function database.Reset(accessName, plyID64)
		local index = nameToIndex[accessName]

		if not index then
			ErrorNoHalt("[TTT2] database.Reset failed. The registered Database of " .. accessName .. " is not available or synced.")

			return
		end

		local _, hasWriteAccess = hasAccessToDatabase(index, plyID64)

		if not hasWriteAccess then
			ErrorNoHalt("[TTT2] database.Reset failed. The player with the ID64 " .. plyID64 .. " has no write access to the database " .. accessName .. " .")

			return
		end

		local dataTable = registeredDatabases[index]
		local databaseName = dataTable.databaseName

		-- Drop the table and create a new one as well as an orm-object
		sql.DropTable(databaseName)
		sql.CreateSqlTable(databaseName, dataTable.keys)
		dataTable.orm = orm.Make(databaseName)

		ResetDatabase(index)

		SendUpdateNextTick(MESSAGE_RESET, {index = index}, SEND_TO_PLY_REGISTERED)
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
