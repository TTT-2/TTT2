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

---
-- Updates the selection state of a provided playermodel. If the state is `true` the model is
-- in the playermodel selction pool.
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
	else -- CLIENT
		net.Start("TTT2UpdateSelectedModels")
		net.WriteString(name)
		net.WriteBool(state)
		net.SendToServer()
	end
end

---
-- Returns an indexed table with all the models that are in the selction pool.
-- @return table An indexed table with all selected player models
-- @realm server
function playermodels.GetSelectedModels()
	if SERVER then
		local playermodelPoolModel = orm.Make(playermodels.sqltable)
		local playermodelPool = playermodelPoolModel:Where({{column = "state", value = true}}) or {}

		local playerModelPoolNames = {}

		for i = 1, #playermodelPool do
			if playermodelPool[i].name == playermodels.initializedFlag then continue end

			playerModelPoolNames[#playerModelPoolNames + 1] = playermodelPool[i].name
		end

		return playerModelPoolNames
	else
		return playermodels.selectedModels or {}
	end
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
	net.ReceiveStream("TTT2StreamModelTable", function(data)
		playermodels.selectedModels = data
	end)
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
	playermodels.initializedFlag = "__INITIALIZED__"

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
		local initializedFlag = playermodelPoolModel:Find(playermodels.initializedFlag)
		local isNewTable = initializedFlag and (initializedFlag.state ~= true) or true

		for name in pairs(playerManagerAllValidModels()) do
			if playermodelPoolModel:Find(name) then continue end

			playermodelPoolModel:New({name = name, state = (isNewTable and initialModels[name]) or false}):Save()
		end

		-- mark table as initialized
		playermodelPoolModel:New({name = playermodels.initializedFlag, state = true}):Save()

		return true
	end

	---
	-- Streams the playermodel selection pool to clients. By default the clients are all superadmin players.
	-- @param[opt] table|Player plys The players that should receive the update, all superadmins if nil
	-- @realm server
	function playermodels.StreamToSelectedClients(plys)
		plys = plys or util.GetFilteredPlayers(function(ply)
			return ply:IsSuperAdmin()
		end)

		net.SendStream("TTT2StreamModelTable", playermodels.GetSelectedModels(), plys)
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

		playermodels.StreamToSelectedClients()
	end)
end
