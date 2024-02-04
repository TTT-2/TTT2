---
-- @author Alf21
-- @author saibotk
-- @author Mineotopia
-- @class ROLE

---
-- This hook can be used by role addons to populate the role settings page
-- with custom convars. The parent is the submenu, where a new form has to
-- be added.
-- @param DPanel parent The parent panel which is the submenu
-- @hook
-- @realm client
function ROLE:AddToSettingsMenu(parent) end

---
-- This hook can be used by role addons to populate the role credit settings form
-- with custom convars. The parent is the credits form, where menu elements can be
-- directly added.
-- @param DPanel parent The parent panel which is the credits form
-- @hook
-- @realm client
function ROLE:AddToSettingsMenuCreditsForm(parent) end
