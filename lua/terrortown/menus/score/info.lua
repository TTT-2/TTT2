--- @ignore

local materialNoTeam = Material("vgui/ttt/dynamic/roles/icon_no_team")

CLSCOREMENU.base = "base_scoremenu"

CLSCOREMENU.icon = Material("vgui/ttt/vskin/roundend/info")
CLSCOREMENU.title = "title_info"
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
	local buttonBox = frameBoxes:Add("DPanel")
	buttonBox:SetSize(sizes.widthMainArea, sizes.heightTopButtonPanel)

	local buttonBoxRow = vgui.Create("DIconLayout", buttonBox)
	buttonBoxRow:Dock(FILL)

	local buttonBoxRowLabel = buttonBoxRow:Add("DLabelTTT2")
	buttonBoxRowLabel:SetSize(sizes.widthTopLabel, sizes.heightTopButtonPanel)
	buttonBoxRowLabel:SetText("Show role distribution from")
	buttonBoxRowLabel.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "LabelRightTTT2", slf, w, h)

		return true
	end

	local buttonBoxRowPanel = buttonBoxRow:Add("DPanel")
	buttonBoxRowPanel:SetSize(2 * sizes.widthTopButton + sizes.padding, sizes.heightTopButtonPanel)

	local buttonBoxRowButton1 = vgui.Create("DButtonTTT2", buttonBoxRowPanel)
	buttonBoxRowButton1:SetSize(sizes.widthTopButton, sizes.heightTopButton)
	buttonBoxRowButton1:DockMargin(sizes.padding, sizes.padding, 0, sizes.padding)
	buttonBoxRowButton1:Dock(LEFT)
	buttonBoxRowButton1:SetText("Round Begin")
	buttonBoxRowButton1.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "ButtonRoundEndLeftTTT2", slf, w, h)

		return true
	end

	local buttonBoxRowButton2 = vgui.Create("DButtonTTT2", buttonBoxRowPanel)
	buttonBoxRowButton2:SetSize(sizes.widthTopButton, sizes.heightTopButton)
	buttonBoxRowButton2:DockMargin(0, sizes.padding, 0, sizes.padding)
	buttonBoxRowButton2:Dock(RIGHT)
	buttonBoxRowButton2:SetText("Round End")
	buttonBoxRowButton2.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "ButtonRoundEndRightTTT2", slf, w, h)

		return true
	end
	buttonBoxRowButton2.isActive = true

	-- MAKE MAIN FRAME SCROLLABLE
	local scrollPanel = frameBoxes:Add("DScrollPanelTTT2")
	scrollPanel:SetSize(sizes.widthMainArea, sizes.heightContent - sizes.heightHeaderPanel - sizes.heightTopButtonPanel - 4 * sizes.padding)

	-- SPLIT FRAME INTO A GRID LAYOUT
	local playerCoumns = vgui.Create("DIconLayout", scrollPanel)
	playerCoumns:Dock(FILL)
	playerCoumns:SetSpaceX(sizes.padding)
	playerCoumns:SetSpaceY(sizes.padding)

	local _, heightScroll = scrollPanel:GetSize()

	local heightColumn = heightScroll
	local widthColumn = (sizes.widthMainArea - 2 * sizes.padding - (heightScroll < heightColumn and 15 or 0) ) / 3

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

	-- FILL THE COLUMNS
	for i = 1, 3 do
		local teamPlayersList = CLSCORE.eventsInfoColumnData[i]
		local teamNamesList = CLSCORE.eventsInfoColumnTeams[i]

		local columnBox = teamInfoBox[i]:Add("DIconLayout")
		columnBox:SetSpaceY(sizes.padding)
		columnBox:Dock(FILL)

		for k = 1, #teamPlayersList do
			local plys = teamPlayersList[k]
			local teamData = TEAMS[teamNamesList[k]]

			-- support roles without a team
			if teamNamesList[k] == TEAM_NONE or not teamData or teamData.alone then
				teamData = {
					color = Color(91, 94, 99, 255),
					iconMaterial = materialNoTeam
				}
			end

			local teamBox = columnBox:Add("DColoredTextBoxTTT2")
			teamBox:SetColor(util.GetChangedColor(vskin.GetBackgroundColor(), 15))
			teamBox:SetSize(widthColumn, sizes.heightTitleRow + #plys * sizes.heightRow + (#plys + 1) * sizes.paddingSmall)

			local teamPlayerBox = vgui.Create("DIconLayout", teamBox)
			teamPlayerBox:SetSpaceY(sizes.paddingSmall)
			teamPlayerBox:Dock(FILL)

			local teamNameBox = teamPlayerBox:Add("DColoredTextBoxTTT2")
			teamNameBox:SetSize(widthColumn, sizes.heightTitleRow)
			teamNameBox:SetColor(teamData.color)
			teamNameBox:SetTitle(teamNamesList[k])
			teamNameBox:SetTitleFont("DermaTTT2TextLarger")
			teamNameBox:SetIcon(teamData.iconMaterial)

			for m = 1, #plys do
				local ply = plys[m]

				local plyRowPanel = teamPlayerBox:Add("DPanel")
				plyRowPanel:SetSize(widthColumn, sizes.heightRow)

				local plyRow = vgui.Create("DIconLayout", plyRowPanel)
				plyRow:SetSpaceX(sizes.padding)
				plyRow:DockMargin(sizes.padding, 0, 0, 0)
				plyRow:Dock(FILL)

				local widthKarma = 50
				local widthScore = 35
				local widthName = widthColumn - widthKarma - widthScore - 4 * sizes.padding

				local plyNameBox = plyRow:Add("DColoredTextBoxTTT2")
				plyNameBox:SetSize(widthName, sizes.heightRow)
				plyNameBox:SetColor(util.GetChangedColor(vskin.GetBackgroundColor(), 15))
				plyNameBox:SetTitle(ply.nick .. (ply.alive and "" or " †"))
				--plyNameBox:SetTitleOpacity(ply.alive and 1.0 or 0.2)
				plyNameBox:SetTitleAlign(TEXT_ALIGN_LEFT)
				plyNameBox:SetIcon(roles.GetByIndex(ply.role).iconMaterial)

				local test = vgui.Create("DColoredBoxTTT2")

				plyNameBox:SetTooltipPanel(test)
				plyNameBox:SetTooltipFixedPosition(0, sizes.heightRow + 1)
				plyNameBox:SetTooltipFixedSize(widthName, 150)

				local plyKarmaBox = plyRow:Add("DColoredTextBoxTTT2")
				plyKarmaBox:SetSize(widthKarma, sizes.heightRow)
				plyKarmaBox:SetColor(COLOR_BLUE)
				--plyKarmaBox:SetTitle(ply.addkarma)
				plyKarmaBox:SetTitle("xx")
				plyKarmaBox:SetTitleFont("DermaTTT2CatHeader")
				plyKarmaBox:SetTooltip("Karma")
				plyKarmaBox:SetTooltipFixedPosition(0, sizes.heightRow + 1)

				local plyPointsBox = plyRow:Add("DColoredTextBoxTTT2")
				plyPointsBox:SetSize(widthScore, sizes.heightRow)
				plyPointsBox:SetColor(COLOR_ORANGE)
				--plyPointsBox:SetTitle(ply.addscore)
				plyPointsBox:SetTitle("xx")
				plyPointsBox:SetTitleFont("DermaTTT2CatHeader")
				plyPointsBox:SetTooltip("Score")
				plyPointsBox:SetTooltipFixedPosition(0, sizes.heightRow + 1)
			end
		end
	end
end
