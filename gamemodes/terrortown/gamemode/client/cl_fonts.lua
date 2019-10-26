---
-- @author LeBroomer
-- @author Alf21
-- @author saibotk

-- micro-optimization stuff
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

	for _, scl in ipairs(FONTS.Scales) do
	  if scaleFactor <= scl then
			return scl
	  end
	end

	--fallback (return the last scale)
	return FONTS.Scales[#FONTS.Scales]
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

	for _, scale in ipairs(FONTS.Scales) do
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
	tmpCol.a = tmpCol.a * (color.a / 255.0)

	local dScaleModifier = 2 * scaleModifier

	drawSimpleText(text, font, x + dScaleModifier, y + dScaleModifier, tmpCol, xalign, yalign)
	drawSimpleText(text, font, x + scaleModifier, y + scaleModifier, tmpCol, xalign, yalign)
	drawSimpleText(text, font, x, y, color, xalign, yalign)
end

---
-- Draws an advanced text (scalable)
-- @note You should use @{surface.CreateAdvancedFont} before trying to access the font
-- @2D
-- @param string text The text to be drawn
-- @param string font The font. See @{surface.CreateAdvancedFont} to create your own. The original font should be always created, see @{surface.CreateFont}.
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

	if FONTS.fonts[font] then
	  scaleModifier = getScaleModifier(scale)
	  font = FONTS.fonts[font][scaleModifier]
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
	  draw.ShadowedText(text, font, x, y, color, xalign, yalign, scaleModifier)
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
-- @return table
-- @realm client
function WrapText(text, width, font)
	-- Oh joy, I get to write my own wrapping function. Thanks Lua!
	-- Splits a string into a table of strings that are under the given width.

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

	for i, wrd in ipairs(words) do
		if i == 1 then
			-- add the first word whether or not it matches the size to prevent
			-- weird empty first lines and ' ' in front of the first line
			lines[1] = wrd

			continue
		end

		local l = #lines
		local added = lines[l] .. " " .. wrd

		w = surface.GetTextSize(added)

		if w > width then
			table.insert(lines, wrd) -- New line needed
		else
			lines[l] = added -- Safe to tack it on
		end
	end

	-- get length of longest line
	local length = 0

	for _, line in ipairs(lines) do
		local w = surface.GetTextSize(line)

		if w > length then
			length = w
		end
	end

	-- get height of lines
	local w, h = surface.GetTextSize(text)

	return lines, length, h * #lines
end
