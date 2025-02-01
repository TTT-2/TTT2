--- @ignore

local TryT = LANG.TryTranslation
local ParT = LANG.GetParamTranslation
local IsKarmaEnabled = KARMA.IsEnabled

local function GetPanelTextSize(pnl) --todo move to perform layout
    surface.SetFont(pnl:GetFont())
    return surface.GetTextSize(TryT(pnl:GetText()))
end

local function MakePlayerGenericTooltip(parent, ply, items, title)
    local initTitleHeight = 25
    local lineHeight = 20
    local iconOffset = (
        (lineHeight - 2 * math.Round(0.1 * lineHeight)) + 4 * math.Round(0.1 * lineHeight)
    )

    local boxLayout = vgui.Create("DIconLayout", parent)
    boxLayout:Dock(FILL)

    local titleBox = boxLayout
        :Add("TTT2:DPanel")
        :SetText(title)
        :SetTextAlign(TEXT_ALIGN_LEFT)
        :SetPaintHookName("ColoredTextBoxTTT2")

    local lengthLongestLine, titleHeight = GetPanelTextSize(titleBox) --todo: move to perform layout
    local height = math.max(initTitleHeight, titleHeight)

    titleBox:SetHeight(height)

    for i = 1, #items do
        local thing = items[i]

        local plyRow = boxLayout:Add("TTT2:DPanel")

        if thing.title then
            plyRow:SetText(thing.title)
        end

        local rowWidth, rowHeight = GetPanelTextSize(plyRow) --todo move to perform layout

        if thing.iconMaterial then
            plyRow:SetIcon(thing.iconMaterial)
            rowWidth = rowWidth + iconOffset
        end

        if rowWidth > lengthLongestLine then
            lengthLongestLine = rowWidth
        end

        rowHeight = math.max(lineHeight, rowHeight)

        plyRow
            :SetHeight(rowHeight)
            :SetTextAlign(TEXT_ALIGN_LEFT)
            :SetPaintHookName("ColoredTextBoxTTT2")

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
        teamInfoBox[numColumn] = playerCoumns:Add("TTT2:DPanel")
        teamInfoBox[numColumn]
            :SetSize(widthColumn, maxHeightColumn)
            :Attach("ColorLighten", 30)
            :SetPaintHookName("ColoredBoxTTT2")

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

            local teamBox = columnBox:Add("TTT:DPanel")
            teamBox
                :Attach("ColorLighten", 15)
                :SetSize(
                    widthColumn,
                    sizes.heightTitleRow
                        + amountPly * sizes.heightRow
                        + (amountPly + 1) * sizes.paddingSmall
                )
                :SetPaintHookName("ColoredTextBoxTTT2")

            local teamPlayerBox = vgui.Create("DIconLayout", teamBox)
            teamPlayerBox:SetSpaceY(sizes.paddingSmall)
            teamPlayerBox:Dock(FILL)

            local teamNameBox = teamPlayerBox:Add("TTT2:DPanel")
            teamNameBox
                :SetSize(widthColumn, sizes.heightTitleRow)
                :SetColor(colorTeam)
                :SetText(teamNamesList[numTeam])
                :SetFont("DermaTTT2TextLarger")
                :SetIcon(teamData.iconMaterial)
                :SetPaintHookName("ColoredTextBoxTTT2")

            for numPly = 1, amountPly do
                local ply = plys[numPly]

                local plyRowPanel =
                    teamPlayerBox:Add("TTT2:DPanel"):SetSize(widthColumn, sizes.heightRow)

                local plyRow = vgui.Create("DIconLayout", plyRowPanel)
                plyRow:SetSpaceX(sizes.padding)
                plyRow:DockMargin(sizes.padding, 0, 0, 0)
                plyRow:Dock(FILL)

                local plyRolesTooltipPanel = vgui.Create("TTT2:DPanel")

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

                local plyNameBox = plyRow:Add("TTT2:DPanel")
                plyNameBox
                    :SetSize(widthName, sizes.heightRow)
                    :Attach("ColorLighten", 15)
                    :SetText(ply.nick .. ((showDeath and not ply.alive) and " (†)" or ""))
                    :SetTextAlign(TEXT_ALIGN_LEFT)
                    :SetIcon(roles.GetByIndex(ply.role).iconMaterial)
                    :SetPaintHookName("ColoredTextBoxTTT2")
                    :SetTooltipPanel(plyRolesTooltipPanel)
                    :SetTooltipFixedPosition(0, sizes.heightRow + 1)
                    :SetTooltipFixedSize(widthRolesTooltip, heightRolesTooltip)

                plyRolesTooltipPanel:SetSize(widthRolesTooltip, heightRolesTooltip)

                -- highlight local player
                if ply.sid64 == localPly64 then
                    plyNameBox:EnableFlashColor(true)
                end

                if IsKarmaEnabled() then
                    local plyKarmaTooltipPanel = vgui.Create("TTT2:DPanel")

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

                    local plyKarmaBox = plyRow:Add("TTT2:DPanel")
                    plyKarmaBox
                        :SetSize(sizes.widthKarma, sizes.heightRow)
                        :SetColor(colorTeamLight)
                        :SetText(CLSCORE.eventsInfoKarma[ply.sid64] or 0)
                        :SetFont("DermaTTT2CatHeader")
                        :SetTooltip("tooltip_karma_gained") --TODO set tooltip + settooltippanel?
                        :SetTooltipPanel(plyKarmaTooltipPanel)
                        :SetTooltipFixedPosition(0, sizes.heightRow + 1)
                        :SetTooltipFixedSize(widthKarmaTooltip, heightKarmaTooltip)
                        :SetPaintHookName("ColoredTextBoxTTT2")

                    plyKarmaTooltipPanel:SetSize(widthKarmaTooltip, heightKarmaTooltip)
                end

                local plyPointsBox = plyRow:Add("TTT2:DPanel")
                plyPointsBox
                    :SetSize(sizes.widthScore, sizes.heightRow)
                    :SetColor(colorTeamDark)
                    :SetText(CLSCORE.eventsInfoScores[ply.sid64] or 0)
                    :SetFont("DermaTTT2CatHeader")
                    :SetTooltip("tooltip_score_gained")
                    :SetPaintHookName("ColoredTextBoxTTT2")

                local plyScoreTooltipPanel = vgui.Create("TTT2:DPanel")

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
    local winBox = frameBoxes:Add("TTT2:DPanel")
    winBox
        :SetColor(CLSCORE.eventsInfoTitleColor)
        :SetSize(sizes.widthMainArea, sizes.heightHeaderPanel)
        :SetText(CLSCORE.eventsInfoTitleText)
        :SetFont("DermaTTT2TextHuge")
        :SetPaintHookName("ColoredTextBoxTTT2")

    -- SWITCHER BETWEEN ROUND BEGIN AND ROUND END
    local buttonBox = frameBoxes
        :Add("TTT2:DPanel")
        :SetSize(sizes.widthMainArea, sizes.heightTopButtonPanel + 2 * sizes.padding)
        :DockPadding(0, sizes.padding, 0, sizes.padding)

    local buttonBoxRow = vgui.Create("DIconLayout", buttonBox)
    buttonBoxRow:Dock(FILL)

    local buttonBoxRowLabel = buttonBoxRow
        :Add("TTT2:DLabel")
        :SetSize(sizes.widthTopLabel, sizes.heightTopButtonPanel)
        :SetText("label_show_roles")
        :SetPaintHookName("LabelRightTTT2")

    local buttonBoxRowPanel = buttonBoxRow:Add("TTT2:DPanel")
    buttonBoxRowPanel:SetSize(2 * sizes.widthTopButton + sizes.padding, sizes.heightTopButtonPanel)

    local buttonBoxRowButton1 = vgui.Create("TTT2:DButton", buttonBoxRowPanel)
        :SetSize(sizes.widthTopButton, sizes.heightTopButton)
        :DockMargin(sizes.padding, sizes.padding, 0, sizes.padding)
        :Dock(LEFT)
        :SetText("button_show_roles_begin")
        :SetPaintHookName("ButtonRoundEndLeftTTT2")

    local buttonBoxRowButton2 = vgui.Create("TTT2:DButton", buttonBoxRowPanel)
        :SetSize(sizes.widthTopButton, sizes.heightTopButton)
        :DockMargin(0, sizes.padding, 0, sizes.padding)
        :Dock(RIGHT)
        :SetText("button_show_roles_end")
        :SetPaintHookName("ButtonRoundEndRightTTT2")

    -- MAKE MAIN FRAME SCROLLABLE
    local scrollPanel = frameBoxes:Add("DScrollPanelTTT2")
    scrollPanel:SetSize(sizes.widthMainArea, sizes.heightContent)

    -- default button state
    buttonBoxRowButton1:Attach("isActive", false)
    buttonBoxRowButton2:Attach("isActive", true)

    PopulatePlayerView(
        scrollPanel,
        sizes,
        CLSCORE.eventsInfoColumnDataEnd,
        CLSCORE.eventsInfoColumnTeamsEnd,
        true
    )

    -- onclick functions for buttons
    buttonBoxRowButton1:On("LeftClick", function()
        buttonBoxRowButton1:Attach("isActive", true)
        buttonBoxRowButton2:Attach("isActive", false)

        PopulatePlayerView(
            scrollPanel,
            sizes,
            CLSCORE.eventsInfoColumnDataStart,
            CLSCORE.eventsInfoColumnTeamsStart,
            false
        )
    end)

    buttonBoxRowButton2:On("LeftClick", function()
        buttonBoxRowButton1:Attach("isActive", false)
        buttonBoxRowButton2:Attach("isActive", true)

        PopulatePlayerView(
            scrollPanel,
            sizes,
            CLSCORE.eventsInfoColumnDataEnd,
            CLSCORE.eventsInfoColumnTeamsEnd,
            true
        )
    end)
end
