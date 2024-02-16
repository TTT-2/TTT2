---
-- @class SWEP
-- @section weapon_ttt_decoy

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

if CLIENT then
    SWEP.PrintName = "decoy_name"
    SWEP.Slot = 7

    SWEP.ViewModelFOV = 70
    SWEP.ViewModelFlip = false

    SWEP.UseHands = true
    SWEP.ShowDefaultViewModel = false
    SWEP.ShowDefaultWorldModel = false

    SWEP.EquipMenuData = {
        type = "item_weapon",
        desc = "decoy_desc",
    }

    SWEP.Icon = "vgui/ttt/icon_decoy"
end

SWEP.Base = "weapon_tttbase"

SWEP.HoldType = "slam"

SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = "models/props_lab/reciever01b.mdl"

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "slam"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.0

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.LimitedStock = true -- only buyable once
SWEP.WeaponID = AMMO_DECOY
SWEP.builtin = true

SWEP.AllowDrop = false
SWEP.NoSights = true

---
-- @realm shared
function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    if SERVER and self:CanPrimaryAttack() then
        local decoy = ents.Create("ttt_decoy")

        if decoy:ThrowEntity(self:GetOwner(), Angle(90, 0, 0)) then
            decoy:SetNWString("decoy_owner_team", self:GetOwner():GetTeam())

            self:PlacedDecoy(decoy)
        end
    end
end

---
-- @realm shared
function SWEP:SecondaryAttack()
    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

    if SERVER and self:CanPrimaryAttack() then
        local decoy = ents.Create("ttt_decoy")

        if decoy:StickEntity(self:GetOwner()) then
            decoy:SetNWString("decoy_owner_team", self:GetOwner():GetTeam())

            self:PlacedDecoy(decoy)
        end
    end
end

if SERVER then
    -- add hook that changes all decoys
    hook.Add("TTT2UpdateTeam", "TTT2DecoyUpdateTeam", function(ply, oldTeam, newTeam)
        if not IsValid(ply.decoy) then
            return
        end

        ply.decoy:SetNWString("decoy_owner_team", newTeam)
    end)
end

---
-- @param Entity decoy
-- @realm shared
function SWEP:PlacedDecoy(decoy)
    self:GetOwner().decoy = decoy

    self:TakePrimaryAmmo(1)

    if not self:CanPrimaryAttack() then
        self:Remove()
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
        self:AddTTT2HUDHelp("decoy_help_primary", "decoy_help_secondary")

        self.BaseClass.Initialize(self)
    end

    ---
    -- @realm client
    function SWEP:InitializeCustomModels()
        self:AddCustomViewModel("vmodel", {
            type = "Model",
            model = "models/props_lab/reciever01b.mdl",
            bone = "ValveBiped.Bip01_R_Finger2",
            rel = "",
            pos = Vector(2.0, 4.8, -0.5),
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
            model = "models/props_lab/reciever01b.mdl",
            bone = "ValveBiped.Bip01_R_Hand",
            rel = "",
            pos = Vector(6, 5.4, -1),
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
