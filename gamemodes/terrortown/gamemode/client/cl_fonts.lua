---
-- @author LeBroomer
-- @author Alf21
-- @author saibotk
-- @author Mineotopia

-- Localise some libs
local draw = draw
local surface = surface
local drawSimpleText = draw.SimpleText
local table = table
local cam = cam
local render = render

FONTS = {}
FONTS.fonts = {}
FONTS.Scales = {1, 1.5, 2, 2.5}

local shadowColorDark = Color(0, 0, 0, 220)
local shadowColorWhite = Color(0, 0, 0, 75)

local function getScaleModifier(scale)
	local scaleFactor = isvector(scale) and math.max(scale.x, math.max(scale.y, scale.z)) or scale
	scaleFactor = tonumber(scaleFactor)

	local FONTScales = FONTS.Scales

	for i = 1, #FONTScales do
		if scaleFactor < FONTScales[i] then
			return i - 1 > 0 and FONTScales[i - 1] or FONTScales[i]
		end
	end

	-- fallback (return the last scale)
	return FONTScales[#FONTScales]
end

---
-- Registers an advanced text (scalable)
-- @important The original font should be always created. See @{surface.CreateFont}
-- @param string fontName
-- @param table fontData
-- @module surface
-- @realm client
-- @todo usage of table structure
function surface.CreateAdvancedFont(fontName, fontData)
	local originalSize = fontData.size or 13

	FONTS.fonts[fontName] = {}

	local fontsScTbl = FONTS.Scales

	for i = 1, #fontsScTbl do
		local scale = fontsScTbl[i]
		local scaledFontName = scale == 1 and fontName or fontName .. tostring(scale)

		--create font
		fontData.size = scale * originalSize

		surface.CreateFont(scaledFontName, fontData)

		FONTS.fonts[fontName][scale] = scaledFontName
	end
end

---
-- Draws a shadowed text on the screen.
-- @2D
-- @param string text The text to be drawn
-- @param[default="DermaDefault"] nil|string font The font. See @{surface.CreateFont} to create your own,
-- or see <a href="https://wiki.garrysmod.com/page/Default_Fonts">Default</a>
-- Fonts for a list of default fonts
-- @param number x The X Coordinate
-- @param number y The Y Coordinate
-- @param Color color The color of the text. Uses the Color structure.
-- @param number xalign The alignment of the X coordinate using
-- <a href="https://wiki.garrysmod.com/page/Enums/TEXT_ALIGN">TEXT_ALIGN_Enums</a>.
-- @param number yalign The alignment of the Y coordinate using
-- <a href="https://wiki.garrysmod.com/page/Enums/TEXT_ALIGN">TEXT_ALIGN_Enums</a>.
-- @param number scaleModifier scale (float number)
-- @ref https://wiki.garrysmod.com/page/draw/SimpleText
-- @module draw
-- @realm client
function draw.ShadowedText(text, font, x, y, color, xalign, yalign, scaleModifier)
	scaleModifier = scaleModifier or 1.0

	local tmpCol = color.r + color.g + color.b > 200 and table.Copy(shadowColorDark) or table.Copy(shadowColorWhite)
	tmpCol.a = math.Round(tmpCol.a * (color.a / 255))

	local dScaleModifier = 2 * scaleModifier

	drawSimpleText(text, font, x + dScaleModifier, y + dScaleModifier, tmpCol, xalign, yalign)
	drawSimpleText(text, font, x + scaleModifier, y + scaleModifier, tmpCol, xalign, yalign)
	drawSimpleText(text, font, x + scaleModifier, y + scaleModifier, tmpCol, xalign, yalign)
	drawSimpleText(text, font, x, y, color, xalign, yalign)
end

local drawShadowedText = draw.ShadowedText

---
-- Draws an advanced text (scalable)
-- @note You should use @{surface.CreateAdvancedFont} before trying to access the font
-- @2D
-- @param string text The text to be drawn
-- @param[default="DefaultBold"] string font The font. See @{surface.CreateAdvancedFont} to create your own. The original font should be always created, see @{surface.CreateFont}.
-- @param number x The X Coordinate
-- @param number y The Y Coordinate
-- @param Color color The color of the text. Uses the Color structure.
-- @param number xalign The alignment of the X coordinate using
-- <a href="https://wiki.garrysmod.com/page/Enums/TEXT_ALIGN">TEXT_ALIGN_Enums</a>.
-- @param number yalign The alignment of the Y coordinate using
-- <a href="https://wiki.garrysmod.com/page/Enums/TEXT_ALIGN">TEXT_ALIGN_Enums</a>.
-- @param boolean shadow whether there should be a shadow of the text
-- @param number scale scale (float number)
-- @module draw
-- @realm client
function draw.AdvancedText(text, font, x, y, color, xalign, yalign, shadow, scale)
	local scaleModifier = 1.0
	local t_font = FONTS.fonts[font]

	if t_font then
		scaleModifier = getScaleModifier(scale)
		font = t_font[scaleModifier]
		scale = scale / scaleModifier
	end

	local scaled = isvector(scale) or scale ~= 1.0
	local mat

	if scaled then
		local hw = ScrW() * 0.5
		local hh = ScrH() * 0.5

		mat = Matrix()
		mat:Translate(Vector(x, y))
		mat:Scale(isvector(scale) and scale or Vector(scale, scale, scale))
		mat:Translate(-Vector(hw, hh))

		render.PushFilterMag(TEXFILTER.LINEAR)
		render.PushFilterMin(TEXFILTER.LINEAR)

		cam.PushModelMatrix(mat)

		x = hw
		y = hh
	end

	if shadow then
		drawShadowedText(text, font, x, y, color, xalign, yalign, scaleModifier)
	else
		drawSimpleText(text, font, x, y, color, xalign, yalign)
	end

	if scaled then
		cam.PopModelMatrix(mat)

		render.PopFilterMag()
		render.PopFilterMin()
	end
end

---
-- Returns a list of lines to wrap the text matching the given width
-- @param string text
-- @param number width
-- @param string font
-- @param number scale
-- @return table
-- @realm client
function draw.GetWrappedText(text, width, font, scale)
	-- Oh joy, I get to write my own wrapping function. Thanks Lua!
	-- Splits a string into a table of strings that are under the given width.

	scale = scale or 1.0
	width = width / scale

	if not text then
		return {}, 0, 0
	end

	surface.SetFont(font or "DefaultBold")

	-- Any wrapping required?
	local w, h = surface.GetTextSize(text)

	if w <= width then
		return {text}, w, h -- Nope, but wrap in table for uniformity
	end

	local words = string.Explode(" ", text) -- No spaces means you're screwed
	local lines = {""}

	for i = 1, #words do
		local wrd = words[i]

		if i == 1 then
			-- add the first word whether or not it matches the size to prevent
			-- weird empty first lines and ' ' in front of the first line
			lines[1] = wrd

			continue
		end

		local lns = #lines
		local added = lines[lns] .. " " .. wrd

		w = surface.GetTextSize(added)

		if w > width then
			lines[lns + 1] = wrd -- New line needed
		else
			lines[lns] = added -- Safe to tack it on
		end
	end

	local lns = #lines

	-- get length of longest line
	local length = 0

	for i = 1, lns do
		local line_w = surface.GetTextSize(lines[i])

		if line_w > length then
			length = line_w
		end
	end

	-- get height of lines
	local _, line_h = surface.GetTextSize(text)

	return lines, length * scale, line_h * lns * scale
end

-- Returns the size of a inserted string
-- @param string text The text that the length should be calculated
-- @param[default="DefaultBold"] string font The font ID
-- @warning This function changes the font to the passed font
-- @return number, number w, h The size of the given text
-- @2D
-- @realm client
function draw.GetTextSize(text, font)
	surface.SetFont(font or "DefaultBold")

	return surface.GetTextSize(text)
end
