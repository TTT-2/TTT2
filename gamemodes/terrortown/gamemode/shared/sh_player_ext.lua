---
-- @module Player
-- @ref https://wiki.garrysmod.com/page/Category:Player
-- shared extensions to player table

local net = net
local table = table
local pairs = pairs
local ipairs = ipairs
local IsValid = IsValid
local hook = hook

local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

local math = math

---
-- Checks whether a player is a available terrorist (not a spectator)
-- @return boolean
-- @realm shared
function plymeta:IsTerror()
	return self:Team() == TEAM_TERROR
end

---
-- Checks whether a player is a spectator (not a terrorist)
-- @return boolean
-- @realm shared
function plymeta:IsSpec()
	return self:Team() == TEAM_SPEC
end

---
-- Checks whether a player has forced to a spectator (not a dead terrorist that is spectating)
-- @return boolean
-- @realm shared
function plymeta:GetForceSpec()
	return self:GetNWBool("force_spec")
end

---
-- Returns the @{ROLE} SubRole id
-- @return[default=0] number
-- @realm shared
function plymeta:GetSubRole()
	return self.subrole or ROLE_INNOCENT
end

---
-- Returns the @{ROLE} BaseRole id
-- @return[default=0] number
-- @realm shared
function plymeta:GetBaseRole()
	return self.role or ROLE_INNOCENT
end

---
-- Returns the @{ROLE} BaseRole id
-- @return[default=0] number
-- @realm shared
-- @see plymeta.GetBaseRole
function plymeta:GetRole()
	return self.role or ROLE_INNOCENT
end

---
-- Sets the subrole and the team of a @{Player}
-- @warning @{plymeta:UpdateTeam} should never be used BEFORE this function!
-- @param number subrole subrole id of a @{ROLE}
-- @param string team team of a @{ROLE}
-- @param boolean forceHooks whether update hooks should be triggerd, even if the role didn't changed
-- @realm shared
function plymeta:SetRole(subrole, team, forceHooks)
	local oldRole = self:GetBaseRole()
	local oldSubrole = self:GetSubRole()
	local oldTeam = self:GetTeam()
	local rd = roles.GetByIndex(subrole)

	self.role = rd.baserole or subrole
	self.subrole = subrole

	self:UpdateTeam(team or rd.defaultTeam or TEAM_NONE)

	local newRole = self:GetBaseRole()
	local newSubrole = self:GetSubRole()
	local newTeam = self:GetTeam()

	if oldSubrole ~= newSubrole then
		local ord = roles.GetByIndex(oldSubrole)
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
	if newSubrole ~= oldSubrole or forceHooks then
		self:SetRoleColor(rd.color)
		self:SetRoleDkColor(rd.dkcolor)
		self:SetRoleBgColor(rd.bgcolor)

		if SERVER then
			hook.Call("PlayerLoadout", GAMEMODE, self)

			-- update subroleModel
			self:SetModel(self:GetSubRoleModel())

			-- Always clear color state, may later be changed in TTTPlayerSetColor
			self:SetColor(COLOR_WHITE)

			hook.Run("TTTPlayerSetColor", self)
		end
	end
end

---
-- Returns the current @{ROLE}'s color
-- @return[default=Color(80, 173, 59, 255)] Color
-- @realm shared
function plymeta:GetRoleColor()
	if not self.roleColor then
		self.roleColor = INNOCENT.color
	end

	return self.roleColor
end

---
-- Sets the current @{ROLE}'s color and modifies it if hooked
-- @param Color col
-- @realm shared
function plymeta:SetRoleColor(col)
	self.roleColor = hook.Run("TTT2ModifyRoleColor", self, col) or col
end

---
-- Returns the current @{ROLE}'s darker color
-- @return[default=Color(28, 116, 10, 255)] Color
-- @realm shared
function plymeta:GetRoleDkColor()
	return self.roleDkColor or INNOCENT.dkcolor
end

---
-- Sets the current @{ROLE}'s darker color and modifies it if hooked
-- @param Color col
-- @realm shared
function plymeta:SetRoleDkColor(col)
	self.roleDkColor = hook.Run("TTT2ModifyRoleDkColor", self, col) or col
end

---
-- Returns the current @{ROLE}'s background color
-- @return[default=Color(200, 68, 81, 255)] Color
-- @realm shared
function plymeta:GetRoleBgColor()
	return self.roleBgColor or INNOCENT.bgcolor
end

---
-- Sets the current @{ROLE}'s background color and modifies it if hooked
-- @param Color col
-- @realm shared
function plymeta:SetRoleBgColor(col)
	self.roleBgColor = hook.Run("TTT2ModifyRoleBgColor", self, col) or col
end

if SERVER then
	util.AddNetworkString("TTT2SyncModel")
	util.AddNetworkString("TTT2SyncSubroleModel")
else
	net.Receive("TTT2SyncModel", function()
		local mdl = net.ReadString()
		local ply = net.ReadEntity()

		if IsValid(ply) then
			ply:SetModel(mdl)
		end
	end)

	net.Receive("TTT2SyncSubroleModel", function()
		local mdl = net.ReadString()
		local ply = net.ReadEntity()

		if mdl == "" then
			mdl = nil
		end

		if IsValid(ply) then
			ply:SetSubRoleModel(mdl)
		end
	end)
end

---
-- Returns the current @{ROLE}'s team
-- @return[default=TEAM_NONE] string
-- @realm shared
function plymeta:GetTeam()
	return self.roleteam or TEAM_NONE
end

---
-- Updates the team of a @{Player}
-- @warning @{plymeta:SetRole} should be used BEFORE calling this function!
-- @param string team a @{ROLE}'s team
-- @realm shared
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

---
-- Checks whether a @{Player} has a certain team
-- @param string name a @{ROLE}' team name
-- @return boolean
-- @realm shared
function plymeta:HasTeam(team)
	return not team and self.roleteam ~= TEAM_NONE or team and self:GetTeam() == team
end

---
-- Checks whether a @{Player} is in the same team as another @{Player}
-- @param Player ply the other @{Player}
-- @return boolean
-- @realm shared
function plymeta:IsInTeam(ply)
	return self:GetTeam() ~= TEAM_NONE and not TEAMS[self:GetTeam()].alone and self:GetTeam() == ply:GetTeam()
end

-- Role access

---
-- Checks whether a @{Player} is an Innocent
-- @return boolean
-- @realm shared
-- @deprecated
function plymeta:GetInnocent()
	return self:GetBaseRole() == ROLE_INNOCENT
end

---
-- Checks whether a @{Player} is a Traitor
-- @note basically traitor without special traitor roles, but includes all SubRoles.
-- Other BaseRoles which are in the same team are excluded!
-- @return boolean
-- @realm shared
-- @deprecated
function plymeta:GetTraitor()
	return self:GetBaseRole() == ROLE_TRAITOR
end

---
-- Checks whether a @{Player} is a Detective
-- @return boolean
-- @realm shared
-- @deprecated
function plymeta:GetDetective()
	return self:GetBaseRole() == ROLE_DETECTIVE
end

---
-- Returns a @{Player} current SubRole @{ROLE}
-- @return[default=INNOCENT] ROLE
-- @realm shared
function plymeta:GetSubRoleData()
	for _, v in ipairs(roles.GetList()) do
		if v.index == self:GetSubRole() then
			return v
		end
	end

	return INNOCENT
end

---
-- Returns a @{Player} current BaseRole (@{ROLE})
-- @return[default=INNOCENT] ROLE
-- @realm shared
function plymeta:GetBaseRoleData()
	for _, v in ipairs(roles.GetList()) do
		if v.index == self:GetBaseRole() then
			return v
		end
	end

	return INNOCENT
end

---
-- @function plymeta:IsInnocent()
-- @desc Checks whether a @{Player} is an Innocent
-- @return boolean
-- @see plymeta:GetInnocent
-- @realm shared
-- @deprecated
plymeta.IsInnocent = plymeta.GetInnocent

---
-- @function plymeta:IsTraitor()
-- @desc Checks whether a @{Player} is a Traitor
-- @note basically traitor without special traitor roles, but includes all SubRoles.
-- Other BaseRoles which are in the same team are excluded!
-- @return boolean
-- @see plymeta:GetTraitor
-- @realm shared
-- @deprecated
plymeta.IsTraitor = plymeta.GetTraitor

---
-- @function plymeta:IsDetective()
-- @desc Checks whether a @{Player} is a Detective
-- @return boolean
-- @see plymeta:GetDetective
-- @realm shared
-- @deprecated
plymeta.IsDetective = plymeta.GetDetective

---
-- Checks whether a @{Player} has a special @{ROLE}
-- @note This just returns <code>false</code> if the @{Player} is an Innocent!
-- @return boolean
-- @realm shared
function plymeta:IsSpecial()
	return self:GetSubRole() ~= ROLE_INNOCENT
end

---
-- Checks whether a @{Player} is a terrorist and in an active round
-- @return boolean
-- @realm shared
function plymeta:IsActive()
	return GetRoundState() == ROUND_ACTIVE and self:IsTerror()
end

---
-- Convenience functions for common patterns
-- will match if player has specific subrole or a general baserole if requested.
-- To check whether a player have a specific baserole not a subrole, use <code>@{plymeta:GetSubRole} == baserole</code>
-- @param number subrole subrole id of a @{ROLE}
-- @return boolean
-- @realm shared
function plymeta:IsRole(subrole)
	local br = self:GetBaseRole()
	local sr = self:GetSubRole()

	return subrole == sr or subrole == br
end

---
-- Checks whether a @{Player} is active and has a specific @{ROLE}
-- @param number subrole subrole id of a @{ROLE}
-- @return boolean
-- @realm shared
-- @see plymeta:IsActive
-- @see plymeta:IsRole
function plymeta:IsActiveRole(subrole)
	return self:IsActive() and self:IsRole(subrole)
end

---
-- Checks whether a @{Player} is active and is an Innocent
-- @return boolean
-- @realm shared
-- @see plymeta:IsActiveRole
function plymeta:IsActiveInnocent()
	return self:IsActiveRole(ROLE_INNOCENT)
end

---
-- Checks whether a @{Player} is active and is a Traitor
-- @return boolean
-- @realm shared
-- @see plymeta:IsActiveRole
function plymeta:IsActiveTraitor()
	return self:IsActiveRole(ROLE_TRAITOR)
end

---
-- Checks whether a @{Player} is active and is a Detective
-- @return boolean
-- @realm shared
-- @see plymeta:IsActiveRole
function plymeta:IsActiveDetective()
	return self:IsActiveRole(ROLE_DETECTIVE)
end

---
-- Checks whether a @{Player} is active and has a special @{ROLE}
-- @return boolean
-- @realm shared
-- @see plymeta:IsActive
-- @see plymeta:IsSpecial
function plymeta:IsActiveSpecial()
	return self:IsActive() and self:IsSpecial()
end

---
-- Checks whether a @{Player} is able to shop
-- @return boolean
-- @realm shared
-- @see ROLE:IsShoppingRole
function plymeta:IsShopper()
	return self:GetSubRoleData():IsShoppingRole()
end

---
-- Checks whether a @{Player} is active and able to shop
-- @return boolean
-- @realm shared
-- @see plymeta:IsActive
-- @see plymeta:IsShopper
function plymeta:IsActiveShopper()
	return self:IsActive() and self:IsShopper()
end

local GetRTranslation = CLIENT and LANG.GetRawTranslation or util.passthrough

---
-- Returns printable role
-- @return string
-- @realm shared
function plymeta:GetRoleString()
	local name = self:GetSubRoleData().name

	return GetRTranslation(name) or name
end

---
-- Returns role language string id, caller must translate if desired
-- @return string
-- @realm shared
function plymeta:GetRoleStringRaw()
	return self:GetSubRoleData().name
end

---
-- Returns the base amount of karma
-- @return number
-- @realm shared
function plymeta:GetBaseKarma()
	return self:GetNWFloat("karma", 1000)
end

---
-- Returns whether a @{Player} carries a @{Weapon}
-- @return boolean
-- @realm shared
function plymeta:HasEquipmentWeapon()
	for _, wep in pairs(self:GetWeapons()) do
		if IsValid(wep) and WEPS.IsEquipment(wep) then
			return true
		end
	end

	return false
end

---
-- Returns whether a @{Player} is able to carry @{Weapon}
-- @param Weapon wep
-- @return boolean
-- @realm shared
function plymeta:CanCarryWeapon(wep)
	if not wep or not wep.Kind then
		return false
	end

	-- appeareantly TTT can't handle two times the same weapon
	for k, v in pairs(self:GetWeapons()) do
		if WEPS.GetClass(wep) == v:GetClass() then
			return false
		end
	end

	return self:CanCarryType(wep.Kind)
end

---
-- Returns whether a @{Player} can carry a @{Weapon} type
-- @param number t
-- @return boolean
-- @realm shared
function plymeta:CanCarryType(t)
	if not t then
		return false
	end

	return InventorySlotFree(self, t)
end

---
-- Returns a @{Player}'s Inventory
-- @return table
-- @realm shared
function plymeta:GetInventory()
	CleanupInventoryIfDirty(self)

	return self.inventory
end

---
-- Returns a list of @{Weapon}s a @{Player} is carrying on a specific slot
-- @param number slot
-- @return table
-- @realm shared
function plymeta:GetWeaponsOnSlot(slot)
	if slot > WEAPON_CLASS then
		return
	end

	return self:GetInventory()[slot]
end

---
-- Returns a list of all Melee @{Weapon}s a @{Player} is carrying
-- @return table
-- @realm shared
function plymeta:GetMeleeWeapons()
	return self:GetWeaponsOnSlot(WEAPON_MELEE)
end

---
-- Returns a list of all Primary @{Weapon}s a @{Player} is carrying
-- @return table
-- @realm shared
function plymeta:GetPrimaryWeapons()
	return self:GetWeaponsOnSlot(WEAPON_HEAVY)
end

---
-- Returns a list of all Secondary @{Weapon}s a @{Player} is carrying
-- @return table
-- @realm shared
function plymeta:GetSecondaryWeapons()
	return self:GetWeaponsOnSlot(WEAPON_PISTOL)
end

---
-- Returns a list of all Nade @{Weapon}s a @{Player} is carrying
-- @return table
-- @realm shared
function plymeta:GetNades()
	return self:GetWeaponsOnSlot(WEAPON_NADE)
end

---
-- Returns a list of all Carry @{Weapon}s a @{Player} is carrying
-- @return table
-- @realm shared
function plymeta:GetCarryWeapons()
	return self:GetWeaponsOnSlot(WEAPON_CARRY)
end

---
-- Returns a list of all Special @{Weapon}s a @{Player} is carrying
-- @return table
-- @realm shared
function plymeta:GetSpecialWeapons()
	return self:GetWeaponsOnSlot(WEAPON_SPECIAL)
end

---
-- Returns a list of all Extra @{Weapon}s a @{Player} is carrying
-- @return table
-- @realm shared
function plymeta:GetExtraWeapons()
	return self:GetWeaponsOnSlot(WEAPON_EXTRA)
end

---
-- Returns a list of all Class @{Weapon}s a @{Player} is carrying
-- @return table
-- @realm shared
function plymeta:GetClassWeapons()
	return self:GetWeaponsOnSlot(WEAPON_CLASS)
end

---
-- Checks whether a @{Player} is a dead terrorist
-- @return boolean
-- @realm shared
-- @see plymeta:IsSpec
function plymeta:IsDeadTerror()
	return self:IsSpec() and not self:Alive()
end

---
-- Checks whether a @{Player} has bought an @{ITEM} or @{Weapon}
-- @param string id of the @{ITEM} or @{Weapon}
-- @return boolean
-- @realm shared
function plymeta:HasBought(id)
	return self.bought and table.HasValue(self.bought, id)
end

---
-- Returns the amount of credits a @{Player} is owning
-- @return number
-- @realm shared
function plymeta:GetCredits()
	return self.equipment_credits or 0
end

---
-- Returns each equipment a @{Player} is owning
-- @return table
-- @realm shared
function plymeta:GetEquipmentItems()
	return self.equipmentItems or {}
end

---
-- Given an equipment id, returns if @{Player} owns this. Given nil, returns if
-- @{Player} has any equipment item.
-- @param[opt] string id
-- @return boolean
-- @realm shared
function plymeta:HasEquipmentItem(id)
	if not id then
		return #self:GetEquipmentItems() > 0
	else
		local itms = self:GetEquipmentItems()

		if table.HasValue(itms, id) then
			return true
		end

		for _, itemId in ipairs(itms) do
			local item = items.GetStored(itemId)
			if item and item.oldId and item.oldId == id then
				return true
			end
		end
	end

	return false
end

---
-- Returns if @{Player} has any equipment item
-- @return boolean
-- @realm shared
function plymeta:HasEquipment()
	return self:HasEquipmentItem() or self:HasEquipmentWeapon()
end

if CLIENT then

	---
	-- Returns if @{Player} has a specific @{Weapon}
	-- @param string cls @{Weapon}'s class name
	-- @return boolean
	-- @realm shared
	function plymeta:HasWeapon(cls) -- Server has this, but isn't shared for some reason
		for _, wep in pairs(self:GetWeapons()) do
			if IsValid(wep) and wep:GetClass() == cls then
				return true
			end
		end

		return false
	end

	local ply = LocalPlayer
	local gmod_GetWeapons = plymeta.GetWeapons

	---
	-- Returns all @{Weapon}s a @{Player} is owning
	-- @return table
	-- @realm shared
	function plymeta:GetWeapons() -- Server has this, but isn't shared for some reason
		if self ~= ply() then
			return {}
		else
			return gmod_GetWeapons(self)
		end
	end
end

---
-- Overrides GetEyeTrace for an optional trace mask param. Technically traces
-- like GetEyeTraceNoCursor but who wants to type that all the time, and we
-- never use cursor tracing anyway.
-- @param MASK[https://wiki.garrysmod.com/page/Enums/MASK] mask The trace mask. This determines what the trace should hit and what it shouldn't hit. A mask is a combination of CONTENTS_Enums - you can use these for more advanced masks.
-- @see https://wiki.garrysmod.com/page/Structures/Trace
-- @realm shared
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
	---
	-- Applies a animation gesture
	-- @param ACT[https://wiki.garrysmod.com/page/Enums/ACT] act The activity (ACT) or sequence that should be played
	-- @param number weight The weight this slot should be set to. Value must be ranging from 0 to 1.
	-- @realm client
	-- @see https://wiki.garrysmod.com/page/Player/AnimRestartGesture
	-- @see https://wiki.garrysmod.com/page/Player/AnimSetGestureWeight
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

	---
	-- Perform the gesture using the GestureRunner system. If custom_runner is
	-- non-nil, it will be used instead of the default runner for the act.
	-- @param ACT[https://wiki.garrysmod.com/page/Enums/ACT] act The activity (ACT) or sequence that should be played
	-- @param table custom_runner
	-- @return boolean success?
	-- @realm client
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

	---
	-- Perform a gesture update
	-- @realm client
	function plymeta:AnimUpdateGesture()
		if self.GestureRunner then
			self.GestureWeight = self:GestureRunner(self.GestureWeight)

			if self.GestureWeight <= 0 then
				self.GestureRunner = nil
			end
		end
	end

	---
	-- @hook
	-- @param Player ply The player to update the animation info for.
	-- @param Vector vel The player's velocity.
	-- @param number maxseqgroundspeed Speed of the animation - used for playback rate scaling.
	-- @return any ?
	-- @realm client
	function GM:UpdateAnimation(ply, vel, maxseqgroundspeed)
		ply:AnimUpdateGesture()

		return self.BaseClass.UpdateAnimation(self, ply, vel, maxseqgroundspeed)
	end

	---
	-- @param Player ply
	-- @hook
	-- @realm client
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
	---
	-- On the server, we just send the client a message that the player is
	-- performing a gesture. This allows the client to decide whether it should
	-- play, depending on eg. a cvar.
	-- @param ACT[https://wiki.garrysmod.com/page/Enums/ACT] act The activity (ACT) or sequence that should be played
	-- @realm server
	function plymeta:AnimPerformGesture(act)
		if not act then return end

		net.Start("TTT_PerformGesture")
		net.WriteEntity(self)
		net.WriteUInt(act, 16)
		net.Broadcast()
	end
end

if SERVER then
	util.AddNetworkString("StartDrowning")
	util.AddNetworkString("TTT2TargetPlayer")
end

---
-- Starts drowning for a @{Player}
-- @param boolean bool
-- @param number time the maximum time a @{Player} is able to dive
-- @param number duration the current duration / time a @{Player} is diving
-- @realm shared
function plymeta:StartDrowning(bool, time, duration)
	if bool then
		-- will start drowning soon
		self.drowning = CurTime() + time
		self.drowningTime = duration
		self.drowningProgress = math.max(0, time * (1 / duration))
	else
		self.drowning = nil
		self.drowningTime = nil
		self.drowningProgress = -1
	end

	if SERVER then
		net.Start("StartDrowning")
		net.WriteBool(bool)

		if bool then
			net.WriteUInt(time, 16)
			net.WriteUInt(self.drowningTime, 16)
		end

		net.Send(self)
	end
end

---
-- Returns the target a @{Player} is spectating
-- @return Player target
-- @realm shared
function plymeta:GetTargetPlayer()
	return self.targetPlayer
end

---
-- Sets the target a @{Player} is spectating
-- @param Player ply
-- @realm shared
function plymeta:SetTargetPlayer(ply)
	self.targetPlayer = ply

	if SERVER then
		net.Start("TTT2TargetPlayer")
		net.WriteEntity(ply)
		net.Send(self)
	end
end

local function checkModel(mdl)
	return mdl and mdl ~= "" and mdl ~= "models/player.mdl"
end

---
-- Returns the current model a @{Player} wears depending on the current @{ROLE}
-- @return string the @{ROLE} @{Model}
-- @realm shared
function plymeta:GetSubRoleModel()
	return self.subroleModel
end

---
-- Sets the current model a @{Player} wears depending on the current @{ROLE}
-- @param string mdl the @{ROLE} @{Model}
-- @realm shared
function plymeta:SetSubRoleModel(mdl)
	if not checkModel(mdl) then
		mdl = nil
	end

	self.subroleModel = mdl

	if SERVER then
		net.Start("TTT2SyncSubroleModel")
		net.WriteString(mdl or "")
		net.WriteEntity(self)
		net.Broadcast()
	end
end

---
-- Returns the @{Player} corpse state (found?)
-- @return boolean
-- @realm shared
function plymeta:OnceFound()
	return self:GetNWFloat("t_first_found", -1) >= 0
end

---
-- Returns whether a @{ROLE} was found
-- @return boolean
-- @realm shared
function plymeta:RoleKnown()
	return self:GetNWBool("role_found", false)
end

---
-- Returns whether a @{Player} was revived this round
-- @return boolean
-- @realm shared
function plymeta:Revived()
	return not self:GetNWBool("body_found", false) and self:OnceFound()
end

---
-- Returns whether a @{Player} was the first that was found this round
-- @return boolean
-- @realm shared
function plymeta:GetFirstFound()
	return math.Round(self:GetNWFloat("t_first_found", -1))
end

---
-- Returns whether a @{Player} was the last that was found this round
-- @return boolean
-- @realm shared
function plymeta:GetLastFound()
	return math.Round(self:GetNWFloat("t_last_found", -1))
end

---
-- Sets the @{Player}'s @{Model}
-- @param string mdlName
-- @note override to fix PS/ModelSelector/... issues
-- @realm shared
local oldSetModel = plymeta.SetModel or plymeta.MetaBaseClass.SetModel
function plymeta:SetModel(mdlName)
	local mdl

	local curMdl = mdlName or self:GetModel()
	if not checkModel(curMdl) then
		curMdl = self.defaultModel

		if not checkModel(curMdl) then
			if not checkModel(GAMEMODE.playermodel) then
				GAMEMODE.playermodel = GAMEMODE.force_plymodel == "" and GetRandomPlayerModel() or GAMEMODE.force_plymodel

				if not checkModel(GAMEMODE.playermodel) then
					GAMEMODE.playermodel = "models/player/phoenix.mdl"
				end
			end

			curMdl = GAMEMODE.playermodel
		end
	end

	local srMdl = self:GetSubRoleModel()
	if srMdl then
		mdl = srMdl

		if curMdl ~= srMdl then
			self.oldModel = curMdl
		end
	else
		if self.oldModel then
			mdl = self.oldModel
			self.oldModel = nil
		else
			mdl = curMdl
		end
	end

	-- last but not least, we fix this grey model "bug"
	if not checkModel(mdl) then
		mdl = "models/player/phoenix.mdl"
	end

	oldSetModel(self, Model(mdl))

	if SERVER then
		net.Start("TTT2SyncModel")
		net.WriteString(mdl)
		net.WriteEntity(self)
		net.Broadcast()
	end
end

hook.Add("TTTEndRound", "TTTEndRound4TTT2TargetPlayer", function()
	for _, pl in ipairs(player.GetAll()) do
		pl.targetPlayer = nil
	end
end)

if CLIENT then
	net.Receive("StartDrowning", function()
		local client = LocalPlayer()

		if not IsValid(client) then return end

		local bool = net.ReadBool()

		client:StartDrowning(bool, bool and net.ReadUInt(16), bool and net.ReadUInt(16))
	end)

	net.Receive("TTT2TargetPlayer", function(len)
		local client = LocalPlayer()

		if not IsValid(client) then return end

		local target = net.ReadEntity()

		if not IsValid(target) or not target:IsPlayer() or target:IsWorld() then
			target = nil
		end

		if target == nil or IsValid(target) and target:IsActive() and target:Alive() then
			client:SetTargetPlayer(target)
		end
	end)
end
