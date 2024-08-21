--- @ignore

local tableCopy = table.Copy
local roles = roles

local virtualSubmenus = {}

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/shops")
CLGAMEMODEMENU.title = "menu_shops_title"
CLGAMEMODEMENU.description = "menu_shops_description"
CLGAMEMODEMENU.priority = 47

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
    local shopsMenuBase = self:GetSubmenuByName("base_shops")

    local counter = 0
    for _, roleData in pairs(self.roles) do
        if roleData.index == ROLE_NONE then
            continue
        end

        counter = counter + 1

        virtualSubmenus[counter] = tableCopy(shopsMenuBase)
        virtualSubmenus[counter].title = roleData.name
        virtualSubmenus[counter].icon = roleData.iconMaterial
        virtualSubmenus[counter].roleData = roleData
        virtualSubmenus[counter].iconBadge = roleData.builtin and builtinIcon
        virtualSubmenus[counter].iconBadgeSize = 8
        virtualSubmenus[counter].roles = self.roles
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
