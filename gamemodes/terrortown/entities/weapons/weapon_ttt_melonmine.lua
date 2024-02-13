if SERVER then
    AddCSLuaFile()

    resource.AddFile("materials/vgui/ttt/icon_melonmine.png")

    util.PrecacheSound("weapons/c4/c4_beep1.wav")
    util.PrecacheSound("weapons/c4/c4_plant.wav")
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "slam"

if CLIENT then
    SWEP.PrintName = "weapon_melonmine_name"
    SWEP.Slot = 6

    SWEP.ViewModelFOV = 70
    SWEP.ViewModelFlip = false

    SWEP.UseHands = true
    SWEP.ShowDefaultViewModel = false
    SWEP.ShowDefaultWorldModel = false

    SWEP.EquipMenuData = {
        type = "item_weapon",
        desc = "weapon_melonmine_desc",
    }

    SWEP.Icon = "vgui/ttt/icon_melonmine.png"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.LimitedStock = true

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.Primary.Delay = 0.9
SWEP.Primary.Recoil = 0.001
SWEP.Primary.Damage = 7
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "slam"

SWEP.Cat = "Explosives"

function SWEP:PrimaryAttack()
    if SERVER and self:CanPrimaryAttack() then
        local melon = ents.Create("ttt_melonmine")

        if melon:StickEntity(self:GetOwner(), Angle(-90, 0, 180)) then
            melon.fingerprints = self.fingerprints

            self:Remove()
        end
    end
end

function SWEP:OnRemove()
    if
        CLIENT
        and IsValid(self:GetOwner())
        and self:GetOwner() == LocalPlayer()
        and self:GetOwner():IsTerror()
    then
        RunConsoleCommand("lastinv")
    end
end

if CLIENT then
    function SWEP:Initialize()
        self:AddTTT2HUDHelp("melonmine_help_pri")

        self.BaseClass.Initialize(self)
    end

    function SWEP:InitializeCustomModels()
        self:AddCustomViewModel("vmodel", {
            type = "Model",
            model = "models/props_junk/watermelon01.mdl",
            bone = "ValveBiped.Bip01_R_Finger2",
            rel = "",
            pos = Vector(1.557, 4.9, 0),
            angle = Angle(0, 0, 0),
            size = Vector(0.625, 0.625, 0.625),
            color = Color(255, 175, 0, 255),
            surpresslightning = false,
            material = "",
            skin = 0,
            bodygroup = {},
        })

        self:AddCustomWorldModel("wmodel", {
            type = "Model",
            model = "models/props_junk/watermelon01.mdl",
            bone = "ValveBiped.Bip01_R_Hand",
            rel = "",
            pos = Vector(3, 6.752, 0),
            angle = Angle(0, 0, 0),
            size = Vector(0.625, 0.625, 0.625),
            color = Color(255, 175, 0, 255),
            surpresslightning = false,
            material = "",
            skin = 0,
            bodygroup = {},
        })
    end
end
