local materialClose = Material("vgui/ttt/derma/icon_close")
local materialBack = Material("vgui/ttt/derma/icon_back")

local SKIN = {}
SKIN.Name = "ttt2_default"

-- register fonts
surface.CreateAdvancedFont("DermaTTT2Title", {font = "Trebuchet24", size = 26, weight = 300})
surface.CreateAdvancedFont("DermaTTT2TitleSmall", {font = "Trebuchet24", size = 18, weight = 600})

function SKIN:PaintFrame(panel, w, h)
	local bgcolor = VSKIN.GetBackgroundColor()
	local accentColor = VSKIN.GetAccentColor()
	local adcolor = VSKIN.GetDarkAccentColor()
	local sdcolor = VSKIN.GetShadowColor()
	local titleTextColor = VSKIN.GetTitleTextColor()

	local sdsize = VSKIN.GetShadowSize()
	local hdsize = VSKIN.GetHeaderHeight()

	if not panel:HasHierarchicalFocus() then
		bgcolor = util.ColorLighten(bgcolor, 25)
	end

	-- DRAW SHADOW (disable clipping)
	if panel.m_bPaintShadow then
		DisableClipping(true)
		draw.RoundedBox(sdsize, -sdsize, -sdsize, w + 2 * sdsize, h + 2 * sdsize, sdcolor)
		DisableClipping(false)
	end

	-- draw main panel box
	draw.Box(0, 0, w, h, bgcolor)

	-- draw panel header area
	draw.Box(0, 0, w, hdsize, accentColor)
	draw.Box(0, hdsize, w, 3, adcolor)

	draw.ShadowedText(panel:GetTitle(), panel:GetTitleFont(), 0.5 * w, 0.5 * hdsize, titleTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1)
end

local function DrawClose(w, h, backgroundColor, textColor, shift)
	local padding = 15

	draw.Box(0, 0, w, h, backgroundColor)
	draw.FilteredShadowedTexture(padding, padding + shift, w - 2 * padding, h - 2 * padding, materialClose, textColor.a, textColor)
end

function SKIN:PaintWindowCloseButton(panel, w, h)
	if not panel.m_bBackground then return end

	local accentColor = VSKIN.GetAccentColor()
	local titleTextColor = VSKIN.GetTitleTextColor()

	if panel:GetDisabled() then
		return DrawClose(w, h, accentColor, util.ColorAlpha(titleTextColor, 70), 0)
	end

	if panel.Depressed or panel:IsSelected() then
		return DrawClose(w, h, util.ColorLighten(accentColor, 40), util.ColorAlpha(titleTextColor, 200), 1)
	end

	if panel.Hovered then
		return DrawClose(w, h, util.ColorLighten(accentColor, 20), titleTextColor, 0)
	end

	return DrawClose(w, h, accentColor, util.ColorAlpha(titleTextColor, 150), 0)
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

	local accentColor = VSKIN.GetAccentColor()
	local titleTextColor = VSKIN.GetTitleTextColor()

	if panel:GetDisabled() then
		return DrawBack(w, h, panel, accentColor, util.ColorAlpha(titleTextColor, 70), 0)
	end

	if panel.Depressed or panel:IsSelected() then
		return DrawBack(w, h, panel, util.ColorLighten(accentColor, 40), util.ColorAlpha(titleTextColor, 200), 1)
	end

	if panel.Hovered then
		return DrawBack(w, h, panel, util.ColorLighten(accentColor, 20), titleTextColor, 0)
	end

	return DrawBack(w, h, panel, accentColor, util.ColorAlpha(titleTextColor, 150), 0)
end

-- REGISTER DERMA SKIN
derma.DefineSkin(SKIN.Name, "TTT2 default skin for all vgui elements", SKIN)
