--- @ignore

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/commands")
CLGAMEMODEMENU.title = "menu_commands_title"
CLGAMEMODEMENU.description = "menu_commands_description"
CLGAMEMODEMENU.priority = 49

function CLGAMEMODEMENU:IsAdminMenu()
    return true
end
