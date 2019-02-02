if CLIENT then
	function HUDELEMENT:DrawBg(x, y, w, h, c)
		surface.SetDrawColor(clr(c))
		surface.DrawRect(x, y, w, h)
	end
end
