local materialClose = Material("vgui/ttt/vskin/icon_close")
local materialBack = Material("vgui/ttt/vskin/icon_back")
local materialCollapseOpened = Material("vgui/ttt/vskin/icon_collapse_opened")
local materialCollapseClosed = Material("vgui/ttt/vskin/icon_collapse_closed")
local materialReset = Material("vgui/ttt/vskin/icon_reset")

local SKIN = {}
SKIN.Name = "ttt2_default"

local TryT = LANG.TryTranslation

local alphaDisabled = 100

-- register fonts
surface.CreateAdvancedFont("DermaTTT2Title", {font = "Trebuchet24", size = 26, weight = 300})
surface.CreateAdvancedFont("DermaTTT2TitleSmall", {font = "Trebuchet24", size = 18, weight = 600})
surface.CreateAdvancedFont("DermaTTT2MenuButtonTitle", {font = "Trebuchet24", size = 22, weight = 300})
surface.CreateAdvancedFont("DermaTTT2MenuButtonDescription", {font = "Trebuchet24", size = 14, weight = 300})
surface.CreateAdvancedFont("DermaTTT2SubMenuButtonTitle", {font = "Trebuchet24", size = 18, weight = 600})
surface.CreateAdvancedFont("DermaTTT2Button", {font = "Trebuchet24", size = 14, weight = 600})
surface.CreateAdvancedFont("DermaTTT2CatHeader", {font = "Trebuchet24", size = 16, weight = 900})
surface.CreateAdvancedFont("DermaTTT2Text", {font = "Trebuchet24", size = 16, weight = 300})
surface.CreateAdvancedFont("DermaTTT2TextLarge", {font = "Trebuchet24", size = 18, weight = 300})

--[[---------------------------------------------------------
	Frame
-----------------------------------------------------------]]
function SKIN:PaintFrameTTT2(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()
	local colorAccent = VSKIN.GetAccentColor()
	local colorAccentDark = VSKIN.GetDarkAccentColor()
	local colorShadow = VSKIN.GetShadowColor()
	local colorTitleText = VSKIN.GetTitleTextColor()

	local sizeShadow = VSKIN.GetShadowSize()
	local sizeHeader = VSKIN.GetHeaderHeight()
	local sizeBorder = VSKIN.GetBorderSize()

	-- DRAW SHADOW (disable clipping)
	if panel.m_bPaintShadow then
		DisableClipping(true)
		draw.RoundedBox(sizeShadow, -sizeShadow, -sizeShadow, w + 2 * sizeShadow, h + 2 * sizeShadow, colorShadow)
		DisableClipping(false)
	end

	-- draw main panel box
	draw.Box(0, 0, w, h, colorBackground)

	-- draw panel header area
	draw.Box(0, 0, w, sizeHeader, colorAccent)
	draw.Box(0, sizeHeader, w, sizeBorder, colorAccentDark)

	draw.ShadowedText(TryT(panel:GetTitle()), panel:GetTitleFont(), 0.5 * w, 0.5 * sizeHeader, colorTitleText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1)
end

--[[---------------------------------------------------------
	Panel
-----------------------------------------------------------]]
function SKIN:PaintPanel(panel, w, h)

end

function SKIN:PaintNavPanelTTT2(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()
	local colorLine = ColorAlpha(util.GetDefaultColor(colorBackground), 200)

	draw.Box(w - 1, 0, 1, h, colorLine)
end

function SKIN:PaintButtonPanelTTT2(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()
	local colorLine = ColorAlpha(util.GetDefaultColor(colorBackground), 200)

	draw.Box(0, 0, w, 1, colorLine)
end

function SKIN:PaintContentPanelTTT2(panel, w, h)
	local colorBackground = ColorAlpha(util.GetDefaultColor(VSKIN.GetBackgroundColor()), 20)

	draw.Box(0, 0, w, h, colorBackground)
end

--[[---------------------------------------------------------
	Button
-----------------------------------------------------------]]
local function DrawClose(w, h, colorBackground, colorText, shift)
	local padding = 15

	draw.Box(0, 0, w, h, colorBackground)
	draw.FilteredShadowedTexture(padding, padding + shift, w - 2 * padding, h - 2 * padding, materialClose, colorText.a, colorText)
end

function SKIN:PaintWindowCloseButton(panel, w, h)
	if not panel.m_bBackground then return end

	local colorAccent = VSKIN.GetAccentColor()
	local colorAccentHover = util.GetHoverColor(colorAccent)
	local colorAccentActive = util.GetActiveColor(colorAccent)

	local colorTitleText = util.GetDefaultColor(colorAccent)

	if not panel:IsEnabled() then
		return DrawClose(w, h, colorAccent, ColorAlpha(colorTitleText, 70), 0)
	end

	if panel.Depressed or panel:IsSelected() then
		return DrawClose(w, h, colorAccentActive, ColorAlpha(colorTitleText, 200), 1)
	end

	if panel.Hovered then
		return DrawClose(w, h, colorAccentHover, colorTitleText, 0)
	end

	return DrawClose(w, h, colorAccent, ColorAlpha(colorTitleText, 150), 0)
end

local function DrawBack(w, h, panel, colorBackground, colorText, shift)
	local padding_w = 10
	local padding_h = 15

	draw.Box(0, 0, w, h, colorBackground)
	draw.FilteredShadowedTexture(padding_w, padding_h + shift, h - 2 * padding_h, h - 2 * padding_h, materialBack, colorText.a, colorText)
	draw.ShadowedText(
		TryT("button_menu_back"),
		"DermaTTT2TitleSmall",
		h - padding_w,
		0.5 * h + shift,
		colorText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER,
		1
	)
end

function SKIN:PaintWindowBackButton(panel, w, h)
	if not panel.m_bBackground then return end

	local colorAccent = VSKIN.GetAccentColor()
	local colorAccentHover = util.GetHoverColor(colorAccent)
	local colorAccentActive = util.GetActiveColor(colorAccent)

	local colorTitleText = util.GetDefaultColor(colorAccent)

	if not panel:IsEnabled() then
		return DrawBack(w, h, panel, colorAccent, ColorAlpha(colorTitleText, 70), 0)
	end

	if panel.Depressed or panel:IsSelected() then
		return DrawBack(w, h, panel, colorAccentActive, ColorAlpha(colorTitleText, 200), 1)
	end

	if panel.Hovered then
		return DrawBack(w, h, panel, colorAccentHover, colorTitleText, 0)
	end

	return DrawBack(w, h, panel, colorAccent, ColorAlpha(colorTitleText, 150), 0)
end

--[[---------------------------------------------------------
	ScrollBar
-----------------------------------------------------------]]
function SKIN:PaintVScrollBar(panel, w, h)
	local colorScrollbarTrack = VSKIN.GetScrollbarTrackColor()

	return draw.RoundedBox(6, 0, 0, w, h, colorScrollbarTrack)
end

function SKIN:PaintScrollBarGrip(panel, w, h)
	local colorScrollbar = VSKIN.GetScrollbarColor()
	local colorScrollbarHover = util.GetHoverColor(colorScrollbar)
	local colorScrollbarActive = util.GetActiveColor(colorScrollbar)

	local sizeCornerRadius = VSKIN.GetCornerRadius()

	if not panel:IsEnabled() then
		return self.tex.Scroller.ButtonV_Disabled( 0, 0, w, h )
	end

	if panel.Depressed then
		return draw.RoundedBox(sizeCornerRadius, 0, 0, w, h, colorScrollbarActive)
	end

	if panel.Hovered then
		return draw.RoundedBox(sizeCornerRadius, 0, 0, w, h, colorScrollbarHover)
	end

	return draw.RoundedBox(sizeCornerRadius, 0, 0, w, h, colorScrollbar)
end

function SKIN:PaintButtonDown(panel, w, h)
	if not panel.m_bBackground then return end

	local colorAccent = VSKIN.GetAccentColor()
	local colorAccentHover = util.GetHoverColor(colorAccent)
	local colorAccentActive = util.GetActiveColor(colorAccent)

	local sizeCornerRadius = VSKIN.GetCornerRadius()

	if not panel:IsEnabled() then
		return self.tex.Scroller.DownButton_Dead( 0, 0, w, h )
	end

	if panel.Depressed or panel:IsSelected() then
		return draw.RoundedBox(sizeCornerRadius, 0, 0, w, h, colorAccentActive)
	end

	if panel.Hovered then
		return draw.RoundedBox(sizeCornerRadius, 0, 0, w, h, colorAccentHover)
	end

	return draw.RoundedBox(sizeCornerRadius, 0, 0, w, h, colorAccent)
end

function SKIN:PaintButtonUp(panel, w, h)
	if not panel.m_bBackground then return end

	local colorAccent = VSKIN.GetAccentColor()
	local colorAccentHover = util.GetHoverColor(colorAccent)
	local colorAccentActive = util.GetActiveColor(colorAccent)

	local sizeCornerRadius = VSKIN.GetCornerRadius()

	if not panel:IsEnabled() then
		return self.tex.Scroller.DownButton_Dead( 0, 0, w, h )
	end

	if panel.Depressed or panel:IsSelected() then
		return draw.RoundedBox(sizeCornerRadius, 0, 0, w, h, colorAccentActive)
	end

	if panel.Hovered then
		return draw.RoundedBox(sizeCornerRadius, 0, 0, w, h, colorAccentHover)
	end

	return draw.RoundedBox(sizeCornerRadius, 0, 0, w, h, colorAccent)
end

local function DrawMenuButton(w, h, panel, colorOutline, colorIcon, colorText, colorDescription, shift)
	local paddingText = 10
	local paddingIcon = 25

	draw.OutlinedBox(0, 0, w, h, 1, colorOutline)
	draw.FilteredTexture(paddingIcon, paddingIcon + shift, h - 2 * paddingIcon, h - 2 * paddingIcon, panel:GetImage(), colorIcon.a, colorIcon)
	draw.SimpleText(
		TryT(panel:GetTitle()),
		panel:GetTitleFont(),
		h,
		paddingText + shift,
		colorText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_TOP
	)

	local desc_wrapped = draw.GetWrappedText(TryT(panel:GetDescription()), w - h - 2 * paddingText, panel:GetDescriptionFont())

	local line_pos = 35
	for i = 1, #desc_wrapped do
		draw.SimpleText(
			desc_wrapped[i],
			panel:GetDescriptionFont(),
			h,
			line_pos + paddingText + shift,
			colorDescription,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP
		)

		line_pos = line_pos + 20
	end
end

function SKIN:PaintMenuButtonTTT2(panel, w, h)
	if not panel.m_bBackground then return end

	local colorBackground = VSKIN.GetBackgroundColor()

	local colorDefault = util.GetDefaultColor(colorBackground)

	local colorText = util.GetChangedColor(colorDefault, 65)
	local colorTextHover = util.GetChangedColor(colorDefault, 50)
	local colorDescription = util.GetChangedColor(colorDefault, 145)
	local colorDescriptionHover = util.GetChangedColor(colorDefault, 135)
	local colorIcon = util.GetChangedColor(colorDefault, 170)
	local colorIconHover = util.GetChangedColor(colorDefault, 160)

	if not panel:IsEnabled() then
		return self.tex.Button_Dead( 0, 0, w, h)
	end

	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		return DrawMenuButton(w, h, panel, colorDescriptionHover, colorIconHover, colorTextHover, colorDescriptionHover, 1)
	end

	if panel.Hovered then
		return DrawMenuButton(w, h, panel, colorDescriptionHover, colorIconHover, colorTextHover, colorDescriptionHover, 0)
	end

	return DrawMenuButton(w, h, panel, colorIcon, colorIcon, colorText, colorDescription, 0)
end

local function DrawSubMenuButton(w, h, panel, sizeBorder, colorBackground, colorBar, colorText)
	draw.Box(0, 0, sizeBorder, h, colorBar)
	draw.Box(sizeBorder, 0, w - sizeBorder, h, colorBackground)

	draw.SimpleText(
		TryT(panel:GetTitle()),
		panel:GetTitleFont(),
		sizeBorder + 20,
		0.5 * h,
		colorText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintSubMenuButtonTTT2(panel, w, h)
	if not panel.m_bBackground then return end

	local colorElemBackground = VSKIN.GetBackgroundColor()

	local colorText = util.GetChangedColor(util.GetDefaultColor(colorElemBackground), 75)
	local colorTextHover = util.GetHoverColor(colorText)
	local colorTextActive = util.GetActiveColor(colorText)

	local colorAccent = VSKIN.GetAccentColor()
	local colorAccentHover = util.GetHoverColor(colorAccent)
	local colorAccentActive = util.GetActiveColor(colorAccent)

	local colorBackground = ColorAlpha(colorAccent, 50)
	local colorBackgroundHover = util.GetHoverColor(colorBackground)
	local colorBackgroundActive = util.GetActiveColor(colorBackground)

	if not panel:IsActive() then
		colorAccent = colorElemBackground
		colorBackground = colorElemBackground
	end

	local sizeBorder = VSKIN.GetBorderSize()


	if not panel:IsEnabled() then
		return self.tex.Button_Dead( 0, 0, w, h)
	end

	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		return DrawSubMenuButton(w, h, panel, sizeBorder, colorBackgroundActive, colorAccentActive, colorTextActive)
	end

	if panel.Hovered then
		return DrawSubMenuButton(w, h, panel, sizeBorder, colorBackgroundHover, colorAccentHover, colorTextHover)
	end

	return DrawSubMenuButton(w, h, panel, sizeBorder, colorBackground, colorAccent, colorText)
end

--[[---------------------------------------------------------
	CheckBox
-----------------------------------------------------------]]
local function DrawCheckBox(w, h, offset, panel, colorBox, colorCenter)
	draw.RoundedBox(4, 0, 0, w, h, colorBox)
	draw.RoundedBox(4, offset + 3, 3, h - 6, h - 6, colorCenter)
end

function SKIN:PaintCheckBox(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()

	local colorBox = util.GetChangedColor(colorBackground, 15)

	local colorAccent = VSKIN.GetAccentColor()
	local colorAccentHover = ColorAlpha(util.GetHoverColor(colorAccent), 200)
	local colorCenter = util.GetChangedColor(colorBackground, 150)

	if not panel:IsEnabled() then
		colorBox = ColorAlpha(colorBox, alphaDisabled)
		colorAccent = ColorAlpha(colorAccent, alphaDisabled)
		colorAccentHover = ColorAlpha(colorAccentHover, alphaDisabled)
		colorCenter = ColorAlpha(colorCenter, alphaDisabled)
	end

	if panel:GetChecked() then
		if not panel:IsEnabled() then
			DrawCheckBox(w, h, w - h, panel, colorBox, colorAccent)
		elseif panel.Hovered then
			DrawCheckBox(w, h, w - h, panel, colorBox, colorAccentHover)
		else
			DrawCheckBox(w, h, w - h, panel, colorBox, colorAccent)
		end
	else
		if not panel:IsEnabled() then
			DrawCheckBox(w, h, 0, panel, colorBox, colorCenter)
		elseif panel.Hovered then
			DrawCheckBox(w, h, 0, panel, colorBox, colorAccentHover)
		else
			DrawCheckBox(w, h, 0, panel, colorBox, colorCenter)
		end
	end
end

function SKIN:PaintCheckBoxLabel(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()

	local colorBox = util.GetChangedColor(colorBackground, 150)
	local colorText = util.GetDefaultColor(colorBox)

	local sizeCornerRadius = VSKIN.GetCornerRadius()

	if not panel:IsEnabled() then
		colorBox = ColorAlpha(colorBox, alphaDisabled)
		colorText = ColorAlpha(colorText, alphaDisabled)
	end

	draw.RoundedBoxEx(sizeCornerRadius, 0, 0, w, h, colorBox, true, false, true, false)

	draw.SimpleText(
		TryT(panel:GetText()),
		panel:GetFont(),
		panel:GetTextPosition(),
		0.5 * h,
		colorText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
end

--[[---------------------------------------------------------
	CollapsibleCategory
-----------------------------------------------------------]]
function SKIN:PaintCollapsibleCategoryTTT2(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()
	local colorAccent = VSKIN.GetAccentColor()

	local sizeBorder = VSKIN.GetBorderSize()

	draw.Box(0, 0, w, h, colorBackground)
	draw.Box(0, h - sizeBorder, w, sizeBorder, colorAccent)
end

function SKIN:PaintCategoryHeaderTTT2(panel, w, h)
	local paddingX = 10
	local paddingY = 10

	local colorBackground = VSKIN.GetBackgroundColor()

	local colorLine = util.GetChangedColor(colorBackground, 50)

	local colorText = util.GetChangedColor(util.GetDefaultColor(colorBackground), 50)

	draw.Box(0, 0, w, h, colorBackground)

	if panel:GetParent():GetExpanded() then
		draw.Line(0, h - 1, w, h - 1, colorLine)
		draw.FilteredShadowedTexture(paddingX, paddingY + 1, h - 2 * paddingY, h - 2 * paddingY, materialCollapseOpened, colorText.a * 0.5, colorText)
	else
		draw.FilteredShadowedTexture(paddingX, paddingY, h - 2 * paddingY, h - 2 * paddingY, materialCollapseClosed, colorText.a * 0.5, colorText)
	end

	draw.SimpleText(
		string.upper(TryT(panel.text)),
		panel:GetFont(),
		h,
		0.5 * h,
		colorText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
end

local function DrawButton(w, h, panel, sizeBorder, colorLine, colorBox, colorText)
	draw.Box(0, 0, w, h, colorBox)
	draw.Box(0, h - sizeBorder, w, sizeBorder, colorLine)

	draw.SimpleText(
		string.upper(TryT(panel:GetText())),
		panel:GetFont(),
		0.5 * w,
		0.5 * (h - sizeBorder),
		colorText,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintButtonTTT2(panel, w, h)
	local colorAccent = VSKIN.GetAccentColor()
	local colorAccentHover = util.GetHoverColor(colorAccent)
	local colorAccentActive = util.GetActiveColor(colorAccent)

	local colorAccentDark = VSKIN.GetDarkAccentColor()
	local colorAccentDarkHover = util.GetHoverColor(colorAccentDark)
	local colorAccentDarkActive = util.GetActiveColor(colorAccentDark)

	local colorAccentDisabled = util.GetChangedColor(util.GetDefaultColor(VSKIN.GetBackgroundColor()), 175)
	local colorAccentDarkDisabled = util.GetChangedColor(util.GetDefaultColor(VSKIN.GetBackgroundColor()), 125)

	local sizeBorder = VSKIN.GetBorderSize()

	if not panel:IsEnabled() then
		local colorText = util.GetDefaultColor(colorAccentDisabled)

		return DrawButton(w, h, panel, sizeBorder, colorAccentDarkDisabled, colorAccentDisabled, colorText)
	end

	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		local colorText = util.GetDefaultColor(colorAccent)

		return DrawButton(w, h, panel, sizeBorder, colorAccentDarkActive, colorAccentActive, colorText)
	end

	if panel.Hovered then
		local colorText = util.GetDefaultColor(colorAccent)

		return DrawButton(w, h, panel, sizeBorder, colorAccentDarkHover, colorAccentHover, colorText)
	end

	local colorText = util.GetDefaultColor(colorAccent)

	return DrawButton(w, h, panel, sizeBorder, colorAccentDark, colorAccent, colorText)
end

local function DrawFormButton(w, h, panel, sizeCornerRadius, colorBoxBack, colorBox, colorText, shift)
	local pad = 6

	draw.RoundedBoxEx(sizeCornerRadius, 0, 0, w, h, colorBoxBack, false, true, false, true)
	draw.RoundedBox(sizeCornerRadius, 1, 1, w - 2, h - 2, colorBox)

	draw.FilteredShadowedTexture(pad, pad + shift, w - 2 * pad, h - 2 * pad, materialReset, colorText.a, colorText)
end

function SKIN:PaintFormButtonResetTTT2(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()

	local colorBoxBack = util.GetChangedColor(colorBackground, 150)
	local colorBox = VSKIN.GetAccentColor()
	local colorText = ColorAlpha(util.GetDefaultColor(colorBox), 150)

	local sizeCornerRadius = VSKIN.GetCornerRadius()
	local shift = 0

	if not panel:IsEnabled() then
		colorBoxBack = ColorAlpha(colorBoxBack, alphaDisabled)
		colorBox = ColorAlpha(colorBox, alphaDisabled)
		colorText = ColorAlpha(colorText, alphaDisabled)
	elseif panel.noDefault then
		colorBox = ColorAlpha(colorBox, alphaDisabled)
		colorText = ColorAlpha(colorText, alphaDisabled)
	elseif panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		colorBox = util.GetActiveColor(colorBox)
		shift = 1
	elseif panel.Hovered then
		colorBox = util.GetHoverColor(colorBox)
	end

	return DrawFormButton(w, h, panel, sizeCornerRadius, colorBoxBack, colorBox, colorText, shift)
end

function SKIN:PaintLabelTTT2(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()

	local colorText = util.GetChangedColor(util.GetDefaultColor(colorBackground), 40)

	draw.SimpleText(
		TryT(panel:GetText()),
		panel:GetFont(),
		0,
		0.5 * h,
		colorText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintFormLabelTTT2(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()

	local colorBox = util.GetChangedColor(colorBackground, 150)
	local colorText = util.GetDefaultColor(colorBox)

	if not panel:IsEnabled() then
		colorBox = ColorAlpha(colorBox, alphaDisabled)
		colorText = ColorAlpha(colorText, alphaDisabled)
	end

	local sizeCornerRadius = VSKIN.GetCornerRadius()

	draw.RoundedBoxEx(sizeCornerRadius, 0, 0, w, h, colorBox, true, false, true, false)

	draw.SimpleText(
		TryT(panel:GetText()),
		panel:GetFont(),
		10,
		0.5 * h,
		colorText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintFormBoxTTT2(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()

	local colorBoxBack = util.GetChangedColor(colorBackground, 150)
	local colorBox = util.GetChangedColor(colorBackground, 15)

	if not panel:IsEnabled() then
		colorBoxBack = ColorAlpha(colorBoxBack, alphaDisabled)
		colorBox = ColorAlpha(colorBox, alphaDisabled)
	end

	local sizeCornerRadius = VSKIN.GetCornerRadius()

	draw.RoundedBoxEx(sizeCornerRadius, 0, 0, w, h, colorBoxBack, false, true, false, true)
	draw.RoundedBox(sizeCornerRadius, 1, 1, w - 2, h - 2, colorBox)
end

function SKIN:PaintMenuLabelTTT2(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()

	local colorText = util.GetChangedColor(util.GetDefaultColor(colorBackground), 150)

	draw.SimpleText(
		TryT(panel:GetText()),
		panel:GetFont(),
		0,
		0.5 * h,
		colorText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintHelpLabelTTT2(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()

	local colorBox = util.GetChangedColor(colorBackground, 20)
	local colorBar = util.GetChangedColor(colorBackground, 80)
	local colorText = util.GetChangedColor(util.GetDefaultColor(colorBox), 40)

	draw.Box(0, 0, w, h, colorBox)
	draw.Box(0, 0, 4, h, colorBar)

	local textTranslated = TryT(panel:GetText())

	local textWrapped = draw.GetWrappedText(
		textTranslated,
		w - 2 * panel.paddingX,
		panel:GetFont()
	)

	local _, heightText = draw.GetTextSize(textTranslated, panel:GetFont())

	local posY = panel.paddingY
	for i = 1, #textWrapped do
		draw.SimpleText(
			textWrapped[i],
			panel:GetFont(),
			panel.paddingX,
			posY,
			colorText,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP
		)

		posY = posY + heightText
	end
end

function SKIN:PaintNumSliderTTT2(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()

	local colorBoxBack = util.GetChangedColor(colorBackground, 150)
	local colorBox = util.GetChangedColor(colorBackground, 15)

	if not panel:IsEnabled() then
		colorBoxBack = ColorAlpha(colorBoxBack, alphaDisabled)
		colorBox = ColorAlpha(colorBox, alphaDisabled)
	end

	local sizeCornerRadius = VSKIN.GetCornerRadius()

	draw.Box(0, 0, w, h, colorBoxBack)
	draw.RoundedBox(sizeCornerRadius, 1, 1, w - 2, h - 2, colorBox)
end

function SKIN:PaintSliderTextAreaTTT2(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()

	local colorBox = util.GetChangedColor(colorBackground, 150)
	local colorText = util.GetDefaultColor(colorBox)

	if not panel:IsEnabled() then
		colorBox = ColorAlpha(colorBox, alphaDisabled)
		colorText = ColorAlpha(colorText, alphaDisabled)
	end

	draw.Box(0, 0, w, h, colorBox)

	draw.SimpleText(
		panel:GetText(),
		panel:GetFont(),
		0.5 * w,
		0.5 * h,
		colorText,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_CENTER
	)
end

--[[---------------------------------------------------------
	ComboBox
-----------------------------------------------------------]]
local function DrawComboBox(w, h, panel, sizeCornerRadius, colorBox, colorText)
	draw.RoundedBox(sizeCornerRadius, 1, 1, w - 2, h - 2, colorBox)
	draw.SimpleText(
		TryT(panel:GetText()),
		panel:GetFont(),
		10,
		0.5 * h,
		colorText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintComboBoxTTT2(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()

	local colorOutline = util.GetChangedColor(colorBackground, 150)
	local colorBox = util.GetChangedColor(colorBackground, 15)
	local colorBoxHover = util.GetHoverColor(colorBox)
	local colorBoxActive = util.GetActiveColor(colorBox)

	local colorText = util.GetChangedColor(util.GetDefaultColor(colorBox), 50)

	local sizeCornerRadius = VSKIN.GetCornerRadius()

	if not panel:IsEnabled() then
		colorBoxActive = ColorAlpha(colorBoxActive, alphaDisabled)
		colorText = ColorAlpha(colorText, alphaDisabled)
		colorOutline = ColorAlpha(colorOutline, alphaDisabled)

		draw.Box(0, 0, w, h, colorOutline)
		DrawComboBox(w, h, panel, sizeCornerRadius, colorBoxActive, colorText)

		return
	end

	if panel.Depressed or panel:IsMenuOpen() then
		draw.Box(0, 0, w, h, colorOutline)
		DrawComboBox(w, h, panel, sizeCornerRadius, colorBoxActive, colorText)

		return
	end

	if panel.Hovered then
		draw.Box(0, 0, w, h, colorOutline)
		DrawComboBox(w, h, panel, sizeCornerRadius, colorBoxHover, colorText)

		return
	end

	draw.Box(0, 0, w, h, colorOutline)
	DrawComboBox(w, h, panel, sizeCornerRadius, colorBox, colorText)
end

--[[
function SKIN:PaintMenu(panel, w, h)
	draw.Box(0, 0, w, h, COLOR_RED)
end

function SKIN:PaintMenuOption(panel, w, h)
	if panel.m_bBackground && !panel:IsEnabled() then
		surface.SetDrawColor(Color( 0, 0, 0, 50 ))
		surface.DrawRect( 0, 0, w, h )
	end

	if panel.m_bBackground && ( panel.Hovered || panel.Highlight) then
		draw.Box(0, 0, w, h, COLOR_YELLOW)
	end

	if ( panel:GetChecked() ) then
		self.tex.Menu_Check( 5, h / 2 - 7, 15, 15 )
	end
end
]]

-- REGISTER DERMA SKIN
derma.DefineSkin(SKIN.Name, "TTT2 default skin for all vgui elements", SKIN)
