if CLIENT then
	function HUDELEMENT:DrawBg(x, y, w, h, c)
		DrawHUDElementBg(x, y, w, h, c)
	end

	function HUDELEMENT:DrawLines(x, y, w, h)
		DrawHUDElementLines(x, y, w, h)
	end
end
