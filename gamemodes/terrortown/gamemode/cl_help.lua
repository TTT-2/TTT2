---- Help screen

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

CreateConVar("ttt_spectator_mode", "0", FCVAR_ARCHIVE)
CreateConVar("ttt_mute_team_check", "0")

CreateClientConVar("ttt_avoid_detective", "0", true, true)

HELPSCRN = {}

function HELPSCRN:Show()
	local client = LocalPlayer()
	local margin = 15
	local w, h = 630, 470

	local dframe = vgui.Create("DFrame")
	dframe:SetSize(w, h)
	dframe:Center()
	dframe:SetTitle(GetTranslation("help_title"))
	dframe:ShowCloseButton(true)

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

	local padding = (dtabs:GetPadding()) * 2

	local tutparent = vgui.Create("DPanel", dtabs)
	tutparent:SetPaintBackground(false)
	tutparent:StretchToParent(margin, 0, 0, 0)

	self:CreateTutorial(tutparent)

	dtabs:AddSheet(GetTranslation("help_tut"), tutparent, "icon16/book_open.png", false, false, GetTranslation("help_tut_tip"))

	local dsettings = vgui.Create("DPanelList", dtabs)
	dsettings:StretchToParent(0, 0, padding, 0)
	dsettings:EnableVerticalScrollbar(true)
	dsettings:SetPadding(10)
	dsettings:SetSpacing(10)

	--- Interface area

	local dgui = vgui.Create("DForm", dsettings)
	dgui:SetName(GetTranslation("set_title_gui"))
	dgui:CheckBox(GetTranslation("set_tips"), "ttt_tips_enable")

	local cb = dgui:NumSlider(GetTranslation("set_startpopup"), "ttt_startpopup_duration", 0, 60, 0)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb:SetTooltip(GetTranslation("set_startpopup_tip"))

	cb = dgui:NumSlider(GetTranslation("set_cross_opacity"), "ttt_ironsights_crosshair_opacity", 0, 1, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb:SetTooltip(GetTranslation("set_cross_opacity"))

	cb = dgui:NumSlider(GetTranslation("set_cross_brightness"), "ttt_crosshair_brightness", 0, 1, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	cb = dgui:NumSlider(GetTranslation("set_cross_size"), "ttt_crosshair_size", 0.1, 3, 1)
	if cb.Label then
		cb.Label:SetWrap(true)
	end

	dgui:CheckBox(GetTranslation("set_cross_disable"), "ttt_disable_crosshair")
	dgui:CheckBox(GetTranslation("set_minimal_id"), "ttt_minimal_targetid")
	dgui:CheckBox(GetTranslation("set_healthlabel"), "ttt_health_label")

	cb = dgui:CheckBox(GetTranslation("set_lowsights"), "ttt_ironsights_lowered")
	cb:SetTooltip(GetTranslation("set_lowsights_tip"))

	cb = dgui:CheckBox(GetTranslation("set_fastsw"), "ttt_weaponswitcher_fast")
	cb:SetTooltip(GetTranslation("set_fastsw_tip"))

	cb = dgui:CheckBox(GetTranslation("set_fastsw_menu"), "ttt_weaponswitcher_displayfast")
	cb:SetTooltip(GetTranslation("set_fastswmenu_tip"))

	cb = dgui:CheckBox(GetTranslation("set_wswitch"), "ttt_weaponswitcher_stay")
	cb:SetTooltip(GetTranslation("set_wswitch_tip"))

	cb = dgui:CheckBox(GetTranslation("set_cues"), "ttt_cl_soundcues")

	dsettings:AddItem(dgui)

	--- Gameplay area

	local dplay = vgui.Create("DForm", dsettings)
	dplay:SetName(GetTranslation("set_title_play"))

	for _, v in pairs(ROLES) do
		if ConVarExists("ttt_avoid_" .. v.name) then
			local rolename = GetTranslation(v.name)

			cb = dplay:CheckBox(GetPTranslation("set_avoid", rolename), "ttt_avoid_" .. v.name)
			cb:SetTooltip(GetPTranslation("set_avoid_tip", rolename))
		end
	end

	cb = dplay:CheckBox(GetTranslation("set_specmode"), "ttt_spectator_mode")
	cb:SetTooltip(GetTranslation("set_specmode_tip"))

	-- TODO what is the following reason?
	-- For some reason this one defaulted to on, unlike other checkboxes, so
	-- force it to the actual value of the cvar (which defaults to off)
	local mute = dplay:CheckBox(GetTranslation("set_mute"), "ttt_mute_team_check")
	mute:SetValue(GetConVar("ttt_mute_team_check"):GetBool())
	mute:SetTooltip(GetTranslation("set_mute_tip"))

	dsettings:AddItem(dplay)

	--- Language area
	local dlanguage = vgui.Create("DForm", dsettings)
	dlanguage:SetName(GetTranslation("set_title_lang"))

	local dlang = vgui.Create("DComboBox", dlanguage)
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

	dlanguage:Help(GetTranslation("set_lang"))
	dlanguage:AddItem(dlang)

	dsettings:AddItem(dlanguage)

	dtabs:AddSheet(GetTranslation("help_settings"), dsettings, "icon16/wrench.png", false, false, GetTranslation("help_settings_tip"))

	-- role description
	local roledesc_panel = vgui.Create("DPanelList", dtabs)
	roledesc_panel:StretchToParent(0, 0, dtabs:GetPadding() * 2, 0)
	roledesc_panel:EnableVerticalScrollbar(true)
	roledesc_panel:SetPadding(10)
	roledesc_panel:SetSpacing(10)

	dtabs:AddSheet("TTT2", roledesc_panel, "icon16/information.png", false, false, "The TTT2 settings")

	local list = vgui.Create("DIconLayout", roledesc_panel)
	list:SetSpaceX(5)
	list:SetSpaceY(5)
	list:Dock(FILL)
	list:DockMargin(5, 5, 5, 5)
	list:DockPadding(10, 10, 10, 10)

	local roledesc_tab = vgui.Create("DForm")
	roledesc_tab:SetSpacing(10)

	local subrole = client:GetSubRole()

	if subrole ~= ROLE_NONE then
		roledesc_tab:SetName("Current Role Description of " .. GetTranslation(client:GetSubRoleData().name))
	else
		roledesc_tab:SetName("Current Role Description")
	end

	roledesc_tab:SetWide(roledesc_panel:GetWide() - 30)
	roledesc_panel:AddItem(roledesc_tab)

	if subrole ~= ROLE_NONE then
		roledesc_tab:Help(GetTranslation("ttt2_desc_" .. client:GetSubRoleData().name))
	else
		roledesc_tab:Help(GetTranslation("ttt2_desc_none"))
	end

	roledesc_tab:SizeToContents()
	-- end role description

	hook.Call("TTTSettingsTabs", GAMEMODE, dtabs)

	dframe:MakePopup()
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
