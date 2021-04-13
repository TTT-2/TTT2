---
-- @class PANEL
-- @section DColoredBoxTTT2

local PANEL = {}

---
-- @ignore
function PANEL:Init()
	self:SetText("")

	self.contents = {
		title = "",
		title_font = "DermaTTT2MenuButtonTitle",
		color = COLOR_WHITE
	}
end

---
-- @param Color color
-- @realm client
function PANEL:SetColor(color)
	self.contents.color = color or COLOR_WHITE
end

---
-- @return Color
-- @realm client
function PANEL:GetColor()
	return self.contents.color
end

---
-- @param number w
-- @param number h
-- @realm client
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "ColoredBoxTTT2", self, w, h)

	return false
end

derma.DefineControl("DColoredBoxTTT2", "", PANEL, "DPanelTTT2")
