--- @ignore

local TryT = LANG.TryTranslation

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 95
CLGAMEMODESUBMENU.title = "submenu_appearance_crosshair_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_crosshair_settings")

    -- store the reference to the checkbox in a variable
    -- because the other settings are enabled based on
    -- the state of this checkbox
    local crossEnb = form:MakeCheckBox({
        label = "label_crosshair_enable",
        convar = "ttt_enable_crosshair",
    })

    form:MakeHelp({
        label = "help_crosshair_scale_enable",
        master = crossEnb,
    })

    local crossDynScaleEnb = form:MakeCheckBox({
        label = "label_crosshair_scale_enable",
        convar = "ttt_crosshair_weaponscale",
        master = crossEnb,
    })

    form:MakeCheckBox({
        label = "label_crosshair_static_length",
        convar = "ttt_crosshair_static_length",
        master = crossDynScaleEnb,
    })

    form:MakeCheckBox({
        label = "label_crosshair_static_gap_length",
        convar = "ttt_crosshair_static_gap_length",
        master = crossDynScaleEnb,
    })

    form:MakeSlider({
        label = "label_crosshair_size",
        convar = "ttt_crosshair_size",
        min = 0,
        max = 3,
        decimal = 1,
        master = crossEnb,
    })

    form:MakeSlider({
        label = "label_crosshair_size_gap",
        convar = "ttt_crosshair_size_gap",
        min = 0,
        max = 3,
        decimal = 1,
        master = crossEnb,
    })

    form:MakeSlider({
        label = "label_crosshair_thickness",
        convar = "ttt_crosshair_thickness",
        min = 1,
        max = 10,
        decimal = 0,
        master = crossEnb,
    })

    form:MakeComboBox({
        label = "label_crosshair_mode",
        convar = "ttt_crosshair_mode",
        choices = {
            { title = TryT("choice_crosshair_mode_0"), value = 0 },
            { title = TryT("choice_crosshair_mode_1"), value = 1 },
            { title = TryT("choice_crosshair_mode_2"), value = 2 },
        },
        master = crossEnb,
    })

    local crossOutlineEnb = form:MakeCheckBox({
        label = "label_crosshair_thickness_outline_enable",
        convar = "ttt_crosshair_outline_enable",
        master = crossEnb,
    })

    form:MakeSlider({
        label = "label_crosshair_thickness_outline",
        convar = "ttt_crosshair_outline_thickness",
        min = 0,
        max = 5,
        decimal = 0,
        master = crossOutlineEnb,
    })

    form:MakeCheckBox({
        label = "label_crosshair_outline_high_contrast",
        convar = "ttt_crosshair_outline_high_contrast",
        master = crossOutlineEnb,
    })

    form:MakeSlider({
        label = "label_crosshair_opacity",
        convar = "ttt_crosshair_opacity",
        min = 0,
        max = 1,
        decimal = 1,
        master = crossEnb,
    })

    form:MakeSlider({
        label = "label_crosshair_ironsight_opacity",
        convar = "ttt_ironsights_crosshair_opacity",
        min = 0,
        max = 1,
        decimal = 1,
        master = crossEnb,
    })

    form:MakeCheckBox({
        label = "label_grenade_trajectory_ui",
        convar = "ttt2_grenade_trajectory_ui",
        master = crossEnb,
    })
end
