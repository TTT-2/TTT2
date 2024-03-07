--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 99
CLGAMEMODESUBMENU.title = "submenu_gameplay_accessibility_title"
CLGAMEMODESUBMENU.icon = Material("vgui/ttt/vskin/helpscreen/accessibility")

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_accessibility_settings")

    form:MakeHelp({
        label = "help_enable_dynamic_fov",
    })

    form:MakeCheckBox({
        label = "label_enable_dynamic_fov",
        convar = "ttt2_enable_dynamic_fov",
    })

    form:MakeHelp({
        label = "help_enable_bobbing_strafe",
    })

    form:MakeCheckBox({
        label = "label_enable_bobbing",
        convar = "ttt2_enable_bobbing",
    })

    form:MakeCheckBox({
        label = "label_enable_bobbing_strafe",
        convar = "ttt2_enable_bobbing_strafe",
    })
end
