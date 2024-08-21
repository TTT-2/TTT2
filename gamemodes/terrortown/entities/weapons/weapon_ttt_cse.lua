---
-- @class SWEP
-- @section weapon_ttt_cse

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "grenade"

if CLIENT then
    SWEP.PrintName = "vis_name"
    SWEP.Slot = 6

    SWEP.ViewModelFOV = 70
    SWEP.ViewModelFlip = false

    SWEP.UseHands = true
    SWEP.ShowDefaultViewModel = false
    SWEP.ShowDefaultWorldModel = false

    SWEP.EquipMenuData = {
        type = "item_weapon",
        desc = "vis_desc",
    }

    SWEP.Icon = "vgui/ttt/icon_cse"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/Items/battery.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.0

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = { ROLE_DETECTIVE } -- only detectives can buy
SWEP.WeaponID = AMMO_CSE
SWEP.builtin = true

SWEP.LimitedStock = true -- only buyable once
SWEP.NoSights = true
SWEP.AllowDrop = false

SWEP.DeathScanDelay = 15

---
-- @ignore
function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    if SERVER then
        local cse = ents.Create("ttt_cse_proj")

        if cse:ThrowEntity(self:GetOwner()) then
            self:Remove()
        end
    end
end

---
-- @ignore
function SWEP:SecondaryAttack()
    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

    if SERVER then
        local cse = ents.Create("ttt_cse_proj")

        if cse:ThrowEntity(self:GetOwner()) then
            self:Remove()
        end
    end
end

---
-- @ignore
function SWEP:PreDrop(isdeath)
    if not isdeath then
        return
    end

    if SERVER then
        local cse = ents.Create("ttt_cse_proj")

        if cse:ThrowEntity(self:GetOwner()) then
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
        self:AddTTT2HUDHelp("vis_help_pri")

        self.BaseClass.Initialize(self)
    end

    ---
    -- @realm client
    function SWEP:InitializeCustomModels()
        self:AddCustomViewModel("vmodel", {
            type = "Model",
            model = "models/Items/battery.mdl",
            bone = "ValveBiped.Bip01_R_Finger2",
            rel = "",
            pos = Vector(1.5, 1.5, 2.7),
            angle = Angle(180, 20, 0),
            size = Vector(0.65, 0.65, 0.65),
            color = Color(255, 255, 255, 255),
            surpresslightning = false,
            material = "",
            skin = 0,
            bodygroup = {},
        })

        self:AddCustomWorldModel("wmodel", {
            type = "Model",
            model = "models/Items/battery.mdl",
            bone = "ValveBiped.Bip01_R_Hand",
            rel = "",
            pos = Vector(3.2, 2.5, 2.7),
            angle = Angle(180, -100, 0),
            size = Vector(0.65, 0.65, 0.65),
            color = Color(255, 255, 255, 255),
            surpresslightning = false,
            material = "",
            skin = 0,
            bodygroup = {},
        })
    end
end
