--- @ignore

local TryT = LANG.TryTranslation

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 98
CLGAMEMODESUBMENU.title = "submenu_administration_round_setup_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_round_dead_players")

    form:MakeCheckBox({
        serverConvar = "ttt_identify_body_woconfirm",
        label = "label_identify_body_woconfirm",
    })

    form:MakeCheckBox({
        serverConvar = "ttt_announce_body_found",
        label = "label_announce_body_found",
    })

    form:MakeCheckBox({
        serverConvar = "ttt2_confirm_killlist",
        label = "label_confirm_killlist",
    })

    form:MakeCheckBox({
        serverConvar = "ttt_dyingshot",
        label = "label_dyingshot",
    })

    form:MakeHelp({
        label = "help_inspect_confirm_mode",
    })

    form:MakeComboBox({
        label = "label_inspect_confirm_mode",
        serverConvar = "ttt2_inspect_confirm_mode",
        choices = {
            { title = TryT("choice_inspect_confirm_mode_0"), value = 0 },
            { title = TryT("choice_inspect_confirm_mode_1"), value = 1 },
            { title = TryT("choice_inspect_confirm_mode_2"), value = 2 },
        },
    })

    local form2 = vgui.CreateTTT2Form(parent, "header_round_setup_prep")

    form2:MakeCheckBox({
        serverConvar = "ttt2_prep_respawn",
        label = "label_prep_respawn",
    })

    form2:MakeCheckBox({
        serverConvar = "ttt_nade_throw_during_prep",
        label = "label_nade_throw_during_prep",
    })

    form2:MakeSlider({
        serverConvar = "ttt_preptime_seconds",
        label = "label_preptime_seconds",
        min = 0,
        max = 120,
        decimal = 0,
    })

    form2:MakeSlider({
        serverConvar = "ttt_firstpreptime",
        label = "label_firstpreptime_seconds",
        min = 0,
        max = 120,
        decimal = 0,
    })

    local form3 = vgui.CreateTTT2Form(parent, "header_round_setup_round")

    form3:MakeSlider({
        serverConvar = "ttt_roundtime_minutes",
        label = "label_roundtime_minutes",
        min = 0,
        max = 60,
        decimal = 0,
    })

    form3:MakeHelp({
        label = "help_haste_mode",
    })

    local enbHaste = form3:MakeCheckBox({
        serverConvar = "ttt_haste",
        label = "label_haste",
    })

    form3:MakeSlider({
        serverConvar = "ttt_haste_starting_minutes",
        label = "label_haste_starting_minutes",
        min = 0,
        max = 60,
        decimal = 0,
        master = enbHaste,
    })

    form3:MakeSlider({
        serverConvar = "ttt_haste_minutes_per_death",
        label = "label_haste_minutes_per_death",
        min = 0,
        max = 10,
        decimal = 1,
        master = enbHaste,
    })

    form3:MakeHelp({
        label = "help_sherlock_mode",
    })

    form3:MakeCheckBox({
        serverConvar = "ttt_sherlock_mode",
        label = "label_sherlock_mode",
    })

    form3:MakeSlider({
        serverConvar = "ttt_minimum_players",
        label = "label_minimum_players",
        min = 0,
        max = 15,
        decimal = 0,
    })

    local form4 = vgui.CreateTTT2Form(parent, "header_round_setup_post")

    form4:MakeCheckBox({
        serverConvar = "ttt_postround_dm",
        label = "label_postround_dm",
    })

    form4:MakeSlider({
        serverConvar = "ttt_posttime_seconds",
        label = "label_posttime_seconds",
        min = 0,
        max = 120,
        decimal = 0,
    })

    local form5 = vgui.CreateTTT2Form(parent, "header_round_setup_map_duration")

    form5:MakeHelp({
        label = "help_session_limits_mode",
    })

    local enbSessionLimitsMode = form5:MakeComboBox({
        label = "label_session_limits_mode",
        serverConvar = "ttt_session_limits_mode",
        choices = {
            { title = TryT("choice_session_limits_mode_0"), value = 0 },
            { title = TryT("choice_session_limits_mode_1"), value = 1 },
            { title = TryT("choice_session_limits_mode_2"), value = 2 },
            { title = TryT("choice_session_limits_mode_3"), value = 3 },
        },
    })

    form5:MakeHelp({
        label = "help_round_limit",
        master = enbSessionLimitsMode,
    })

    form5:MakeSlider({
        serverConvar = "ttt_round_limit",
        label = "label_round_limit",
        min = 0,
        max = 100,
        decimal = 0,
        master = enbSessionLimitsMode,
    })

    form5:MakeSlider({
        serverConvar = "ttt_time_limit_minutes",
        label = "label_time_limit_minutes",
        min = 0,
        max = 175,
        decimal = 0,
        master = enbSessionLimitsMode,
    })

    local form6 = vgui.CreateTTT2Form(parent, "header_loadingscreen")

    form6:MakeHelp({
        label = "help_enable_loadingscreen",
    })

    form6:MakeHelp({
        label = "help_enable_loadingscreen_server",
    })

    local enbLoadingscreen = form6:MakeCheckBox({
        label = "label_enable_loadingscreen_server",
        serverConvar = "ttt2_enable_loadingscreen_server",
    })

    form6:MakeSlider({
        label = "label_loadingscreen_min_duration",
        serverConvar = "ttt2_loadingscreen_min_duration",
        min = 0,
        max = 10,
        decimal = 1,
        master = enbLoadingscreen,
    })
end
