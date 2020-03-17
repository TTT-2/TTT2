local materialIcon = Material("vgui/ttt/derma/helpscreen/appearance")

local function PopulateGeneralPanel(parent)
	local form = CreateForm(parent, "set_title_color")

	form:MakeHelp({
		label = "help_color_desc"
	})

	form:MakeCheckBox({
		label = "set_global_color_enable",
		initial = GLAPP.ShouldUseGlobalFocusColor(),
		onChange = function(_, value)
			GLAPP.SetUseGlobalFocusColor(value)
		end
	})

	local cm = form:ColorMixer("set_global_focus_color", GLAPP.GetFocusColor(), false, false)

	cm.ValueChanged = function(self, color)
		GLAPP.SetFocusColor(color)
	end

	form:MakeHelp({
		label = "help_scale_factor"
	})

	form:MakeSlider({
		label = "set_scale_factor",
		min = 0.1,
		max = 3,
		decimal = 1,
		initial = GLAPP.GetGlobalScale(),
		onValueChanged = function(self, value)
			GLAPP.SetGlobalScale(value)

			-- reset to make sure it is only in valid steps
			self:SetValue(GLAPP.GetGlobalScale())
		end
	})
end

local function PopulateHUDSwitcherPanelSettings(parent, currentHUD)
	parent:Clear()

	parent:MakeHelp({
		label = "help_hud_special_settings"
	})

	for key, data in pairs(currentHUD:GetSavingKeys() or {}) do
		if data.typ == "color" then
			local cm = parent:ColorMixer(data.desc or key, currentHUD[key] or COLOR_WHITE, true, true)

			function cm:ValueChanged(col)
				currentHUD[key] = col

				if isfunction(data.OnChange) then
					data.OnChange(currentHUD, col)
				end
			end

		elseif data.typ == "number" then
			local ns = parent:NumSlider(data.desc or key, nil, 0.1, 4.0, 1)

			if currentHUD[key] then
				ns:SetDefaultValue(currentHUD[key])
				ns:SetValue(math.Round(currentHUD[key], 1))
			end

			function ns:OnValueChanged(val)
				val = math.Round(val, 1)

				if val ~= math.Round(currentHUD[key], 1) then
					if isfunction(data.OnChange) then
						data.OnChange(currentHUD, val)
					end

					currentHUD[key] = val
				end
			end
		end
	end
end

local function PopulateHUDSwitcherPanel(parent)
	local form = CreateForm(parent, "set_title_hud_select")

	local currentHUDName = HUDManager.GetHUD()
	local currentHUD = huds.GetStored(currentHUDName)
	local hudList = huds.GetList()
	local restrictedHUDs = HUDManager.GetModelValue("restrictedHUDs")
	local validHUDs = {}

	if not currentHUD.GetSavingKeys then
		form:MakeHelp({
			label = "help_hud_game_reload"
		})

		return
	end

	for i = 1, #hudList do
		local hud = hudList[i]

		-- do not add HUD to the selection list if restricted
		if table.HasValue(restrictedHUDs, hud.id) then continue end

		validHUDs[#validHUDs + 1] = hud.id
	end

	form:MakeComboBox({
		label = "select_hud",
		choices = validHUDs,
		selectName = currentHUDName,
		onSelect = function(_, _, value)
			HUDManager.SetHUD(value)
		end
	})

	PopulateHUDSwitcherPanelSettings(CreateForm(parent, "set_title_hud_customize"), currentHUD)

	-- REGISTER UNHIDE FUNCTION TO STOP HUD EDITOR
	VHDL.RegisterCallback("unhide", function(menu)
		HUDEditor.StopEditHUD()
	end)
end

hook.Add("TTT2HUDUpdated", "UpdateHUDSwitcherData", function(name)
	if HELPSCRN:GetOpenMenu() ~= "ttt2_appearance_hud_switcher" then return end

	-- rebuild the content area so that data is refreshed
	-- based on the newly selected HUD
	VHDL.Rebuild()
end)

local function PopulateVSkinPanel(parent)
	local form = CreateForm(parent, "set_title_vskin")

	form:MakeHelp({
		label = "help_vskin_info"
	})

	form:MakeComboBox({
		label = "select_vskin",
		choices = VSKIN.GetVSkinList(),
		selectName = VSKIN.GetVSkinName(),
		onSelect = function(_, _, value)
			VSKIN.SelectVSkin(value)
		end
	})

	form:MakeCheckBox({
		label = "set_blur_enable",
		initial = VSKIN.ShouldBlurBackground(),
		onChange = function(_, value)
			VSKIN.SetBlurBackground(value)
		end
	})
end

local function PopulateTargetIDPanel(parent)
	local form = CreateForm(parent, "set_title_targetid")

	form:MakeHelp({
		label = "help_targetid_info"
	})

	form:MakeCheckBox({
		label = "set_minimal_id",
		convar = "ttt_minimal_targetid"
	})
end

local function PopulateCrosshairPanel(parent)
	local form = CreateForm(parent, "set_title_cross")

	-- store the reference to the checkbox in a variable
	-- because the other settings are enabled based on
	-- the state of this checkbox
	local crossEnb = form:MakeCheckBox({
		label = "set_cross_enable",
		convar = "ttt_enable_crosshair"
	})

	-- store the reference to the checkbox in a variable
	-- because the other settings are enabled based on
	-- the state of this checkbox
	local crossGapEnb = form:MakeCheckBox({
		label = "set_cross_gap_enable",
		convar = "ttt_crosshair_gap_enable",
		master = crossEnb
	})

	form:MakeSlider({
		label = "set_cross_gap",
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
		label = "set_cross_opacity",
		convar = "ttt_crosshair_opacity",
		min = 0,
		max = 1,
		decimal = 1,
		master = crossEnb
	})

	form:MakeSlider({
		label = "set_ironsight_cross_opacity",
		convar = "ttt_ironsights_crosshair_opacity",
		min = 0,
		max = 1,
		decimal = 1,
		master = crossEnb
	})

	form:MakeSlider({
		label = "set_cross_size",
		convar = "ttt_crosshair_size",
		min = 0.1,
		max = 3,
		decimal = 1,
		master = crossEnb
	})

	form:MakeSlider({
		label = "set_cross_thickness",
		convar = "ttt_crosshair_thickness",
		min = 1,
		max = 10,
		decimal = 0,
		master = crossEnb
	})

	form:MakeSlider({
		label = "set_cross_outlinethickness",
		convar = "ttt_crosshair_outlinethickness",
		min = 0,
		max = 5,
		decimal = 0,
		master = crossEnb
	})

	form:MakeCheckBox({
		label = "set_cross_static_enable",
		convar = "ttt_crosshair_static",
		master = crossEnb
	})

	form:MakeCheckBox({
		label = "set_cross_dot_enable",
		convar = "ttt_crosshair_dot",
		master = crossEnb
	})

	form:MakeCheckBox({
		label = "set_cross_weaponscale_enable",
		convar = "ttt_crosshair_weaponscale",
		master = crossEnb
	})

	form:MakeCheckBox({
		label = "set_lowsights",
		convar = "ttt_ironsights_lowered",
		master = crossEnb
	})
end

local function PopulateDamagePanel(parent)
	local form = CreateForm(parent, "f1_dmgindicator_title")

	-- store the reference to the checkbox in a variable
	-- because the other settings are enabled based on
	-- the state of this checkbox
	local dmgEnb = form:MakeCheckBox({
		label = "f1_dmgindicator_enable",
		convar = "ttt_dmgindicator_enable"
	})

	form:MakeComboBox({
		label = "f1_dmgindicator_mode",
		convar = "ttt_dmgindicator_mode",
		choices = DMGINDICATOR.GetThemeNames(),
		master = dmgEnb
	})

	form:MakeSlider({
		label = "f1_dmgindicator_duration",
		convar = "ttt_dmgindicator_duration",
		min = 0,
		max = 30,
		decimal = 2,
		master = dmgEnb
	})

	form:MakeSlider({
		label = "f1_dmgindicator_maxdamage",
		convar = "ttt_dmgindicator_duration",
		min = 0,
		max = 100,
		decimal = 1,
		master = dmgEnb
	})

	form:MakeSlider({
		label = "f1_dmgindicator_maxalpha",
		convar = "ttt_dmgindicator_maxalpha",
		min = 0,
		max = 255,
		decimal = 0,
		master = dmgEnb
	})
end

local function PopulatePerformancePanel(parent)
	local form = CreateForm(parent, "set_title_gui")

	form:MakeCheckBox({
		label = "set_tips",
		convar = "ttt_tips_enable"
	})

	form:MakeCheckBox({
		label = "entity_draw_halo",
		convar = "ttt_entity_draw_halo"
	})

	form:MakeCheckBox({
		label = "disable_spectatorsoutline",
		convar = "ttt2_disable_spectatorsoutline"
	})

	form:MakeCheckBox({
		label = "disable_overheadicons",
		convar = "ttt2_disable_overheadicons"
	})
end

local function PopulateInterfacePanel(parent)
	local form = CreateForm(parent, "set_title_gui")

	form:MakeCheckBox({
		label = "set_tips",
		convar = "ttt_tips_enable"
	})

	form:MakeSlider({
		label = "set_startpopup",
		convar = "ttt_startpopup_duration",
		min = 0,
		max = 60,
		decimal = 0
	})

	form:MakeCheckBox({
		label = "set_fastsw_menu",
		convar = "ttt_weaponswitcher_displayfast"
	})

	form:MakeCheckBox({
		label = "set_wswitch",
		convar = "ttt_weaponswitcher_stay"
	})

	form:MakeCheckBox({
		label = "set_cues",
		convar = "ttt_cl_soundcues"
	})
end

---
-- Function to populate main menu
-- @param table helpData The main menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.populate["ttt2_appearance"] = function(helpData, id)
	local bindingsData = helpData:RegisterSubMenu(id)

	bindingsData:SetTitle("menu_appearance_title")
	bindingsData:SetDescription("menu_appearance_description")
	bindingsData:SetIcon(materialIcon)
end

---
-- Function to populate sub menu
-- @param table helpData The sub menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.subPopulate["ttt2_appearance"] = function(helpData, id)
	-- general
	local generalData = helpData:PopulateSubMenu(id .. "_general")

	generalData:SetTitle("submenu_appearance_general_title")
	generalData:PopulatePanel(PopulateGeneralPanel)

	-- HUD switcher
	local hudData = helpData:PopulateSubMenu(id .. "_hud_switcher")

	hudData:SetTitle("submenu_appearance_hudswitcher_title")
	hudData:PopulatePanel(PopulateHUDSwitcherPanel)
	hudData:PopulateButtonPanel(function(parent)
		local buttonReset = vgui.Create("DButtonTTT2", parent)
		buttonReset:SetText("Reset")
		buttonReset:SetSize(100, 45)
		buttonReset:SetPos(475, 20)
		buttonReset.DoClick = function(btn)
			local currentHUD = huds.GetStored(HUDManager.GetHUD())

			if not currentHUD then return end

			currentHUD:Reset()
			currentHUD:SaveData()
		end

		local buttonEditor = vgui.Create("DButtonTTT2", parent)
		buttonEditor:SetText("HUD Editor")
		buttonEditor:SetSize(175, 45)
		buttonEditor:SetPos(600, 20)
		buttonEditor.DoClick = function(btn)
			local currentHUDName = HUDManager.GetHUD()

			if not currentHUDName then return end

			HUDEditor.EditHUD(currentHUDName)

			VHDL.HideFrame()
		end
	end)

	-- VSKIN
	local vskinData = helpData:PopulateSubMenu(id .. "_vskin")

	vskinData:SetTitle("submenu_appearance_vskin_title")
	vskinData:PopulatePanel(PopulateVSkinPanel)

	-- targetID
	local targetData = helpData:PopulateSubMenu(id .. "_target_id")

	targetData:SetTitle("submenu_appearance_targetid_title")
	targetData:PopulatePanel(PopulateTargetIDPanel)

	-- crosshair
	local crosshairData = helpData:PopulateSubMenu(id .. "_crosshair")

	crosshairData:SetTitle("submenu_appearance_crosshair_title")
	crosshairData:PopulatePanel(PopulateCrosshairPanel)

	-- damage indicator
	local damageData = helpData:PopulateSubMenu(id .. "_damage_indicator")

	damageData:SetTitle("submenu_appearance_dmgindicator_title")
	damageData:PopulatePanel(PopulateDamagePanel)

	-- performance
	local performanceData = helpData:PopulateSubMenu(id .. "_performance")

	performanceData:SetTitle("submenu_appearance_performance_title")
	performanceData:PopulatePanel(PopulatePerformancePanel)

	-- interface
	local interfaceData = helpData:PopulateSubMenu(id .. "_interface")

	interfaceData:SetTitle("submenu_appearance_interface_title")
	interfaceData:PopulatePanel(PopulateInterfacePanel)

	-- miscellaneous
	local miscellaneousData = helpData:PopulateSubMenu(id .. "_miscellaneous")

	miscellaneousData:SetTitle("submenu_appearance_miscellaneous_title")
end
