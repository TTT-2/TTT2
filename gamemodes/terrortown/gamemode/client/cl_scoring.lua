---
-- @class CLSCORE
-- @desc Game report at round end
-- @author Mineotopia

local vskin = vskin

local materialInfo = Material("vgui/ttt/vskin/roundend/info")
local materialEvents = Material("vgui/ttt/vskin/roundend/events")
local materialScores = Material("vgui/ttt/vskin/roundend/scores")

local sizes = {
	width = 1200,
	height = 700,
	padding = 10
}

local function PopulateInfoPanel(parent)
	print("INFO")
end

local function PopulateEventsPanel(parent)
	print("EVENTS")
end

local function PopulateScoresPanel(parent)
	print("SCORES")
end

local function InternalModifyRoundendMenu(panelData)
	local infoPanel = panelData:RegisterSubMenu("roundend_info")

	infoPanel:SetTitle("title")
	infoPanel:SetIcon(materialInfo)
	infoPanel:PopulatePanel(PopulateInfoPanel)

	local eventsPanel = panelData:RegisterSubMenu("roundend_events")

	eventsPanel:SetTitle("title")
	eventsPanel:SetIcon(materialEvents)
	eventsPanel:PopulatePanel(PopulateEventsPanel)

	local scoresPanel = panelData:RegisterSubMenu("roundend_scores")

	scoresPanel:SetTitle("title")
	scoresPanel:SetIcon(materialScores)
	scoresPanel:PopulatePanel(PopulateScoresPanel)
end

CLSCORE = {}

function CLSCORE:CalculateSizes()
	sizes.heightMainArea = sizes.height - 2 * sizes.padding
	sizes.widthMenu = 50 + vskin.GetBorderSize()
	sizes.widthMainArea = sizes.width - sizes.widthMenu - 2 * sizes.padding
	sizes.heightButton = 45
	sizes.widthButton = 175
	sizes.heightBottomButtonPanel = sizes.heightButton + sizes.padding + 1
	sizes.heightContent = sizes.heightMainArea - sizes.heightBottomButtonPanel
	sizes.heightMenuButton = 50
end

function CLSCORE:CreatePanel()
	self:CalculateSizes()

	-- GENERATE MENU CONTENT
	local menuTbl = {}
	local panelData = menuDataHandler.CreateNewRoundendMenu()

	panelData:BindData(menuTbl)

	InternalModifyRoundendMenu(panelData)

	-- RUN HOOK TO ADD DATA TO MENU
	hook.Run("TTT2ModifyRoundEndMenu", panelData)

	local frame = vguihandler.GenerateFrame(sizes.width, sizes.height, "report_title", true)

	frame:SetPadding(0, 0, 0, 0)
	frame:CloseButtonClickOverride(function()
		self:HidePanel()
	end)

	-- LEFT HAND MENU STRIP
	local menuBox = vgui.Create("DPanelTTT2", frame)
	menuBox:SetSize(sizes.widthMenu, sizes.heightMainArea)
	menuBox:DockMargin(0, sizes.padding, 0, sizes.padding)
	menuBox:Dock(LEFT)
	menuBox.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "VerticalBorderedBoxTTT2", slf, w, h)

		return false
	end

	local menuBoxGrid = vgui.Create("DIconLayout", menuBox)
	menuBoxGrid:Dock(FILL)
	menuBoxGrid:SetSpaceY(sizes.padding)

	-- RIGHT HAND MAIN AREA
	local mainBox = vgui.Create("DPanelTTT2", frame)
	mainBox:SetSize(sizes.widthMainArea, sizes.heightMainArea)
	mainBox:DockMargin(sizes.padding, sizes.padding, sizes.padding, sizes.padding)
	mainBox:Dock(RIGHT)

	local contentBox = vgui.Create("DPanelTTT2", mainBox)
	contentBox:SetSize(sizes.widthMainArea, sizes.heightContent)
	contentBox:Dock(TOP)

	local buttonArea = vgui.Create("DButtonPanelTTT2", mainBox)
	buttonArea:SetSize(sizes.widthMainArea, sizes.heightBottomButtonPanel)
	buttonArea:Dock(BOTTOM)

	local buttonSave = vgui.Create("DButtonTTT2", buttonArea)
	buttonSave:SetText("report_save")
	buttonSave:SetSize(sizes.widthButton, sizes.heightButton)
	buttonSave:SetPos(0, sizes.padding + 1)
	buttonSave.DoClick = function(btn)
		self:SaveLog()
	end

	local buttonClose = vgui.Create("DButtonTTT2", buttonArea)
	buttonClose:SetText("close")
	buttonClose:SetSize(sizes.widthButton, sizes.heightButton)
	buttonClose:SetPos(sizes.widthMainArea - 175, sizes.padding + 1)
	buttonClose.DoClick = function(btn)
		self:HidePanel()
	end

	-- POPULATE SIDEBAR PANEL
	local lastActive

	for i = 1, #menuTbl do
		local data = menuTbl[i]

		local menuButton = menuBoxGrid:Add("DSubMenuButtonTTT2")
		menuButton:SetSize(sizes.widthMenu - 1, sizes.heightMenuButton)
		menuButton:SetIcon(data.iconMat)
		menuButton:SetTooltip(data.title)
		menuButton.DoClick = function(slf)
			contentBox:Clear()

			if isfunction(data.populateFn) then
				data.populateFn(contentBox)
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
	if isfunction(menuTbl[1].populateFn) then
		menuTbl[1].populateFn(contentBox)
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

end

---
-- Initializes the score @{Panel}
-- @param table eventTable The list of eventTable
-- @realm client
-- @internal
function CLSCORE:Init(eventTable)
	self.events = eventTable
	self.eventsSorted = events.SortByPlayerAndEvent()

	-- now iterate over the event table to get an instant access
	-- to the important data
	for i = 1, #eventTable do
		local event = eventTable[i]

		if event == EVENT_SELECTED then
			self.playerInitialRoles = event.plys
		elseif event == EVENT_FINISH then
			self.playerFinalRoles = event.plys
			self.wintype = event.wintype
		end
	end
end

---
-- Resets the old score @{Panel}, initializes a new one and displays it to the local @{Player}
-- @param table eventTable A list of eventTable that should be reported
-- @realm client
-- @internal
function CLSCORE:ReportEvents(eventTable)
	self:Reset()

	self:Init(eventTable)
	self:ShowPanel()
end

---
-- Toggles the visibility of the current score @{Panel}
-- @realm client
-- @internal
function CLSCORE:Toggle()
	if self:IsPanelHidden() then
		self:ShowPanel()
	else
		self:HidePanel()
	end
end

---
-- Used to modify the roundend screen menu by adding custom submenues to it.
-- @param ROUNDEND_MENU_DATA panelData The already existing panel data
function GM:TTT2ModifyRoundEndMenu(panelData)

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
