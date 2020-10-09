
local PANEL = {}

AccessorFunc(PANEL, "m_iSelectedNumber", "SelectedNumber")

Derma_Install_Convar_Functions(PANEL)

function PANEL:Init()
	self:SetSelectedNumber(0)
	self:SetSize(60, 30)
end

function PANEL:UpdateText()
	local str = input.GetKeyName(self:GetSelectedNumber())

	if not str then
		str = "button_none"
	end

	str = language.GetPhrase(str)

	self:SetText(str)
end

function PANEL:DoClick()
	self:SetText("button_press_key")

	input.StartKeyTrapping()

	self.trapping = true
end

function PANEL:DoRightClick()
	self:SetText("button_none")
	self:SetValue(0)
end

function PANEL:SetSelectedNumber(iNum)
	self.m_iSelectedNumber = iNum
	self:ConVarChanged(iNum)
	self:UpdateText()
	self:OnChange(iNum)
end

function PANEL:Think()
	if input.IsKeyTrapping() and self.trapping then
		local code = input.CheckKeyTrapping()

		if code then
			if code == KEY_ESCAPE then
				self:SetValue(self:GetSelectedNumber())
			else
				self:SetValue(code)
			end

			self.trapping = false
		end

	end

	self:ConVarNumberThink()
end

function PANEL:SetValue(iNumValue)
	self:SetSelectedNumber(iNumValue)
end

function PANEL:GetValue()
	return self:GetSelectedNumber()
end

function PANEL:OnChange()

end

derma.DefineControl("DBinderTTT2", "", PANEL, "DButtonTTT2")
