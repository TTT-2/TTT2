---
-- HUD base class.
-- @module HUD
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
-- Draws the old role icon
-- @param number x
-- @param number y
-- @param number w width
-- @param number h height
-- @param Material icon the role icon
-- @param Color color
-- @realm client
function DrawOldRoleIcon(x, y, w, h, icon, color)
	local base_mat = Material("vgui/ttt/dynamic/base")
	local base_overlay = Material("vgui/ttt/dynamic/base_overlay")

	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	surface.SetMaterial(base_mat)
	surface.DrawTexturedRect(x, y, w, h)

	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	surface.SetMaterial(base_overlay)
	surface.DrawTexturedRect(x, y, w, h)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(icon)
	surface.DrawTexturedRect(x, y, w, h)
end

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
