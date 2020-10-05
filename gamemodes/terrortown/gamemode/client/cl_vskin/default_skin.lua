local materialClose = Material("vgui/ttt/vskin/icon_close")
local materialBack = Material("vgui/ttt/vskin/icon_back")
local materialCollapseOpened = Material("vgui/ttt/vskin/icon_collapse_opened")
local materialCollapseClosed = Material("vgui/ttt/vskin/icon_collapse_closed")

local SKIN = {
	Name = "ttt2_default"
}

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

local colors = {}
local sizes = {}

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

function SKIN:UpdatedVSkin()
	colors = {
		background = vskinGetBackgroundColor(),
		accent = vskinGetAccentColor(),
		accentHover = utilGetHoverColor(vskinGetAccentColor()),
		accentActive = utilGetActiveColor(vskinGetAccentColor()),
		accentText = utilGetDefaultColor(vskinGetAccentColor()),
		accentDark = vskinGetDarkAccentColor(),
		accentDarkHover = utilGetHoverColor(vskinGetDarkAccentColor()),
		accentDarkActive = utilGetActiveColor(vskinGetDarkAccentColor()),
		sliderInactive = utilGetChangedColor(vskinGetBackgroundColor(), 75),
		shadow = vskinGetShadowColor(),
		titleText = vskinGetTitleTextColor(),
		default = utilGetDefaultColor(vskinGetBackgroundColor()),
		content = utilGetChangedColor(vskinGetBackgroundColor(), 30),
		handle = utilGetChangedColor(vskinGetBackgroundColor(), 15),
		settingsBox = utilGetChangedColor(vskinGetBackgroundColor(), 150),
		helpBox = utilGetChangedColor(vskinGetBackgroundColor(), 20),
		helpBar = utilGetChangedColor(vskinGetBackgroundColor(), 80),
		helpText = utilGetChangedColor(utilGetDefaultColor(utilGetChangedColor(vskinGetBackgroundColor(), 20)), 40),
		settingsText = utilGetDefaultColor(utilGetChangedColor(vskinGetBackgroundColor(), 150)),
		scrollBar = vskinGetScrollbarColor(),
		scrollBarActive = utilColorDarken(vskinGetScrollbarColor(), 5)
	}

	sizes = {
		shadow = vskinGetShadowSize(),
		header = vskinGetHeaderHeight(),
		border = vskinGetBorderSize(),
		cornerRadius = vskinGetCornerRadius()
	}
end

function SKIN:PaintFrameTTT2(panel, w, h)
	if panel:GetPaintShadow() then
		DisableClipping(true)
		drawRoundedBox(sizes.shadow, -sizes.shadow, -sizes.shadow, w + 2 * sizes.shadow, h + 2 * sizes.shadow, colors.shadow)
		DisableClipping(false)
	end

	-- draw main panel box
	drawBox(0, 0, w, h, colors.background)

	-- draw panel header area
	drawBox(0, 0, w, sizes.header, colors.accent)
	drawBox(0, sizes.header, w, sizes.border, colors.accentDark)

	drawShadowedText(TryT(panel:GetTitle()), panel:GetTitleFont(), 0.5 * w, 0.5 * sizes.header, colors.titleText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1)
end

function SKIN:PaintPanel(panel, w, h)

end

function SKIN:PaintNavPanelTTT2(panel, w, h)
	drawBox(w - 1, 0, 1, h, ColorAlpha(colors.default, 200))
end

function SKIN:PaintButtonPanelTTT2(panel, w, h)
	drawBox(0, 0, w, 1, ColorAlpha(colors.default, 200))
end

function SKIN:PaintContentPanelTTT2(panel, w, h)
	drawBox(0, 0, w, h, colors.content)
end

function SKIN:PaintWindowCloseButton(panel, w, h)
	if not panel.m_bBackground then return end

	local colorBackground = colors.accent
	local colorText = ColorAlpha(colors.accentText, 150)
	local shift = 0
	local padding = 15

	if not panel:IsEnabled() then
		colorText = ColorAlpha(colors.accentText, 70)
	elseif panel.Depressed or panel:IsSelected() then
		colorBackground = colors.accentActive
		colorText = ColorAlpha(colors.accentText, 200)
		shift = 1
	elseif panel.Hovered then
		colorBackground = colors.accentHover
		colorText = colors.accentText
	end

	drawBox(0, 0, w, h, colorBackground)
	drawFilteredShadowedTexture(padding, padding + shift, w - 2 * padding, h - 2 * padding, materialClose, colorText.a, colorText)
end

function SKIN:PaintWindowBackButton(panel, w, h)
	if not panel.m_bBackground then return end

	local colorBackground = colors.accent
	local colorText = ColorAlpha(colors.accentText, 150)
	local shift = 0
	local padding_w = 10
	local padding_h = 15

	if not panel:IsEnabled() then
		colorText = ColorAlpha(colors.accentText, 70)
	elseif panel.Depressed or panel:IsSelected() then
		colorBackground = colors.accentActive
		colorText = ColorAlpha(colors.accentText, 200)
		shift = 1
	elseif panel.Hovered then
		colorBackground = colors.accentHover
		colorText = colors.accentText
	end

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

function SKIN:PaintScrollBarGrip(panel, w, h)
	local colorScrollbar = colors.scrollBar
	local posX = 4
	local sizeX = w - 8

	if panel.Depressed then
		colorScrollbar = colors.scrollBarActive
		posX = 0
		sizeX = w
	elseif panel.Hovered then
		posX = 0
		sizeX = w
	end

	drawRoundedBox(sizes.cornerRadius, posX, 0, sizeX, h, colorScrollbar)
end

function SKIN:PaintMenuButtonTTT2(panel, w, h)
	if not panel.m_bBackground then return end

	local colorOutline = utilGetChangedColor(colors.default, 170)
	local colorDescription = utilGetChangedColor(colors.default, 145)
	local colorText = utilGetChangedColor(colors.default, 65)
	local colorIcon = utilGetChangedColor(colors.default, 170)
	local shift = 0
	local paddingText = 10
	local paddingIcon = 25

	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		colorOutline = utilGetChangedColor(colors.default, 135)
		colorDescription = utilGetChangedColor(colors.default, 135)
		colorIcon = utilGetChangedColor(colors.default, 160)
		colorText = utilGetChangedColor(colors.default, 50)
		shift = 1
	elseif panel.Hovered then
		colorOutline = utilGetChangedColor(colors.default, 135)
		colorDescription = utilGetChangedColor(colors.default, 135)
		colorIcon = utilGetChangedColor(colors.default, 160)
		colorText = utilGetChangedColor(colors.default, 50)
	end

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

function SKIN:PaintSubMenuButtonTTT2(panel, w, h)
	if not panel.m_bBackground then return end

	local colorBackground = colors.background
	local colorBar = colors.background
	local colorText = utilGetChangedColor(colors.default, 75)
	local shift = 0

	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		colorBackground = utilGetActiveColor(ColorAlpha(colors.accent, 50))
		colorBar = colors.accentActive
		colorText = utilGetActiveColor(utilGetChangedColor(colors.default, 25))
		shift = 1
	elseif panel.Hovered then
		colorBackground = utilGetHoverColor(ColorAlpha(colors.accent, 50))
		colorBar = colors.accentHover
		colorText = utilGetHoverColor(utilGetChangedColor(colors.default, 75))
	elseif panel:IsActive() then
		colorBackground = utilGetHoverColor(ColorAlpha(colors.accent, 50))
		colorBar = colors.accentHover
		colorText = utilGetHoverColor(utilGetChangedColor(colors.default, 75))
	end

	drawBox(0, 0, sizes.border, h, colorBar)
	drawBox(sizes.border, 0, w - sizes.border, h, colorBackground)

	drawSimpleText(
		TryT(panel:GetTitle()),
		panel:GetTitleFont(),
		sizes.border + 20,
		0.5 * h + shift,
		colorText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintCheckBox(panel, w, h)
	local colorBox, colorCenter, offset

	if panel:GetChecked() then
		if not panel:IsEnabled() then
			colorBox = ColorAlpha(colors.handle, alphaDisabled)
			colorCenter = ColorAlpha(colors.handle, alphaDisabled)
			offset = w - h
		elseif panel.Hovered then
			colorBox = colors.handle
			colorCenter = colors.accentHover
			offset = w - h
		else
			colorBox = colors.handle
			colorCenter = colors.accent
			offset = w - h
		end
	else
		if not panel:IsEnabled() then
			colorBox = ColorAlpha(colors.handle, alphaDisabled)
			colorCenter = ColorAlpha(colors.settingsBox, alphaDisabled)
			offset = 0
		elseif panel.Hovered then
			colorBox = colors.handle
			colorCenter = colors.accentHover
			offset = 0
		else
			colorBox = colors.handle
			colorCenter = colors.settingsBox
			offset = 0
		end
	end

	drawRoundedBox(4, 0, 0, w, h, colorBox)
	drawRoundedBox(4, offset + 3, 3, h - 6, h - 6, colorCenter)
end

function SKIN:PaintCheckBoxLabel(panel, w, h)
	local colorBox = colors.settingsBox
	local colorText = colors.settingsText

	if not panel:IsEnabled() then
		colorBox = ColorAlpha(colors.settingsBox, alphaDisabled)
		colorText = ColorAlpha(colors.settingsText, alphaDisabled)
	end

	drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colorBox, true, false, true, false)

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

function SKIN:PaintCollapsibleCategoryTTT2(panel, w, h)
	drawBox(0, 0, w, h, colors.background)
	drawBox(0, h - sizes.border, w, sizes.border, colors.accent)
end

function SKIN:PaintCategoryHeaderTTT2(panel, w, h)
	local colorLine = utilGetChangedColor(colors.background, 50)
	local colorText = utilGetChangedColor(colors.default, 50)
	local paddingX = 10
	local paddingY = 10

	drawBox(0, 0, w, h, colors.background)

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

function SKIN:PaintButtonTTT2(panel, w, h)
	local colorLine = colors.accentDark
	local colorBox = colors.accent
	local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)
	local shift = 0

	if not panel:IsEnabled() then
		local colorAccentDisabled = utilGetChangedColor(colors.default, 150)

		colorLine = utilColorDarken(colorAccentDisabled, 50)
		colorBox = utilGetChangedColor(colors.default, 150)
		colorText = ColorAlpha(utilGetDefaultColor(colorAccentDisabled), 220)
	elseif panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		colorLine = colors.accentDarkActive
		colorBox = colors.accentActive
		colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)
		shift = 1
	elseif panel.Hovered then
		colorLine = colors.accentDarkHover
		colorBox = colors.accentHover
		colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)
	end

	drawBox(0, 0, w, h, colorBox)
	drawBox(0, h - sizes.border, w, sizes.border, colorLine)

	drawShadowedText(
		string.upper(TryT(panel:GetText())),
		panel:GetFont(),
		0.5 * w,
		0.5 * (h - sizes.border) + shift,
		colorText,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintFormButtonIconTTT2(panel, w, h)
	local colorBoxBack = colors.settingsBox
	local colorBox = colors.accent
	local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)
	local shift = 0
	local pad = 6

	if not panel:IsEnabled() then
		colorBoxBack = ColorAlpha(colors.settingsBox, alphaDisabled)
		colorBox = ColorAlpha(colors.accent, alphaDisabled)
		colorText = ColorAlpha(utilGetDefaultColor(colors.accent), alphaDisabled)
	elseif panel.noDefault then
		colorBoxBack = colors.settingsBox
		colorBox = ColorAlpha(colors.accent, alphaDisabled)
		colorText = ColorAlpha(utilGetDefaultColor(colors.accent), alphaDisabled)
	elseif panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		colorBoxBack = colors.settingsBox
		colorBox = colors.accentActive
		colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)
		shift = 1
	elseif panel.Hovered then
		colorBoxBack = colors.settingsBox
		colorBox = colors.accentHover
		colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)
	end

	drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colorBoxBack, false, true, false, true)
	drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, colorBox)

	drawFilteredShadowedTexture(pad, pad + shift, w - 2 * pad, h - 2 * pad, panel.material, colorText.a, colorText)
end

function SKIN:PaintBinderButtonTTT2(panel, w, h)
	local colorBoxBack = colors.settingsBox
	local colorBox = colors.accent
	local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)
	local shift = 0

	if not panel:IsEnabled() then
		colorBoxBack = ColorAlpha(colors.settingsBox, alphaDisabled)
		colorBox = ColorAlpha(colors.accent, alphaDisabled)
		colorText = ColorAlpha(colors.settingsText, alphaDisabled)
	end

	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		colorBoxBack = colors.settingsBox
		colorBox = colors.accentActive
		colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)
		shift = 1
	end

	if panel.Hovered then
		colorBoxBack = colors.settingsBox
		colorBox = colors.accentActive
		colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)
	end

	drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colorBoxBack, false, true, false, true)
	drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, colorBox)

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

function SKIN:PaintLabelTTT2(panel, w, h)
	drawSimpleText(
		TryT(panel:GetText()),
		panel:GetFont(),
		0,
		0.5 * h,
		utilGetChangedColor(colors.default, 40),
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintFormLabelTTT2(panel, w, h)
	local colorText = colors.settingsText
	local colorBox = colors.settingsBox

	if not panel:IsEnabled() then
		colorText = ColorAlpha(colors.settingsText, alphaDisabled)
		colorBox = ColorAlpha(colors.settingsBox, alphaDisabled)
	end

	drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colorBox, true, false, true, false)
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
	local colorBox = colors.settingsBox
	local colorHandle = colors.handle

	if not panel:IsEnabled() then
		colorBox = ColorAlpha(colors.settingsBox, alphaDisabled)
		colorHandle = ColorAlpha(colors.handle, alphaDisabled)
	end

	drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colorBox, false, true, false, true)
	drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, colorHandle)
end

function SKIN:PaintMenuLabelTTT2(panel, w, h)
	drawSimpleText(
		TryT(panel:GetText()),
		panel:GetFont(),
		0,
		0.5 * h,
		colors.settingsText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintHelpLabelTTT2(panel, w, h)
	drawBox(0, 0, w, h, colors.helpBox)
	drawBox(0, 0, 4, h, colors.helpBar)

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
			colors.helpText,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP
		)

		posY = posY + heightText
	end
end

function SKIN:PaintSliderKnob(panel, w, h)
	local colorBox = colors.accent

	if not panel:IsEnabled() then
		colorBox = ColorAlpha(colors.accent, alphaDisabled)
	end

	if panel.Depressed then
		colorBox = colors.accentActive
	end

	if panel.Hovered then
		colorBox = colors.accentHover
	end

	drawRoundedBox(math.floor(w * 0.5), 0, 0, w, h, colorBox)
end

function SKIN:PaintNumSliderTTT2(panel, w, h)
	local colorBox = colors.settingsBox
	local colorHandle = colors.handle
	local colorLineActive = colors.accent
	local colorLinePassive = colors.sliderInactive
	local pad = 5

	if not panel:IsEnabled() then
		colorBox = ColorAlpha(colors.settingsBox, alphaDisabled)
		colorHandle = ColorAlpha(colors.handle, alphaDisabled)
		colorLineActive = ColorAlpha(colors.accent, alphaDisabled)
		colorLinePassive = ColorAlpha(colors.sliderInactive, alphaDisabled)
	end

	drawBox(0, 0, w, h, colorBox)
	drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, colorHandle)

	-- draw selection line
	drawBox(5, 0.5 * h - 1, w - 2 * pad, 2, colorLinePassive)
	drawBox(5, 0.5 * h - 1, (w - pad) * panel:GetFraction() - pad, 2, colorLineActive)
end

function SKIN:PaintSliderTextAreaTTT2(panel, w, h)
	local colorBox = colors.settingsBox
	local colorText = colors.settingsText

	if not panel:IsEnabled() then
		colorBox = ColorAlpha(colors.settingsBox, alphaDisabled)
		colorText = ColorAlpha(colors.settingsText, alphaDisabled)
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
	local colorBox = colors.settingsBox

	if not panel:IsEnabled() then
		colorBox = ColorAlpha(colors.settingsBox, alphaDisabled)
	end

	drawBox(0, 0, w, h, colorBox)
end

function SKIN:PaintComboBoxTTT2(panel, w, h)
	local colorBox = colors.settingsBox
	local colorHandle = colors.handle
	local colorText = utilGetChangedColor(utilGetDefaultColor(colors.handle), 50)

	if not panel:IsEnabled() then
		colorBox = ColorAlpha(colors.settingsBox, alphaDisabled)
		colorHandle = ColorAlpha(utilGetActiveColor(colors.handle), alphaDisabled)
		colorText = ColorAlpha(colorText, alphaDisabled)
	end

	if panel.Depressed or panel:IsMenuOpen() then
		colorHandle = utilGetHoverColor(colors.handle)
	end

	if panel.Hovered then
		colorHandle = utilGetActiveColor(colors.handle)
	end

	drawBox(0, 0, w, h, colorBox)
	drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, colorHandle)
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

-- REGISTER DERMA SKIN
derma.DefineSkin(SKIN.Name, "TTT2 default skin for all vgui elements", SKIN)
