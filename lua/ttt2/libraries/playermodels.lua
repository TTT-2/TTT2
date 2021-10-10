---
-- A module that contains all functions related to playermodels
-- @author Mineotopia

if SERVER then
	AddCSLuaFile()

	util.AddNetworkString("TTT2UpdateSelectedModels")
end

local pairs = pairs
local playerManagerAllValidModels = player_manager.AllValidModels
local utilPrecacheModel = util.PrecacheModel
local mathRandom = math.random

playermodels = playermodels or {}
playermodels.selectedModels = playermodels.selectedModels or {}
playermodels.modelHasHeadHitBox = playermodels.modelHasHeadHitBox or {}

---
-- Updates the selection state of a provided playermodel. If the state is `true` the model is
-- in the playermodel selection pool.
-- @param string name The name of the model
-- @param boolean state The state, `true` to enable the model
-- @realm shared
function playermodels.UpdateModelState(name, state)
	if SERVER then
		local playermodelPoolModel = orm.Make(playermodels.sqltable)

		if not playermodelPoolModel then return end

		playermodelObject = playermodelPoolModel:Find(name)

		if not playermodelObject then return end

		playermodelObject.state = state or false
		playermodelObject:Save()

		playermodels.StreamSelectedModelsToSelectedClients()
	else -- CLIENT
		net.Start("TTT2UpdateSelectedModels")
		net.WriteString(name)
		net.WriteBool(state)
		net.SendToServer()
	end
end

---
-- Returns an indexed table with all the models that are in the selection pool.
-- @return table An indexed table with all selected player models
-- @realm server
function playermodels.GetSelectedModels()
	if SERVER then
		local playermodelPoolModel = orm.Make(playermodels.sqltable)
		local playermodelPool = playermodelPoolModel:Where({{column = "state", value = true}}) or {}

		local playerModelPoolNames = {}

		for i = 1, #playermodelPool do
			playerModelPoolNames[i] = playermodelPool[i].name
		end

		return playerModelPoolNames
	else
		return playermodels.selectedModels or {}
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
function playermodels.HasSelectedModel(name)
	local models = playermodels.GetSelectedModels()

	for i = 1, #models do
		if models[i] ~= name then continue end

		return true
	end

	return false
end

if CLIENT then
	local callbackCache = {}

	net.ReceiveStream("TTT2StreamModelTable", function(data)
		playermodels.selectedModels = data

		for i = 1, #callbackCache do
			callbackCache[i](data)
		end
	end)

	net.ReceiveStream("TTT2StreamHeadHitBoxesTable", function(data)
		playermodels.modelHasHeadHitBox = data
	end)

	---
	-- Used to add a function to the callback stack that is called when a change
	-- is made on the server. The first argument of the Callback function is the
	-- new data.
	-- @param function Callback The callback function that should be added
	-- @realm client
	function playermodels.AddChangeCallback(Callback)
		callbackCache[#callbackCache + 1] = Callback
	end
end

if SERVER then
	---
	-- @realm server
	local cvCustomModels = CreateConVar("ttt2_use_custom_models", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

	local initialModels = {
		["css_phoenix"] = true,
		["css_arctic"] = true,
		["css_guerilla"] = true,
		["css_leet"] = true
	}

	-- extend the playermodels scope on the server
	playermodels.sqltable = "ttt2_playermodel_pool"
	playermodels.savingKeys = {
		state = {typ = "bool", default = false}
	}

	playermodels.fallbackModel = "models/player/phoenix.mdl"

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

			playermodelPoolModel:New({name = name, state = initialModels[name] or false}):Save()
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
	function playermodels.StreamSelectedModelsToSelectedClients(plys)
		plys = plys or util.GetFilteredPlayers(function(ply)
			return ply:IsSuperAdmin()
		end)

		net.SendStream("TTT2StreamModelTable", playermodels.GetSelectedModels(), plys)
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

	net.Receive("TTT2UpdateSelectedModels", function(_, ply)
		if not IsValid(ply) or not ply:IsSuperAdmin() then return end

		playermodels.UpdateModelState(net.ReadString(), net.ReadBool())
	end)
end
