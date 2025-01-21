--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 97
CLGAMEMODESUBMENU.title = "submenu_roles_roles_general_title"
CLGAMEMODESUBMENU.searchable = false

local TryT = LANG.TryTranslation

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_roles_additional")

    local masterEnb = form:MakeCheckBox({
        serverConvar = "ttt_newroles_enabled",
        label = "label_roles_newroles_enabled",
    })

    form:MakeHelp({
        label = "help_roles_advanced_warning",
        master = masterEnb,
    })

    form:MakeHelp({
        label = "help_roles_max_roles",
        master = masterEnb,
    })

    form:MakeSlider({
        serverConvar = "ttt_max_roles",
        label = "label_roles_max_roles",
        min = 0,
        max = 64,
        decimal = 0,
        master = masterEnb,
    })

    form:MakeSlider({
        serverConvar = "ttt_max_roles_pct",
        label = "label_roles_max_roles_pct",
        min = 0,
        max = 1,
        decimal = 2,
        master = masterEnb,
    })

    form:MakeHelp({
        label = "help_roles_max_baseroles",
        master = masterEnb,
    })

    form:MakeSlider({
        serverConvar = "ttt_max_baseroles",
        label = "label_roles_max_baseroles",
        min = 0,
        max = 64,
        decimal = 0,
        master = masterEnb,
    })

    form:MakeSlider({
        serverConvar = "ttt_max_baseroles_pct",
        label = "label_roles_max_baseroles_pct",
        min = 0,
        max = 1,
        decimal = 2,
        master = masterEnb,
    })

    local form2 = vgui.CreateTTT2Form(parent, "header_roles_derandomize")

    form2:MakeHelp({
        label = "help_roles_derandomize",
    })

    local masterDerand = form2:MakeComboBox({
        serverConvar = "ttt_role_derandomize_mode",
        label = "label_roles_derandomize_mode",
        choices = {
            {
                title = TryT("label_roles_derandomize_mode_none"),
                value = ROLE_DERAND_NONE,
            },
            {
                title = TryT("label_roles_derandomize_mode_base_only"),
                value = ROLE_DERAND_BASEROLE,
            },
            {
                title = TryT("label_roles_derandomize_mode_sub_only"),
                value = ROLE_DERAND_SUBROLE,
            },
            {
                title = TryT("label_roles_derandomize_mode_base_and_sub"),
                value = ROLE_DERAND_BOTH,
            },
        },
    })

    form2:MakeHelp({
        label = "help_roles_derandomize_min_weight",
        master = masterDerand,
    })

    form2:MakeSlider({
        serverConvar = "ttt_role_derandomize_min_weight",
        label = "label_roles_derandomize_min_weight",
        master = masterDerand,
        min = 1,
        max = 50,
        decimal = 0,
    })

    local form3 = vgui.CreateTTT2Form(parent, "header_roles_reward_credits")

    form3:MakeHelp({
        label = "help_roles_award_info",
    })

    form3:MakeSlider({
        serverConvar = "ttt_credits_award_size",
        label = "label_roles_credits_award_size",
        min = 0,
        max = 5,
        decimal = 0,
    })

    form3:MakeHelp({
        label = "help_roles_award_pct",
    })

    form3:MakeSlider({
        serverConvar = "ttt_credits_award_pct",
        label = "label_roles_credits_award_pct",
        min = 0,
        max = 1,
        decimal = 2,
    })

    form3:MakeHelp({
        label = "help_roles_award_repeat",
    })

    form3:MakeCheckBox({
        serverConvar = "ttt_credits_award_repeat",
        label = "label_roles_credits_award_repeat",
    })

    form3:MakeHelp({
        label = "help_roles_credits_award_kill",
    })

    form3:MakeSlider({
        serverConvar = "ttt_credits_award_kill",
        label = "label_roles_credits_award_kill",
        min = 0,
        max = 10,
        decimal = 0,
    })

    local form4 = vgui.CreateTTT2Form(parent, "header_roles_special_settings")

    form4:MakeHelp({
        label = "help_detective_hats",
    })

    form4:MakeCheckBox({
        serverConvar = "ttt_detective_hats",
        label = "label_detective_hats",
    })

    form4:MakeHelp({
        label = "help_inspect_credits_always",
    })

    form4:MakeCheckBox({
        serverConvar = "ttt2_inspect_credits_always_visible",
        label = "label_inspect_credits_always",
    })
end
