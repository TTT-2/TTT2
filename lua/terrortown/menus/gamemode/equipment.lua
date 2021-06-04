--- @ignore

local tableCopy = table.Copy

local virtualSubmenus = {}

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/equipment")
CLGAMEMODEMENU.title = "menu_equipment_title"
CLGAMEMODEMENU.description = "menu_equipment_description"
CLGAMEMODEMENU.priority = 49

function CLGAMEMODEMENU:Initialize()
	-- Don't create Submenus, as the needed data needs to be loaded later
end

function CLGAMEMODEMENU:ReloadData()
	-- add "virtual" submenus that are treated as real one even without files
	virtualSubmenus = {}

	local items = ShopEditor.GetEquipmentForRoleAll()
	SortEquipmentTable(items)
	local equipmentMenuBase = self:GetSubmenuByName("base_equipment")

	for i = 1, #items do
		local item = items[i]

		virtualSubmenus[i] = tableCopy(equipmentMenuBase)
		virtualSubmenus[i].title = item.EquipMenuData and item.EquipMenuData.name or item.PrintName or item.id or "UNDEFINED"
		virtualSubmenus[i].item = item
	end
end

-- overwrite the normal submenu function to return our custom virtual submenus
function CLGAMEMODEMENU:GetSubmenus()
	self:ReloadData()
	return virtualSubmenus
end

function CLGAMEMODEMENU:IsAdminMenu()
	return true
end
