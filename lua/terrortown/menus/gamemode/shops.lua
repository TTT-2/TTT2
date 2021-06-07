--- @ignore

local tableCopy = table.Copy

local virtualSubmenus = {}

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/shops")
CLGAMEMODEMENU.title = "menu_shops_title"
CLGAMEMODEMENU.description = "menu_shops_description"
CLGAMEMODEMENU.priority = 48

CLGAMEMODEMENU.isInitialized = false

function CLGAMEMODEMENU:IsAdminMenu()
	return true
end

function CLGAMEMODEMENU:InitializeVirtualMenus()
	-- add "virtual" submenus that are treated as real one even without files
	virtualSubmenus = {}

	local roles = roles.GetSortedRoles()
	local shopsMenuBase = self:GetSubmenuByName("base_shops")

	local counter = 0
	for _, roleData in pairs(roles) do
		if roleData.name == "none" then continue end
		counter = counter + 1

		virtualSubmenus[counter] = tableCopy(shopsMenuBase)
		virtualSubmenus[counter].title = roleData.name
		virtualSubmenus[counter].icon = roleData.iconMaterial
		virtualSubmenus[counter].roleData = roleData
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