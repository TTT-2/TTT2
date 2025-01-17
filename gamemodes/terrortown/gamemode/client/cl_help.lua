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

    Dev(1, "Added TTT2 gamemode submenu file: ", path, name)
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

    Dev(1, "Added TTT2 gamemode menu file: ", path, name)
end

-- initialize the submenus after they were loaded
local function InitSubmenu(class, path, name)
    class:Initialize()
end

-- once the classes are set up and inherited from their base, they
-- are ready to be used, i.e. their submenus can be added
local function LoadSubmenus(class, path, name)
    -- do not load the submenu base again
    if name == "base_gamemodemenu" then
        return
    end

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
        if submenu.type == "base_gamemodesubmenu" then
            continue
        end

        submenusIndexed[#submenusIndexed + 1] = submenu
    end

    table.SortByMember(submenusIndexed, "priority")

    class:SetSubmenuTable(submenusIndexed)

    class:Initialize()
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
    if menu.type == "base_gamemodemenu" then
        continue
    end

    menusIndexed[#menusIndexed + 1] = menu
end

table.SortByMember(menusIndexed, "priority")

-- END load help menu classes

-- SET UP HELPSCRN AND INCLUDE ADDITIONAL FILES
HELPSCRN = HELPSCRN or {}

HELPSCRN.populate = HELPSCRN.populate or {}
HELPSCRN.subPopulate = HELPSCRN.subPopulate or {}
HELPSCRN.currentMenuId = HELPSCRN.currentMenuId or nil
HELPSCRN.parent = HELPSCRN.parent or nil
HELPSCRN.submenuClass = HELPSCRN.submenuClass or nil
HELPSCRN.menuFrame = HELPSCRN.menuFrame or nil

HELPSCRN.padding = 5

-- define sizes
local width, height = 1100, 700
local heightMainMenuButton = 120

local widthNav = 300
local widthContent, heightContent = 800, 700
local heightButtonPanel = 80
local heightAdminSeperator = 50

local function AddMenuButtons(menuTbl, parent, widthButton, heightButton)
    for i = 1, #menuTbl do
        local menuClass = menuTbl[i]

        local settingsButton = parent:Add("DMenuButtonTTT2")
        settingsButton:SetSize(widthButton, heightButton)
        settingsButton:SetTitle(menuClass.title or menuClass.type)
        settingsButton:SetDescription(menuClass.description)
        settingsButton:SetImage(menuClass.icon)

        settingsButton.DoClick = function(slf)
            HELPSCRN:ShowSubmenu(menuClass)
        end
    end
end

-- since the main menu has no ID, it has this static ID
local MAIN_MENU = "main"

---
-- Opens the help screen
-- @realm client
function HELPSCRN:ShowMainMenu()
    local frame = self.menuFrame

    -- IF MENU ELEMENT DOES NOT ALREADY EXIST, CREATE IT
    if IsValid(frame) then
        frame:ClearFrame(nil, nil, "help_title")
    else
        frame = vguihandler.GenerateFrame(width, height, "help_title")
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

    -- SPLIT INTO NORMAL AND ADMIN MENUS
    local menusNormal, menusAdmin = {}, {}

    for i = 1, #menusIndexed do
        local menu = menusIndexed[i]

        if not menu:ShouldShow() then
            continue
        end

        if menu:IsAdminMenu() then
            menusAdmin[#menusAdmin + 1] = menu
        else
            menusNormal[#menusNormal + 1] = menu
        end
    end

    local rows = math.ceil(#menusNormal / 3) + math.ceil(#menusAdmin / 3)
    local maxHeight = rows * heightMainMenuButton
        + (rows - 1) * self.padding
        + ((#menusAdmin == 0) and 0 or heightAdminSeperator)
    local heightScroll = height - vskin.GetHeaderHeight() - vskin.GetBorderSize() - 2 * self.padding

    local scrollSize = (heightScroll < maxHeight and 20 or 0)

    local widthMainMenuButton = (width - 4 * self.padding - scrollSize) / 3

    AddMenuButtons(menusNormal, dsettings, widthMainMenuButton, heightMainMenuButton)

    -- only show admin section if player is admin and
    -- there are menues to be shown
    if #menusAdmin == 0 then
        return
    end

    local labelSpacer = dsettings:Add("DLabelTTT2")
    labelSpacer.OwnLine = true
    labelSpacer:SetText("label_menu_admin_spacer")
    labelSpacer:SetSize(width - 2 * self.padding - scrollSize, heightAdminSeperator)
    labelSpacer:SetFont("DermaTTT2TextLarge")
    labelSpacer.Paint = function(slf, w, h)
        derma.SkinHook("Paint", "LabelSpacerTTT2", slf, w, h)

        return true
    end

    AddMenuButtons(menusAdmin, dsettings, widthMainMenuButton, heightMainMenuButton)
end

---
-- @see HELPSCRN:ShowMainMenu()
-- @realm client
-- @function HELPSCRN:Show()
HELPSCRN.Show = HELPSCRN.ShowMainMenu

---
-- Returns the name of the currently opened menu, returns nil if no menu is opened.
-- @return[default=nil] string The id of the opened menu or nil
-- @realm client
function HELPSCRN:GetOpenMenu()
    if not self:IsVisible() then
        return
    end

    if self.currentMenuId == MAIN_MENU then
        return MAIN_MENU
    end

    return self.currentMenuId .. "_" .. self.submenuClass.type
end

---
-- Sets up the data for the content area without actually building the area.
-- @param Panel parent The parent panel
-- @param table submenuClass The submenu class
-- @realm client
function HELPSCRN:SetupContentArea(parent, submenuClass)
    self.parent = parent
    self.lastSubmenuClass = self.submenuClass
    self.submenuClass = submenuClass
end

---
-- Builds the content area, the data has to be set previously.
-- @realm client
function HELPSCRN:BuildContentArea()
    local parent = self.parent

    if not IsValid(parent) then
        return
    end

    ---
    -- @realm client
    if
        hook.Run(
            "TTT2OnHelpSubmenuClear",
            parent,
            self.currentMenuId,
            self.lastMenuData,
            self.submenuClass
        ) == false
    then
        return
    end

    parent:Clear()

    local width2, height2 = parent:GetSize()
    local _, paddingTop, _, paddingBottom = parent:GetDockPadding()

    -- CALCULATE SIZE BASED ON EXISTENCE OF BUTTON PANEL
    if self.submenuClass:HasButtonPanel() then
        height2 = height2 - heightButtonPanel
    end

    -- ADD CONTENT BOX AND CONTENT
    local contentAreaScroll = vgui.Create("DScrollPanelTTT2", parent)
    contentAreaScroll:SetVerticalScrollbarEnabled(true)
    contentAreaScroll:SetSize(width2, height2 - paddingTop - paddingBottom)
    contentAreaScroll:Dock(TOP)

    self.submenuClass:Populate(contentAreaScroll)

    -- ADD BUTTON BOX AND BUTTONS
    if self.submenuClass:HasButtonPanel() then
        local buttonArea = vgui.Create("DButtonPanelTTT2", parent)
        buttonArea:SetSize(width2, heightButtonPanel)
        buttonArea:Dock(BOTTOM)

        self.submenuClass:PopulateButtonPanel(buttonArea)
    end
end

---
-- Opens the help sub screen.
-- @param table menuClass The class of the submenu
-- @realm client
function HELPSCRN:ShowSubmenu(menuClass)
    local frame = self.menuFrame

    -- IF MENU ELEMENT DOES NOT ALREADY EXIST, CREATE IT
    if IsValid(frame) then
        frame:ClearFrame(nil, nil, menuClass.title or menuClass.type)
    else
        frame = vguihandler.GenerateFrame(width, height, menuClass.title or menuClass.type)
    end

    -- INIT SUB MENU SPECIFIC STUFF
    frame:ShowBackButton(true)
    frame:SetPadding(0, 0, 0, 0)

    frame:RegisterBackFunction(function()
        self:ShowMainMenu()
    end)

    -- MARK AS SUBMENU
    self.currentMenuId = menuClass.type

    -- BUILD GENERAL BOX STRUCTURE
    local navArea = vgui.Create("DNavPanelTTT2", frame)
    navArea:SetWide(widthNav)
    navArea:SetPos(0, 0)
    navArea:DockPadding(0, 0, 1, 0)
    navArea:Dock(LEFT)

    local contentArea = vgui.Create("DContentPanelTTT2", frame)
    contentArea:SetSize(
        widthContent,
        heightContent - vskin.GetHeaderHeight() - vskin.GetBorderSize()
    )
    contentArea:SetPos(widthNav, 0)
    contentArea:DockPadding(self.padding, self.padding, self.padding, self.padding)
    contentArea:Dock(TOP)

    -- MAKE SEPARATE SUBMENULIST ON THE NAVAREA WITH A CONTENT AREA
    local submenuList = vgui.Create("DSubmenuListTTT2", navArea)
    submenuList:Dock(FILL)
    submenuList:SetPadding(self.padding)
    submenuList:SetBasemenuClass(menuClass, contentArea)
    if menuClass.searchBarPlaceholderText then
        submenuList:SetSearchBarPlaceholderText(menuClass.searchBarPlaceholderText)
    end

    -- REFRESH SIZE OF SUBMENULIST FOR CORRECT SUBMENU DEPENDENT SIZE
    submenuList:InvalidateLayout(true)

    -- REGISTER REBUILD CALLBACK
    frame.OnRebuild = function(slf)
        -- do not rebuild if the main menu is open, only if submenu is open
        if HELPSCRN.currentMenuId == MAIN_MENU then
            return
        end

        HELPSCRN:BuildContentArea()
    end
end

---
-- Unhides the helpscreen if it was hidden.
-- @realm client
function HELPSCRN:Unhide()
    if not self.menuFrame or not self.menuFrame:IsFrameHidden() then
        return
    end

    self.menuFrame:ShowFrame()
end

---
-- Checks whether there is a valid menu frame object to see if the menu is visible.
-- @note This also returns true if the menu is hidden but not destroyed (e.g. while using the HUD editor).
-- @return boolean Returns true if the menu is visible
-- @realm client
function HELPSCRN:IsVisible()
    return IsValid(self.menuFrame)
end

local function ShowTTTHelp(ply, cmd, args)
    -- F1 PRESSED: CLOSE MAIN MENU IF MENU IS ALREADY OPENED
    if
        HELPSCRN.currentMenuId == MAIN_MENU
        and HELPSCRN:IsVisible()
        and not HELPSCRN.menuFrame:IsFrameHidden()
    then
        HELPSCRN.menuFrame:CloseFrame()

        return
    end

    -- F1 PRESSED AND MENU IS HIDDEN: UNHIDE
    if
        HELPSCRN.currentMenuId
        and IsValid(HELPSCRN.menuFrame)
        and HELPSCRN.menuFrame:IsFrameHidden()
    then
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
-- @param table submenuClass The menu data of the menu that will be opened
-- @hook
-- @realm client
function GM:TTT2OnHelpSubmenuClear(parent, currentMenuId, lastMenuData, submenuClass) end
