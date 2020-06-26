---
-- @class HELPSCRN
-- @desc Help screen

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation
local pairs = pairs
local ipairs = ipairs
local IsValid = IsValid
local ConVarExists = ConVarExists
local CreateConVar = CreateConVar
local surface = surface

ttt_include("vgui__cl_f1settings_button")

surface.CreateFont("SettingsButtonFont", {font = "Trebuchet24", size = 24, weight = 1000})

CreateConVar("ttt_spectator_mode", "0", FCVAR_ARCHIVE)
CreateConVar("ttt_mute_team_check", "0")

HELPSCRN = {}

local helpframe

local function AddBindingCategory(category, parent)
	local form = vgui.Create("DForm", parent)

	form:SetName(LANG.TryTranslation(category))

	for _, binding in ipairs(bind.GetSettingsBindings()) do
		if binding.category == category then
			-- creating two grids:
			-- GRID: tooltip, bindingbutton and extra button area
			-- GRIDEXTRA: inside the last GRID box, houses default and disable buttons
			local dPGrid = vgui.Create("DGrid")
			dPGrid:SetCols(3)
			dPGrid:SetColWide(120)

			local dPGridExtra = vgui.Create("DGrid")
			dPGridExtra:SetCols(2)
			dPGridExtra:SetColWide(60)

			form:AddItem(dPGrid)

			-- Keybind Label
			local dPlabel = vgui.Create("DLabel")
			dPlabel:SetText(LANG.TryTranslation(binding.label) .. ":")
			dPlabel:SetTextColor(COLOR_BLACK)
			dPlabel:SetContentAlignment(4)
			dPlabel:SetSize(120, 25)

			dPGrid:AddItem(dPlabel)


			-- Keybind Button
			local dPBinder = vgui.Create("DBinder")
			dPBinder:SetSize(100, 25)

			local curBinding = bind.Find(binding.name)
			dPBinder:SetValue(curBinding)
			dPBinder:SetTooltip(GetTranslation("f1_bind_description"))

			dPGrid:AddItem(dPBinder)
			dPGrid:AddItem(dPGridExtra)

			-- DEFAULT Button
			local dPBindResetButton = vgui.Create("DButton")
			dPBindResetButton:SetText(GetTranslation("f1_bind_reset_default"))
			dPBindResetButton:SetSize(55, 25)
			dPBindResetButton:SetTooltip(GetTranslation("f1_bind_reset_default_description"))

			if binding.defaultKey ~= nil then
				dPBindResetButton.DoClick = function()
					bind.Set(binding.defaultKey, binding.name, true)
					dPBinder:SetValue(bind.Find(binding.name))
				end
			else
				dPBindResetButton:SetDisabled(true)
			end
			dPGridExtra:AddItem(dPBindResetButton)

			-- DISABLE Button
			local dPBindDisableButton = vgui.Create("DButton")
			dPBindDisableButton:SetText(GetTranslation("f1_bind_disable_bind"))
			dPBindDisableButton:SetSize(55, 25)
			dPBindDisableButton:SetTooltip(GetTranslation("f1_bind_disable_description"))

			dPBindDisableButton.DoClick = function()
				bind.Remove(curBinding, binding.name, true)
				dPBinder:SetValue(bind.Find(binding.name))
			end

			dPGridExtra:AddItem(dPBindDisableButton)

			-- onchange function
			function dPBinder:OnChange(num)
				bind.Remove(curBinding, binding.name, true)

				if num ~= 0 then
					bind.Add(num, binding.name, true)
				end

				LocalPlayer():ChatPrint(GetPTranslation("ttt2_bindings_new", {name = binding.name, key = input.GetKeyName(num) or "NONE"}))

				curBinding = num
			end
		end
	end

	form:Dock(TOP)
end

function HELPSCRN.IsOpen()
	return IsValid(helpframe) or IsValid(LocalPlayer().settingsFrame)
end

---
-- Opens the help screen
-- @realm client
function HELPSCRN:Show()
	if IsValid(helpframe) then
		helpframe:Close()

		return
	end

	local client = LocalPlayer()
	client.hudswitcherSettingsF1 = nil

	if client.settingsFrame and IsValid(client.settingsFrame) then
		client.settingsFrameForceClose = true

		client.settingsFrame:Close()
	end

	client.settingsFrameForceClose = nil

	local margin = 15
	local minWidth, minHeight = 630, 470
	local w, h = math.max(minWidth, math.Round(ScrW() * 0.6)), math.max(minHeight, math.Round(ScrH() * 0.8))

	local dframe = vgui.Create("DFrame")
	dframe:SetSize(w, h)
	dframe:Center()
	dframe:SetTitle(GetTranslation("help_title"))
	dframe:SetVisible(true)
	dframe:ShowCloseButton(true)
	dframe:SetMouseInputEnabled(true)
	dframe:SetDeleteOnClose(true)

	local bw, bh = 50, 25

	local dbut = vgui.Create("DButton", dframe)
	dbut:SetSize(bw, bh)
	dbut:SetPos(w - bw - margin, h - bh - margin * 0.5)
	dbut:SetText(GetTranslation("close"))

	dbut.DoClick = function()
		dframe:Close()
	end

	local w2, h2 = w - margin * 2, h - margin * 3 - bh

	local dtabs = vgui.Create("DPropertySheet", dframe)
	dtabs:SetPos(margin, margin * 2)
	dtabs:SetSize(w2, h2)

	-- now fill with content

	local padding = (dtabs:GetPadding()) * 2

	-- TTT Settings
	local pad = 10

	local scrollPanel = vgui.Create("DScrollPanel", dtabs)
	scrollPanel:StretchToParent(0, 0, padding, 0)

	dtabs:AddSheet(GetTranslation("help_settings"), scrollPanel, "icon16/wrench.png", false, false, GetTranslation("help_settings_tip"))

	local dsettings = vgui.Create("DIconLayout", scrollPanel)
	dsettings:Dock(FILL)
	dsettings:SetSpaceX(pad)
	dsettings:SetSpaceY(pad)

	local cols = 4
	local btnWidth = math.Round((w2 - pad * (cols + 1)) / cols)
	local btnHeight = btnWidth * 0.75
	local settings_panel_default_bgcol = Color(160, 160, 160, 255)

	local tbl = {
		[1] = {
			id = "changes",
			onclick = function(slf)
				local frm = ShowChanges()

				if not frm then return end

				local oldClose = frm.OnClose

				frm.OnClose = function(slf2)
					if isfunction(oldClose) then
						oldClose(slf2)
					end

					if not client.settingsFrameForceClose then
						self:Show()
					end
				end

				client.settingsFrame = frm
			end,
			getTitle = function()
				return GetTranslation("f1_settings_changes_title")
			end
		},
		[2] = {
			id = "hudSwitcher",
			onclick = function(slf)
				client.hudswitcherSettingsF1 = true
				HUDManager.ShowHUDSwitcher()
			end,
			getTitle = function()
				return GetTranslation("f1_settings_hudswitcher_title")
			end
		},
		[3] = {
			id = "bindings",
			getContent = self.CreateBindings,
			getTitle = function()
				return GetTranslation("f1_settings_bindings_title")
			end
		},
		[4] = {
			id = "interface",
			getContent = self.CreateInterfaceSettings,
			getTitle = function()
				return GetTranslation("f1_settings_interface_title")
			end
		},
		[5] = {
			id = "gameplay",
			getContent = self.CreateGameplaySettings,
			getTitle = function()
				return GetTranslation("f1_settings_gameplay_title")
			end
		},
		[6] = {
			id = "crosshair",
			getContent = self.CreateCrosshairSettings,
			getTitle = function()
				return GetTranslation("f1_settings_crosshair_title")
			end
		},
		[7] = {
			id = "damageIndicator",
			getContent = self.CreateDamageIndicatorSettings,
			getTitle = function()
				return GetTranslation("f1_settings_dmgindicator_title")
			end
		},
		[8] = {
			id = "language",
			getContent = self.CreateLanguageForm,
			getTitle = function()
				return GetTranslation("f1_settings_language_title")
			end
		},
		[9] = {
			id = "administration",
			getContent = self.CreateAdministrationForm,
			shouldShow = function()
				return LocalPlayer():IsAdmin()
			end,
			getTitle = function()
				return GetTranslation("f1_settings_administration_title")
			end
		}
	}

	hook.Run("TTT2ModifySettingsList", tbl)

	for _, data in ipairs(tbl) do
		if isfunction(data.shouldShow) and not data.shouldShow() then continue end

		local title = string.upper(isfunction(data.getTitle) and data.getTitle() or data.id)

		local settingsButton = dsettings:Add("DF1SettingsButton")
		settingsButton:SetSize(btnWidth, btnHeight)
		settingsButton:SetFont("SettingsButtonFont")
		settingsButton:SetText(title)
		settingsButton:SetTextColor(COLOR_BLACK)

		settingsButton.DoClick = function(slf)
			dframe:Close()

			if isfunction(data.onclick) then
				data.onclick(slf)

				return
			end

			local frame = vgui.Create("DFrame")
			frame:SetSize(minWidth, minHeight)
			frame:Center()
			frame:SetTitle(title)
			frame:SetVisible(true)
			frame:ShowCloseButton(true)
			frame:SetMouseInputEnabled(true)
			frame:SetDeleteOnClose(true)

			frame.OnClose = function(frm)
				if not client.settingsFrameForceClose then
					self:Show()
				end
			end

			local pnl = vgui.Create("DScrollPanel", frame)
			pnl:SetVerticalScrollbarEnabled(true)
			pnl:Dock(FILL)
			pnl:SetPaintBackground(true)
			pnl:SetBackgroundColor(settings_panel_default_bgcol)

			if isfunction(data.getContent) then
				data.getContent(self, pnl)
			end

			--
			frame:MakePopup()
			frame:SetKeyboardInputEnabled(false)

			client.settingsFrame = frame
		end
	end

	-- Tutorial
	local tutparent = vgui.Create("DPanel", dtabs)
	tutparent:SetPaintBackground(false)
	tutparent:StretchToParent(margin, 0, 0, 0)

	self:CreateTutorial(tutparent)

	dtabs:AddSheet(GetTranslation("help_tut"), tutparent, "icon16/book_open.png", false, false, GetTranslation("help_tut_tip"))

	-- extern support
	hook.Call("TTTSettingsTabs", GAMEMODE, dtabs)

	--
	dframe:MakePopup()
	dframe:SetKeyboardInputEnabled(false)

	helpframe = dframe
end

local function ShowTTTHelp(ply, cmd, args)
	HELPSCRN:Show()
end
concommand.Add("ttt_helpscreen", ShowTTTHelp)

-- Some spectator mode bookkeeping

local function SpectateCallback(cv, old, new)
	local num = tonumber(new)

	if num and (num == 0 or num == 1) then
		RunConsoleCommand("ttt_spectate", num)
	end
end
cvars.AddChangeCallback("ttt_spectator_mode", SpectateCallback)

local function MuteTeamCallback(cv, old, new)
	net.Start("TTT2MuteTeam")
	net.WriteBool(tobool(new))
	net.SendToServer()
end
cvars.AddChangeCallback("ttt_mute_team_check", MuteTeamCallback)

---
-- Creates the settings for the help screen
-- @param Panel parent
-- @realm client
-- @internal
function HELPSCRN:CreateInterfaceSettings(parent)
	local form = vgui.Create("DForm", parent)
	form:SetName(GetTranslation("set_title_gui"))
	form:CheckBox(GetTranslation("set_tips"), "ttt_tips_enable")

	local cb = form:NumSlider(GetTranslation("set_startpopup"), "ttt_startpopup_duration", 0, 60, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb:SetTooltip(GetTranslation("set_startpopup_tip"))

	form:CheckBox(GetTranslation("set_healthlabel"), "ttt_health_label")

	cb = form:CheckBox(GetTranslation("set_fastsw_menu"), "ttt_weaponswitcher_displayfast")
	cb:SetTooltip(GetTranslation("set_fastswmenu_tip"))

	cb = form:CheckBox(GetTranslation("set_wswitch"), "ttt_weaponswitcher_stay")
	cb:SetTooltip(GetTranslation("set_wswitch_tip"))

	cb = form:CheckBox(GetTranslation("set_cues"), "ttt_cl_soundcues")

	cb = form:CheckBox(GetTranslation("entity_draw_halo"), "ttt_entity_draw_halo")

	cb = form:CheckBox(GetTranslation("disable_spectatorsoutline"), "ttt2_disable_spectatorsoutline")
	cb:SetTooltip(GetTranslation("disable_spectatorsoutline_tip"))

	cb = form:CheckBox(GetTranslation("disable_overheadicons"), "ttt2_disable_overheadicons")
	cb:SetTooltip(GetTranslation("disable_overheadicons_tip"))

	form:Dock(FILL)
end

---
-- Creates the language form for the help screen
-- @param Panel parent
-- @realm client
-- @internal
function HELPSCRN:CreateLanguageForm(parent)
	local form = vgui.Create("DForm", parent)
	form:SetName(GetTranslation("set_title_lang"))

	local dlang = vgui.Create("DComboBox", form)
	dlang:SetConVar("ttt_language")
	dlang:AddChoice("Server default", "auto")

	for _, lang in pairs(LANG.GetLanguages()) do
		dlang:AddChoice(string.Capitalize(lang), lang)
	end

	-- Why is DComboBox not updating the cvar by default?
	dlang.OnSelect = function(idx, val, data)
		RunConsoleCommand("ttt_language", data)
	end

	dlang.Think = dlang.ConVarStringThink

	form:Help(GetTranslation("set_lang"))
	form:AddItem(dlang)

	form:Dock(FILL)
end

---
-- Creates the crosshair settings for the help screen
-- @param Panel parent
-- @realm client
-- @internal
function HELPSCRN:CreateCrosshairSettings(parent)
	local form = vgui.Create("DForm", parent)
	form:SetName(GetTranslation("set_title_cross"))

	form:CheckBox(GetTranslation("set_cross_color_enable"), "ttt_crosshair_color_enable")

	local cm = vgui.Create("DColorMixer")
	cm:SetLabel(GetTranslation("set_cross_color"))
	cm:SetTall(120)
	cm:SetAlphaBar(false)
	cm:SetPalette(false)
	cm:SetColor(Color(30, 160, 160, 255))
	cm:SetConVarR("ttt_crosshair_color_r")
	cm:SetConVarG("ttt_crosshair_color_g")
	cm:SetConVarB("ttt_crosshair_color_b")

	form:AddItem(cm)

	form:CheckBox(GetTranslation("set_cross_gap_enable"), "ttt_crosshair_gap_enable")

	local cb = form:NumSlider(GetTranslation("set_cross_gap"), "ttt_crosshair_gap", 0, 30, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider(GetTranslation("set_cross_opacity"), "ttt_crosshair_opacity", 0, 1, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider(GetTranslation("set_ironsight_cross_opacity"), "ttt_ironsights_crosshair_opacity", 0, 1, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider(GetTranslation("set_cross_brightness"), "ttt_crosshair_brightness", 0, 1, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider(GetTranslation("set_cross_size"), "ttt_crosshair_size", 0.1, 3, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider(GetTranslation("set_cross_thickness"), "ttt_crosshair_thickness", 1, 10, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider(GetTranslation("set_cross_outlinethickness"), "ttt_crosshair_outlinethickness", 0, 5, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	form:CheckBox(GetTranslation("set_cross_disable"), "ttt_disable_crosshair")
	form:CheckBox(GetTranslation("set_minimal_id"), "ttt_minimal_targetid")
	form:CheckBox(GetTranslation("set_cross_static_enable"), "ttt_crosshair_static")
	form:CheckBox(GetTranslation("set_cross_dot_enable"), "ttt_crosshair_dot")
	form:CheckBox(GetTranslation("set_cross_lines_enable"), "ttt_crosshair_lines")
	form:CheckBox(GetTranslation("set_cross_weaponscale_enable"), "ttt_crosshair_weaponscale")

	cb = form:CheckBox(GetTranslation("set_lowsights"), "ttt_ironsights_lowered")
	cb:SetTooltip(GetTranslation("set_lowsights_tip"))

	form:Dock(FILL)
end

---
-- Creates the damage indicator settings for the help screen
-- @param Panel parent
-- @realm client
-- @internal
function HELPSCRN:CreateDamageIndicatorSettings(parent)
	local form = vgui.Create("DForm", parent)
	form:SetName(GetTranslation("f1_dmgindicator_title"))

	form:CheckBox(GetTranslation("f1_dmgindicator_enable"), "ttt_dmgindicator_enable")

	local dmode = vgui.Create("DComboBox", form)
	dmode:SetConVar("ttt_dmgindicator_mode")

	for name in pairs(DMGINDICATOR.themes) do
		dmode:AddChoice(name)
	end

	-- Why is DComboBox not updating the cvar by default?
	dmode.OnSelect = function(idx, val, data)
		RunConsoleCommand("ttt_dmgindicator_mode", data)
	end

	form:Help(GetTranslation("f1_dmgindicator_mode"))
	form:AddItem(dmode)

	local cb = form:NumSlider(GetTranslation("f1_dmgindicator_duration"), "ttt_dmgindicator_duration", 0, 30, 2)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider(GetTranslation("f1_dmgindicator_maxdamage"), "ttt_dmgindicator_maxdamage", 0, 100, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = form:NumSlider(GetTranslation("f1_dmgindicator_maxalpha"), "ttt_dmgindicator_maxalpha", 0, 255, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	form:Dock(FILL)
end

---
-- Creates the gameplay settings for the help screen
-- @param Panel parent
-- @realm client
-- @internal
function HELPSCRN:CreateGameplaySettings(parent)
	local form = vgui.Create("DForm", parent)
	form:SetName(GetTranslation("set_title_play"))

	local cb
	local rlsList = roles.GetList()

	for i = 1, #rlsList do
		local v = rlsList[i]

		if ConVarExists("ttt_avoid_" .. v.name) then
			local rolename = GetTranslation(v.name)

			cb = form:CheckBox(GetPTranslation("set_avoid", rolename), "ttt_avoid_" .. v.name)
			cb:SetTooltip(GetPTranslation("set_avoid_tip", rolename))
		end
	end

	cb = form:CheckBox(GetTranslation("set_specmode"), "ttt_spectator_mode")
	cb:SetTooltip(GetTranslation("set_specmode_tip"))

	cb = form:CheckBox(GetTranslation("set_fastsw"), "ttt_weaponswitcher_fast")
	cb:SetTooltip(GetTranslation("set_fastsw_tip"))

	cb = form:CheckBox(GetTranslation("hold_aim"), "ttt2_hold_aim")
	cb:SetTooltip(GetTranslation("hold_aim_tip"))

	cb = form:CheckBox(GetTranslation("doubletap_sprint_anykey"), "ttt2_doubletap_sprint_anykey")
	cb:SetTooltip(GetTranslation("doubletap_sprint_anykey_tip"))

	cb = form:CheckBox(GetTranslation("disable_doubletap_sprint"), "ttt2_disable_doubletap_sprint")
	cb:SetTooltip(GetTranslation("disable_doubletap_sprint_tip"))

	-- TODO what is the following reason?
	-- For some reason this one defaulted to on, unlike other checkboxes, so
	-- force it to the actual value of the cvar (which defaults to off)
	local mute = form:CheckBox(GetTranslation("set_mute"), "ttt_mute_team_check")
	mute:SetValue(GetConVar("ttt_mute_team_check"):GetBool())
	mute:SetTooltip(GetTranslation("set_mute_tip"))

	form:Dock(FILL)
end

---
-- Creates the bindings menu for the help screen
-- @param Panel parent
-- @realm client
-- @internal
function HELPSCRN:CreateBindings(parent)
	AddBindingCategory("TTT2 Bindings", parent)

	for k, category in ipairs(bind.GetSettingsBindingsCategories()) do
		if k > 2 then
			AddBindingCategory(category, parent)
		end
	end

	AddBindingCategory("Other Bindings", parent)
end

-- Administration
-- save the restricted huds list view here to adjust its content in the update listener
local admin_dlv_rhuds = nil

---
-- creates the administration form for the help screen
-- @param Panel parent
-- @realm client
-- @internal
function HELPSCRN:CreateAdministrationForm(parent)
	local defaultHUDlabel = vgui.Create("DLabel", parent)
	defaultHUDlabel:SetText(GetTranslation("hud_default") .. ":")
	defaultHUDlabel:Dock(TOP)

	local defaultHUDCb = vgui.Create("DComboBox", parent)
	defaultHUDCb:SetValue(ttt2net.GetGlobal({"hud_manager", "defaultHUD"}) or "None")

	defaultHUDCb.OnSelect = function(_, _, value)
		net.Start("TTT2DefaultHUDRequest")
		net.WriteString(value == "None" and "" or value)
		net.SendToServer()
	end

	for _, v in ipairs(huds.GetList()) do
		defaultHUDCb:AddChoice(v.id)
	end

	defaultHUDCb:Dock(TOP)

	local forceHUDlabel = vgui.Create("DLabel", parent)
	forceHUDlabel:SetText(GetTranslation("hud_force") .. ":")
	forceHUDlabel:Dock(TOP)

	local forceHUDCb = vgui.Create("DComboBox", parent)
	forceHUDCb:SetValue(ttt2net.GetGlobal({"hud_manager", "forcedHUD"}) or "None")

	forceHUDCb.OnSelect = function(_, _, value)
		net.Start("TTT2ForceHUDRequest")
		net.WriteString(value == "None" and "" or value)
		net.SendToServer()
	end

	forceHUDCb:AddChoice("None")

	for _, v in ipairs(huds.GetList()) do
		forceHUDCb:AddChoice(v.id)
	end

	forceHUDCb:Dock(TOP)

	local restrictHUDlabel = vgui.Create("DLabel", parent)
	restrictHUDlabel:SetText(GetTranslation("hud_restricted") .. ":")
	restrictHUDlabel:Dock(TOP)

	admin_dlv_rhuds = vgui.Create("DListView", parent)
	admin_dlv_rhuds:SetHeight(100)
	admin_dlv_rhuds:SetMultiSelect(false)
	admin_dlv_rhuds:AddColumn("HUD")
	admin_dlv_rhuds:AddColumn("Restricted")

	local restrictedHUDs = ttt2net.GetGlobal({"hud_manager", "restrictedHUDs"})
	local allHUDs = huds.GetList()

	for _, v in ipairs(allHUDs) do
		admin_dlv_rhuds:AddLine(v.id, table.HasValue(restrictedHUDs, v.id) and "true" or "false")
	end

	admin_dlv_rhuds:Dock(TOP)

	function admin_dlv_rhuds:DoDoubleClick(lineID, line)
		net.Start("TTT2RestrictHUDRequest")
		net.WriteString(line:GetColumnText(1))
		net.WriteBool(not tobool(line:GetColumnText(2)))
		net.SendToServer()
	end
end

ttt2net.OnUpdateGlobal({"hud_manager", "restrictedHUDs"}, function(_, value)
	if not admin_dlv_rhuds or not IsValid(admin_dlv_rhuds) then return end

	admin_dlv_rhuds:Clear()

	local a = huds.GetList()

	for _, v in ipairs(a) do
		admin_dlv_rhuds:AddLine(v.id, table.HasValue(value, v.id) and "true" or "false")
	end
end)

net.Receive("TTT2RestrictHUDResponse", function()
	local accepted = net.ReadBool()
	local hudname = net.ReadString()

	local client = LocalPlayer()
	if not IsValid(client) then return end

	if not accepted then
		client:ChatPrint("[TTT2][HUDManager] " .. GetPTranslation("hud_restricted_failed", {hudname = hudname}))

		return
	end
end)

net.Receive("TTT2ForceHUDResponse", function()
	local accepted = net.ReadBool()
	local hudname = net.ReadString()

	local client = LocalPlayer()
	if not IsValid(client) then return end

	if not accepted then
		client:ChatPrint("[TTT2][HUDManager] " .. GetPTranslation("hud_forced_failed", {hudname = hudname}))

		return
	end
end)

net.Receive("TTT2DefaultHUDResponse", function()
	local accepted = net.ReadBool()
	local hudname = net.ReadString()

	local client = LocalPlayer()
	if not IsValid(client) then return end

	if not accepted then
		client:ChatPrint("[TTT2][HUDManager] " .. GetPTranslation("hud_default_failed", {hudname = hudname}))

		return
	end
end)

-- Tutorial

local imgpath = "vgui/ttt/help/tut0%d"
local tutorial_pages = 6

---
-- Creates the tutorial for the help screen
-- @param Panel parent
-- @realm client
-- @todo update tutorial
-- @internal
function HELPSCRN:CreateTutorial(parent)
	--local w, h = parent:GetSize()
	--local m = 5

	local bg = vgui.Create("ColoredBox", parent)
	bg:StretchToParent(0, 0, 0, 0)
	bg:SetTall(330)
	bg:SetColor(COLOR_BLACK)

	local tut = vgui.Create("DImage", parent)
	tut:StretchToParent(0, 0, 0, 0)
	tut:SetVerticalScrollbarEnabled(false)
	tut:SetImage(Format(imgpath, 1))
	tut:SetWide(1024)
	tut:SetTall(512)

	tut.current = 1

	local bw, bh = 100, 30

	local bar = vgui.Create("TTTProgressBar", parent)
	bar:SetSize(200, bh)
	bar:MoveBelow(bg)
	bar:CenterHorizontal()
	bar:SetMin(1)
	bar:SetMax(tutorial_pages)
	bar:SetValue(1)
	bar:SetColor(Color(0, 200, 0))

	-- fixing your panels...
	bar.UpdateText = function(s)
		s.Label:SetText(Format("%i / %i", s.m_iValue, s.m_iMax))
	end

	bar:UpdateText()

	local bnext = vgui.Create("DButton", parent)
	bnext:SetFont("Trebuchet22")
	bnext:SetSize(bw, bh)
	bnext:SetText(GetTranslation("next"))
	bnext:CopyPos(bar)
	bnext:AlignRight(1)

	local bprev = vgui.Create("DButton", parent)
	bprev:SetFont("Trebuchet22")
	bprev:SetSize(bw, bh)
	bprev:SetText(GetTranslation("prev"))
	bprev:CopyPos(bar)
	bprev:AlignLeft()

	bnext.DoClick = function()
		if tut.current < tutorial_pages then
			tut.current = tut.current + 1

			tut:SetImage(Format(imgpath, tut.current))
			bar:SetValue(tut.current)
		end
	end

	bprev.DoClick = function()
		if tut.current > 1 then
			tut.current = tut.current - 1

			tut:SetImage(Format(imgpath, tut.current))
			bar:SetValue(tut.current)
		end
	end
end
