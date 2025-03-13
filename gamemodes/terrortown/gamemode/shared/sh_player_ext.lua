---
-- Shared extensions to player table
-- @ref https://wiki.facepunch.com/gmod/Player
-- @class Player

local net = net
local table = table
local IsValid = IsValid
local hook = hook
local math = math

-- Distinguish between 3 modes to reset, add or remove equipped items
EQUIPITEMS_RESET = 0
EQUIPITEMS_ADD = 1
EQUIPITEMS_REMOVE = 2

---@class Player
local plymeta = FindMetaTable("Player")
if not plymeta then
    ErrorNoHaltWithStack("FAILED TO FIND PLAYER TABLE")

    return
end

---
-- @internal
-- @realm shared
function plymeta:SetupDataTables()
    -- This has to be transferred, because we need the value when predicting the player movement
    -- It turned out that this is the only reliable way to fix all prediction errors.
    self:NetworkVar("Float", "SprintStamina")
    self:NetworkVar("Float", "SprintCooldownTime")

    if SERVER then
        self:SetSprintStamina(1)
    end

    -- these are networked variables for the custom FOV handling
    self:NetworkVar("Float", "FOVTime")
    self:NetworkVar("Float", "FOVTransitionTime")
    self:NetworkVar("Float", "FOVValue")
    self:NetworkVar("Float", "FOVLastValue")
    self:NetworkVar("Bool", "FOVIsFixed")
end

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
    return self.subrole or ROLE_NONE
end

---
-- Returns the @{ROLE} BaseRole id
-- @return[default=0] number
-- @realm shared
function plymeta:GetBaseRole()
    return self.role or ROLE_NONE
end

---
-- Returns the @{ROLE} BaseRole id
-- @return[default=0] number
-- @realm shared
-- @see Player:GetBaseRole
function plymeta:GetRole()
    return self.role or ROLE_NONE
end

---
-- Sets the subrole and the team of a @{Player}
-- @warning @{plymeta:UpdateTeam} should never be used BEFORE this function!
-- @param number subrole subrole id of a @{ROLE}
-- @param string team team of a @{ROLE}
-- @param boolean forceHooks whether update hooks should be triggerd, even if the role didn't changed
-- @param boolean suppressEvent Set this to true if no rolechange event should be triggered
-- @realm shared
function plymeta:SetRole(subrole, team, forceHooks, suppressEvent)
    local oldBaseRole = self.role and self:GetBaseRole() or nil
    local oldSubrole = self.subrole and self:GetSubRole() or nil
    local oldTeam = self.roleteam and self:GetTeam() or nil

    local roleData = roles.GetByIndex(subrole)

    self.role = roleData.baserole or subrole
    self.subrole = subrole

    -- this update team hook should suppress the event trigger
    self:UpdateTeam(team or roleData.defaultTeam or TEAM_NONE, true, true)

    local newBaseRole = self:GetBaseRole()
    local newTeam = self:GetTeam()

    if oldSubrole ~= subrole then
        local activeRolesCount = GetActiveRolesCount(roleData) + 1

        SetActiveRolesCount(roleData, activeRolesCount)

        if activeRolesCount > 0 then
            ---
            -- @realm shared
            hook.Run("TTT2ToggleRole", roleData, true)
        end

        if oldSubrole then
            local oldRoleData = roles.GetByIndex(oldSubrole)
            local oldActiveRolesCount = GetActiveRolesCount(oldRoleData) - 1

            SetActiveRolesCount(oldRoleData, oldActiveRolesCount)

            if oldActiveRolesCount <= 0 then
                ---
                -- @realm shared
                hook.Run("TTT2ToggleRole", oldRoleData, false)
            end
        end
    end

    if oldBaseRole ~= newBaseRole or forceHooks then
        ---
        -- @realm shared
        hook.Run("TTT2UpdateBaserole", self, oldBaseRole, newBaseRole)
    end

    if oldSubrole ~= subrole or forceHooks then
        ---
        -- @realm shared
        hook.Run("TTT2UpdateSubrole", self, oldSubrole, subrole)

        if SERVER then
            -- Trigger the update in the next tick to make sure the role is updated
            -- on the client first before any markerVision updates are sent.
            -- This is important so that functions such as GetRoleColor() return the
            -- correct color instead of the color from the old role.
            timer.Simple(0, function()
                if not IsValid(self) then
                    return
                end

                markerVision.PlayerUpdatedRole(self, oldSubrole, subrole)
            end)
        end
    end

    if oldTeam ~= newTeam or forceHooks then
        ---
        -- @realm shared
        hook.Run("TTT2UpdateTeam", self, oldTeam, newTeam)
    end

    if
        SERVER
        and not suppressEvent
        and (oldSubrole ~= subrole or oldTeam ~= newTeam or forceHooks)
    then
        events.Trigger(EVENT_ROLECHANGE, self, oldSubrole, subrole, oldTeam, newTeam)
    end

    -- ye olde hooks
    if subrole ~= oldSubrole or forceHooks then
        self:SetRoleColor(roleData.color)
        self:SetRoleDkColor(roleData.dkcolor)
        self:SetRoleLtColor(roleData.ltcolor)
        self:SetRoleBgColor(roleData.bgcolor)

        if SERVER then
            ---
            -- @realm server
            hook.Run("PlayerLoadout", self, false)

            -- Don't update the model if oldSubrole is nil (player isn't already spawned, leading to an initialization error)
            if oldSubrole and GetConVar("ttt_enforce_playermodel"):GetBool() then
                -- update subroleModel
                self:SetModel(self:GetSubRoleModel())
            end

            -- Always clear color state, may later be changed in TTTPlayerSetColor
            self:SetColor(COLOR_WHITE)

            ---
            -- @realm server
            hook.Run("TTTPlayerSetColor", self)
        end
    end

    if SERVER then
        roleData:GiveRoleLoadout(self, true)

        if oldSubrole then
            roles.GetByIndex(oldSubrole):RemoveRoleLoadout(self, true)
        end
    end
end

---
-- Returns the current @{ROLE}'s color
-- @return Color
-- @realm shared
function plymeta:GetRoleColor()
    return self.roleColor or roles.NONE.color
end

---
-- Sets the current @{ROLE}'s color and modifies it if hooked
-- @param Color col
-- @realm shared
function plymeta:SetRoleColor(col)
    ---
    -- @realm shared
    self.roleColor = hook.Run("TTT2ModifyRoleColor", self, col) or col
end

---
-- Returns the current @{ROLE}'s darker color
-- @return Color
-- @realm shared
function plymeta:GetRoleDkColor()
    return self.roleDkColor or roles.NONE.dkcolor
end

---
-- Sets the current @{ROLE}'s darker color and modifies it if hooked
-- @param Color col
-- @realm shared
function plymeta:SetRoleDkColor(col)
    ---
    -- @realm shared
    self.roleDkColor = hook.Run("TTT2ModifyRoleDkColor", self, col) or col
end

---
-- Returns the current @{ROLE}'s lighter color
-- @return Color
-- @realm shared
function plymeta:GetRoleLtColor()
    return self.roleLtColor or roles.NONE.ltcolor
end

---
-- Sets the current @{ROLE}'s lighter color and modifies it if hooked
-- @param Color col
-- @realm shared
function plymeta:SetRoleLtColor(col)
    ---
    -- @realm shared
    self.roleLtColor = hook.Run("TTT2ModifyRoleLtColor", self, col) or col
end

---
-- Returns the current @{ROLE}'s background color
-- @return Color
-- @realm shared
function plymeta:GetRoleBgColor()
    return self.roleBgColor or roles.NONE.bgcolor
end

---
-- Sets the current @{ROLE}'s background color and modifies it if hooked
-- @param Color col
-- @realm shared
function plymeta:SetRoleBgColor(col)
    ---
    -- @realm shared
    self.roleBgColor = hook.Run("TTT2ModifyRoleBgColor", self, col) or col
end

if SERVER then
    util.AddNetworkString("TTT2SyncModel")
    util.AddNetworkString("TTT2SyncSubroleModel")
else
    net.Receive("TTT2SyncModel", function()
        local mdl = net.ReadString()
        local ply = net.ReadPlayer()

        if not IsValid(ply) then
            return
        end

        ply:SetModel(mdl)
    end)

    net.Receive("TTT2SyncSubroleModel", function()
        local mdl = net.ReadString()
        local ply = net.ReadPlayer()

        if mdl == "" then
            mdl = nil
        end

        if not IsValid(ply) then
            return
        end

        ply:SetSubRoleModel(mdl)
    end)
end

---
-- Returns the current @{ROLE}'s team
-- @return[default=TEAM_NONE] string
-- @note If the real role has the flag `alone`, TEAM_NONE will be returned.
-- Use @{Player:GetRealTeam()} instead if this behavior is not intended.
-- @realm shared
function plymeta:GetTeam()
    local tm = self.roleteam

    if tm ~= nil and not TEAMS[tm].alone then
        return tm
    end

    return TEAM_NONE
end

---
-- Returns the real @{ROLE}'s team
-- @return nil|string
-- @realm shared
function plymeta:GetRealTeam()
    return self.roleteam
end

---
-- Updates the team of a @{Player}
-- @warning @{plymeta:SetRole} should be used BEFORE calling this function!
-- @param string team a @{ROLE}'s team
-- @param boolean suppressEvent Set this to true if no rolechange event should be triggered
-- @param boolean suppressHook Set this to true if no updateTeam hook should be triggered
-- @realm shared
function plymeta:UpdateTeam(team, suppressEvent, suppressHook)
    if team == TEAM_NOCHANGE then
        return
    end

    local oldTeam = self:GetTeam()

    self.roleteam = team or TEAM_NONE

    local newTeam = self:GetTeam()

    if oldTeam == newTeam then
        return
    end

    if not suppressHook then
        ---
        -- @realm shared
        hook.Run("TTT2UpdateTeam", self, oldTeam, newTeam)
    end

    if SERVER then
        -- Trigger the update in the next tick to make sure the team is updated
        -- on the client first before any markerVision updates are sent.
        -- This is important so that the team color assess returns the
        -- correct color instead of the color from the old team.
        timer.Simple(0, function()
            if not IsValid(self) then
                return
            end

            markerVision.PlayerUpdatedTeam(self, oldTeam, newTeam)
        end)
    end

    if SERVER and not suppressEvent then
        local subrole = self:GetSubRole()

        events.Trigger(EVENT_ROLECHANGE, self, subrole, subrole, oldTeam, newTeam)
    end
end

---
-- Checks whether a @{Player} has a team
-- @return boolean
-- @realm shared
function plymeta:HasTeam()
    local tm = self:GetTeam()

    return tm ~= TEAM_NONE and not TEAMS[tm].alone
end

---
-- Checks whether a @{Player} is in the same team as another @{Player}
-- @param Player ply the other @{Player}
-- @return boolean
-- @realm shared
function plymeta:IsInTeam(ply)
    return self:HasTeam() and self:GetTeam() == ply:GetTeam()
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
-- @return[default=NONE] ROLE
-- @realm shared
function plymeta:GetSubRoleData()
    local rlsList = roles.GetList()
    local subrl = self:GetSubRole()

    for i = 1, #rlsList do
        if rlsList[i].index ~= subrl then
            continue
        end

        return rlsList[i]
    end

    return roles.NONE
end

---
-- Returns a @{Player} current BaseRole (@{ROLE})
-- @return[default=NONE] ROLE
-- @realm shared
function plymeta:GetBaseRoleData()
    local rlsList = roles.GetList()
    local bsrl = self:GetBaseRole()

    for i = 1, #rlsList do
        if rlsList[i].index ~= bsrl then
            continue
        end

        return rlsList[i]
    end

    return roles.NONE
end

---
-- Checks whether a @{Player} is an Innocent
-- @return boolean
-- @see Player:GetInnocent
-- @realm shared
-- @deprecated
-- @function plymeta:IsInnocent()
plymeta.IsInnocent = plymeta.GetInnocent

---
-- Checks whether a @{Player} is a Traitor
-- @note basically traitor without special traitor roles, but includes all SubRoles.
-- Other BaseRoles which are in the same team are excluded!
-- @return boolean
-- @see Player:GetTraitor
-- @realm shared
-- @deprecated
-- @function plymeta:IsTraitor()
plymeta.IsTraitor = plymeta.GetTraitor

---
-- Checks whether a @{Player} is a Detective
-- @return boolean
-- @see Player:GetDetective
-- @realm shared
-- @deprecated
-- @function plymeta:IsDetective()
plymeta.IsDetective = plymeta.GetDetective

---
-- Checks whether a @{Player} has a special @{ROLE}.
-- @note This just returns <code>false</code> if the @{Player} is an Innocent or has no role!
-- @return boolean Returns true if the player has a special role
-- @realm shared
function plymeta:HasSpecialRole()
    return self:GetSubRole() ~= ROLE_INNOCENT and self:GetSubRole() ~= ROLE_NONE
end

---
-- Checks whether a @{Player} has a special @{ROLE}.
-- @note This just returns <code>false</code> if the @{Player} is an Innocent!
-- @return boolean Returns true if the player has a special role
-- @see Player:HasSpecialRole
-- @realm shared
-- @deprecated
-- @function plymeta:IsSpecial()
plymeta.IsSpecial = plymeta.HasSpecialRole

---
-- Checks whether or not a player has an evil team. By default all teams that aren't innocent or none are counted as evil.
-- @return boolean Returns true if the role is evil
-- @realm shared
function plymeta:HasEvilTeam()
    return util.IsEvilTeam(self:GetTeam())
end

---
-- Checks whether a @{Player} is a terrorist and in an active round
-- @return boolean
-- @realm shared
function plymeta:IsActive()
    return gameloop.GetRoundState() == ROUND_ACTIVE and self:IsTerror()
end

---
-- Checks whether a @{Player} is fully connected to the server
-- @return boolean
-- @realm shared
function plymeta:IsFullySignedOn()
    return (GAMEMODE.PlayerSignOnStates and GAMEMODE.PlayerSignOnStates[self:UserID()])
        == SIGNONSTATE_FULL
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
-- Checks whether a @{Player} has a valid @{ROLE}
-- @return boolean
-- @realm shared
function plymeta:HasRole()
    return self:GetSubRole() ~= ROLE_NONE
end

---
-- Checks whether a @{Player} is active and has a specific @{ROLE}
-- @param number subrole subrole id of a @{ROLE}
-- @return boolean
-- @realm shared
-- @see Player:IsActive
-- @see Player:IsRole
function plymeta:IsActiveRole(subrole)
    return self:IsActive() and self:IsRole(subrole)
end

---
-- Checks whether a @{Player} is active and is an Innocent
-- @return boolean
-- @realm shared
-- @see Player:IsActiveRole
function plymeta:IsActiveInnocent()
    return self:IsActiveRole(ROLE_INNOCENT)
end

---
-- Checks whether a @{Player} is active and is a Traitor
-- @return boolean
-- @realm shared
-- @see Player:IsActiveRole
function plymeta:IsActiveTraitor()
    return self:IsActiveRole(ROLE_TRAITOR)
end

---
-- Checks whether a @{Player} is active and is a Detective
-- @return boolean
-- @realm shared
-- @see Player:IsActiveRole
function plymeta:IsActiveDetective()
    return self:IsActiveRole(ROLE_DETECTIVE)
end

---
-- Checks whether a @{Player} is active and has a special @{ROLE}
-- @return boolean
-- @realm shared
-- @see Player:IsActive
-- @see Player:HasSpecialRole
function plymeta:IsActiveSpecial()
    return self:IsActive() and self:HasSpecialRole()
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
-- @see Player:IsActive
-- @see Player:IsShopper
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
    local weps = self:GetWeapons()

    for i = 1, #weps do
        local wep = weps[i]

        if not IsValid(wep) or not WEPS.IsEquipment(wep) then
            continue
        end

        return true
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
    local weps = self:GetWeapons()
    local wepCls = WEPS.GetClass(wep)

    for k = 1, #weps do
        if wepCls ~= weps[k]:GetClass() then
            continue
        end

        return false
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
-- @see Player:IsSpec
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
-- Resets the equipment item table to the provided one
-- @param[opt] table items The table with the item entities
-- @realm shared
function plymeta:SetEquipmentItems(items)
    self.equipmentItems = items or {}

    if SERVER then
        -- we use this instead of SendEquipment here to prevent any of the
        -- equipment reset functions to be triggered
        net.SendStream("TTT2_SetEquipmentItems", self.equipmentItems, self)
    end
end

if CLIENT then
    net.ReceiveStream("TTT2_SetEquipmentItems", function(equipmentItems)
        LocalPlayer():SetEquipmentItems(equipmentItems)
    end)
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

        for i = 1, #itms do
            local item = items.GetStored(itms[i])
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

---
-- Overrides GetEyeTrace for an optional trace mask param. Technically traces
-- like GetEyeTraceNoCursor but who wants to type that all the time, and we
-- never use cursor tracing anyway.
-- @param MASK mask The trace mask. This determines what the trace should hit and what it shouldn't hit.
-- A mask is a combination of CONTENTS_Enums - you can use these for more advanced masks.
-- @ref https://wiki.facepunch.com/gmod/Structures/Trace
-- @realm shared
function plymeta:GetEyeTrace(mask)
    mask = mask or MASK_SOLID

    if CLIENT then
        local framenum = FrameNumber()

        if self.LastPlayerTrace == framenum and self.LastPlayerTraceMask == mask then
            return self.PlayerTrace
        end

        self.LastPlayerTrace = framenum
        self.LastPlayerTraceMask = mask
    end

    local tr = util.GetPlayerTrace(self)
    tr.mask = mask

    tr = util.TraceLine(tr)
    self.PlayerTrace = tr

    return tr
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
        net.WritePlayer(ply)
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
        net.WritePlayer(self)
        net.Broadcast()
    end
end

---
-- Returns the @{Player} corpse state (found?)
-- @return boolean
-- @realm shared
function plymeta:OnceFound()
    return self:TTT2NETGetFloat("t_first_found", -1) >= 0
end

---
-- Returns whether a @{ROLE} was found
-- @return boolean
-- @realm shared
function plymeta:RoleKnown()
    return self:TTT2NETGetBool("role_found", false)
end

---
-- Returns whether a @{Player} was revived after being confirmed this round
-- @return boolean
-- @realm shared
function plymeta:WasRevivedAndConfirmed()
    return not self:IsSpec() and not self:TTT2NETGetBool("body_found", false) and self:OnceFound()
end

---
-- Returns whether a @{Player} was the first that was found this round
-- @return boolean
-- @realm shared
function plymeta:GetFirstFound()
    return math.Round(self:TTT2NETGetFloat("t_first_found", -1))
end

---
-- Returns whether the player is ready. A player is ready when he is able to look
-- around and move (first call of @{GM:SetupMove}). A bot player is always considered
-- as ready.
-- @warning If called on the client, it is only 100% reliable for the local player. While the
-- restult for other players is most likely still true, it can have some issues in certain
-- scenarios.
-- @return boolean
-- @realm shared
function plymeta:IsReady()
    if self:IsBot() then
        return true
    end

    return self.isReady or false
end

---
-- This hook is called once the player is ready on client and server. This means that
-- the client is able to handle data from the server
-- @param Player ply The @{Player} that is now ready
-- @hook
-- @realm shared
function GM:TTT2PlayerReady(ply) end

local oldSetModel = plymeta.SetModel or plymeta.MetaBaseClass.SetModel

---
-- Sets the @{Player}'s @{Model}
-- @param string mdlName
-- @note override to fix PS/ModelSelector/... issues
-- @realm shared
function plymeta:SetModel(mdlName)
    local mdl

    local curMdl = mdlName or self:GetModel()

    if not checkModel(curMdl) then
        curMdl = self.defaultModel

        if not checkModel(curMdl) then
            if not checkModel(GAMEMODE.playermodel) then
                GAMEMODE.playermodel = GAMEMODE.force_plymodel

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

        self:SetupHands()
    end
end

hook.Add("TTTEndRound", "TTTEndRound4TTT2TargetPlayer", function()
    local plys = player.GetAll()
    for i = 1, #plys do
        plys[i].targetPlayer = nil
    end
end)

---
-- Returns if the player is reviving.
-- @return boolean The blocking status
-- @realm shared
function plymeta:IsReviving()
    return self.isReviving or false
end

---
-- Returns if the ongoing revival is blocking or not.
-- @return boolean The blocking status
-- @realm shared
function plymeta:IsBlockingRevival()
    return self.revivalBlockMode and self.revivalBlockMode > REVIVAL_BLOCK_NONE
end

---
-- Returns the blocking mode of the ongoing revival.
-- @return number The blocking mode
-- @realm shared
function plymeta:GetRevivalBlockMode()
    return self.revivalBlockMode or REVIVAL_BLOCK_NONE
end

---
-- Returns the time when the ongoing revival started.
-- @return[default=@{CurTime()}] number The time when the revival started in seconds
-- @realm shared
function plymeta:GetRevivalStartTime()
    return self.revivalStartTime or CurTime()
end

---
-- Returns the duration for the ongoing revival.
-- @return[default=1.0] number The time for the revival in seconds
-- @realm shared
function plymeta:GetRevivalDuration()
    return self.revivalDurarion or 0.0
end

---
-- Checks if a player was active during this round. A player was active if they received
-- a role. This state is reset once the next round begins (@{GM:TTTBeginRound}).
-- @return boolean Returns if the player was active
-- @realm shared
function plymeta:WasActiveInRound()
    return self:TTT2NETGetBool("player_was_active_in_round", false)
end

---
-- Returns the times a player has died in an active round.
-- @return number The amoutn of deaths in the active round
-- @realm shared
function plymeta:GetDeathsInRound()
    return self:TTT2NETGetUInt("player_round_deaths", 0)
end

---
-- Checks if a player died while the round was active.
-- @return boolean Returns if the player died in the round
-- @realm shared
function plymeta:HasDiedInRound()
    return self:GetDeathsInRound() > 0
end

---
-- Checks if a player was revived in the round.
-- @return boolean Returns if the player was revived
-- @realm shared
function plymeta:WasRevivedInRound()
    return self:HasDiedInRound()
end

---
-- Returns the player height vector based on the curren thead bone
-- position. X and Y move along the head bone, Z contains the actual
-- height.
-- @note Uses the player's bounding box as a fallback if the head
-- bone is not defined
-- @note Respects the model scale for the height calculation
-- @return vector The player height
-- @realm shared
function plymeta:GetHeadPosition()
    local matrix, posHeadBone
    local bone = self:LookupBone("ValveBiped.Bip01_Head1")

    local posPlayer = self:GetPos()

    -- if the bone is defined, the bone matrix is defined as well;
    -- however on hot reloads this can momentarily break before it
    -- fixes itself again after a short time
    if bone then
        matrix = self:GetBoneMatrix(bone)
    end

    if matrix then
        posHeadBone = matrix:GetTranslation()
    end

    -- If a player is too far away, their head-bone position is only updated
    -- sporadically.
    -- In that case we want to fall back to the highest corner of the players bounding
    -- box position.
    if posHeadBone and not self:IsDormant() then
        -- note: the 8 is the assumed height of the head after the head bone
        -- this might not work for every model
        posHeadBone.z = posHeadBone.z
            + 8 * self:GetModelScale() * self:GetManipulateBoneScale(bone).z

        return posHeadBone - posPlayer
    end

    -- if the model has no head bone for some reason, use the player
    -- position as a fallback
    local obbmMaxs = self:OBBMaxs()
    obbmMaxs.x = 0
    obbmMaxs.y = 0

    return obbmMaxs * self:GetModelScale()
end

-- to make it hotreload safe, we have to make sure it is not
-- called recursively by only caching the original function
if debug.getinfo(plymeta.SetFOV, "flLnSu").what == "C" then
    plymeta.SetOldFOV = plymeta.SetFOV
end

---
-- Set a player's FOV (Field Of View) over a certain amount of time.
-- @param number fov The angle of perception (FOV); set to 0 to return to default user FOV
-- @param[default=0] number time The time it takes to transition to the FOV expressed in a floating point
-- @param[default=self] Entity requester The requester or "owner" of the zoom event; only this entity will be able to change the player's FOV until it is set back to 0
-- @realm shared
function plymeta:SetFOV(fov, time, requester)
    -- if dynamic FOV is disabled, the default function should be used
    if not self:GetPlayerSetting("enable_dynamic_fov") then
        self:SetOldFOV(fov, time, requester)

        return
    end

    -- these values have to be set for our custom FOV handling in GM:CalcView
    self:SetFOVLastValue(self:GetFOVValue())
    self:SetFOVValue(fov or 0)
    self:SetFOVTime(CurTime())
    self:SetFOVTransitionTime(time)
    self:SetFOVIsFixed(fov and fov ~= 0)

    -- set time to 0 so our custom FOV code can handle the zoom out
    if not fov or fov == 0 then
        time = 0
    end

    self:SetOldFOV(fov, time, requester)
end

---
-- Checks if a player is in iron sights.
-- @return boolean Returns true if the player is in iron sights
-- @realm shared
function plymeta:IsInIronsights()
    local wep = self:GetActiveWeapon()

    return IsValid(wep)
        and not wep.NoSights
        and isfunction(wep.GetIronsights)
        and wep:GetIronsights()
end

---
-- Get the value of a shared player setting.
-- @param string identifier The identifier of the setting
-- @return any The value of the setting, nil if not set
-- @realm shared
function plymeta:GetPlayerSetting(identifier)
    return self.playerSettings and self.playerSettings[identifier]
end

---
-- A hook that is called on change of a player setting on the server.
-- @param Player ply The player whose setting was changed
-- @param string identifier The setting's identifier
-- @param any oldValue The old value of the setting
-- @param any newValue The new value of the settings
-- @hook
-- @realm shared
function GM:TTT2PlayerSettingChanged(ply, identifier, oldValue, newValue) end

---
-- A hook that is called on the change of a role. It is called once for the old role
-- and once for the new role if some criteria are met.
-- @param ROLE roleData The roledata of the rolechange
-- @param boolean isNewRole True if it is the new role, false if it is the old role
-- @hook
-- @realm shared
function GM:TTT2ToggleRole(roleData, isNewRole) end

---
-- This hook is called on the change of a player's base role.
-- @param Player ply The player whose role is changed
-- @param number oldBaserole The numeric identifier of the old role
-- @param number newBaserole The numeric identifier of the new role
-- @hook
-- @realm shared
function GM:TTT2UpdateBaserole(ply, oldBaserole, newBaserole) end

---
-- This hook is called on the change of a player's sub role.
-- @param Player ply The player whose role is changed
-- @param number oldSubrole The numeric identifier of the old role
-- @param number newSubrole The numeric identifier of the new role
-- @hook
-- @realm shared
function GM:TTT2UpdateSubrole(ply, oldSubrole, newSubrole) end

---
-- This hook is called on the change of a player's team.
-- @param Player ply The player whose team is changed
-- @param string oldTeam The identifier of the old team
-- @param string newTeam The identifier of the new team
-- @hook
-- @realm shared
function GM:TTT2UpdateTeam(ply, oldTeam, newTeam) end

---
-- This hook is called (mostly on rolechanges) when the player's role color
-- is set and can be used to modify the color.
-- @param Player ply The player whose role color is set
-- @param Color clr The color that should be used
-- @return nil|Color The new color that is intended for the player
-- @hook
-- @realm shared
function GM:TTT2ModifyRoleColor(ply, clr) end

---
-- This hook is called (mostly on rolechanges) when the player's darkened role color
-- is set and can be used to modify the color.
-- @param Player ply The player whose role color is set
-- @param Color clr The color that should be used
-- @return nil|Color The new color that is intended for the player
-- @hook
-- @realm shared
function GM:TTT2ModifyRoleDkColor(ply, clr) end

---
-- This hook is called (mostly on rolechanges) when the player's lightened role color
-- is set and can be used to modify the color.
-- @param Player ply The player whose role color is set
-- @param Color clr The color that should be used
-- @return nil|Color The new color that is intended for the player
-- @hook
-- @realm shared
function GM:TTT2ModifyRoleLtColor(ply, clr) end

---
-- This hook is called (mostly on rolechanges) when the player's background role color
-- is set and can be used to modify the color.
-- @param Player ply The player whose role color is set
-- @param Color clr The color that should be used
-- @return nil|Color The new color that is intended for the player
-- @hook
-- @realm shared
function GM:TTT2ModifyRoleBgColor(ply, clr) end
