---
-- @class CLGAMEMODEMENU

CLGAMEMODEMENU.type = "base_gamemodemenu"
CLGAMEMODEMENU.priority = 0
CLGAMEMODEMENU.icon = nil
CLGAMEMODEMENU.title = ""
CLGAMEMODEMENU.description = ""

CLGAMEMODEMENU.submenus = {}

---
-- Used to define whether a menu should be shown at all. By default this
-- excludes admin menus for non admin players and menus without any content.
-- @note This function should be overwritten but not not called.
-- @internal
-- @realm client
function CLGAMEMODEMENU:ShouldShow()
	if not LocalPlayer():IsAdmin() and self:IsAdminMenu() then
		return false
	end

	return #self:GetSubmenus() > 0
end

---
-- Used to define whether this menu is available for all or only for admins.
-- @note This function should be overwritten but not not called.
-- @internal
-- @realm client
function CLGAMEMODEMENU:IsAdminMenu()
	return false
end

---
-- Returns the whole table with all submenus to this menu.
-- @return table A table with all found submenus
-- @realm client
function CLGAMEMODEMENU:GetSubmenus()
	return self.submenus
end

---
-- Returns the reference to the submenu class if available.
-- @param string name The name of the class (usually the type defined by the filename)
-- @return[default=nil] Returns the reference to the found submenu class
-- @realm client
function CLGAMEMODEMENU:GetSubmenuByName(name)
	for i = 1, #self.submenus do
		local submenu = self.submenus[i]

		if submenu.type ~= name then continue end

		return submenu
	end
end

---
-- Sets the whole submenu table.
-- @param table submenuTable The new submenu class table
-- @realm client
function CLGAMEMODEMENU:SetSubmenuTable(submenuTable)
	self.submenus = submenuTable
end

---
-- Adds another submenu class to the list of submenus.
-- @param CLGAMEMODESUBMENU submenu The new submenu class
-- @realm client
function CLGAMEMODEMENU:AddSubmenu(submenu)
	self.submenus[#self.submenus + 1] = submenu
end

---
-- Called after the class is initialized and has finished inheriting.
-- @note This function should be overwritten but not not called.
-- @internal
-- @realm client
function CLGAMEMODEMENU:Initialize()

end
