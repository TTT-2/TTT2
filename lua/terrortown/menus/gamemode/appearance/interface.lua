--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 92
CLGAMEMODESUBMENU.title = "submenu_appearance_interface_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_interface_settings")

	form:MakeCheckBox({
		label = "label_interface_tips_enable",
		convar = "ttt_tips_enable"
	})

	form:MakeSlider({
		label = "label_interface_popup",
		convar = "ttt_startpopup_duration",
		min = 0,
		max = 60,
		decimal = 0
	})

	form:MakeHelp({
		label = "help_HUD_enable_description"
	})

	form:MakeCheckBox({
		label = "label_HUD_enable_box_blur",
		convar = "ttt2_hud_enable_box_blur"
	})

	form:MakeCheckBox({
		label = "label_HUD_enable_description",
		convar = "ttt2_hud_enable_description"
	})

	local form2 = vgui.CreateTTT2Form(parent, "header_interface_keys")

	form2:MakeHelp({
		label = "help_keyhelp"
	})

	form2:MakeCheckBox({
		label = "label_keyhelp_show_core",
		convar = "ttt2_keyhelp_show_core"
	})

	form2:MakeCheckBox({
		label = "label_keyhelp_show_extra",
		convar = "ttt2_keyhelp_show_extra"
	})

	form2:MakeCheckBox({
		label = "label_keyhelp_show_equipment",
		convar = "ttt2_keyhelp_show_equipment"
	})

	local form3 = vgui.CreateTTT2Form(parent, "header_interface_wepswitch")

	form3:MakeCheckBox({
		label = "label_interface_fastsw_menu",
		convar = "ttt_weaponswitcher_displayfast"
	})

	form3:MakeCheckBox({
		label = "label_inferface_wswitch_hide_enable",
		convar = "ttt_weaponswitcher_hide"
	})

end
