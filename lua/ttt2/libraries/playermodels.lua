---
-- A module that contains all functions related to playermodels
-- @author Mineotopia

if SERVER then
	AddCSLuaFile()

	util.AddNetworkString("TTT2UpdatePlayerModelSelected")
	util.AddNetworkString("TTT2UpdatePlayerModelHattable")
	util.AddNetworkString("TTT2ResetPlayerModels")
end

local pairs = pairs
local playerManagerAllValidModels = player_manager.AllValidModels
local playerManagerTranslateToPlayerModelName = player_manager.TranslateToPlayerModelName
local utilPrecacheModel = util.PrecacheModel
local mathRandom = math.random
local stringLower = string.lower

local function GetPlayerSize(ply)
	local bottom, top = ply:GetHull()

	return top - bottom
end

playermodels = playermodels or {}
playermodels.modelStates = playermodels.modelStates or {}
playermodels.modelHasHeadHitBox = playermodels.modelHasHeadHitBox or {}

---
-- Updates the selection state of a provided playermodel. If the state is `true` the model is
-- in the playermodel selection pool.
-- @param string name The name of the model
-- @param boolean selected The selection state, `true` to enable the model
-- @realm shared
function playermodels.UpdateModelSelected(name, selected)
	if SERVER then
		local playermodelPoolModel = orm.Make(playermodels.sqltable)

		if not playermodelPoolModel then return end

		playermodelObject = playermodelPoolModel:Find(name)

		if not playermodelObject then return end

		playermodelObject.selected = selected or false
		playermodelObject:Save()

		playermodels.StreamModelStateToSelectedClients()
	else -- CLIENT
		net.Start("TTT2UpdatePlayerModelSelected")
		net.WriteString(name)
		net.WriteBool(selected or false)
		net.SendToServer()
	end
end

---
-- Updates the hattable state of a provided playermodel. If the state is `true` the model is
-- able to receive a hat.
-- @param string name The name of the model
-- @param boolean hattable The hattable state, `true` to enable hats for the model
-- @realm shared
function playermodels.UpdateModelHattable(name, hattable)
	if SERVER then
		local playermodelPoolModel = orm.Make(playermodels.sqltable)

		if not playermodelPoolModel then return end

		playermodelObject = playermodelPoolModel:Find(name)

		if not playermodelObject then return end

		playermodelObject.hattable = hattable or false
		playermodelObject:Save()

		playermodels.StreamModelStateToSelectedClients()
	else -- CLIENT
		net.Start("TTT2UpdatePlayerModelHattable")
		net.WriteString(name)
		net.WriteBool(hattable or false)
		net.SendToServer()
	end
end

---
-- Returns an indexed table with all the models states that are stroed
-- in the database.
-- @note While this function is shared, the data is only available for superadmin on the
-- client, if no manual sync is triggered.
-- @return table An hashed table with all the model data stored in the database
-- @realm shared
function playermodels.GetModelStates()
	if SERVER then
		local data = orm.Make(playermodels.sqltable):All()
		local hashableData = {}

		for i = 1, #data do
			local entry = data[i]
			local name = entry.name

			hashableData[name] = {}

			for key, info in pairs(playermodels.savingKeys) do
				if info.typ == "bool" then
					hashableData[name][key] = tobool(entry[key])
				elseif info.typ == "number" then
					hashableData[name][key] = tonumber(entry[key])
				else
					hashableData[name][key] = entry[key]
				end
			end

			hashableData[name].sortName = stringLower(name)
		end

		return hashableData
	else
		return playermodels.modelStates or {}
	end
end

---
-- Returns a table with key-value pairs of the model name and a boolean that
-- specifies whether this model has a headshot hitbox or not.
-- @note While this function is shared, the data is only available for superadmin on the
-- client, if no manual sync is triggered.
-- @return table A table with information about headshot hitboxes
-- @realm shared
function playermodels.GetHeadHitBoxModelNameList()
	return playermodels.modelHasHeadHitBox or {}
end

---
-- Checks if a provided model is in the selection pool.
-- @note While this function is shared, the data is only available for superadmin on the
-- client, if no manual sync is triggered.
-- @param string name The name of the model
-- @return boolean Returns true, if the model is in the selection pool
-- @realm shared
function playermodels.IsSelectedModel(name)
	local models = playermodels.GetModelStates()

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
	local models = playermodels.GetModelStates()

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
		playermodels.InitializeDatabase()

		-- this data then has to be synced to the client again
		playermodels.StreamModelStateToSelectedClients()
	else
		net.Start("TTT2ResetPlayerModels")
		net.SendToServer()
	end
end

if CLIENT then
	local callbackCache = {}

	net.ReceiveStream("TTT2StreamModelTable", function(data)
		playermodels.modelStates = data

		for _, Callback in pairs(callbackCache) do
			Callback(data)
		end
	end)

	net.ReceiveStream("TTT2StreamHeadHitBoxesTable", function(data)
		playermodels.modelHasHeadHitBox = data
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

	-- all the reamining functions are server only
	return
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

-- extend the playermodels scope on the server
playermodels.sqltable = "ttt2_playermodel_pool"
playermodels.savingKeys = {
	selected = {typ = "bool", default = false},
	hattable = {typ = "bool", default = false}
}

playermodels.fallbackModel = "models/player/phoenix.mdl"

---
-- Returns an indexed table with all the models that are in the selection pool.
-- @return table An indexed table with all selected player models
-- @realm server
function playermodels.GetSelectedModels()
	local playermodelPoolModel = orm.Make(playermodels.sqltable)
	local playermodelPool = playermodelPoolModel:Where({{column = "selected", value = true}}) or {}
	local playerModelPoolNames = {}


	for i = 1, #playermodelPool do
		playerModelPoolNames[i] = playermodelPool[i].name
	end

	return playerModelPoolNames
end

---
-- Initializes the database. This adds all models and sets the default models to true, if it
-- is the first init on this server.
-- @return boolean Returns false, if it failed during the process
-- @internal
-- @realm server
function playermodels.InitializeDatabase()
	if not sql.CreateSqlTable(playermodels.sqltable, playermodels.savingKeys) then
		return false
	end

	local playermodelPoolModel = orm.Make(playermodels.sqltable)

	for name in pairs(playerManagerAllValidModels()) do
		if playermodelPoolModel:Find(name) then continue end

		print(name, initialModels[name], initialHattableModels[name])

		playermodelPoolModel:New(
			{name = name,
			selected = initialModels[name] or false,
			hattable = initialHattableModels[name] or false
		}):Save()
	end

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
				playermodels.modelHasHeadHitBox[name] = true

				break
			end

			playermodels.modelHasHeadHitBox[name] = false
		end
	end

	testingEnt:Remove()
end

---
-- Streams the playermodel selection pool to clients. By default streams to all superadmin players.
-- @param[opt] table|Player plys The players that should receive the update, all superadmins if nil
-- @realm server
function playermodels.StreamModelStateToSelectedClients(plys)
	plys = plys or util.GetFilteredPlayers(function(ply)
		return ply:IsSuperAdmin()
	end)

	net.SendStream("TTT2StreamModelTable", playermodels.GetModelStates(), plys)
end

---
-- Streams the information about headshot hitboxes to clients. By default streams to all superadmin players.
-- @param[opt] table|Player plys The players that should receive the update, all superadmins if nil
-- @realm server
function playermodels.StreamHeadHitBoxesToSelectedClients(plys)
	plys = plys or util.GetFilteredPlayers(function(ply)
		return ply:IsSuperAdmin()
	end)

	net.SendStream("TTT2StreamHeadHitBoxesTable", playermodels.GetHeadHitBoxModelNameList(), plys)
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

net.Receive("TTT2UpdatePlayerModelSelected", function(_, ply)
	if not IsValid(ply) or not ply:IsSuperAdmin() then return end

	playermodels.UpdateModelSelected(net.ReadString(), net.ReadBool())
end)

net.Receive("TTT2UpdatePlayerModelHattable", function(_, ply)
	if not IsValid(ply) or not ply:IsSuperAdmin() then return end

	playermodels.UpdateModelHattable(net.ReadString(), net.ReadBool())
end)

net.Receive("TTT2ResetPlayerModels", function(_, ply)
	if not IsValid(ply) or not ply:IsSuperAdmin() then return end

	playermodels.Reset()
end)
