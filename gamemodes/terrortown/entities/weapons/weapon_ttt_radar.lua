---
-- @class SWEP
-- @desc radar
-- @section weapon_ttt_radar

local playerGetAll = player.GetAll

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
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.0

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE } -- only traitors can buy
SWEP.LimitedStock = true -- only buyable once
SWEP.WeaponID = EQUIP_RADAR or 2

SWEP.builtin = true

SWEP.AllowDrop = true
SWEP.NoSights = true

-- Radar specific
SWEP.IsAutomaticScanRunning = false
local targets = {}
local statusIcon = Material("vgui/ttt/perks/hud_radar.png")
local radarAvailable = "radar_scan_available"
local radarBlocked = "radar_scan_blocked"

if CLIENT then
    STATUS:RegisterStatus(radarAvailable, {
        -- sets the icon that will be rendered
        hud = statusIcon,
        -- the type that defines the color, it can be 'good', 'bad' or 'default'
        type = "good",
    })
    STATUS:RegisterStatus(radarBlocked, {
        -- sets the icon that will be rendered
        hud = statusIcon,
        -- the type that defines the color, it can be 'good', 'bad' or 'default'
        type = "bad",
    })
end

---
-- @realm server
local function UpdateStatus(radarEnt, applyToNewOwner)
    if CLIENT or not IsValid(radarEnt) then
        return
    end

    local lastPly = radarEnt:GetLastOwner()
    if IsValid(lastPly) then
        STATUS:RemoveStatus(lastPly, radarAvailable)
        STATUS:RemoveStatus(lastPly, radarBlocked)
    end

    local curPly = radarEnt:GetOwner()
    if applyToNewOwner and IsValid(curPly) then
        local remainingTime = radarEnt:GetRemainingTime()
        if remainingTime > 0 then
            STATUS:AddTimedStatus(curPly, radarBlocked, remainingTime, true)
        else
            STATUS:AddStatus(curPly, radarAvailable)
        end
    end
end

-- @realm shared
-- stylua: ignore
cvRadarChargeTime = CreateConVar("ttt2_radar_charge_time", "30", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsRepeatMode")
    self:NetworkVar("Float", 0, "LastRadarTime")
    self:NetworkVar("Entity", 0, "LastOwner")
end

function SWEP:Reset()
    self:SetIsRepeatMode(true)
    self:SetLastRadarTime(CurTime() - cvRadarChargeTime:GetInt())
end

---
-- @ignore
function SWEP:Initialize()
    self.BaseClass.Initialize(self)

    self:Reset()

    if CLIENT then
        hook.Add("HUDPaint", "Radar_Weapon_Targets", function()
            if not IsValid(self) then
                hook.Remove("HUDPaint", "Radar_Weapon_Targets")
                return
            end
            if self:ShouldDraw() then
                self:Draw()
            end
        end)

        self:AddTTT2HUDHelp("radar_scan", "radar_auto")
    end
end

function SWEP:Equip(newOwner)
    self:SetLastOwner(newOwner)
    UpdateStatus(self, true)

    if self:GetIsRepeatMode() then
        self:TryTriggerScan()
    end
end

function SWEP:OnDrop()
    UpdateStatus(self, false)
end

function SWEP:OnRemove()
    UpdateStatus(self, false)
    hook.Remove("HUDPaint", "Radar_Weapon_Targets")
end

---
-- @ignore
function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    if self:TryTriggerScan() then
        -- TODO: Play Sound
    else
        -- LANG.Msg(self:GetOwner(), "radar_charging", nil, MSG_CHAT_WARN)
    end
end

---
-- @ignore
function SWEP:SecondaryAttack()
    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

    self:SetIsRepeatMode(not self:GetIsRepeatMode())

    if self:GetIsRepeatMode() then
        self:TryTriggerScan()
    end
    -- TODO: Play Sound
end

---
-- @ignore
function SWEP:Reload()
    return false
end

function SWEP:CanTriggerNextScan()
    return IsValid(self:GetOwner()) and self:GetRemainingTime() <= 0
end

---
-- Creates a new radar point
-- @param Player ply The player that will see this radar point
-- @param Vector pos The position of the radar point
-- @param[opt] Entity ent The entity that is used for this radar point
-- @param[opt] Color color A color for this radar point, this overwrites the normal color
-- @return table
-- @realm server
local function CreateTargetTable(ply, pos, ent, color)
    local subrole, team = -1, "none"

    if not IsValid(ent) then
        subrole = -1
    elseif not ent:IsPlayer() then
        -- Decoys appear as innocents for players from other teams
        if ent:GetNWString("decoy_owner_team", "none") ~= ply:GetTeam() then
            subrole = ROLE_INNOCENT
            team = TEAM_INNOCENT
        end
    else
        ---
        -- @realm server
        -- stylua: ignore
        subrole, team = hook.Run("TTT2ModifyRadarRole", ply, ent)

        if not subrole then
            subrole = (
                ent:IsInTeam(ply)
                or table.HasValue(ent:GetSubRoleData().visibleForTeam, ply:GetTeam())
            )
                    and ent:GetSubRole()
                or ROLE_INNOCENT
        end

        if not team then
            team = (
                ent:IsInTeam(ply)
                or table.HasValue(ent:GetSubRoleData().visibleForTeam, ply:GetTeam())
            )
                    and ent:GetTeam()
                or TEAM_INNOCENT
        end
    end

    return {
        pos = pos,
        subrole = subrole,
        team = team,
        color = color,
    }
end

---
-- Triggers a new radar scan. Fails if the radar is still charging.
-- @param bool isAutomatic
-- @internal
-- @realm shared
function SWEP:TryTriggerScan()
    if not self:CanTriggerNextScan() then
        return false
    end

    self:SetLastRadarTime(CurTime())
    UpdateStatus(self, true)

    timer.Simple(cvRadarChargeTime:GetInt(), function()
        UpdateStatus(self, true)

        if not IsValid(self) or not self:GetIsRepeatMode() then
            return
        end

        self:TryTriggerScan()
    end)

    if CLIENT then
        return true
    end

    local ply = self:GetOwner()

    local scan_ents = playerGetAll()

    table.Add(scan_ents, ents.FindByClass("ttt_decoy"))

    local targets = {}
    for i = 1, #scan_ents do
        local ent = scan_ents[i]

        if
            not IsValid(ent)
            or ply == ent
            or ent:IsPlayer() and (not ent:IsTerror() or ent:GetNWBool("disguised", false))
        then
            continue
        end

        local pos = ent:LocalToWorld(ent:OBBCenter())

        -- Round off, easier to send and inaccuracy does not matter
        pos.x = math.Round(pos.x)
        pos.y = math.Round(pos.y)
        pos.z = math.Round(pos.z)

        targets[#targets + 1] = CreateTargetTable(ply, pos, ent)
    end

    net.Start("TTT_Radar")
    net.WriteUInt(#targets, 16)

    for i = 1, #targets do
        local tgt = targets[i]

        net.WriteInt(tgt.pos.x, 15)
        net.WriteInt(tgt.pos.y, 15)
        net.WriteInt(tgt.pos.z, 15)

        if tgt.subrole == -1 then
            net.WriteBool(false)
        else
            net.WriteBool(true)
            net.WriteUInt(tgt.subrole, ROLE_BITS)
        end

        net.WriteString(tgt.team or "none")

        if tgt.color then
            net.WriteBool(true)
            net.WriteColor(tgt.color)
        else
            net.WriteBool(false)
        end
    end

    net.Send(ply)

    return true
end

function SWEP:GetRemainingTime()
    return math.max(0, self:GetLastRadarTime() + cvRadarChargeTime:GetInt() - CurTime() - 0.1)
end

if CLIENT then
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

    local indicator = surface.GetTextureID("effects/select_ring")
    local colorFallback = Color(150, 150, 150)
    local near_cursor_dist = 180

    function SWEP:Draw()
        surface.SetFont("HudSelectionText")
        surface.SetTexture(indicator)
        local mpos = Vector(ScrW() * 0.5, ScrH() * 0.5, 0)

        local subrole, alpha, scrpos, md

        for i = 1, #targets do
            local tgt = targets[i]

            alpha = 255
            scrpos = tgt.pos:ToScreen()

            if scrpos.visible then
                md = mpos:Distance(Vector(scrpos.x, scrpos.y, 0))

                if md < near_cursor_dist then
                    alpha = math.Clamp(alpha * (md / near_cursor_dist), 40, 230)
                end

                subrole = tgt.subrole or ROLE_INNOCENT

                local roleData = roles.GetByIndex(subrole)
                local c = roleData.radarColor
                    or (TEAMS[tgt.team] and TEAMS[tgt.team].color or colorFallback)

                if tgt.color then
                    surface.SetDrawColor(tgt.color.r, tgt.color.g, tgt.color.b, alpha)
                    surface.SetTextColor(tgt.color.r, tgt.color.g, tgt.color.b, alpha)
                else
                    surface.SetDrawColor(c.r, c.g, c.b, alpha)
                    surface.SetTextColor(c.r, c.g, c.b, alpha)
                end

                RADAR.DrawTarget(tgt, 24, 0)
            end
        end
    end

    function SWEP:ShouldDraw()
        return IsValid(self:GetOwner())
            and self:GetOwner() == LocalPlayer()
            and self:GetRemainingTime() > 0
    end

    local function ReceiveRadarScan()
        local num_targets = net.ReadUInt(16)

        targets = {}

        for i = 1, num_targets do
            local pos = Vector(net.ReadInt(15), net.ReadInt(15), net.ReadInt(15))

            local hasSubrole = net.ReadBool()
            local subrole

            if hasSubrole then
                subrole = net.ReadUInt(ROLE_BITS)
            end

            local team = net.ReadString()

            local color

            if net.ReadBool() then
                color = net.ReadColor()
            end

            targets[i] = {
                pos = pos,
                subrole = subrole,
                team = team,
                hasSubrole = hasSubrole,
                color = color,
            }
        end
    end
    net.Receive("TTT_Radar", ReceiveRadarScan)
end
