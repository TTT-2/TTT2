---
-- @class PANEL
-- @section DTextEntryTTT2

local PANEL = {}

local font = "DermaTTT2Text"

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "heightMult", "HeightMult")

---
-- @accessor bool
-- @realm client
AccessorFunc(PANEL, "isOnFocus", "IsOnFocus")

---
-- @accessor string
-- @realm client
AccessorFunc(PANEL, "placeholderText", "PlaceholderText")

---
-- @accessor string
-- @realm client
AccessorFunc(PANEL, "curPlaceholderText", "CurrentPlaceholderText")

---
-- @ignore
function PANEL:Init()
	self.TextArea = vgui.Create("DTextEntry", self)
	self.TextColor = util.GetActiveColor(util.GetChangedColor(util.GetDefaultColor(vskin.GetBackgroundColor()), 25))

	self.TextArea:SetFont(font)
	self.TextArea:SetTextColor(textColor)
	self.TextArea:SetCursorColor(textColor)

	self.TextArea.OnValueChange = function(slf,value)
		-- print("ta.ovc:",slf,value)
		self:SetValue(value)
	end

	self.TextArea.OnGetFocus = function(slf)
		self:SetIsOnFocus(true)
		self:OnGetFocus()
	end

	self.TextArea.OnLoseFocus = function(slf)
		self:SetIsOnFocus(false)
		self:OnLoseFocus()

		if slf:GetValue() == "" then
			self:SetCurrentPlaceholderText(self:GetPlaceholderText())
		else
			self:SetCurrentPlaceholderText("")
		end
	end

	-- This turns off the engine drawing for the text entry
	self.TextArea:SetPaintBackgroundEnabled(false)
	self.TextArea:SetPaintBorderEnabled(false)
	self.TextArea:SetPaintBackground(false)

	-- This turns off the engine drawing of the panel itself
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)
	self:SetPaintBackground(false)

	-- Sets default values
	self:SetHeightMult(1)
	self:SetIsOnFocus(false)
	self:SetPlaceholderText("searchbar_default_placeholder")
	self:SetCurrentPlaceholderText("searchbar_default_placeholder")

	self:PerformLayout()
end

---
-- @realm client
function PANEL:ResetToDefaultValue()
	if not self:GetDefaultValue() then return end

	self:SetValue(self:GetDefaultValue())
end

---
-- @param any val
-- @param bool ignoreConVar To avoid endless loops, separated setting of convars and UI values
-- @realm client
function PANEL:SetValue(value, ignoreConVar)
	-- print("p.sv:", self, value, self:GetValue())
	if not value then return end

	if value == self:GetValue() then return end

	self.m_sValue = value

	self:ValueChanged(value)

	-- Set ConVars only when Mouse is released
	if ignoreConVar --[[or self:IsEditing()]] then --[[print("no convar, editing")]] return end

	self:SetConVarValues(value)
end

---
-- @param any val
-- @realm client
function PANEL:SetConVarValues(value)
	-- print("p.scvv:", self, value)
	if self.conVar then
		self.conVar:SetString(value)
	end

	if self.serverConVar then
		cvars.ChangeServerConVar(self.serverConVar, tostring(value))
	end
end

---
-- @return any
-- @realm client
function PANEL:GetValue()
	return self.m_sValue or ""
end

---
-- @param string value
-- @realm client
function PANEL:SetDefaultValue(value)
	local noDefault = true

	if isstring(value) then
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
-- @return boolean
-- @realm client
function PANEL:IsEditing()
	return self.TextArea:IsEditing()
end

---
-- @return string defaultValue
-- @realm client
function PANEL:GetDefaultValue()
	return self.default
end

---
-- @return boolean
-- @realm client
function PANEL:IsHovered()
	return self.TextArea:IsHovered() or vgui.GetHoveredPanel() == self
end

---
-- @param string cvar
-- @realm client
function PANEL:SetConVar(cvar)
	if not ConVarExists(cvar or "") then return end

	self.conVar = GetConVar(cvar)

	self:SetValue(self.conVar:GetString(), true)
	self:SetDefaultValue(tostring(GetConVar(cvar):GetDefault()))
end

---
-- @param string cvar
-- @realm client
function PANEL:SetServerConVar(cvar)
	if not cvar or cvar == "" then return end

	self.serverConVar = cvar

	cvars.ServerConVarGetValue(cvar, function (wasSuccess, value, default)
		-- print(wasSuccess, value, default)
		if wasSuccess then
			self:SetValue(tostring(value), true)
			self:SetDefaultValue(tostring(default))
		end
	end)

	local function OnServerConVarChangeCallback(conVarName, oldValue, newValue)
		if not IsValid(self) then
			cvars.RemoveChangeCallback(conVarName, "TTT2F1MenuServerConVarChangeCallback")

			return
		end

		self:SetValue(tostring(newValue), true)
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
	-- print("p.vc:", self, val)
	if self.TextArea ~= vgui.GetKeyboardFocus() then
		self.TextArea:SetText(val)
	end

	self:OnValueChanged(val)
end

---
-- overwrites the base function with an empty function
-- @param any val
-- @realm client
function PANEL:OnValueChanged(val)

end

---
-- @return Panel
-- @realm client
function PANEL:GetTextArea()
	return self.TextArea
end

---
-- @return string
-- @realm client
function PANEL:GetTextValue()
	return self:GetValue()
end


---
-- @param string newFont
-- @realm client
function PANEL:SetFont(newFont)
	self.TextArea:SetFont(newFont)

	font = newFont
end

---
-- @return string
-- @realm client
function PANEL:GetFont()
	return font
end

---
-- This function determines if @{PANEL:OnValueChange()} is called on every typed letter or not.
-- @param bool enabled
-- @realm client
function PANEL:SetUpdateOnType(enabled)
	self.TextArea:SetUpdateOnType(enabled)
end

---
-- This function is called when the searchbar is focussed.
-- @note This function can be overwritten but not called.
-- @realm client
function PANEL:OnGetFocus()

end

---
-- This function is called when the searchbar is not focussed anymore.
-- @note This function can be overwritten but not called.
-- @realm client
function PANEL:OnLoseFocus()

end

---
-- This function is called by the searchbar when a text is entered/changed.
-- @note This function should be overwritten but not called.
-- @param string value
-- @realm client
function PANEL:OnValueChange(value)

end

---
-- @ignore
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "TextEntryTTT2", self, w, h)

	return true
end

---
-- @ignore
function PANEL:PerformLayout()
	local width, height = self:GetSize()
	local heightMult = self:GetHeightMult()

	-- local reset = self:GetResetButton()
	-- width = width - 32

	self.TextArea:SetSize(width, height * heightMult)
	self.TextArea:SetPos(0, height * (1 - heightMult) * 0.5)

	-- React to skin changes in menu
	self.TextArea:SetTextColor(util.GetActiveColor(util.GetChangedColor(util.GetDefaultColor(vskin.GetBackgroundColor()), 25)))

	self.TextArea:InvalidateLayout(true)
end

---
-- @return boolean
-- @realm client
function PANEL:Clear()
	return self.TextArea:Clear()
end

---
-- @param boolean b
-- @realm client
function PANEL:SetEnabled(b)
	self.TextArea:SetEnabled(b)

	FindMetaTable("DPanelTTT2").SetEnabled(self, b)
end

derma.DefineControl("DTextEntryTTT2", "", PANEL, "DPanelTTT2")
