---- Help screen

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation
local pairs = pairs
local ipairs = ipairs
local IsValid = IsValid
local ConVarExists = ConVarExists
local CreateConVar = CreateConVar

ttt_include("vgui__cl_settings_button")

CreateConVar("ttt_spectator_mode", "0", FCVAR_ARCHIVE)
CreateConVar("ttt_mute_team_check", "0")

CreateClientConVar("ttt_avoid_detective", "0", true, true)

HELPSCRN = {}

local helpframe

function HELPSCRN:Show()
	if helpframe and IsValid(helpframe) then
		helpframe:Close()

		return
	end

	local client = LocalPlayer()
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

	local dtabs = vgui.Create("DPropertySheet", dframe)
	dtabs:SetPos(margin, margin * 2)
	dtabs:SetSize(w - margin * 2, h - margin * 3 - bh)

	-- now fill with content

	local padding = (dtabs:GetPadding()) * 2

	-- TTT Settings

	local dsettings = vgui.Create("DPanelList", dtabs)
	dsettings:StretchToParent(0, 0, padding, 0)
	dsettings:EnableVerticalScrollbar(true)
	dsettings:SetPadding(10)
	dsettings:SetSpacing(10)

	dtabs:AddSheet(GetTranslation("help_settings"), dsettings, "icon16/wrench.png", false, false, GetTranslation("help_settings_tip"))

	local btnWidth = 120
	local btnHeight = btnWidth * 0.75
	local pad = 40
	local cols = ((w - 50) / (btnWidth + pad))

	local tbl = {
		changes = {
			onclick = function(slf)
				ShowChanges()
			end,
			getTitle = function()
				return "Changes"
			end
		},
		hudSwitcher = {
			onclick = function(slf)
				HUDManager.ShowHUDSwitcher(true)
			end,
			getTitle = function()
				return "HUD Switcher"
			end
		},
		bindings = {
			getContent = self.CreateBindings
		},
		interface = {
			getContent = self.CreateInterfaceSettings
		},
		gameplay = {
			getContent = self.CreateGameplaySettings
		},
		crosshair = {
			getContent = self.CreateCrosshairSettings
		},
		language = {
			getContent = self.CreateLanguageForm
		}
	}

	local row = 1
	local i = 1

	for name, tbl in pairs(tbl) do
		local settingsButton = vgui.Create("DSettingsButton", dsettings)
		settingsButton:SetSize(btnWidth, btnHeight)
		settingsButton:SetText(isfunction(tbl.getTitle) and tbl.getTitle() or string.upper(name))

		local pos = table.Copy(dsettings:GetPos())
		pos.x = pos.x + i * (btnWidth + pad)
		pos.y = pos.y + row * (btnHeight + pad)

		settingsButton:SetPos(pos)

		settingsButton.DoClick = function(slf)
			self:Close()

			if isfunction(tbl.onclick) then
				tbl.onclick(slf)

				return
			end

			local frame = vgui.Create("DFrame")
			frame:SetSize(minWidth, minHeight)

			frame.OnClose = function(slf)
				self:Show()
			end

			local pnl = vgui.Create("DPanel", frame)
			pnl:Dock(FILL)

			if isfunction(tbl.getContent) then
				tbl.getContent(self, pnl)
			end
		end

		if i % cols == 0 then
			i = 1
			row = row + 1
		else
			i = i + 1
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
	local num = tonumber(new)

	if num and (num == 0 or num == 1) then
		RunConsoleCommand("ttt_mute_team", num)
	end
end
cvars.AddChangeCallback("ttt_mute_team_check", MuteTeamCallback)

function HELPSCRN:CreateInterfaceSettings(parent)
	parent:SetName(GetTranslation("set_title_gui"))
	parent:CheckBox(GetTranslation("set_tips"), "ttt_tips_enable")

	local cb = parent:NumSlider(GetTranslation("set_startpopup"), "ttt_startpopup_duration", 0, 60, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb:SetTooltip(GetTranslation("set_startpopup_tip"))

	parent:CheckBox(GetTranslation("set_healthlabel"), "ttt_health_label")

	cb = parent:CheckBox(GetTranslation("set_fastsw"), "ttt_weaponswitcher_fast")
	cb:SetTooltip(GetTranslation("set_fastsw_tip"))

	cb = parent:CheckBox(GetTranslation("set_fastsw_menu"), "ttt_weaponswitcher_displayfast")
	cb:SetTooltip(GetTranslation("set_fastswmenu_tip"))

	cb = parent:CheckBox(GetTranslation("set_wswitch"), "ttt_weaponswitcher_stay")
	cb:SetTooltip(GetTranslation("set_wswitch_tip"))

	cb = parent:CheckBox(GetTranslation("set_cues"), "ttt_cl_soundcues")
end

-- language
function HELPSCRN:CreateLanguageForm(parent)
	parent:SetName(GetTranslation("set_title_lang"))

	local dlang = vgui.Create("DComboBox", parent)
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

	parent:Help(GetTranslation("set_lang"))
	parent:AddItem(dlang)
end

function HELPSCRN:CreateCrosshairSettings(parent)
	parent:SetName(GetTranslation("set_title_cross"))

	parent:CheckBox(GetTranslation("set_cross_color_enable"), "ttt_crosshair_color_enable")

	local cm = vgui.Create("DColorMixer")
	cm:SetLabel(GetTranslation("set_cross_color"))
	cm:SetTall(120)
	cm:SetAlphaBar(false)
	cm:SetPalette(false)
	cm:SetColor(Color(30, 160, 160, 255))
	cm:SetConVarR("ttt_crosshair_color_r")
	cm:SetConVarG("ttt_crosshair_color_g")
	cm:SetConVarB("ttt_crosshair_color_b")

	parent:AddItem(cm)

	parent:CheckBox(GetTranslation("set_cross_gap_enable"), "ttt_crosshair_gap_enable")

	local cb = parent:NumSlider(GetTranslation("set_cross_gap"), "ttt_crosshair_gap", 0, 30, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = parent:NumSlider(GetTranslation("set_cross_opacity"), "ttt_crosshair_opacity", 0, 1, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = parent:NumSlider(GetTranslation("set_ironsight_cross_opacity"), "ttt_ironsights_crosshair_opacity", 0, 1, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = parent:NumSlider(GetTranslation("set_cross_brightness"), "ttt_crosshair_brightness", 0, 1, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = parent:NumSlider(GetTranslation("set_cross_size"), "ttt_crosshair_size", 0.1, 3, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = parent:NumSlider(GetTranslation("set_cross_thickness"), "ttt_crosshair_thickness", 1, 10, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = parent:NumSlider(GetTranslation("set_cross_outlinethickness"), "ttt_crosshair_outlinethickness", 0, 5, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	parent:CheckBox(GetTranslation("set_cross_disable"), "ttt_disable_crosshair")
	parent:CheckBox(GetTranslation("set_minimal_id"), "ttt_minimal_targetid")
	parent:CheckBox(GetTranslation("set_cross_static_enable"), "ttt_crosshair_static")
	parent:CheckBox(GetTranslation("set_cross_dot_enable"), "ttt_crosshair_dot")
	parent:CheckBox(GetTranslation("set_cross_weaponscale_enable"), "ttt_crosshair_weaponscale")

	cb = parent:CheckBox(GetTranslation("set_lowsights"), "ttt_ironsights_lowered")
	cb:SetTooltip(GetTranslation("set_lowsights_tip"))
end

function HELPSCRN:CreateGameplaySettings(parent)
	parent:SetName(GetTranslation("set_title_play"))

	local cb

	for _, v in pairs(GetRoles()) do
		if ConVarExists("ttt_avoid_" .. v.name) then
			local rolename = GetTranslation(v.name)

			cb = parent:CheckBox(GetPTranslation("set_avoid", rolename), "ttt_avoid_" .. v.name)
			cb:SetTooltip(GetPTranslation("set_avoid_tip", rolename))
		end
	end

	cb = parent:CheckBox(GetTranslation("set_specmode"), "ttt_spectator_mode")
	cb:SetTooltip(GetTranslation("set_specmode_tip"))

	-- TODO what is the following reason?
	-- For some reason this one defaulted to on, unlike other checkboxes, so
	-- force it to the actual value of the cvar (which defaults to off)
	local mute = parent:CheckBox(GetTranslation("set_mute"), "ttt_mute_team_check")
	mute:SetValue(GetConVar("ttt_mute_team_check"):GetBool())
	mute:SetTooltip(GetTranslation("set_mute_tip"))
end

-- Bindings
function HELPSCRN:CreateBindings(parent)
	parent:SetName("TTT2 Bindings")

	for _, binding in ipairs(bind.GetSettingsBindings()) do
		local dPlabel = vgui.Create("DLabel")
		dPlabel:SetText(binding.label)

		local dPBinder = vgui.Create("DBinder")
		dPBinder:SetSize(170, 30)

		local curBinding = bind.Find(binding.name)
		dPBinder:SetValue(curBinding)

		function dPBinder:OnChange(num)
			if num == 0 then
				bind.Remove(curBinding, binding.name)
			else
				bind.Remove(curBinding, binding.name)
				bind.Add(num, binding.name, true)

				LocalPlayer():ChatPrint("New bound key for '" .. binding.name .. "': " .. input.GetKeyName(num))
			end

			curBinding = num
		end

		parent:AddItem(dPlabel, dPBinder)
	end
end

--- Tutorial

local imgpath = "vgui/ttt/help/tut0%d"
local tutorial_pages = 6

-- TODO update tutorial
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
