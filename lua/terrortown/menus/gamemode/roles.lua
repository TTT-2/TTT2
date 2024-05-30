--- @ignore

local tableCopy = table.Copy
local roles = roles

local virtualSubmenus = {}

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/roles")
CLGAMEMODEMENU.title = "menu_roles_title"
CLGAMEMODEMENU.description = "menu_roles_description"
CLGAMEMODEMENU.priority = 46

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

        virtualSubmenus[counter] = tableCopy(rolesMenuBase)
        virtualSubmenus[counter].title = roleData.name
        virtualSubmenus[counter].icon = roleData.iconMaterial
        virtualSubmenus[counter].roleData = roleData
        virtualSubmenus[counter].iconBadge = roleData.builtin and builtinIcon
        virtualSubmenus[counter].iconBadgeSize = 8
        virtualSubmenus[counter].basemenu = self
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
