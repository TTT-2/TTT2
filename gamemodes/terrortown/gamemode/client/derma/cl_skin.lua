local materialClose = Material("vgui/ttt/derma/icon_close")
local materialBack = Material("vgui/ttt/derma/icon_back")

local SKIN = {}
SKIN.Name = "ttt2_default"

local TryT = LANG.TryTranslation

-- register fonts
surface.CreateAdvancedFont("DermaTTT2Title", {font = "Trebuchet24", size = 26, weight = 300})
surface.CreateAdvancedFont("DermaTTT2TitleSmall", {font = "Trebuchet24", size = 18, weight = 600})

--[[---------------------------------------------------------
	Frame
-----------------------------------------------------------]]
function SKIN:PaintFrame(panel, w, h)
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
	Button
-----------------------------------------------------------]]
local function DrawClose(w, h, backgroundColor, textColor, shift)
	local padding = 15

	draw.Box(0, 0, w, h, backgroundColor)
	draw.FilteredShadowedTexture(padding, padding + shift, w - 2 * padding, h - 2 * padding, materialClose, textColor.a, textColor)
end

function SKIN:PaintWindowCloseButton(panel, w, h)
	if not panel.m_bBackground then return end

	local colorAccent = VSKIN.GetAccentColor()
	local colorAccentHover = VSKIN.GetHoverAccentColor()
	local colorAccentActive = VSKIN.GetActiveAccentColor()
	local colorTitleText = VSKIN.GetTitleTextColor()

	if panel:GetDisabled() then
		return DrawClose(w, h, colorAccent, util.ColorAlpha(colorTitleText, 70), 0)
	end

	if panel.Depressed or panel:IsSelected() then
		return DrawClose(w, h, colorAccentActive, util.ColorAlpha(colorTitleText, 200), 1)
	end

	if panel.Hovered then
		return DrawClose(w, h, colorAccentHover, colorTitleText, 0)
	end

	return DrawClose(w, h, colorAccent, util.ColorAlpha(colorTitleText, 150), 0)
end

local function DrawBack(w, h, panel, backgroundColor, textColor, shift)
	local padding_w = 10
	local padding_h = 15

	draw.Box(0, 0, w, h, backgroundColor)
	draw.FilteredShadowedTexture(padding_w, padding_h + shift, h - 2 * padding_h, h - 2 * padding_h, materialBack, textColor.a, textColor)
	draw.ShadowedText("back", "DermaTTT2TitleSmall", h - padding_w, 0.5 * h + shift, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1)
end

function SKIN:PaintWindowBackButton(panel, w, h)
	if not panel.m_bBackground then return end

	local colorAccent = VSKIN.GetAccentColor()
	local colorAccentHover = VSKIN.GetHoverAccentColor()
	local colorAccentActive = VSKIN.GetActiveAccentColor()
	local colorTitleText = VSKIN.GetTitleTextColor()

	if panel:GetDisabled() then
		return DrawBack(w, h, panel, colorAccent, util.ColorAlpha(colorTitleText, 70), 0)
	end

	if panel.Depressed or panel:IsSelected() then
		return DrawBack(w, h, panel, colorAccentActive, util.ColorAlpha(colorTitleText, 200), 1)
	end

	if panel.Hovered then
		return DrawBack(w, h, panel, colorAccentHover, colorTitleText, 0)
	end

	return DrawBack(w, h, panel, colorAccent, util.ColorAlpha(colorTitleText, 150), 0)
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

	if panel:GetDisabled() then
		return self.tex.Scroller.ButtonV_Disabled( 0, 0, w, h )
	end

	if panel.Depressed then
		return draw.RoundedBox(6, 0, 0, w, h, colorScrollbarActive)
	end

	if panel.Hovered then
		return draw.RoundedBox(6, 0, 0, w, h, colorScrollbarHover)
	end

	return draw.RoundedBox(6, 0, 0, w, h, colorScrollbar)
end

function SKIN:PaintButtonDown(panel, w, h)
	if not panel.m_bBackground then return end

	local colorAccent = VSKIN.GetAccentColor()
	local colorAccentHover = VSKIN.GetHoverAccentColor()
	local colorAccentActive = VSKIN.GetActiveAccentColor()

	if panel:GetDisabled() then
		return self.tex.Scroller.DownButton_Dead( 0, 0, w, h )
	end

	if panel.Depressed or panel:IsSelected() then
		return draw.RoundedBox(6, 0, 0, w, h, colorAccentActive)
	end

	if panel.Hovered then
		return draw.RoundedBox(6, 0, 0, w, h, colorAccentHover)
	end

	return draw.RoundedBox(6, 0, 0, w, h, colorAccent)
end

function SKIN:PaintButtonUp(panel, w, h)
	if not panel.m_bBackground then return end

	local colorAccent = VSKIN.GetAccentColor()
	local colorAccentHover = VSKIN.GetHoverAccentColor()
	local colorAccentActive = VSKIN.GetActiveAccentColor()

	if panel:GetDisabled() then
		return self.tex.Scroller.DownButton_Dead( 0, 0, w, h )
	end

	if panel.Depressed or panel:IsSelected() then
		return draw.RoundedBox(6, 0, 0, w, h, colorAccentActive)
	end

	if panel.Hovered then
		return draw.RoundedBox(6, 0, 0, w, h, colorAccentHover)
	end

	return draw.RoundedBox(6, 0, 0, w, h, colorAccent)
end

-- REGISTER DERMA SKIN
derma.DefineSkin(SKIN.Name, "TTT2 default skin for all vgui elements", SKIN)
