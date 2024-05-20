--- @ignore

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/addons")
CLGAMEMODEMENU.title = "menu_server_addons_title"
CLGAMEMODEMENU.description = "menu_server_addons_description"
CLGAMEMODEMENU.priority = 45

-- overwrite and return true to enable a searchbar
function CLGAMEMODEMENU:HasSearchbar()
    return true
end

function CLGAMEMODEMENU:IsAdminMenu()
    return true
end
