---
-- @class HELPSCRN
-- @desc Help screen

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation
local ipairs = ipairs
local IsValid = IsValid
local CreateConVar = CreateConVar

CreateConVar("ttt_spectator_mode", "0", FCVAR_ARCHIVE)
CreateConVar("ttt_mute_team_check", "0")

-- SET UP HELPSCRN AND INCLUDE ADDITIONAL FILES
HELPSCRN = HELPSCRN or {
	populate = {},
	subPopulate = {},
	nameMenuOpen = nil
}

ttt_include("cl_help_populate")
ttt_include("cl_help_populate_addons")
ttt_include("cl_help_populate_appearance")
ttt_include("cl_help_populate_bindings")
ttt_include("cl_help_populate_changelog")
ttt_include("cl_help_populate_gameplay")
ttt_include("cl_help_populate_guide")
ttt_include("cl_help_populate_language")
ttt_include("cl_help_populate_legacy")

-- DEFINE SIZE
HELPSCRN.pad = 5

local w, h = 1100, 700
local cols = 3
local widthMainButton = math.Round((w - 2 * HELPSCRN.pad * (cols + 1)) / cols)
local heightMainButton = 120

local widthNav, heightNav = 300, 700
local widthNavHeader, heightNavHeader = 299, 80
local widthNavContent, heightNavContent = 299, 620
local widthContent, heightContent = 800, 700
local heightButtonPanel = 80
local widthNavButton, heightNavButton = 299, 50

---
-- Opens the help screen
-- @realm client
function HELPSCRN:ShowMainMenu()
	-- IF MENU ELEMENT DOES NOT ALREADY EXIST, CREATE IT
	local frame
	if self.nameMenuOpen and VHDL.IsOpen() then
		frame = VHDL.ClearFrame(w, h, "help_title")
	else
		frame = VHDL.GenerateFrame(w, h, "help_title", true)
	end

	-- INIT MAIN MENU SPECIFIC STUFF
	frame:SetPadding(5, 5, 5, 5)

	-- MARK AS MAIN MENU
	self.nameMenuOpen = "main"

	-- MAKE MAIN FRAME SCROLEABLE
	local scrollPanel = vgui.Create("DScrollPanel", frame)
	scrollPanel:Dock(FILL)

	-- SPLIT FRAME INTO A GRID LAYOUT
	local dsettings = vgui.Create("DIconLayout", scrollPanel)
	dsettings:Dock(FILL)
	dsettings:SetSpaceX(HELPSCRN.pad)
	dsettings:SetSpaceY(HELPSCRN.pad)

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
			self:ShowSubMenu(data)
		end
	end
end

function HELPSCRN:GetOpenMenu()
	return self.nameMenuOpen and self.menuData.id
end

function HELPSCRN:SetupContentArea(parent, menuData)
	self.parent = parent
	self.menuData = menuData
end

function HELPSCRN:BuildContentArea()
	self.parent:Clear()

	local w2, h2 = self.parent:GetSize()
	local _, p1, _, p2 = self.parent:GetDockPadding()

	-- CALCULATE SIZE BASED ON EXISTENCE OF BUTTON PANEL
	if isfunction(self.menuData.populateButtonFn) then
		h2 = h2 - heightButtonPanel
	end

	-- ADD CONTENT BOX AND CONTENT
	local contentAreaScroll = vgui.Create("DScrollPanel", self.parent)
	contentAreaScroll:SetVerticalScrollbarEnabled(true)
	contentAreaScroll:SetSize(w2, h2 - p1 - p2)
	contentAreaScroll:Dock(TOP)

	if isfunction(self.menuData.populateFn) then
		self.menuData.populateFn(contentAreaScroll)
	end

	-- ADD BUTTON BOX AND BUTTONS
	if isfunction(self.menuData.populateButtonFn) then
		local buttonArea = vgui.Create("DButtonPanelTTT2", self.parent)
		buttonArea:SetSize(w2, heightButtonPanel)
		buttonArea:Dock(BOTTOM)

		self.menuData.populateButtonFn(buttonArea)
	end
end

function HELPSCRN:ShowSubMenu(data)
	-- IF MENU ELEMENT DOES NOT ALREADY EXIST, CREATE IT
	local frame
	if self.nameMenuOpen and VHDL.IsOpen() then
		frame = VHDL.ClearFrame(w, h, data.title or data.id)
	else
		frame = VHDL.GenerateFrame(w, h, data.title or data.id, true)
	end

	-- INIT SUB MENU SPECIFIC STUFF
	frame:ShowBackButton(true)
	frame:SetPadding(0, 0, 0, 0)

	frame:RegisterBackFunction(function()
		self:ShowMainMenu()
	end)

	-- MARK AS SUBMENU
	self.nameMenuOpen = "sub"

	-- BUILD GENERAL BOX STRUCTURE
	local navArea = vgui.Create("DNavPanelTTT2", frame)
	navArea:SetSize(widthNav, heightNav - VSKIN.GetHeaderHeight() - VSKIN.GetBorderSize())
	navArea:SetPos(0, 0)
	navArea:Dock(LEFT)

	local navAreaHeader = vgui.Create("DPanel", navArea)
	navAreaHeader:SetPos(0, 0)
	navAreaHeader:SetSize(widthNavHeader, heightNavHeader)

	local navAreaHeaderText = vgui.Create("DLabelTTT2", navAreaHeader)
	navAreaHeaderText:SetText("menu_name")
	navAreaHeaderText:DockMargin(15, 0, 0, 5)
	navAreaHeaderText:Dock(BOTTOM)
	navAreaHeaderText:SetFont("DermaTTT2TextLarge")
	navAreaHeaderText.Paint = function(slf, width, height)
		derma.SkinHook("Paint", "MenuLabelTTT2", slf, width, height)

		return true
	end

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
	navAreaScrollGrid:SetSpaceY(HELPSCRN.pad)

	local contentArea = vgui.Create("DContentPanelTTT2", frame)
	contentArea:SetSize(widthContent, heightContent - VSKIN.GetHeaderHeight() - VSKIN.GetBorderSize())
	contentArea:SetPos(widthNav, 0)
	contentArea:DockPadding(HELPSCRN.pad, HELPSCRN.pad, HELPSCRN.pad, HELPSCRN.pad)
	contentArea:Dock(TOP)

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
			HELPSCRN:SetupContentArea(contentArea, menuTbl[i])
			HELPSCRN:BuildContentArea()

			-- handle the set/unset of active buttons for the draw process
			lastActive:SetActive(false)
			slf:SetActive()

			lastActive = slf
		end
	end

	-- autoselect first entry
	if #menuTbl >= 1 then
		HELPSCRN:SetupContentArea(contentArea, menuTbl[1])
		HELPSCRN:BuildContentArea()

		-- handle the set of active buttons for the draw process
		navAreaScrollGrid:GetChild(0):SetActive()

		lastActive = navAreaScrollGrid:GetChild(0)
	end

	-- REGISTER REBUILD CALLABCK
	VHDL.RegisterCallback("rebuild", function(menu)
		print(tostring(HELPSCRN.nameMenuOpen))

		if HELPSCRN.nameMenuOpen ~= "sub" then return end

		HELPSCRN:BuildContentArea()
	end)
end

local function ShowTTTHelp(ply, cmd, args)
	-- F1 PRESSED: CLOSE MAIN MENU IF MENU IS ALREADY OPENED
	if HELPSCRN.nameMenuOpen == "main" and VHDL.IsOpen() then
		VHDL.CloseFrame()

		return
	end

	-- F1 PRESSED AND MENU IS HIDDEN: UNHIDE
	if HELPSCRN.nameMenuOpen and VHDL.IsHidden() then
		VHDL.UnhideFrame()

		return
	end

	-- DO NOTHING IF OTHER MENU IS OPEN
	if not HELPSCRN.nameMenuOpen and VHDL.IsOpen() then return end

	-- F1 PRESSED: CLOSE SUB MENU IF MENU IS ALREADY OPENED
	-- AND OPEN MAIN MENU IN GENERAL
	HELPSCRN:ShowMainMenu()
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
