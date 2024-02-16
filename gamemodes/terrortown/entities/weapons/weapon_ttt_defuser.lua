---
-- @class SWEP
-- @desc defuser
-- @section weapon_ttt_defuser

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "slam"

if CLIENT then
    SWEP.PrintName = "defuser_name"
    SWEP.Slot = 7

    SWEP.ShowDefaultViewModel = false

    SWEP.EquipMenuData = {
        type = "item_weapon",
        desc = "defuser_desc",
    }

    SWEP.Icon = "vgui/ttt/icon_defuser"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_defuser.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo = "none"

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = { ROLE_DETECTIVE } -- only detectives can buy
SWEP.WeaponID = AMMO_DEFUSER

SWEP.builtin = true

local defuse = Sound("c4.disarmfinish")

---
-- @ignore
function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    local spos = self:GetOwner():GetShootPos()
    local sdest = spos + (self:GetOwner():GetAimVector() * 80)

    local tr =
        util.TraceLine({ start = spos, endpos = sdest, filter = self:GetOwner(), mask = MASK_SHOT })

    if IsValid(tr.Entity) and tr.Entity.Defusable then
        local bomb = tr.Entity
        if bomb.Defusable == true or bomb:Defusable() then
            if SERVER and bomb.Disarm then
                bomb:Disarm(self:GetOwner())
                sound.Play(defuse, bomb:GetPos())
            end

            self:SetNextPrimaryFire(CurTime() + (self.Primary.Delay * 2))
        end
    end
end

---
-- @ignore
function SWEP:SecondaryAttack() end

if CLIENT then
    ---
    -- @ignore
    function SWEP:Initialize()
        self:AddTTT2HUDHelp("defuser_help_primary")

        return BaseClass.Initialize(self)
    end

    ---
    -- @ignore
    function SWEP:DrawWorldModel()
        if not IsValid(self:GetOwner()) then
            self:DrawModel()
        end
    end
end

---
-- @ignore
function SWEP:Reload()
    return false
end

---
-- @ignore
function SWEP:OnDrop() end
