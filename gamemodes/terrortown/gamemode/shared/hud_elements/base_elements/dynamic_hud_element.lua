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
end
