--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 98
CLGAMEMODESUBMENU.title = "submenu_administration_round_setup_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_round_dead_players")

	form:MakeCheckBox({
		serverConvar = "ttt_identify_body_woconfirm",
		label = "label_identify_body_woconfirm"
	})

	form:MakeCheckBox({
		serverConvar = "ttt_announce_body_found",
		label = "label_announce_body_found"
	})

	form:MakeCheckBox({
		serverConvar = "ttt2_confirm_killlist",
		label = "label_confirm_killlist"
	})

	form:MakeCheckBox({
		serverConvar = "ttt2_inspect_detective_only",
		label = "label_inspect_detective_only"
	})

	form:MakeCheckBox({
		serverConvar = "ttt2_confirm_detective_only",
		label = "label_confirm_detective_only"
	})

	form:MakeCheckBox({
		serverConvar = "ttt_dyingshot",
		label = "label_dyingshot"
	})

	local form2 = vgui.CreateTTT2Form(parent, "header_round_setup_prep")

	form2:MakeCheckBox({
		serverConvar = "ttt2_prep_respawn",
		label = "label_prep_respawn"
	})

	form2:MakeCheckBox({
		serverConvar = "ttt_nade_throw_during_prep",
		label = "label_nade_throw_during_prep"
	})

	form2:MakeSlider({
		serverConvar = "ttt_preptime_seconds",
		label = "label_preptime_seconds",
		min = 0,
		max = 120,
		decimal = 0
	})

	form2:MakeSlider({
		serverConvar = "ttt_firstpreptime",
		label = "label_firstpreptime_seconds",
		min = 0,
		max = 120,
		decimal = 0
	})

	local form3 = vgui.CreateTTT2Form(parent, "header_round_setup_round")

	form3:MakeSlider({
		serverConvar = "ttt_roundtime_minutes",
		label = "label_roundtime_minutes",
		min = 0,
		max = 60,
		decimal = 0,
	})

	form3:MakeHelp({
		label = "help_haste_mode"
	})

	local enbHaste = form3:MakeCheckBox({
		serverConvar = "ttt_haste",
		label = "label_haste"
	})

	form3:MakeSlider({
		serverConvar = "ttt_haste_starting_minutes",
		label = "label_haste_starting_minutes",
		min = 0,
		max = 60,
		decimal = 0,
		master = enbHaste
	})

	form3:MakeSlider({
		serverConvar = "ttt_haste_minutes_per_death",
		label = "label_haste_minutes_per_death",
		min = 0,
		max = 10,
		decimal = 1,
		master = enbHaste
	})

	form3:MakeHelp({
		label = "help_sherlock_mode"
	})

	form3:MakeCheckBox({
		serverConvar = "ttt_sherlock_mode",
		label = "label_sherlock_mode"
	})

	form3:MakeSlider({
		serverConvar = "ttt_minimum_players",
		label = "label_minimum_players",
		min = 0,
		max = 15,
		decimal = 0
	})

	local form4 = vgui.CreateTTT2Form(parent, "header_round_setup_post")

	form4:MakeCheckBox({
		serverConvar = "ttt_postround_dm",
		label = "label_postround_dm"
	})

	form4:MakeSlider({
		serverConvar = "ttt_posttime_seconds",
		label = "label_posttime_seconds",
		min = 0,
		max = 120,
		decimal = 0
	})

	local form5 = vgui.CreateTTT2Form(parent, "header_round_setup_map_duration")

	local enbSessionLimitsEnabled = form5:MakeCheckBox({
		serverConvar = "ttt_session_limits_enabled",
		label = "label_session_limits_enabled"
	})

	form5:MakeHelp({
		label = "help_round_limit"
	})

	form5:MakeSlider({
		serverConvar = "ttt_round_limit",
		label = "label_round_limit",
		min = 0,
		max = 100,
		decimal = 0,
		master = enbSessionLimitsEnabled
	})

	form5:MakeSlider({
		serverConvar = "ttt_time_limit_minutes",
		label = "label_time_limit_minutes",
		min = 0,
		max = 175,
		decimal = 0,
		master = enbSessionLimitsEnabled
	})
end
