---
-- @class HELPSCRN
-- @desc Help screen

local IsValid = IsValid
local CreateConVar = CreateConVar

CreateConVar("ttt_spectator_mode", "0", FCVAR_ARCHIVE)
CreateConVar("ttt_mute_team_check", "0")

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

local mainMenuOrder = {
	"ttt2_changelog",
	"ttt2_guide",
	"ttt2_bindings",
	"ttt2_language",
	"ttt2_appearance",
	"ttt2_gameplay",
	"ttt2_addons",
	"ttt2_legacy"
}

local mainMenuAdminOrder = {
	"ttt2_administration",
	"ttt2_equipment",
	"ttt2_shops"
}

-- Populate the main menu
local function InternalModifyMainMenu(helpData)
	for i = 1, #mainMenuOrder do
		local id = mainMenuOrder[i]

		HELPSCRN.populate[id](helpData, id)
	end

	for i = 1, #mainMenuAdminOrder do
		local id = mainMenuAdminOrder[i]
		HELPSCRN.populate[id](helpData, id)
	end
end

-- Populate the sub menues
local function InternalModifySubMenu(helpData, menuId)
	if not HELPSCRN.subPopulate[menuId] then return end

	HELPSCRN.subPopulate[menuId](helpData, menuId)
end

-- SET UP HELPSCRN AND INCLUDE ADDITIONAL FILES
HELPSCRN = HELPSCRN or {}

HELPSCRN.populate = HELPSCRN.populate or {}
HELPSCRN.subPopulate = HELPSCRN.subPopulate or {}
HELPSCRN.nameMenuOpen = HELPSCRN.nameMenuOpen or nil
HELPSCRN.parent = HELPSCRN.parent or nil
HELPSCRN.menuData = HELPSCRN.menuData or nil
HELPSCRN.mainframe = HELPSCRN.mainframe or nil

HELPSCRN.pad = 5

fileloader.LoadFolder("terrortown/gamemode/client/cl_help/", false, CLIENT_FILE)

-- define sizes
local w, h = 1100, 700
local cols = 3
local widthMainButton = math.Round((w - 2 * HELPSCRN.pad * (cols + 1)) / cols)
local heightMainButton = 120

local widthNav, heightNav = 300, 700
local heightNavHeader = 15
local widthNavContent, heightNavContent = 299, 685
local widthContent, heightContent = 800, 700
local heightButtonPanel = 80
local widthNavButton, heightNavButton = 299, 50

local function AddMenuButtons(menuTbl, parent)
	for i = 1, #menuTbl do
		local data = menuTbl[i]

		local settingsButton = parent:Add("DMenuButtonTTT2")
		settingsButton:SetSize(widthMainButton, heightMainButton)
		settingsButton:SetTitle(data.title or data.id)
		settingsButton:SetDescription(data.description)
		settingsButton:SetImage(data.iconMat)

		settingsButton.DoClick = function(slf)
			HELPSCRN:ShowSubMenu(data)
		end
	end
end

---
-- Opens the help screen
-- @realm client
function HELPSCRN:ShowMainMenu()
	local frame = self.mainframe

	-- IF MENU ELEMENT DOES NOT ALREADY EXIST, CREATE IT
	if IsValid(frame) and not frame:IsFrameHidden() then
		frame:ClearFrame(nil, nil, "help_title")
	else
		frame = vguihandler.GenerateFrame(w, h, "help_title", true)
	end

	self.mainframe = frame

	-- INIT MAIN MENU SPECIFIC STUFF
	frame:SetPadding(self.pad, self.pad, self.pad, self.pad)

	-- MARK AS MAIN MENU
	self.nameMenuOpen = "main"

	-- MAKE MAIN FRAME SCROLLABLE
	local scrollPanel = vgui.Create("DScrollPanel", frame)
	scrollPanel:Dock(FILL)

	-- SPLIT FRAME INTO A GRID LAYOUT
	local dsettings = vgui.Create("DIconLayout", scrollPanel)
	dsettings:Dock(FILL)
	dsettings:SetSpaceX(self.pad)
	dsettings:SetSpaceY(self.pad)

	-- GENERATE MENU CONTENT
	local menuTbl = {}
	local helpData = HELP_DATA:BindData(menuTbl)

	InternalModifyMainMenu(helpData)

	hook.Run("TTT2ModifyMainMenu", helpData)

	local menuesNormal = helpData:GetVisibleNormalMenues()
	local menuesAdmin = helpData:GetVisibleAdminMenues()

	AddMenuButtons(menuesNormal, dsettings)

	-- only show admin section if player is admin and
	-- there are menues to be shown
	if #menuesAdmin == 0 then return end

	local labelSpacer = dsettings:Add("DLabelTTT2")
	labelSpacer.OwnLine = true
	labelSpacer:SetText("label_menu_admin_spacer")
	labelSpacer:SetSize(w, 35)

	AddMenuButtons(menuesAdmin, dsettings)
end

---
-- Returns the name of the currently open menu
-- @return string The id of the opened menu
-- @realm client
function HELPSCRN:GetOpenMenu()
	return self.nameMenuOpen and self.menuData.id
end

---
-- Sets up the data for the content area without actually building the area
-- @param Panel parent The parent panel
-- @param table menuData The menu content table
-- @realm client
function HELPSCRN:SetupContentArea(parent, menuData)
	self.parent = parent
	self.lastMenuData = self.menuData
	self.menuData = menuData
end

---
-- Builds the content area, the data has to be set previously
-- @realm client
function HELPSCRN:BuildContentArea()
	if not IsValid(self.parent) then return end

	if hook.Run("TTT2OnSubmenuClear", self.parent, self.nameMenuOpen, self.lastMenuData, self.menuData) == false then return end

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

---
-- Opens the help sub screen
-- @param table data The data of the submenu
-- @realm client
function HELPSCRN:ShowSubMenu(data)
	local frame = self.mainframe

	-- IF MENU ELEMENT DOES NOT ALREADY EXIST, CREATE IT
	if IsValid(frame) and not frame:IsFrameHidden() then
		frame:ClearFrame(nil, nil, data.title or data.id)
	else
		frame = vguihandler.GenerateFrame(w, h, data.title or data.id)
	end

	-- INIT SUB MENU SPECIFIC STUFF
	frame:ShowBackButton(true)
	frame:SetPadding(0, 0, 0, 0)

	frame:RegisterBackFunction(function()
		self:ShowMainMenu()
	end)

	-- MARK AS SUBMENU
	self.nameMenuOpen = data.id

	-- BUILD GENERAL BOX STRUCTURE
	local navArea = vgui.Create("DNavPanelTTT2", frame)
	navArea:SetSize(widthNav, heightNav - vskin.GetHeaderHeight() - vskin.GetBorderSize())
	navArea:SetPos(0, 0)
	navArea:Dock(LEFT)

	local navAreaContent = vgui.Create("DPanel", navArea)
	navAreaContent:SetPos(0, heightNavHeader)
	navAreaContent:SetSize(widthNavContent, heightNavContent - vskin.GetHeaderHeight() - vskin.GetBorderSize())

	-- MAKE NAV AREA SCROLLABLE
	local navAreaScroll = vgui.Create("DScrollPanel", navAreaContent)
	navAreaScroll:SetVerticalScrollbarEnabled(true)
	navAreaScroll:Dock(FILL)

	-- SPLIT NAV AREA INTO A GRID LAYOUT
	local navAreaScrollGrid = vgui.Create("DIconLayout", navAreaScroll)
	navAreaScrollGrid:Dock(FILL)
	navAreaScrollGrid:SetSpaceY(self.pad)

	local contentArea = vgui.Create("DContentPanelTTT2", frame)
	contentArea:SetSize(widthContent, heightContent - vskin.GetHeaderHeight() - vskin.GetBorderSize())
	contentArea:SetPos(widthNav, 0)
	contentArea:DockPadding(self.pad, self.pad, self.pad, self.pad)
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

	-- REGISTER REBUILD CALLBACK
	frame.OnRebuild = function(slf)
		if HELPSCRN.nameMenuOpen == "main" then return end

		HELPSCRN:BuildContentArea()
	end
end

local function ShowTTTHelp(ply, cmd, args)
	-- F1 PRESSED: CLOSE MAIN MENU IF MENU IS ALREADY OPENED
	if HELPSCRN.nameMenuOpen == "main" and IsValid(HELPSCRN.mainframe) and not HELPSCRN.mainframe:IsFrameHidden() then
		HELPSCRN.mainframe:CloseFrame()

		return
	end

	-- F1 PRESSED AND MENU IS HIDDEN: UNHIDE
	if HELPSCRN.nameMenuOpen and IsValid(HELPSCRN.mainframe) and HELPSCRN.mainframe:IsFrameHidden() then
		HELPSCRN.mainframe:UnhideFrame()

		return
	end

	-- F1 PRESSED: CLOSE SUB MENU IF MENU IS ALREADY OPENED
	-- AND OPEN MAIN MENU IN GENERAL
	HELPSCRN:ShowMainMenu()
end
concommand.Add("ttt_helpscreen", ShowTTTHelp)

---
-- A hook that is called once the content area of the helpscreen
-- is about to be cleared, clearing is stopped if false is returned.
-- @param Panel parent The parent panel
-- @param string nameMenuOpen The name of the opened submenu
-- @param table lastMenuData The menu data of the menu that will be closed
-- @param table menuData The menu data of the menu that will be opened
-- @hook
-- @realm client
function GM:TTT2OnSubmenuClear(parent, nameMenuOpen, lastMenuData, menuData)

end
