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

	bindingsData:SetTitle("f1_settings_appearance_title")
	bindingsData:SetDescription("Some cool text will be here...")
	bindingsData:SetIcon(Material("vgui/ttt/dynamic/roles/icon_inno"))
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

	generalData:SetTitle("ttt2_general")

	-- HUD editor
	local hudData = helpData:PopulateSubMenu(id .. "_hud_editor")

	hudData:SetTitle("ttt2_hud_editor")
	hudData:PopulateButtonPanel(function(parent)

	end)

	--local currentHUD = HUDManager.GetHUD()
	--local hudLists = huds.GetList()
	--local restrictedHUDs = HUDManager.GetModelValue("restrictedHUDs")

	-- VSKIN
	local vskinData = helpData:PopulateSubMenu(id .. "_vskin")

	vskinData:SetTitle("ttt2_vskin")

	-- targetID
	local targetData = helpData:PopulateSubMenu(id .. "_target_id")

	targetData:SetTitle("ttt2_target_id")

	-- crosshair
	local crosshairData = helpData:PopulateSubMenu(id .. "_crosshair")

	crosshairData:SetTitle("ttt2_crosshair")
	crosshairData:PopulatePanel(PopulateCrosshairPanel)

	-- damage indicator
	local damageData = helpData:PopulateSubMenu(id .. "_damage_indicator")

	damageData:SetTitle("ttt2_damage_indicator")
	damageData:PopulatePanel(PopulateDamagePanel)

	-- performance
	local performanceData = helpData:PopulateSubMenu(id .. "_performance")

	performanceData:SetTitle("ttt2_performance")
	performanceData:PopulatePanel(PopulatePerformancePanel)

	-- interface
	local interfaceData = helpData:PopulateSubMenu(id .. "_interface")

	interfaceData:SetTitle("ttt2_interface")
	interfaceData:PopulatePanel(PopulateInterfacePanel)

	-- miscellaneous
	local miscellaneousData = helpData:PopulateSubMenu(id .. "_miscellaneous")

	miscellaneousData:SetTitle("ttt2_miscellaneous")
end
