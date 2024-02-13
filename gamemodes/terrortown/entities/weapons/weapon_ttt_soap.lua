if SERVER then
    AddCSLuaFile()

    resource.AddFile("materials/vgui/ttt/.vmt")

    util.PrecacheSound("soap/slip.wav")
end

SWEP.HoldType = "grenade"

if CLIENT then
    SWEP.PrintName = "weapon_soap_name"
    SWEP.Slot = 7

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 64

    SWEP.UseHands = true
    SWEP.ShowDefaultViewModel = false
    SWEP.ShowDefaultWorldModel = false

    SWEP.EquipMenuData = {
        type = "item_weapon",
        name = "weapon_soap_name",
        desc = "weapon_soap_desc",
    }

    SWEP.Icon = "vgui/ttt/icon_soap"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/cstrike/c_eq_flashbang.mdl"
SWEP.WorldModel = "models/soap.mdl"

SWEP.Author = "Blechkanne"

SWEP.Kind = WEAPON_EQUIP1
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.LimitedStock = true

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.Primary.Delay = 0.9
SWEP.Primary.Damage = 7
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:PrimaryAttack()
    if SERVER and self:CanPrimaryAttack() then
        local soap = ents.Create("ttt_soap")

        if soap:StickEntity(self:GetOwner(), Angle(90, 0, 0)) then
            self:Remove()
        end
    end
end

function SWEP:SecondaryAttack() end

if CLIENT then
    function SWEP:Initialize()
        self:AddTTT2HUDHelp("soap_help_pri")

        self.BaseClass.Initialize(self)
    end

    function SWEP:OnRemove()
        local owner = self:GetOwner()

        if IsValid(owner) and owner == LocalPlayer() and owner:IsTerror() then
            RunConsoleCommand("lastinv")
        end
    end

    function SWEP:InitializeCustomModels()
        self:AddCustomViewModel("vmodel", {
            type = "Model",
            model = "models/soap.mdl",
            bone = "ValveBiped.Bip01_R_Finger2",
            rel = "",
            pos = Vector(1, 2, -1),
            angle = Angle(90, 80, -10),
            size = Vector(1.3, 1.3, 1.3),
            color = Color(255, 255, 255, 255),
            surpresslightning = false,
            material = "",
            skin = 0,
            bodygroup = {},
        })

        self:AddCustomWorldModel("wmodel", {
            type = "Model",
            model = "models/soap.mdl",
            bone = "ValveBiped.Bip01_R_Hand",
            rel = "",
            pos = Vector(4, 2.5, 0),
            angle = Angle(110, -20, 0),
            size = Vector(1.3, 1.3, 1.3),
            color = Color(255, 255, 255, 255),
            surpresslightning = false,
            material = "",
            skin = 0,
            bodygroup = {},
        })
    end

    function SWEP:AddToSettingsMenu(parent)
        local form = vgui.CreateTTT2Form(parent, "soap_addon_header")

        form:MakeHelp({
            label = "soap_help_menu",
        })

        form:MakeCheckBox({
            label = "label_soap_kick_props",
            serverConvar = "ttt_soap_kick_props",
        })

        form:MakeSlider({
            label = "label_soap_velocity",
            serverConvar = "ttt_soap_velocity",
            min = 0,
            max = 1000,
            decimal = 0,
        })
    end
end
