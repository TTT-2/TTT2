if engine.ActiveGamemode() ~= "terrortown" then return end

---
-- @author Mineotopia

local render = render
local surface = surface
local draw = draw
local tableCopy = table.Copy
local mathRound = math.Round

local shadowColorDark = Color(0, 0, 0, 220)
local shadowColorWhite = Color(0, 0, 0, 75)

---
-- A function to draw an outlined box with a definable width
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
-- A function to draw an outlined box with a shadow
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

	local tmpCol = color.r + color.g + color.b > 200 and tableCopy(shadowColorDark) or tableCopy(shadowColorWhite)
	tmpCol.a = mathRound(tmpCol.a * (color.a / 255))

	drawOutlinedBox(x + 2, y + 2, w, h, t, tmpCol)
	drawOutlinedBox(x + 1, y + 1, w, h, t, tmpCol)
	drawOutlinedBox(x + 1, y + 1, w, h, t, tmpCol)
	drawOutlinedBox(x, y, w, h, t, color)
end

---
-- A function to draw an outlined box with a shadow
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
-- A function to draw an outlined box with a shadow
-- @param number startX The x position to start the line
-- @param number startY The y position to start the line
-- @param number endX The x position to end the line
-- @param number endY The y position to end the line
-- @param[default=COLOR_WHITE] Color color The color of the line
-- @2D
-- @realm client
function draw.ShadowedLine(startX, startY, endX, endY, color)
	color = color or COLOR_WHITE

	local tmpCol = color.r + color.g + color.b > 200 and tableCopy(shadowColorDark) or tableCopy(shadowColorWhite)
	tmpCol.a = mathRound(tmpCol.a * (color.a / 255))

	drawLine(startX + 2, startY + 2, endX + 2, endY + 2, tmpCol)
	drawLine(startX + 1, startY + 1, endX + 1, endY + 1, tmpCol)
	drawLine(startX + 1, startY + 1, endX + 1, endY + 1, tmpCol)
	drawLine(startX, startY, endX, endY, color)
end

---
-- Draws a filtered textured rectangle / image / icon
-- @param number x
-- @param number y
-- @param number w width
-- @param number h height
-- @param Material material
-- @param[default=255] number alpha
-- @param[default=COLOR_WHITE] Color col the alpha value will be ignored
-- @2D
-- @realm client
function draw.FilteredTexture(x, y, w, h, material, alpha, color)
	alpha = alpha or 255
	color = color or COLOR_WHITE

	surface.SetDrawColor(color.r, color.g, color.b, alpha)
	surface.SetMaterial(material)

	render.PushFilterMag(TEXFILTER.LINEAR)
	render.PushFilterMin(TEXFILTER.LINEAR)

	surface.DrawTexturedRect(x, y, w, h)

	render.PopFilterMag()
	render.PopFilterMin()
end

local drawFilteredTexture = draw.FilteredTexture

---
-- Draws a filtered textured rectangle / image / icon with shadow
-- @param number x
-- @param number y
-- @param number w width
-- @param number h height
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

	local tmpCol = color.r + color.g + color.b > 200 and tableCopy(shadowColorDark) or tableCopy(shadowColorWhite)
	tmpCol.a = mathRound(tmpCol.a * (alpha / 255))

	local shift_tex_1 = mathRound(scale)
	local shift_tex_2 = mathRound(2 * scale)

	drawFilteredTexture(x + shift_tex_2, y + shift_tex_2, w, h, material, tmpCol.a, tmpCol)
	drawFilteredTexture(x + shift_tex_1, y + shift_tex_1, w, h, material, tmpCol.a, tmpCol)
	drawFilteredTexture(x, y, w, h, material, alpha, color)
end
