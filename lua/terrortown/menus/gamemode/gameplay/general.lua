--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 100
CLGAMEMODESUBMENU.title = "submenu_gameplay_general_title"
CLGAMEMODESUBMENU.icon = Material("vgui/ttt/vskin/helpscreen/gameplay")

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_gameplay_settings")

    form:MakeCheckBox({
        label = "label_gameplay_specmode",
        convar = "ttt_spectator_mode",
    })

    form:MakeCheckBox({
        label = "label_shop_double_click_buy",
        convar = "ttt_bem_enable_doubleclick_buy",
    })

    local form2 = vgui.CreateTTT2Form(parent, "header_weapon_settings")

    form2:MakeCheckBox({
        label = "label_gameplay_fastsw",
        convar = "ttt_weaponswitcher_fast",
    })

    form2:MakeCheckBox({
        label = "label_gameplay_hold_aim",
        convar = "ttt2_hold_aim",
    })

    form2:MakeCheckBox({
        label = "label_crosshair_ironsight_low_enabled",
        convar = "ttt_ironsights_lowered",
    })
end
