local PANEL = {}

function PANEL:Init()
	self:SetText("")

	self.contents = {
		title = "",
		title_font = "DermaTTT2Text",
		opacity = 1.0,
		align = TEXT_ALIGN_CENTER,
		color = COLOR_WHITE,
		icon = nil
	}
end

function PANEL:SetTitle(title)
	self.contents.title = title or ""
end

function PANEL:GetTitle()
	return self.contents.title
end

function PANEL:SetTitleFont(title_font)
	self.contents.title_font = title_font or ""
end

function PANEL:GetTitleFont()
	return self.contents.title_font
end

function PANEL:SetTitleOpacity(opacity)
	self.contents.opacity = opacity or 1.0
end

function PANEL:GetTitleOpacity()
	return self.contents.opacity
end

function PANEL:SetTitleAlign(align)
	self.contents.align = align or TEXT_ALIGN_CENTER
end

function PANEL:GetTitleAlign()
	return self.contents.align
end

function PANEL:SetColor(color)
	self.contents.color = color or COLOR_WHITE
end

function PANEL:GetColor()
	return self.contents.color
end

function PANEL:SetIcon(icon)
	self.contents.icon = icon
end

function PANEL:GetIcon()
	return self.contents.icon
end

function PANEL:HasIcon()
	return self.contents.icon ~= nil
end

function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "ColoredTextBoxTTT2", self, w, h)

	return false
end

derma.DefineControl("DColoredTextBoxTTT2", "", PANEL, "DPanel")
