--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 100
CLGAMEMODESUBMENU.title = "submenu_gameplay_general_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_gameplay_settings")

	form:MakeCheckBox({
		label = "label_gameplay_specmode",
		convar = "ttt_spectator_mode",
	})

	form:MakeCheckBox({
		label = "label_gameplay_fastsw",
		convar = "ttt_weaponswitcher_fast",
	})

	form:MakeCheckBox({
		label = "label_gameplay_hold_aim",
		convar = "ttt2_hold_aim",
	})

	form:MakeCheckBox({
		label = "label_shop_double_click_buy",
		convar = "ttt_bem_enable_doubleclick_buy",
	})

	form:MakeCheckBox({
		label = "label_grenade_fuse_meter_ui",
		convar = "ttt2_grenade_fuse_meter_ui"
	})

	form:MakeCheckBox({
		label = "label_grenade_trajectory_ui",
		convar = "ttt2_grenade_trajectory_ui"
	})
end
