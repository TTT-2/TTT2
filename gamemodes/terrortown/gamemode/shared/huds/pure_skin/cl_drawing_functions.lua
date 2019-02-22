-- x, y, width, height, color
function DrawHUDElementBg(x, y, w, h, c)
	surface.SetDrawColor(clr(c))
	surface.DrawRect(x, y, w, h)
end

-- x, y, width, height, alpha
function DrawHUDElementLines(x, y, w, h, a)
	a = a or 1
	-- draw borders
	-- top, left
	surface.SetDrawColor(255, 255, 255, 40 * a)
	surface.DrawLine(x, y, x + w, y)
	surface.DrawLine(x, y + 1, x, y + h)

	-- top, left
	surface.SetDrawColor(255, 255, 255, 20 * a)
	surface.DrawLine(x + 1, y + 1, x + w, y + 1)
	surface.DrawLine(x + 1, y + 2, x + 1, y + h)

	-- draw borders
	-- bottom, right
	surface.SetDrawColor(0, 0, 0, 125 * a)
	surface.DrawLine(x, y + h - 1, x + w - 1, y + h - 1)
	surface.DrawLine(x + w - 1, y, x + w - 1, y + h)

	-- bottom, right
	surface.SetDrawColor(0, 0, 0, 60 * a)
	surface.DrawLine(x + 1, y + h - 2, x + w - 2, y + h - 2)
	surface.DrawLine(x + w - 2, y + 1, x + w - 2, y + h - 1)
end
