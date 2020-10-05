local materialIcon = Material("vgui/ttt/vskin/helpscreen/appearance")

local function PopulateGeneralPanel(parent)
	local form = CreateTTT2Form(parent, "header_global_color")

	form:MakeHelp({
		label = "help_color_desc"
	})

	-- store the reference to the checkbox in a variable
	-- because the other settings are enabled based on
	-- the state of this checkbox
	local enbColor = form:MakeCheckBox({
		label = "label_global_color_enable",
		initial = appearance.ShouldUseGlobalFocusColor(),
		OnChange = function(_, value)
			appearance.SetUseGlobalFocusColor(value)
		end,
		default = false
	})

	form:MakeColorMixer({
		label = "label_global_color",
		initial = appearance.GetFocusColor(),
		OnChange = function(_, color)
			appearance.SetFocusColor(color)
		end,
		master = enbColor
	})

	form:MakeHelp({
		label = "help_scale_factor"
	})

	form:MakeSlider({
		label = "label_global_scale_factor",
		min = 0.1,
		max = 3,
		decimal = 1,
		initial = appearance.GetGlobalScale(),
		OnChange = function(_, value)
			appearance.SetGlobalScale(value)
		end,
		default = appearance.GetDefaultGlobalScale()
	})
end

local hudSwicherSettings = {
	["color"] = function(parent, currentHUD, key, data)
		parent:MakeColorMixer({
			label = data.desc or key,
			initial = currentHUD[key],
			showAlphaBar = true,
			showPalette = true,
			OnChange = function(_, color)
				currentHUD[key] = color

				if isfunction(data.OnChange) then
					data.OnChange(currentHUD, color)
				end
			end
		})
	end,

	["number"] = function(parent, currentHUD, key, data)
		parent:MakeSlider({
			label = data.desc or key,
			min = data.min or 0.1,
			max = data.max or 4,
			decimal = data.decimal or 1,
			initial = math.Round(currentHUD[key] or 1, 1),
			default = data.default,
			OnChange = function(_, value)
				value = math.Round(value, 1)
				currentHUD[key] = value

				if isfunction(data.OnChange) then
					data.OnChange(currentHUD, value)
				end
			end
		})
	end,

	["boolean"] = function(parent, currentHUD, key, data)
		parent:MakeCheckBox({
			label = data.desc or key,
			initial = math.Round(currentHUD[key] or 1, 1),
			default = data.default,
			OnChange = function(_, value)
				value = value or false
				currentHUD[key] = value

				if isfunction(data.OnChange) then
					data.OnChange(currentHUD, value)
				end
			end
		})
	end
}

local function PopulateHUDSwitcherPanelSettings(parent, currentHUD)
	parent:Clear()

	parent:MakeHelp({
		label = "help_hud_special_settings"
	})

	for key, data in pairs(currentHUD:GetSavingKeys() or {}) do
		hudSwicherSettings[data.typ](parent, currentHUD, key, data)
	end
end

local function PopulateHUDSwitcherPanel(parent)
	local form = CreateTTT2Form(parent, "header_hud_select")

	local currentHUDName = HUDManager.GetHUD()
	local currentHUD = huds.GetStored(currentHUDName)
	local hudList = huds.GetList()
	local restrictedHUDs = ttt2net.GetGlobal({"hud_manager", "restrictedHUDs"})
	local forcedHUD = ttt2net.GetGlobal({"hud_manager", "forcedHUD"})
	local validHUDs = {}

	if not currentHUD.GetSavingKeys then
		form:MakeHelp({
			label = "help_hud_game_reload"
		})

		return
	end

	if forcedHUD then
		validHUDs[1] = forcedHUD
	else
		for i = 1, #hudList do
			local hud = hudList[i]

			-- do not add HUD to the selection list if restricted
			if table.HasValue(restrictedHUDs, hud.id) then continue end

			validHUDs[#validHUDs + 1] = hud.id
		end
	end

	form:MakeComboBox({
		label = "label_hud_select",
		choices = validHUDs,
		selectName = currentHUDName,
		OnChange = function(_, _, value)
			HUDManager.SetHUD(value)
		end,
		default = ttt2net.GetGlobal({"hud_manager", "defaultHUD"})
	})

	PopulateHUDSwitcherPanelSettings(CreateTTT2Form(parent, "header_hud_customize"), currentHUD)

	-- REGISTER UNHIDE FUNCTION TO STOP HUD EDITOR
	HELPSCRN.menuFrame.OnShow = function(slf)
		if HELPSCRN:GetOpenMenu() ~= "ttt2_appearance_hud_switcher" then return end

		HUDEditor.StopEditHUD()
	end
end

hook.Add("TTT2HUDUpdated", "UpdateHUDSwitcherData", function()
	if HELPSCRN:GetOpenMenu() ~= "ttt2_appearance_hud_switcher" then return end

	-- rebuild the content area so that data is refreshed
	-- based on the newly selected HUD
	vguihandler.Rebuild()
end)

local function PopulateVSkinPanel(parent)
	local form = CreateTTT2Form(parent, "header_vskin_select")

	form:MakeHelp({
		label = "help_vskin_info"
	})

	form:MakeComboBox({
		label = "label_vskin_select",
		choices = vskin.GetVSkinList(),
		selectName = vskin.GetVSkinName(),
		OnChange = function(_, _, value)
			vskin.SelectVSkin(value)
		end,
		default = vskin.GetDefaultVSkinName()
	})

	form:MakeCheckBox({
		label = "label_blur_enable",
		initial = vskin.ShouldBlurBackground(),
		OnChange = function(_, value)
			vskin.SetBlurBackground(value)
		end,
		default = true
	})

	form:MakeCheckBox({
		label = "label_color_enable",
		initial = vskin.ShouldColorBackground(),
		OnChange = function(_, value)
			vskin.SetColorBackground(value)
		end,
		default = true
	})
end

local function PopulateTargetIDPanel(parent)
	local form = CreateTTT2Form(parent, "header_targetid")

	form:MakeHelp({
		label = "help_targetid_info"
	})

	form:MakeCheckBox({
		label = "label_minimal_targetid",
		convar = "ttt_minimal_targetid"
	})
end

local function PopulateShopPanel(parent)
	local form = CreateTTT2Form(parent, "header_shop_settings")

	form:MakeHelp({
		label = "help_shop_key_desc"
	})

	form:MakeCheckBox({
		label = "label_shop_always_show",
		convar = "ttt_bem_always_show_shop"
	})

	if GetConVar("ttt_bem_allow_change"):GetBool() then
		local form2 = CreateTTT2Form(parent, "header_shop_layout")

		form2:MakeSlider({
			label = "label_shop_num_col",
			convar = "ttt_bem_cols",
			min = 1,
			max = 20,
			decimal = 0
		})

		form2:MakeSlider({
			label = "label_shop_num_row",
			convar = "ttt_bem_rows",
			min = 1,
			max = 20,
			decimal = 0
		})

		form2:MakeSlider({
			label = "label_shop_item_size",
			convar = "ttt_bem_size",
			min = 32,
			max = 128,
			decimal = 0
		})
	end

	local form3 = CreateTTT2Form(parent, "header_shop_marker")

	form3:MakeCheckBox({
		label = "label_shop_show_slot",
		convar = "ttt_bem_marker_slot"
	})

	form3:MakeCheckBox({
		label = "label_shop_show_custom",
		convar = "ttt_bem_marker_custom"
	})

	form3:MakeCheckBox({
		label = "label_shop_show_fav",
		convar = "ttt_bem_marker_fav"
	})
end

local function PopulateCrosshairPanel(parent)
	local form = CreateTTT2Form(parent, "header_crosshair_settings")

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

local function PopulateDamagePanel(parent)
	local form = CreateTTT2Form(parent, "header_damage_indicator")

	form:MakeHelp({
		label = "help_damage_indicator_desc"
	})

	-- store the reference to the checkbox in a variable
	-- because the other settings are enabled based on
	-- the state of this checkbox
	local dmgEnb = form:MakeCheckBox({
		label = "label_damage_indicator_enable",
		convar = "ttt_dmgindicator_enable"
	})

	form:MakeComboBox({
		label = "label_damage_indicator_mode",
		convar = "ttt_dmgindicator_mode",
		choices = DMGINDICATOR.GetThemeNames(),
		master = dmgEnb
	})

	form:MakeSlider({
		label = "label_damage_indicator_duration",
		convar = "ttt_dmgindicator_duration",
		min = 0,
		max = 30,
		decimal = 2,
		master = dmgEnb
	})

	form:MakeSlider({
		label = "label_damage_indicator_maxdamage",
		convar = "ttt_dmgindicator_maxdamage",
		min = 0,
		max = 100,
		decimal = 1,
		master = dmgEnb
	})

	form:MakeSlider({
		label = "label_damage_indicator_maxalpha",
		convar = "ttt_dmgindicator_maxalpha",
		min = 0,
		max = 255,
		decimal = 0,
		master = dmgEnb
	})
end

local function PopulatePerformancePanel(parent)
	local form = CreateTTT2Form(parent, "header_performance_settings")

	form:MakeCheckBox({
		label = "label_performance_halo_enable",
		convar = "ttt_entity_draw_halo"
	})

	form:MakeCheckBox({
		label = "label_performance_spec_outline_enable",
		convar = "ttt2_enable_spectatorsoutline"
	})

	form:MakeCheckBox({
		label = "label_performance_ohicon_enable",
		convar = "ttt2_enable_overheadicons"
	})
end

local function PopulateInterfacePanel(parent)
	local form = CreateTTT2Form(parent, "header_interface_settings")

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

HELPSCRN.populate["ttt2_appearance"] = function(helpData, id)
	local bindingsData = helpData:RegisterSubMenu(id)

	bindingsData:SetTitle("menu_appearance_title")
	bindingsData:SetDescription("menu_appearance_description")
	bindingsData:SetIcon(materialIcon)
end

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
		local currentHUDName = HUDManager.GetHUD()
		local currentHUD = huds.GetStored(currentHUDName)

		local buttonReset = vgui.Create("DButtonTTT2", parent)

		buttonReset:SetText("button_reset")
		buttonReset:SetSize(100, 45)
		buttonReset:SetPos(475, 20)
		buttonReset.DoClick = function(btn)
			if not currentHUD then return end

			currentHUD:Reset()
			currentHUD:SaveData()
		end
		buttonReset:SetEnabled(not currentHUD.disableHUDEditor)

		local buttonEditor = vgui.Create("DButtonTTT2", parent)

		buttonEditor:SetText("button_hud_editor")
		buttonEditor:SetSize(175, 45)
		buttonEditor:SetPos(600, 20)
		buttonEditor.DoClick = function(btn)
			if not currentHUDName then return end

			HUDEditor.EditHUD(currentHUDName)

			HELPSCRN.menuFrame:HideFrame()
		end
		buttonEditor:SetEnabled(not currentHUD.disableHUDEditor)
	end)

	-- vskin
	local vskinData = helpData:PopulateSubMenu(id .. "_vskin")

	vskinData:SetTitle("submenu_appearance_vskin_title")
	vskinData:PopulatePanel(PopulateVSkinPanel)

	-- targetID
	local targetData = helpData:PopulateSubMenu(id .. "_target_id")

	targetData:SetTitle("submenu_appearance_targetid_title")
	targetData:PopulatePanel(PopulateTargetIDPanel)

	-- equipment shop
	local shopData = helpData:PopulateSubMenu(id .. "_shop")

	shopData:SetTitle("submenu_appearance_shop_title")
	shopData:PopulatePanel(PopulateShopPanel)

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
