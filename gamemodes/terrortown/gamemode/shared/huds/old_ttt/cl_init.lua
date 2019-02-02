local surface = surface

-- Fonts
surface.CreateFont("TraitorState", {font = "Trebuchet24", size = 28, weight = 1000})
surface.CreateFont("TimeLeft", {font = "Trebuchet24", size = 24, weight = 800})
surface.CreateFont("HealthAmmo", {font = "Trebuchet24", size = 24, weight = 750})

function DrawOldRoleIcon(x, y, w, h, icon, color)
	local base = Material("vgui/ttt/dynamic/base")
	local base_overlay = Material("vgui/ttt/dynamic/base_overlay")

	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	surface.SetMaterial(base)
	surface.DrawTexturedRect(x, y, w, h)

	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	surface.SetMaterial(base_overlay)
	surface.DrawTexturedRect(x, y, w, h)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(icon)
	surface.DrawTexturedRect(x, y, w, h)
end

function HUD:Initialize()
	self:ForceHUDElement("old_ttt_info")
	self:ForceHUDElement("old_ttt_spec")
	self:ForceHUDElement("old_ttt_items")
	self:ForceHUDElement("old_ttt_mstack")

	self:HideHUDType("tttroundinfo")

	-- important to call the base initialize, to set default values for all elements
	self.BaseClass:Initialize()
end
