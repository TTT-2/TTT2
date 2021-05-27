---
-- @class HELPSCRN

local IsValid = IsValid

---
-- @realm client
CreateConVar("ttt_spectator_mode", "0", FCVAR_ARCHIVE)

---
-- @realm client
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

-- LOAD HELP MENU PAGE CLASSES

local function ShouldInherit(t, base)
	return t.base ~= t.type
end

-- callback function that is called once the submenu class is loaded
local function OnSubmenuClassLoaded(class, path, name)
	class.type = name
	class.base = class.base or "base_gamemodesubmenu"

	MsgN("Added TTT2 gamemode submenu file: ", path, name)
end

-- load submenu base from specific folder
local submenuBase = classbuilder.BuildFromFolder(
	"terrortown/menus/gamemode/base_gamemodemenu/",
	CLIENT_FILE,
	"CLGAMEMODESUBMENU", -- class scope
	OnSubmenuClassLoaded, -- on class loaded
	true, -- should inherit
	ShouldInherit -- special inheritance check
)

-- callback function that is called once the menu class is loaded;
-- also used to load submenus for this menu
local function OnMenuClassLoaded(class, path, name)
	class.type = name
	class.base = class.base or "base_gamemodemenu"

	MsgN("Added TTT2 gamemode menu file: ", path, name)
end

-- initialize the submenus after they were loaded
local function InitSubmenu(class, path, name)
	class:Initialize()
end

-- once the classes are set up and inherited from their base, they
-- are ready to be used, i.e. their submenus can be added
local function LoadSubmenus(class, path, name)
	class:Initialize()

	-- do not load the submenu base again
	if name == "base_gamemodemenu" then return end

	-- now search for submenus in the corresponding folder
	local submenus = classbuilder.BuildFromFolder(
		"terrortown/menus/gamemode/" .. name .. "/",
		CLIENT_FILE,
		"CLGAMEMODESUBMENU", -- class scope
		OnSubmenuClassLoaded, -- on class loaded
		true, -- should inherit
		ShouldInherit, -- special inheritance check
		submenuBase, -- passing through additional menu table for inheritance
		InitSubmenu -- post inheritance callback
	)

	-- transfer mnus into indexed table and sort by priority
	local submenusIndexed = {}

	for _, submenu in pairs(submenus) do
		if submenu.type == "base_gamemodesubmenu" then continue end

		submenusIndexed[#submenusIndexed + 1] = submenu
	end

	table.SortByMember(submenusIndexed, "priority")

	class:SetSubmenuTable(submenusIndexed)
end

local menus = classbuilder.BuildFromFolder(
	"terrortown/menus/gamemode/",
	CLIENT_FILE,
	"CLGAMEMODEMENU", -- class scope
	OnMenuClassLoaded, -- on class loaded callback
	true, -- should inherit
	ShouldInherit, -- special inheritance check
	nil, -- don't pass through additional classes
	LoadSubmenus -- post inheritance callback
)

-- transfer mnus into indexed table and sort by priority
--local menusIndexed = {}
menusIndexed = {}

for _, menu in pairs(menus) do
	if menu.type == "base_gamemodemenu" then continue end

	menusIndexed[#menusIndexed + 1] = menu
end

table.SortByMember(menusIndexed, "priority")

-- END load help menu classes

















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
local function InternalModifyHelpMainMenu(helpData)
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
local function InternalModifyHelpSubmenu(helpData, menuId)
	if not HELPSCRN.subPopulate[menuId] then return end

	HELPSCRN.subPopulate[menuId](helpData, menuId)
end

-- SET UP HELPSCRN AND INCLUDE ADDITIONAL FILES
HELPSCRN = HELPSCRN or {}

HELPSCRN.populate = HELPSCRN.populate or {}
HELPSCRN.subPopulate = HELPSCRN.subPopulate or {}
HELPSCRN.currentMenuId = HELPSCRN.currentMenuId or nil
HELPSCRN.parent = HELPSCRN.parent or nil
HELPSCRN.menuData = HELPSCRN.menuData or nil
HELPSCRN.menuFrame = HELPSCRN.menuFrame or nil

HELPSCRN.padding = 5

-- define sizes
local width, height = 1100, 700
local cols = 3
local widthMainMenuButton = math.Round((width - 2 * HELPSCRN.padding * (cols + 1)) / cols)
local heightMainMenuButton = 120

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
		settingsButton:SetSize(widthMainMenuButton, heightMainMenuButton)
		settingsButton:SetTitle(data.title or data.id)
		settingsButton:SetDescription(data.description)
		settingsButton:SetImage(data.iconMat)

		settingsButton.DoClick = function(slf)
			HELPSCRN:ShowSubmenu(data)
		end
	end
end

-- since the main menu has no ID, it has this static ID
local MAIN_MENU = "main"

fileloader.LoadFolder("terrortown/gamemode/client/cl_help/", false, CLIENT_FILE)

---
-- Opens the help screen
-- @realm client
function HELPSCRN:ShowMainMenu()
	local frame = self.menuFrame

	-- IF MENU ELEMENT DOES NOT ALREADY EXIST, CREATE IT
	if IsValid(frame) then
		frame:ClearFrame(nil, nil, "help_title")
	else
		frame = vguihandler.GenerateFrame(width, height, "help_title", true)
	end

	self.menuFrame = frame

	-- INIT MAIN MENU SPECIFIC STUFF
	frame:SetPadding(self.padding, self.padding, self.padding, self.padding)

	-- MARK AS MAIN MENU
	self.currentMenuId = MAIN_MENU

	-- MAKE MAIN FRAME SCROLLABLE
	local scrollPanel = vgui.Create("DScrollPanelTTT2", frame)
	scrollPanel:Dock(FILL)

	-- SPLIT FRAME INTO A GRID LAYOUT
	local dsettings = vgui.Create("DIconLayout", scrollPanel)
	dsettings:Dock(FILL)
	dsettings:SetSpaceX(self.padding)
	dsettings:SetSpaceY(self.padding)

	-- GENERATE MENU CONTENT
	local menuTbl = {}
	local helpData = menuDataHandler.CreateNewHelpMenu()

	helpData:BindData(menuTbl)

	InternalModifyHelpMainMenu(helpData)

	---
	-- @realm client
	hook.Run("TTT2ModifyHelpMainMenu", helpData)

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
-- @see HELPSCRN:ShowMainMenu()
-- @realm client
-- @function HELPSCRN:Show()
HELPSCRN.Show = HELPSCRN.ShowMainMenu

---
-- Returns the name of the currently opened menu, returns nil if no menu is opened
-- @return string The id of the opened menu or nil
-- @realm client
function HELPSCRN:GetOpenMenu()
	-- `self.menuData.id` is not reset on close of the menu, therefore it has to be
	-- checked if a menu is open at all. This is done by checking if `self.currentMenuId ~= nil`
	-- since this variable is set to `nil` once the menu is closed
	return self.currentMenuId and self.menuData.id
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
	local parent = self.parent

	if not IsValid(parent) then return end

	---
	-- @realm client
	if hook.Run("TTT2OnHelpSubmenuClear", parent, self.currentMenuId, self.lastMenuData, self.menuData) == false then return end

	parent:Clear()

	local width2, height2 = parent:GetSize()
	local _, paddingTop, _, paddingBottom = parent:GetDockPadding()

	-- CALCULATE SIZE BASED ON EXISTENCE OF BUTTON PANEL
	if isfunction(self.menuData.populateButtonFn) then
		height2 = height2 - heightButtonPanel
	end

	-- ADD CONTENT BOX AND CONTENT
	local contentAreaScroll = vgui.Create("DScrollPanelTTT2", parent)
	contentAreaScroll:SetVerticalScrollbarEnabled(true)
	contentAreaScroll:SetSize(width2, height2 - paddingTop - paddingBottom)
	contentAreaScroll:Dock(TOP)

	if isfunction(self.menuData.populateFn) then
		self.menuData.populateFn(contentAreaScroll)
	end

	-- ADD BUTTON BOX AND BUTTONS
	if isfunction(self.menuData.populateButtonFn) then
		local buttonArea = vgui.Create("DButtonPanelTTT2", parent)
		buttonArea:SetSize(width2, heightButtonPanel)
		buttonArea:Dock(BOTTOM)

		self.menuData.populateButtonFn(buttonArea)
	end
end

---
-- Opens the help sub screen
-- @param table data The data of the submenu
-- @realm client
function HELPSCRN:ShowSubmenu(data)
	local frame = self.menuFrame

	-- IF MENU ELEMENT DOES NOT ALREADY EXIST, CREATE IT
	if IsValid(frame) then
		frame:ClearFrame(nil, nil, data.title or data.id)
	else
		frame = vguihandler.GenerateFrame(width, height, data.title or data.id)
	end

	-- INIT SUB MENU SPECIFIC STUFF
	frame:ShowBackButton(true)
	frame:SetPadding(0, 0, 0, 0)

	frame:RegisterBackFunction(function()
		self:ShowMainMenu()
	end)

	-- MARK AS SUBMENU
	self.currentMenuId = data.id

	-- BUILD GENERAL BOX STRUCTURE
	local navArea = vgui.Create("DNavPanelTTT2", frame)
	navArea:SetSize(widthNav, heightNav - vskin.GetHeaderHeight() - vskin.GetBorderSize())
	navArea:SetPos(0, 0)
	navArea:Dock(LEFT)

	local navAreaContent = vgui.Create("DPanel", navArea)
	navAreaContent:SetPos(0, heightNavHeader)
	navAreaContent:SetSize(widthNavContent, heightNavContent - vskin.GetHeaderHeight() - vskin.GetBorderSize())

	-- MAKE NAV AREA SCROLLABLE
	local navAreaScroll = vgui.Create("DScrollPanelTTT2", navAreaContent)
	navAreaScroll:SetVerticalScrollbarEnabled(true)
	navAreaScroll:Dock(FILL)

	-- SPLIT NAV AREA INTO A GRID LAYOUT
	local navAreaScrollGrid = vgui.Create("DIconLayout", navAreaScroll)
	navAreaScrollGrid:Dock(FILL)
	navAreaScrollGrid:SetSpaceY(self.padding)

	local contentArea = vgui.Create("DContentPanelTTT2", frame)
	contentArea:SetSize(widthContent, heightContent - vskin.GetHeaderHeight() - vskin.GetBorderSize())
	contentArea:SetPos(widthNav, 0)
	contentArea:DockPadding(self.padding, self.padding, self.padding, self.padding)
	contentArea:Dock(TOP)

	-- GENERATE MENU CONTENT
	local menuTbl = {}
	local helpData = menuDataHandler.CreateNewHelpSubmenu()

	helpData:BindData(menuTbl)

	InternalModifyHelpSubmenu(helpData, data.id)

	---
	-- @realm client
	hook.Run("TTT2ModifyHelpSubmenu", helpData, data.id)

	-- cache reference to last active button
	local lastActive

	if #menuTbl == 0 then
		local labelNoContent = vgui.Create("DLabelTTT2", contentArea)
		labelNoContent:SetText("label_menu_not_populated")
		labelNoContent:SetSize(widthContent - 40, 50)
		labelNoContent:SetFont("DermaTTT2Title")
		labelNoContent:SetPos(20, 0)
	else
		for i = 1, #menuTbl do
			local subData = menuTbl[i]

			local settingsButton = navAreaScrollGrid:Add("DSubmenuButtonTTT2")
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

		HELPSCRN:SetupContentArea(contentArea, menuTbl[1])
		HELPSCRN:BuildContentArea()

		-- handle the set of active buttons for the draw process
		navAreaScrollGrid:GetChild(0):SetActive()

		lastActive = navAreaScrollGrid:GetChild(0)
	end

	-- REGISTER REBUILD CALLBACK
	frame.OnRebuild = function(slf)
		-- do not rebuild if the main menu is open, only if submenu is open
		if HELPSCRN.currentMenuId == MAIN_MENU then return end

		HELPSCRN:BuildContentArea()
	end
end

---
-- Unhides the helpscreen if it was hidden.
-- @realm client
function HELPSCRN:Unhide()
	if not self.menuFrame or not self.menuFrame:IsFrameHidden() then return end

	self.menuFrame:ShowFrame()
end

local function ShowTTTHelp(ply, cmd, args)
	-- F1 PRESSED: CLOSE MAIN MENU IF MENU IS ALREADY OPENED
	if HELPSCRN.currentMenuId == MAIN_MENU and IsValid(HELPSCRN.menuFrame) and not HELPSCRN.menuFrame:IsFrameHidden() then
		HELPSCRN.menuFrame:CloseFrame()

		return
	end

	-- F1 PRESSED AND MENU IS HIDDEN: UNHIDE
	if HELPSCRN.currentMenuId and IsValid(HELPSCRN.menuFrame) and HELPSCRN.menuFrame:IsFrameHidden() then
		HELPSCRN.menuFrame:ShowFrame()

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
-- @param string currentMenuId The name of the opened submenu
-- @param table lastMenuData The menu data of the menu that will be closed
-- @param table menuData The menu data of the menu that will be opened
-- @hook
-- @realm client
function GM:TTT2OnHelpSubmenuClear(parent, currentMenuId, lastMenuData, menuData)

end

---
-- A hook that is used to popuplate and modify the contents of the main help menu.
-- @param HELP_MENU_DATA helpData A reference to the menu data object
-- @hook
-- @realm client
function GM:TTT2ModifyHelpMainMenu(helpData)

end

---
-- A hook that is used to popuplate and modify the contents of the sub help menu.
-- @param HELP_MENU_DATA helpData A reference to the sub menu data object
-- @param string menuId The id of the currently opened menu
-- @hook
-- @realm client
function GM:TTT2ModifyHelpSubmenu(helpData, menuId)

end
