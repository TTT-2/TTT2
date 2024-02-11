---
-- drawsc library functions
-- adds a secondary function that draws based on the global scale factor
-- which is based on a 1920x1080p resolution
-- @author Mineotopia
-- @module drawsc

if SERVER then
    AddCSLuaFile()

    return
end

local GetGlobalScale = appearance.GetGlobalScale

local mRound = math.Round
local drawOutlinedBox = draw.OutlinedBox
local drawOutlinedShadowedBox = draw.OutlinedShadowedBox
local drawBox = draw.Box
local drawShadowedBox = draw.ShadowedBox
local drawOutlinedCircle = draw.OutlinedCircle
local drawOutlinedShadowedCircle = draw.OutlinedShadowedCircle
local drawFilteredTexture = draw.FilteredTexture
local drawFilteredShadowedTexture = draw.FilteredShadowedTexture
local drawAdvancedText = draw.AdvancedText
local drawBlurredBox = draw.BlurredBox

drawsc = {}

---
-- A function to draw an outlined box with a definable width
-- @note The size is scaled by the global scale factor
-- @param number x The x position of the outlined box
-- @param number y The y position of the outlined box
-- @param number w The width of the outlined box
-- @param number h The height of the outlined box
-- @param[default=1] number t The thickness of the outline
-- @param[default=Color(255, 255, 255, 255)] Color color The color of the line
-- @2D
-- @realm client
function drawsc.OutlinedBox(x, y, w, h, t, color)
    local scale = GetGlobalScale()

    drawOutlinedBox(
        mRound(x * scale),
        mRound(y * scale),
        mRound(w * scale),
        mRound(h * scale),
        mRound(t * scale),
        color
    )
end

---
-- A function to draw an outlined box with a shadow
-- @note The size is scaled by the global scale factor
-- @param number x The x position of the rectangle
-- @param number y The y position of the rectangle
-- @param number w The width of the rectangle
-- @param number h The height of the rectangle
-- @param[default=1] number t The thickness of the line
-- @param[default=Color(255, 255, 255, 255)] Color color The color of the line
-- @2D
-- @realm client
function drawsc.OutlinedShadowedBox(x, y, w, h, t, color)
    local scale = GetGlobalScale()

    drawOutlinedShadowedBox(
        mRound(x * scale),
        mRound(y * scale),
        mRound(w * scale),
        mRound(h * scale),
        mRound(t * scale),
        color,
        scale
    )
end

---
-- A function to draws a simple box without a corner radius
-- @note The size is scaled by the global scale factor
-- @param number x The x position to start the box
-- @param number y The y position to start the box
-- @param number w The width of the box
-- @param number h The height of the box
-- @param[default=Color(255, 255, 255, 255)] Color color The color of the box
-- @2D
-- @realm client
function drawsc.Box(x, y, w, h, color)
    local scale = GetGlobalScale()

    drawBox(mRound(x * scale), mRound(y * scale), mRound(w * scale), mRound(h * scale), color)
end

---
-- A function to draws a simple shadowed box without a corner radius
-- @note The size is scaled by the global scale factor
-- @param number x The x position to start the box
-- @param number y The y position to start the box
-- @param number w The width of the box
-- @param number h The height of the box
-- @param[default=Color(255, 255, 255, 255)] Color color The color of the box
-- @2D
-- @realm client
function drawsc.ShadowedBox(x, y, w, h, color)
    local scale = GetGlobalScale()

    drawShadowedBox(
        mRound(x * scale),
        mRound(y * scale),
        mRound(w * scale),
        mRound(h * scale),
        color,
        scale
    )
end

---
-- A function to draws a circle outline
-- @note The size is scaled by the global scale factor
-- @param number x The center x position to start the circle
-- @param number y The center y position to start the circle
-- @param number r The radius of the circle
-- @param[default=Color(255, 255, 255, 255)] Color color The color of the circle
-- @2D
-- @realm client
function drawsc.OutlinedCircle(x, y, r, color)
    local scale = GetGlobalScale()

    drawOutlinedCircle(mRound(x * scale), mRound(y * scale), mRound(r * scale), color)
end

---
-- A function to draws a circle outline with a shadow
-- @note The size is scaled by the global scale factor
-- @param number x The center x position to start the circle
-- @param number y The center y position to start the circle
-- @param number r The radius of the circle
-- @param[default=Color(255, 255, 255, 255)] Color color The color of the circle
-- @2D
-- @realm client
function drawsc.OutlinedShadowedCircle(x, y, r, color)
    local scale = GetGlobalScale()

    drawOutlinedShadowedCircle(
        mRound(x * scale),
        mRound(y * scale),
        mRound(r * scale),
        color,
        scale
    )
end

---
-- Draws a filtered textured rectangle / image / icon
-- @note The size is scaled by the global scale factor
-- @param number x The horizontal position
-- @param number y The vertical position
-- @param number w width The width
-- @param number h height The height
-- @param Material material The material
-- @param[default=255] number alpha The opacity of the material
-- @param[default=Color(255, 255, 255, 255)] Color col the alpha value will be ignored
-- @2D
-- @realm client
function drawsc.FilteredTexture(x, y, w, h, material, alpha, color)
    local scale = GetGlobalScale()

    drawFilteredTexture(
        mRound(x * scale),
        mRound(y * scale),
        mRound(w * scale),
        mRound(h * scale),
        material,
        alpha,
        color
    )
end

---
-- Draws a filtered textured rectangle / image / icon with shadow
-- @note The size is scaled by the global scale factor
-- @param number x The horizontal position
-- @param number y The vertical position
-- @param number w width The width
-- @param number h height The height
-- @param Material material The material
-- @param[default=255] number alpha The opacity of the material
-- @param[default=Color(255, 255, 255, 255)] Color col the alpha value will be ignored
-- @2D
-- @realm client
function drawsc.FilteredShadowedTexture(x, y, w, h, material, alpha, color)
    local scale = GetGlobalScale()

    drawFilteredShadowedTexture(
        mRound(x * scale),
        mRound(y * scale),
        mRound(w * scale),
        mRound(h * scale),
        material,
        alpha,
        color,
        scale
    )
end

---
-- Draws an advanced text (scalable)
-- @note The size is scaled by the global scale factor
-- @param string text The text to be drawn
-- @param[default="DefaultBold"] string font The font. See @{surface.CreateAdvancedFont} to create your own. The original font should be always created, see @{surface.CreateFont}.
-- @param number x The x coordinate
-- @param number y The y coordinate
-- @param Color color The color of the text. Uses the Color structure.
-- @param number xalign The alignment of the x coordinate using
-- <a href="https://wiki.facepunch.com/gmod/Enums/TEXT_ALIGN">TEXT_ALIGN_Enums</a>.
-- @param number yalign The alignment of the y coordinate using
-- <a href="https://wiki.facepunch.com/gmod/Enums/TEXT_ALIGN">TEXT_ALIGN_Enums</a>.
-- @param[default=0] number angle The rotational angle in degree
-- @2D
-- @realm client
function drawsc.AdvancedText(text, font, x, y, color, xalign, yalign, angle)
    local scale = GetGlobalScale()

    drawAdvancedText(
        text,
        font,
        mRound(x * scale),
        mRound(y * scale),
        color,
        xalign,
        yalign,
        false,
        scale,
        angle
    )
end

---
-- Draws an advanced text (scalable) with a drop shadow
-- @note The size is scaled by the global scale factor
-- @param string text The text to be drawn
-- @param[default="DefaultBold"] string font The font. See @{surface.CreateAdvancedFont} to create your own. The original font should be always created, see @{surface.CreateFont}.
-- @param number x The x coordinate
-- @param number y The y coordinate
-- @param Color color The color of the text. Uses the Color structure.
-- @param number xalign The alignment of the x coordinate using
-- <a href="https://wiki.facepunch.com/gmod/Enums/TEXT_ALIGN">TEXT_ALIGN_Enums</a>.
-- @param number yalign The alignment of the y coordinate using
-- <a href="https://wiki.facepunch.com/gmod/Enums/TEXT_ALIGN">TEXT_ALIGN_Enums</a>.
-- @param[default=0] number angle The rotational angle in degree
-- @2D
-- @realm client
function drawsc.AdvancedShadowedText(text, font, x, y, color, xalign, yalign, angle)
    local scale = GetGlobalScale()

    drawAdvancedText(
        text,
        font,
        mRound(x * scale),
        mRound(y * scale),
        color,
        xalign,
        yalign,
        true,
        scale,
        angle
    )
end

---
-- Draws a box that uses the remaining screenspace as a blurred background.
-- @param number x The vertical position
-- @param number y The horizontal position
-- @param number w width The width in reference to the vertical position
-- @param number h height The height in reference to the horizontal position
-- @param[default=1] number fraction The blur fraction. The higher, the blurrier
-- @2D
-- @realm client
function drawsc.BlurredBox(x, y, w, h, fraction)
    local scale = GetGlobalScale()

    drawBlurredBox(
        mRound(x * scale),
        mRound(y * scale),
        mRound(w * scale),
        mRound(h * scale),
        fraction
    )
end
