if CLIENT then
	function DrawHUDElementBg(x, y, w, h, c)
		surface.SetDrawColor(100, 100, 100, 50)
		surface.DrawRect(x - 1, y - 1, w + 1, h + 1)

		surface.SetDrawColor(clr(c))
		surface.DrawRect(x, y, w, h)
	end

	function HUDELEMENT:DrawBg(x, y, w, h, c)
		DrawHUDElementBg(x, y, w, h, c)
	end
end
