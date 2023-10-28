--- @ignore

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/thirdparty")
CLGAMEMODEMENU.title = "menu_thirdparty_title"
CLGAMEMODEMENU.description = "menu_thirdparty_description"
CLGAMEMODEMENU.priority = 33

function CLGAMEMODEMENU:IsAdminMenu()
	return true
end
