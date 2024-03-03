---
-- @class SWEP
-- @section weapon_ttt_unarmed

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "normal"

if CLIENT then
    SWEP.PrintName = "unarmed_name"
    SWEP.Slot = 5

    SWEP.ShowDefaultViewModel = false

    SWEP.EquipMenuData = {
        type = "item_weapon",
    }

    SWEP.Icon = "vgui/ttt/icon_unarmed"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Kind = WEAPON_UNARMED
SWEP.InLoadoutFor = { ROLE_INNOCENT, ROLE_TRAITOR, ROLE_DETECTIVE }

SWEP.AllowDelete = false
SWEP.AllowDrop = false
SWEP.overrideDropOnDeath = DROP_ON_DEATH_TYPE_DENY
SWEP.NoSights = true

SWEP.silentPickup = true

SWEP.builtin = true

---
-- @ignore
function SWEP:PrimaryAttack() end

---
-- @ignore
function SWEP:SecondaryAttack() end

---
-- @ignore
function SWEP:Reload() end

---
-- @ignore
function SWEP:Holster()
    return true
end

---
-- @ignore
function SWEP:OnDrop()
    self:Remove()
end

---
-- @ignore
function SWEP:ShouldDropOnDie()
    return false
end

if CLIENT then
    ---
    -- @realm client
    function SWEP:DrawWorldModel()
        if IsValid(self:GetOwner()) then
            return
        end

        self:DrawModel()
    end

    ---
    -- @realm client
    function SWEP:DrawWorldModelTranslucent() end
end

if SERVER then
    ---
    -- Always return true to be removed instead of dropped
    -- @return boolean
    -- @realm client
    function SWEP:ShouldRemove()
        return true
    end
end
