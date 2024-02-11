---
-- @class CLSCOREMENU

CLSCOREMENU.type = "base_scoremenu"
CLSCOREMENU.priority = 0
CLSCOREMENU.icon = nil
CLSCOREMENU.title = "base_menu_title"

---
-- This function is used to populate the menu on open/refresh.
-- @param Panel parent The parent panel
-- @note This function should be overwritten but not not called.
-- @internal
-- @realm client
function CLSCOREMENU:Populate(parent) end
