local surface = surface

-- Fonts
surface.CreateFont("PureSkinRole", {font = "Trebuchet24", size = 30, weight = 700})
surface.CreateFont("PureSkinBar", {font = "Trebuchet24", size = 21, weight = 1000})
surface.CreateFont("PureSkinWep", {font = "Trebuchet24", size = 21, weight = 1000})
surface.CreateFont("PureSkinWepNum", {font = "Trebuchet24", size = 21, weight = 700})

local defaultColor = Color(49, 71, 94)

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

HUD.basecolor = defaultColor

function HUD:Initialize()
	self:ForceHUDElement("pure_skin_playerinfo")
	self:ForceHUDElement("pure_skin_roundinfo")
	self:ForceHUDElement("pure_skin_wswitch")
	self:ForceHUDElement("pure_skin_drowning")
	--self:ForceHUDElement("old_ttt_spec")
	--self:ForceHUDElement("old_ttt_items")

	-- Initialize elements default values
	for _, v in ipairs(self:GetHUDElements()) do
		local elem = hudelements.GetStored(v)
		if elem then
			elem:Initialize()
			elem:SetDefaults()

			-- load and initialize all HUDELEMENT data from database
			if SQL.CreateSqlTable("ttt2_hudelements", elem.savingKeys) then
				local loaded = SQL.Load("ttt2_hudelements", elem.id, elem, elem.savingKeys)

				if not loaded then
					SQL.Init("ttt2_hudelements", elem.id, elem, elem.savingKeys)
				end
			end

			elem:Load()

			elem.initialized = true
		else
			Msg("Error: HUD " .. (self.id or "?") .. " has unkown element named " .. v .. "\n")
		end
	end

	self:PerformLayout()
end

function HUD:Loaded()
	for _, elem in ipairs(self:GetHUDElements()) do
		local el = hudelements.GetStored(elem)
		if el then
			el.basecolor = self.basecolor
		end
	end
end

function HUD:Reset()
	self.basecolor = defaultColor
end

-- Voice overriding
include("cl_voice.lua")
