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

function TARGET_DATA:GetEntity()
	return self.data.ent
end

function TARGET_DATA:GetEntityDistance()
	return self.data.distance
end

function TARGET_DATA:EnableOutline(enb_outline)
	self.params.drawOutline = enb_outline or true
end

function TARGET_DATA:EnableText(enb_text)
	self.params.drawInfo = enb_text or true
end

function TARGET_DATA:SetOutlineColor(color)
	self.params.outlineColor = color or COLOR_WHITE
end

function TARGET_DATA:GetRefPosition()
	return self.params.refPosition.x, self.params.refPosition.y
end

function TARGET_DATA:SetRefPosition(ref_x, ref_y)
	self.params.refPosition = {
		x = ref_x,
		y = ref_y
	}
end

function TARGET_DATA:SetKey(key)
	self.params.displayInfo.key = key
end

function TARGET_DATA:SetKeyBiding(key_binding)
	self.params.displayInfo.key = input.GetKeyCode(input.LookupBinding(key_binding))
end

function TARGET_DATA:AddIcon(material, color)
	self.params.displayInfo.icon[#self.params.displayInfo.icon + 1] = {
		material = material,
		color = color or COLOR_WHITE
	}
end

function TARGET_DATA:SetTitle(text, color, inline_icons)
	self.params.displayInfo.title = {
		text = text or "",
		color = color or COLOR_WHITE,
		icons = inline_icons or {}
	}
end

function TARGET_DATA:SetSubtitle(text, color, inline_icons)
	self.params.displayInfo.subtitle = {
		text = text or "",
		color = color or COLOR_LLGRAY,
		icons = inline_icons or {}
	}
end

function TARGET_DATA:AddDescriptionLine(text, color, inline_icons)
	self.params.displayInfo.desc[#self.params.displayInfo.desc + 1] = {
		text = text or "",
		color = color or COLOR_WHITE,
		icons = inline_icons or {}
	}
end

function TARGET_DATA:GetRaw()
	return self.data, self.params
end
