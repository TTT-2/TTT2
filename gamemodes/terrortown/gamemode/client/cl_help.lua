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

-- store the helpscreen in here to allow toggling with key
local menuCache = {
	mainMenu,
	subMenu
}

-- DEFINE SIZE
local w, h = 1100, 700
local pad = 5
local cols = 3
local widthMainButton = math.Round((w - 2 * pad * (cols + 1)) / cols)
local heightMainButton = 120

local widthNav, heightNav = 300, 700
local widthNavHeader, heightNavHeader = 299, 80
local widthNavContent, heightNavContent = 299, 620
local widthContent, heightContent = 800, 700
local widthButtonPnl, heightButtonPanel = 800, 80
local widthNavButton, heightNavButton = 299, 50

HELPSCRN = {}

function HELPSCRN.IsOpen()
	return IsValid(menuCache.mainMenu) or IsValid(LocalPlayer().settingsFrame)
end

-- TODO set pos based on last pos!
---
-- Opens the help screen
-- @realm client
function HELPSCRN:Show(x, y)
	-- F1 PRESSED: CLOSE MAIN MENU IF MENU IS ALREADY OPENED
	if IsValid(menuCache.mainMenu) then
		menuCache.mainMenu:Close()

		return
	end

	-- F1 PRESSED: CLOSE SUB MENU IF MENU IS ALREADY OPENED
	if IsValid(menuCache.subMenu) then
		menuCache.subMenu:Close()
	end

	-- SET UP MAIN FRAME
	local dframe = vgui.Create("DFrameTTT2")
	dframe:SetSize(w, h)
	dframe:SetPos(x or 0.5 * (ScrW() - w), y or 0.5 * (ScrH() - h)) -- keep old position
	dframe:SetTitle("help_title")
	dframe:SetVisible(true)
	dframe:SetDraggable(true)
	dframe:ShowCloseButton(true)
	dframe:ShowBackButton(false)
	dframe:SetDeleteOnClose(true)
	dframe:SetSkin("ttt2_default")

	-- MAKE MAIN FRAME SCROLEABLE
	local scrollPanel = vgui.Create("DScrollPanel", dframe)
	scrollPanel:Dock(FILL)

	-- SPLIT FRAME INTO A GRID LAYOUT
	local dsettings = vgui.Create("DIconLayout", scrollPanel)
	dsettings:Dock(FILL)
	dsettings:SetSpaceX(pad)
	dsettings:SetSpaceY(pad)

	-- GENERATE MENU CONTENT
	local menuTbl = {}
	local helpData = HELP_DATA:BindData(menuTbl)

	InternalModifyMainMenu(helpData)

	hook.Run("TTT2ModifyMainMenu", helpData)

	for i = 1, #menuTbl do
		local data = menuTbl[i]

		-- do not show if it is admin only and the player is no admin
		if data.adminOnly and not LocalPlayer():IsAdmin() then continue end

		-- do not show if the shouldShow function returnes false
		if isfunction(data.shouldShowFn) and not data.shouldShowFn() then continue end

		local settingsButton = dsettings:Add("DMenuButtonTTT2")
		settingsButton:SetSize(widthMainButton, heightMainButton)
		settingsButton:SetTitle(data.title or data.id)
		settingsButton:SetDescription(data.description)
		settingsButton:SetImage(data.iconMat)

		settingsButton.DoClick = function(slf)
			dframe:Close()

			local posX, posY = dframe:GetPos()

			self:ShowSubMenu(posX, posY, data)
		end
	end

	dframe:MakePopup()
	dframe:SetKeyboardInputEnabled(false)

	menuCache.mainMenu = dframe
end

function HELPSCRN:ShowSubMenu(x, y, data)
	--if isfunction(data.onClickFn) then
	--	data.onClickFn(slf)

	--	return
	--end

	local frame = vgui.Create("DFrameTTT2")
	frame:SetSize(w, h)
	frame:SetPos(x, y)
	frame:SetTitle(data.title or data.id)
	frame:SetVisible(true)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:ShowBackButton(true)
	frame:SetDeleteOnClose(true)
	frame:SetSkin("ttt2_default")
	frame:SetPadding(0, 0, 0, 0)

	frame:RegisterBackFunction(function()
		self:Show(frame:GetPos())
	end)

	local navArea = vgui.Create("DNavPanelTTT2", frame)
	navArea:SetSize(widthNav, heightNav - VSKIN.GetHeaderHeight() - VSKIN.GetBorderSize())
	navArea:SetPos(0, 0)
	navArea:Dock(LEFT)

	local navAreaHeader = vgui.Create("DPanel", navArea)
	navAreaHeader:SetPos(0, 0)
	navAreaHeader:SetSize(widthNavHeader, heightNavHeader)

	local navAreaHeaderText = vgui.Create("DLabel", navAreaHeader)
	navAreaHeaderText:SetText("MENU")
	navAreaHeaderText:Dock(BOTTOM)

	local navAreaContent = vgui.Create("DPanel", navArea)
	navAreaContent:SetPos(0, heightNavHeader)
	navAreaContent:SetSize(widthNavContent, heightNavContent)

	-- MAKE NAV AREA SCROLEABLE
	local navAreaScroll = vgui.Create("DScrollPanel", navAreaContent)
	navAreaScroll:SetVerticalScrollbarEnabled(true)
	navAreaScroll:Dock(FILL)

	-- SPLIT NAV AREA INTO A GRID LAYOUT
	local navAreaScrollGrid = vgui.Create("DIconLayout", navAreaScroll)
	navAreaScrollGrid:Dock(FILL)
	navAreaScrollGrid:SetSpaceY(pad)

	local contentArea = vgui.Create("DContentPanelTTT2", frame)
	contentArea:SetSize(widthContent, heightContent - VSKIN.GetHeaderHeight() - VSKIN.GetBorderSize())
	contentArea:SetPos(widthNav, 0)
	contentArea:DockPadding(5, 5, 5, 5)
	contentArea:Dock(TOP)

	local contentAreaScroll = vgui.Create("DScrollPanel", contentArea)
	contentAreaScroll:SetVerticalScrollbarEnabled(true)
	contentAreaScroll:Dock(FILL)
	--pnl:SetPaintBackground(true)
	--pnl:SetBackgroundColor(settings_panel_default_bgcol)

	-- CALCULATE SIZES
	--local showButtons = isfunction(self.populateButtonFn)

	-- GENERATE MENU CONTENT
	local menuTbl = {}
	local helpData = SUB_HELP_DATA:BindData(menuTbl)

	InternalModifySubMenu(helpData, data.id)

	hook.Run("TTT2ModifySubMenu", helpData, data.id)

	-- cache reference to last active button
	local lastActive

	for i = 1, #menuTbl do
		local subData = menuTbl[i]

		local settingsButton = navAreaScrollGrid:Add("DSubMenuButtonTTT2")
		settingsButton:SetSize(widthNavButton, heightNavButton)
		settingsButton:SetTitle(subData.title or subData.id)

		settingsButton.DoClick = function(slf)
			contentAreaScroll:Clear()

			if isfunction(menuTbl[1].populateFn) then
				menuTbl[i].populateFn(contentAreaScroll)
			end

			-- handle the set/unset of active buttons for the draw process
			lastActive:SetActive(false)
			slf:SetActive()

			lastActive = slf
		end
	end

	-- autoselect first entry
	if #menuTbl >= 1 then
		if isfunction(menuTbl[1].populateFn) then
			menuTbl[1].populateFn(contentAreaScroll)
		end

		-- handle the set of active buttons for the draw process
		navAreaScrollGrid:GetChild(0):SetActive()

		lastActive = navAreaScrollGrid:GetChild(0)
	end

	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)

	menuCache.subMenu = frame
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

function HELPSCRN:CreateCompatibilityPanel(parent)
	local margin_x = 5
	local margin_y = 30

	local dframe2 = vgui.Create("DFrame")
	dframe2:SetSize(630, 470)
	dframe2:Center()
	dframe2:SetTitle(GetTranslation("help_title"))
	dframe2:SetVisible(true)
	dframe2:ShowCloseButton(true)
	dframe2:MakePopup()

	local dtabs = vgui.Create("DPropertySheet", dframe2)
	dtabs:SetPos(margin_x, margin_y)
	dtabs:SetSize(630 - 2 * margin_x, 470 - 2 * margin_y)

	-- Compatibility Info
	local compatinfo = vgui.Create("DPanel", dtabs)
	compatinfo:SetPaintBackground(false)
	compatinfo:StretchToParent(margin_x, 0, 0, 0)

	self:CreateCompatInfo(compatinfo)

	dtabs:AddSheet(GetTranslation("help_settings_compat"), compatinfo, "icon16/wrench.png", false, false, GetTranslation("help_settings_tip"))

	-- Tutorial
	local tutparent = vgui.Create("DPanel", dtabs)
	tutparent:SetPaintBackground(false)
	tutparent:StretchToParent(margin_x, 0, 0, 0)

	self:CreateTutorial(tutparent)

	dtabs:AddSheet(GetTranslation("help_tut"), tutparent, "icon16/book_open.png", false, false, GetTranslation("help_tut_tip"))
	dtabs:AddSheet(GetTranslation("help_tut2"), tutparent, "icon16/book_open.png", false, false, GetTranslation("help_tut_tip"))
	dtabs:AddSheet(GetTranslation("help_tut3"), tutparent, "icon16/book_open.png", false, false, GetTranslation("help_tut_tip"))

	-- extern support
	hook.Run("TTTSettingsTabs", dtabs)

	print("listing children:")
	--for _, v in ipairs(dtabs:GetChild(0):GetChildren()) do
	--	PrintTable(v:GetTable())
	--	print("------------------------------------------------------------------")
	--end

	--PrintTable(dtabs:GetChildren())
	-- 1: is always the tab bar
	--for i, v in ipairs(dtabs:GetChildren()) do
	--	PrintTable(v:GetTable())
	--	print("------------------------------------------------------------------")
	--end

	local children = dtabs:GetItems()
	for i = 1, #children do
		local child = children[i]

		print(child.Name)
	end
end

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

	for _, v in ipairs(roles.GetList()) do
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
	defaultHUDCb:SetValue(HUDManager.GetModelValue("defaultHUD") or "None")

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
	forceHUDCb:SetValue(HUDManager.GetModelValue("forcedHUD") or "None")

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

	local restrictedHUDs = HUDManager.GetModelValue("restrictedHUDs")
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

HUDManager.OnUpdateAttribute("restrictedHUDs", function()
	if not admin_dlv_rhuds or not IsValid(admin_dlv_rhuds) then return end

	admin_dlv_rhuds:Clear()

	local r = HUDManager.GetModelValue("restrictedHUDs")
	local a = huds.GetList()

	for _, v in ipairs(a) do
		admin_dlv_rhuds:AddLine(v.id, table.HasValue(r, v.id) and "true" or "false")
	end
end)

net.Receive("TTT2RestrictHUDResponse", function()
	local accepted = net.ReadBool()
	local hudname = net.ReadString()
	local ply = LocalPlayer()

	if not accepted then
		ply:ChatPrint("[TTT2][HUDManager] " .. GetPTranslation("hud_restricted_failed", {hudname = hudname}))

		return
	end
end)

net.Receive("TTT2ForceHUDResponse", function()
	local accepted = net.ReadBool()
	local hudname = net.ReadString()
	local ply = LocalPlayer()

	if not accepted then
		ply:ChatPrint("[TTT2][HUDManager] " .. GetPTranslation("hud_forced_failed", {hudname = hudname}))

		return
	end
end)

net.Receive("TTT2DefaultHUDResponse", function()
	local accepted = net.ReadBool()
	local hudname = net.ReadString()
	local ply = LocalPlayer()

	if not accepted then
		ply:ChatPrint("[TTT2][HUDManager] " .. GetPTranslation("hud_default_failed", {hudname = hudname}))

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
function HELPSCRN:CreateCompatInfo(parent)

end


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
