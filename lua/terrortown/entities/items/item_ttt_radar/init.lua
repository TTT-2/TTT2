---
-- @class ITEM
-- @section RADAR

local math = math

local net = net
local table = table
local IsValid = IsValid
local hook = hook
local playerGetAll = player.GetAll

local cv_radarCharge

util.AddNetworkString("TTT2RadarUpdateAutoScan")
util.AddNetworkString("TTT2RadarUpdateTime")

---
-- @ignore
function ITEM:Initialize()
    cv_radarCharge = GetConVar("ttt2_radar_charge_time")
end

local function UpdateTimeOnPlayer(ply)
    if ply.lastRadarTime == ply.radarTime then
        return
    end

    ply.lastRadarTime = ply.radarTime

    net.Start("TTT2RadarUpdateTime")
    net.WriteUInt(ply.radarTime, 8)
    net.Send(ply)
end

---
-- @class RADAR

RADAR = RADAR or {}

---
-- Triggers a new radar scan. Fails if the radar is still charging.
-- @param Player ply The player whose radar is affected
-- @internal
-- @realm server
function RADAR.TriggerRadarScan(ply)
    if not IsValid(ply) or not ply:IsTerror() then
        return
    end

    if not ply:HasEquipmentItem("item_ttt_radar") then
        LANG.Msg(ply, "radar_not_owned", nil, MSG_CHAT_WARN)

        return
    end

    if ply.radar_charge > CurTime() then
        LANG.Msg(ply, "radar_charging", nil, MSG_CHAT_WARN)

        return
    end

    -- update radar time after the previous scan was finished
    UpdateTimeOnPlayer(ply)

    -- remove 0.1 seconds to account for rounding errors
    ply.radar_charge = CurTime() + ply.radarTime - 0.1

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

            targets[#targets + 1] = RADAR.CreateTargetTable(ply, pos, ent)
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
concommand.Add("ttt_radar_scan", RADAR.TriggerRadarScan)

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
function RADAR.CreateTargetTable(ply, pos, ent, color)
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
function RADAR.SetupRadarScan(ply)
    timer.Create("radarTimeout_" .. ply:SteamID64(), ply.radarTime, 1, function()
        if
            not IsValid(ply)
            or not ply:HasEquipmentItem("item_ttt_radar")
            or ply.radarDoesNotRepeat
        then
            return
        end

        RADAR.TriggerRadarScan(ply)
        RADAR.SetupRadarScan(ply)
    end)
end

---
-- Inits the radar.
-- Called when the radar is added to the player.
-- @param Player ply The player who owens the radar
-- @realm server
function RADAR.Init(ply)
    if not IsValid(ply) then
        return
    end

    ply:ResetRadarTime()

    RADAR.TriggerRadarScan(ply)
    RADAR.SetupRadarScan(ply)
end

---
-- Deinits the radar.
-- Called when the radar is removed from the player.
-- @param Player ply The player who owned the radar
-- @realm server
function RADAR.Deinit(ply)
    if not IsValid(ply) then
        return
    end

    timer.Remove("radarTimeout_" .. ply:SteamID64())
end

net.Receive("TTT2RadarUpdateAutoScan", function(_, ply)
    if not IsValid(ply) then
        return
    end

    ply.radarDoesNotRepeat = not net.ReadBool()
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
function plymeta:ResetRadarTime()
    self.radarTime = self:GetSubRoleData().radarTime or cv_radarCharge:GetInt()
end

---
-- Forces a new radar scan, even when the radar is still charging. It is recommended to
-- call this function after @{plymeta:SetRadarTime} to enforce an immediate change.
-- @realm server
function plymeta:ForceRadarScan()
    if not self:HasEquipmentItem("item_ttt_radar") then
        return
    end

    RADAR.Deinit(self)

    -- reset the radar charge end time to now to allow a new scan
    self.radar_charge = CurTime()

    RADAR.TriggerRadarScan(self)
    RADAR.SetupRadarScan(self)
end
