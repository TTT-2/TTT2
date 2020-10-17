---
-- @class PANEL
-- @section DNumSliderWang

local math = math
local table = table
local vgui = vgui

local PANEL = {}

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_fDefaultValue", "DefaultValue")

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_autoFocus", "AutoFocus")

---
-- @ignore
function PANEL:Init()
	self.TextArea = self:Add("DNumberWang", self)
	self.TextArea:Dock(RIGHT)
	self.TextArea:SetWide(45)

	self.TextArea.OnValueChanged = function(_, val)
		self:SetValue(val)
	end

	local oldOnGetFocus = self.TextArea.OnGetFocus

	self.TextArea.OnGetFocus = function(slf)
		if slf:GetParent():GetAutoFocus() then
			slf:GetParent():GetParent():SetKeyboardInputEnabled(true)
		end

		if isfunction(oldOnGetFocus) then
			oldOnGetFocus(slf)
		end
	end

	local oldOnLoseGocus = self.TextArea.OnLoseFocus

	self.TextArea.OnLoseFocus = function(slf)
		if slf:GetParent():GetAutoFocus() then
			slf:GetParent():GetParent():SetKeyboardInputEnabled(false)
		end

		if isfunction(oldOnLoseGocus) then
			oldOnLoseGocus(slf)
		end
	end

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
	Derma_Hook(self.Slider, "Paint", "Paint", "NumSlider")

	self.Label = vgui.Create("DLabel", self)
	self.Label:Dock(LEFT)
	self.Label:SetMouseInputEnabled(true)

	self.Scratch = self.Label:Add("DNumberScratch")
	self.Scratch:SetImageVisible(false)
	self.Scratch:Dock(FILL)

	self.Scratch.OnValueChanged = function()
		self:ValueChanged(self.Scratch:GetFloatValue())
	end

	self:SetTall(32)

	self:SetMin(0)
	self:SetMax(1)
	self:SetDecimals(2)
	self:SetText("")
	self:SetValue(0.5)

	--
	-- You really shouldn't be messing with the internals of these controls from outside..
	-- .. but if you are, this might stop your code from fucking us both.
	--
	self.Wang = self.Scratch
end

---
-- @param number min
-- @param number max
-- @realm client
function PANEL:SetMinMax(min, max)
	self.Scratch:SetMin(tonumber(min))
	self.Scratch:SetMax(tonumber(max))

	self.TextArea:SetMin(tonumber(min))
	self.TextArea:SetMax(tonumber(max))

	self:UpdateNotches()
end

---
-- @param boolean bool
-- @realm client
function PANEL:SetDark(bool)
	self.Label:SetDark(bool)
end

---
-- @return number
-- @realm client
function PANEL:GetMin()
	return self.Scratch:GetMin()
end

---
-- @return number
-- @realm client
function PANEL:GetMax()
	return self.Scratch:GetMax()
end

---
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
	if not min then
		min = 0
	end

	self.Scratch:SetMin(tonumber(min))
	self.TextArea:SetMin(tonumber(min))

	self:UpdateNotches()
end

---
-- @param number max
-- @realm client
function PANEL:SetMax(max)
	if not max then
		max = 0
	end

	self.Scratch:SetMax(tonumber(max))
	self.TextArea:SetMax(tonumber(max))

	self:UpdateNotches()
end

---
-- @param number val
-- @realm client
function PANEL:SetValue(val)
	val = math.Clamp(tonumber(val) or 0, self:GetMin(), self:GetMax())

	if self:GetValue() == val then return end

	self.Scratch:SetValue(val) -- This will also call ValueChanged
	self.TextArea:SetValue(val)

	self:ValueChanged(self:GetValue()) -- In most cases this will cause double execution of OnValueChanged
end

---
-- @return number float value
-- @realm client
function PANEL:GetValue()
	return self.Scratch:GetFloatValue()
end

---
-- @param number d
-- @realm client
function PANEL:SetDecimals(d)
	self.Scratch:SetDecimals(d)
	self.TextArea:SetDecimals(d)

	self:UpdateNotches()
	self:ValueChanged(self:GetValue()) -- Update the text
end

---
-- @return number decimal value
-- @realm client
function PANEL:GetDecimals()
	return self.Scratch:GetDecimals()
end

---
-- @return boolean Are we currently changing the value?
-- @realm client
function PANEL:IsEditing()
	return self.Scratch:IsEditing() or self.TextArea:IsEditing() or self.Slider:IsEditing()
end

---
-- @return boolean Are we currently hover the value?
-- @realm client
function PANEL:IsHovered()
	return self.Scratch:IsHovered() or self.TextArea:IsHovered() or self.Slider:IsHovered() or vgui.GetHoveredPanel() == self
end

---
-- @ignore
function PANEL:PerformLayout()
	self.Label:SetWide(self:GetWide() / 2.4)
end

---
-- @param string cvar the convar
-- @ref https://wiki.garrysmod.com/page/Panel/SetConVar
-- @realm client
function PANEL:SetConVar(cvar)
	self.Scratch:SetConVar(cvar)
	self.TextArea:SetConVar(cvar)
end

---
-- @param string text
-- @see PANEL:SetText
-- @realm client
function PANEL:SetText(text)
	self.Label:SetText(text)
end

---
-- @return string
-- @see PANEL:SetText
-- @realm client
function PANEL:GetText()
	return self.Label:GetText()
end

---
-- @param any val
-- @realm client
function PANEL:ValueChanged(val)
	val = math.Clamp(tonumber(val) or 0, self:GetMin(), self:GetMax())

	if self.TextArea ~= vgui.GetKeyboardFocus() then
		self.TextArea:SetValue(self.Scratch:GetTextValue())
	end

	self.Slider:SetSlideX(self.Scratch:GetFraction(val))

	self:OnValueChanged(val)
end

---
-- @param any val
-- @realm client
function PANEL:OnValueChanged(val)
	-- For override
end

---
-- @param number x
-- @param number y
-- @return number fraction A value between 0 and 1
-- @return number the given y
-- @realm client
function PANEL:TranslateSliderValues(x, y)
	self:SetValue(self.Scratch:GetMin() + x * self.Scratch:GetRange())

	return self.Scratch:GetFraction(), y
end

---
-- @return Panel
-- @realm client
function PANEL:GetTextArea()
	return self.TextArea
end

---
-- @realm client
function PANEL:UpdateNotches()
	local range = self:GetRange()

	self.Slider:SetNotches(nil)

	if range < self:GetWide() * 0.25 then
		self.Slider:SetNotches(range)
	else
		self.Slider:SetNotches(self:GetWide() * 0.25)
	end
end

---
-- @ignore
function PANEL:GenerateExample(ClassName, PropertySheet, Width, Height)
	local ctrl = vgui.Create(ClassName)
	ctrl:SetWide(200)
	ctrl:SetMin(1)
	ctrl:SetMax(10)
	ctrl:SetText("Example Slider!")
	ctrl:SetDecimals(0)

	PropertySheet:AddSheet(ClassName, ctrl, nil, true, true)
end

derma.DefineControl("DNumSliderWang", "Menu Option Line", table.Copy(PANEL), "Panel")
