local surface = surface

-- Fonts
surface.CreateFont("PureSkinRole", {font = "Trebuchet24", size = 30, weight = 800})
surface.CreateFont("PureSkinBar", {font = "Trebuchet24", size = 22, weight = 1500})
surface.CreateFont("PureSkinWep", {font = "Trebuchet24", size = 21, weight = 1500})

HUD.previewImage = Material("vgui/ttt/huds/pure_skin/preview.png")
HUD.savingKeys = {
	basecolor = {
		typ = "color",
		desc = "BaseColor",
		OnChange = function(slf, col)
			for _, elem in ipairs(slf:GetHUDElements()) do
				local el = hudelements.GetStored(elem)
				if el then
					el.basecolor = col
				end
			end
		end
	}
}

HUD.basecolor = Color(49, 71, 94)

function HUD:Initialize()
	self:ForceHUDElement("pure_skin_playerinfo")
	self:ForceHUDElement("pure_skin_roundinfo")
	self:ForceHUDElement("pure_skin_wswitch")
	self:ForceHUDElement("pure_skin_drowning")
	--self:ForceHUDElement("old_ttt_spec")
	--self:ForceHUDElement("old_ttt_items")

	-- important to call the base initialize, to set default values for all elements
	self.BaseClass:Initialize()
end

function HUD:Loaded()
	for _, elem in ipairs(self:GetHUDElements()) do
		local el = hudelements.GetStored(elem)
		if el then
			el.basecolor = self.basecolor
		end
	end
end

-- Voice overriding
include("cl_voice.lua")
