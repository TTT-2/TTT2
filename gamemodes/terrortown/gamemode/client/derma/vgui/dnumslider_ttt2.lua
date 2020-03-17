
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

	Derma_Hook(self.Slider, "Paint", "Paint", "NumSliderTTT2")

	self.Label = vgui.Create ("DLabelTTT2", self)
	self.Label:Dock(LEFT)
	self.Label:SetMouseInputEnabled(true)
	self.Label:SetFont("DermaTTT2Text")

	self.Label.Paint = function(slf, w, h)
		derma.SkinHook("Paint", "FormLabelTTT2", slf, w, h)

		return true
	end

	self.Scratch = self.Label:Add("DNumberScratch")
	self.Scratch:SetImageVisible(false)
	self.Scratch:Dock(FILL)

	-- make sure the calue is only changed in given
	-- decimal steps
	self.Scratch.SetValue = function(slf, val)
		val = math.Round(tonumber(val), self:GetDecimals())

		if val == nil then return end
		if val == slf:GetFloatValue() then return end

		slf:SetFloatValue(val)
		slf:OnValueChanged(val)
		slf:UpdateConVar()
	end

	self.Scratch.OnValueChanged = function()
		self:ValueChanged(self.Scratch:GetFloatValue())
	end

	self:SetTall(32)
	self:SetMin(0)
	self:SetMax(1)
	self:SetDecimals(2)
	self:SetText("")
	self:SetValue(0.5)

	-- You really shouldn't be messing with the internals of
	-- these controls from outside, but if you are, this might
	-- stop your code from fucking us both.
	self.Wang = self.Scratch
end

function PANEL:SetMinMax(min, max)
	self.Scratch:SetMin(tonumber(min))
	self.Scratch:SetMax(tonumber(max))
	self:UpdateNotches()
end

function PANEL:SetDark(b)
	self.Label:SetDark(b)
end

function PANEL:GetMin()
	return self.Scratch:GetMin()
end

function PANEL:GetMax()
	return self.Scratch:GetMax()
end

function PANEL:GetRange()
	return self:GetMax() - self:GetMin()
end

function PANEL:ResetToDefaultValue()
	if not self:GetDefaultValue() then return end

	self:SetValue(self:GetDefaultValue())
end

function PANEL:SetMin(min)
	min = min or 0

	self.Scratch:SetMin(tonumber(min))
	self:UpdateNotches()
end

function PANEL:SetMax(max)
	max = max or 0

	self.Scratch:SetMax(tonumber(max))
	self:UpdateNotches()
end

function PANEL:SetValue(val)
	val = math.Clamp(tonumber(val) or 0, self:GetMin(), self:GetMax())

	if self:GetValue() == val then return end

	self.Scratch:SetValue(val) -- This will also call ValueChanged
	self:ValueChanged(self:GetValue()) -- In most cases this will cause double execution of OnValueChanged
end

function PANEL:GetValue()
	return self.Scratch:GetFloatValue()
end

function PANEL:SetDecimals(d)
	self.Scratch:SetDecimals(d)
	self:UpdateNotches()
	self:ValueChanged(self:GetValue()) -- Update the text
end

function PANEL:GetDecimals()
	return self.Scratch:GetDecimals()
end

function PANEL:IsEditing()
	return self.Scratch:IsEditing() or self.TextArea:IsEditing() or self.Slider:IsEditing()
end

function PANEL:IsHovered()
	return self.Scratch:IsHovered() or self.TextArea:IsHovered() or self.Slider:IsHovered() or vgui.GetHoveredPanel() == self
end

function PANEL:PerformLayout()
	self.Label:SetWide(self:GetWide() / 2.4)
end

function PANEL:SetConVar(cvar)
	self.Scratch:SetConVar(cvar)
	self.TextArea:SetConVar(cvar)
end

function PANEL:SetText(text)
	self.Label:SetText(text)
end

function PANEL:GetText()
	return self.Label:GetText()
end

function PANEL:ValueChanged(val)
	val = math.Clamp(tonumber(val) or 0, self:GetMin(), self:GetMax())

	if self.TextArea ~= vgui.GetKeyboardFocus() then
		self.TextArea:SetValue(self.Scratch:GetTextValue())
	end

	self.Slider:SetSlideX(self.Scratch:GetFraction(val))
	self:OnValueChanged(val)
end

function PANEL:OnValueChanged(val)

end

function PANEL:TranslateSliderValues(x, y)
	self:SetValue(self.Scratch:GetMin() + (x * self.Scratch:GetRange()))

	return self.Scratch:GetFraction(), y
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

function PANEL:SetEnabled(b)
	self.TextArea:SetEnabled(b)
	self.Slider:SetEnabled(b)
	self.Scratch:SetEnabled(b)
	self.Label:SetEnabled(b)

	FindMetaTable("Panel").SetEnabled(self, b)
end

derma.DefineControl("DNumSliderTTT2", "", PANEL, "Panel")
