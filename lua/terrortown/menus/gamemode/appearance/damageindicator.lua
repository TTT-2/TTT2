--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 94
CLGAMEMODESUBMENU.title = "submenu_appearance_dmgindicator_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_damage_indicator")

    form:MakeHelp({
        label = "help_damage_indicator_desc",
    })

    -- store the reference to the checkbox in a variable
    -- because the other settings are enabled based on
    -- the state of this checkbox
    local dmgEnb = form:MakeCheckBox({
        label = "label_damage_indicator_enable",
        convar = "ttt_dmgindicator_enable",
    })

    form:MakeComboBox({
        label = "label_damage_indicator_mode",
        convar = "ttt_dmgindicator_mode",
        choices = dmgindicator.GetThemeNames(),
        master = dmgEnb,
    })

    form:MakeSlider({
        label = "label_damage_indicator_duration",
        convar = "ttt_dmgindicator_duration",
        min = 0,
        max = 30,
        decimal = 2,
        master = dmgEnb,
    })

    form:MakeSlider({
        label = "label_damage_indicator_maxdamage",
        convar = "ttt_dmgindicator_maxdamage",
        min = 0,
        max = 100,
        decimal = 1,
        master = dmgEnb,
    })

    form:MakeSlider({
        label = "label_damage_indicator_maxalpha",
        convar = "ttt_dmgindicator_maxalpha",
        min = 0,
        max = 255,
        decimal = 0,
        master = dmgEnb,
    })
end
