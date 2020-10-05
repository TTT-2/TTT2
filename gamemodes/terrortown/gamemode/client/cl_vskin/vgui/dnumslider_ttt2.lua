local PANEL = {}

AccessorFunc(PANEL, "m_fDefaultValue", "DefaultValue")

function PANEL:Init()
	self.TextArea = self:Add("DTextEntry")
	self.TextArea:Dock(RIGHT)
	self.TextArea:SetPaintBackground(false)
	self.TextArea:SetWide(45)
	self.TextArea:SetNumeric(true)
	self.TextArea:SetFont("DermaTTT2Text")

	self.TextArea.OnChange = function(textarea, val)
		self:SetValue(self.TextArea:GetText())
	end

	self.TextArea.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "SliderTextAreaTTT2", slf, w, h)

		return true
	end

	-- Causes automatic clamp to min/max, disabled for now
	self.Slider = self:Add("DSlider", self)
	self.Slider:SetLockY(0.5)

	self.Slider.TranslateValues = function(slider, x, y)
		return self:TranslateSliderValues(x, y)
	end

	self.Slider.GetFraction = function(slf)
		return self:GetFraction()
	end

	self.Slider:SetTrapInside(true)
	self.Slider:Dock(FILL)
	self.Slider:SetHeight(16)

	self.Slider.Knob.OnMousePressed = function(panel, mcode)
		if mcode == MOUSE_MIDDLE then
			self:ResetToDefaultValue()

			return
		end

		self.Slider:OnMousePressed(mcode)
	end

	-- make slider know a bit bigger
	self.Slider.Knob.PerformLayout = function(slf)
		local _, pH = self:GetSize()

		slf:SetSize(8, pH - 10)
	end

	Derma_Hook(self.Slider, "Paint", "Paint", "NumSliderTTT2")

	self:SetTall(32)
	self:SetMin(0)
	self:SetMax(1)
	self:SetDecimals(2)
	self:SetText("")
	self:SetValue(0.5)
end

function PANEL:SetMinMax(min, max)
	self:SetMin(tonumber(min))
	self:SetMax(tonumber(max))
	self:UpdateNotches()
end

function PANEL:GetMin()
	return self.m_numMin or 0
end

function PANEL:GetMax()
	return self.m_numMax or 0
end

function PANEL:GetRange()
	return self:GetMax() - self:GetMin()
end

function PANEL:ResetToDefaultValue()
	if not self:GetDefaultValue() then return end

	self:SetValue(self:GetDefaultValue())
end

function PANEL:SetMin(min)
	self.m_numMin = tonumber(min) or 0

	self:UpdateNotches()
end

function PANEL:SetMax(max)
	self.m_numMax = tonumber(max) or 0

	self:UpdateNotches()
end

function PANEL:SetValue(val)
	if not val then return end

	val = math.Clamp(tonumber(val) or 0, self:GetMin(), self:GetMax())
	val = math.Round(val, self:GetDecimals())

	if val == self:GetValue() then return end

	self.m_fValue = val

	self:ValueChanged(self.m_fValue)

	if self.conVar then
		self.conVar:SetFloat(self.m_fValue)
	end
end

function PANEL:GetValue()
	return self.m_fValue or 0
end

function PANEL:SetDecimals(d)
	self.m_iDecimals = d

	self:UpdateNotches()
	self:ValueChanged(self:GetValue()) -- Update the text
end

function PANEL:GetDecimals()
	return self.m_iDecimals or 0
end

function PANEL:IsEditing()
	return self.TextArea:IsEditing() or self.Slider:IsEditing()
end

function PANEL:IsHovered()
	return self.TextArea:IsHovered() or self.Slider:IsHovered() or vgui.GetHoveredPanel() == self
end

function PANEL:SetConVar(cvar)
	if not cvar or cvar == "" then return end

	self.conVar = GetConVar(cvar)

	self:SetValue(self.conVar:GetFloat())
end

function PANEL:ValueChanged(val)
	val = math.Clamp(tonumber(val) or 0, self:GetMin(), self:GetMax())

	if self.TextArea ~= vgui.GetKeyboardFocus() then
		self.TextArea:SetValue(self:GetTextValue())
	end

	-- update knob position
	self.Slider:SetSlideX(self:GetFraction())
	self.Slider:InvalidateLayout()

	self:OnValueChanged(val)
end

-- overwrites the base function with an empty function
function PANEL:OnValueChanged(val)

end

function PANEL:TranslateSliderValues(x, y)
	self:SetValue(self:GetMin() + (x * self:GetRange()))

	return self:GetFraction(), y
end

function PANEL:GetTextArea()
	return self.TextArea
end

function PANEL:UpdateNotches()
	local range = self:GetRange()

	self.Slider:SetNotches(nil)

	if range < self:GetWide() * 0.25 then
		return self.Slider:SetNotches(range)
	else
		self.Slider:SetNotches(self:GetWide() * 0.25)
	end
end

function PANEL:GetRange()
	return self:GetMax() - self:GetMin()
end

function PANEL:GetFraction()
	return (self:GetValue() - self:GetMin()) / self:GetRange()
end

function PANEL:GetTextValue()
	local iDecimals = self:GetDecimals()

	if iDecimals == 0 then
		return Format("%i", self:GetValue())
	end

	return Format("%." .. iDecimals .. "f", self:GetValue())
end

function PANEL:SetEnabled(b)
	self.TextArea:SetEnabled(b)
	self.Slider:SetEnabled(b)

	FindMetaTable("Panel").SetEnabled(self, b)
end

derma.DefineControl("DNumSliderTTT2", "", PANEL, "Panel")
