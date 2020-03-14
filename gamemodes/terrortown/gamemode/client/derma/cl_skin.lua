local materialClose = Material("vgui/ttt/derma/icon_close")
local materialBack = Material("vgui/ttt/derma/icon_back")

local SKIN = {}
SKIN.Name = "ttt2_default"

local TryT = LANG.TryTranslation

-- register fonts
surface.CreateAdvancedFont("DermaTTT2Title", {font = "Trebuchet24", size = 26, weight = 300})
surface.CreateAdvancedFont("DermaTTT2TitleSmall", {font = "Trebuchet24", size = 18, weight = 600})
surface.CreateAdvancedFont("DermaTTT2MenuButtonTitle", {font = "Trebuchet24", size = 22, weight = 300})
surface.CreateAdvancedFont("DermaTTT2MenuButtonDescription", {font = "Trebuchet24", size = 14, weight = 300})
surface.CreateAdvancedFont("DermaTTT2SubMenuButtonTitle", {font = "Trebuchet24", size = 18, weight = 600})
surface.CreateAdvancedFont("DermaTTT2Button", {font = "Trebuchet24", size = 14, weight = 600})

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

	--if not panel:HasHierarchicalFocus() then
	--	colorBackground = util.ColorLighten(colorBackground, 25)
	--end

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

	if panel:GetDisabled() then
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

	if panel:GetDisabled() then
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

	if panel:GetDisabled() then
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

	if panel:GetDisabled() then
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

	if panel:GetDisabled() then
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
	local padding_text = 10
	local padding_icon = 25

	draw.OutlinedBox(0, 0, w, h, 1, colorOutline)
	draw.FilteredTexture(padding_icon, padding_icon + shift, h - 2 * padding_icon, h - 2 * padding_icon, panel:GetImage(), colorIcon.a, colorIcon)
	draw.SimpleText(
		TryT(panel:GetTitle()),
		panel:GetTitleFont(),
		h,
		padding_text + shift,
		colorText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_TOP
	)

	local desc_wrapped = draw.GetWrappedText(TryT(panel:GetDescription()), w - h - 2 * padding_text, panel:GetDescriptionFont())

	local line_pos = 35
	for i = 1, #desc_wrapped do
		draw.SimpleText(
			desc_wrapped[i],
			panel:GetDescriptionFont(),
			h,
			line_pos + padding_text + shift,
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

	if panel:GetDisabled() then
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


	if panel:GetDisabled() then
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
local function DrawCheckBox(w, h, panel, colorOutline, colorBox, colorCenter)
	draw.RoundedBox(4, 0, 0, w, h, colorOutline)
	draw.RoundedBox(4, 1, 1, w - 2, h - 2, colorBox)
	draw.RoundedBox(2, 4, 4, w - 8, h - 8, colorCenter)
end

function SKIN:PaintCheckBox(panel, w, h)
	local colorBackground = VSKIN.GetBackgroundColor()
	local colorDefault = util.GetDefaultColor(colorBackground)
	local colorAccent = VSKIN.GetAccentColor()

	if panel:GetChecked() then
		local colorOutline = util.GetChangedColor(colorDefault, 50)
		local colorBox = colorBackground
		local colorCenter = colorAccent
		local colorCenterHover = ColorAlpha(util.GetHoverColor(colorCenter), 200)

		if panel:GetDisabled() then
			self.tex.CheckboxD_Checked( 0, 0, w, h )
		elseif panel.Hovered then
			DrawCheckBox(w, h, panel, colorOutline, colorBox, colorCenterHover)
		else
			DrawCheckBox(w, h, panel, colorOutline, colorBox, colorCenter)
		end
	else
		local colorOutline = util.GetChangedColor(colorDefault, 50)
		local colorBox = colorBackground
		local colorCenter = Color(0, 0, 0, 0)
		local colorCenterHover = ColorAlpha(util.GetHoverColor(colorAccent), 100)

		if panel:GetDisabled() then
			self.tex.CheckboxD( 0, 0, w, h )
		elseif panel.Hovered then
			DrawCheckBox(w, h, panel, colorOutline, colorBox, colorCenterHover)
		else
			DrawCheckBox(w, h, panel, colorOutline, colorBox, colorCenter)
		end
	end
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
	local colorBackground = VSKIN.GetBackgroundColor()

	local colorText = util.GetDefaultColor(colorBackground)

	draw.Box(0, 0, w, h, colorBackground)

	draw.SimpleText(
		string.upper(panel.text),
		panel:GetFont(),
		0.5 * h,
		0.5 * h,
		colorText,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
end

local function DrawButton(w, h, panel, sizeBorder, colorLine, colorBox, colorText)
	draw.RoundedBox(5, 0, 0, w, h, colorBox)
	draw.Box(0, h - 2 * sizeBorder, w, sizeBorder, colorLine)

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

	if panel:GetDisabled() then
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

-- REGISTER DERMA SKIN
derma.DefineSkin(SKIN.Name, "TTT2 default skin for all vgui elements", SKIN)
