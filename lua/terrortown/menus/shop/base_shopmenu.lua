---
-- @class CLSHOPMENU

CLSHOPMENU.type = "base_shopmenu"
CLSHOPMENU.priority = 0
CLSHOPMENU.icon = nil
CLSHOPMENU.title = "base_shop_title"

---
-- This function is used to populate the menu on open/refresh.
-- @param Panel parent The parent panel
-- @note This function should be overwritten but not not called.
-- @internal
-- @realm client
function CLSHOPMENU:Populate(parent)

end

---
-- This function is used to populate the button panel of a menu on open/refresh.
-- @note This function should be overwritten but not called.
-- @note @{CLSHOPMENU:HasButtonPanel} has to return true to display any button panel at all.
-- @param Panel parent The parent panel
-- @internal
-- @realm client
function CLSHOPMENU:PopulateButtonPanel(parent)

end
