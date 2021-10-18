---
-- @class PANEL
-- @section DNumSliderTTT2

local PANEL = {}

---
-- @ignore
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

	local sliderSetDragging = self.Slider.SetDragging

	self.Slider.SetDragging = function(panel, setDragging)
		sliderSetDragging(self.Slider, setDragging)
		self:OnChangeDragging(setDragging)
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

---
-- This function is called, when the slider starts and ends being dragged
-- Calls SetConVarValue only after the dragging ends to not sync every change
-- @param bool setDragging the state it is changed to
-- @realm client
function PANEL:OnChangeDragging(setDragging)
	local value = self:GetValue()

	if setDragging then
		self.valueBeforeDragging = value
	elseif value ~= self.valueBeforeDragging then
		self:SetConVarValues(value)
	end
end

---
-- @param number min
-- @param number max
-- @realm client
function PANEL:SetMinMax(min, max)
	self:SetMin(tonumber(min))
	self:SetMax(tonumber(max))
	self:UpdateNotches()
end

---
-- @return[default=0] number
-- @realm client
function PANEL:GetMin()
	return self.m_numMin or 0
end

---
-- @return[default=0] number
-- @realm client
function PANEL:GetMax()
	return self.m_numMax or 0
end

---
-- @return[default=0] number
-- @realm client
function PANEL:GetRange()
	return self:GetMax() - self:GetMin()
end

---
-- @realm client
function PANEL:ResetToDefaultValue()
	if not self:GetDefaultValue() then return end

	self:SetValue(self:GetDefaultValue())
end

---
-- @param number min
-- @realm client
function PANEL:SetMin(min)
	self.m_numMin = tonumber(min) or 0

	self:UpdateNotches()
end

---
-- @param number max
-- @realm client
function PANEL:SetMax(max)
	self.m_numMax = tonumber(max) or 0

	self:UpdateNotches()
end

---
-- @param any val
-- @param bool ignoreConVar To avoid endless loops, separated setting of convars and UI values
-- @realm client
function PANEL:SetValue(value, ignoreConVar)
	if not value then return end

	value = math.Clamp(tonumber(value) or 0, self:GetMin(), self:GetMax())
	value = math.Round(value, self:GetDecimals())

	if value == self:GetValue() then return end

	self.m_fValue = value

	self:ValueChanged(value)

	-- Set ConVars only when Mouse is released
	if ignoreConVar or self:IsEditing() then return end

	self:SetConVarValues(value)
end

---
-- @param any val
-- @realm client
function PANEL:SetConVarValues(value)
	if self.conVar then
		self.conVar:SetFloat(value)
	end

	if self.serverConVar then
		cvars.ChangeServerConVar(self.serverConVar, tostring(value))
	end
end

---
-- @return any
-- @realm client
function PANEL:GetValue()
	return self.m_fValue or 0
end

---
-- @param number value
-- @realm client
function PANEL:SetDefaultValue(value)
	local noDefault = true

	if isnumber(value) then
		self.default = value
		noDefault = false
	else
		self.default = nil
	end

	local reset = self:GetResetButton()

	if ispanel(reset) then
		reset.noDefault = noDefault
	end
end

---
-- @return number defaultValue
-- @realm client
function PANEL:GetDefaultValue()
	return self.default
end

---
-- @param number d
-- @realm client
function PANEL:SetDecimals(d)
	self.m_iDecimals = d

	self:UpdateNotches()
	self:ValueChanged(self:GetValue()) -- Update the text
end

---
-- @return number
-- @realm client
function PANEL:GetDecimals()
	return self.m_iDecimals or 0
end

---
-- @return boolean
-- @realm client
function PANEL:IsEditing()
	return self.TextArea:IsEditing() or self.Slider:IsEditing()
end

---
-- @return boolean
-- @realm client
function PANEL:IsHovered()
	return self.TextArea:IsHovered() or self.Slider:IsHovered() or vgui.GetHoveredPanel() == self
end

---
-- @param string cvar
-- @realm client
function PANEL:SetConVar(cvar)
	if not ConVarExists(cvar or "") then return end

	self.conVar = GetConVar(cvar)

	self:SetValue(self.conVar:GetFloat(), true)
	self:SetDefaultValue(tonumber(GetConVar(cvar):GetDefault()))
end

---
-- @param string cvar
-- @realm client
function PANEL:SetServerConVar(cvar)
	if not cvar or cvar == "" then return end

	self.serverConVar = cvar

	cvars.ServerConVarGetValue(cvar, function (wasSuccess, value, default)
		if wasSuccess then
			self:SetValue(tonumber(value), true)
			self:SetDefaultValue(tonumber(default))
		end
	end)

	local function OnServerConVarChangeCallback(conVarName, oldValue, newValue)
		if not IsValid(self) then
			cvars.RemoveChangeCallback(conVarName, "TTT2F1MenuServerConVarChangeCallback")

			return
		end

		self:SetValue(tonumber(newValue), true)
	end

	cvars.AddChangeCallback(cvar, OnServerConVarChangeCallback, "TTT2F1MenuServerConVarChangeCallback")
end

---
-- @param Panel reset
-- @realm client
function PANEL:SetResetButton(reset)
	if not ispanel(reset) then return end

	self.resetButton = reset

	reset.DoClick = function(slf)
		self:ResetToDefaultValue()
	end

	reset.noDefault = self.default == nil
end

---
-- @return Panel reset
-- @realm client
function PANEL:GetResetButton()
	return self.resetButton
end

---
-- @param any val
-- @realm client
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

---
-- overwrites the base function with an empty function
-- @param any val
-- @realm client
function PANEL:OnValueChanged(val)

end

---
-- @param number x
-- @param number y
-- @return number fraction
-- @return number y The given y (second param)
-- @realm client
function PANEL:TranslateSliderValues(x, y)
	self:SetValue(self:GetMin() + (x * self:GetRange()))

	return self:GetFraction(), y
end

---
-- @return Panel
-- @realm client
function PANEL:GetTextArea()
	return self.TextArea
end

---
-- @return nil|boolean
-- @realm client
function PANEL:UpdateNotches()
	local range = self:GetRange()

	self.Slider:SetNotches(nil)

	if range < self:GetWide() * 0.25 then
		return self.Slider:SetNotches(range)
	else
		self.Slider:SetNotches(self:GetWide() * 0.25)
	end
end

---
-- @return number
-- @realm client
function PANEL:GetFraction()
	return (self:GetValue() - self:GetMin()) / self:GetRange()
end

---
-- @return string
-- @realm client
function PANEL:GetTextValue()
	local iDecimals = self:GetDecimals()

	if iDecimals == 0 then
		return Format("%i", self:GetValue())
	end

	return Format("%." .. iDecimals .. "f", self:GetValue())
end

---
-- @param boolean b
-- @realm client
function PANEL:SetEnabled(b)
	self.TextArea:SetEnabled(b)
	self.Slider:SetEnabled(b)

	FindMetaTable("Panel").SetEnabled(self, b)
end

derma.DefineControl("DNumSliderTTT2", "", PANEL, "Panel")
