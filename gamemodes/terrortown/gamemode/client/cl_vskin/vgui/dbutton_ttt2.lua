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

	self.text = ""

	-- remove label and overwrite function
	self:SetText("")
	self.SetText = function(slf, text)
		slf.text = text
	end
end

---
-- @return string
-- @realm client
function PANEL:GetText()
	return self.text
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
-- @ignore
function PANEL:SizeToContents()
	local w, h = self:GetContentSize()

	self:SetSize(w + 8, h + 4)
end

derma.DefineControl("DButtonTTT2", "A standard Button", PANEL, "DLabelTTT2")
