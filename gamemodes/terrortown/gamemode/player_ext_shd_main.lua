-- shared extensions to player table

local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

local math = math

function plymeta:IsTerror()
	return self:Team() == TEAM_TERROR
end

function plymeta:IsSpec()
	return self:Team() == TEAM_SPEC
end

function plymeta:GetForceSpec()
	return self:GetNWBool("force_spec")
end

function plymeta:GetSubRole()
	return self.subrole
end

function plymeta:GetBaseRole()
	return self.role
end

function plymeta:GetRole()
	return self.role
end

-- ply:UpdateTeam(team) should never be used BEFORE this function
function plymeta:SetRole(subrole, team, forceHooks)
	local oldRole = self:GetBaseRole()
	local oldSubrole = self:GetSubRole()
	local oldTeam = self:GetTeam()
	local rd = GetRoleByIndex(subrole)

	self.role = rd.baserole or subrole
	self.subrole = subrole

	self:UpdateTeam(team or rd.defaultTeam or TEAM_NONE)

	local newRole = self:GetBaseRole()
	local newSubrole = self:GetSubRole()
	local newTeam = self:GetTeam()

	if oldSubrole ~= newSubrole then
		local ord = GetRoleByIndex(oldSubrole)
		local ar = GetActiveRolesCount(rd) + 1
		local oar = GetActiveRolesCount(ord) - 1

		SetActiveRolesCount(rd, ar)
		SetActiveRolesCount(ord, oar)

		if ar > 0 then
			hook.Run("TTT2ToggleRole", rd, true)
		end

		if oar <= 0 then
			hook.Run("TTT2ToggleRole", ord, false)
		end
	end

	if oldRole ~= newRole or forceHooks then
		hook.Run("TTT2UpdateBaserole", self, oldRole, newRole)
	end

	if oldSubrole ~= newSubrole or forceHooks then
		hook.Run("TTT2UpdateSubrole", self, oldSubrole, newSubrole)
	end

	if oldTeam ~= newTeam or forceHooks then
		hook.Run("TTT2UpdateTeam", self, oldTeam, newTeam)
	end

	-- ye olde hooks
	if SERVER and (newSubrole ~= oldSubrole or forceHooks) then
		hook.Run("PlayerLoadout", self)
		hook.Run("PlayerSetModel", self)
		hook.Run("TTTPlayerSetColor", self)
	end
end

function plymeta:GetTeam()
	return self.roleteam or TEAM_NONE
end

function plymeta:UpdateTeam(team)
	if not team or team ~= TEAM_NOCHANGE then
		local oldTeam = self:GetTeam()

		self.roleteam = team or TEAM_NONE

		local newTeam = self:GetTeam()

		if oldTeam ~= newTeam then
			hook.Run("TTT2UpdateTeam", self, oldTeam, newTeam)
		end
	end
end

function plymeta:HasTeam(team)
	return not team and self.roleteam ~= TEAM_NONE or team and self:GetTeam() == team
end

function plymeta:IsInTeam(ply)
	return self:GetTeam() ~= TEAM_NONE and not TEAMS[self:GetTeam()].alone and self:GetTeam() == ply:GetTeam()
end

-- Role access
function plymeta:GetInnocent()
	return self:GetBaseRole() == ROLE_INNOCENT
end

-- basically traitor without special traitor roles (w/ teams)
function plymeta:GetTraitor()
	return self:GetBaseRole() == ROLE_TRAITOR
end

function plymeta:GetDetective()
	return self:GetBaseRole() == ROLE_DETECTIVE
end

function plymeta:GetSubRoleData()
	for _, v in pairs(GetRoles()) do
		if v.index == self:GetSubRole() then
			return v
		end
	end

	return INNOCENT
end

function plymeta:GetBaseRoleData()
	for _, v in pairs(GetRoles()) do
		if v.index == self:GetBaseRole() then
			return v
		end
	end

	return INNOCENT
end

plymeta.IsInnocent = plymeta.GetInnocent
plymeta.IsTraitor = plymeta.GetTraitor
plymeta.IsDetective = plymeta.GetDetective

function plymeta:IsSpecial()
	return self:GetSubRole() ~= ROLE_INNOCENT
end

-- Player is alive and in an active round
function plymeta:IsActive()
	return GetRoundState() == ROUND_ACTIVE and self:IsTerror()
end

-- convenience functions for common patterns
-- will match if player has specific subrole or a general baserole if requested.
-- To check whether a player have a specific baserole not a subrole, use ply:GetSubRole() == baserole
function plymeta:IsRole(subrole)
	local br = self:GetBaseRole()
	local sr = self:GetSubRole()

	return subrole == sr or subrole == br
end

function plymeta:IsActiveRole(subrole)
	return self:IsActive() and self:IsRole(subrole)
end

function plymeta:IsActiveInnocent()
	return self:IsActiveRole(ROLE_INNOCENT)
end

-- basically traitor without special traitor roles (w/ teams)
function plymeta:IsActiveTraitor()
	return self:IsActiveRole(ROLE_TRAITOR)
end

function plymeta:IsActiveDetective()
	return self:IsActiveRole(ROLE_DETECTIVE)
end

function plymeta:IsActiveSpecial()
	return self:IsActive() and self:IsSpecial()
end

function plymeta:IsShopper()
	return IsShoppingRole(self:GetSubRole())
end

function plymeta:IsActiveShopper()
	return self:IsActive() and self:IsShopper()
end

local GetRTranslation = CLIENT and LANG.GetRawTranslation or util.passthrough

-- Returns printable role
function plymeta:GetRoleString()
	local name = self:GetSubRoleData().name

	return GetRTranslation(name) or name
end

-- Returns role language string id, caller must translate if desired
function plymeta:GetRoleStringRaw()
	return self:GetSubRoleData().name
end

function plymeta:GetBaseKarma()
	return self:GetNWFloat("karma", 1000)
end

function plymeta:HasEquipmentWeapon()
	for _, wep in pairs(self:GetWeapons()) do
		if IsValid(wep) and WEPS.IsEquipment(wep) then
			return true
		end
	end

	return false
end

function plymeta:CanCarryWeapon(wep)
	if not wep or not wep.Kind then
		return false
	end

	return self:CanCarryType(wep.Kind)
end

function plymeta:CanCarryType(t)
	if not t then
		return false
	end

	for _, w in pairs(self:GetWeapons()) do
		if w.Kind and w.Kind == t then
			return false
		end
	end

	return true
end

function plymeta:IsDeadTerror()
	return self:IsSpec() and not self:Alive()
end

function plymeta:HasBought(id)
	return self.bought and table.HasValue(self.bought, id)
end

function plymeta:GetCredits()
	return self.equipment_credits or 0
end

function plymeta:GetEquipmentItems()
	return self.equipment_items or EQUIP_NONE
end

-- Given an equipment id, returns if player owns this. Given nil, returns if
-- player has any equipment item.
function plymeta:HasEquipmentItem(id)
	if not id then
		return self:GetEquipmentItems() ~= EQUIP_NONE
	else
		return util.BitSet(self:GetEquipmentItems(), id)
	end
end

function plymeta:HasEquipment()
	return self:HasEquipmentItem() or self:HasEquipmentWeapon()
end

if CLIENT then
	-- Server has this, but isn't shared for some reason
	function plymeta:HasWeapon(cls)
		for _, wep in pairs(self:GetWeapons()) do
			if IsValid(wep) and wep:GetClass() == cls then
				return true
			end
		end

		return false
	end

	local ply = LocalPlayer
	local gmod_GetWeapons = plymeta.GetWeapons

	function plymeta:GetWeapons()
		if self ~= ply() then
			return {}
		else
			return gmod_GetWeapons(self)
		end
	end
end

-- Override GetEyeTrace for an optional trace mask param. Technically traces
-- like GetEyeTraceNoCursor but who wants to type that all the time, and we
-- never use cursor tracing anyway.
function plymeta:GetEyeTrace(mask)
	if self.LastPlayerTraceMask == mask and self.LastPlayerTrace == CurTime() then
		return self.PlayerTrace
	end

	local tr = util.GetPlayerTrace(self)
	tr.mask = mask

	self.PlayerTrace = util.TraceLine(tr)
	self.LastPlayerTrace = CurTime()
	self.LastPlayerTraceMask = mask

	return self.PlayerTrace
end

-- TODO move this to client file
if CLIENT then
	function plymeta:AnimApplyGesture(act, weight)
		self:AnimRestartGesture(GESTURE_SLOT_CUSTOM, act, true) -- true = autokill
		self:AnimSetGestureWeight(GESTURE_SLOT_CUSTOM, weight)
	end

	local function MakeSimpleRunner(act)
		return function (ply, w)
			-- just let this gesture play itself and get out of its way
			if w == 0 then
				ply:AnimApplyGesture(act, 1)

				return 1
			else
				return 0
			end
		end
	end

	-- act -> gesture runner fn
	local act_runner = {
		-- ear grab needs weight control
		-- sadly it's currently the only one
		[ACT_GMOD_IN_CHAT] = function (ply, w)
			local dest = ply:IsSpeaking() and 1 or 0

			w = math.Approach(w, dest, FrameTime() * 10)
			if w > 0 then
				ply:AnimApplyGesture(ACT_GMOD_IN_CHAT, w)
			end

			return w
		end
	}

	-- Insert all the "simple" gestures that do not need weight control
	for _, a in ipairs{
		ACT_GMOD_GESTURE_AGREE,
		ACT_GMOD_GESTURE_DISAGREE,
		ACT_GMOD_GESTURE_WAVE,
		ACT_GMOD_GESTURE_BECON,
		ACT_GMOD_GESTURE_BOW,
		ACT_GMOD_GESTURE_SALUTE,
		ACT_GMOD_CHEER,
		ACT_SIGNAL_FORWARD,
		ACT_SIGNAL_HALT,
		ACT_SIGNAL_GROUP,
		ACT_ITEM_PLACE,
		ACT_ITEM_DROP,
		ACT_ITEM_GIVE
	} do
		act_runner[a] = MakeSimpleRunner(a)
	end

	CreateConVar("ttt_show_gestures", "1", FCVAR_ARCHIVE)

	-- Perform the gesture using the GestureRunner system. If custom_runner is
	-- non-nil, it will be used instead of the default runner for the act.
	function plymeta:AnimPerformGesture(act, custom_runner)
		if not ConVarExists("ttt_show_gestures") or GetConVar("ttt_show_gestures"):GetInt() == 0 then return end

		local runner = custom_runner or act_runner[act]

		if not runner then
			return false
		end

		self.GestureWeight = 0
		self.GestureRunner = runner

		return true
	end

	-- Perform a gesture update
	function plymeta:AnimUpdateGesture()
		if self.GestureRunner then
			self.GestureWeight = self:GestureRunner(self.GestureWeight)

			if self.GestureWeight <= 0 then
				self.GestureRunner = nil
			end
		end
	end

	function GM:UpdateAnimation(ply, vel, maxseqgroundspeed)
		ply:AnimUpdateGesture()

		return self.BaseClass.UpdateAnimation(self, ply, vel, maxseqgroundspeed)
	end

	function GM:GrabEarAnimation(ply)

	end

	local function TTT_PerformGesture()
		local ply = net.ReadEntity()
		local act = net.ReadUInt(16)

		if IsValid(ply) and act then
			ply:AnimPerformGesture(act)
		end
	end
	net.Receive("TTT_PerformGesture", TTT_PerformGesture)
else -- SERVER
	-- On the server, we just send the client a message that the player is
	-- performing a gesture. This allows the client to decide whether it should
	-- play, depending on eg. a cvar.
	function plymeta:AnimPerformGesture(act)
		if not act then return end

		net.Start("TTT_PerformGesture")
		net.WriteEntity(self)
		net.WriteUInt(act, 16)
		net.Broadcast()
	end
end
