---
-- HUD base class.
-- @class HUD
-- @section pure_skin

---
-- This overwrites the default popup drawing function
-- @param Panel pnl source panel
-- @param number w width
-- @param number h height
-- @realm client
function HUD.VoicePaint(pnl, w, h)
	if not IsValid(pnl.ply) then return end

	DrawHUDElementBg(0, 0, w, h, pnl.Color)
	DrawHUDElementLines(0, 0, w, h)
end
