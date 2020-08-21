local materialClose = Material("vgui/ttt/vskin/icon_close")
local materialBack = Material("vgui/ttt/vskin/icon_back")
local materialCollapseOpened = Material("vgui/ttt/vskin/icon_collapse_opened")
local materialCollapseClosed = Material("vgui/ttt/vskin/icon_collapse_closed")

local SKIN = {}
SKIN.Name = "ttt2_default"

local TryT = LANG.TryTranslation

local utilGetDefaultColor = util.GetDefaultColor
local utilGetChangedColor = util.GetChangedColor
local utilGetHoverColor = util.GetHoverColor
local utilGetActiveColor = util.GetActiveColor
local utilColorDarken = util.ColorDarken

local vskinGetBackgroundColor = vskin.GetBackgroundColor
local vskinGetAccentColor = vskin.GetAccentColor
local vskinGetDarkAccentColor = vskin.GetDarkAccentColor
local vskinGetShadowColor = vskin.GetShadowColor
local vskinGetTitleTextColor = vskin.GetTitleTextColor
local vskinGetScrollbarTrackColor = vskin.GetScrollbarTrackColor
local vskinGetScrollbarColor = vskin.GetScrollbarColor
local vskinGetShadowSize = vskin.GetShadowSize
local vskinGetHeaderHeight = vskin.GetHeaderHeight
local vskinGetBorderSize = vskin.GetBorderSize
local vskinGetCornerRadius = vskin.GetCornerRadius

local drawRoundedBox = draw.RoundedBox
local drawRoundedBoxEx = draw.RoundedBoxEx
local drawBox = draw.Box
local drawShadowedText = draw.ShadowedText
local drawFilteredShadowedTexture = draw.FilteredShadowedTexture
local drawOutlinedBox = draw.OutlinedBox
local drawFilteredTexture = draw.FilteredTexture
local drawSimpleText = draw.SimpleText
local drawLine = draw.Line
local drawGetWrappedText = draw.GetWrappedText
local drawGetTextSize = draw.GetTextSize

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
	local colorBackground = vskinGetBackgroundColor()
	local colorAccent = vskinGetAccentColor()
	local colorAccentDark = vskinGetDarkAccentColor()
	local colorShadow = vskinGetShadowColor()
	local colorTitleText = vskinGetTitleTextColor()

	local sizeShadow = vskinGetShadowSize()
	local sizeHeader = vskinGetHeaderHeight()
	local sizeBorder = vskinGetBorderSize()

	-- DRAW SHADOW (disable clipping)
	if panel.m_bPaintShadow then
		DisableClipping(true)
		drawRoundedBox(sizeShadow, -sizeShadow, -sizeShadow, w + 2 * sizeShadow, h + 2 * sizeShadow, colorShadow)
		DisableClipping(false)
	end

	-- draw main panel box
	drawBox(0, 0, w, h, colorBackground)

	-- draw panel header area
	drawBox(0, 0, w, sizeHeader, colorAccent)
	drawBox(0, sizeHeader, w, sizeBorder, colorAccentDark)

	drawShadowedText(TryT(panel:GetTitle()), panel:GetTitleFont(), 0.5 * w, 0.5 * sizeHeader, colorTitleText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1)
end

--[[---------------------------------------------------------
	Panel
-----------------------------------------------------------]]
function SKIN:PaintPanel(panel, w, h)

end

function SKIN:PaintNavPanelTTT2(panel, w, h)
	local colorBackground = vskinGetBackgroundColor()
	local colorLine = ColorAlpha(utilGetDefaultColor(colorBackground), 200)

	drawBox(w - 1, 0, 1, h, colorLine)
end

function SKIN:PaintButtonPanelTTT2(panel, w, h)
	local colorBackground = vskinGetBackgroundColor()
	local colorLine = ColorAlpha(utilGetDefaultColor(colorBackground), 200)

	drawBox(0, 0, w, 1, colorLine)
end

function SKIN:PaintContentPanelTTT2(panel, w, h)
	local colorBackground = utilGetChangedColor(vskinGetBackgroundColor(), 30)

	drawBox(0, 0, w, h, colorBackground)
end

--[[---------------------------------------------------------
	Button
-----------------------------------------------------------]]
local function DrawClose(w, h, colorBackground, colorText, shift)
	local padding = 15

	drawBox(0, 0, w, h, colorBackground)
	drawFilteredShadowedTexture(padding, padding + shift, w - 2 * padding, h - 2 * padding, materialClose, colorText.a, colorText)
end

function SKIN:PaintWindowCloseButton(panel, w, h)
	if not panel.m_bBackground then return end

	local colorAccent = vskinGetAccentColor()
	local colorAccentHover = utilGetHoverColor(colorAccent)
	local colorAccentActive = utilGetActiveColor(colorAccent)

	local colorTitleText = utilGetDefaultColor(colorAccent)

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

	drawBox(0, 0, w, h, colorBackground)
	drawFilteredShadowedTexture(padding_w, padding_h + shift, h - 2 * padding_h, h - 2 * padding_h, materialBack, colorText.a, colorText)
	drawShadowedText(
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

	local colorAccent = vskinGetAccentColor()
	local colorAccentHover = utilGetHoverColor(colorAccent)
	local colorAccentActive = utilGetActiveColor(colorAccent)

	local colorTitleText = utilGetDefaultColor(colorAccent)

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
	local colorScrollbarTrack = vskinGetScrollbarTrackColor()

	local sizeCornerRadius = vskinGetCornerRadius()

	return drawRoundedBox(sizeCornerRadius, 0, 0, w, h, colorScrollbarTrack)
end

function SKIN:PaintScrollBarGrip(panel, w, h)
	local colorScrollbar = vskinGetScrollbarColor()
	local colorScrollbarHover = utilGetChangedColor(colorScrollbar, 10)
	local colorScrollbarActive = utilGetChangedColor(colorScrollbar, 15)

	local sizeCornerRadius = vskinGetCornerRadius()

	if not panel:IsEnabled() then
		return self.tex.Scroller.ButtonV_Disabled( 0, 0, w, h )
	end

	if panel.Depressed then
		return drawRoundedBox(sizeCornerRadius, 0, 0, w, h, colorScrollbarActive)
	end

	if panel.Hovered then
		return drawRoundedBox(sizeCornerRadius, 0, 0, w, h, colorScrollbarHover)
	end

	return drawRoundedBox(sizeCornerRadius, 0, 0, w, h, colorScrollbar)
end

function SKIN:PaintButtonDown(panel, w, h)
	if not panel.m_bBackground then return end

	local colorAccent = vskinGetAccentColor()
	local colorAccentHover = utilGetHoverColor(colorAccent)
	local colorAccentActive = utilGetActiveColor(colorAccent)

	local sizeCornerRadius = vskinGetCornerRadius()

	if not panel:IsEnabled() then
		return self.tex.Scroller.DownButton_Dead( 0, 0, w, h )
	end

	if panel.Depressed or panel:IsSelected() then
		return drawRoundedBox(sizeCornerRadius, 0, 0, w, h, colorAccentActive)
	end

	if panel.Hovered then
		return drawRoundedBox(sizeCornerRadius, 0, 0, w, h, colorAccentHover)
	end

	return drawRoundedBox(sizeCornerRadius, 0, 0, w, h, colorAccent)
end

function SKIN:PaintButtonUp(panel, w, h)
	if not panel.m_bBackground then return end

	local colorAccent = vskinGetAccentColor()
	local colorAccentHover = utilGetHoverColor(colorAccent)
	local colorAccentActive = utilGetActiveColor(colorAccent)

	local sizeCornerRadius = vskinGetCornerRadius()

	if not panel:IsEnabled() then
		return self.tex.Scroller.DownButton_Dead( 0, 0, w, h )
	end

	if panel.Depressed or panel:IsSelected() then
		return drawRoundedBox(sizeCornerRadius, 0, 0, w, h, colorAccentActive)
	end

	if panel.Hovered then
		return drawRoundedBox(sizeCornerRadius, 0, 0, w, h, colorAccentHover)
	end

	return drawRoundedBox(sizeCornerRadius, 0, 0, w, h, colorAccent)
end

local function DrawMenuButton(w, h, panel, colorOutline, colorIcon, colorText, colorDescription, shift)
	local paddingText = 10
	local paddingIcon = 25

	drawOutlinedBox(0, 0, w, h, 1, colorOutline)
	drawFilteredTexture(paddingIcon, paddingIcon + shift, h - 2 * paddingIcon, h - 2 * paddingIcon, panel:GetImage(), colorIcon.a, colorIcon)
	drawSimpleText(
		TryT(panel:GetTitle()),
		panel:GetTitleFont(),
		h,
		paddingText + shift,
		colorText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_TOP
	)

	local desc_wrapped = drawGetWrappedText(TryT(panel:GetDescription()), w - h - 2 * paddingText, panel:GetDescriptionFont())

	local line_pos = 35
	for i = 1, #desc_wrapped do
		drawSimpleText(
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

	local colorBackground = vskinGetBackgroundColor()

	local colorDefault = utilGetDefaultColor(colorBackground)

	local colorText = utilGetChangedColor(colorDefault, 65)
	local colorTextHover = utilGetChangedColor(colorDefault, 50)
	local colorDescription = utilGetChangedColor(colorDefault, 145)
	local colorDescriptionHover = utilGetChangedColor(colorDefault, 135)
	local colorIcon = utilGetChangedColor(colorDefault, 170)
	local colorIconHover = utilGetChangedColor(colorDefault, 160)

	if not panel:IsEnabled() then
		return self.tex.Button_Dead(0, 0, w, h)
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
	drawBox(0, 0, sizeBorder, h, colorBar)
	drawBox(sizeBorder, 0, w - sizeBorder, h, colorBackground)

	drawSimpleText(
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

	local colorElemBackground = vskinGetBackgroundColor()

	local colorText = utilGetChangedColor(utilGetDefaultColor(colorElemBackground), 75)
	local colorTextHover = utilGetHoverColor(colorText)
	local colorTextActive = utilGetActiveColor(colorText)

	local colorAccent = vskinGetAccentColor()
	local colorAccentHover = utilGetHoverColor(colorAccent)
	local colorAccentActive = utilGetActiveColor(colorAccent)

	local colorBackground = ColorAlpha(colorAccent, 50)
	local colorBackgroundHover = utilGetHoverColor(colorBackground)
	local colorBackgroundActive = utilGetActiveColor(colorBackground)

	if not panel:IsActive() then
		colorAccent = colorElemBackground
		colorBackground = colorElemBackground
	end

	local sizeBorder = vskinGetBorderSize()


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
	drawRoundedBox(4, 0, 0, w, h, colorBox)
	drawRoundedBox(4, offset + 3, 3, h - 6, h - 6, colorCenter)
end

function SKIN:PaintCheckBox(panel, w, h)
	local colorBackground = vskinGetBackgroundColor()

	local colorBox = utilGetChangedColor(colorBackground, 15)

	local colorAccent = vskinGetAccentColor()
	local colorAccentHover = ColorAlpha(utilGetHoverColor(colorAccent), 200)
	local colorCenter = utilGetChangedColor(colorBackground, 150)

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
	local colorBackground = vskinGetBackgroundColor()

	local colorBox = utilGetChangedColor(colorBackground, 150)
	local colorText = utilGetDefaultColor(colorBox)

	local sizeCornerRadius = vskinGetCornerRadius()

	if not panel:IsEnabled() then
		colorBox = ColorAlpha(colorBox, alphaDisabled)
		colorText = ColorAlpha(colorText, alphaDisabled)
	end

	drawRoundedBoxEx(sizeCornerRadius, 0, 0, w, h, colorBox, true, false, true, false)

	drawSimpleText(
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
	local colorBackground = vskinGetBackgroundColor()
	local colorAccent = vskinGetAccentColor()

	local sizeBorder = vskinGetBorderSize()

	drawBox(0, 0, w, h, colorBackground)
	drawBox(0, h - sizeBorder, w, sizeBorder, colorAccent)
end

function SKIN:PaintCategoryHeaderTTT2(panel, w, h)
	local paddingX = 10
	local paddingY = 10

	local colorBackground = vskinGetBackgroundColor()

	local colorLine = utilGetChangedColor(colorBackground, 50)

	local colorText = utilGetChangedColor(utilGetDefaultColor(colorBackground), 50)

	drawBox(0, 0, w, h, colorBackground)

	if panel:GetParent():GetExpanded() then
		drawLine(0, h - 1, w, h - 1, colorLine)
		drawFilteredShadowedTexture(paddingX, paddingY + 1, h - 2 * paddingY, h - 2 * paddingY, materialCollapseOpened, colorText.a * 0.5, colorText)
	else
		drawFilteredShadowedTexture(paddingX, paddingY, h - 2 * paddingY, h - 2 * paddingY, materialCollapseClosed, colorText.a * 0.5, colorText)
	end

	drawSimpleText(
		string.upper(TryT(panel.text)),
		panel:GetFont(),
		h,
		0.5 * h,
		colorText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
end

local function DrawButton(w, h, panel, sizeBorder, colorLine, colorBox, colorText, shift)
	drawBox(0, 0, w, h, colorBox)
	drawBox(0, h - sizeBorder, w, sizeBorder, colorLine)

	drawShadowedText(
		string.upper(TryT(panel:GetText())),
		panel:GetFont(),
		0.5 * w,
		0.5 * (h - sizeBorder) + shift,
		colorText,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintButtonTTT2(panel, w, h)
	local colorAccent = vskinGetAccentColor()
	local colorAccentHover = utilGetHoverColor(colorAccent)
	local colorAccentActive = utilGetActiveColor(colorAccent)

	local colorAccentDark = vskinGetDarkAccentColor()
	local colorAccentDarkHover = utilGetHoverColor(colorAccentDark)
	local colorAccentDarkActive = utilGetActiveColor(colorAccentDark)

	local colorAccentDisabled = utilGetChangedColor(utilGetDefaultColor(vskinGetBackgroundColor()), 150)
	local colorAccentDarkDisabled = utilColorDarken(colorAccentDisabled, 50)

	local sizeBorder = vskinGetBorderSize()

	if not panel:IsEnabled() then
		local colorText = ColorAlpha(utilGetDefaultColor(colorAccentDisabled), 220)

		return DrawButton(w, h, panel, sizeBorder, colorAccentDarkDisabled, colorAccentDisabled, colorText, 0)
	end

	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		local colorText = ColorAlpha(utilGetDefaultColor(colorAccent), 220)

		return DrawButton(w, h, panel, sizeBorder, colorAccentDarkActive, colorAccentActive, colorText, 1)
	end

	if panel.Hovered then
		local colorText = ColorAlpha(utilGetDefaultColor(colorAccent), 220)

		return DrawButton(w, h, panel, sizeBorder, colorAccentDarkHover, colorAccentHover, colorText, 0)
	end

	local colorText = ColorAlpha(utilGetDefaultColor(colorAccent), 220)

	return DrawButton(w, h, panel, sizeBorder, colorAccentDark, colorAccent, colorText, 0)
end

local function DrawFormButton(w, h, panel, sizeCornerRadius, colorBoxBack, colorBox, colorText, shift)
	local pad = 6

	drawRoundedBoxEx(sizeCornerRadius, 0, 0, w, h, colorBoxBack, false, true, false, true)
	drawRoundedBox(sizeCornerRadius, 1, 1, w - 2, h - 2, colorBox)

	drawFilteredShadowedTexture(pad, pad + shift, w - 2 * pad, h - 2 * pad, panel.material, colorText.a, colorText)
end

function SKIN:PaintFormButtonIconTTT2(panel, w, h)
	local colorBackground = vskinGetBackgroundColor()

	local colorBoxBack = utilGetChangedColor(colorBackground, 150)
	local colorBox = vskinGetAccentColor()
	local colorText = ColorAlpha(utilGetDefaultColor(colorBox), 150)

	local sizeCornerRadius = vskinGetCornerRadius()
	local shift = 0

	if not panel:IsEnabled() then
		colorBoxBack = ColorAlpha(colorBoxBack, alphaDisabled)
		colorBox = ColorAlpha(colorBox, alphaDisabled)
		colorText = ColorAlpha(colorText, alphaDisabled)
	elseif panel.noDefault then
		colorBox = ColorAlpha(colorBox, alphaDisabled)
		colorText = ColorAlpha(colorText, alphaDisabled)
	elseif panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		colorBox = utilGetActiveColor(colorBox)
		shift = 1
	elseif panel.Hovered then
		colorBox = utilGetHoverColor(colorBox)
	end

	return DrawFormButton(w, h, panel, sizeCornerRadius, colorBoxBack, colorBox, colorText, shift)
end

local function DrawFormButtonText(w, h, panel, sizeCornerRadius, colorBoxBack, colorBox, colorText, shift)
	drawRoundedBoxEx(sizeCornerRadius, 0, 0, w, h, colorBoxBack, false, true, false, true)
	drawRoundedBox(sizeCornerRadius, 1, 1, w - 2, h - 2, colorBox)

	drawShadowedText(
		string.upper(TryT(panel:GetText())),
		panel:GetFont(),
		0.5 * w,
		0.5 * h + shift,
		colorText,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintBinderButtonTTT2(panel, w, h)
	local colorBackground = vskinGetBackgroundColor()

	local colorBoxBack = utilGetChangedColor(colorBackground, 150)
	local colorBox = vskinGetAccentColor()
	local colorText = ColorAlpha(utilGetDefaultColor(colorBox), 150)

	local sizeCornerRadius = vskinGetCornerRadius()
	local shift = 0

	if not panel:IsEnabled() then
		colorBoxBack = ColorAlpha(colorBoxBack, alphaDisabled)
		colorBox = ColorAlpha(colorBox, alphaDisabled)
		colorText = ColorAlpha(colorText, alphaDisabled)
	elseif panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		colorBox = utilGetActiveColor(colorBox)
		shift = 1
	elseif panel.Hovered then
		colorBox = utilGetHoverColor(colorBox)
	end

	return DrawFormButtonText(w, h, panel, sizeCornerRadius, colorBoxBack, colorBox, colorText, shift)
end

function SKIN:PaintLabelTTT2(panel, w, h)
	local colorBackground = vskinGetBackgroundColor()

	local colorText = utilGetChangedColor(utilGetDefaultColor(colorBackground), 40)

	drawSimpleText(
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
	local colorBackground = vskinGetBackgroundColor()

	local colorBox = utilGetChangedColor(colorBackground, 150)
	local colorText = utilGetDefaultColor(colorBox)

	if not panel:IsEnabled() then
		colorBox = ColorAlpha(colorBox, alphaDisabled)
		colorText = ColorAlpha(colorText, alphaDisabled)
	end

	local sizeCornerRadius = vskinGetCornerRadius()

	drawRoundedBoxEx(sizeCornerRadius, 0, 0, w, h, colorBox, true, false, true, false)

	drawSimpleText(
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
	local colorBackground = vskinGetBackgroundColor()

	local colorBoxBack = utilGetChangedColor(colorBackground, 150)
	local colorBox = utilGetChangedColor(colorBackground, 15)

	if not panel:IsEnabled() then
		colorBoxBack = ColorAlpha(colorBoxBack, alphaDisabled)
		colorBox = ColorAlpha(colorBox, alphaDisabled)
	end

	local sizeCornerRadius = vskinGetCornerRadius()

	drawRoundedBoxEx(sizeCornerRadius, 0, 0, w, h, colorBoxBack, false, true, false, true)
	drawRoundedBox(sizeCornerRadius, 1, 1, w - 2, h - 2, colorBox)
end

function SKIN:PaintMenuLabelTTT2(panel, w, h)
	local colorBackground = vskinGetBackgroundColor()

	local colorText = utilGetChangedColor(utilGetDefaultColor(colorBackground), 150)

	drawSimpleText(
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
	local colorBackground = vskinGetBackgroundColor()

	local colorBox = utilGetChangedColor(colorBackground, 20)
	local colorBar = utilGetChangedColor(colorBackground, 80)
	local colorText = utilGetChangedColor(utilGetDefaultColor(colorBox), 40)

	drawBox(0, 0, w, h, colorBox)
	drawBox(0, 0, 4, h, colorBar)

	local textTranslated = TryT(panel:GetText())

	local textWrapped = drawGetWrappedText(
		textTranslated,
		w - 2 * panel.paddingX,
		panel:GetFont()
	)

	local _, heightText = drawGetTextSize(textTranslated, panel:GetFont())

	local posY = panel.paddingY
	for i = 1, #textWrapped do
		drawSimpleText(
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

function SKIN:PaintSliderKnob(panel, w, h)
	local colorAccent = vskinGetAccentColor()
	local colorAccentHover = utilGetHoverColor(colorAccent)
	local colorAccentActive = utilGetActiveColor(colorAccent)

	if not panel:IsEnabled() then
		colorAccent = ColorAlpha(colorAccent, alphaDisabled)
		colorAccentHover = colorAccent
		colorAccentActive = colorAccent
	end

	if panel.Depressed then
		return drawRoundedBox(math.floor(w * 0.5), 0, 0, w, h, colorAccentActive)
	end

	if panel.Hovered then
		return drawRoundedBox(math.floor(w * 0.5), 0, 0, w, h, colorAccentHover)
	end

	return drawRoundedBox(math.floor(w * 0.5), 0, 0, w, h, colorAccent)
end

function SKIN:PaintNumSliderTTT2(panel, w, h)
	local pad = 5

	local colorBackground = vskinGetBackgroundColor()
	local colorAccent = vskinGetAccentColor()

	local colorBoxBack = utilGetChangedColor(colorBackground, 150)
	local colorBox = utilGetChangedColor(colorBackground, 15)
	local colorSlider = utilGetChangedColor(colorBackground, 75)

	if not panel:IsEnabled() then
		colorAccent = ColorAlpha(colorAccent, alphaDisabled)
		colorBoxBack = ColorAlpha(colorBoxBack, alphaDisabled)
		colorBox = ColorAlpha(colorBox, alphaDisabled)
		colorSlider = ColorAlpha(colorSlider, alphaDisabled)
	end

	local sizeCornerRadius = vskinGetCornerRadius()

	drawBox(0, 0, w, h, colorBoxBack)
	drawRoundedBox(sizeCornerRadius, 1, 1, w - 2, h - 2, colorBox)

	-- draw selection line
	drawBox(5, 0.5 * h - 1, w - 2 * pad, 2, colorSlider)
	drawBox(5, 0.5 * h - 1, (w - pad) * panel:GetFraction() - pad, 2, colorAccent)
end

function SKIN:PaintSliderTextAreaTTT2(panel, w, h)
	local colorBackground = vskinGetBackgroundColor()

	local colorBox = utilGetChangedColor(colorBackground, 150)
	local colorText = utilGetDefaultColor(colorBox)

	if not panel:IsEnabled() then
		colorBox = ColorAlpha(colorBox, alphaDisabled)
		colorText = ColorAlpha(colorText, alphaDisabled)
	end

	drawBox(0, 0, w, h, colorBox)

	drawSimpleText(
		panel:GetText(),
		panel:GetFont(),
		0.5 * w,
		0.5 * h,
		colorText,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintBinderPanelTTT2(panel, w, h)
	local colorBackground = vskinGetBackgroundColor()

	local colorBoxBack = utilGetChangedColor(colorBackground, 150)

	if not panel:IsEnabled() then
		colorBoxBack = ColorAlpha(colorBoxBack, alphaDisabled)
	end

	drawBox(0, 0, w, h, colorBoxBack)
end

--[[---------------------------------------------------------
	ComboBox
-----------------------------------------------------------]]
local function DrawComboBox(w, h, panel, sizeCornerRadius, colorBox, colorText)
	drawRoundedBox(sizeCornerRadius, 1, 1, w - 2, h - 2, colorBox)
	drawSimpleText(
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
	local colorBackground = vskinGetBackgroundColor()

	local colorOutline = utilGetChangedColor(colorBackground, 150)
	local colorBox = utilGetChangedColor(colorBackground, 15)
	local colorBoxHover = utilGetHoverColor(colorBox)
	local colorBoxActive = utilGetActiveColor(colorBox)

	local colorText = utilGetChangedColor(utilGetDefaultColor(colorBox), 50)

	local sizeCornerRadius = vskinGetCornerRadius()

	if not panel:IsEnabled() then
		colorBoxActive = ColorAlpha(colorBoxActive, alphaDisabled)
		colorText = ColorAlpha(colorText, alphaDisabled)
		colorOutline = ColorAlpha(colorOutline, alphaDisabled)

		drawBox(0, 0, w, h, colorOutline)
		DrawComboBox(w, h, panel, sizeCornerRadius, colorBoxActive, colorText)

		return
	end

	if panel.Depressed or panel:IsMenuOpen() then
		drawBox(0, 0, w, h, colorOutline)
		DrawComboBox(w, h, panel, sizeCornerRadius, colorBoxActive, colorText)

		return
	end

	if panel.Hovered then
		drawBox(0, 0, w, h, colorOutline)
		DrawComboBox(w, h, panel, sizeCornerRadius, colorBoxHover, colorText)

		return
	end

	drawBox(0, 0, w, h, colorOutline)
	DrawComboBox(w, h, panel, sizeCornerRadius, colorBox, colorText)
end

-- REGISTER DERMA SKIN
derma.DefineSkin(SKIN.Name, "TTT2 default skin for all vgui elements", SKIN)
