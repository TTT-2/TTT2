---
-- A module that contains all functions related to playermodels
-- @author Mineotopia

if SERVER then
	AddCSLuaFile()

	util.AddNetworkString("TTT2UpdatePlayerModel")
	util.AddNetworkString("TTT2UpdateChangedPlayerModel")
	util.AddNetworkString("TTT2ResetPlayerModels")
end

local pairs = pairs
local playerManagerAllValidModels = player_manager.AllValidModels
local playerManagerTranslateToPlayerModelName = player_manager.TranslateToPlayerModelName
local utilPrecacheModel = util.PrecacheModel
local mathRandom = math.random
local stringLower = string.lower
local tableCopy = table.Copy

local function GetPlayerSize(ply)
	local bottom, top = ply:GetHull()

	return top - bottom
end

---
-- @realm server
local cvCustomModels = CreateConVar("ttt2_use_custom_models", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

local initialModels = {
	["css_phoenix"] = true,
	["css_arctic"] = true,
	["css_guerilla"] = true,
	["css_leet"] = true
}

local initialHattableModels = {
	["css_phoenix"] = true,
	["css_arctic"] = true,
	["monk"] = true,
	["female01"] = true,
	["female02"] = true,
	["female03"] = true,
	["female04"] = true,
	["female05"] = true,
	["female06"] = true,
	["male01"] = true,
	["male02"] = true,
	["male03"] = true,
	["male04"] = true,
	["male05"] = true,
	["male06"] = true,
	["male07"] = true,
	["male08"] = true,
	["male09"] = true
}

-- Increase this when more values are given
-- (2 ^ bitCount) - 1 is the maximum number that can be sent
local bitCount = 2

playermodels = playermodels or {}

playermodels.sqltable = "ttt2_playermodel_pool_changes"
playermodels.savingKeys = {
	selected = {typ = "bool", default = false},
	hattable = {typ = "bool", default = false}
}

playermodels.fallbackModel = "models/player/phoenix.mdl"

playermodels.modelStates = playermodels.modelStates or {}
playermodels.defaultModelStates = playermodels.defaultModelStates or {}
playermodels.changedModelStates = playermodels.changedModelStates or {}

-- Enums for the states
playermodels.state = {
	selected = 1,
	hattable = 2
}

-- Are automatically constructed on first use
-- playermodels.stateNames = { [1] = "selected" ...}

---
-- Updates the given value state of a provided playermodel.
-- @param string name The name of the model
-- @param number valueEnum The enum of the variable to change. See `playermodels.state` for listed enums
-- @param boolean state The selection state, `true` to enable the model
-- @realm shared
function playermodels.UpdateModel(name, valueEnum, state)
	if SERVER then
		local valueName = playermodels.GetStringFromEnum(valueEnum)

		playermodels.modelStates[name][valueName] = state
		playermodels.changedModelStates[name] = playermodels.changedModelStates[name] or {}

		local changedData = playermodels.changedModelStates[name]

		if playermodels.defaultModelStates[name][valueName] == state then
			changedData[valueName] = nil
		else
			changedData[valueName] = state
		end

		local playermodelPoolModel = orm.Make(playermodels.sqltable)
		local playermodelObject = playermodelPoolModel:Find(name)

		if not playermodelObject then
			playermodelObject = playermodelPoolModel:New({
				name = name
			})
		end

		playermodelObject[valueName] = changedData[valueName]

		if table.IsEmpty(changedData) then
			playermodelObject:Delete()
			playermodels.changedModelStates[name] = nil
		else
			playermodelObject:Save()
			playermodels.changedModelStates[name] = changedData
		end

		playermodels.StreamModelStateToSelectedClients(true)
	else -- CLIENT
		net.Start("TTT2UpdatePlayerModel")
		net.WriteString(name)
		net.WriteUInt(valueEnum, bitCount)
		net.WriteBool(state or false)
		net.SendToServer()
	end
end

---
-- Converts the given enum to a string and also creates a fast lookup table
-- @param number stateEnum The enum to be converted. See `playermodels.state` for listed enums
-- @return string stateName returns the name of the given enum
-- @realm shared
function playermodels.GetStringFromEnum(stateEnum)
	if not playermodels.stateNames then
		playermodels.stateNames = {}

		for name, enum in pairs(playermodels.state) do
			playermodels.stateNames[enum] = name
		end
	end

	return playermodels.stateNames[stateEnum]
end

---
-- Returns an indexed table with all the models states that are stored
-- @note While this function is shared, the data is only available for superadmin on the
-- client, if no manual sync is triggered.
-- @return table An hashed table with all the model data stored in the database
-- @realm shared
function playermodels.GetModelStates()
	return playermodels.modelStates or {}
end

---
-- Checks if a provided model is in the selection pool.
-- @note While this function is shared, the data is only available for superadmin on the
-- client, if no manual sync is triggered.
-- @param string name The name of the model
-- @return boolean Returns true, if the model is in the selection pool
-- @realm shared
function playermodels.IsSelectedModel(name)
	local models = playermodels.modelStates

	if not models or not models[name] then
		return false
	end

	return models[name].selected or false
end

---
-- Checks if a provided model is hattable.
-- @note While this function is shared, the data is only available for superadmin on the
-- client, if no manual sync is triggered.
-- @param string name The name of the model
-- @return boolean Returns true, if the model is hattable
-- @realm shared
function playermodels.IsHattableModel(name)
	local models = playermodels.modelStates

	if not models or not models[name] then
		return false
	end

	return models[name].hattable or false
end

---
-- Reset all selected playermodels, hattability and reinitialize the database.
-- @realm shared
function playermodels.Reset()
	if SERVER then
		-- in the first step the database is deleted
		sql.DropTable(playermodels.sqltable)

		-- then the table is reinitialized
		playermodels.Initialize()

		-- this data then has to be synced to the client again
		playermodels.StreamModelStateToSelectedClients()
	else
		net.Start("TTT2ResetPlayerModels")
		net.SendToServer()
	end
end

if CLIENT then
	local callbackCache = {}

	net.ReceiveStream("TTT2StreamDefaultModelTable", function(data)
		playermodels.defaultModelStates = data
		playermodels.modelStates = tableCopy(data)

		for _, Callback in pairs(callbackCache) do
			Callback(data)
		end
	end)

	net.ReceiveStream("TTT2StreamChangedModelTable", function(data)
		local dataValue

		for name, values in pairs(playermodels.defaultModelStates) do
			for valueName, value in pairs(values) do
				playermodels.modelStates[name] = playermodels.modelStates[name] or {}
				dataValue = data[name] and data[name][valueName]

				if dataValue == nil then
					dataValue = value
				end

				playermodels.modelStates[name][valueName] = dataValue
				playermodels.modelStates[name].sortName = stringLower(name)
			end
		end

		for _, Callback in pairs(callbackCache) do
			Callback(playermodels.modelStates)
		end
	end)

	---
	-- Used to add a function to the callback stack that is called when a change
	-- is made on the server. The first argument of the Callback function is the
	-- new data.
	-- @param string name The unique callback identifier
	-- @param function Callback The callback function that should be added
	-- @realm client
	function playermodels.OnChange(name, Callback)
		callbackCache[name] = Callback
	end

	-- all the remaining functions are server only
	return
end

---
-- Returns an indexed table with all the changed models states that are stored
-- in the database.
-- @return table A hashed table with all the model data stored in the database
-- @realm server
function playermodels.ReadChangedModelStatesSQL()
	local sqlTable = orm.Make(playermodels.sqltable)

	local data = sqlTable:All()
	local hashableData = {}

	for i = 1, #data do
		local entry = data[i]
		local name = entry.name

		hashableData[name] = {}

		for key, info in pairs(playermodels.savingKeys) do
			local value = entry[key]

			if value == "nil" or value == "NULL" then continue end

			if info.typ == "bool" then
				hashableData[name][key] = tobool(value)
			elseif info.typ == "number" then
				hashableData[name][key] = tonumber(value)
			else
				hashableData[name][key] = value
			end
		end
	end

	return hashableData
end

---
-- Returns an indexed table with all the models that are in the selection pool.
-- @return table An indexed table with all selected player models
-- @realm server
function playermodels.GetSelectedModels()
	local playerModelPoolNames = {}

	for name, values in pairs(playermodels.modelStates) do
		if values.selected then
			playerModelPoolNames[#playerModelPoolNames + 1] = name
		end
	end

	return playerModelPoolNames
end

---
-- Initializes the modelstates. This adds all models and sets the default models to true, if it
-- is the first init on this server.
-- @internal
-- @realm server
function playermodels.Initialize()
	if not sql.CreateSqlTable(playermodels.sqltable, playermodels.savingKeys) then
		return false
	end

	local data = playermodels.modelStates or {}
	local defaultData = {}
	local changedData = playermodels.ReadChangedModelStatesSQL()

	for name in pairs(playerManagerAllValidModels()) do
		defaultData[name] = {}
		defaultData[name].selected = initialModels[name] or false
		defaultData[name].hattable = initialHattableModels[name] or false

		data[name] = data[name] or {}

		if changedData[name] and changedData[name].selected ~= nil then
		 	data[name].selected = changedData[name].selected
		else
			data[name].selected = defaultData[name].selected
		end

		if changedData[name] and changedData[name].hattable ~= nil then
		 	data[name].hattable = changedData[name].hattable
		else
			data[name].hattable  = defaultData[name].hattable
		end
	end

	playermodels.modelStates = data
	playermodels.defaultModelStates = defaultData
	playermodels.changedModelStates = changedData

	playermodels.InitializeHeadHitBoxes()

	return true
end

---
-- Tests each model for headshot hitboxes by applying it to a testing entity and then
-- checking all its bones.
-- @note Do not use before @{GM:InitPostEntity} has been called, otherwise the server will crash!
-- @realm server
function playermodels.InitializeHeadHitBoxes()
	local testingEnt = ents.Create("ttt_model_tester")

	for name, model in pairs(playerManagerAllValidModels()) do
		testingEnt:SetModel(model)

		for i = 1, testingEnt:GetHitBoxCount(0) do
			if testingEnt:GetHitBoxHitGroup(i - 1, 0) == HITGROUP_HEAD then
				playermodels.modelStates[name].hasHeadHitBox = true

				break
			end

			playermodels.modelStates[name].hasHeadHitBox = false
		end

		playermodels.defaultModelStates[name].hasHeadHitBox = playermodels.modelStates[name].hasHeadHitBox
	end

	testingEnt:Remove()
end

---
-- Streams the playermodel selection pool to clients. By default streams to all superadmin players.
-- @param bool onlyChanges if only changes should be sent, otherwise the default is sent too
-- @param[opt] table|Player plys The players that should receive the update, all superadmins if nil
-- @realm server
function playermodels.StreamModelStateToSelectedClients(onlyChanges, plys)
	plys = plys or util.GetFilteredPlayers(function(ply)
		---
		-- @realm server
		return hook.Run("TTT2AdminCheck", ply)
	end)

	if not onlyChanges then
		net.SendStream("TTT2StreamDefaultModelTable", playermodels.defaultModelStates, plys)
	end

	net.SendStream("TTT2StreamChangedModelTable", playermodels.changedModelStates, plys)
end

---
-- Precaches all valid playermodels to make sure that rendering the model can be done
-- without an initial lag. This is especially important for menus where multiple
-- models are rendered.
-- @internal
-- @realm server
function playermodels.PrecacheModels()
	for _, model in pairs(playerManagerAllValidModels()) do
		utilPrecacheModel(model)
	end
end

---
-- Selects a random playermodel from the available list of existing playermodels
-- @return Model model The selected playermodel
-- @realm server
function playermodels.GetRandomPlayerModel()
	local availableModels = playermodels.GetSelectedModels()
	local sizeAvailableModels = #availableModels

	if cvCustomModels:GetBool() and sizeAvailableModels > 0 then
		local modelPaths = playerManagerAllValidModels()
		local randomModel = availableModels[mathRandom(sizeAvailableModels)]

		return Model(modelPaths[randomModel])
	else
		return Model(playermodels.fallbackModel)
	end
end

---
-- Applies a detective hat to the provided player. Doesn't check if the player's model
-- allows a hat. Use the Filter function for this.
-- @param Player ply The player that should receive the hat
-- @param[opt] function Filter The filter function that has to return true to apply a hat
-- @realm server
function playermodels.ApplyPlayerHat(ply, Filter)
	if IsValid(ply.hat) or (isfunction(Filter) and not Filter(ply)) then return end

	local hat = ents.Create("ttt_hat_deerstalker")

	if not IsValid(hat) then return end

	hat:SetPos(ply:GetPos() + Vector(0, 0, GetPlayerSize(ply).z))
	hat:SetAngles(ply:GetAngles())
	hat:SetParent(ply)

	hat:Spawn()

	ply.hat = hat
end

---
-- Removes the detective hat from the player.
-- @param Player ply The player whose hat should be removed
-- @realm server
function playermodels.RemovePlayerHat(ply)
	if not IsValid(ply.hat) then return end

	SafeRemoveEntity(ply.hat)

	ply.hat = nil
end

---
-- Checks whether a playermodel can have a hat.
-- @param Player ply The players whose model should be checked
-- @return boolean Returns true if the player's model can have a detective hat
-- @realm server
function playermodels.PlayerCanHaveHat(ply)
	return playermodels.IsHattableModel(playerManagerTranslateToPlayerModelName(ply:GetModel()))
end

net.Receive("TTT2UpdatePlayerModel", function(_, ply)
	---
	-- @realm server
	if not IsValid(ply) or not hook.Run("TTT2AdminCheck", ply) then return end

	playermodels.UpdateModel(net.ReadString(), net.ReadUInt(bitCount), net.ReadBool())
end)

net.Receive("TTT2ResetPlayerModels", function(_, ply)
	---
	-- @realm server
	if not IsValid(ply) or not hook.Run("TTT2AdminCheck", ply) then return end

	playermodels.Reset()
end)
