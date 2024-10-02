---
-- @module dmgindicator

dmgindicator = {
    themes = {},

    -- setup convars
    cv = {
        ---
        -- @realm client
        enable = CreateConVar("ttt_dmgindicator_enable", "1", FCVAR_ARCHIVE),

        ---
        -- @realm client
        mode = CreateConVar("ttt_dmgindicator_mode", "default", FCVAR_ARCHIVE),

        ---
        -- @realm client
        duration = CreateConVar("ttt_dmgindicator_duration", "1.5", FCVAR_ARCHIVE),

        ---
        -- @realm client
        maxdamage = CreateConVar("ttt_dmgindicator_maxdamage", "50.0", FCVAR_ARCHIVE),

        ---
        -- @realm client
        maxalpha = CreateConVar("ttt_dmgindicator_maxalpha", "255", FCVAR_ARCHIVE),
    },
}

local lastDamage = CurTime()
local damageAmount = 0.0
local maxDamageAmount = 0.0

local materialStringBase = "vgui/ttt/dmgindicator/themes/"
local pathBase = "materials/" .. materialStringBase

local function CollectDmgIndicatorTextures()
    local materials = file.Find(pathBase .. "*.png", "GAME")

    for i = 1, #materials do
        local material = materials[i]
        local materialName = string.StripExtension(material)

        dmgindicator.themes[materialName] = Material(materialStringBase .. material)
    end
end

CollectDmgIndicatorTextures()

net.Receive("ttt2_damage_received", function()
    local damageReceived = net.ReadFloat()
    if damageReceived <= 0 then
        return
    end

    lastDamage = CurTime()
    maxDamageAmount = math.min(
        1.0,
        math.max(damageAmount, 0.0) + damageReceived / dmgindicator.cv.maxdamage:GetFloat()
    )
    damageAmount = maxDamageAmount
end)

---
-- Called before @{GM:HUDPaint} when the HUD background is being drawn.
-- Things rendered in this hook will always appear behind things rendered in @{GM:HUDPaint}.
-- @2D
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:HUDPaintBackground
-- @local
function GM:HUDPaintBackground()
    if not dmgindicator.cv.enable:GetBool() then
        return
    end

    local indicatorDuration = dmgindicator.cv.duration:GetFloat()

    if damageAmount > 0 then
        local theme = dmgindicator.themes[dmgindicator.cv.mode:GetString()]
            or dmgindicator.themes["Default"]
        local remainingTimeFactor = math.max(0, indicatorDuration - (CurTime() - lastDamage))
            / indicatorDuration

        damageAmount = maxDamageAmount * remainingTimeFactor

        surface.SetDrawColor(255, 255, 255, dmgindicator.cv.maxalpha:GetInt() * damageAmount)
        surface.SetMaterial(theme)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    end
end

---
-- Returns an indexed table with the names of all themes
-- @return table A table with names of all themes
-- @realm client
function dmgindicator.GetThemeNames()
    return table.GetKeys(dmgindicator.themes)
end
