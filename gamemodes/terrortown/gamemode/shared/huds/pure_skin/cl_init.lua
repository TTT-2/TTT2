local surface = surface

-- Fonts
surface.CreateFont("PureSkinMSTACKTitle", {font = "Trebuchet24", size = 30, weight = 700})
surface.CreateFont("PureSkinMSTACKMsg", {font = "Trebuchet24", size = 24, weight = 700})
surface.CreateFont("PureSkinRole", {font = "Trebuchet24", size = 30, weight = 700})
surface.CreateFont("PureSkinBar", {font = "Trebuchet24", size = 21, weight = 1000})
surface.CreateFont("PureSkinWep", {font = "Trebuchet24", size = 21, weight = 1000})
surface.CreateFont("PureSkinWepNum", {font = "Trebuchet24", size = 21, weight = 700})

-- base drawing functions
include("cl_drawing_functions.lua")

local base = "hud_base"

DEFINE_BASECLASS(base)

HUD.Base = base

local defaultColor = Color(49, 71, 94)

HUD.previewImage = Material("vgui/ttt/huds/pure_skin/preview.png")

local savingKeys

function HUD:GetSavingKeys()
	if not savingKeys then
		savingKeys = BaseClass.GetSavingKeys(self)
		savingKeys.basecolor = {
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
	end

	return table.Copy(savingKeys)
end

HUD.basecolor = defaultColor

function HUD:Initialize()
	self:ForceHUDElement("pure_skin_playerinfo")
	self:ForceHUDElement("pure_skin_roundinfo")
	self:ForceHUDElement("pure_skin_wswitch")
	self:ForceHUDElement("pure_skin_drowning")
	self:ForceHUDElement("pure_skin_mstack")
	self:ForceHUDElement("pure_skin_items")
	self:ForceHUDElement("pure_skin_miniscoreboard")
	self:ForceHUDElement("pure_skin_punchometer")
	self:ForceHUDElement("pure_skin_target")

	BaseClass.Initialize(self)
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

-- Popup overriding
include("cl_popup.lua")
