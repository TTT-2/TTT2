---
-- Radar rendering
-- @module radar

if SERVER then
    AddCSLuaFile()
    util.AddNetworkString("TTT_CorpseCall")
    return
end

RADAR = RADAR or {}

local math = math

local net = net
local table = table
local IsValid = IsValid
local hook = hook

local surface = surface
local GetTranslation
local GetPTranslation
local pairs = pairs

local c4warn = surface.GetTextureID("vgui/ttt/icon_c4warn")
local sample_scan = surface.GetTextureID("vgui/ttt/sample_scan")
local det_beacon = surface.GetTextureID("vgui/ttt/det_beacon")

RADAR.bombs = {}
RADAR.bombs_count = 0
RADAR.samples = {}
RADAR.samples_count = 0
RADAR.called_corpses = {}

---
-- Clears the radar
-- @internal
-- @realm client
function RADAR:Clear()
    self.bombs = {}
    self.samples = {}
    self.bombs_count = 0
    self.samples_count = 0
end

---
-- Cache stuff we'll be drawing
-- @internal
-- @realm client
function RADAR.CacheEnts()
    -- also do some corpse cleanup here
    for k, corpse in pairs(RADAR.called_corpses) do
        if corpse.called + 45 < CurTime() then
            RADAR.called_corpses[k] = nil -- will make # inaccurate, no big deal
        end
    end

    if RADAR.bombs_count == 0 then
        return
    end

    -- Update bomb positions for those we know about
    for idx, b in pairs(RADAR.bombs) do
        local ent = Entity(idx)

        if IsValid(ent) then
            b.pos = ent:GetPos()
        end
    end
end

function RADAR.DrawTarget(tgt, size, offset, no_shrink)
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
function RADAR:Draw(client)
    if not IsValid(client) then
        return
    end

    GetPTranslation = GetPTranslation or LANG.GetParamTranslation

    surface.SetFont("HudSelectionText")

    -- bomb warnings
    -- note: This is deprecated use markerVision instead
    if self.bombs_count ~= 0 and client:IsActive() and not client:GetSubRoleData().unknownTeam then
        surface.SetTexture(c4warn)
        surface.SetTextColor(client:GetRoleColor())
        surface.SetDrawColor(255, 255, 255, 200)

        for _, bomb in pairs(self.bombs) do
            if bomb.team ~= nil and bomb.team == client:GetTeam() then
                self.DrawTarget(bomb, 24, 0, true)
            end
        end
    end

    -- corpse calls
    if not table.IsEmpty(self.called_corpses) then
        surface.SetTexture(det_beacon)
        surface.SetTextColor(255, 255, 255, 240)
        surface.SetDrawColor(255, 255, 255, 230)

        for _, corpse in pairs(self.called_corpses) do
            self.DrawTarget(corpse, 16, 0.5)
        end
    end

    -- DNA samples
    if self.samples_count ~= 0 then
        surface.SetTexture(sample_scan)
        surface.SetTextColor(200, 50, 50, 255)
        surface.SetDrawColor(255, 255, 255, 240)

        for _, sample in pairs(self.samples) do
            self.DrawTarget(sample, 16, 0.5, true)
        end
    end
end

local function TTT_CorpseCall()
    local pos = net.ReadVector()
    local _tmp = { pos = pos, called = CurTime() }

    table.insert(RADAR.called_corpses, _tmp)
end
net.Receive("TTT_CorpseCall", TTT_CorpseCall)
