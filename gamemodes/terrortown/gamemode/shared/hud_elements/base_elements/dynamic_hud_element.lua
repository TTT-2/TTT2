local base = "hud_element_base"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	local defaultColor = Color(49, 71, 94)

	function HUDELEMENT:GetHUDScale()
		local hud = huds.GetStored(HUDManager.GetHUD())

		return (hud and hud.scale) or 1.0
	end

	function HUDELEMENT:GetHUDBasecolor()
		local hud = huds.GetStored(HUDManager.GetHUD())

		return (hud and hud.basecolor) or defaultColor
	end

	--DEPRECATED
	function HUDELEMENT:ShadowedText(text, font, x, y, color, xalign, yalign, dark)
		draw.ShadowedText(text, font, x, y, color, xalign, yalign, dark)
	end

	--DEPRECATED
	function HUDELEMENT:AdvancedText(text, font, x, y, color, xalign, yalign, shadow, scale)
		draw.AdvancedText(text, font, x, y, color, xalign, yalign, shadow, scale)
	end
end
