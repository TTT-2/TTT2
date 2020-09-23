local materialClose = Material("vgui/ttt/vskin/icon_close")
local materialBack = Material("vgui/ttt/vskin/icon_back")
local materialCollapseOpened = Material("vgui/ttt/vskin/icon_collapse_opened")
local materialCollapseClosed = Material("vgui/ttt/vskin/icon_collapse_closed")
local materialRhombus = Material("vgui/ttt/vskin/rhombus")

local SKIN = {}
SKIN.Name = "ttt2_default"

local TryT = LANG.TryTranslation

local mathRound = math.Round

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
surface.CreateAdvancedFont("DermaTTT2TextLarger", {font = "Trebuchet24", size = 20, weight = 900})
surface.CreateAdvancedFont("DermaTTT2TextHuge", {font = "Trebuchet24", size = 72, weight = 900})

function SKIN:UpdatedVSkin()
	colors = {
		background = vskinGetBackgroundColor(),
		accent = vskinGetAccentColor(),
		accentHover = utilGetHoverColor(vskinGetAccentColor()),
		accentActive = utilGetActiveColor(vskinGetAccentColor()),
		accentText = utilGetDefaultColor(vskinGetAccentColor()),
		accentDark = vskinGetDarkAccentColor(),
		accentDarkHover = utilGetHoverColor(vskinGetDarkAccentColor()),
		accentDarkactive = utilGetActiveColor(vskinGetDarkAccentColor()),
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

--[[---------------------------------------------------------
	Frame
-----------------------------------------------------------]]
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

--[[---------------------------------------------------------
	Panel
-----------------------------------------------------------]]
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

	if not panel:IsEnabled() then
		return DrawClose(w, h, colors.accent, ColorAlpha(colors.accentText, 70), 0)
	end

	if panel.Depressed or panel:IsSelected() then
		return DrawClose(w, h, colors.accentActive, ColorAlpha(colors.accentText, 200), 1)
	end

	if panel.Hovered then
		return DrawClose(w, h, colors.accentHover, colors.accentText, 0)
	end

	return DrawClose(w, h, colors.accent, ColorAlpha(colors.accentText, 150), 0)
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

	if not panel:IsEnabled() then
		return DrawBack(w, h, panel, colors.accent, ColorAlpha(colors.accentText, 70), 0)
	end

	if panel.Depressed or panel:IsSelected() then
		return DrawBack(w, h, panel, colors.accentActive, ColorAlpha(colors.accentText, 200), 1)
	end

	if panel.Hovered then
		return DrawBack(w, h, panel, colors.accentHover, colors.accentText, 0)
	end

	return DrawBack(w, h, panel, colors.accent, ColorAlpha(colors.accentText, 150), 0)
end

--[[---------------------------------------------------------
	ScrollBar
-----------------------------------------------------------]]
function SKIN:PaintScrollBarGrip(panel, w, h)
	if not panel:IsEnabled() then
		return self.tex.Scroller.ButtonV_Disabled( 0, 0, w, h )
	end

	if panel.Depressed then
		return drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colors.scrollBarActive)
	end

	if panel.Hovered then
		return drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colors.scrollBar)
	end

	return drawRoundedBox(sizes.cornerRadius, 4, 0, w - 8, h, colors.scrollBar)
end

function SKIN:PaintButtonDown(panel, w, h)
	if not panel.m_bBackground then return end

	if not panel:IsEnabled() then
		return self.tex.Scroller.DownButton_Dead( 0, 0, w, h )
	end

	if panel.Depressed or panel:IsSelected() then
		return drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colors.accentActive)
	end

	if panel.Hovered then
		return drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colors.accentHover)
	end

	return drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colors.accent)
end

function SKIN:PaintButtonUp(panel, w, h)
	if not panel.m_bBackground then return end

	if not panel:IsEnabled() then
		return self.tex.Scroller.DownButton_Dead( 0, 0, w, h )
	end

	if panel.Depressed or panel:IsSelected() then
		return drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colors.accentActive)
	end

	if panel.Hovered then
		return drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colors.accentHover)
	end

	return drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colors.accent)
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

	if not panel:IsEnabled() then
		return self.tex.Button_Dead(0, 0, w, h)
	end

	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		local colorDescription = utilGetChangedColor(colors.default, 135)
		local colorIcon = utilGetChangedColor(colors.default, 160)
		local colorText = utilGetChangedColor(colors.default, 50)

		return DrawMenuButton(w, h, panel, colorDescription, colorIcon, colorText, colorDescription, 1)
	end

	if panel.Hovered then
		local colorDescription = utilGetChangedColor(colors.default, 135)
		local colorIcon = utilGetChangedColor(colors.default, 160)
		local colorText = utilGetChangedColor(colors.default, 50)

		return DrawMenuButton(w, h, panel, colorDescription, colorIcon, colorText, colorDescription, 0)
	end

	local colorDescription = utilGetChangedColor(colors.default, 145)
	local colorText = utilGetChangedColor(colors.default, 65)
	local colorIcon = utilGetChangedColor(colors.default, 170)

	return DrawMenuButton(w, h, panel, colorIcon, colorIcon, colorText, colorDescription, 0)
end

local function DrawSubMenuButton(w, h, panel, sizeBorder, colorBackground, colorBar, colorText, shift)
	drawBox(0, 0, sizeBorder, h, colorBar)
	drawBox(sizeBorder, 0, w - sizeBorder, h, colorBackground)

	local pad = mathRound(0.3 * h)

	local hasIcon = panel:HasIcon()
	local sizeIcon = h - 2 * pad

	if hasIcon then
		drawFilteredShadowedTexture(pad + sizeBorder, pad + shift, sizeIcon, sizeIcon, panel:GetIcon(), colorText.a, colorText)
	end

	drawSimpleText(
		TryT(panel:GetTitle()),
		panel:GetTitleFont(),
		sizeBorder + pad + (hasIcon and (sizeIcon + pad) or pad),
		0.5 * h + shift,
		colorText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintSubMenuButtonTTT2(panel, w, h)
	if not panel.m_bBackground then return end

	if not panel:IsEnabled() then
		return self.tex.Button_Dead( 0, 0, w, h)
	end

	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		local colorBackground = utilGetActiveColor(ColorAlpha(colors.accent, 50))
		local colorText = utilGetActiveColor(utilGetChangedColor(colors.default, 25))

		return DrawSubMenuButton(w, h, panel, sizes.border, colorBackground, colors.accentActive, colorText, 1)
	end

	if panel.Hovered then
		local colorBackground = utilGetHoverColor(ColorAlpha(colors.accent, 50))
		local colorText = utilGetHoverColor(utilGetChangedColor(colors.default, 75))

		return DrawSubMenuButton(w, h, panel, sizes.border, colorBackground, colors.accentHover, colorText, 0)
	end

	if panel:IsActive() then
		local colorBackground = utilGetHoverColor(ColorAlpha(colors.accent, 50))
		local colorText = utilGetHoverColor(utilGetChangedColor(colors.default, 75))

		return DrawSubMenuButton(w, h, panel, sizes.border, colorBackground, colors.accentHover, colorText, 0)
	end

	local colorText = utilGetChangedColor(colors.default, 75)

	return DrawSubMenuButton(w, h, panel, sizes.border, colors.background, colors.background, colorText, 0)
end

--[[---------------------------------------------------------
	CheckBox
-----------------------------------------------------------]]
local function DrawCheckBox(w, h, offset, panel, colorBox, colorCenter)
	drawRoundedBox(4, 0, 0, w, h, colorBox)
	drawRoundedBox(4, offset + 3, 3, h - 6, h - 6, colorCenter)
end

function SKIN:PaintCheckBox(panel, w, h)
	if panel:GetChecked() then
		if not panel:IsEnabled() then
			DrawCheckBox(w, h, w - h, panel, ColorAlpha(colors.handle, alphaDisabled), ColorAlpha(colors.handle, alphaDisabled))
		elseif panel.Hovered then
			DrawCheckBox(w, h, w - h, panel, colors.handle, colors.accentHover)
		else
			DrawCheckBox(w, h, w - h, panel, colors.handle, colors.accent)
		end
	else
		if not panel:IsEnabled() then
			DrawCheckBox(w, h, 0, panel, ColorAlpha(colors.handle, alphaDisabled), ColorAlpha(colors.settingsBox, alphaDisabled))
		elseif panel.Hovered then
			DrawCheckBox(w, h, 0, panel, colors.handle, colors.accentHover)
		else
			DrawCheckBox(w, h, 0, panel, colors.handle, colors.settingsBox)
		end
	end
end

function SKIN:PaintCheckBoxLabel(panel, w, h)
	if panel:IsEnabled() then
		drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colors.settingsBox, true, false, true, false)

		drawSimpleText(
			TryT(panel:GetText()),
			panel:GetFont(),
			panel:GetTextPosition(),
			0.5 * h,
			colors.settingsText,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_CENTER
		)
	else
		drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, ColorAlpha(colors.settingsBox, alphaDisabled), true, false, true, false)

		drawSimpleText(
			TryT(panel:GetText()),
			panel:GetFont(),
			panel:GetTextPosition(),
			0.5 * h,
			ColorAlpha(colors.settingsText, alphaDisabled),
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_CENTER
		)
	end
end

--[[---------------------------------------------------------
	CollapsibleCategory
-----------------------------------------------------------]]
function SKIN:PaintCollapsibleCategoryTTT2(panel, w, h)
	drawBox(0, 0, w, h, colors.background)
	drawBox(0, h - sizes.border, w, sizes.border, colors.accent)
end

function SKIN:PaintCategoryHeaderTTT2(panel, w, h)
	local paddingX = 10
	local paddingY = 10

	local colorLine = utilGetChangedColor(colors.background, 50)
	local colorText = utilGetChangedColor(colors.default, 50)

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
	if not panel:IsEnabled() then
		local colorAccentDisabled = utilGetChangedColor(colors.default, 150)
		local colorAccentDarkDisabled = utilColorDarken(colorAccentDisabled, 50)

		local colorText = ColorAlpha(utilGetDefaultColor(colorAccentDisabled), 220)

		return DrawButton(w, h, panel, sizes.border, colorAccentDarkDisabled, colorAccentDisabled, colorText, 0)
	end

	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)

		return DrawButton(w, h, panel, sizes.border, colors.accentDarkactive, colors.accentActive, colorText, 1)
	end

	if panel.Hovered then
		local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)

		return DrawButton(w, h, panel, sizes.border, colors.accentDarkHover, colors.accentHover, colorText, 0)
	end

	local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)

	return DrawButton(w, h, panel, sizes.border, colors.accentDark, colors.accent, colorText, 0)
end

local function DrawFormButton(w, h, panel, sizeCornerRadius, colorBoxBack, colorBox, colorText, shift)
	local pad = 6

	drawRoundedBoxEx(sizeCornerRadius, 0, 0, w, h, colorBoxBack, false, true, false, true)
	drawRoundedBox(sizeCornerRadius, 1, 1, w - 2, h - 2, colorBox)

	drawFilteredShadowedTexture(pad, pad + shift, w - 2 * pad, h - 2 * pad, panel.material, colorText.a, colorText)
end

function SKIN:PaintFormButtonIconTTT2(panel, w, h)
	if not panel:IsEnabled() then
		local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), alphaDisabled)

		return DrawFormButton(w, h, panel, sizes.cornerRadius, ColorAlpha(colors.settingsBox, alphaDisabled), ColorAlpha(colors.accent, alphaDisabled), colorText, 0)
	end

	if panel.noDefault then
		local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), alphaDisabled)

		return DrawFormButton(w, h, panel, sizes.cornerRadius, colors.settingsBox, ColorAlpha(colors.accent, alphaDisabled), colorText, 0)
	end

	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)

		return DrawFormButton(w, h, panel, sizes.cornerRadius, colors.settingsBox, colors.accentActive, colorText, 1)
	end

	if panel.Hovered then
		local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)

		return DrawFormButton(w, h, panel, sizes.cornerRadius, colors.settingsBox, colors.accentHover, colorText, 0)
	end

	local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)

	return DrawFormButton(w, h, panel, sizes.cornerRadius, colors.settingsBox, colors.accent, colorText, 0)
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
	if not panel:IsEnabled() then
		return DrawFormButtonText(w, h, panel, sizes.cornerRadius, ColorAlpha(colors.settingsBox, alphaDisabled), ColorAlpha(colors.accent, alphaDisabled), ColorAlpha(colors.settingsText, alphaDisabled), 0)
	end

	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)

		return DrawFormButtonText(w, h, panel, sizes.cornerRadius, colors.settingsBox, colors.accentActive, colorText, 1)
	end

	if panel.Hovered then
		local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)

		return DrawFormButtonText(w, h, panel, sizes.cornerRadius, colors.settingsBox, colors.accentActive, colorText, 0)
	end

	local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 150)

	return DrawFormButtonText(w, h, panel, sizes.cornerRadius, colors.settingsBox, colors.accent, colorText, 0)
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

function SKIN:PaintLabelRighTTT2(panel, w, h)
	drawSimpleText(
		TryT(panel:GetText()),
		panel:GetFont(),
		w,
		0.5 * h,
		utilGetChangedColor(colors.default, 40),
		TEXT_ALIGN_RIGHT,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintFormLabelTTT2(panel, w, h)
	if not panel:IsEnabled() then
		drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, ColorAlpha(colors.settingsBox, alphaDisabled), true, false, true, false)
		drawSimpleText(
			TryT(panel:GetText()),
			panel:GetFont(),
			10,
			0.5 * h,
			ColorAlpha(colors.settingsText, alphaDisabled),
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_CENTER
		)
	else
		drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colors.settingsBox, true, false, true, false)
		drawSimpleText(
			TryT(panel:GetText()),
			panel:GetFont(),
			10,
			0.5 * h,
			colors.settingsText,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_CENTER
		)
	end
end

function SKIN:PaintFormBoxTTT2(panel, w, h)
	if not panel:IsEnabled() then
		drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, ColorAlpha(colors.settingsBox, alphaDisabled), false, true, false, true)
		drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, ColorAlpha(colors.handle, alphaDisabled))
	else
		drawRoundedBoxEx(sizes.cornerRadius, 0, 0, w, h, colors.settingsBox, false, true, false, true)
		drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, colors.handle)
	end
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
	if not panel:IsEnabled() then
		return drawRoundedBox(math.floor(w * 0.5), 0, 0, w, h, ColorAlpha(colors.accent, alphaDisabled))
	end

	if panel.Depressed then
		return drawRoundedBox(math.floor(w * 0.5), 0, 0, w, h, colors.accentActive)
	end

	if panel.Hovered then
		return drawRoundedBox(math.floor(w * 0.5), 0, 0, w, h, colors.accentHover)
	end

	return drawRoundedBox(math.floor(w * 0.5), 0, 0, w, h, colors.accent)
end

function SKIN:PaintNumSliderTTT2(panel, w, h)
	local pad = 5

	if not panel:IsEnabled() then
		drawBox(0, 0, w, h, ColorAlpha(colors.settingsBox, alphaDisabled))
		drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, ColorAlpha(colors.handle, alphaDisabled))

		-- draw selection line
		drawBox(5, 0.5 * h - 1, w - 2 * pad, 2, ColorAlpha(colors.sliderInactive, alphaDisabled))
		drawBox(5, 0.5 * h - 1, (w - pad) * panel:GetFraction() - pad, 2, ColorAlpha(colors.accent, alphaDisabled))
	else
		drawBox(0, 0, w, h, colors.settingsBox)
		drawRoundedBox(sizes.cornerRadius, 1, 1, w - 2, h - 2, colors.handle)

		-- draw selection line
		drawBox(5, 0.5 * h - 1, w - 2 * pad, 2, colors.sliderInactive)
		drawBox(5, 0.5 * h - 1, (w - pad) * panel:GetFraction() - pad, 2, colors.accent)
	end
end

function SKIN:PaintSliderTextAreaTTT2(panel, w, h)
	if not panel:IsEnabled() then
		drawBox(0, 0, w, h, ColorAlpha(colors.settingsBox, alphaDisabled))
		drawSimpleText(
			panel:GetText(),
			panel:GetFont(),
			0.5 * w,
			0.5 * h,
			ColorAlpha(colors.settingsText, alphaDisabled),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	else
		drawBox(0, 0, w, h, colors.settingsBox)
		drawSimpleText(
			panel:GetText(),
			panel:GetFont(),
			0.5 * w,
			0.5 * h,
			colors.settingsText,
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end
end

function SKIN:PaintBinderPanelTTT2(panel, w, h)
	if not panel:IsEnabled() then
		drawBox(0, 0, w, h, ColorAlpha(colors.settingsBox, alphaDisabled))
	else
		drawBox(0, 0, w, h, colors.settingsBox)
	end
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
	local colorText = utilGetChangedColor(utilGetDefaultColor(colors.handle), 50)

	if not panel:IsEnabled() then
		drawBox(0, 0, w, h, ColorAlpha(colors.settingsBox, alphaDisabled))
		DrawComboBox(w, h, panel, sizes.cornerRadius, ColorAlpha(utilGetActiveColor(colors.handle), alphaDisabled), ColorAlpha(colorText, alphaDisabled))

		return
	end

	if panel.Depressed or panel:IsMenuOpen() then
		drawBox(0, 0, w, h, colors.settingsBox)
		DrawComboBox(w, h, panel, sizes.cornerRadius, utilGetHoverColor(colors.handle), colorText)

		return
	end

	if panel.Hovered then
		drawBox(0, 0, w, h, colors.settingsBox)
		DrawComboBox(w, h, panel, sizes.cornerRadius, utilGetHoverColor(colors.handle), colorText)

		return
	end

	drawBox(0, 0, w, h, colors.settingsBox)
	DrawComboBox(w, h, panel, sizes.cornerRadius, colors.handle, colorText)
end

function SKIN:PaintColoredTextBoxTTT2(panel, w, h)
	local colorBackground = panel:GetColor()
	local colorText = utilGetDefaultColor(colorBackground)
	local align = panel:GetTitleAlign()
	local alpha = mathRound(colorText.a * panel:GetTitleOpacity())
	local hasIcon = panel:HasIcon()
	local pad = mathRound(0.1 * h)
	local sizeIcon = h - 2 * pad

	drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, colorBackground)
	drawShadowedText(
		TryT(panel:GetTitle()),
		panel:GetTitleFont(),
		(align == TEXT_ALIGN_CENTER) and (0.5 * w) or (hasIcon and (sizeIcon + 4 * pad) or (2 * pad)),
		0.5 * h,
		ColorAlpha(colorText, alpha),
		align,
		TEXT_ALIGN_CENTER,
		1
	)

	if hasIcon then
		drawFilteredShadowedTexture(pad, pad, sizeIcon, sizeIcon, panel:GetIcon(), alpha, colorText)
	end
end

function SKIN:PaintColoredBoxTTT2(panel, w, h)
	drawRoundedBox(sizes.cornerRadius, 0, 0, w, h, panel:GetColor())
end

function SKIN:PaintVerticalBorderedBoxTTT2(panel, w, h)
	drawBox(w - 1, 0, 1, h, ColorAlpha(colors.default, 200))
end

local function DrawButtonRoundEnd(w, h, panel, radius, leftSide, colorBackground, colorForeground, colorText, shift)
	if leftSide then
		drawRoundedBoxEx(radius, 0, 0, w, h, colorBackground, true, false, true, false)
		drawRoundedBox(radius, 2, 2, w - 3, h - 4, colorForeground)
	else
		drawRoundedBoxEx(radius, 0, 0, w, h, colorBackground, false, true, false, true)
		drawRoundedBox(radius, 1, 2, w - 3, h - 4, colorForeground)
	end

	drawSimpleText(
		TryT(panel:GetText()),
		panel:GetFont(),
		0.5 * w,
		0.5 * h + shift,
		colorText,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_CENTER
	)
end

function SKIN:PaintButtonRoundEndLeftTTT2(panel, w, h)
	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)

		return DrawButtonRoundEnd(w, h, panel, sizes.cornerRadius, true, colors.content, colors.accent, colorText, 1)
	end

	if panel.Hovered then
		local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)

		return DrawButtonRoundEnd(w, h, panel, sizes.cornerRadius, true, colors.content, colors.accentHover, colorText, 0)
	end

	if not panel.isActive then
		local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)

		return DrawButtonRoundEnd(w, h, panel, sizes.cornerRadius, true, colors.content, colors.handle, colorText, 0)
	end

	local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)

	return DrawButtonRoundEnd(w, h, panel, sizes.cornerRadius, true, colors.content, colors.accent, colorText, 0)
end

function SKIN:PaintButtonRoundEndRightTTT2(panel, w, h)
	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)

		return DrawButtonRoundEnd(w, h, panel, sizes.cornerRadius, false, colors.content, colors.accent, colorText, 1)
	end

	if panel.Hovered then
		local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)

		return DrawButtonRoundEnd(w, h, panel, sizes.cornerRadius, false, colors.content, colors.accentHover, colorText, 0)
	end

	if not panel.isActive then
		local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)

		return DrawButtonRoundEnd(w, h, panel, sizes.cornerRadius, false, colors.content, colors.handle, colorText, 0)
	end

	local colorText = ColorAlpha(utilGetDefaultColor(colors.accent), 220)

	return DrawButtonRoundEnd(w, h, panel, sizes.cornerRadius, false, colors.content, colors.accent, colorText, 0)
end

function SKIN:PaintTooltipTTT2(panel, w, h)
	local sizeArrow = panel.sizeArrow
	local sizeRhombus = 2 * sizeArrow

	local colorLine = ColorAlpha(colors.default, 100)

	drawBox(0, sizeArrow, w, h - sizeArrow, colorLine)
	drawFilteredTexture(sizeArrow, 0, sizeRhombus, sizeRhombus, materialRhombus, colorLine.a, colorLine)

	drawBox(1, sizeArrow + 1, w - 2, h - sizeArrow - 2, colors.background)
	drawFilteredTexture(sizeArrow, 1, sizeRhombus, sizeRhombus, materialRhombus, colors.background.a, colors.background)

	if panel:HasText() then
		drawSimpleText(
			panel:GetText(),
			panel:GetFont(),
			0.5 * w,
			0.5 * (h + sizeArrow),
			utilGetDefaultColor(colors.background),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end
end

-- REGISTER DERMA SKIN
derma.DefineSkin(SKIN.Name, "TTT2 default skin for all vgui elements", SKIN)
