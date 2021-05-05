--- @ignore

local TryT = LANG.TryTranslation
local ParT = LANG.GetParamTranslation

local function MakePlayerRoleTooltip(parent, width, ply)
	local plyRoles = CLSCORE.eventsPlayerRoles[ply.sid64]
	local height = 25

	local boxLayout = vgui.Create("DIconLayout", parent)
	boxLayout:Dock(FILL)

	local titleBox = boxLayout:Add("DColoredTextBoxTTT2")
	titleBox:SetSize(width, 25)
	titleBox:SetDynamicColor(parent, 0)
	titleBox:SetTitle("tooltip_roles_time")
	titleBox:SetTitleAlign(TEXT_ALIGN_LEFT)

	for i = 1, #plyRoles do
		local plyRole = plyRoles[i]
		local roleData = roles.GetByIndex(plyRole.role)

		local plyRoleBox = boxLayout:Add("DColoredTextBoxTTT2")
		plyRoleBox:SetSize(width, 20)
		plyRoleBox:SetDynamicColor(parent, 0)
		plyRoleBox:SetTitleAlign(TEXT_ALIGN_LEFT)
		plyRoleBox:SetIcon(roleData.iconMaterial)

		plyRoleBox.GetTitle = function()
			return tostring(i) .. ". " .. TryT(roleData.name) .. " (" .. TryT(plyRole.team) .. ")"
		end

		height = height + 20
	end

	return height
end

local function MakePlayerScoreTooltip(parent, width, ply)
	local plyScores = CLSCORE.eventsPlayerScores[ply.sid64]
	local height = 25

	local boxLayout = vgui.Create("DIconLayout", parent)
	boxLayout:Dock(FILL)

	local titleBox = boxLayout:Add("DColoredTextBoxTTT2")
	titleBox:SetSize(width, 25)
	titleBox:SetDynamicColor(parent, 0)
	titleBox:SetTitle("tooltip_score_gained")
	titleBox:SetTitleAlign(TEXT_ALIGN_LEFT)

	-- In a first Pass filter all scoreevents and scores by name, positivy and number of Events
	local filteredPlyScoreList = {}
	for i = 1, #plyScores do
		local plyScoreEvent = plyScores[i]
		local rawScoreTexts = plyScoreEvent:GetRawScoreText(ply.sid64)

		for k = 1, #rawScoreTexts do
			local rawScoreText = rawScoreTexts[k]
			local scoreName = rawScoreText.name
			local score = rawScoreText.score

			filteredPlyScoreList[scoreName] = filteredPlyScoreList[scoreName] or {score = {0,0}, numEvents = {0,0}}

			local posIndex = score < 0 and 1 or 2 -- first entry contains negative and second positive entries
			local filteredPlyScore = filteredPlyScoreList[scoreName]

			filteredPlyScore.score[posIndex] = filteredPlyScore.score[posIndex] + score
			filteredPlyScore.numEvents[posIndex] = filteredPlyScore.numEvents[posIndex] + 1
		end
	end

	-- In a second pass we create the tooltip boxes with summarized scoreevents
	for rawScoreTextName, scoreObj in pairs(filteredPlyScoreList) do
		for i = 1, 2 do
			local score = scoreObj.score[i]
			local numberEvents = scoreObj.numEvents[i]

			if score == 0 then continue end

			local plyRoleBox = boxLayout:Add("DColoredTextBoxTTT2")
			plyRoleBox:SetSize(width, 20)
			plyRoleBox:SetDynamicColor(parent, 0)
			plyRoleBox:SetTitleAlign(TEXT_ALIGN_LEFT)

			plyRoleBox.GetTitle = function()
				return "- " .. (numberEvents > 1 and (numberEvents .. "x ") or "") .. ParT("tooltip_" .. rawScoreTextName, {score = score})
			end

			height = height + 20
		end
	end

	return height
end

local function MakePlayerKarmaTooltip(parent, width, ply)
	local plyKarmaList = CLSCORE.eventsPlayerKarma[ply.sid64]
	local height = 25

	local boxLayout = vgui.Create("DIconLayout", parent)
	boxLayout:Dock(FILL)

	local titleBox = boxLayout:Add("DColoredTextBoxTTT2")
	titleBox:SetSize(width, 25)
	titleBox:SetDynamicColor(parent, 0)
	titleBox:SetTitle("tooltip_karma_gained")
	titleBox:SetTitleAlign(TEXT_ALIGN_LEFT)

	if not istable(plyKarmaList) then
		return height
	end

	for karmaText, karma in pairs(plyKarmaList) do
		local plyRoleBox = boxLayout:Add("DColoredTextBoxTTT2")
		plyRoleBox:SetSize(width, 20)
		plyRoleBox:SetDynamicColor(parent, 0)
		plyRoleBox:SetTitleAlign(TEXT_ALIGN_LEFT)

		plyRoleBox.GetTitle = function()
			return "- " .. TryT(karmaText) .. ": " .. karma
		end

		height = height + 20
	end

	return height
end

local function PopulatePlayerView(parent, sizes, columnData, columnTeams, showDeath)
	parent:Clear()

	-- SPLIT FRAME INTO A GRID LAYOUT
	local playerCoumns = vgui.Create("DIconLayout", parent)
	playerCoumns:Dock(FILL)
	playerCoumns:SetSpaceX(sizes.padding)
	playerCoumns:SetSpaceY(sizes.padding)

	local _, heightScroll = parent:GetSize()
	local maxHeightColumn = heightScroll

	-- DETERTMINE THE SIZE FIRST TO TAKE THE SCROLLBAR SIZE INTO ACCOUNT
	for i = 1, 3 do
		local teamPlayersList = columnData[i]
		local heightColumn = 0

		for k = 1, #teamPlayersList do
			local plys = teamPlayersList[k]
			local amountPly = #plys

			heightColumn = heightColumn + sizes.heightTitleRow + amountPly * sizes.heightRow + (amountPly + 1) * sizes.paddingSmall

			-- if there is a second team, add padding to size
			if k > 1 then
				heightColumn = heightColumn + sizes.padding
			end
		end

		maxHeightColumn = math.max(maxHeightColumn, heightColumn)
	end

	local widthColumn = (sizes.widthMainArea - 2 * sizes.padding - (heightScroll < maxHeightColumn and 15 or 0)) / 3
	local widthName = widthColumn - sizes.widthKarma - sizes.widthScore - 4 * sizes.padding

	local teamInfoBox = {}

	local localPly64 = LocalPlayer():SteamID64()

	-- FILL THE COLUMNS
	for numColumn = 1, 3 do
		teamInfoBox[numColumn] = playerCoumns:Add("DColoredBoxTTT2")
		teamInfoBox[numColumn]:SetSize(widthColumn, maxHeightColumn)
		teamInfoBox[numColumn]:SetDynamicColor(parent, 30)

		local teamPlayersList = columnData[numColumn]
		local teamNamesList = columnTeams[numColumn]

		local columnBox = teamInfoBox[numColumn]:Add("DIconLayout")
		columnBox:SetSpaceY(sizes.padding)
		columnBox:Dock(FILL)

		for numTeam = 1, #teamPlayersList do
			local plys = teamPlayersList[numTeam]
			local amountPly = #plys
			local teamData = TEAMS[teamNamesList[numTeam]]
			local colorTeam = teamData.color
			local colorTeamLight = util.ColorLighten(colorTeam, 35)
			local colorTeamDark = util.ColorDarken(colorTeam, 20)

			local teamBox = columnBox:Add("DColoredTextBoxTTT2")
			teamBox:SetDynamicColor(parent, 15)
			teamBox:SetSize(widthColumn, sizes.heightTitleRow + amountPly * sizes.heightRow + (amountPly + 1) * sizes.paddingSmall)

			local teamPlayerBox = vgui.Create("DIconLayout", teamBox)
			teamPlayerBox:SetSpaceY(sizes.paddingSmall)
			teamPlayerBox:Dock(FILL)

			local teamNameBox = teamPlayerBox:Add("DColoredTextBoxTTT2")
			teamNameBox:SetSize(widthColumn, sizes.heightTitleRow)
			teamNameBox:SetColor(colorTeam)
			teamNameBox:SetTitle(teamNamesList[numTeam])
			teamNameBox:SetTitleFont("DermaTTT2TextLarger")
			teamNameBox:SetIcon(teamData.iconMaterial)

			for numPly = 1, amountPly do
				local ply = plys[numPly]

				local plyRowPanel = teamPlayerBox:Add("DPanelTTT2")
				plyRowPanel:SetSize(widthColumn, sizes.heightRow)

				local plyRow = vgui.Create("DIconLayout", plyRowPanel)
				plyRow:SetSpaceX(sizes.padding)
				plyRow:DockMargin(sizes.padding, 0, 0, 0)
				plyRow:Dock(FILL)

				local plyNameBox = plyRow:Add("DColoredTextBoxTTT2")
				plyNameBox:SetSize(widthName, sizes.heightRow)
				plyNameBox:SetDynamicColor(parent, 15)
				plyNameBox:SetTitle(ply.nick .. ((showDeath and not ply.alive) and " (†)" or ""))
				plyNameBox:SetTitleAlign(TEXT_ALIGN_LEFT)
				plyNameBox:SetIcon(roles.GetByIndex(ply.role).iconMaterial)

				-- highlight local player
				if ply.sid64 == localPly64 then
					plyNameBox:EnableFlashColor(true)
				end

				local plyRolesTooltipPanel = vgui.Create("DPanelTTT2")

				local heightRolesTooltip = MakePlayerRoleTooltip(plyRolesTooltipPanel, widthName, ply)

				plyNameBox:SetTooltipPanel(plyRolesTooltipPanel)
				plyNameBox:SetTooltipFixedPosition(0, sizes.heightRow + 1)
				plyNameBox:SetTooltipFixedSize(widthName, heightRolesTooltip)
				plyRolesTooltipPanel:SetSize(widthName, heightRolesTooltip)

				local plyKarmaBox = plyRow:Add("DColoredTextBoxTTT2")
				plyKarmaBox:SetSize(sizes.widthKarma, sizes.heightRow)
				plyKarmaBox:SetColor(colorTeamLight)
				plyKarmaBox:SetTitle(CLSCORE.eventsInfoKarma[ply.sid64] or 0)
				plyKarmaBox:SetTitleFont("DermaTTT2CatHeader")
				plyKarmaBox:SetTooltip("tooltip_karma_gained")

				local plyKarmaTooltipPanel = vgui.Create("DPanelTTT2")

				local heightKarmaTooltip = MakePlayerKarmaTooltip(plyKarmaTooltipPanel, 200, ply)

				plyKarmaBox:SetTooltipPanel(plyKarmaTooltipPanel)
				plyKarmaBox:SetTooltipFixedPosition(0, sizes.heightRow + 1)
				plyKarmaBox:SetTooltipFixedSize(200, heightKarmaTooltip)
				plyKarmaTooltipPanel:SetSize(200, heightKarmaTooltip)

				local plyPointsBox = plyRow:Add("DColoredTextBoxTTT2")
				plyPointsBox:SetSize(sizes.widthScore, sizes.heightRow)
				plyPointsBox:SetColor(colorTeamDark)
				plyPointsBox:SetTitle(CLSCORE.eventsInfoScores[ply.sid64] or 0)
				plyPointsBox:SetTitleFont("DermaTTT2CatHeader")
				plyPointsBox:SetTooltip("tooltip_score_gained")

				local plyScoreTooltipPanel = vgui.Create("DPanelTTT2")

				local heightScoreTooltip = MakePlayerScoreTooltip(plyScoreTooltipPanel, 200, ply)

				plyPointsBox:SetTooltipPanel(plyScoreTooltipPanel)
				plyPointsBox:SetTooltipFixedPosition(0, sizes.heightRow + 1)
				plyPointsBox:SetTooltipFixedSize(200, heightScoreTooltip)
				plyScoreTooltipPanel:SetSize(200, heightScoreTooltip)
			end
		end
	end
end

CLSCOREMENU.base = "base_scoremenu"

CLSCOREMENU.icon = Material("vgui/ttt/vskin/roundend/info")
CLSCOREMENU.title = "title_score_info"
CLSCOREMENU.priority = 100

function CLSCOREMENU:Populate(parent)
	local sizes = CLSCORE.sizes

	local frameBoxes = vgui.Create("DIconLayout", parent)
	frameBoxes:Dock(FILL)

	-- CREATE WIN TITLE BOX
	local winBox = frameBoxes:Add("DColoredTextBoxTTT2")
	winBox:SetColor(CLSCORE.eventsInfoTitleColor)
	winBox:SetSize(sizes.widthMainArea, sizes.heightHeaderPanel)
	winBox:SetTitle(CLSCORE.eventsInfoTitleText)
	winBox:SetTitleFont("DermaTTT2TextHuge")

	-- SWITCHER BETWEEN ROUND BEGIN AND ROUND END
	local buttonBox = frameBoxes:Add("DPanelTTT2")
	buttonBox:SetSize(sizes.widthMainArea, sizes.heightTopButtonPanel + 2 * sizes.padding)
	buttonBox:DockPadding(0, sizes.padding, 0, sizes.padding)

	local buttonBoxRow = vgui.Create("DIconLayout", buttonBox)
	buttonBoxRow:Dock(FILL)

	local buttonBoxRowLabel = buttonBoxRow:Add("DLabelTTT2")
	buttonBoxRowLabel:SetSize(sizes.widthTopLabel, sizes.heightTopButtonPanel)
	buttonBoxRowLabel:SetText("label_show_roles")
	buttonBoxRowLabel.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "LabelRightTTT2", slf, w, h)

		return true
	end

	local buttonBoxRowPanel = buttonBoxRow:Add("DPanelTTT2")
	buttonBoxRowPanel:SetSize(2 * sizes.widthTopButton + sizes.padding, sizes.heightTopButtonPanel)

	local buttonBoxRowButton1 = vgui.Create("DButtonTTT2", buttonBoxRowPanel)
	buttonBoxRowButton1:SetSize(sizes.widthTopButton, sizes.heightTopButton)
	buttonBoxRowButton1:DockMargin(sizes.padding, sizes.padding, 0, sizes.padding)
	buttonBoxRowButton1:Dock(LEFT)
	buttonBoxRowButton1:SetText("button_show_roles_begin")
	buttonBoxRowButton1.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "ButtonRoundEndLeftTTT2", slf, w, h)

		return true
	end

	local buttonBoxRowButton2 = vgui.Create("DButtonTTT2", buttonBoxRowPanel)
	buttonBoxRowButton2:SetSize(sizes.widthTopButton, sizes.heightTopButton)
	buttonBoxRowButton2:DockMargin(0, sizes.padding, 0, sizes.padding)
	buttonBoxRowButton2:Dock(RIGHT)
	buttonBoxRowButton2:SetText("button_show_roles_end")
	buttonBoxRowButton2.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "ButtonRoundEndRightTTT2", slf, w, h)

		return true
	end

	-- MAKE MAIN FRAME SCROLLABLE
	local scrollPanel = frameBoxes:Add("DScrollPanelTTT2")
	scrollPanel:SetSize(sizes.widthMainArea, sizes.heightContent)

	-- default button state
	buttonBoxRowButton1.isActive = false
	buttonBoxRowButton2.isActive = true
	PopulatePlayerView(scrollPanel, sizes, CLSCORE.eventsInfoColumnDataEnd, CLSCORE.eventsInfoColumnTeamsEnd, true)

	-- onclick functions for buttons
	buttonBoxRowButton1.DoClick = function()
		buttonBoxRowButton1.isActive = true
		buttonBoxRowButton2.isActive = false

		PopulatePlayerView(scrollPanel, sizes, CLSCORE.eventsInfoColumnDataStart, CLSCORE.eventsInfoColumnTeamsStart, false)
	end

	buttonBoxRowButton2.DoClick = function()
		buttonBoxRowButton1.isActive = false
		buttonBoxRowButton2.isActive = true

		PopulatePlayerView(scrollPanel, sizes, CLSCORE.eventsInfoColumnDataEnd, CLSCORE.eventsInfoColumnTeamsEnd, true)
	end
end
