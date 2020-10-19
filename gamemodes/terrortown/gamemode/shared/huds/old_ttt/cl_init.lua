---
-- HUD base class.
-- @class HUD
-- @section old_ttt

local surface = surface

-- Fonts
surface.CreateFont("TraitorState", {font = "Trebuchet24", size = 28, weight = 1000})
surface.CreateFont("TimeLeft", {font = "Trebuchet24", size = 24, weight = 800})
surface.CreateFont("HealthAmmo", {font = "Trebuchet24", size = 24, weight = 750})
surface.CreateFont("ItemInfo", {font = "Trebuchet24", size = 14, weight = 700})

local base = "hud_base"

DEFINE_BASECLASS(base)

HUD.Base = base
HUD.disableHUDEditor = true
HUD.previewImage = Material("vgui/ttt/huds/old_ttt/preview.png")

---
-- Loads this HUD and connects with special @{HUDELEMENT}
-- @realm client
function HUD:Initialize()
	self:ForceElement("old_ttt_info")
	self:ForceElement("old_ttt_punchometer")
	self:ForceElement("old_ttt_sidebar")
	self:ForceElement("old_ttt_mstack")
	self:ForceElement("old_ttt_wswitch")
	self:ForceElement("old_ttt_target")
	self:ForceElement("old_ttt_pickup")
	self:ForceElement("old_ttt_revival")

	BaseClass.Initialize(self)
end

---
-- this is doing nothing, to prevent the hud from saving data to the database
-- @realm client
function HUD:SaveData()

end

---
-- this is doing nothing, to prevent the hud from loading data from the database
-- @realm client
function HUD:LoadData()

end
