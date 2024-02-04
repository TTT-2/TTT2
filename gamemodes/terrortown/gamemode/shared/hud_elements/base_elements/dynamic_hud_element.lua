---
-- @class HUDELEMENT
-- @section dynamic_hud_element

local base = "hud_element_base"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

local draw = draw
local huds = huds

if CLIENT then
    local defaultColor = Color(49, 71, 94)

    ---
    -- Returns the current @{HUD} scale (for this element)
    -- @return[default=1.0] number
    -- @realm client
    -- @deprecated
    function HUDELEMENT:GetHUDScale()
        return appearance.GetGlobalScale()
    end

    ---
    -- Returns the current @{HUD} base @{Color}
    -- @return[default=Color(49, 71, 94)] Color
    -- @realm client
    function HUDELEMENT:GetHUDBasecolor()
        local hud = huds.GetStored(HUDManager.GetHUD())

        return (hud and hud.basecolor) or defaultColor
    end

    ---
    -- @param string text
    -- @param string font
    -- @param number x
    -- @param number y
    -- @param Color color
    -- @param number xalign
    -- @param number yalign
    -- @param boolean dark
    -- @deprecated
    -- @realm client
    function HUDELEMENT:ShadowedText(text, font, x, y, color, xalign, yalign, dark)
        draw.ShadowedText(text, font, x, y, color, xalign, yalign, dark)
    end

    ---
    -- @param string text
    -- @param string font
    -- @param number x
    -- @param number y
    -- @param Color color
    -- @param number xalign
    -- @param number yalign
    -- @param boolean shadow
    -- @param number scale
    -- @deprecated
    -- @realm client
    function HUDELEMENT:AdvancedText(text, font, x, y, color, xalign, yalign, shadow, scale)
        draw.AdvancedText(text, font, x, y, color, xalign, yalign, shadow, scale)
    end
end
