---
-- @class SWEP
-- @desc radar
-- @section weapon_ttt_radar

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "melee"

if CLIENT then
    SWEP.PrintName = "radar_name"
    SWEP.Slot = 7

    SWEP.EquipMenuData = {
        type = "item_weapon",
        name = "radar_name",
        desc = "radar_desc",
    }

    SWEP.ViewModelFOV = 70
    SWEP.ViewModelFlip = false

    SWEP.UseHands = true
    SWEP.ShowDefaultViewModel = false
    SWEP.ShowDefaultWorldModel = false

    SWEP.Icon = "vgui/ttt/icon_radar"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/props/cs_office/radio.mdl"

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

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE } -- only traitors can buy
SWEP.LimitedStock = true -- only buyable once
SWEP.WeaponID = EQUIP_RADAR or 2

SWEP.builtin = true

SWEP.AllowDrop = true
SWEP.NoSights = true

function SWEP:Equip(newOwner)
    if SERVER then
        radar.Init(newOwner)
    end
end

function SWEP:OnDrop()
    if SERVER then
        radar.Deinit(self:GetOwner())
    end

    self:GetOwner().radarCharge = 0
    if CLIENT then
        radar:Clear()
    end
end

---
-- @ignore
function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    radar.TriggerRadarScan(self:GetOwner())
end

---
-- @ignore
function SWEP:SecondaryAttack()
    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

    if CLIENT then
        radar:SwitchRepeatingMode()
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
        self:AddTTT2HUDHelp("radar_scan", "radar_auto")

        self.BaseClass.Initialize(self)
    end

    ---
    -- @ignore
    function SWEP:AddToSettingsMenu(parent)
        local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")

        form:MakeSlider({
            serverConvar = "ttt2_radar_charge_time",
            label = "label_radar_charge_time",
            min = 0,
            max = 60,
            decimal = 0,
        })
    end

    ---
    -- @realm client
    function SWEP:InitializeCustomModels()
        self:AddCustomViewModel("vmodel", {
            type = "Model",
            model = "models/props/cs_office/radio.mdl",
            bone = "ValveBiped.Bip01_R_Finger2",
            rel = "",
            pos = Vector(7, 3.5, 2),
            angle = Angle(10, 75, 200),
            size = Vector(0.725, 0.725, 0.725),
            color = Color(255, 255, 255, 255),
            surpresslightning = false,
            material = "",
            skin = 0,
            bodygroup = {},
        })

        self:AddCustomWorldModel("wmodel", {
            type = "Model",
            model = "models/props/cs_office/radio.mdl",
            bone = "ValveBiped.Bip01_R_Hand",
            rel = "",
            pos = Vector(4, 6, 0),
            angle = Angle(20, 15, 190),
            size = Vector(0.625, 0.625, 0.625),
            color = Color(255, 255, 255, 255),
            surpresslightning = false,
            material = "",
            skin = 0,
            bodygroup = {},
        })
    end
end
