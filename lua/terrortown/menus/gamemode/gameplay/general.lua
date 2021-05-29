--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 100
CLGAMEMODESUBMENU.title = "submenu_gameplay_general_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_gameplay_settings")

	form:MakeCheckBox({
		label = "label_gameplay_specmode",
		convar = "ttt_spectator_mode"
	})

	form:MakeCheckBox({
		label = "label_gameplay_fastsw",
		convar = "ttt_weaponswitcher_fast"
	})

	form:MakeCheckBox({
		label = "label_gameplay_hold_aim",
		convar = "ttt2_hold_aim"
	})

	form:MakeCheckBox({
		label = "label_gameplay_mute",
		convar = "ttt_mute_team_check"
	})

	local enbSprint = form:MakeCheckBox({
		label = "label_gameplay_dtsprint_enable",
		convar = "ttt2_enable_doubletap_sprint"
	})

	form:MakeCheckBox({
		label = "label_gameplay_dtsprint_anykey",
		convar = "ttt2_doubletap_sprint_anykey",
		master = enbSprint
	})

	form:MakeCheckBox({
		label = "label_shop_double_click_buy",
		convar = "ttt_bem_enable_doubleclick_buy"
	})
end
