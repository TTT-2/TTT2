--- @ignore

local TryT = LANG.TryTranslation
local ParT = LANG.GetParamTranslation
local IsKarmaEnabled = KARMA.IsEnabled

local function GetPanelTextSize(pnl)
    surface.SetFont(pnl:GetTitleFont())
    return surface.GetTextSize(TryT(pnl:GetTitle()))
end

local function MakePlayerGenericTooltip(parent, ply, items, title)
    local initTitleHeight = 25
    local lineHeight = 20
    local iconOffset = (
        (lineHeight - 2 * math.Round(0.1 * lineHeight)) + 4 * math.Round(0.1 * lineHeight)
    )

    local boxLayout = vgui.Create("DIconLayout", parent)
    boxLayout:Dock(FILL)

    local titleBox = boxLayout:Add("DColoredTextBoxTTT2")
    titleBox:SetDynamicColor(parent, 0)
    titleBox:SetTitle(title)
    titleBox:SetTitleAlign(TEXT_ALIGN_LEFT)

    local lengthLongestLine, titleHeight = GetPanelTextSize(titleBox)
    local height = math.max(initTitleHeight, titleHeight)
    titleBox:SetHeight(height)

    for i = 1, #items do
        local thing = items[i]
        local plyRow = boxLayout:Add("DColoredTextBoxTTT2")
        plyRow:SetDynamicColor(parent, 0)
        plyRow:SetTitleAlign(TEXT_ALIGN_LEFT)
        if thing.title then
            plyRow:SetTitle(thing.title)
        end

        local rowWidth, rowHeight = GetPanelTextSize(plyRow)

        if thing.iconMaterial then
            plyRow:SetIcon(thing.iconMaterial)
            rowWidth = rowWidth + iconOffset
        end

        if rowWidth > lengthLongestLine then
            lengthLongestLine = rowWidth
        end

        rowHeight = math.max(lineHeight, rowHeight)
        plyRow:SetHeight(rowHeight)
        height = height + rowHeight
    end

    -- add some padding to the right margin
    lengthLongestLine = lengthLongestLine + iconOffset

    -- we found the longest line, now make all entries that long
    local children = boxLayout:GetChildren()
    for i = 1, #children do
        children[i]:SetWidth(lengthLongestLine)
    end

    return lengthLongestLine, height
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

            heightColumn = heightColumn
                + sizes.heightTitleRow
                + amountPly * sizes.heightRow
                + (amountPly + 1) * sizes.paddingSmall

            -- if there is a second team, add padding to size
            if k > 1 then
                heightColumn = heightColumn + sizes.padding
            end
        end

        maxHeightColumn = math.max(maxHeightColumn, heightColumn)
    end

    local widthColumn = (
        sizes.widthMainArea
        - 2 * sizes.padding
        - (heightScroll < maxHeightColumn and 15 or 0)
    ) / 3

    local widthName
    if IsKarmaEnabled() then
        widthName = widthColumn - sizes.widthKarma - sizes.widthScore - 4 * sizes.padding
    else
        widthName = widthColumn - sizes.widthScore - 3 * sizes.padding
    end

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
            teamBox:SetSize(
                widthColumn,
                sizes.heightTitleRow
                    + amountPly * sizes.heightRow
                    + (amountPly + 1) * sizes.paddingSmall
            )

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

                local roleBucket = {}
                local plyRoles = CLSCORE.eventsPlayerRoles[ply.sid64] or {}
                for i = 1, #plyRoles do
                    local plyRole = plyRoles[i]
                    local roleData = roles.GetByIndex(plyRole.role)

                    roleBucket[#roleBucket + 1] = {
                        title = tostring(i) .. ". " .. TryT(roleData.name) .. " (" .. TryT(
                            plyRole.team
                        ) .. ")",
                        iconMaterial = roleData.iconMaterial,
                    }
                end
                local widthRolesTooltip, heightRolesTooltip = MakePlayerGenericTooltip(
                    plyRolesTooltipPanel,
                    ply,
                    roleBucket,
                    "tooltip_roles_time"
                )

                plyNameBox:SetTooltipPanel(plyRolesTooltipPanel)
                plyNameBox:SetTooltipFixedPosition(0, sizes.heightRow + 1)
                plyNameBox:SetTooltipFixedSize(widthRolesTooltip, heightRolesTooltip)
                plyRolesTooltipPanel:SetSize(widthRolesTooltip, heightRolesTooltip)

                if IsKarmaEnabled() then
                    local plyKarmaBox = plyRow:Add("DColoredTextBoxTTT2")
                    plyKarmaBox:SetSize(sizes.widthKarma, sizes.heightRow)
                    plyKarmaBox:SetColor(colorTeamLight)
                    plyKarmaBox:SetTitle(CLSCORE.eventsInfoKarma[ply.sid64] or 0)
                    plyKarmaBox:SetTitleFont("DermaTTT2CatHeader")
                    plyKarmaBox:SetTooltip("tooltip_karma_gained")

                    local plyKarmaTooltipPanel = vgui.Create("DPanelTTT2")

                    local karmaBucket = {}
                    local plyKarmaList = CLSCORE.eventsPlayerKarma[ply.sid64] or {}
                    for karmaText, karma in pairs(plyKarmaList) do
                        karmaBucket[#karmaBucket + 1] = {
                            title = "- " .. TryT(karmaText) .. ": " .. karma,
                        }
                    end
                    local widthKarmaTooltip, heightKarmaTooltip = MakePlayerGenericTooltip(
                        plyKarmaTooltipPanel,
                        ply,
                        karmaBucket,
                        "tooltip_karma_gained"
                    )

                    plyKarmaBox:SetTooltipPanel(plyKarmaTooltipPanel)
                    plyKarmaBox:SetTooltipFixedPosition(0, sizes.heightRow + 1)
                    plyKarmaBox:SetTooltipFixedSize(widthKarmaTooltip, heightKarmaTooltip)
                    plyKarmaTooltipPanel:SetSize(widthKarmaTooltip, heightKarmaTooltip)
                end

                local plyPointsBox = plyRow:Add("DColoredTextBoxTTT2")
                plyPointsBox:SetSize(sizes.widthScore, sizes.heightRow)
                plyPointsBox:SetColor(colorTeamDark)
                plyPointsBox:SetTitle(CLSCORE.eventsInfoScores[ply.sid64] or 0)
                plyPointsBox:SetTitleFont("DermaTTT2CatHeader")
                plyPointsBox:SetTooltip("tooltip_score_gained")

                local plyScoreTooltipPanel = vgui.Create("DPanelTTT2")

                local scoreBucket = {}
                local plyScores = CLSCORE.eventsPlayerScores[ply.sid64] or {}

                -- In a first Pass filter all scoreevents and scores by name, positivy and number of Events
                local filteredPlyScoreList = {}
                for i = 1, #plyScores do
                    local plyScoreEvent = plyScores[i]
                    local rawScoreTexts = plyScoreEvent:GetRawScoreText(ply.sid64)

                    for k = 1, #rawScoreTexts do
                        local rawScoreText = rawScoreTexts[k]
                        local scoreName = rawScoreText.name
                        local score = rawScoreText.score

                        filteredPlyScoreList[scoreName] = filteredPlyScoreList[scoreName]
                            or { score = 0, numEvents = 0 }

                        local filteredPlyScore = filteredPlyScoreList[scoreName]

                        filteredPlyScore.score = filteredPlyScore.score + score
                        filteredPlyScore.numEvents = filteredPlyScore.numEvents + 1
                    end
                end

                for rawScoreTextName, scoreObj in pairs(filteredPlyScoreList) do
                    local score = scoreObj.score
                    local numberEvents = scoreObj.numEvents

                    if score == 0 then
                        continue
                    end

                    scoreBucket[#scoreBucket + 1] = {
                        title = "- "
                            .. (numberEvents > 1 and (numberEvents .. "x ") or "")
                            .. ParT("tooltip_" .. rawScoreTextName, { score = score }),
                    }
                end
                local widthScoreTooltip, heightScoreTooltip = MakePlayerGenericTooltip(
                    plyScoreTooltipPanel,
                    ply,
                    scoreBucket,
                    "tooltip_score_gained"
                )

                plyPointsBox:SetTooltipPanel(plyScoreTooltipPanel)
                plyPointsBox:SetTooltipFixedPosition(0, sizes.heightRow + 1)
                plyPointsBox:SetTooltipFixedSize(widthScoreTooltip, heightScoreTooltip)
                plyScoreTooltipPanel:SetSize(widthScoreTooltip, heightScoreTooltip)
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
    PopulatePlayerView(
        scrollPanel,
        sizes,
        CLSCORE.eventsInfoColumnDataEnd,
        CLSCORE.eventsInfoColumnTeamsEnd,
        true
    )

    -- onclick functions for buttons
    buttonBoxRowButton1.DoClick = function()
        buttonBoxRowButton1.isActive = true
        buttonBoxRowButton2.isActive = false

        PopulatePlayerView(
            scrollPanel,
            sizes,
            CLSCORE.eventsInfoColumnDataStart,
            CLSCORE.eventsInfoColumnTeamsStart,
            false
        )
    end

    buttonBoxRowButton2.DoClick = function()
        buttonBoxRowButton1.isActive = false
        buttonBoxRowButton2.isActive = true

        PopulatePlayerView(
            scrollPanel,
            sizes,
            CLSCORE.eventsInfoColumnDataEnd,
            CLSCORE.eventsInfoColumnTeamsEnd,
            true
        )
    end
end
