HUD.voicePaint = function(s, w, h)
	if not IsValid(s.ply) then return end

	DrawHUDElementBg(0, 0, w, h, s.Color)
	DrawHUDElementLines(0, 0, w, h)
end
