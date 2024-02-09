---
-- HUD base class.
-- @class HUD
-- @section old_ttt

local surface = surface

-- Fonts
surface.CreateFont("TraitorState", { font = "Tahoma", size = 28, weight = 1000, extended = true })
surface.CreateFont("TimeLeft", { font = "Tahoma", size = 24, weight = 800, extended = true })
surface.CreateFont("HealthAmmo", { font = "Tahoma", size = 24, weight = 750, extended = true })
surface.CreateFont("ItemInfo", { font = "Tahoma", size = 14, weight = 700, extended = true })

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
function HUD:SaveData() end

---
-- this is doing nothing, to prevent the hud from loading data from the database
-- @realm client
function HUD:LoadData() end
