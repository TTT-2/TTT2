local materialClose = Material("vgui/ttt/derma/icon_close")
local materialBack = Material("vgui/ttt/derma/icon_back")

local SKIN = {}
SKIN.Name = "ttt2_default"

local TryT = LANG.TryTranslation

-- register fonts
surface.CreateAdvancedFont("DermaTTT2Title", {font = "Trebuchet24", size = 26, weight = 300})
surface.CreateAdvancedFont("DermaTTT2TitleSmall", {font = "Trebuchet24", size = 18, weight = 600})
surface.CreateAdvancedFont("DermaTTT2MenuButtonTitle", {font = "Trebuchet24", size = 18, weight = 600})
surface.CreateAdvancedFont("DermaTTT2MenuButtonDescription", {font = "Trebuchet24", size = 13, weight = 300})

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

	if not panel:HasHierarchicalFocus() then
		colorBackground = util.ColorLighten(colorBackground, 25)
	end

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
	local colorAccentHover = VSKIN.GetHoverAccentColor()
	local colorAccentActive = VSKIN.GetActiveAccentColor()
	local colorTitleText = VSKIN.GetTitleTextColor()

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
	draw.ShadowedText("back", "DermaTTT2TitleSmall", h - padding_w, 0.5 * h + shift, colorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1)
end

function SKIN:PaintWindowBackButton(panel, w, h)
	if not panel.m_bBackground then return end

	local colorAccent = VSKIN.GetAccentColor()
	local colorAccentHover = VSKIN.GetHoverAccentColor()
	local colorAccentActive = VSKIN.GetActiveAccentColor()
	local colorTitleText = VSKIN.GetTitleTextColor()

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
	local colorScrollbarHover = VSKIN.GetHoverScrollbarColor()
	local colorScrollbarActive = VSKIN.GetActiveScrollbarColor()

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
	local colorAccentHover = VSKIN.GetHoverAccentColor()
	local colorAccentActive = VSKIN.GetActiveAccentColor()

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
	local colorAccentHover = VSKIN.GetHoverAccentColor()
	local colorAccentActive = VSKIN.GetActiveAccentColor()

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

local function DrawMenuButton(w, h, panel, colorOutline, colorIcon, colorText, shift)
	local padding = 10

	draw.OutlinedBox(0, 0, w, h, 1, colorOutline)
	draw.FilteredTexture(padding, padding + shift, h - 2 * padding, h - 2 * padding, panel:GetImage(), colorIcon.a, colorIcon)
	draw.ShadowedText(TryT(panel:GetTitle()), panel:GetTitleFont(), h, padding + shift, colorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1)

	local colorDescription = Color(colorText.r, colorText.g, colorText.b, colorText.a * 0.75)
	local desc_wrapped = draw.GetWrappedText(TryT(panel:GetDescription()), w - h - 2 * padding, panel:GetDescriptionFont())

	local line_pos = 35
	for i = 1, #desc_wrapped do
		draw.ShadowedText(
			desc_wrapped[i],
			panel:GetDescriptionFont(),
			h,
			line_pos + padding + shift,
			colorDescription,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP,
			1
		)

		line_pos = line_pos + 20
	end
end

function SKIN:PaintMenuButtonTTT2(panel, w, h)
	if not panel.m_bBackground then return end

	local colorBackground = VSKIN.GetBackgroundColor()

	local colorText = ColorAlpha(util.GetDefaultColor(colorBackground), 200)
	local colorTextHover = Color(colorText.r, colorText.g, colorText.b, colorText.a * 1.2)
	local colorIcon = Color(colorText.r, colorText.g, colorText.b, colorText.a * 0.2)
	local colorHover = Color(colorText.r, colorText.g, colorText.b, colorText.a * 0.3)

	if panel:GetDisabled() then
		return self.tex.Button_Dead( 0, 0, w, h)
	end

	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		return DrawMenuButton(w, h, panel, colorTextHover, colorHover, colorTextHover, 1)
	end

	if panel.Hovered then
		return DrawMenuButton(w, h, panel, colorTextHover, colorHover, colorTextHover, 0)
	end

	return DrawMenuButton(w, h, panel, colorIcon, colorIcon, colorText, 0)
end

local function DrawSubMenuButton(w, h, panel, sizeBorder, colorBackground, colorBar, colorText)
	draw.Box(0, 0, sizeBorder, h, colorBar)
	draw.Box(sizeBorder, 0, w - sizeBorder, h, colorBackground)

	draw.SimpleText(
		panel:GetTitle(),
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

	local colorText = util.ColorLighten(util.GetDefaultColor(colorElemBackground), 75)
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

-- REGISTER DERMA SKIN
derma.DefineSkin(SKIN.Name, "TTT2 default skin for all vgui elements", SKIN)
