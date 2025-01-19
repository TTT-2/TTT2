---
-- @class CLGAMEMODEMENU

local TryT = LANG.TryTranslation
local stringLower = string.lower
local stringFind = string.find

CLGAMEMODEMENU.type = "base_gamemodemenu"
CLGAMEMODEMENU.priority = 0
CLGAMEMODEMENU.icon = nil
CLGAMEMODEMENU.title = ""
CLGAMEMODEMENU.description = ""
CLGAMEMODEMENU.searchBarPlaceholderText = nil

CLGAMEMODEMENU.submenus = {}

---
-- Used to define whether a menu should be shown at all. By default this
-- excludes admin menus for non admin players and menus without any content.
-- @note This function should be overwritten but not not called.
-- @return boolean Returns true if this menu should be visible
-- @hook
-- @realm client
function CLGAMEMODEMENU:ShouldShow()
    if self:IsAdminMenu() and not admin.IsAdmin(LocalPlayer()) then
        return false
    end

    return self:HasVisibleSubmenus()
end

---
-- Checks if this menu has any visible submenus. They are visible if they are
-- registered and @{CLGAMEMODEMENU:ShouldShow()} returns true.
-- @note This function can be overwritten, but probably shouldn't.
-- @return boolean Returns true if there is at least one visible submenu
-- @hook
-- @realm client
function CLGAMEMODEMENU:HasVisibleSubmenus()
    return #self:GetVisibleSubmenus() > 0
end

---
-- Returns a table with references to all registered and visible submenu classes
-- of this menu. They are visible if they are registered and
-- @{CLGAMEMODEMENU:ShouldShow()} returns true.
-- @note This only returns the searchable submenus. Any submenu returned here will be searched
-- by the search bar, if present.
-- @return table Returns a table of all registered and visible submenus
-- @realm client
function CLGAMEMODEMENU:GetVisibleSubmenus()
    local visibleSubmenus = {}
    local allSubmenus = self:GetSubmenus()

    for i = 1, #allSubmenus do
        local submenu = allSubmenus[i]

        if not submenu:ShouldShow() then
            continue
        end

        if not submenu.searchable then
            continue
        end

        visibleSubmenus[#visibleSubmenus + 1] = submenu
    end

    return visibleSubmenus
end

---
-- Returns a table with references to the submenu classes which should not be searchable
-- (and which should appear above the search bar, if any).
-- @note This is very similar to @{CLGAMEMODEMENU:GetVisibleSubmenus()}, excelt it only returns non-searcable
-- submenus.
-- @return table Returns a table containing all non-searchable submenus which should be visible.
-- @realm client
function CLGAMEMODEMENU:GetVisibleNonSearchedSubmenus()
    local visibleSubmenus = {}
    local allSubmenus = self:GetSubmenus()

    for i = 1, #allSubmenus do
        local submenu = allSubmenus[i]

        if not submenu:ShouldShow() then
            continue
        end

        if submenu.searchable then
            continue
        end

        visibleSubmenus[#visibleSubmenus + 1] = submenu
    end

    return visibleSubmenus
end

---
-- Used to define whether this menu is available for all or only for admins.
-- @note This function should be overwritten but not called.
-- @hook
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
-- @return[default=nil] table Returns the reference to the found submenu class
-- @realm client
function CLGAMEMODEMENU:GetSubmenuByName(name)
    for i = 1, #self.submenus do
        local submenu = self.submenus[i]

        if submenu.type ~= name then
            continue
        end

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
-- Checks if the menu has a searchbar enabled.
-- @note This function should be overwritten and return true, if you want a searchbar.
-- @return boolean Return true if searchbar should be available
-- @hook
-- @realm client
function CLGAMEMODEMENU:HasSearchbar()
    return false
end

---
-- Filters the list with a searchText and returns full list if nothing is entered.
-- @note Overwrite MatchesSearchString for a custom search!
-- This function can be overwritten, but probably shouldn't.
-- @param string searchText
-- @return menuClasses Returns a list of all matching submenus, needs to be indexed with ascending numbers
-- @hook
-- @realm client
function CLGAMEMODEMENU:GetMatchingSubmenus(searchText)
    local submenuClasses = self:GetVisibleSubmenus()

    if searchText == "" then
        return submenuClasses
    end

    local filteredSubmenuClasses = {}

    local counter = 0

    for i = 1, #submenuClasses do
        local submenuClass = submenuClasses[i]

        if self:MatchesSearchString(submenuClass, searchText) then
            counter = counter + 1
            filteredSubmenuClasses[counter] = submenuClass
        end
    end

    return filteredSubmenuClasses
end

---
-- Determines the used searchfunction, when a HasSearchbar returns true.
-- Parameters for that function are submenuClasses and the searchText
-- Per default only titles are searched and compared to the searchtext in lowercase letters.
-- @note This function can be overwritten to use a custom searchfunction.
-- @param menuClass submenuClass
-- @param string searchText
-- @return boolean Returns if the searchText is somewhere matched inside the submenuClass
-- @hook
-- @realm client
function CLGAMEMODEMENU:MatchesSearchString(submenuClass, searchText)
    local txt = stringLower(searchText)
    local title = stringLower(TryT(submenuClass.title))
    local start = stringFind(title, txt)

    return tobool(start)
end

---
-- Called after the class is initialized and has finished inheriting.
-- @note This function should be overwritten but not called.
-- @hook
-- @realm client
function CLGAMEMODEMENU:Initialize() end
