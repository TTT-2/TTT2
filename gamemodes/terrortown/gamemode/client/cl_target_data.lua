---
-- @author Mineotopia

TARGET_DATA = {}

---
-- Binds two target data tables to the @{TARGET_DATA} object
-- @param table data The data table about the focused entity
-- @param table params The default table with the params that should be modified by the hook
-- @return @{TARGET_DATA} The object to be used in the hook
-- @internal
-- @realm client
function TARGET_DATA:BindTarget(data, params)
	self.data = data
	self.params = params

	return self
end

---
-- Returns the currently focused entity
-- @return Entity The focused entity
-- @realm client
function TARGET_DATA:GetEntity()
	return self.data.ent
end

---
-- Returns the distance to the focused entity
-- @return number The distance to the focused entity
-- @realm client
function TARGET_DATA:GetEntityDistance()
	return self.data.distance
end

---
-- Enables/Disables the outline around a focused entity
-- @param [default=true] boolean enb_outline A boolean defining the outline state
-- @realm client
function TARGET_DATA:EnableOutline(enb_outline)
	self.params.drawOutline = enb_outline or true
end

---
-- Enables/Disables the targetID text and icons
-- @param [default=true] boolean enb_text A boolean defining the text stat
-- @realm client
function TARGET_DATA:EnableText(enb_text)
	self.params.drawInfo = enb_text or true
end

---
-- Sets the outline color of a focused entity
-- @param [default=Color(255, 255, 255, 255)] Color The outline color
-- @realm client
function TARGET_DATA:SetOutlineColor(color)
	self.params.outlineColor = color or COLOR_WHITE
end

---
-- Returns the reference position of the targetID HUD element. The reference position
-- is used to position the element on screen.
-- @return number, number Reference position x, reference position y
-- @realm client
function TARGET_DATA:GetRefPosition()
	return self.params.refPosition.x, self.params.refPosition.y
end

---
-- Sets the reference position of the targetID HUD element. The reference position
-- is used to position the element on screen. This value shouldn't be changed in
-- a normal scenario.
-- @param number ref_x The reference position on the x axis
-- @param number ref_y The reference position on the y axis
-- @realm client
function TARGET_DATA:SetRefPosition(ref_x, ref_y)
	self.params.refPosition = {
		x = ref_x or self.params.refPosition.x,
		y = ref_y or self.params.refPosition.y
	}
end

---
-- Sets a key to be displayed in the targetID element
-- @param string key The key to be displayed, this can be any string. E.g. "E".
-- @realm client
function TARGET_DATA:SetKey(key)
	self.params.displayInfo.key = key
end

---
-- Sets a key to be displayed in the targetID element based on a key binding
-- @param string key_binding The key binding like "+use".
-- @realm client
function TARGET_DATA:SetKeyBiding(key_binding)
	self.params.displayInfo.key = input.GetKeyCode(input.LookupBinding(key_binding))
end

---
-- Adds a icon to the icon list on the left side of the targetID element.
-- @param Material material The material of the icon that should be rendered
-- @param [default=Color(255, 255, 255, 255)] Color color The color of the icon
-- @return number The amount of icons that are currently in the table
-- @realm client
function TARGET_DATA:AddIcon(material, color)
	self.params.displayInfo.icon[#self.params.displayInfo.icon + 1] = {
		material = material,
		color = color or COLOR_WHITE
	}

	return #self.params.displayInfo.icon
end

---
-- Sets the title of the specific targetID element
-- @param [default=""] string text The text that should be displayed
-- @param [default=Color(255, 255, 255, 255)] Color color The color of the line
-- @param [default=nil] table inline_icons A table of materials that should be rendered in front of the text
-- @realm client
function TARGET_DATA:SetTitle(text, color, inline_icons)
	self.params.displayInfo.title = {
		text = text or "",
		color = color or COLOR_WHITE,
		icons = inline_icons or {}
	}
end

---
-- Sets the subtitle of the specific targetID element
-- @param [default=""] string text The text that should be displayed
-- @param [default=Color(210, 210, 210, 255)] Color color The color of the line
-- @param [default=nil] table inline_icons A table of materials that should be rendered in front of the text
-- @realm client
function TARGET_DATA:SetSubtitle(text, color, inline_icons)
	self.params.displayInfo.subtitle = {
		text = text or "",
		color = color or COLOR_LLGRAY,
		icons = inline_icons or {}
	}
end

---
-- Adds a line of text to the description area of the targetID element
-- @param [default=""] string text The text that should be displayed
-- @param [default=Color(255, 255, 255, 255)] Color color The color of the line
-- @param [default=nil] table inline_icons A table of materials that should be rendered in front of the text
-- @return number The amount of description lines that are currently in the table
-- @realm client
function TARGET_DATA:AddDescriptionLine(text, color, inline_icons)
	self.params.displayInfo.desc[#self.params.displayInfo.desc + 1] = {
		text = text or "",
		color = color or COLOR_WHITE,
		icons = inline_icons or {}
	}

	return #self.params.displayInfo.desc
end

---
-- Returns the raw data tables of the targetID element to me modified by experienced users
-- @return table, table The table of the entity data, the table of the targetID element parameters
function TARGET_DATA:GetRaw()
	return self.data, self.params
end
