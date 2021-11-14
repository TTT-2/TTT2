---
-- A module that contains all functions related to playermodels
-- @author Mineotopia

if SERVER then
	AddCSLuaFile()

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

local initialDefaultStates = {
	selected = {
		["css_phoenix"] = true,
		["css_arctic"] = true,
		["css_guerilla"] = true,
		["css_leet"] = true
	},
	hattable = {
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
}

playermodels = playermodels or {}

playermodels.accessName = "Playermodel_Pool"
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
	selected = "selected",
	hattable = "hattable"
}

---
-- Updates the given value state of a provided playermodel.
-- @param string name The name of the model
-- @param string valueName The name of the variable to change. See `playermodels.state` for listed names
-- @param boolean state The selection state, `true` to enable the model
-- @realm shared
function playermodels.UpdateModel(name, valueName, state)
	if playermodels.defaultModelStates[name][valueName] == state then
		state = nil
	end

	database.SetValue(playermodels.accessName, name, valueName, state)
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
-- @warning As client you must give an OnReceiveFunction as data might be gathered from the server first
-- @param string name The name of the model
-- @param[opt] function OnReceiveFunc(value) only for the client the function to be called with the returned value if the model is selectable
-- @return[opt] boolean Returns true, if the model is in the selection pool on the server only
-- @realm shared
function playermodels.IsSelectedModel(name, OnReceiveFunc)
	local defaultValue = database.GetDefaultValue(playermodels.accessName, name, "selected")

	local _, isSelected = database.GetValue(playermodels.accessName, name, "selected", function(databaseExists, value)
		if not databaseExists or value == nil then
			value = defaultValue
		end

		OnReceiveFunc(value)
	end)

	if SERVER then
		if isSelected == nil then
			isSelected = defaultValue
		end

		return isSelected
	end
end

---
-- Checks if a provided model is hattable.
-- @warning As client you must give an OnReceiveFunction as data might be gathered from the server first
-- @param string name The name of the model
-- @param[opt] function OnReceiveFunc(value) only for the client  the function to be called with the returned value if the model is hattable
-- @return[opt] boolean Returns true, if the model is hattable on the server only
-- @realm shared
function playermodels.IsHattableModel(name, OnReceiveFunc)
	local defaultValue = database.GetDefaultValue(playermodels.accessName, name, "hattable")

	local _, isHattable = database.GetValue(playermodels.accessName, name, "hattable", function(databaseExists, value)
		if not databaseExists or value == nil then
			value = defaultValue
		end

		OnReceiveFunc(value)
	end)

	if SERVER then
		if isHattable == nil then
			isHattable = defaultValue
		end

		return isHattable
	end
end

function playermodels.AddChangeCallback(modelName, valueName, callback, identifier)
	database.AddChangeCallback(playermodels.accessName, modelName, valueName, function(accessName, itemName, key, oldValue, newValue)
		if newValue == nil then
			newValue = playermodels.defaultModelStates[modelName][valueName]
		end

		callback(newValue)
	end,
	identifier)
end

function playermodels.RemoveChangeCallback(modelName, valueName, identifier)
	database.RemoveChangeCallback(playermodels.accessName, modelName, valueName, identifier)
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
	net.ReceiveStream("TTT2StreamDefaultModelTable", function(data)
		playermodels.defaultModelStates = data
		playermodels.modelStates = tableCopy(data)
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
	end)

	-- all the remaining functions are server only
	return
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
	if not database.Register(playermodels.sqltable, playermodels.accessName, playermodels.savingKeys) then
		return false
	end

	local data = playermodels.modelStates or {}
	local defaultData = {}
	local _, changedData = database.GetTable(playermodels.accessName)

	for name in pairs(playerManagerAllValidModels()) do
		defaultData[name] = {}
		data[name] = data[name] or {}

		for key, defaultStates in pairs(initialDefaultStates) do
			local state = defaultStates[name]
			defaultData[name][key] = state or false

			if changedData[name] and changedData[name][key] ~= nil then
		 		data[name][key] = changedData[name][key]
			else
				data[name][key] = state or false
			end

			if state ~= nil then
				database.SetDefaultValue(playermodels.accessName, name, key, state)
			end
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
		return ply:IsSuperAdmin()
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

net.Receive("TTT2ResetPlayerModels", function(_, ply)
	if not IsValid(ply) or not ply:IsSuperAdmin() then return end

	playermodels.Reset()
end)
