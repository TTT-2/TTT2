---
-- font library functions
-- adds support for advanced fonts (fonts with mipmapping)
-- @author Mineotopia, LeBroomer
-- @module fonts

if SERVER then
    AddCSLuaFile()

    return
end

local surface = surface
local mathMax = math.max
local isvector = isvector
local tonumber = tonumber
local tostring = tostring

fonts = {}
fonts.fonts = {}
fonts.scales = { 1, 1.5, 2, 2.5 }

---
-- Gets the scale modifer based on a given scale. This function tries to find one of
-- the given steps defined in `fonts.scales` that fits best to the given scale. If it
-- fails to find a fitting scale, it returns the largest available.
-- @param number|Vector scale The font scale
-- @return number The font scale
-- @internal
-- @realm client
function fonts.GetScaleModifier(scale)
    local scaleFactor = isvector(scale) and mathMax(scale.x, mathMax(scale.y, scale.z)) or scale

    scaleFactor = tonumber(scaleFactor)

    local fontScales = fonts.scales

    for i = 1, #fontScales do
        if scaleFactor < fontScales[i] then
            return i - 1 > 0 and fontScales[i - 1] or fontScales[i]
        end
    end

    --fallback (return the last scale)
    return fontScales[#fontScales]
end

---
-- Adds a font to the font list.
-- @param string name The name of the font
-- @param[default=13] number baseSize The basesize of this font
-- @param table fontData
-- @internal
-- @realm client
function fonts.AddFont(name, baseSize, fontData)
    baseSize = baseSize or 13

    fonts.fonts[name] = {}

    for i = 1, #fonts.scales do
        local scale = fonts.scales[i]
        local nameScaled = scale == 1 and name or name .. tostring(scale)

        fontData.size = scale * baseSize

        surface.CreateFont(nameScaled, fontData)

        fonts.fonts[name][scale] = nameScaled
    end
end

---
-- Returns a specified font.
-- @param string name The font name
-- @return table A table of the font with different scales
-- @realm client
function fonts.GetFont(name)
    return fonts.fonts[name]
end

---
-- Returns a table of all font scales.
-- @return table A table of all font scales
-- @realm client
function fonts.GetScales()
    return fonts.scales
end

---
-- Gets the scaled variant of a font.
-- @param string name The font name
-- @param number[default=appearance.GetGlobalScale()] scale The target scale
-- @return string The name of the scaled font
-- @return number The scale that the font needs to be rendered at to exactly match the target scale
-- @return number The font scale modifier
-- @realm client
function fonts.ScaledFont(font, scale, t_font)
    if not scale then
        scale = appearance.GetGlobalScale()
    end
    t_font = t_font or fonts.GetFont(font)
    local scaleModifier = fonts.GetScaleModifier(scale)
    font = t_font[scaleModifier]
    scale = scale / scaleModifier
    return font, scale, scaleModifier
end
