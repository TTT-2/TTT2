local surface = surface

-- Fonts
surface.CreateFont("PureSkinRole", {font = "Trebuchet24", size = 24, weight = 1200})
surface.CreateFont("PureSkinBar", {font = "Trebuchet24", size = 18, weight = 1000})
surface.CreateFont("PureSkinWep", {font = "Trebuchet24", size = 20, weight = 1200})

function HUD:Initialize()
	self:ForceHUDElement("pure_skin_playerinfo")
	self:ForceHUDElement("pure_skin_roundinfo")
	self:ForceHUDElement("pure_skin_wswitch")
	--self:ForceHUDElement("old_ttt_spec")
	--self:ForceHUDElement("old_ttt_items")

	-- important to call the base initialize, to set default values for all elements
	self.BaseClass:Initialize()
end
