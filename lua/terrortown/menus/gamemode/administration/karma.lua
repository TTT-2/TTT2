--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 89
CLGAMEMODESUBMENU.title = "submenu_administration_karma_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_karma_tweaking")

    form:MakeHelp({
        label = "help_karma",
    })

    local enbKma = form:MakeCheckBox({
        serverConvar = "ttt_karma",
        label = "label_karma",
    })

    form:MakeHelp({
        label = "help_karma_strict",
        master = enbKma,
    })

    form:MakeCheckBox({
        serverConvar = "ttt_karma_strict",
        label = "label_karma_strict",
        master = enbKma,
    })

    form:MakeSlider({
        serverConvar = "ttt_karma_starting",
        label = "label_karma_starting",
        min = 0,
        max = 1500,
        decimal = 0,
        master = enbKma,
    })

    form:MakeHelp({
        label = "help_karma_max",
        master = enbKma,
    })

    form:MakeSlider({
        serverConvar = "ttt_karma_max",
        label = "label_karma_max",
        min = 0,
        max = 1500,
        decimal = 0,
        master = enbKma,
    })

    form:MakeHelp({
        label = "help_karma_ratio",
        master = enbKma,
    })

    form:MakeSlider({
        serverConvar = "ttt_karma_ratio",
        label = "label_karma_ratio",
        min = 0,
        max = 0.01,
        decimal = 4,
        master = enbKma,
    })

    form:MakeSlider({
        serverConvar = "ttt_karma_kill_penalty",
        label = "label_karma_kill_penalty",
        min = 0,
        max = 100,
        decimal = 0,
        master = enbKma,
    })

    form:MakeHelp({
        label = "help_karma_traitordmg_ratio",
        master = enbKma,
    })

    form:MakeSlider({
        serverConvar = "ttt_karma_traitordmg_ratio",
        label = "label_karma_traitordmg_ratio",
        min = 0,
        max = 0.01,
        decimal = 4,
        master = enbKma,
    })

    form:MakeSlider({
        serverConvar = "ttt_karma_traitorkill_bonus",
        label = "label_karma_traitorkill_bonus",
        min = 0,
        max = 100,
        decimal = 0,
        master = enbKma,
    })

    form:MakeHelp({
        label = "help_karma_bonus",
        master = enbKma,
    })

    form:MakeSlider({
        serverConvar = "ttt_karma_round_increment",
        label = "label_karma_round_increment",
        min = 0,
        max = 100,
        decimal = 0,
        master = enbKma,
    })

    form:MakeSlider({
        serverConvar = "ttt_karma_clean_bonus",
        label = "label_karma_clean_bonus",
        min = 0,
        max = 100,
        decimal = 0,
        master = enbKma,
    })

    form:MakeHelp({
        label = "help_karma_clean_half",
        master = enbKma,
    })

    form:MakeSlider({
        serverConvar = "ttt_karma_clean_half",
        label = "label_karma_clean_half",
        min = 0,
        max = 5,
        decimal = 2,
        master = enbKma,
    })

    form:MakeCheckBox({
        serverConvar = "ttt_karma_persist",
        label = "label_karma_persist",
        master = enbKma,
    })

    local form2 = vgui.CreateTTT2Form(parent, "header_karma_kick")

    local enbKick = form2:MakeCheckBox({
        serverConvar = "ttt_karma_low_autokick",
        label = "label_karma_low_autokick",
        master = enbKma,
    })

    form2:MakeSlider({
        serverConvar = "ttt_karma_low_amount",
        label = "label_karma_low_amount",
        min = 0,
        max = 1500,
        decimal = 0,
        master = enbKick,
    })

    local enbBan = form2:MakeCheckBox({
        serverConvar = "ttt_karma_low_ban",
        label = "label_karma_low_ban",
        master = enbKick,
    })

    form2:MakeSlider({
        serverConvar = "ttt_karma_low_ban_minutes",
        label = "label_karma_low_ban_minutes",
        min = 0,
        max = 120,
        decimal = 0,
        master = enbBan,
    })

    local form3 = vgui.CreateTTT2Form(parent, "header_karma_logging")

    form3:MakeCheckBox({
        serverConvar = "ttt_karma_debugspam",
        label = "label_karma_debugspam",
        master = enbKma,
    })
end
