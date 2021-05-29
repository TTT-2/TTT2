--- @ignore

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/equipment")
CLGAMEMODEMENU.title = "menu_equipment_title"
CLGAMEMODEMENU.description = "menu_equipment_description"
CLGAMEMODEMENU.priority = 49

function CLGAMEMODEMENU:IsAdminMenu()
	return true
end
