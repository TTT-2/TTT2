---
-- @module HUDELEMENT
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
	function HUDELEMENT:GetHUDScale()
		local hud = huds.GetStored(HUDManager.GetHUD())

		return (hud and hud.scale) or 1.0
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
	-- @deprecated
	-- @realm client
	function HUDELEMENT:ShadowedText(text, font, x, y, color, xalign, yalign, dark)
		draw.ShadowedText(text, font, x, y, color, xalign, yalign, dark)
	end

	---
	-- @deprecated
	-- @realm client
	function HUDELEMENT:AdvancedText(text, font, x, y, color, xalign, yalign, shadow, scale)
		draw.AdvancedText(text, font, x, y, color, xalign, yalign, shadow, scale)
	end
end
