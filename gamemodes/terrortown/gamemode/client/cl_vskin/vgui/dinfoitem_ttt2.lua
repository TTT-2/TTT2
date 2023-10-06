---
-- @class PANEL
-- @section DCardTTT2

local PANEL = {}

---
-- @ignore
function PANEL:Init()
	self:SetContentAlignment(5)

	self:SetTall(22)
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)

	self.data = {
		title = "",
		icon = nil
	}
end

---
-- @param string text
-- @realm client
function PANEL:SetText(text)
	self.data.text = text
end

---
-- @return string
-- @realm client
function PANEL:GetText()
	return self.data.text
end

---
-- @param Material icon
-- @realm client
function PANEL:SetIcon(icon)
	self.data.icon = icon
end

---
-- @return Matieral
-- @realm client
function PANEL:GetIcon()
	return self.data.icon
end

---
-- @ignore
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "InfoItemTTT2", self, w, h)

	return false
end

derma.DefineControl("DInfoItemTTT2", "A special info box used for body search info", PANEL, "DPanelTTT2")
