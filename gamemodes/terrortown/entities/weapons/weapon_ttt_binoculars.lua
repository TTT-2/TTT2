---
-- @class SWEP
-- @section weapon_ttt_binoculars

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "camera"

if CLIENT then
    SWEP.PrintName = "binoc_name"
    SWEP.Slot = 7

    SWEP.ShowDefaultViewModel = false
    SWEP.ShowDefaultWorldModel = false

    SWEP.EquipMenuData = {
        type = "item_weapon",
        desc = "binoc_desc",
    }

    SWEP.Icon = "vgui/ttt/icon_binoc"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/Items/combine_rifle_cartridge01.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.0
SWEP.Primary.Cone = 0.075

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.2

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = { ROLE_DETECTIVE } -- only detectives can buy
SWEP.WeaponID = AMMO_BINOCULARS
SWEP.builtin = true

SWEP.AllowDrop = true

SWEP.ZoomLevels = {
    0,
    30,
    20,
    10,
}

SWEP.ProcessingDelay = 5
SWEP.decayRate = 0.5

---
-- @ignore
function SWEP:SetupDataTables()
    self:NetworkVar("Entity", 0, "ProcessTarget")
    self:NetworkVar("Float", 0, "Progress")
    self:NetworkVar("Float", 1, "AwayTime")
    self:NetworkVar("Int", 0, "ZoomAmount")

    return BaseClass.SetupDataTables(self)
end

---
-- @param Entity target The new processing target.
-- @realm shared
function SWEP:SetNewTarget(target)
    self:SetProcessTarget(target)
    self:SetProgress(0)
    self:SetAwayTime(0)
end

---
-- @ignore
function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 0.1)

    local corpse = self:GetTargetingCorpse()

    if corpse == nil or self:GetProcessTarget() ~= NULL and self:GetProcessTarget() == corpse then
        return
    end

    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    if SERVER then
        self:SetNewTarget(corpse)
    end
end

local click = Sound("weapons/sniper/sniper_zoomin.wav")

---
-- @ignore
function SWEP:SecondaryAttack()
    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

    if CLIENT and IsFirstTimePredicted() then
        LocalPlayer():EmitSound(click)
    end

    self:CycleZoom()
end

---
-- @ignore
function SWEP:SetZoomLevel(level)
    self:SetZoomAmount(level)

    local owner = self:GetOwner()
    if IsValid(owner) then
        owner:SetFOV(self.ZoomLevels[level], 0.3)
    end
end

---
-- @ignore
function SWEP:CycleZoom()
    self:SetZoomAmount(self:GetZoomAmount() + 1)

    if not self.ZoomLevels[self:GetZoomAmount()] then
        self:SetZoomAmount(1)
    end

    self:SetZoomLevel(self:GetZoomAmount())
end

---
-- @ignore
function SWEP:PreDrop()
    self:SetZoomLevel(1)

    self:SetNewTarget(NULL)

    return BaseClass.PreDrop(self)
end

---
-- @ignore
function SWEP:Holster()
    self:SetZoomLevel(1)

    self:SetNewTarget(NULL)

    return true
end

---
-- @ignore
function SWEP:Deploy()
    self:SetZoomLevel(1)

    return BaseClass.Deploy(self)
end

---
-- @ignore
function SWEP:OnRemove()
    BaseClass.OnRemove(self)

    self:SetZoomLevel(1)
end

---
-- @ignore
function SWEP:Reload()
    local playSound = false
    if self:GetZoomAmount() > 1 or self:GetProgress() > 0 then
        self:SetZoomLevel(1)
        playSound = true
    end

    if CLIENT and IsFirstTimePredicted() and playSound then
        LocalPlayer():EmitSound(click)
    end

    self:SetNewTarget(NULL)

    return false
end

---
-- @return boolean
-- @realm shared
function SWEP:IsTargetingCorpse()
    local ent = self:GetOwner():GetEyeTrace(MASK_SHOT).Entity

    return IsValid(ent) and ent:IsPlayerRagdoll()
end

---
-- @return Entity
-- @realm shared
function SWEP:GetTargetingCorpse()
    local ent = self:GetOwner():GetEyeTrace(MASK_SHOT).Entity

    if IsValid(ent) and ent:IsPlayerRagdoll() then
        return ent
    end
end

local confirm = Sound("npc/turret_floor/click1.wav")

---
-- @realm shared
function SWEP:IdentifyCorpse()
    local owner = self:GetOwner()

    if SERVER then
        local tr = owner:GetEyeTrace(MASK_SHOT)

        CORPSE.ShowSearch(owner, tr.Entity, false, true)
    elseif IsFirstTimePredicted() then
        LocalPlayer():EmitSound(confirm)
    end
end

---
-- @ignore
function SWEP:Think()
    BaseClass.Think(self)

    if self:GetProcessTarget() == NULL then
        return
    end

    local tickDirection = engine.TickInterval()
    local awayTime = self:GetAwayTime()

    if self:GetTargetingCorpse() ~= self:GetProcessTarget() then
        awayTime = awayTime + tickDirection
        self:SetAwayTime(awayTime)
        tickDirection = tickDirection * (-self.decayRate * awayTime)
    else
        self:SetAwayTime(0)
    end

    local newProgress = self:GetProgress() + tickDirection
    self:SetProgress(newProgress)

    if newProgress < 0 then
        self:SetNewTarget(NULL)
    elseif newProgress > self.ProcessingDelay then
        self:IdentifyCorpse()
        self:SetNewTarget(NULL)
    end
end

if CLIENT then
    local TryT = LANG.TryTranslation
    local GetPT = LANG.GetParamTranslation
    local mathRound = math.Round
    local mathClamp = math.Clamp
    local mathCeil = math.ceil

    ---
    -- @ignore
    function SWEP:Initialize()
        self:AddTTT2HUDHelp("binoc_help_pri", "binoc_help_sec")
        self:AddHUDHelpLine("binoc_help_reload", Key("+reload", "undefined_key"))

        BaseClass.Initialize(self)
    end

    ---
    -- @realm client
    function SWEP:InitializeCustomModels()
        self:AddCustomWorldModel("wmodel", {
            type = "Model",
            model = "models/Items/combine_rifle_cartridge01.mdl",
            bone = "ValveBiped.Bip01_R_Hand",
            rel = "",
            pos = Vector(4, 5, 0),
            angle = Angle(0, 80, -20),
            size = Vector(0.7, 0.7, 0.7),
            color = Color(255, 255, 255, 255),
            surpresslightning = false,
            material = "",
            skin = 0,
            bodygroup = {},
        })
    end

    ---
    -- @ignore
    function SWEP:AdjustMouseSensitivity()
        if self:GetZoomAmount() > 0 then
            return 1 / self:GetZoomAmount()
        end

        return -1
    end

    hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDBinocular", function(tData)
        local client = LocalPlayer()
        local ent = tData:GetEntity()

        if not IsValid(client) or not client:IsTerror() or not client:Alive() then
            return
        end

        local c_wep = client:GetActiveWeapon()

        if
            not IsValid(ent)
            or not IsValid(c_wep)
            or not ent:IsPlayerRagdoll()
            or c_wep:GetClass() ~= "weapon_ttt_binoculars"
            or c_wep:GetProcessTarget() ~= ent
        then
            return
        end

        local progress =
            mathRound(mathClamp((c_wep:GetProgress() / c_wep.ProcessingDelay) * 100, 0, 100))

        tData:AddDescriptionLine(
            GetPT("binoc_progress", { progress = progress }),
            client.GetRoleColor and client:GetRoleColor() or roles.INNOCENT.color
        )
    end)

    ---
    -- @ignore
    function SWEP:DrawHUD()
        BaseClass.DrawHUD(self)

        local client = LocalPlayer()
        local scale = appearance.GetGlobalScale()
        local color = appearance.SelectFocusColor(
            client.GetRoleColor and client:GetRoleColor() or roles.INNOCENT.color
        )

        draw.ShadowedText(
            TryT("binoc_zoom_level") .. ": " .. self:GetZoomAmount(),
            "TargetID_Description",
            mathCeil(ScrW() * 0.5) + 45 * scale,
            mathCeil(ScrH() * 0.5) - 35 * scale,
            color,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )
    end
end
