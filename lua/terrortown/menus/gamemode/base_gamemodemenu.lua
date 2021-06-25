---
-- @class CLGAMEMODEMENU

local TryT = LANG.TryTranslation
local lowerString = string.lower
local findString = string.find

CLGAMEMODEMENU.type = "base_gamemodemenu"
CLGAMEMODEMENU.priority = 0
CLGAMEMODEMENU.icon = nil
CLGAMEMODEMENU.title = ""
CLGAMEMODEMENU.description = ""
CLGAMEMODEMENU.searchbar = false

CLGAMEMODEMENU.submenus = {}

---
-- Used to define whether a menu should be shown at all. By default this
-- excludes admin menus for non admin players and menus without any content.
-- @note This function should be overwritten but not not called.
-- @return boolean Returns true if this menu should be visible
-- @internal
-- @realm client
function CLGAMEMODEMENU:ShouldShow()
	if not LocalPlayer():IsAdmin() and self:IsAdminMenu() then
		return false
	end

	return self:HasVisibleSubmenus()
end

---
-- Checks if this menu has any visible submenus. They are visible if they are
-- registered and @{CLGAMEMODEMENU:ShouldShow()} returns true.
-- @return boolean Returns true if there is at least one visible submenu
-- @realm client
function CLGAMEMODEMENU:HasVisibleSubmenus()
	return #self:GetVisibleSubmenus() > 0
end

---
-- Returns a table with references to all registered and visible submenu classes
-- of this menu. They are visible if they are registered and
-- @{CLGAMEMODEMENU:ShouldShow()} returns true.
-- @return table Returns a table of all registered and visible submenus
-- @realm client
function CLGAMEMODEMENU:GetVisibleSubmenus()
	local visibleSubmenus = {}
	local allSubmenus = self:GetSubmenus()

	for i = 1, #allSubmenus do
		local submenu = allSubmenus[i]

		if not submenu:ShouldShow() then continue end

		visibleSubmenus[#visibleSubmenus + 1] = submenu
	end

	return visibleSubmenus
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
-- Enables searchbar for the menu.
-- @param bool active
-- @realm client
function CLGAMEMODEMENU:EnableSearchbar(active)
	self.searchbar = active
end

---
-- Checks if the menu has a searchbar enabled.
-- @return boolean Returns true if searchbar is set
-- @realm client
function CLGAMEMODEMENU:HasSearchbar()
	return self.searchbar
end

---
-- Sets the used searchfunction.
-- Parameters for that function are submenuClasses and the searchText
-- @param function searchFunction
-- @realm client
function CLGAMEMODEMENU:SetSearchFunction(searchFunction)
	if not isfunction(searchFunction) then return end

	self.searchFunction = searchFunction
end

---
-- Gets the used searchfunction.
-- Parameters for that function are submenuClasses and the searchText
-- @return function Returns the given searchFunction or a default-function,
-- which only searches the titles and compares strings in lowercase letters.
-- @realm client
function CLGAMEMODEMENU:GetSearchFunction()
	local searchFunction = self.searchFunction

	if not isfunction(searchFunction) then
		-- Default searchfunction searches only titles in lowercase letters
		searchFunction = function(submenuClass, searchText)
			local txt = lowerString(searchText)
			local title = lowerString(TryT(submenuClass.title))
			local start = findString(title, txt)

			return start or false and true
		end
	end

	return searchFunction
end

---
-- Called after the class is initialized and has finished inheriting.
-- @note This function should be overwritten but not not called.
-- @internal
-- @realm client
function CLGAMEMODEMENU:Initialize()

end
