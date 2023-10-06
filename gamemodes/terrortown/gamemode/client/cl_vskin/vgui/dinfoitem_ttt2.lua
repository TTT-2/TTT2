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
-- @param string text
-- @realm client
function PANEL:SetTitle(title)
	self.data.title = title
end

---
-- @return string
-- @realm client
function PANEL:GetTitle()
	return self.data.title
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
-- @param number live_time
-- @realm client
function PANEL:SetLiveTime(live_time)
	self.data.live_time = live_time
end

---
-- @return number
-- @realm client
function PANEL:GetLiveTime()
	return self.data.live_time
end

---
-- @return boolean
-- @realm client
function PANEL:HasLiveTime()
	return self.data.live_time ~= nil
end

---
-- @param boolean state
-- @realm client
function PANEL:SetLiveTimeInverted(state)
	self.data.live_time_inverted = state
end

---
-- @return boolean
-- @realm client
function PANEL:GetLiveTimeInverted()
	return self.data.live_time_inverted or false
end

---
-- @ignore
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "InfoItemTTT2", self, w, h)

	return false
end

derma.DefineControl("DInfoItemTTT2", "A special info box used for body search info", PANEL, "DPanelTTT2")
