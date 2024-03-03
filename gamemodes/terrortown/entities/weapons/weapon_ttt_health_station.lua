---
-- @class SWEP
-- @desc health staion
-- @section weapon_ttt_health_station

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "normal"

if CLIENT then
    SWEP.PrintName = "hstation_name"
    SWEP.Slot = 6

    SWEP.ShowDefaultViewModel = false

    SWEP.EquipMenuData = {
        type = "item_weapon",
        desc = "hstation_desc",
    }

    SWEP.Icon = "vgui/ttt/icon_health"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/props/cs_office/microwave.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.0

-- This is special equipment
SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = { ROLE_DETECTIVE } -- only detectives can buy
SWEP.LimitedStock = true -- only buyable once
SWEP.WeaponID = AMMO_HEALTHSTATION

SWEP.builtin = true

SWEP.AllowDrop = false
SWEP.NoSights = true

SWEP.drawColor = Color(180, 180, 250, 255)

---
-- @ignore
function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    if SERVER then
        local health = ents.Create("ttt_health_station")

        if health:ThrowEntity(self:GetOwner(), Angle(90, -90, 0)) then
            self:Remove()
        end
    end
end

---
-- @ignore
function SWEP:Reload()
    return false
end

---
-- @realm shared
function SWEP:Initialize()
    if CLIENT then
        self:AddTTT2HUDHelp("hstation_help_primary")
    end

    self:SetColor(self.drawColor)

    return BaseClass.Initialize(self)
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
