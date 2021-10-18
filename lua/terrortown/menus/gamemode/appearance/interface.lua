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

	form:MakeCheckBox({
		label = "label_interface_fastsw_menu",
		convar = "ttt_weaponswitcher_displayfast"
	})

	form:MakeCheckBox({
		label = "label_inferface_wswitch_hide_enable",
		convar = "ttt_weaponswitcher_hide"
	})

	form:MakeCheckBox({
		label = "label_inferface_scues_enable",
		convar = "ttt_cl_soundcues"
	})
end
