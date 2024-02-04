--- @ignore

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/administration")
CLGAMEMODEMENU.title = "menu_administration_title"
CLGAMEMODEMENU.description = "menu_administration_description"
CLGAMEMODEMENU.priority = 50

function CLGAMEMODEMENU:IsAdminMenu()
    return true
end
