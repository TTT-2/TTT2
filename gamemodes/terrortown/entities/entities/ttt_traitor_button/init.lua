-- serverside only

AddCSLuaFile("shared.lua")
include("shared.lua")

TButtonMapConfig = {}
MapButtonEntIndexMapping = {}

local lastRead = -1
local dir = "ttt2tbuttons"
local path = dir .. "/" .. game.GetMap() .. ".json"

local function ReadMapConfig()
	file.CreateDir(dir)

	local modTime = (not file.Exists(path, "DATA") and (lastRead + 1)) or file.Time(path, "DATA")

	if modTime <= lastRead then
		return TButtonMapConfig
	end

	lastRead = modTime
	local content = file.Read(path, "DATA")

	if not content then
		return TButtonMapConfig
	end

	TButtonMapConfig = util.JSONToTable(content) or {}

	for id in pairs(TButtonMapConfig) do
		local ent = ents.GetMapCreatedEntity(tonumber(id))
		if IsValid(ent) then
			MapButtonEntIndexMapping[ent:EntIndex()] = id
		end
	end

	return TButtonMapConfig
end

local function SendMapConfig(skipRead, ply)
	if not skipRead then
		ReadMapConfig()
	end

	net.Start("TTT2SendTButtonConfig")
	net.WriteTable(TButtonMapConfig)
	net.WriteTable(MapButtonEntIndexMapping)

	if IsValid(ply) and ply:IsPlayer() then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

local function UpdateMapConfig(ent, roleRawString, team, teamMode)
	if not IsValid(ent) then return false end

	local mapID = ent:MapCreationID()
	if mapID == -1 then return false end

	local currentJSON = ReadMapConfig()
	currentJSON[mapID] = currentJSON[mapID] or {}
	currentJSON[mapID].Override = currentJSON[mapID].Override or {}
	currentJSON[mapID].Override.Role = currentJSON[mapID].Override.Role or {}
	currentJSON[mapID].Override.Team = currentJSON[mapID].Override.Team or {}
	currentJSON[mapID].Description = ent:GetDescription()

	if teamMode then
		local cur = currentJSON[mapID].Override.Team[team]
		if cur == nil then
			currentJSON[mapID].Override.Team[team] = true
		elseif cur then
			currentJSON[mapID].Override.Team[team] = false
		else
			currentJSON[mapID].Override.Team[team] = nil
		end
	else
		local cur = currentJSON[mapID].Override.Role[roleRawString]
		if cur == nil then
			currentJSON[mapID].Override.Role[roleRawString] = true
		elseif cur then
			currentJSON[mapID].Override.Role[roleRawString] = false
		else
			currentJSON[mapID].Override.Role[roleRawString] = nil
		end
	end

	file.Write(path, util.TableToJSON(currentJSON, true))
	TButtonMapConfig = currentJSON
	MapButtonEntIndexMapping[mapID] = ent:EntIndex()

	return true
end

net.Receive("TTT2RequestTButtonConfig", function(len, ply)
	SendMapConfig(false, ply)
end)

hook.Add("TTTInitPostEntity", "TTT2TButtonsCacheInitialize", function()
	-- Initially send the map config
	SendMapConfig()
end)

net.Receive("TTT2ToggleTButton", function(len, ply)
	local ent = net.ReadEntity()
	local teamMode = net.ReadBool()

	if not IsValid(ply) or not IsValid(ent) or not ply:IsAdmin() then return end

	local use, message = hook.Run("TTTCanToggleTraitorButton", ent, ply)

	if not use then
		if message then
			LANG.Msg(ply, message, nil, MSG_MSTACK_ROLE)
		end

		return
	end

	UpdateMapConfig(ent, ply:GetRoleStringRaw(), ply:GetTeam(), teamMode)
	SendMapConfig(true)
end)

local function ActivateTButton(ply, ent)
	if not IsValid(ply) or not IsValid(ent) or ent:GetClass() ~= "ttt_traitor_button" then return end

	if not ent.PlayerRoleCanUse or not ent:PlayerRoleCanUse(ply) or not ent.TraitorUse then return end

	local use, message = hook.Run("TTTCanUseTraitorButton", ent, ply)

	if not use then
		if message then
			LANG.Msg(ply, message, nil, MSG_MSTACK_ROLE)
		end

		return
	end

	ent:TraitorUse(ply)
end

net.Receive("TTT2ActivateTButton", function(len, ply)
	ActivateTButton(ply, net.ReadEntity())
end)

ENT.RemoveOnPress = false

ENT.Model = Model("models/weapons/w_bugbait.mdl")

function ENT:Initialize()
	self:SetModel(self.Model)

	self:SetNoDraw(true)
	self:DrawShadow(false)
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)

	self:SetDelay(self.RawDelay or 1)

	if self:GetDelay() < 0 then
		self.RemoveOnPress = true -- func_button can be made single use by setting delay to be negative, so mimic that here
	end

	if self.RemoveOnPress then
		self:SetDelay(-1) -- tells client we're single use
	end

	if self:GetUsableRange() < 1 then
		self:SetUsableRange(1024)
	end

	self:SetNextUseTime(0)
	self:SetLocked(self:HasSpawnFlags(2048))

	self:SetDescription(self.RawDescription or "?")

	self:SetRole(self.Role or "none")
	self:SetTeam(self.Team or TEAM_NONE)

	self.RawDelay = nil
	self.RawDescription = nil
end

function ENT:KeyValue(key, value)
	if key == "OnPressed" then
		self:StoreOutput(key, value)
	elseif key == "wait" then -- as Delay Before Reset in func_button
		self.RawDelay = tonumber(value)
	elseif key == "description" then
		self.RawDescription = tostring(value)

		if self.RawDescription and string.len(self.RawDescription) < 1 then
			self.RawDescription = nil
		end
	elseif key == "RemoveOnPress" then
		self.RemoveOnPress = tobool(value)
	elseif key == "role" then
		self.Role = tostring(value)
	elseif key == "team" then
		self.Team = tostring(value)
	else
		self:SetNetworkKeyValue(key, value)
	end
end

function ENT:AcceptInput(name, activator)
	if name == "Toggle" then
		self:SetLocked(not self:GetLocked())

		return true
	elseif name == "Hide" or name == "Lock" then
		self:SetLocked(true)

		return true
	elseif name == "Unhide" or name == "Unlock" then
		self:SetLocked(false)

		return true
	end
end

function GAMEMODE:TTTCanUseTraitorButton(ent, ply)
	-- Can be used to prevent players from using this button.
	-- Return a boolean and a message that can shows up if you can't use the button.
	-- Example: return false, "Not allowed".
	return true
end

function GAMEMODE:TTTCanToggleTraitorButton(ent, ply)
	-- Can be used to prevent admins from toggling modes this button.
	-- Return a boolean and a message that can shows up if you can't toggle the button.
	-- Example: return false, "Not allowed".
	return true
end

function ENT:TraitorUse(ply)
	if not IsValid(ply) then
		return false
	end

	if not self:PlayerRoleCanUse(ply)
	or not self:IsUsable()
	or self:GetPos():Distance(ply:GetPos()) > self:GetUsableRange() then
		return false
	end

	net.Start("TTT_ConfirmUseTButton")
	net.Send(ply)

	-- send output to all entities linked to us
	self:TriggerOutput("OnPressed", ply)

	if self.RemoveOnPress then
		self:SetLocked(true)
		self:Remove()
	else
		-- lock ourselves until we should be usable again
		self:SetNextUseTime(CurTime() + self:GetDelay())
	end

	hook.Run("TTTTraitorButtonActivated", self, ply)

	return true
end

-- Fix for traitor buttons having awkward init/render behavior, in the event that a map has been optimized with area portals.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

-- keep the noombmessage (aka. concommand) for compatibility
local function TraitorUseCmd(ply, cmd, args)
	if #args ~= 1 or not IsValid(ply) then return end

	local idx = tonumber(args[1])

	if not idx then return end

	ActivateTButton(Entity(idx))
end
concommand.Add("ttt_use_tbutton", TraitorUseCmd)
