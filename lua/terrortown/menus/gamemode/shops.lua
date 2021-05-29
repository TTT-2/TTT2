--- @ignore

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/shops")
CLGAMEMODEMENU.title = "menu_shops_title"
CLGAMEMODEMENU.description = "menu_shops_description"
CLGAMEMODEMENU.priority = 48

function CLGAMEMODEMENU:IsAdminMenu()
	return true
end
