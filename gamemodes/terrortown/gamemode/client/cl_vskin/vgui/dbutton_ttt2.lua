---
-- @class PANEL
-- @section DButtonTTT2

local PANEL = {}

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bBorder", "DrawBorder", FORCE_BOOL)

---
-- @ignore
function PANEL:Init()
	self:SetContentAlignment(5)

	self:SetTall(22)
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)

	self:SetCursor("hand")
	self:SetFont("DermaTTT2Button")
	-- remove label and overwrite function
	self:SetText("")
	self.SetText = function(slf, text)
		slf.data.text = text
	end

	self.data = {}
end

---
-- @return string
-- @realm client
function PANEL:GetText()
	return self.data.text
end

---
-- @param table params
-- @realm client
function PANEL:SetParams(params)
	self.data.params = params
end

---
-- @return table
-- @realm client
function PANEL:GetParams()
	return self.data.params
end

---
-- @return boolean
-- @realm client
function PANEL:HasParams()
	return self.data.params ~= nil
end

---
-- @return boolean
-- @realm client
function PANEL:IsDown()
	return self.Depressed
end

---
-- @ignore
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "ButtonTTT2", self, w, h)

	return false
end

---
-- @param string strName
-- @param string strArgs
-- @realm client
function PANEL:SetConsoleCommand(strName, strArgs)
	self.DoClick = function(slf, val)
		RunConsoleCommand(strName, strArgs)
	end
end

---
-- @param Color color
-- @realm client
function PANEL:SetColor(color)
	self.data.color = color
end

---
-- @return Color
-- @realm client
function PANEL:GetColor()
	return self.data.color
end

---
-- @param Material icon
-- @param[default=false] boolean is_shadowed
-- @param[default=32] number size
-- @realm client
function PANEL:SetIcon(icon, is_shadowed, size)
	self.data.icon = icon
	self.data.icon_shadow = is_shadowed or false
	self.data.icon_size = size or 32
end

---
-- @return Matieral
-- @realm client
function PANEL:GetIcon()
	return self.data.icon
end

---
-- @return boolean
-- @realm client
function PANEL:HasIcon()
	return self.data.icon ~= nil
end

---
-- @return boolean
-- @realm client
function PANEL:IsIconShadowed()
	return self.data.icon_shadow
end

---
-- @return number
-- @realm client
function PANEL:GetIconSize()
	return self.data.icon_size
end

---
-- @ignore
function PANEL:SizeToContents()
	local w, h = self:GetContentSize()

	self:SetSize(w + 8, h + 4)
end

derma.DefineControl("DButtonTTT2", "A standard Button", PANEL, "DLabelTTT2")
