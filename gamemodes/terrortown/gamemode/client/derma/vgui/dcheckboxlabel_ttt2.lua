local PANEL = {}

AccessorFunc(PANEL, "m_iIndent", "Indent")

function PANEL:Init()
	self.Button = vgui.Create("DCheckBox", self)
	self.Button.OnChange = function(_, val)
		self:OnChange(val)
	end

	self:SetFont("DermaTTT2Text")
end

function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "CheckBoxLabel", self, w, h)

	return true
end

function PANEL:SetConVar(cvar)
	self.Button:SetConVar(cvar)
end

function PANEL:SetValue(val)
	self.Button:SetValue(val)
end

function PANEL:SetChecked(val)
	self.Button:SetChecked(val)
end

function PANEL:GetChecked(val)
	return self.Button:GetChecked()
end

function PANEL:Toggle()
	self.Button:Toggle()
end

function PANEL:PerformLayout()
	local x = self.m_iIndent or 0

	local height = self:GetTall()
	local heightButton = 0.8 * height
	local widthButton = 1.3 * height
	local paddingButton = 0.5 * (height - heightButton)

	self.Button:SetSize(widthButton, heightButton)
	self.Button:SetPos(x + paddingButton, paddingButton)

	self.textPos = 2 * paddingButton + widthButton + x
end

function PANEL:GetTextPosition()
	return self.textPos or 0
end

function PANEL:SetText(text)
	self.text = text
end

function PANEL:SetFont(font)
	self.font = font
end

function PANEL:GetFont()
	return self.font or ""
end

function PANEL:GetText()
	return self.text or ""
end

function PANEL:OnChange(bVal)

end

derma.DefineControl("DCheckBoxLabelTTT2", "", PANEL, "DButtonTTT2")
