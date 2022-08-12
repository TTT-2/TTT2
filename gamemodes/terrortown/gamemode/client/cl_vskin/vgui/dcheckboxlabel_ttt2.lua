---
-- @class PANEL
-- @section DCheckBoxLabelTTT2

local PANEL = {}

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_iIndent", "Indent")

---
-- @accessor bool
-- @realm client
AccessorFunc(PANEL, "ignoreNetworkedVar", "IgnoreNetworkedVar", FORCE_BOOL)

---
-- @ignore
function PANEL:Init()
	self.Button = vgui.Create("DCheckBox", self)
	self.Button.OnChange = function(_, val)
		self:ValueChanged(val)

		-- enable / disable slaves on change
		self:UpdateSlaves(val)
	end

	local oldSetEnabled = self.SetEnabled

	self.SetEnabled = function(slf, enabled)
		oldSetEnabled(slf, enabled)

		slf.Button:SetEnabled(enabled)

		-- make sure sub-slaves are updated as well
		if not enabled then
			slf:UpdateSlaves(false)
		else
			slf:UpdateSlaves(slf.Button:GetChecked())
		end
	end

	self:SetFont("DermaTTT2Text")

	-- store slaves in here to be updates on change of this value
	self.slaves = {}
end

---
-- @param boolean val
-- @realm client
function PANEL:UpdateSlaves(val)
	for i = 1, #self.slaves do
		self.slaves[i]:SetEnabled(val)
	end
end

---
-- @ignore
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "CheckBoxLabel", self, w, h)

	return true
end

---
-- @param bool invert
-- @realm client
function PANEL:SetInverted(invert)
	self.inverted = tobool(invert)
end

---
-- @param string cvar
-- @realm client
function PANEL:SetConVar(cvar)
	if not ConVarExists(cvar or "") then return end

	self.Button:SetConVar(cvar)
	self:SetDefaultValue(tobool(GetConVar(cvar):GetDefault()))
end

local networkedVarTracker = 0
---
-- @param string cvar
-- @realm client
function PANEL:SetServerConVar(cvar)
	if not cvar or cvar == "" then return end

	self.serverConVar = cvar

	cvars.ServerConVarGetValue(cvar, function(wasSuccess, value, default)
		if wasSuccess then
			self:SetValue(tobool(value), true)
			self:SetDefaultValue(tobool(default))
		end
	end)

	networkedVarTracker = networkedVarTracker % 1023 + 1
	local myIdentifierString = "TTT2F1MenuServerConVarChangeCallback" .. tostring(networkedVarTracker)

	local function OnServerConVarChangeCallback(conVarName, oldValue, newValue)
		if not IsValid(self) then
			cvars.RemoveChangeCallback(conVarName, myIdentifierString)

			return
		end

		self:SetValue(tobool(newValue), true)
	end

	cvars.AddChangeCallback(cvar, OnServerConVarChangeCallback, myIdentifierString)
end

---
-- @param table databaseInfo containing {name, itemName, key}
-- @realm client
function PANEL:SetDatabase(databaseInfo)
	if not istable(databaseInfo) then return end

	local name = databaseInfo.name
	local itemName = databaseInfo.itemName
	local key = databaseInfo.key

	if not name or not itemName or not key then return end

	self.databaseInfo = databaseInfo

	database.GetValue(name, itemName, key, function(databaseExists, value)
		if databaseExists then
			self:SetValue(value, true)
		end
	end)

	self:SetDefaultValue(database.GetDefaultValue(name, itemName, key))

	networkedVarTracker = networkedVarTracker % 1023 + 1
	local myIdentifierString = "TTT2F1MenuDatabaseChangeCallback" .. tostring(networkedVarTracker)

	local function OnDatabaseChangeCallback(_name, _itemName, _key, oldValue, newValue)
		if not IsValid(self) then
			database.RemoveChangeCallback(name, itemName, key, myIdentifierString)

			return
		end

		self:SetValue(newValue, true)
	end

	database.AddChangeCallback(name, itemName, key, OnDatabaseChangeCallback, myIdentifierString)
end

---
-- @param any val
-- @param bool ignoreNetworkedVar To avoid endless loops, separated setting of networked vars and UI values
-- @realm client
function PANEL:SetValue(val, ignoreNetworkedVar)
	self:SetIgnoreNetworkedVar(ignoreNetworkedVar)

	if self.inverted then
		val = not val
	end

	self.Button:SetValue(val)
end

---
-- @param bool value
-- @realm client
function PANEL:SetDefaultValue(value)
	local noDefault = true

	if isbool(value) then
		if self.inverted then
			value = not value
		end

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
-- @return bool defaultValue, if unset returns false
-- @realm client
function PANEL:GetDefaultValue()
	return tobool(self.default)
end

---
-- @param any val
-- @realm client
function PANEL:SetChecked(val)
	self.Button:SetChecked(val)
end

---
-- @return any
-- @realm client
function PANEL:GetChecked()
	return self.Button:GetChecked()
end

---
-- @realm client
function PANEL:Toggle()
	self.Button:Toggle()
end

---
-- @param Panel reset
-- @realm client
function PANEL:SetResetButton(reset)
	if not ispanel(reset) then return end

	self.resetButton = reset

	reset.DoClick = function(slf)
		self:SetValue(self:GetDefaultValue())
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
-- @param Panel slave
-- @realm client
function PANEL:AddSlave(slave)
	if not IsValid(slave) then return end

	self.slaves[#self.slaves + 1] = slave

	slave:SetEnabled(self.Button:GetChecked())
end

---
-- @ignore
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

---
-- @return number
-- @realm client
function PANEL:GetTextPosition()
	return self.textPos or 0
end

---
-- @param string text
-- @realm client
function PANEL:SetText(text)
	self.text = text
end

---
-- @param table params
-- @realm client
function PANEL:SetParams(params)
	self.params = params
end

---
-- @param string font
-- @realm client
function PANEL:SetFont(font)
	self.font = font
end

---
-- @return string
-- @realm client
function PANEL:GetFont()
	return self.font or ""
end

---
-- @return string
-- @realm client
function PANEL:GetText()
	return self.text or ""
end

---
-- @return table
-- @realm client
function PANEL:GetParams()
	return self.params
end

---
-- @param any val
-- @realm client
function PANEL:ValueChanged(val)
	if self.inverted then
		val = not val
	end

	if self.serverConVar and not self:GetIgnoreNetworkedVar() then
		cvars.ChangeServerConVar(self.serverConVar, val and "1" or "0")
	elseif self.databaseInfo and not self:GetIgnoreNetworkedVar() then
		database.SetValue(self.databaseInfo.name, self.databaseInfo.itemName, self.databaseInfo.key, val)
	else
		self:SetIgnoreNetworkedVar(false)
	end

	self:OnValueChanged(val)
end

---
-- overwrites the base function with an empty function
-- @param any val
-- @realm client
function PANEL:OnValueChanged(val)

end

derma.DefineControl("DCheckBoxLabelTTT2", "", PANEL, "DButtonTTT2")
