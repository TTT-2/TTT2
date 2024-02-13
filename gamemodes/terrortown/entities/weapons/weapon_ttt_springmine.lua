if SERVER then
    AddCSLuaFile()
end

if CLIENT then
    SWEP.PrintName = "name_springmine"
    SWEP.Slot = 6

    SWEP.ViewModelFOV = 10

    SWEP.EquipMenuData = {
        type = "item_weapon",
        desc = "desc_springmine",
    }

    SWEP.Icon = "vgui/ttt/icon_springmine.png"
end

SWEP.Base = "weapon_tttbase"

SWEP.HoldType = "slam"

local ammo = 3

SWEP.Primary.ClipSize = ammo
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
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.LimitedStock = true

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false

SWEP.UseHands = true
SWEP.ShowDefaultViewModel = false
SWEP.ShowDefaultWorldModel = false

SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.AllowDrop = false

SWEP.NoSights = true

function SWEP:HandleAttack()
    if SERVER and self:CanPrimaryAttack() then
        local spring = ents.Create("ttt_springmine")

        if spring:ThrowEntity(self:GetOwner(), Angle(-90, 0, 180)) then
            spring.fingerprints = self.fingerprints

            self:TakePrimaryAmmo(1)

            if not self:CanPrimaryAttack() then
                self:Remove()
            end
        end
    end
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    self:HandleAttack()
end

function SWEP:SecondaryAttack()
    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

    self:HandleAttack()
end

function SWEP:WasBought(buyer)
    self:SetClip1(ammo)
end

function SWEP:Reload()
    return false
end

if CLIENT then
    function SWEP:OnRemove()
        if
            not IsValid(self:GetOwner())
            or self:GetOwner() ~= LocalPlayer()
            or not self:GetOwner():IsTerror()
        then
            return
        end

        RunConsoleCommand("lastinv")

        self.BaseClass.OnRemove(self)
    end

    function SWEP:Initialize()
        self:AddTTT2HUDHelp("springmine_help_pri")

        self.BaseClass.Initialize(self)
    end

    function SWEP:InitializeCustomModels()
        self:AddCustomViewModel("vmodel", {
            type = "Model",
            model = "models/props_phx/smallwheel.mdl",
            bone = "ValveBiped.Bip01_R_Finger2",
            rel = "",
            pos = Vector(1.557, 4.9, 0),
            angle = Angle(120, 0, 20),
            size = Vector(0.55, 0.55, 0.55),
            color = Color(50, 50, 50, 255),
            surpresslightning = false,
            material = "models/debug/debugwhite",
            skin = 0,
            bodygroup = {},
        })

        self:AddCustomWorldModel("wmodel", {
            type = "Model",
            model = "models/props_phx/smallwheel.mdl",
            bone = "ValveBiped.Bip01_R_Hand",
            rel = "",
            pos = Vector(5, 6, 0),
            angle = Angle(120, 20, 0),
            size = Vector(0.625, 0.625, 0.625),
            color = Color(50, 50, 50, 255),
            surpresslightning = false,
            material = "models/debug/debugwhite",
            skin = 0,
            bodygroup = {},
        })
    end
end
