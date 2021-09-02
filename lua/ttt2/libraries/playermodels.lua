---
-- A module that contains all functions related to playermodels
-- @author Mineotopia

if SERVER then
	AddCSLuaFile()

	---
	-- @realm server
	CreateConVar("ttt2_selected_playermodels", "css_phoenix,css_arctic,css_guerilla,css_leet", {FCVAR_ARCHIVE, FCVAR_NOTIFY})

	util.AddNetworkString("TTT2UpdateSelectedModels")
end

local pairs = pairs
local playerManagerAllValidModels = player_manager.AllValidModels
local utilPrecacheModel = util.PrecacheModel
local stringSplit = string.Split
local GetConVar = GetConVar
local tableRemove = table.remove
local tableConcat = table.concat
local tableHasValue = table.HasValue
local RunConsoleCommand = RunConsoleCommand

local callbackCache = {}

playermodels = playermodels or {}

local function Inernal_OnDataAvailable(_, modelString)
	for i = 1, #callbackCache do
		local Callback = callbackCache[i]

		if not isfunction(Callback) then continue end

		Callback(stringSplit(modelString, ","))
	end

	callbackCache = {}
end

function playermodels.GetSelectedModels(OnDataAvailable)
	callbackCache[#callbackCache + 1] = OnDataAvailable

	if CLIENT then
		cvars.ServerConVarGetValue("ttt2_selected_playermodels", Inernal_OnDataAvailable)
	else
		Inernal_OnDataAvailable(nil, GetConVar("ttt2_selected_playermodels"):GetString())
	end
end

function playermodels.AddSelectedModel(name)
	net.Start("TTT2UpdateSelectedModels")
	net.WriteBool(true)
	net.WriteString(name)
	net.SendToServer()
end

function playermodels.RemoveSelectedModel(name)
	net.Start("TTT2UpdateSelectedModels")
	net.WriteBool(false)
	net.WriteString(name)
	net.SendToServer()
end

if SERVER then
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

	net.Receive("TTT2UpdateSelectedModels", function(_, ply)
		if not IsValid(ply) or not ply:IsSuperAdmin() then return end

		local currentModels = stringSplit(GetConVar("ttt2_selected_playermodels"):GetString(), ",")

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
