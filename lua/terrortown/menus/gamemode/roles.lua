--- @ignore

local tableCopy = table.Copy
local roles = roles

local virtualSubmenus = {}

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/roles")
CLGAMEMODEMENU.title = "menu_roles_title"
CLGAMEMODEMENU.description = "menu_roles_description"
CLGAMEMODEMENU.priority = 46
CLGAMEMODEMENU.searchBarPlaceholderText = "searchbar_roles_placeholder"

CLGAMEMODEMENU.isInitialized = false
CLGAMEMODEMENU.roles = nil

local builtinIcon = Material("vgui/ttt/vskin/markers/builtin")

function CLGAMEMODEMENU:IsAdminMenu()
    return true
end

function CLGAMEMODEMENU:InitializeVirtualMenus()
    -- add "virtual" submenus that are treated as real one even without files
    virtualSubmenus = {}

    self.roles = roles.GetSortedRoles()
    local rolesMenuBase = self:GetSubmenuByName("base_roles")

    local counter = 0
    for _, roleData in pairs(self.roles) do
        if roleData.index == ROLE_NONE then
            continue
        end

        counter = counter + 1

        local virtualSubmenu = tableCopy(rolesMenuBase)
        virtualSubmenu.title = roleData.name
        virtualSubmenu.icon = roleData.iconMaterial
        virtualSubmenu.roleData = roleData
        virtualSubmenu.iconBadge = roleData.builtin and builtinIcon
        virtualSubmenu.iconBadgeSize = 8
        virtualSubmenu.basemenu = self
        -- make sure that the virtual submenu will be shown
        function virtualSubmenu:ShouldShow()
            return true
        end
        virtualSubmenus[counter] = virtualSubmenu
    end
end

-- overwrite the normal submenu function to return our custom virtual submenus
function CLGAMEMODEMENU:GetSubmenus()
    if not self.isInitialized then
        self.isInitialized = true

        self:InitializeVirtualMenus()
    end

    return virtualSubmenus
end

-- overwrite and return true to enable a searchbar
function CLGAMEMODEMENU:HasSearchbar()
    return true
end

-- override this so that we have non-searched submenus above the search bar
function CLGAMEMODEMENU:GetVisibleNonSearchedSubmenus()
    local visibleSubmenus = {}
    -- all of the non-searchable submenus are in self.submenus
    local allSubmenus = self.submenus

    for i = 1, #allSubmenus do
        local submenu = allSubmenus[i]

        if not submenu:ShouldShow() then
            continue
        end

        visibleSubmenus[#visibleSubmenus + 1] = submenu
    end

    return visibleSubmenus
end

---
-- This hook can be used to extend role settings page of role addons
-- with custom convars. The parent is the submenu, where a new form has to
-- be added.
-- This is for extending existing addons, role authors should use @{ROLE:AddToSettingsMenu}.
-- @param ROLE role @{ROLE} data,
-- @param DPanel parent The parent panel which is the submenu
-- @hook
-- @realm client
function GM:TTT2OnRoleAddToSettingsMenu(role, parent) end
