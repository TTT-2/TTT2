---
-- @class CLGAMEMODESUBMENU

CLGAMEMODESUBMENU.type = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = ""

---
-- This function is used to populate the submenu on open/refresh.
-- @note This function should be overwritten but not not called.
-- @param Panel parent The parent panel
-- @internal
-- @realm client
function CLGAMEMODESUBMENU:Populate(parent)

end

---
-- This function is used to populate the button panel of a submenu on open/refresh.
-- @note This function should be overwritten but not called.
-- @note @{CLGAMEMODESUBMENU:HasButtonPanel} has to return true to display any button panel at all.
-- @param Panel parent The parent panel
-- @internal
-- @realm client
function CLGAMEMODESUBMENU:PopulateButtonPanel(parent)

end

---
-- Function to overwrite if the menu should have a button panel.
-- @note This function should be overwritten but not not called.
-- @return[default=false] Returns if this submenu has a button panel
-- @internal
-- @realm client
function CLGAMEMODESUBMENU:HasButtonPanel()
	return false
end

---
-- Called after the class is initialized and has finished inheriting.
-- @note This function should be overwritten but not not called.
-- @internal
-- @realm client
function CLGAMEMODESUBMENU:Initialize()

end

---
-- Used to define whether this submenu should be shown at all.
-- @note This function should be overwritten but not not called.
-- @return[default=true] Returns true if this submenu should be visible
-- @internal
-- @realm client
function CLGAMEMODESUBMENU:ShouldShow()
	return true
end
