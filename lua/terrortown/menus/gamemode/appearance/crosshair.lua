--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 95
CLGAMEMODESUBMENU.title = "submenu_appearance_crosshair_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_crosshair_settings")

	-- store the reference to the checkbox in a variable
	-- because the other settings are enabled based on
	-- the state of this checkbox
	local crossEnb = form:MakeCheckBox({
		label = "label_crosshair_enable",
		convar = "ttt_enable_crosshair"
	})

	-- store the reference to the checkbox in a variable
	-- because the other settings are enabled based on
	-- the state of this checkbox
	local crossGapEnb = form:MakeCheckBox({
		label = "label_crosshair_gap_enable",
		convar = "ttt_crosshair_gap_enable",
		master = crossEnb
	})

	form:MakeSlider({
		label = "label_crosshair_gap",
		convar = "ttt_crosshair_gap",
		min = 0,
		max = 30,
		decimal = 0,
		-- this master depends on crossEnb, therefore this
		-- slider also depends on crossEnb, while also depending
		-- on crossGapEnb
		master = crossGapEnb
	})

	form:MakeSlider({
		label = "label_crosshair_opacity",
		convar = "ttt_crosshair_opacity",
		min = 0,
		max = 1,
		decimal = 1,
		master = crossEnb
	})

	form:MakeSlider({
		label = "label_crosshair_ironsight_opacity",
		convar = "ttt_ironsights_crosshair_opacity",
		min = 0,
		max = 1,
		decimal = 1,
		master = crossEnb
	})

	form:MakeSlider({
		label = "label_crosshair_size",
		convar = "ttt_crosshair_size",
		min = 0.1,
		max = 3,
		decimal = 1,
		master = crossEnb
	})

	form:MakeSlider({
		label = "label_crosshair_thickness",
		convar = "ttt_crosshair_thickness",
		min = 1,
		max = 10,
		decimal = 0,
		master = crossEnb
	})

	form:MakeSlider({
		label = "label_crosshair_thickness_outline",
		convar = "ttt_crosshair_outlinethickness",
		min = 0,
		max = 5,
		decimal = 0,
		master = crossEnb
	})

	form:MakeCheckBox({
		label = "label_crosshair_static_enable",
		convar = "ttt_crosshair_static",
		master = crossEnb
	})

	form:MakeCheckBox({
		label = "label_crosshair_dot_enable",
		convar = "ttt_crosshair_dot",
		master = crossEnb
	})

	form:MakeCheckBox({
		label = "label_crosshair_lines_enable",
		convar = "ttt_crosshair_lines",
		master = crossEnb
	})

	form:MakeCheckBox({
		label = "label_crosshair_scale_enable",
		convar = "ttt_crosshair_weaponscale",
		master = crossEnb
	})

	form:MakeCheckBox({
		label = "label_crosshair_ironsight_low_enabled",
		convar = "ttt_ironsights_lowered",
		master = crossEnb
	})
end
