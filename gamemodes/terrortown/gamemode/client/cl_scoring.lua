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

end

local function PopulateEventsPanel(parent)

end

local function PopulateScoresPanel(parent)

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
	sizes.heightContent = sizes.height - 2 * sizes.padding
	sizes.widthMenu = 50 + vskin.GetBorderSize()
	sizes.widthContent = sizes.width - sizes.widthMenu - 2 * sizes.padding
end

function CLSCORE:CreatePanel()
	self:CalculateSizes()

	-- GENERATE MENU CONTENT
	local menuTbl = {}
	local panelData = ROUNDEND_MENU_DATA:BindData(menuTbl)

	InternalModifyRoundendMenu(panelData)

	-- RUN HOOK TO ADD DATA TO MENU
	hook.Run("TTT2ModifyRoundEndMenu", panelData)

	PrintTable(panelData)

	local frame = vguihandler.GenerateFrame(sizes.width, sizes.height, "report_title", true)

	frame:SetPadding(0, 0, 0, 0)

	-- LEFT HAND MENU STRIP
	local menuBox = vgui.Create("DPanel", frame)
	menuBox:SetSize(sizes.widthMenu, sizes.heightContent)
	menuBox:DockMargin(0, sizes.padding, 0, sizes.padding)
	menuBox:Dock(LEFT)
	menuBox.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "VerticalBorderedBoxTTT2", slf, w, h)

		return false
	end

	local menuBoxGrid = vgui.Create("DIconLayout", menuBox)
	menuBoxGrid:Dock(FILL)
	menuBoxGrid:SetSpaceY(sizes.padding)

	-- RIGHT HAND CONTENT AREA
	local contentBox = vgui.Create("DPanel", frame)
	contentBox:SetSize(sizes.widthContent, sizes.heightContent)
	contentBox:DockMargin(sizes.padding, sizes.padding, sizes.padding, sizes.padding)
	contentBox:Dock(RIGHT)

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
-- @param table events The list of events
-- @realm client
-- @internal
function CLSCORE:Init(events)

end

---
-- Resets the old score @{Panel}, initializes a new one and displays it to the local @{Player}
-- @param table events A list of events that should be reported
-- @realm client
-- @internal
function CLSCORE:ReportEvents(events)

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
