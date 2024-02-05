--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 88
CLGAMEMODESUBMENU.title = "submenu_administration_inventory_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_inventory_gernal")

    form:MakeHelp({
        label = "help_max_slots",
    })

    form:MakeSlider({
        serverConvar = "ttt2_max_melee_slots",
        label = "label_max_melee_slots",
        min = -1,
        max = 10,
        decimal = 0,
    })

    form:MakeSlider({
        serverConvar = "ttt2_max_secondary_slots",
        label = "label_max_secondary_slots",
        min = -1,
        max = 10,
        decimal = 0,
    })

    form:MakeSlider({
        serverConvar = "ttt2_max_primary_slots",
        label = "label_max_primary_slots",
        min = -1,
        max = 10,
        decimal = 0,
    })

    form:MakeSlider({
        serverConvar = "ttt2_max_nade_slots",
        label = "label_max_nade_slots",
        min = -1,
        max = 10,
        decimal = 0,
    })

    form:MakeSlider({
        serverConvar = "ttt2_max_carry_slots",
        label = "label_max_carry_slots",
        min = -1,
        max = 10,
        decimal = 0,
    })

    form:MakeSlider({
        serverConvar = "ttt2_max_unarmed_slots",
        label = "label_max_unarmed_slots",
        min = -1,
        max = 10,
        decimal = 0,
    })

    form:MakeSlider({
        serverConvar = "ttt2_max_special_slots",
        label = "label_max_special_slots",
        min = -1,
        max = 10,
        decimal = 0,
    })

    form:MakeSlider({
        serverConvar = "ttt2_max_extra_slots",
        label = "label_max_extra_slots",
        min = -1,
        max = 10,
        decimal = 0,
    })

    local form2 = vgui.CreateTTT2Form(parent, "header_inventory_pickup")

    form2:MakeCheckBox({
        serverConvar = "ttt_weapon_autopickup",
        label = "label_weapon_autopickup",
    })
end
