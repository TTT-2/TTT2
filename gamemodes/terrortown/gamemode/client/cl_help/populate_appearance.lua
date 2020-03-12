local materialIcon = Material("vgui/ttt/derma/helpscreen/appearance")

local function PopulateHUDSwitcherPanel(parent)
	local form = vgui.Create("DFormTTT2", parent)
	form:SetName("set_title_hud_select")

	local currentHUDName = HUDManager.GetHUD()
	local huds = huds.GetList()
	local restrictedHUDs = HUDManager.GetModelValue("restrictedHUDs")

	local combobox = form:ComboBox("select_hud")

	for i = 1, #huds do
		local hud = huds[i]

		-- do not add HUD to the selection list if restricted
		if table.HasValue(restrictedHUDs, hud.id) then continue end

		combobox:AddChoice(hud.id)

		if hud.id == currentHUDName then
			combobox:ChooseOption(hud.id, i)
		end
	end

	combobox.OnSelect = function(self, index, value)
		HUDManager.SetHUD(value)
	end

	form:Dock(TOP)

	local form2 = vgui.Create("DFormTTT2", parent)
	form2:SetName("set_title_hud_customize")

	form2:Dock(TOP)

	-- REGISTER UNHIDE FUNCTION TO STOP HUD EDITOR
	VHDL.RegisterCallback("unhide", function(menu)
		print("unhiding")

		HUDEditor.StopEditHUD()
	end)
end

local function PopulateVSkinPanel(parent)
	local form = vgui.Create("DFormTTT2", parent)
	form:SetName("set_title_vskin")

	local vskins = VSKIN.GetVSkinList()
	local combobox = form:ComboBox("select_vskin")

	for i = 1, #vskins do
		local vskin = vskins[i]

		combobox:AddChoice(vskin)

		if vskin == VSKIN.GetVSkinName() then
			combobox:ChooseOption(vskin, i)
		end
	end

	combobox.OnSelect = function(self, index, value)
		VSKIN.SelectVSkin(value)
	end

	local cb = form:CheckBox("set_blur_enable")
	cb:SetValue(VSKIN.ShouldBlurBackground())

	cb.OnChange = function(self, value)
		VSKIN.SetBlurBackground(value)
	end

	form:Dock(TOP)
end

local function PopulateCrosshairPanel(parent)
	local form = vgui.Create("DFormTTT2", parent)
	form:SetName("set_title_cross")

	form:CheckBox("set_cross_color_enable", "ttt_crosshair_color_enable")

	local cm = vgui.Create("DColorMixer")
	cm:SetLabel("set_cross_color")
	cm:SetTall(120)
	cm:SetAlphaBar(false)
	cm:SetPalette(false)
	cm:SetColor(Color(30, 160, 160, 255))
	cm:SetConVarR("ttt_crosshair_color_r")
	cm:SetConVarG("ttt_crosshair_color_g")
	cm:SetConVarB("ttt_crosshair_color_b")

	form:AddItem(cm)

	form:CheckBox("set_cross_gap_enable", "ttt_crosshair_gap_enable")

	local cb = form:NumSlider("set_cross_gap", "ttt_crosshair_gap", 0, 30, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider("set_cross_opacity", "ttt_crosshair_opacity", 0, 1, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider("set_ironsight_cross_opacity", "ttt_ironsights_crosshair_opacity", 0, 1, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider("set_cross_brightness", "ttt_crosshair_brightness", 0, 1, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider("set_cross_size", "ttt_crosshair_size", 0.1, 3, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider("set_cross_thickness", "ttt_crosshair_thickness", 1, 10, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider("set_cross_outlinethickness", "ttt_crosshair_outlinethickness", 0, 5, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	form:CheckBox("set_cross_disable", "ttt_disable_crosshair")
	form:CheckBox("set_minimal_id", "ttt_minimal_targetid")
	form:CheckBox("set_cross_static_enable", "ttt_crosshair_static")
	form:CheckBox("set_cross_dot_enable", "ttt_crosshair_dot")
	form:CheckBox("set_cross_weaponscale_enable", "ttt_crosshair_weaponscale")

	cb = form:CheckBox("set_lowsights", "ttt_ironsights_lowered")
	cb:SetTooltip("set_lowsights_tip")

	form:Dock(TOP)
end

local function PopulateDamagePanel(parent)
	local form = vgui.Create("DFormTTT2", parent)
	form:SetName("f1_dmgindicator_title")

	form:CheckBox("f1_dmgindicator_enable", "ttt_dmgindicator_enable")

	local dmode = vgui.Create("DComboBox", form)
	dmode:SetConVar("ttt_dmgindicator_mode")

	for name in pairs(DMGINDICATOR.themes) do
		dmode:AddChoice(name)
	end

	-- Why is DComboBox not updating the cvar by default?
	dmode.OnSelect = function(idx, val, data)
		RunConsoleCommand("ttt_dmgindicator_mode", data)
	end

	form:Help("f1_dmgindicator_mode")
	form:AddItem(dmode)

	local cb = form:NumSlider("f1_dmgindicator_duration", "ttt_dmgindicator_duration", 0, 30, 2)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider("f1_dmgindicator_maxdamage", "ttt_dmgindicator_maxdamage", 0, 100, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider("f1_dmgindicator_maxalpha", "ttt_dmgindicator_maxalpha", 0, 255, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	form:Dock(TOP)
end

local function PopulatePerformancePanel(parent)
	local form = vgui.Create("DFormTTT2", parent)
	form:SetName("set_title_gui")
	form:CheckBox("set_tips", "ttt_tips_enable")

	local cb

	cb = form:CheckBox("entity_draw_halo", "ttt_entity_draw_halo")

	cb = form:CheckBox("disable_spectatorsoutline", "ttt2_disable_spectatorsoutline")
	cb:SetTooltip("disable_spectatorsoutline_tip")

	cb = form:CheckBox("disable_overheadicons", "ttt2_disable_overheadicons")
	cb:SetTooltip("disable_overheadicons_tip")

	form:Dock(TOP)
end

local function PopulateInterfacePanel(parent)
	local form = vgui.Create("DFormTTT2", parent)
	form:SetName("set_title_gui")
	form:CheckBox("set_tips", "ttt_tips_enable")

	local cb

	cb = form:NumSlider("set_startpopup", "ttt_startpopup_duration", 0, 60, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb:SetTooltip("set_startpopup_tip")

	form:CheckBox("set_healthlabel", "ttt_health_label")

	cb = form:CheckBox("set_fastsw_menu", "ttt_weaponswitcher_displayfast")
	cb:SetTooltip("set_fastswmenu_tip")

	cb = form:CheckBox("set_wswitch", "ttt_weaponswitcher_stay")
	cb:SetTooltip("set_wswitch_tip")

	cb = form:CheckBox("set_cues", "ttt_cl_soundcues")

	form:Dock(TOP)
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
