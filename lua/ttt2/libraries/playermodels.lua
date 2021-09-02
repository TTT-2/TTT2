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
local stringSplit = string.Split
local tableRemove = table.remove
local tableConcat = table.concat
local tableHasValue = table.HasValue
local RunConsoleCommand = RunConsoleCommand
local mathRandom = math.random

playermodels = playermodels or {}

---
-- Adds a new model name to the list of the selected playermodes.
-- @param string name The name of the model
-- @realm shared
function playermodels.AddSelectedModel(name)
	net.Start("TTT2UpdateSelectedModels")
	net.WriteBool(true)
	net.WriteString(name)
	net.SendToServer()
end

---
-- Removes a model by its name from the list of the selected playermodes.
-- @param string name The name of the model
-- @realm shared
function playermodels.RemoveSelectedModel(name)
	net.Start("TTT2UpdateSelectedModels")
	net.WriteBool(false)
	net.WriteString(name)
	net.SendToServer()
end

if CLIENT then
	local callbackCache = {}

	local function Inernal_OnDataAvailable(_, modelString)
		for i = 1, #callbackCache do
			local Callback = callbackCache[i]

			if not isfunction(Callback) then continue end

			Callback(stringSplit(modelString, ","))
		end

		callbackCache = {}
	end

	---
	-- Rerturns an indexed table with all the models that are in the selction pool. Sends
	-- a request to the server and the data is provided in the callback function.
	-- @param function OnDataAvailable The callback function that is called once the data is available
	-- @realm client
	function playermodels.GetSelectedModels(OnDataAvailable)
		callbackCache[#callbackCache + 1] = OnDataAvailable

		cvars.ServerConVarGetValue("ttt2_selected_playermodels", Inernal_OnDataAvailable)
	end
end

if SERVER then
	---
	-- @realm server
	local cvSelectPlayermodels = CreateConVar("ttt2_selected_playermodels", "css_phoenix,css_arctic,css_guerilla,css_leet", {FCVAR_ARCHIVE})

	---
	-- @realm server
	local cvCustomModels = CreateConVar("ttt2_use_custom_models", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

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
	-- Rerturns an indexed table with all the models that are in the selction pool.
	-- @return table An indexed table with all selected player models
	-- @realm server
	function playermodels.GetSelectedModels()
		return stringSplit(cvSelectPlayermodels:GetString(), ",")
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
			return Model("models/player/phoenix.mdl")
		end
	end

	net.Receive("TTT2UpdateSelectedModels", function(_, ply)
		if not IsValid(ply) or not ply:IsSuperAdmin() then return end

		local modelString = cvSelectPlayermodels:GetString()
		local currentModels = modelString == "" and {} or stringSplit(modelString, ",")

		if net.ReadBool() then
			local toAdd = net.ReadString()

			if tableHasValue(currentModels, toAdd) then return end

			currentModels[#currentModels + 1] = toAdd
		else
			local toRemove = net.ReadString()

			for i = 1, #currentModels do
				if toRemove ~= currentModels[i] then continue end

				tableRemove(currentModels, i)

				break
			end
		end

		RunConsoleCommand("ttt2_selected_playermodels", tableConcat(currentModels, ","))
	end)
end
