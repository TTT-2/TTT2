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
function HUD.PopupPaint(pnl, w, h)
    DrawHUDElementBg(0, 0, w, h, pnl.paintColor)
    DrawHUDElementLines(0, 0, w, h)
end
