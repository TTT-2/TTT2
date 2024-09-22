---
-- Radar rendering
-- @module radar

if SERVER then
    AddCSLuaFile()

    util.AddNetworkString("TTT2RadarUpdateAutoScan")
    util.AddNetworkString("TTT2RadarUpdateTime")
end

radar = radar or {}

local math = math

local net = net
local table = table
local IsValid = IsValid
local hook = hook
local playerGetAll = player.GetAll

if CLIENT then
    local surface = surface
    local GetTranslation
    local GetPTranslation
    local pairs = pairs

    local indicator = surface.GetTextureID("effects/select_ring")
    local c4warn = surface.GetTextureID("vgui/ttt/icon_c4warn")
    local sample_scan = surface.GetTextureID("vgui/ttt/sample_scan")
    local det_beacon = surface.GetTextureID("vgui/ttt/det_beacon")
    local near_cursor_dist = 180

    local colorFallback = Color(150, 150, 150)

    radar.targets = {}
    radar.enable = false
    radar.startTime = 0
    radar.bombs = {}
    radar.bombs_count = 0
    radar.repeating = true
    radar.samples = {}
    radar.samples_count = 0
    radar.called_corpses = {}

    ---
    -- Disables the scan
    -- @internal
    -- @realm client
    function radar:EndScan()
        self.enable = false
        self.startTime = 0
    end

    ---
    -- Clears the radar
    -- @internal
    -- @realm client
    function radar:Clear()
        self:EndScan()

        self.bombs = {}
        self.samples = {}
        self.bombs_count = 0
        self.samples_count = 0
    end

    ---
    -- Cache stuff we'll be drawing
    -- @internal
    -- @realm client
    function radar.CacheEnts()
        -- also do some corpse cleanup here
        for k, corpse in pairs(radar.called_corpses) do
            if corpse.called + 45 < CurTime() then
                radar.called_corpses[k] = nil -- will make # inaccurate, no big deal
            end
        end

        if radar.bombs_count == 0 then
            return
        end

        -- Update bomb positions for those we know about
        for idx, b in pairs(radar.bombs) do
            local ent = Entity(idx)

            if IsValid(ent) then
                b.pos = ent:GetPos()
            end
        end
    end

    local function DrawTarget(tgt, size, offset, no_shrink)
        local scrpos = tgt.pos:ToScreen() -- sweet
        local sz = (util.IsOffScreen(scrpos) and not no_shrink) and (size * 0.5) or size

        scrpos.x = math.Clamp(scrpos.x, sz, ScrW() - sz)
        scrpos.y = math.Clamp(scrpos.y, sz, ScrH() - sz)

        if util.IsOffScreen(scrpos) then
            return
        end

        surface.DrawTexturedRect(scrpos.x - sz, scrpos.y - sz, sz * 2, sz * 2)

        -- Drawing full size?
        if sz == size then
            local text = tostring(
                math.Round(util.HammerUnitsToMeters(LocalPlayer():EyePos():Distance(tgt.pos)), 0)
            ) .. "m"
            local w, h = surface.GetTextSize(text)

            -- Show range to target
            surface.SetTextPos(scrpos.x - w * 0.5, scrpos.y + offset * sz - h * 0.5)
            surface.DrawText(text)

            if tgt.t then
                -- Show time
                text = util.SimpleTime(tgt.t - CurTime(), "%02i:%02i")
                w, h = surface.GetTextSize(text)

                surface.SetTextPos(scrpos.x - w * 0.5, scrpos.y + sz * 0.5)
                surface.DrawText(text)
            elseif tgt.nick then
                -- Show nickname
                text = tgt.nick
                w, h = surface.GetTextSize(text)

                surface.SetTextPos(scrpos.x - w * 0.5, scrpos.y + sz * 0.5)
                surface.DrawText(text)
            end
        end
    end

    ---
    -- Draws the indicator on the screen
    -- @param Player client
    -- @hook
    -- @internal
    -- @realm client
    function radar:Draw(client)
        if not IsValid(client) then
            return
        end

        GetPTranslation = GetPTranslation or LANG.GetParamTranslation

        surface.SetFont("HudSelectionText")

        -- bomb warnings
        -- note: This is deprecated use markerVision instead
        if
            self.bombs_count ~= 0
            and client:IsActive()
            and not client:GetSubRoleData().unknownTeam
        then
            surface.SetTexture(c4warn)
            surface.SetTextColor(client:GetRoleColor())
            surface.SetDrawColor(255, 255, 255, 200)

            for _, bomb in pairs(self.bombs) do
                if bomb.team ~= nil and bomb.team == client:GetTeam() then
                    DrawTarget(bomb, 24, 0, true)
                end
            end
        end

        -- corpse calls
        if not table.IsEmpty(self.called_corpses) then
            surface.SetTexture(det_beacon)
            surface.SetTextColor(255, 255, 255, 240)
            surface.SetDrawColor(255, 255, 255, 230)

            for _, corpse in pairs(self.called_corpses) do
                DrawTarget(corpse, 16, 0.5)
            end
        end

        -- DNA samples
        if self.samples_count ~= 0 then
            surface.SetTexture(sample_scan)
            surface.SetTextColor(200, 50, 50, 255)
            surface.SetDrawColor(255, 255, 255, 240)

            for _, sample in pairs(self.samples) do
                DrawTarget(sample, 16, 0.5, true)
            end
        end

        -- player radar
        if not self.enable then
            return
        end

        surface.SetTexture(indicator)

        local radarTime = client.radarTime or 30
        local remaining = math.max(0, radarTime - (CurTime() - radar.startTime))
        local alpha_base = 55 + 200 * (remaining / radarTime)
        local mpos = Vector(ScrW() * 0.5, ScrH() * 0.5, 0)

        local subrole, alpha, scrpos, md

        for i = 1, #radar.targets do
            local tgt = radar.targets[i]

            alpha = alpha_base
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

                DrawTarget(tgt, 24, 0)
            end
        end
    end

    local function TTT_CorpseCall()
        local pos = net.ReadVector()
        local _tmp = { pos = pos, called = CurTime() }

        table.insert(radar.called_corpses, _tmp)
    end
    net.Receive("TTT_CorpseCall", TTT_CorpseCall)

    local function ReceiveRadarScan()
        local num_targets = net.ReadUInt(16)

        radar.targets = {}

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

            radar.targets[i] = {
                pos = pos,
                subrole = subrole,
                team = team,
                hasSubrole = hasSubrole,
                color = color,
            }
        end

        radar.enable = true
        radar.startTime = CurTime()
    end
    net.Receive("TTT_Radar", ReceiveRadarScan)

    local function ReceiveRadarTime()
        LocalPlayer().radarTime = net.ReadUInt(8)
    end
    net.Receive("TTT2RadarUpdateTime", ReceiveRadarTime)

    function radar:SwitchRepeatingMode()
        local newValue = not self.repeating

        self.repeating = newValue
        net.Start("TTT2RadarUpdateAutoScan")
        net.WriteBool(newValue)
        net.SendToServer()

        radar.repeating = newValue
    end

    ---
    -- Creates the settings menu
    -- @param Panel parent
    -- @param Panel frame
    -- @return Panel the dform
    -- @internal
    -- @realm client
    function radar.CreateMenu(parent, frame)
        GetTranslation = GetTranslation or LANG.GetTranslation
        GetPTranslation = GetPTranslation or LANG.GetParamTranslation
        --local w, h = parent:GetSize()

        local dform = vgui.Create("DForm", parent)
        dform:SetLabel(GetTranslation("radar_menutitle"))
        dform:StretchToParent(0, 0, 0, 0)
        dform:SetAutoSize(false)

        local owned = LocalPlayer():HasRadarEquipped()
        if not owned then
            dform:Help(GetTranslation("radar_not_owned"))

            return dform
        end

        local bw, bh = 100, 25

        local dscan = vgui.Create("DButton", dform)
        dscan:SetSize(bw, bh)
        dscan:SetText(GetTranslation("radar_scan"))

        dscan.DoClick = function(s)
            RunConsoleCommand("ttt_radar_scan")

            frame:Close()
        end

        dform:AddItem(dscan)

        local dlabel = vgui.Create("DLabel", dform)
        dlabel:SetText(GetPTranslation("radar_help", { num = LocalPlayer().radarTime or 30 }))
        dlabel:SetWrap(true)
        dlabel:SetTall(50)

        dform:AddItem(dlabel)

        local dcheck = vgui.Create("DCheckBoxLabel", dform)
        dcheck:SetText(GetTranslation("radar_auto"))
        dcheck:SetIndent(5)
        dcheck:SetValue(radar.repeating)

        dcheck.OnChange = function(s, val)
            radar:SwitchRepeatingMode()
        end

        dform:AddItem(dcheck)

        dform.Think = function(s)
            dscan:SetEnabled(not radar.repeating and owned)
        end

        dform:SetVisible(true)

        return dform
    end
end -- CLIENT

---
-- Triggers a new radar scan. Fails if the radar is still charging.
-- @param Player ply The player whose radar is affected
-- @internal
-- @realm server
function radar.TriggerRadarScan(ply)
    if not IsValid(ply) or not ply:IsTerror() then
        return
    end

    if not ply:HasRadarEquipped() then
        LANG.Msg(ply, "radar_not_owned", nil, MSG_CHAT_WARN)

        return
    end

    if ply.radarCharge > CurTime() then
        LANG.Msg(ply, "radar_charging", nil, MSG_CHAT_WARN)

        return
    end

    -- update radar time after the previous scan was finished
    if ply.lastRadarTime ~= ply.radarTime then
        ply.lastRadarTime = ply.radarTime

        net.Start("TTT2RadarUpdateTime")
        net.WriteUInt(ply.radarTime, 8)
        net.Send(ply)
    end

    -- remove 0.1 seconds to account for rounding errors
    ply.radarCharge = CurTime() + ply.radarTime - 0.1

    local targets, customradar

    if ply:GetSubRoleData() and ply:GetSubRoleData().CustomRadar then
        customradar = ply:GetSubRoleData().CustomRadar(ply)
    end

    if istable(customradar) then
        targets = table.Copy(customradar)
    else -- if we get no value we use default radar
        targets = {}

        local scan_ents = playerGetAll()

        table.Add(scan_ents, ents.FindByClass("ttt_decoy"))

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

            targets[#targets + 1] = radar.CreateTargetTable(ply, pos, ent)
        end
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
end
concommand.Add("ttt_radar_scan", radar.TriggerRadarScan)

---
-- This hook can be used to modify the radar dots of players.
-- @param Player ply The player that receives the radar information
-- @param Player target The Player whose info should be changed
-- @return nil|number The modified role
-- @return nil|string The modified team
-- @hook
-- @realm server
function GM:TTT2ModifyRadarRole(ply, target) end

local function GetDataForRadar(ply, ent)
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

    return subrole, team
end

---
-- Creates a new radar point
-- @param Player ply The player that will see this radar point
-- @param Vector pos The position of the radar point
-- @param[opt] Entity ent The entity that is used for this radar point
-- @param[opt] Color color A color for this radar point, this overwrites the normal color
-- @return table
-- @realm server
function radar.CreateTargetTable(ply, pos, ent, color)
    local subrole, team = GetDataForRadar(ply, ent)

    return {
        pos = pos,
        subrole = subrole,
        team = team,
        color = color,
    }
end

---
-- Sets up the timer for a new radar scan.
-- @param Player ply The player whose radar is affected
-- @internal
-- @realm server
function radar.SetupRadarScan(ply)
    timer.Create("radarTimeout_" .. ply:SteamID64(), ply.radarTime, 1, function()
        if not IsValid(ply) or not ply.radarRepeating or not ply:HasRadarEquipped() then
            return
        end

        radar.TriggerRadarScan(ply)
        radar.SetupRadarScan(ply)
    end)
end

---
-- Inits the radar.
-- Called when the radar is added to the player.
-- @param Player ply The player who owens the radar
-- @realm server
function radar.Init(ply)
    if not IsValid(ply) then
        return
    end

    ply:ResetRadar()

    radar.TriggerRadarScan(ply)
    radar.SetupRadarScan(ply)
end

---
-- Deinits the radar.
-- Called when the radar is removed from the player.
-- @param Player ply The player who owned the radar
-- @realm server
function radar.Deinit(ply)
    if not IsValid(ply) then
        return
    end

    timer.Remove("radarTimeout_" .. ply:SteamID64())
end

net.Receive("TTT2RadarUpdateAutoScan", function(_, ply)
    if not IsValid(ply) then
        return
    end

    ply.radarRepeating = net.ReadBool()
end)

---
-- @class Player

local plymeta = assert(FindMetaTable("Player"), "FAILED TO FIND PLAYER TABLE")

---
-- Sets the radar time interval, lets the current scan run out before it is changed.
-- @param number time The radar time interval
-- @realm server
function plymeta:SetRadarTime(time)
    self.radarTime = time
end

---
-- Sets the radar time interval to the role or convar default, lets the current scan run out before it is changed.
-- @realm server
function plymeta:ResetRadar()
    self.radarTime = self:GetSubRoleData().radarTime or GetConVar("ttt2_radar_charge_time"):GetInt()
    self.radarRepeating = self.radarRepeating or true
    self.radarCharge = 0
end

---
-- Forces a new radar scan, even when the radar is still charging. It is recommended to
-- call this function after @{plymeta:SetRadarTime} to enforce an immediate change.
-- @realm server
function plymeta:ForceRadarScan()
    if not self:HasRadarEquipped() then
        return
    end

    radar.Deinit(self)

    -- reset the radar charge end time to now to allow a new scan
    self.radarCharge = CurTime()

    radar.TriggerRadarScan(self)
    radar.SetupRadarScan(self)
end

function plymeta:HasRadarEquipped()
    return self:HasEquipmentItem("item_ttt_radar") or self:HasEquipmentWeapon("weapon_ttt_radar")
end
