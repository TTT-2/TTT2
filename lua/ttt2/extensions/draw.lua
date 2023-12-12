---
-- draw extension functions
-- @author Mineotopia
-- @module draw

if SERVER then
	AddCSLuaFile()

	return -- the rest of the draw library is client only
end

local render = render
local surface = surface
local draw = draw
local drawSimpleText = draw.SimpleText
local table = table
local cam = cam
local tableCopy = table.Copy
local mathRound = math.Round

local colorShadowDark = Color(0, 0, 0, 220)
local colorShadowBright = Color(0, 0, 0, 75)

local materialBlurScreen = Material("pp/blurscreen")

local function GetShadowColor(color)
	local tmpCol = color.r + color.g + color.b > 200 and tableCopy(colorShadowDark) or tableCopy(colorShadowBright)

	tmpCol.a = mathRound(tmpCol.a * (color.a / 255))

	return tmpCol
end

---
-- A function to draw an outlined box with a definable width.
-- @param number x The x position of the rectangle
-- @param number y The y position of the rectangle
-- @param number w The width of the rectangle
-- @param number h The height of the rectangle
-- @param[default=1] number t The thickness of the line
-- @param[default=COLOR_WHITE] Color color The color of the line
-- @2D
-- @realm client
function draw.OutlinedBox(x, y, w, h, t, color)
	t = t or 1

	surface.SetDrawColor(color or COLOR_WHITE)

	for i = 0, t - 1 do
		surface.DrawOutlinedRect(x + i, y + i, w - i * 2, h - i * 2)
	end
end

local drawOutlinedBox = draw.OutlinedBox

---
-- A function to draw an outlined box with a shadow.
-- @param number x The x position of the rectangle
-- @param number y The y position of the rectangle
-- @param number w The width of the rectangle
-- @param number h The height of the rectangle
-- @param[default=1] number t The thickness of the line
-- @param[default=COLOR_WHITE] Color color The color of the line
-- @2D
-- @realm client
function draw.OutlinedShadowedBox(x, y, w, h, t, color)
	color = color or COLOR_WHITE

	local tmpCol = GetShadowColor(color)

	drawOutlinedBox(x + 2, y + 2, w, h, t, tmpCol)
	drawOutlinedBox(x + 1, y + 1, w, h, t, tmpCol)
	drawOutlinedBox(x + 1, y + 1, w, h, t, tmpCol)
	drawOutlinedBox(x, y, w, h, t, color)
end

---
-- A function to draw a simple rectilinear box.
-- @param number x The x position to start the box
-- @param number y The y position to start the box
-- @param number w The width of the box
-- @param number h The height of the box
-- @param[default=COLOR_WHITE] Color color The color of the box
-- @2D
-- @realm client
function draw.Box(x, y, w, h, color)
	surface.SetDrawColor(color or COLOR_WHITE)
	surface.DrawRect(x, y, w, h)
end

local drawBox = draw.Box

---
-- A function to draws a simple shadowed rectilinear box.
-- @param number x The x position to start the box
-- @param number y The y position to start the box
-- @param number w The width of the box
-- @param number h The height of the box
-- @param[default=Color(255, 255, 255, 255)] Color color The color of the box
-- @param[default=1.0] number scale A scaling factor that is used for the shadows
-- @2D
-- @realm client
function draw.ShadowedBox(x, y, w, h, color, scale)
	color = color or COLOR_WHITE
	scale = scale or 1

	local shift1 = mathRound(scale)
	local shift2 = mathRound(scale * 2)

	local tmpCol = GetShadowColor(color)

	drawBox(x + shift2, y + shift2, w, h, tmpCol)
	drawBox(x + shift1, y + shift1, w, h, tmpCol)
	drawBox(x + shift1, y + shift1, w, h, tmpCol)
	drawBox(x, y, w, h, color)
end

---
-- A function to draw a circle outline.
-- @param number x The center x position to start the circle
-- @param number y The center y position to start the circle
-- @param number r The radius of the circle
-- @param[default=COLOR_WHITE] Color color The color of the circle
-- @2D
-- @realm client
function draw.OutlinedCircle(x, y, r, color)
	color = color or COLOR_WHITE

	surface.DrawCircle(x, y, r, color.r, color.g, color.b, color.a)
end

local drawOutlinedCircle = draw.OutlinedCircle

---
-- A function to draws a circle outline with a shadow.
-- @param number x The center x position to start the circle
-- @param number y The center y position to start the circle
-- @param number r The radius of the circle
-- @param[default=Color(255,255,255,255)]Color color The color of the circle
-- @param[default=1.0]number scale A scaling factor that is used for the shadows
-- @2D
-- @realm client
function draw.OutlinedShadowedCircle(x, y, r, color, scale)
	color = color or COLOR_WHITE
	scale = scale or 1

	local shift1 = mathRound(scale)
	local shift2 = mathRound(scale * 2)

	local tmpCol = GetShadowColor(color)

	drawOutlinedCircle(x + shift2, y + shift2, r, tmpCol)
	drawOutlinedCircle(x + shift1, y + shift1, r, tmpCol)
	drawOutlinedCircle(x + shift1, y + shift1, r, tmpCol)
	drawOutlinedCircle(x, y, r, color)
end

---
-- Draws a circle around a provided center point with a given radius.
-- @param number x The center x position to start the circle
-- @param number y The center y position to start the circle
-- @param number radius The radius of the circle
-- @param[default=Color(255,255,255,255)]Color color The color of the circle
-- @2D
-- @realm client
function draw.Circle(x, y, radius, color)
	color = color or COLOR_WHITE

	local diameter = radius * 2

	draw.RoundedBox(radius, x - radius, y - radius, diameter, diameter, color)
end

local drawCircle = draw.Circle

---
-- A function to draw a circle with a shadow.
-- @param number x The center x position to start the circle
-- @param number y The center y position to start the circle
-- @param number r The radius of the circle
-- @param[default=Color(255,255,255,255)]Color color The color of the circle
-- @param[default=1.0]number scale A scaling factor that is used for the shadows
-- @2D
-- @realm client
function draw.ShadowedCircle(x, y, radius, color, scale)
	color = color or COLOR_WHITE
	scale = scale or 1

	local shift1 = mathRound(scale)
	local shift2 = mathRound(scale * 2)

	local tmpCol = GetShadowColor(color)

	drawCircle(x + shift2, y + shift2, radius, tmpCol)
	drawCircle(x + shift1, y + shift1, radius, tmpCol)
	drawCircle(x + shift1, y + shift1, radius, tmpCol)
	drawCircle(x, y, radius, color)
end

---
-- A function to draw an outlined box with a shadow.
-- @param number startX The x position to start the line
-- @param number startY The y position to start the line
-- @param number endX The x position to end the line
-- @param number endY The y position to end the line
-- @param[default=COLOR_WHITE] Color color The color of the line
-- @2D
-- @realm client
function draw.Line(startX, startY, endX, endY, color)
	surface.SetDrawColor(color or COLOR_WHITE)
	surface.DrawLine(startX, startY, endX, endY)
end

local drawLine = draw.Line

---
-- A function to draw an outlined box with a shadow.
-- @param number startX The x position to start the line
-- @param number startY The y position to start the line
-- @param number endX The x position to end the line
-- @param number endY The y position to end the line
-- @param[default=COLOR_WHITE] Color color The color of the line
-- @2D
-- @realm client
function draw.ShadowedLine(startX, startY, endX, endY, color)
	color = color or COLOR_WHITE

	local tmpCol = GetShadowColor(color)

	drawLine(startX + 2, startY + 2, endX + 2, endY + 2, tmpCol)
	drawLine(startX + 1, startY + 1, endX + 1, endY + 1, tmpCol)
	drawLine(startX + 1, startY + 1, endX + 1, endY + 1, tmpCol)
	drawLine(startX, startY, endX, endY, color)
end

---
-- Draws a textured rectangle / image / icon.
-- @param number x The vertical position
-- @param number y The horizontal position
-- @param number w width The width in reference to the vertical position
-- @param number h height The height in reference to the horizontal position
-- @param Material material
-- @param[default=255] number alpha
-- @param[default=COLOR_WHITE] Color col the alpha value will be ignored
-- @2D
-- @realm client
function draw.Texture(x, y, w, h, material, alpha, color)
	alpha = alpha or 255
	color = color or COLOR_WHITE

	surface.SetDrawColor(color.r, color.g, color.b, alpha)
	surface.SetMaterial(material)

	surface.DrawTexturedRect(x, y, w, h)
end

local drawTexture = draw.Texture

---
-- Draws a textured rectangle / image / icon with shadow.
-- @param number x The vertical position
-- @param number y The horizontal position
-- @param number w width The width in reference to the vertical position
-- @param number h height The height in reference to the horizontal position
-- @param Material material
-- @param[default=255] number alpha
-- @param[default=COLOR_WHITE] Color col the alpha value will be ignored
-- @param[default=1.0] number scale A scaling factor that is used for the shadows
-- @2D
-- @realm client
function draw.ShadowedTexture(x, y, w, h, material, alpha, color, scale)
	alpha = alpha or 255
	color = color or COLOR_WHITE
	scale = scale or 1

	local tmpCol = GetShadowColor(color)

	local shift_tex_1 = mathRound(scale)
	local shift_tex_2 = mathRound(2 * scale)

	drawTexture(x + shift_tex_2, y + shift_tex_2, w, h, material, tmpCol.a, tmpCol)
	drawTexture(x + shift_tex_1, y + shift_tex_1, w, h, material, tmpCol.a, tmpCol)
	drawTexture(x, y, w, h, material, alpha, color)
end

---
-- Draws a filtered textured rectangle / image / icon.
-- @param number x The vertical position
-- @param number y The horizontal position
-- @param number w width The width in reference to the vertical position
-- @param number h height The height in reference to the horizontal position
-- @param Material material
-- @param[default=255] number alpha
-- @param[default=COLOR_WHITE] Color col the alpha value will be ignored
-- @2D
-- @realm client
function draw.FilteredTexture(x, y, w, h, material, alpha, color)
	render.PushFilterMag(TEXFILTER.LINEAR)
	render.PushFilterMin(TEXFILTER.LINEAR)

	drawTexture(x, y, w, h, material, alpha, color)

	render.PopFilterMag()
	render.PopFilterMin()
end

local drawFilteredTexture = draw.FilteredTexture

---
-- Draws a filtered textured rectangle / image / icon with shadow.
-- @param number x The vertical position
-- @param number y The horizontal position
-- @param number w width The width in reference to the vertical position
-- @param number h height The height in reference to the horizontal position
-- @param Material material
-- @param[default=255] number alpha
-- @param[default=COLOR_WHITE] Color col the alpha value will be ignored
-- @param[default=1.0] number scale A scaling factor that is used for the shadows
-- @2D
-- @realm client
function draw.FilteredShadowedTexture(x, y, w, h, material, alpha, color, scale)
	alpha = alpha or 255
	color = color or COLOR_WHITE
	scale = scale or 1

	local tmpCol = GetShadowColor(color)

	local shift_tex_1 = mathRound(scale)
	local shift_tex_2 = mathRound(2 * scale)

	drawFilteredTexture(x + shift_tex_2, y + shift_tex_2, w, h, material, tmpCol.a, tmpCol)
	drawFilteredTexture(x + shift_tex_1, y + shift_tex_1, w, h, material, tmpCol.a, tmpCol)
	drawFilteredTexture(x, y, w, h, material, alpha, color)
end

---
-- Draws a box that uses the remaining screenspace as a blurred background.
-- @param number x The vertical position
-- @param number y The horizontal position
-- @param number w width The width in reference to the vertical position
-- @param number h height The height in reference to the horizontal position
-- @param[default=1] number fraction The blur fraction. The higher, the blurrier
-- @2D
-- @realm client
function draw.BlurredBox(x, y, w, h, fraction)
	fraction = fraction or 1

	surface.SetMaterial(materialBlurScreen)
	surface.SetDrawColor(255, 255, 255, 255)

	for i = 0.33, 1, 0.33 do
		materialBlurScreen:SetFloat("$blur", fraction * i * 5)
		materialBlurScreen:Recompute()

		render.UpdateScreenEffectTexture()

		render.SetScissorRect(x, y, x + w, y + h, true)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		render.SetScissorRect(0, 0, 0, 0, false)
	end
end

---
-- Draws a shadowed text on the screen.
-- @2D
-- @param string text The text to be drawn
-- @param[default="DermaDefault"] nil|string font The font. See @{surface.CreateFont} to create your own,
-- or see <a href="https://wiki.facepunch.com/gmod/Default_Fonts">Default</a>
-- Fonts for a list of default fonts
-- @param number x The X Coordinate
-- @param number y The Y Coordinate
-- @param Color color The color of the text. Uses the Color structure.
-- @param number xalign The alignment of the X coordinate using
-- <a href="https://wiki.facepunch.com/gmod/Enums/TEXT_ALIGN">TEXT_ALIGN_Enums</a>.
-- @param number yalign The alignment of the Y coordinate using
-- <a href="https://wiki.facepunch.com/gmod/Enums/TEXT_ALIGN">TEXT_ALIGN_Enums</a>.
-- @param number scale The scale (float number)
-- @ref https://wiki.facepunch.com/gmod/draw.SimpleText
-- @realm client
function draw.ShadowedText(text, font, x, y, color, xalign, yalign, scale)
	scale = scale or 1.0

	local tmpCol = GetShadowColor(color)

	local shift1 = mathRound(scale)
	local shift2 = mathRound(scale * 2)

	drawSimpleText(text, font, x + shift2, y + shift2, tmpCol, xalign, yalign)
	drawSimpleText(text, font, x + shift1, y + shift1, tmpCol, xalign, yalign)
	drawSimpleText(text, font, x + shift1, y + shift1, tmpCol, xalign, yalign)
	drawSimpleText(text, font, x, y, color, xalign, yalign)
end

local drawShadowedText = draw.ShadowedText

---
-- Draws an advanced text (scalable)
-- @note You should use @{surface.CreateAdvancedFont} before trying to access the font
-- @param string text The text to be drawn
-- @param[default="DefaultBold"] string font The font. See @{surface.CreateAdvancedFont} to create your own. The original font should be always created, see @{surface.CreateFont}.
-- @param number x The x coordinate
-- @param number y The y coordinate
-- @param Color color The color of the text. Uses the Color structure.
-- @param number xalign The alignment of the x coordinate using
-- <a href="https://wiki.facepunch.com/gmod/Enums/TEXT_ALIGN">TEXT_ALIGN_Enums</a>.
-- @param number yalign The alignment of the y coordinate using
-- <a href="https://wiki.facepunch.com/gmod/Enums/TEXT_ALIGN">TEXT_ALIGN_Enums</a>.
-- @param boolean shadow whether there should be a shadow of the text
-- @param[default=1.0] number scale The text scale (float number)
-- @param[default=0] number angle The rotational angle in degree
-- @2D
-- @realm client
function draw.AdvancedText(text, font, x, y, color, xalign, yalign, shadow, scale, angle)
	local scaleModifier = 1.0
	local t_font = fonts.GetFont(font)

	if t_font then
		scaleModifier = fonts.GetScaleModifier(scale)
		font = t_font[scaleModifier]
		scale = scale / scaleModifier
	end

	local scaled = isvector(scale) or scale ~= 1.0
	local rotated = angle and angle ~= 0 and angle ~= 360
	local mat

	if scaled or rotated then
		local hw = ScrW() * 0.5
		local hh = ScrH() * 0.5

		mat = Matrix()
		mat:Translate(Vector(x, y))
		mat:Scale(isvector(scale) and scale or Vector(scale, scale, scale))
		mat:Rotate(Angle(0, angle, 0))
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

	if scaled or rotated then
		cam.PopModelMatrix()

		render.PopFilterMag()
		render.PopFilterMin()
	end
end

-- If there are no spaces, we have to cut the string at some point.
-- To improve performance, we don't want to iterate over every single
-- character. Therefore we assume the length based on an average first.
local function InternalSplitLongWord(word, width, widthWord)
	local charCount = fastutf8.len(word)
	local wCharAverage = widthWord / charCount
	-- limit to at least 1, to prevent infinite loops
	local charCountPerLine = math.max(1, math.floor(width / wCharAverage))

	local lines = { "" }

	local currentStartPos = 1
	local currentLineNumber = 1

	while true do
		local nextStartPos = currentStartPos + charCountPerLine
		local currentEndPos = nextStartPos - 1

		-- Check if we need to end the algorithm and can finish
		if nextStartPos > charCount then
			-- put the remainder into the next line in this special case
			-- this case is reached when calculating the last line and we
			-- overshoot the end of the word, so we need to put the rest
			-- into the next line
			if currentStartPos <= charCount then
				lines[currentLineNumber] = fastutf8.sub(word, currentStartPos, charCount)
			end

			break
		end

		local nextLine = fastutf8.sub(word, currentStartPos, currentEndPos)
		local widthNextLine = surface.GetTextSize(nextLine)

		-- Check if our estimated cut needs adjustment and does not fit
		if widthNextLine > width then
			-- We need to keep removing characters until the line fits
			local charsToRemove = 0
			-- We keep track of the width of the removed chars
			-- to not use the expensive utf8.sub function for each char
			local widthOfRemovedChars = 0

			-- Iterate from the end of the new line to the start
			-- To never remove the first char of a line, we add +1 to the start pos,
			-- so we prevent infinite loops
			for i = currentEndPos, currentStartPos + 1, -1 do
				widthOfRemovedChars = widthOfRemovedChars + surface.GetTextSize(fastutf8.GetChar(word, i))
				charsToRemove = charsToRemove + 1

				if widthNextLine - widthOfRemovedChars <= width then
					break
				end
			end

			-- Only do something if we actually removed chars
			if charsToRemove > 0 then
				-- Remove the chars from the line & shift the next start position
				nextStartPos = nextStartPos - charsToRemove
				nextLine = fastutf8.sub(word, currentStartPos, nextStartPos - 1)
			end
		elseif widthNextLine < width then
			-- We need to add characters until the line does not fit anymore
			local charsToAdd = 0
			-- We keep track of the width of the added chars
			-- to not use the expensive utf8.sub function for each char
			local widthOfAddedChars = 0

			-- Iterate from the end of the current position to the end of the word
			for i = currentEndPos, charCount, 1 do
				widthOfAddedChars = widthOfAddedChars + surface.GetTextSize(fastutf8.GetChar(word, i))

				-- Break if the next char would not fit into the line
				if widthNextLine + widthOfAddedChars >= width then
					break
				end

				-- Only add a char that still fits into the line
				charsToAdd = charsToAdd + 1
			end

			-- Only do something if we actually added chars
			if charsToAdd > 0 then
				-- Add the chars to the line & shift the next start position
				nextStartPos = nextStartPos + charsToAdd
				nextLine = fastutf8.sub(word, currentStartPos, nextStartPos - 1)
			end
		end

		-- Add the line to the table
		lines[currentLineNumber] = nextLine

		-- Set the index to the new start position
		currentStartPos = nextStartPos
		currentLineNumber = currentLineNumber + 1
	end

	return lines
end

local function InternalGetWrappedText(text, allowedWidth, scale)
	-- Any wrapping required?
	local width, height = surface.GetTextSize(text)

	if width <= allowedWidth then
		return { text }, width, height -- Nope, but wrap in table for uniformity
	end

	local words = string.Explode(" ", text)
	local lines = {}

	for i = 1, #words do
		local word = words[i]

		-- first, check the length of the word; if it is longer than a line, then
		-- it has to be split as well
		local widthWord = surface.GetTextSize(word)

		if widthWord > allowedWidth then
			table.Add(lines, InternalSplitLongWord(word, allowedWidth, widthWord))

			continue
		end

		local amountLines = #lines
		local combinedString = ""

		if i == 1 then
			combinedString = word
		else
			combinedString = lines[amountLines] .. " " .. word
		end

		width = surface.GetTextSize(combinedString)

		if width > allowedWidth then
			lines[amountLines + 1] = word -- New line needed
		else
			lines[amountLines] = combinedString -- Safe to tack it on
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

	return lines, length * scale, height * lns * scale
end

---
-- Returns a list of lines to wrap the text matching the given width. Also breaks the string
-- at new line characters.
-- @param string text The text that should be wrapped
-- @param number width The maximal width that the text is allowed to have
-- @param[default="DefaultBold"] string font The font that should be used here
-- @param[default=1.0] number scale The UI scale factor
-- @return table A table with the broken up lines
-- @return number The width of the longest line
-- @return number The height of all lines
-- @realm client
function draw.GetWrappedText(text, width, font, scale)
	scale = scale or 1.0
	width = width / scale

	if not text then
		return {}, 0, 0
	end

	surface.SetFont(font or "DefaultBold")

	local lines = string.Explode("\n", text)
	local returnLines = {}
	local returnWidth = 0
	local returnHeight = 0

	for i = 1, #lines do
		local newLines, newWidth, newHeight = InternalGetWrappedText(lines[i], width, scale)

		table.Add(returnLines, newLines)
		returnWidth = math.max(returnWidth, newWidth)
		returnHeight = returnHeight + newHeight
	end

	return returnLines, returnWidth, returnHeight
end

-- Returns the size of a inserted string
-- @param string text The text that the length should be calculated
-- @param[default="DefaultBold"] string font The font ID
-- @warning This function changes the font to the passed font
-- @return number,number w, h The size of the given text
-- @2D
-- @realm client
function draw.GetTextSize(text, font)
	surface.SetFont(font or "DefaultBold")

	return surface.GetTextSize(text)
end
