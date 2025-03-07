---
-- @class SWEP
-- @section weapon_ttt_c4
if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

if CLIENT then
    SWEP.PrintName = "C4"
    SWEP.Slot = 6

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.EquipMenuData = {
        type = "item_weapon",
        name = "C4",
        desc = "c4_desc",
    }

    SWEP.Icon = "vgui/ttt/icon_c4"
    SWEP.IconLetter = "I"
end

---
-- @realm shared
CreateConVar(
    "ttt2_c4_radius",
    "600",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED },
    "Defines the damage radius of C4 explosions"
)

---
-- @realm shared
CreateConVar(
    "ttt2_c4_radius_inner",
    "500",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED },
    "Defines the kill radius of C4 explosions"
)

SWEP.Base = "weapon_tttbase"

SWEP.HoldType = "slam"

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = { ROLE_TRAITOR } -- only traitors can buy
SWEP.WeaponID = AMMO_C4

SWEP.builtin = true

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 5.0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.0

SWEP.NoSights = true

---
-- @ignore
function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    if SERVER then
        local bomb = ents.Create("ttt_c4")

        if bomb:ThrowEntity(self:GetOwner(), Angle(30, 180, 0)) then
            bomb.fingerprints = self.fingerprints

            self:Remove()
        end
    end
end

---
-- @ignore
function SWEP:SecondaryAttack()
    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

    if SERVER then
        local bomb = ents.Create("ttt_c4")

        if bomb:StickEntity(self:GetOwner(), Angle(-90, 0, 180)) then
            bomb.fingerprints = self.fingerprints

            self:Remove()
        end
    end
end

---
-- @ignore
function SWEP:Reload()
    return false
end

if CLIENT then
    ---
    -- @ignore
    function SWEP:Initialize()
        self:AddTTT2HUDHelp("c4_help_primary", "c4_help_secondary")

        return BaseClass.Initialize(self)
    end

    ---
    -- @ignore
    function SWEP:AddToSettingsMenu(parent)
        local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")

        form:MakeHelp({
            label = "help_c4_radius",
        })

        form:MakeSlider({
            serverConvar = "ttt2_c4_radius_inner",
            label = "label_c4_radius_inner",
            min = 0,
            max = 2000,
            decimal = 0,
        })

        form:MakeSlider({
            serverConvar = "ttt2_c4_radius",
            label = "label_c4_radius",
            min = 0,
            max = 2000,
            decimal = 0,
        })
    end
end
