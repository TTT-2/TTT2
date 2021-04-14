---
-- Game Report
-- @class CLSCORE
-- @desc Game report at round end
-- @author Mineotopia

local vskin = vskin

local function CreateColumns(plys)
	local teamsTbl = {}
	local index = 1
	local direction = 1

	local colTbl = {
		{},
		{},
		{}
	}
	local colTeamsTbl = {
		{},
		{},
		{}
	}

	for i = 1, #plys do
		local ply = plys[i]

		if not teamsTbl[ply.team] then
			print(tostring(ply.team))

			teamsTbl[ply.team] = {}
		end

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

	MsgN("Added TTT2 score menu file: ", path, name)
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
	if subMenu.type == "base_scoremenu" then continue end

	subMenusIndexed[#subMenusIndexed + 1] = subMenu
end

table.SortByMember(subMenusIndexed, "priority")

CLSCORE = CLSCORE or {}
CLSCORE.sizes = {}

function CLSCORE:CalculateSizes()
	self.sizes.width = 1200
	self.sizes.height = 700
	self.sizes.padding = 10
	self.sizes.paddingSmall = 0.5 * self.sizes.padding

	self.sizes.heightMainArea = self.sizes.height - 2 * self.sizes.padding
	self.sizes.widthMenu = 50 + vskin.GetBorderSize()
	self.sizes.widthMainArea = self.sizes.width - self.sizes.widthMenu - 2 * self.sizes.padding

	self.sizes.heightHeaderPanel = 100
	self.sizes.widthTopButton = 140
	self.sizes.heightTopButton = 30
	self.sizes.widthTopLabel = 0.5 * self.sizes.widthMainArea - self.sizes.widthTopButton - self.sizes.padding
	self.sizes.heightTopButtonPanel = self.sizes.heightTopButton + 2 * self.sizes.padding
	self.sizes.heightRow = 25
	self.sizes.heightTitleRow = 30

	self.sizes.heightButton = 45
	self.sizes.widthButton = 175
	self.sizes.heightBottomButtonPanel = self.sizes.heightButton + self.sizes.padding + 1
	self.sizes.heightContent = self.sizes.heightMainArea - self.sizes.heightBottomButtonPanel - vskin.GetHeaderHeight() - vskin.GetBorderSize()
	self.sizes.heightMenuButton = 50
end

function CLSCORE:CreatePanel()
	self:CalculateSizes()

	local frame = vguihandler.GenerateFrame(self.sizes.width, self.sizes.height, "report_title", true)

	frame:SetPadding(0, 0, 0, 0)
	frame:CloseButtonClickOverride(function()
		self:HidePanel()
	end)

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
	mainBox:DockMargin(self.sizes.padding, self.sizes.padding, self.sizes.padding, self.sizes.padding)
	mainBox:Dock(RIGHT)

	local contentBox = vgui.Create("DPanelTTT2", mainBox)
	contentBox:SetSize(self.sizes.widthMainArea, self.sizes.heightContent)
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
	buttonClose:SetPos(self.sizes.widthMainArea - 175, self.sizes.padding + 1)
	buttonClose.DoClick = function(btn)
		self:HidePanel()
	end

	-- POPULATE SIDEBAR PANEL
	local lastActive

	for i = 1, #subMenusIndexed do
		local data = subMenusIndexed[i]

		local menuButton = menuBoxGrid:Add("DSubMenuButtonTTT2")
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
-- Displays the score @{Panel} for the local @{Player}
-- @realm client
function CLSCORE:ShowPanel()
	if not IsValid(self.panel) then
		self.panel = CLSCORE:CreatePanel()
	end

	self.panel:ShowFrame()
end

function CLSCORE:HidePanel()
	if not IsValid(self.panel) then return end

	self.panel:HideFrame()
end

function CLSCORE:IsPanelHidden()
	if IsValid(self.panel) then
		return self.panel:IsFrameHidden()
	else
		return true
	end
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
-- @note The logfiles are stored in <code>ttt/logs</code>
-- @realm client
-- @internal
function CLSCORE:SaveLog()

end

---
-- Resets the stored data of the current score @{Panel}, currently done in @{GM:TTTBeginRound}
-- @realm client
-- @internal
function CLSCORE:Reset()
	self:ClearPanel()
end

---
-- Initializes the score @{Panel} and prepares the needed data
-- @realm client
-- @internal
function CLSCORE:Init()
	self.events = events.GetEventList()
	self.eventsSorted = events.SortByPlayerAndEvent()
	self.eventsInfoData = eventdata.GetPlayerEndRoles() -- TODO needed?
	self.eventsInfoScores = events.GetPlayerTotalScores()

	-- now iterate over the event table to get an instant access
	-- to the important data
	for i = 1, #self.events do
		local event = self.events[i]

		if event.type == EVENT_FINISH then
			self.wintype = event.event.wintype
			self.eventsInfoPlayers = event.event.plys
		end
	end

	-- prepare info screen data into sorted groups
	self.eventsInfoColumnData, self.eventsInfoColumnTeams = CreateColumns(self.eventsInfoPlayers)

	-- get data for info title
	self.eventsInfoTitleText, self.eventsInfoTitleColor = self:GetWinData()
end

---
-- Resets the old score @{Panel}, initializes a new one and displays it to the local @{Player}
-- @param table eventTable A list of eventTable that should be reported
-- @realm client
-- @internal
function CLSCORE:ReportEvents()
	self:Reset()

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

	if wintype == WIN_TIMELIMIT then
		return "hilite_win_time", COLOR_LBROWN
	elseif wintype == WIN_NONE then
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
	--TODO remove
	self:ClearPanel()

	if self:IsPanelHidden() then
		self:ShowPanel()
	else
		self:HidePanel()
	end
end

-- TODO: Remove before release
concommand.Add("scp", function()
	CLSCORE:Toggle()
end)

-- compatibbility for now
CLSCORE.EventDisplay = {}

---
-- Tell CLSCORE how to display an event. See @{file/cl_scoring_events.lua} for examples.
-- @param number event_id
-- @param table event_fns The event table @{function}s. Pass an empty table to keep an event from showing up.
-- @realm client
-- @module CLSCORE
function CLSCORE.DeclareEventDisplay(event_id, event_fns)
	if not event_fns or not istable(event_fns) then
		error(string.format("Event %d display: no display functions found.", event_id), 2)
	end

	if not event_fns.text then
		error(string.format("Event %d display: no text display function found.", event_id), 2)
	end

	if not event_fns.icon then
		error(string.format("Event %d display: no icon and tooltip display function found.", event_id), 2)
	end

	CLSCORE.EventDisplay[event_id] = event_fns
end
