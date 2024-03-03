---
-- Game Report
-- @class CLSCORE
-- @desc Game report at round end
-- @author Mineotopia

local vskin = vskin
local TryT = LANG.TryTranslation

local function CreateColumns(plys)
    local teamsTbl = {}
    local index = 1
    local direction = 1

    local colTbl = {
        {},
        {},
        {},
    }
    local colTeamsTbl = {
        {},
        {},
        {},
    }

    for i = 1, #plys do
        local ply = plys[i]

        teamsTbl[ply.team] = teamsTbl[ply.team] or {}

        teamsTbl[ply.team][#teamsTbl[ply.team] + 1] = ply
    end

    for i = 1, table.Count(teamsTbl) do
        if index == 4 then
            direction = -1
            index = 3
        end

        if index == 0 then
            direction = 1
            index = 1
        end

        local plyTable, team = table.GetAndRemoveBiggestSubTable(teamsTbl)

        colTbl[index][#colTbl[index] + 1] = plyTable
        colTeamsTbl[index][#colTeamsTbl[index] + 1] = team

        index = index + direction
    end

    return colTbl, colTeamsTbl
end

-- load score menu pages
local function ShouldInherit(t, base)
    return t.base ~= t.type
end

local function OnInitialization(class, path, name)
    class.type = name
    class.base = class.base or "base_scoremenu"

    Dev(1, "Added TTT2 score menu file: ", path, name)
end

local subMenus = classbuilder.BuildFromFolder(
    "terrortown/menus/score/",
    CLIENT_FILE,
    "CLSCOREMENU", -- class scope
    OnInitialization, -- on class loaded
    true, -- should inherit
    ShouldInherit -- special inheritance check
)

-- transfer subMenus into indexed table
local subMenusIndexed = {}

for _, subMenu in pairs(subMenus) do
    if subMenu.type == "base_scoremenu" then
        continue
    end

    subMenusIndexed[#subMenusIndexed + 1] = subMenu
end

table.SortByMember(subMenusIndexed, "priority")

CLSCORE = CLSCORE or {}
CLSCORE.sizes = {}

---
-- Precalculates the sizes needed for the UI.
-- @internal
-- @realm client
function CLSCORE:CalculateSizes()
    self.sizes.width = 1200
    self.sizes.height = 700
    self.sizes.padding = 10
    self.sizes.paddingSmall = 0.5 * self.sizes.padding

    self.sizes.widthMenu = 50 + vskin.GetBorderSize()

    local doublePadding = 2 * self.sizes.padding

    self.sizes.heightMainArea = self.sizes.height
        - doublePadding
        - vskin.GetHeaderHeight()
        - vskin.GetBorderSize()
    self.sizes.widthMainArea = self.sizes.width - self.sizes.widthMenu - doublePadding

    self.sizes.heightHeaderPanel = 120
    self.sizes.widthTopButton = 140
    self.sizes.heightTopButton = 30
    self.sizes.widthTopLabel = 0.5 * self.sizes.widthMainArea
        - self.sizes.widthTopButton
        - self.sizes.padding
    self.sizes.heightTopButtonPanel = self.sizes.heightTopButton + doublePadding
    self.sizes.heightRow = 25
    self.sizes.heightTitleRow = 30

    self.sizes.heightButton = 45
    self.sizes.widthButton = 175
    self.sizes.heightBottomButtonPanel = self.sizes.heightButton + self.sizes.padding + 1
    self.sizes.heightContentLarge = self.sizes.heightMainArea
        - self.sizes.heightBottomButtonPanel
        - self.sizes.heightTopButtonPanel
        - 3 * self.sizes.padding
    self.sizes.heightContent = self.sizes.heightContentLarge - self.sizes.heightHeaderPanel
    self.sizes.heightMenuButton = 50

    self.sizes.widthKarma = 50
    self.sizes.widthScore = 35
end

---
-- Creates the score @{Panel} for the local @{Player}.
-- @internal
-- @realm client
function CLSCORE:CreatePanel()
    self:CalculateSizes()

    local frame = vguihandler.GenerateFrame(self.sizes.width, self.sizes.height, "report_title")

    frame:SetPadding(0, 0, 0, 0)
    frame:CloseButtonClickOverride(function()
        self:HidePanel()
    end)

    frame.IsBlockingBindings = function(slf)
        return self:IsBlockingBindings()
    end

    -- LEFT HAND MENU STRIP
    local menuBox = vgui.Create("DPanelTTT2", frame)
    menuBox:SetSize(self.sizes.widthMenu, self.sizes.heightMainArea)
    menuBox:DockMargin(0, self.sizes.padding, 0, self.sizes.padding)
    menuBox:Dock(LEFT)
    menuBox.Paint = function(slf, w, h)
        derma.SkinHook("Paint", "VerticalBorderedBoxTTT2", slf, w, h)

        return false
    end

    local menuBoxGrid = vgui.Create("DIconLayout", menuBox)
    menuBoxGrid:Dock(FILL)
    menuBoxGrid:SetSpaceY(self.sizes.padding)

    -- RIGHT HAND MAIN AREA
    local mainBox = vgui.Create("DPanelTTT2", frame)
    mainBox:SetSize(self.sizes.widthMainArea, self.sizes.heightMainArea)
    mainBox:DockMargin(
        self.sizes.padding,
        self.sizes.padding,
        self.sizes.padding,
        self.sizes.padding
    )
    mainBox:Dock(RIGHT)

    local contentBox = vgui.Create("DPanelTTT2", mainBox)
    contentBox:SetSize(self.sizes.widthMainArea, self.sizes.heightMainArea)
    contentBox:Dock(TOP)

    local buttonArea = vgui.Create("DButtonPanelTTT2", mainBox)
    buttonArea:SetSize(self.sizes.widthMainArea, self.sizes.heightBottomButtonPanel)
    buttonArea:Dock(BOTTOM)

    local buttonSave = vgui.Create("DButtonTTT2", buttonArea)
    buttonSave:SetText("report_save")
    buttonSave:SetSize(self.sizes.widthButton, self.sizes.heightButton)
    buttonSave:SetPos(0, self.sizes.padding + 1)
    buttonSave.DoClick = function(btn)
        self:SaveLog()
    end

    local buttonClose = vgui.Create("DButtonTTT2", buttonArea)
    buttonClose:SetText("close")
    buttonClose:SetSize(self.sizes.widthButton, self.sizes.heightButton)
    buttonClose:SetPos(self.sizes.widthMainArea - self.sizes.widthButton, self.sizes.padding + 1)
    buttonClose.DoClick = function(btn)
        self:HidePanel()
    end

    -- POPULATE SIDEBAR PANEL
    local lastActive

    for i = 1, #subMenusIndexed do
        local data = subMenusIndexed[i]

        local menuButton = menuBoxGrid:Add("DSubmenuButtonTTT2")
        menuButton:SetSize(self.sizes.widthMenu - 1, self.sizes.heightMenuButton)
        menuButton:SetIcon(data.icon)
        menuButton:SetTooltip(data.title)
        menuButton.DoClick = function(slf)
            contentBox:Clear()

            if isfunction(data.Populate) then
                data:Populate(contentBox)
            end

            slf:SetActive(true)
            lastActive:SetActive(false)
            lastActive = slf
        end

        if i == 1 then
            menuButton:SetActive(true)
            lastActive = menuButton
        end
    end

    -- load initial menu
    if isfunction(subMenusIndexed[1].Populate) then
        subMenusIndexed[1]:Populate(contentBox)
    end

    return frame
end

---
-- Displays the score @{Panel} for the local @{Player}.
-- @realm client
-- @internal
function CLSCORE:ShowPanel()
    if not IsValid(self.panel) then
        self.panel = CLSCORE:CreatePanel()
    end

    self.panel:ShowFrame()
end

---
-- Hides a @{Panel} without closing it.
-- @realm client
function CLSCORE:HidePanel()
    if not IsValid(self.panel) then
        return
    end

    self.panel:HideFrame()
end

---
-- Checks if there is an existing @{Panel} hidden
-- @return boolean Returns true if a @{Panel} is hidden
-- @realm client
function CLSCORE:IsPanelHidden()
    if IsValid(self.panel) then
        return self.panel:IsFrameHidden()
    else
        return true
    end
end

---
-- Checks if this panel should block TTT2 Binds
-- @return boolean True if this frame blocks TTT2 Binds
-- @realm client
function CLSCORE:IsBlockingBindings()
    return false
end

---
-- Clears the current score @{Panel} and removes it
-- @realm client
-- @internal
function CLSCORE:ClearPanel()
    if IsValid(self.panel) then
        self.panel:CloseFrame()
    end
end

---
-- Saves the current score @{Panel}'s data into a log file
-- @note The logfiles are stored in <code>terrortown/logs</code>
-- @realm client
-- @internal
function CLSCORE:SaveLog()
    local events = self.events

    if not events or #events == 0 then
        chat.AddText(COLOR_WHITE, TryT("report_save_error"))

        return
    end

    local logdir = "terrortown/logs"

    if not file.IsDir(logdir, "DATA") then
        file.CreateDir(logdir)
    end

    local logname = logdir .. "/ttt_events_" .. os.time() .. ".txt"
    local log = "Trouble in Terrorist Town 2 - Round Events Log\n" .. string.rep("-", 50) .. "\n"

    log = log
        .. string.format("%s | %-15s | %s\n", " TIME  ", "TYPE", "WHAT HAPPENED")
        .. string.rep("-", 50)
        .. "\n"

    for i = 1, #events do
        local event = events[i]

        if event.event.roundState ~= ROUND_ACTIVE then
            continue
        end

        local time = event:GetTime()
        local minutes = math.floor(time / 60)
        local seconds = math.floor(time % 60)

        log = log
            .. string.format(
                "[%02d:%02d] | %-15s | %s\n",
                minutes,
                seconds,
                event.type,
                event:Serialize() or ""
            )
    end

    file.Write(logname, log)

    chat.AddText(
        COLOR_WHITE,
        TryT("report_save_result"),
        COLOR_GREEN,
        " /garrysmod/data/" .. logname
    )
end

---
-- Initializes the score @{Panel} and prepares the needed data
-- @realm client
-- @internal
function CLSCORE:Init()
    self.events = events.GetEventList()
    self.eventsSorted = events.SortByPlayerAndEvent()
    self.eventsInfoScores = eventdata.GetPlayerTotalScores()
    self.eventsInfoKarma = eventdata.GetPlayerTotalKarma()
    self.eventsPlayerRoles = eventdata.GetPlayerRoles()
    self.eventsPlayerScores = eventdata.GetPlayerScores()
    self.eventsPlayerKarma = eventdata.GetPlayerKarma()

    -- now iterate over the event table to get an instant access
    -- to the important data
    for i = 1, #self.events do
        local event = self.events[i]

        if event.type == EVENT_SELECTED then
            self.eventsInfoPlayersStart = {}

            local plys = event.event.plys

            for k = 1, #plys do
                local ply = plys[k]

                if ply.role == ROLE_NONE then
                    continue
                end

                self.eventsInfoPlayersStart[#self.eventsInfoPlayersStart + 1] = ply
            end
        end

        if event.type == EVENT_FINISH then
            self.wintype = event.event.wintype
            self.eventsInfoPlayersEnd = {}

            local plys = event.event.plys

            for k = 1, #plys do
                local ply = plys[k]

                if ply.role == ROLE_NONE then
                    continue
                end

                self.eventsInfoPlayersEnd[#self.eventsInfoPlayersEnd + 1] = ply
            end
        end
    end

    -- prepare info screen data into sorted groups
    self.eventsInfoColumnDataStart, self.eventsInfoColumnTeamsStart =
        CreateColumns(self.eventsInfoPlayersStart)
    self.eventsInfoColumnDataEnd, self.eventsInfoColumnTeamsEnd =
        CreateColumns(self.eventsInfoPlayersEnd)

    -- get data for info title
    self.eventsInfoTitleText, self.eventsInfoTitleColor = self:GetWinData()
end

---
-- ClearPanels the old score @{Panel}, initializes a new one and displays it to the local @{Player}
-- @realm client
-- @internal
function CLSCORE:ReportEvents()
    self:ClearPanel()

    self:Init()
    self:ShowPanel()
end

---
-- Converts the wintype into title data.
-- @internal
-- @return string The title text string
-- @return Color The background color for the title box
-- @realm client
function CLSCORE:GetWinData()
    local wintype = self.wintype

    -- convert default TTT win conditions
    if wintype == WIN_TRAITOR then
        wintype = TEAM_TRAITOR
    elseif wintype == WIN_INNOCENT then
        wintype = TEAM_INNOCENT
    end

    if wintype == WIN_TIMELIMIT then
        return "hilite_win_time", COLOR_LBROWN
    elseif wintype == TEAM_NONE then -- make it a tie
        return "hilite_win_tie", COLOR_LBROWN
    else
        return "hilite_win_" .. wintype, TEAMS[wintype].color
    end
end

---
-- Toggles the visibility of the current score @{Panel}
-- @realm client
-- @internal
function CLSCORE:Toggle()
    -- if no round has happened yet, the menu can't be opened
    if not self.events then
        return
    end

    if self:IsPanelHidden() then
        self:ShowPanel()
    else
        self:HidePanel()
    end
end

bind.Register("toggle_clscore", function()
    CLSCORE:Toggle()
end, nil, "header_bindings_ttt2", "label_bind_clscore")
