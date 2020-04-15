---
-- @class EPOP
-- @author Mineotopia
-- @desc A event popup system that works alongside the MSTACK system to display important messages

EPOP = {}

---
-- Adds a popup message to the @{EPOP}
-- @param string|table title The title of the popup that will be displayed in large letters (can be a table with `text` and `color` attribute)
-- @param string|table text An optional description that will be displayed below the title (can be a table with `text` and `color` attribute)
-- @param number disp_time The render duration of the popup
-- @param table icon_tbl An optional set of icon materials that will be rendered below the popup
-- @realm client
function EPOP:AddMessage(title, text, disp_time, icon_tbl)
	self.msg = {
		title = {},
		text = {}
	}

	if isstring(title) then
		self.msg.title.text = title
	else
		self.msg.title = title
	end

	if isstring(text) then
		self.msg.text.text = text
	else
		self.msg.text = text
	end

	self.msg.icon_tbl = icon_tbl or {}
	self.msg.time = CurTime() + (disp_time or 4)
end

---
-- A shortcut function to check if an @{EPOP} should be rendered
-- @realm client
function EPOP:ShouldRender()
	if not self.msg or CurTime() > self.msg.time then
		return false
	end

	return true
end

---
-- Instantly removed the currently displayed @{EPOP}
-- @realm client
function EPOP:RemoveMessage()
	self.msg = nil
end
