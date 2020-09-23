local width, height = 1200, 700
local padding = 10
local paddingSmall = 0.5 * padding
local widthMenu = 50 + vskin.GetBorderSize()
local heightMenuButton = 50
local widthContent = width - widthMenu - 2 * padding
local heightContent = height - 2 * padding
local heightTitleRow = 30
local heightRow = 25
local heightButton = 45
local widthButton = 175
local heightHeaderPanel = 100
local heightBottomButtonPanel = heightButton + 2 * padding + 1
local widthTopButton = 140
local heightTopButton = 30
local widthTopLabel = 0.5 * widthContent - widthTopButton - padding
local heightTopButtonPanel = heightTopButton + 2 * padding

local materialInfo = Material("vgui/ttt/vskin/roundend/info")
local materialEvents = Material("vgui/ttt/vskin/roundend/events")
local materialScores = Material("vgui/ttt/vskin/roundend/scores")

frame = nil

local testplys = {
	{
		nick = "Rudolph",
		team = TEAM_INNOCENT,
		role = ROLE_INNOCENT,
		addscore = 0,
		addkarma = -120,
		alive = true
	},
	{
		nick = "Adam",
		team = TEAM_INNOCENT,
		role = ROLE_PHARAOH,
		addscore = 2,
		addkarma = 60,
		alive = false
	},
	{
		nick = "Maria",
		team = TEAM_TRAITOR,
		role = ROLE_TRAITOR,
		addscore = 10,
		addkarma = 100,
		alive = true
	},
	{
		nick = "Joseph",
		team = TEAM_TRAITOR,
		role = ROLE_HITMAN,
		addscore = 12,
		addkarma = 100,
		alive = true
	},
	{
		nick = "Jaqueline",
		team = TEAM_JACKAL,
		role = ROLE_JACKAL,
		addscore = -8,
		addkarma = -250,
		alive = false
	},
	{
		nick = "Sophia",
		team = TEAM_JACKAL,
		role = ROLE_SIDEKICK,
		addscore = 0,
		addkarma = 20,
		alive = true
	},
	{
		nick = "Rebecca",
		team = TEAM_MARKER,
		role = ROLE_MARKER,
		addscore = 0,
		addkarma = 0,
		alive = false
	},
	{
		nick = "Marco",
		team = TEAM_TRAITOR,
		role = ROLE_TRAITOR,
		addscore = 6,
		addkarma = 120,
		alive = true
	},
	{
		nick = "Matthew",
		team = TEAM_TRAITOR,
		role = ROLE_SUPERVILLAIN,
		addscore = -8,
		addkarma = -120,
		alive = true
	},
	{
		nick = "Angelina",
		team = TEAM_INNOCENT,
		role = ROLE_INNOCENT,
		addscore = 2,
		addkarma = 50,
		alive = false
	},
}

local function GetAndRemoveBiggestSubTable(tbl)
	local subTbl = {}
	local subIdx = 0

	for i, t in pairs(tbl) do
		if #t < #subTbl then continue end

		subTbl = t
		subIdx = i
	end

	if isnumber(subItx) then
		table.remove(tbl, subIdx)
	else
		tbl[subIdx] = nil
	end

	return subTbl, subIdx
end

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

		local plyTable, team = GetAndRemoveBiggestSubTable(teamsTbl)

		colTbl[index][#colTbl[index] + 1] = plyTable
		colTeamsTbl[index][#colTeamsTbl[index] + 1] = team

		index = index + direction
	end

	return colTbl, colTeamsTbl
end

concommand.Add("rend", function()
	if frame and frame.Close then
		frame:Close()

		frame = nil

		return
	end

	frame = vguihandler.GenerateFrame(width, height, "report_title", true)

	-- INIT MAIN MENU SPECIFIC STUFF
	frame:SetPadding(0, 0, 0, 0)

	local menuBox = vgui.Create("DPanel", frame)
	menuBox:SetSize(widthMenu, heightContent)
	menuBox:DockMargin(0, padding, 0, padding)
	menuBox:Dock(LEFT)
	menuBox.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "VerticalBorderedBoxTTT2", slf, w, h)

		return false
	end

	-- SPLIT NAV AREA INTO A GRID LAYOUT
	local menuBoxGrid = vgui.Create("DIconLayout", menuBox)
	menuBoxGrid:Dock(FILL)
	menuBoxGrid:SetSpaceY(padding)

	local settingsButton1 = menuBoxGrid:Add("DSubMenuButtonTTT2")
	settingsButton1:SetSize(widthMenu - 1, heightMenuButton)
	settingsButton1:SetIcon(materialInfo)
	settingsButton1.DoClick = function(slf)

	end
	settingsButton1:SetActive()

	local settingsButton2 = menuBoxGrid:Add("DSubMenuButtonTTT2")
	settingsButton2:SetSize(widthMenu - 1, heightMenuButton)
	settingsButton2:SetIcon(materialEvents)
	settingsButton2.DoClick = function(slf)

	end

	local settingsButton3 = menuBoxGrid:Add("DSubMenuButtonTTT2")
	settingsButton3:SetSize(widthMenu - 1, heightMenuButton)
	settingsButton3:SetIcon(materialScores)
	settingsButton3.DoClick = function(slf)

	end

	local contentBox = vgui.Create("DPanel", frame)
	contentBox:SetSize(widthContent, heightContent)
	contentBox:DockMargin(padding, padding, padding, padding)
	contentBox:Dock(RIGHT)

	local frameBoxes = vgui.Create("DIconLayout", contentBox)
	frameBoxes:Dock(FILL)
	frameBoxes:SetSpaceX(padding)
	frameBoxes:SetSpaceY(padding)

	local winBox = frameBoxes:Add("DColoredTextBoxTTT2")
	winBox:SetColor(TRAITOR.color)
	winBox:SetSize(widthContent, heightHeaderPanel)
	winBox:SetTitle("hilite_win_traitors")
	winBox:SetTitleFont("DermaTTT2TextHuge")

	local buttonBox = frameBoxes:Add("DPanel")
	buttonBox:SetSize(widthContent, heightTopButtonPanel)

	local buttonBoxRow = vgui.Create("DIconLayout", buttonBox)
	buttonBoxRow:Dock(FILL)

	local buttonBoxRowLabel = buttonBoxRow:Add("DLabelTTT2")
	buttonBoxRowLabel:SetSize(widthTopLabel, heightTopButtonPanel)
	buttonBoxRowLabel:SetText("Show role distribution from")
	buttonBoxRowLabel.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "LabelRighTTT2", slf, w, h)

		return true
	end

	local buttonBoxRowPanel = buttonBoxRow:Add("DPanel")
	buttonBoxRowPanel:SetSize(2 * widthTopButton + padding, heightTopButtonPanel)

	local buttonBoxRowButton1 = vgui.Create("DButtonTTT2", buttonBoxRowPanel)
	buttonBoxRowButton1:SetSize(widthTopButton, heightTopButton)
	buttonBoxRowButton1:DockMargin(padding, padding, 0, padding)
	buttonBoxRowButton1:Dock(LEFT)
	buttonBoxRowButton1:SetText("Round Begin")
	buttonBoxRowButton1.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "ButtonRoundEndLeftTTT2", slf, w, h)

		return true
	end

	local buttonBoxRowButton2 = vgui.Create("DButtonTTT2", buttonBoxRowPanel)
	buttonBoxRowButton2:SetSize(widthTopButton, heightTopButton)
	buttonBoxRowButton2:DockMargin(0, padding, 0, padding)
	buttonBoxRowButton2:Dock(RIGHT)
	buttonBoxRowButton2:SetText("Round End")
	buttonBoxRowButton2.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "ButtonRoundEndRightTTT2", slf, w, h)

		return true
	end
	buttonBoxRowButton2.isActive = true

	-- MAKE MAIN FRAME SCROLLABLE
	local scrollPanel = frameBoxes:Add("DScrollPanelTTT2")
	scrollPanel:SetSize(widthContent, height - heightHeaderPanel - heightTopButtonPanel - heightBottomButtonPanel - 4 * padding - vskin.GetHeaderHeight() - vskin.GetBorderSize())

	-- SPLIT FRAME INTO A GRID LAYOUT
	local playerCoumns = vgui.Create("DIconLayout", scrollPanel)
	playerCoumns:Dock(FILL)
	playerCoumns:SetSpaceX(padding)
	playerCoumns:SetSpaceY(padding)

	local _, heightScroll = scrollPanel:GetSize()

	local heightColumn = heightScroll
	local widthColumn = (widthContent - 2 * padding - (heightScroll < heightColumn and 15 or 0) ) / 3

	local teamInfoBox = {}

	teamInfoBox[1] = playerCoumns:Add("DColoredBoxTTT2")
	teamInfoBox[1]:SetSize(widthColumn, heightColumn)
	teamInfoBox[1]:SetColor(util.GetChangedColor(vskin.GetBackgroundColor(), 30))

	teamInfoBox[2] = playerCoumns:Add("DColoredBoxTTT2")
	teamInfoBox[2]:SetSize(widthColumn, heightColumn)
	teamInfoBox[2]:SetColor(util.GetChangedColor(vskin.GetBackgroundColor(), 30))

	teamInfoBox[3] = playerCoumns:Add("DColoredBoxTTT2")
	teamInfoBox[3]:SetSize(widthColumn, heightColumn)
	teamInfoBox[3]:SetColor(util.GetChangedColor(vskin.GetBackgroundColor(), 30))

	local columnData, columnTeams = CreateColumns(testplys)

	for i = 1, 3 do
		local teamPlayersList = columnData[i]
		local teamNamesList = columnTeams[i]

		local columnBox = teamInfoBox[i]:Add("DIconLayout")
		columnBox:SetSpaceY(padding)
		columnBox:Dock(FILL)

		for k = 1, #teamPlayersList do
			local plys = teamPlayersList[k]
			local teamData = TEAMS[teamNamesList[k]]

			local teamBox = columnBox:Add("DColoredTextBoxTTT2")
			teamBox:SetColor(util.GetChangedColor(vskin.GetBackgroundColor(), 15))
			teamBox:SetSize(widthColumn, heightTitleRow + #plys * heightRow + (#plys + 1) * paddingSmall)

			local teamPlayerBox = vgui.Create("DIconLayout", teamBox)
			teamPlayerBox:SetSpaceY(paddingSmall)
			teamPlayerBox:Dock(FILL)

			local teamNameBox = teamPlayerBox:Add("DColoredTextBoxTTT2")
			teamNameBox:SetSize(widthColumn, heightTitleRow)
			teamNameBox:SetColor(teamData.color)
			teamNameBox:SetTitle(teamNamesList[k])
			teamNameBox:SetTitleFont("DermaTTT2TextLarger")
			teamNameBox:SetIcon(teamData.iconMaterial)

			for m = 1, #plys do
				local ply = plys[m]

				local plyRowPanel = teamPlayerBox:Add("DPanel")
				plyRowPanel:SetSize(widthColumn, heightRow)

				local plyRow = vgui.Create("DIconLayout", plyRowPanel)
				plyRow:SetSpaceX(padding)
				plyRow:DockMargin(padding, 0, 0, 0)
				plyRow:Dock(FILL)

				local widthKarma = 50
				local widthScore = 35
				local widthName = widthColumn - widthKarma - widthScore - 4 * padding

				local plyNameBox = plyRow:Add("DColoredTextBoxTTT2")
				plyNameBox:SetSize(widthName, heightRow)
				plyNameBox:SetColor(util.GetChangedColor(vskin.GetBackgroundColor(), 15))
				plyNameBox:SetTitle(ply.nick)
				plyNameBox:SetTitleOpacity(ply.alive and 1.0 or 0.2)
				plyNameBox:SetTitleAlign(TEXT_ALIGN_LEFT)
				plyNameBox:SetIcon(roles.GetByIndex(ply.role).iconMaterial)

				local test = vgui.Create("DColoredBoxTTT2")
				--test:SetColor(COLOR_GREEN)

				plyNameBox:SetTooltipPanel(test)
				plyNameBox:SetTooltipFixedPosition(0, heightRow + 1)
				plyNameBox:SetTooltipFixedSize(widthName, 150)
				--plyNameBox:SetTooltip("Test")

				local plyKarmaBox = plyRow:Add("DColoredTextBoxTTT2")
				plyKarmaBox:SetSize(widthKarma, heightRow)
				plyKarmaBox:SetColor(COLOR_BLUE)
				plyKarmaBox:SetTitle(ply.addkarma)
				plyKarmaBox:SetTitleFont("DermaTTT2CatHeader")
				plyKarmaBox:SetTooltip("Karma")
				plyKarmaBox:SetTooltipFixedPosition(0, heightRow + 1)

				local plyPointsBox = plyRow:Add("DColoredTextBoxTTT2")
				plyPointsBox:SetSize(widthScore, heightRow)
				plyPointsBox:SetColor(COLOR_ORANGE)
				plyPointsBox:SetTitle(ply.addscore)
				plyPointsBox:SetTitleFont("DermaTTT2CatHeader")
				plyPointsBox:SetTooltip("Score")
				plyPointsBox:SetTooltipFixedPosition(0, heightRow + 1)
			end
		end
	end

	local buttonArea = frameBoxes:Add("DButtonPanelTTT2")
	buttonArea:SetSize(widthContent, heightBottomButtonPanel)

	local buttonSave = vgui.Create("DButtonTTT2", buttonArea)
	buttonSave:SetText("report_save")
	buttonSave:SetSize(widthButton, heightButton + 1)
	buttonSave:SetPos(0, padding)
	buttonSave.DoClick = function(btn)

	end

	local buttonClose = vgui.Create("DButtonTTT2", buttonArea)
	buttonClose:SetText("close")
	buttonClose:SetSize(widthButton, heightButton)
	buttonClose:SetPos(widthContent - 175, padding + 1)
	buttonClose.DoClick = function(btn)
		frame:Close()
	end
end)
