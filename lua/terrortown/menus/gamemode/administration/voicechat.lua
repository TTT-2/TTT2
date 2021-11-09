--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 93
CLGAMEMODESUBMENU.title = "submenu_administration_voicechat_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_voicechat_battery")

	form:MakeHelp({
		label = "help_voicechat_battery"
	})

	local enbBat = form:MakeCheckBox({
		serverConvar = "ttt_voice_drain",
		label = "label_voice_drain"
	})

	form:MakeSlider({
		serverConvar = "ttt_voice_drain_normal",
		label = "label_voice_drain_normal",
		min = 0,
		max = 1,
		decimal = 2,
		master = enbBat
	})

	form:MakeSlider({
		serverConvar = "ttt_voice_drain_admin",
		label = "label_voice_drain_admin",
		min = 0,
		max = 1,
		decimal = 2,
		master = enbBat
	})

	form:MakeSlider({
		serverConvar = "ttt_voice_drain_recharge",
		label = "label_voice_drain_recharge",
		min = 0,
		max = 1,
		decimal = 2,
		master = enbBat
	})

	local form2 = vgui.CreateTTT2Form(parent, "header_voicechat_locational")

	form2:MakeCheckBox({
		serverConvar = "ttt_locational_voice",
		label = "label_locational_voice"
	})
end
