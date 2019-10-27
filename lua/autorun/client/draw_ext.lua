---
-- @author Mineotopia

local surface = surface
local draw = draw
local tableCopy = table.Copy

local shadowColorDark = Color(0, 0, 0, 220)
local shadowColorWhite = Color(0, 0, 0, 75)

---
-- A function to draw an outlined box with a definable width
-- @param number x The x position of the rectangle
-- @param number y The y position of the rectangle
-- @param number w The width of the rectangle
-- @param number h The height of the rectangle
-- @param [default=1] number t The thickness of the line
-- @param [default=COLOR_WHITE] Color color The color of the line
-- @2D
-- @realm client
function draw.OutlinedBox(x, y, w, h, t, color)
	t = t or 1

	surface.SetDrawColor(color or COLOR_WHITE)
	for i = 0, t - 1 do
		surface.DrawOutlinedRect(x + i, y + i, w - i * 2, h - i * 2)
	end
end

---
-- A function to draw an outlined box with a shadow
-- @param number x The x position of the rectangle
-- @param number y The y position of the rectangle
-- @param number w The width of the rectangle
-- @param number h The height of the rectangle
-- @param [default=1] number t The thickness of the line
-- @param [default=COLOR_WHITE] Color color The color of the line
-- @2D
-- @realm client
function draw.OutlinedShadowedBox(x, y, w, h, t, color)
	color = color or COLOR_WHITE

	local tmpCol = color.r + color.g + color.b > 200 and tableCopy(shadowColorDark) or tableCopy(shadowColorWhite)
	tmpCol.a = tmpCol.a * (color.a / 255.0)

	draw.OutlinedBox(x + 2, y + 2, w, h, t, tmpCol)
	draw.OutlinedBox(x + 1, y + 1, w, h, t, tmpCol)
	draw.OutlinedBox(x + 1, y + 1, w, h, t, tmpCol)
	draw.OutlinedBox(x, y, w, h, t, color)
end

---
-- A function to draw an outlined box with a shadow
-- @param number startX The x position to start the line
-- @param number startY The y position to start the line
-- @param number endX The x position to end the line
-- @param number endY The y position to end the line
-- @param [default=COLOR_WHITE] Color color The color of the line
-- @2D
-- @realm client
function draw.DrawLine(startX, startY, endX, endY, color)
	surface.SetDrawColor(color or COLOR_WHITE)
	surface.DrawLine(startX, startY, endX, endY)
end

---
-- A function to draw an outlined box with a shadow
-- @param number startX The x position to start the line
-- @param number startY The y position to start the line
-- @param number endX The x position to end the line
-- @param number endY The y position to end the line
-- @param [default=COLOR_WHITE] Color color The color of the line
-- @2D
-- @realm client
function draw.DrawShadowedLine(startX, startY, endX, endY, color)
	color = color or COLOR_WHITE

	local tmpCol = color.r + color.g + color.b > 200 and tableCopy(shadowColorDark) or tableCopy(shadowColorWhite)
	tmpCol.a = tmpCol.a * (color.a / 255.0)

	draw.DrawLine(startX + 2, startY + 2, endX + 2, endY + 2, tmpCol)
	draw.DrawLine(startX + 1, startY + 1, endX + 1, endY + 1, tmpCol)
	draw.DrawLine(startX + 1, startY + 1, endX + 1, endY + 1, tmpCol)
	draw.DrawLine(startX, startY, endX, endY, color)
end