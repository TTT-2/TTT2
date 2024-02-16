---
-- @class SWEP
-- @section weapon_ttt_beacon

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "slam"

if CLIENT then
    SWEP.PrintName = "beacon_name"
    SWEP.Slot = 6

    SWEP.ViewModelFOV = 70
    SWEP.ViewModelFlip = false

    SWEP.UseHands = true
    SWEP.ShowDefaultViewModel = false
    SWEP.ShowDefaultWorldModel = false

    SWEP.EquipMenuData = {
        type = "item_weapon",
        desc = "beacon_desc",
    }

    SWEP.Icon = "vgui/ttt/icon_beacon"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = "models/props_lab/reciever01a.mdl"

SWEP.Primary.ClipSize = 3
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "slam"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.0

SWEP.Kind = WEAPON_EQUIP

SWEP.CanBuy = { ROLE_DETECTIVE }
SWEP.LimitedStock = true -- only buyable once
SWEP.WeaponID = AMMO_BEACON
SWEP.builtin = true

SWEP.Spawnable = true
SWEP.AllowDrop = false
SWEP.NoSights = true

SWEP.builtin = true

---
-- @realm shared
function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    if SERVER and self:CanPrimaryAttack() then
        local beacon = ents.Create("ttt_beacon")

        if beacon:ThrowEntity(self:GetOwner(), Angle(90, 0, 0)) then
            self:PlacedBeacon()
        end
    end
end

---
-- @realm shared
function SWEP:SecondaryAttack()
    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

    if SERVER and self:CanPrimaryAttack() then
        local beacon = ents.Create("ttt_beacon")

        if beacon:StickEntity(self:GetOwner()) then
            self:PlacedBeacon()
        end
    end
end

---
-- @realm shared
function SWEP:PlacedBeacon()
    self:TakePrimaryAmmo(1)

    if not self:CanPrimaryAttack() then
        self:Remove()
    end
end

---
-- @param Player buyer
-- @realm shared
function SWEP:WasBought(buyer)
    self:SetClip1(self:Clip1() + 2)
end

---
-- @realm shared
function SWEP:Reload()
    return false
end

if CLIENT then
    ---
    -- @realm client
    function SWEP:Initialize()
        self:AddTTT2HUDHelp("beacon_help_pri", "beacon_help_sec")

        self.BaseClass.Initialize(self)
    end

    ---
    -- @realm client
    function SWEP:InitializeCustomModels()
        self:AddCustomViewModel("vmodel", {
            type = "Model",
            model = "models/props_lab/reciever01a.mdl",
            bone = "ValveBiped.Bip01_R_Finger2",
            rel = "",
            pos = Vector(2.2, 6.5, -1),
            angle = Angle(120, 10, 0),
            size = Vector(0.6, 0.6, 0.6),
            color = Color(255, 255, 255, 255),
            surpresslightning = false,
            material = "",
            skin = 0,
            bodygroup = {},
        })

        self:AddCustomWorldModel("wmodel", {
            type = "Model",
            model = "models/props_lab/reciever01a.mdl",
            bone = "ValveBiped.Bip01_R_Hand",
            rel = "",
            pos = Vector(6.7, 7, -1),
            angle = Angle(-60, 35, 0),
            size = Vector(0.6, 0.6, 0.6),
            color = Color(255, 255, 255, 255),
            surpresslightning = false,
            material = "",
            skin = 0,
            bodygroup = {},
        })
    end
end
