--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 90
CLGAMEMODESUBMENU.title = "submenu_administration_mapentities_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_mapentities_prop_possession")

    form:MakeHelp({
        label = "help_prop_possession",
    })

    local enbPP = form:MakeCheckBox({
        serverConvar = "ttt_spec_prop_control",
        label = "label_spec_prop_control",
    })

    form:MakeSlider({
        serverConvar = "ttt_spec_prop_base",
        label = "label_spec_prop_base",
        min = 0,
        max = 50,
        decimal = 0,
        master = enbPP,
    })

    form:MakeSlider({
        serverConvar = "ttt_spec_prop_maxpenalty",
        label = "label_spec_prop_maxpenalty",
        min = -50,
        max = 0,
        decimal = 0,
        master = enbPP,
    })

    form:MakeSlider({
        serverConvar = "ttt_spec_prop_maxbonus",
        label = "label_spec_prop_maxbonus",
        min = 0,
        max = 50,
        decimal = 0,
        master = enbPP,
    })

    form:MakeSlider({
        serverConvar = "ttt_spec_prop_force",
        label = "label_spec_prop_force",
        min = 50,
        max = 300,
        decimal = 0,
        master = enbPP,
    })

    form:MakeSlider({
        serverConvar = "ttt_spec_prop_rechargetime",
        label = "label_spec_prop_rechargetime",
        min = 0,
        max = 5,
        decimal = 1,
        master = enbPP,
    })

    form:MakeHelp({
        label = "help_prop_spec_dash",
        master = enbPP,
    })

    form:MakeSlider({
        serverConvar = "ttt_spec_prop_dash",
        label = "label_spec_prop_dash",
        min = 1,
        max = 10,
        decimal = 0,
        master = enbPP,
    })

    local form2 = vgui.CreateTTT2Form(parent, "header_mapentities_doors")

    form2:MakeCheckBox({
        serverConvar = "ttt2_doors_force_pairs",
        label = "label_doors_force_pairs",
    })

    local enbDoor = form2:MakeCheckBox({
        serverConvar = "ttt2_doors_destructible",
        label = "label_doors_destructible",
    })

    form2:MakeCheckBox({
        serverConvar = "ttt2_doors_locked_indestructible",
        label = "label_doors_locked_indestructible",
        master = enbDoor,
    })

    form2:MakeSlider({
        serverConvar = "ttt2_doors_health",
        label = "label_doors_health",
        min = 0,
        max = 500,
        decimal = 0,
        master = enbDoor,
    })

    form2:MakeSlider({
        serverConvar = "ttt2_doors_prop_health",
        label = "label_doors_prop_health",
        min = 0,
        max = 500,
        decimal = 0,
        master = enbDoor,
    })
end
