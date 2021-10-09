--- @ignore

local tableCopy = table.Copy
local roles = roles

local virtualSubmenus = {}

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/roles")
CLGAMEMODEMENU.title = "menu_roles_title"
CLGAMEMODEMENU.description = "menu_roles_description"
CLGAMEMODEMENU.priority = 47

CLGAMEMODEMENU.isInitialized = false
CLGAMEMODEMENU.roles = nil

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
		if roleData.index == ROLE_NONE then continue end

		counter = counter + 1

		virtualSubmenus[counter] = tableCopy(rolesMenuBase)
		virtualSubmenus[counter].title = roleData.name
		virtualSubmenus[counter].icon = roleData.iconMaterial
		virtualSubmenus[counter].roleData = roleData
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
