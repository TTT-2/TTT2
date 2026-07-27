--- @ignore

local function PopulateEventTable(parent, sizes, events, onlyLocalPlayer)
    local sid64 = LocalPlayer():SteamID64()

    parent:Clear()

    -- SPLIT MAIN FRAME INTO FRAMEBOXES
    local frameBoxesScroll = vgui.Create("DIconLayout", parent)
    frameBoxesScroll:Dock(FILL)

    for i = 1, #events do
        local event = events[i]

        event.onlyLocalPlayer = onlyLocalPlayer

        if event.event.roundState ~= ROUND_ACTIVE then
            continue
        end
        if onlyLocalPlayer and not event:HasAffectedPlayer(sid64) then
            continue
        end

        local eventBox = frameBoxesScroll:Add("DEventBoxTTT2")
        eventBox:SetEvent(event)
        eventBox:SetSize(sizes.widthMainArea, eventBox:GetContentHeight(sizes.widthMainArea))
    end
end

CLSCOREMENU.base = "base_scoremenu"

CLSCOREMENU.icon = Material("vgui/ttt/vskin/roundend/events")
CLSCOREMENU.title = "title_score_events"
CLSCOREMENU.priority = 99

function CLSCOREMENU:Populate(parent)
    local sizes = CLSCORE.sizes
    local events = CLSCORE.events

    local frameBoxes = vgui.Create("DIconLayout", parent)
    frameBoxes:Dock(FILL)

    -- SWITCHER BETWEEN ROUND BEGIN AND ROUND END
    local buttonBox = frameBoxes:Add("TTT2:DPanel")
    buttonBox
        :SetSize(sizes.widthMainArea, sizes.heightTopButtonPanel + 2 * sizes.padding)
        :DockPadding(0, sizes.padding, 0, sizes.padding)

    local buttonBoxRow = vgui.Create("DIconLayout", buttonBox)
    buttonBoxRow:Dock(FILL)

    local buttonBoxRowLabel = buttonBoxRow:Add("TTT2:DLabel")
    buttonBoxRowLabel
        :SetSize(sizes.widthTopLabel, sizes.heightTopButtonPanel)
        :SetText("label_show_events")
        :SetHorizontalTextAlign(TEXT_ALIGN_RIGHT)

    local buttonBoxRowPanel = buttonBoxRow:Add("TTT2:DPanel")
    buttonBoxRowPanel:SetSize(2 * sizes.widthTopButton + sizes.padding, sizes.heightTopButtonPanel)

    local buttonBoxRowButton1 = vgui.Create("TTT2:DButton", buttonBoxRowPanel)
        :SetSize(sizes.widthTopButton, sizes.heightTopButton)
        :DockMargin(sizes.padding, sizes.padding, 0, sizes.padding)
        :Dock(LEFT)
        :SetText("button_show_events_you")
        :SetPaintHookName("ButtonRoundEndLeftTTT2")

    local buttonBoxRowButton2 = vgui.Create("TTT2:DButton", buttonBoxRowPanel)
        :SetSize(sizes.widthTopButton, sizes.heightTopButton)
        :DockMargin(0, sizes.padding, 0, sizes.padding)
        :Dock(RIGHT)
        :SetText("button_show_events_global")
        :SetPaintHookName("ButtonRoundEndRightTTT2")

    -- MAKE MAIN FRAME SCROLLABLE
    local scrollPanel = frameBoxes:Add("DScrollPanelTTT2")
    scrollPanel:SetSize(sizes.widthMainArea, sizes.heightContentLarge)

    -- default button state
    buttonBoxRowButton1:Attach("isActive", false)
    buttonBoxRowButton2:Attach("isActive", true)

    PopulateEventTable(scrollPanel, sizes, events, false)

    -- onclick functions for buttons
    buttonBoxRowButton1.DoClick = function()
        buttonBoxRowButton1:Attach("isActive", true)
        buttonBoxRowButton2:Attach("isActive", false)

        PopulateEventTable(scrollPanel, sizes, events, true)

        scrollPanel:InvalidateLayout()
    end

    buttonBoxRowButton2.DoClick = function()
        buttonBoxRowButton1:Attach("isActive", false)
        buttonBoxRowButton2:Attach("isActive", true)

        PopulateEventTable(scrollPanel, sizes, events, false)

        scrollPanel:InvalidateLayout()
    end
end
