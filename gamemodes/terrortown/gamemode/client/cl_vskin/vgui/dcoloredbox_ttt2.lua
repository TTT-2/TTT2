local PANEL = {}

function PANEL:Init()
	self:SetText("")

	self.contents = {
		title = "",
		title_font = "DermaTTT2MenuButtonTitle",
		color = COLOR_WHITE
	}
end

function PANEL:SetColor(color)
	self.contents.color = color or COLOR_WHITE
end

function PANEL:GetColor(color)
	return self.contents.color
end

function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "ColoredBoxTTT2", self, w, h)

	return false
end

derma.DefineControl("DColoredBoxTTT2", "", PANEL, "DPanel")
