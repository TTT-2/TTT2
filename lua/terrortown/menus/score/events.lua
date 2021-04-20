--- @ignore

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
	local buttonBox = frameBoxes:Add("DPanelTTT2")
	buttonBox:SetSize(sizes.widthMainArea, sizes.heightTopButtonPanel + 2 * sizes.padding)
	buttonBox:DockPadding(0, sizes.padding, 0, sizes.padding)

	local buttonBoxRow = vgui.Create("DIconLayout", buttonBox)
	buttonBoxRow:Dock(FILL)

	local buttonBoxRowLabel = buttonBoxRow:Add("DLabelTTT2")
	buttonBoxRowLabel:SetSize(sizes.widthTopLabel, sizes.heightTopButtonPanel)
	buttonBoxRowLabel:SetText("label_show_events")
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
	buttonBoxRowButton1:SetText("button_show_events_you")
	buttonBoxRowButton1.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "ButtonRoundEndLeftTTT2", slf, w, h)

		return true
	end

	local buttonBoxRowButton2 = vgui.Create("DButtonTTT2", buttonBoxRowPanel)
	buttonBoxRowButton2:SetSize(sizes.widthTopButton, sizes.heightTopButton)
	buttonBoxRowButton2:DockMargin(0, sizes.padding, 0, sizes.padding)
	buttonBoxRowButton2:Dock(RIGHT)
	buttonBoxRowButton2:SetText("button_show_events_global")
	buttonBoxRowButton2.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "ButtonRoundEndRightTTT2", slf, w, h)

		return true
	end

	-- MAKE MAIN FRAME SCROLLABLE
	local scrollPanel = frameBoxes:Add("DScrollPanelTTT2")
	scrollPanel:SetSize(sizes.widthMainArea, sizes.heightContentLarge)

	-- SPLIT MAIN FRAME INTO FRAMEBOXES
	local frameBoxesScroll = vgui.Create("DIconLayout", scrollPanel)
	frameBoxesScroll:Dock(FILL)

	for i = 1, #events do
		local event = events[i]

		if event.event.roundState ~= ROUND_ACTIVE then continue end

		local eventBox = frameBoxesScroll:Add("DEventBoxTTT2")
		eventBox:SetEvent(event)
		eventBox:SetSize(sizes.widthMainArea, eventBox:GetContentHeight(sizes.widthMainArea))
	end
end
