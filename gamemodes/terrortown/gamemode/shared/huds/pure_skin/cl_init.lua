---
-- HUD base class.
-- @class HUD
-- @section pure_skin

local surface = surface

-- Fonts
surface.CreateAdvancedFont(
    "PureSkinMSTACKImageMsg",
    { font = "Tahoma", size = 21, weight = 1000, extended = true }
)
surface.CreateAdvancedFont(
    "PureSkinMSTACKMsg",
    { font = "Tahoma", size = 15, weight = 900, extended = true }
)
surface.CreateAdvancedFont(
    "PureSkinRole",
    { font = "Tahoma", size = 30, weight = 700, extended = true }
)
surface.CreateAdvancedFont(
    "PureSkinBar",
    { font = "Tahoma", size = 21, weight = 1000, extended = true }
)
surface.CreateAdvancedFont(
    "PureSkinWep",
    { font = "Tahoma", size = 21, weight = 1000, extended = true }
)
surface.CreateAdvancedFont(
    "PureSkinWepNum",
    { font = "Tahoma", size = 21, weight = 700, extended = true }
)
surface.CreateAdvancedFont(
    "PureSkinItemInfo",
    { font = "Tahoma", size = 14, weight = 700, extended = true }
)
surface.CreateAdvancedFont(
    "PureSkinTimeLeft",
    { font = "Tahoma", size = 24, weight = 800, extended = true }
)
surface.CreateAdvancedFont(
    "PureSkinPopupTitle",
    { font = "Tahoma", size = 48, weight = 600, extended = true }
)
surface.CreateAdvancedFont(
    "PureSkinPopupText",
    { font = "Tahoma", size = 18, weight = 600, extended = true }
)

-- base drawing functions
include("cl_drawing_functions.lua")

local base = "scalable_hud"

DEFINE_BASECLASS(base)

HUD.Base = base

HUD.previewImage = Material("vgui/ttt/huds/pure_skin/preview.png")
HUD.defaultcolor = Color(49, 71, 94)

---
-- Loads this HUD and connects with special @{HUDELEMENT}
-- @realm client
function HUD:Initialize()
    self:ForceElement("pure_skin_playerinfo")
    self:ForceElement("pure_skin_roundinfo")
    self:ForceElement("pure_skin_wswitch")
    self:ForceElement("pure_skin_drowning")
    self:ForceElement("pure_skin_mstack")
    self:ForceElement("pure_skin_sidebar")
    self:ForceElement("pure_skin_miniscoreboard")
    self:ForceElement("pure_skin_punchometer")
    self:ForceElement("pure_skin_target")
    self:ForceElement("pure_skin_pickup")
    self:ForceElement("pure_skin_revival")
    self:ForceElement("pure_skin_teamindicator")

    BaseClass.Initialize(self)
end

-- Popup overriding
include("cl_popup.lua")
