---
-- @class SWEP
-- @section weapon_ttt_unarmed

if SERVER then
	AddCSLuaFile()
end

SWEP.HoldType = "normal"

if CLIENT then
	SWEP.PrintName = "unarmed_name"
	SWEP.Slot = 5

	SWEP.ViewModelFOV = 10
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
SWEP.InLoadoutFor = {ROLE_INNOCENT, ROLE_TRAITOR, ROLE_DETECTIVE}

SWEP.AllowDelete = false
SWEP.AllowDrop = false
SWEP.NoSights = true
SWEP.InvisibleViewModel = true

SWEP.silentPickup = true

SWEP.builtin = true

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

---
-- @ignore
function SWEP:PrimaryAttack()

end

---
-- @ignore
function SWEP:SecondaryAttack()

end

---
-- @ignore
function SWEP:Reload()

end

---
-- @ignore
function SWEP:Holster()
	return true
end

---
-- @ignore
function SWEP:DrawWorldModel()

end

---
-- @ignore
function SWEP:DrawWorldModelTranslucent()

end
