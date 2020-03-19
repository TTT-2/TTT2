local PANEL = {}

AccessorFunc(PANEL, "m_iIndent", "Indent")

function PANEL:Init()
	self.Button = vgui.Create("DCheckBox", self)
	self.Button.OnChange = function(_, val)
		self:OnChange(val)

		-- enable / disable slaves on change
		self:UpdateSlaves(val)
	end

	self:SetFont("DermaTTT2Text")

	-- store slaves in here to be updates on change of this value
	self.slaves = {}
end

function PANEL:UpdateSlaves(val)
	for i = 1, #self.slaves do
		self.slaves[i]:SetEnabled(val)
	end
end

function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "CheckBoxLabel", self, w, h)

	return true
end

function PANEL:SetEnabled(enabled)
	self:SetDisabled(not enabled)

	self.Button:SetEnabled(enabled)

	-- make sure sub-slaves are updated as well
	if not enabled then
		self:UpdateSlaves(false)
	else
		self:UpdateSlaves(self.Button:GetChecked())
	end
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

function PANEL:AddSlave(slave)
	self.slaves[#self.slaves + 1] = slave

	slave:SetEnabled(self.Button:GetChecked())
end

function PANEL:PerformLayout()
	local x = self.m_iIndent or 0

	local height = self:GetTall()
	local paddingButton = 4
	local heightButton = height - 2 * paddingButton
	local widthButton = 1.5 * heightButton

	self.Button:SetSize(widthButton, heightButton)
	self.Button:SetPos(x + paddingButton, paddingButton)

	self.textPos = 2 * paddingButton + widthButton + x + 5
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
