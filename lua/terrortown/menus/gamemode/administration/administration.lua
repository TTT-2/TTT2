--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 100
CLGAMEMODESUBMENU.title = "submenu_administration_administration_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_administration_general")

    form:MakeHelp({
        label = "help_idle",
    })

    local enbIdle = form:MakeCheckBox({
        serverConvar = "ttt_idle",
        label = "label_idle",
    })

    form:MakeSlider({
        serverConvar = "ttt_idle_limit",
        label = "label_idle_limit",
        min = 0,
        max = 300,
        decimal = 0,
        master = enbIdle,
    })

    form:MakeHelp({
        label = "help_namechange_kick",
    })

    local enbKick = form:MakeCheckBox({
        serverConvar = "ttt_namechange_kick",
        label = "label_namechange_kick",
    })

    form:MakeSlider({
        serverConvar = "ttt_namechange_bantime",
        label = "label_namechange_bantime",
        min = 0,
        max = 60,
        decimal = 0,
        master = enbKick,
    })

    local form2 = vgui.CreateTTT2Form(parent, "header_administration_logging")

    form2:MakeHelp({
        label = "help_damage_log",
    })

    form2:MakeCheckBox({
        serverConvar = "ttt_log_damage_for_console",
        label = "label_log_damage_for_console",
    })

    form2:MakeCheckBox({
        serverConvar = "ttt_damagelog_save",
        label = "label_damagelog_save",
    })

    local form3 = vgui.CreateTTT2Form(parent, "header_administration_misc")

    form3:MakeCheckBox({
        serverConvar = "ttt_debug_preventwin",
        label = "label_debug_preventwin",
    })

    form3:MakeCheckBox({
        serverConvar = "ttt_bots_are_spectators",
        label = "label_bots_are_spectators",
    })

    form3:MakeCheckBox({
        serverConvar = "ttt2_tbutton_admin_show",
        label = "label_tbutton_admin_show",
    })

    local form4 = vgui.CreateTTT2Form(parent, "header_administration_scoreboard")

    form4:MakeCheckBox({
        serverConvar = "ttt_highlight_admins",
        label = "label_highlight_admins",
    })

    form4:MakeCheckBox({
        serverConvar = "ttt_highlight_dev",
        label = "label_highlight_dev",
    })

    form4:MakeCheckBox({
        serverConvar = "ttt_highlight_vip",
        label = "label_highlight_vip",
    })

    form4:MakeCheckBox({
        serverConvar = "ttt_highlight_addondev",
        label = "label_highlight_addondev",
    })

    form4:MakeCheckBox({
        serverConvar = "ttt_highlight_supporter",
        label = "label_highlight_supporter",
    })
end
