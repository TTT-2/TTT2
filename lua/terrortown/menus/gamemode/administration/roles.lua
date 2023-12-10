--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 97
CLGAMEMODESUBMENU.title = "submenu_administration_roles_general_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_roles_additional")

	local masterEnb = form:MakeCheckBox({
		serverConvar = "ttt_newroles_enabled",
		label = "label_roles_newroles_enabled"
	})

	form:MakeHelp({
		label = "help_roles_advanced_warning"
	})

	form:MakeHelp({
		label = "help_roles_max_roles"
	})

	form:MakeSlider({
		serverConvar = "ttt_max_roles",
		label = "label_roles_max_roles",
		min = 0,
		max = 64,
		decimal = 0,
		master = masterEnb
	})

	form:MakeSlider({
		serverConvar = "ttt_max_roles_pct",
		label = "label_roles_max_roles_pct",
		min = 0,
		max = 1,
		decimal = 2,
		master = masterEnb
	})

	form:MakeHelp({
		label = "help_roles_max_baseroles"
	})

	form:MakeSlider({
		serverConvar = "ttt_max_baseroles",
		label = "label_roles_max_baseroles",
		min = 0,
		max = 64,
		decimal = 0,
		master = masterEnb
	})

	form:MakeSlider({
		serverConvar = "ttt_max_baseroles_pct",
		label = "label_roles_max_baseroles_pct",
		min = 0,
		max = 1,
		decimal = 2,
		master = masterEnb
	})

	form:MakeHelp({
		label = "help_roles_allow_avoiding"
	})

	form:MakeCheckBox({
		serverConvar = "ttt2_roles_allow_avoiding",
		label = "label_roles_allow_avoiding"
	})

	local form2 = vgui.CreateTTT2Form(parent, "header_roles_reward_credits")

	form2:MakeHelp({
		label = "help_roles_award_info"
	})

	form2:MakeSlider({
		serverConvar = "ttt_credits_award_size",
		label = "label_roles_credits_award_size",
		min = 0,
		max = 5,
		decimal = 0
	})

	form2:MakeHelp({
		label = "help_roles_award_pct"
	})

	form2:MakeSlider({
		serverConvar = "ttt_credits_award_pct",
		label = "label_roles_credits_award_pct",
		min = 0,
		max = 1,
		decimal = 2
	})

	form2:MakeHelp({
		label = "help_roles_award_repeat"
	})

	form2:MakeCheckBox({
		serverConvar = "ttt_credits_award_repeat",
		label = "label_roles_credits_award_repeat"
	})

	form2:MakeHelp({
		label = "help_roles_credits_award_kill"
	})

	form2:MakeSlider({
		serverConvar = "ttt_credits_award_kill",
		label = "label_roles_credits_award_kill",
		min = 0,
		max = 10,
		decimal = 0
	})

	local form3 = vgui.CreateTTT2Form(parent, "header_roles_special_settings")

	form3:MakeHelp({
		label = "help_detective_hats"
	})

	form3:MakeCheckBox({
		serverConvar = "ttt_detective_hats",
		label = "label_detective_hats"
	})
end
