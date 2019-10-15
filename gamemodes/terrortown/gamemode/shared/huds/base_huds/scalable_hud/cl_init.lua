---
-- HUD base class.
-- @module HUD
-- @section scalable_hud

local base = "hud_base"

local savingKeys

DEFINE_BASECLASS(base)

HUD.Base = base
HUD.defaultscale = 1.0
HUD.scale = HUD.defaultscale

---
-- This will initialize the HUD, by calling @{HUDELEMENT:Initialize} on its
-- elements, respecting the parent -> child relations. It will also call
-- @{HUD:PerformLayout} before setting the HUDELEMENT.initialized parameter.
-- @realm client
function HUD:Initialize()
	self.basecolor = self.defaultcolor

	BaseClass.Initialize(self)
end

---
-- This function will return a table containing all keys that will be stored by
-- the @{HUD:SaveData} function.
-- @return table
-- @realm client
function HUD:GetSavingKeys()
	if not savingKeys then
		savingKeys = BaseClass.GetSavingKeys(self)
		savingKeys.basecolor = {
			typ = "color",
			desc = LANG.GetTranslation("f1_settings_hudswitcher_desc_basecolor"),
			OnChange = function(slf, col)
				slf:PerformLayout()
			end
		}
		savingKeys.scale = {
			typ = "number",
			desc = LANG.GetTranslation("f1_settings_hudswitcher_desc_hud_scale"),
			OnChange = function(slf, val)
				slf.scale = val

				slf:Reset()
				slf:SaveData()
			end
		}
	end

	return table.Copy(savingKeys)
end

---
-- This function will load all saved keys from the Database and will then call
-- @{HUDELEMENT:LoadData} on all elements, shown by the HUD. After that it will
-- call @{HUD:PerformLayout}. This function is called when the HUDManager loads
-- / changes to this HUD.
-- @realm client
function HUD:LoadData()
	BaseClass.LoadData(self)

	for _, elem in ipairs(self:GetElements()) do
		local el = hudelements.GetStored(elem)
		if el then
			local min_size = el:GetDefaults().minsize

			el:SetMinSize(min_size.w * self.scale, min_size.h * self.scale)
			el:PerformLayout()
		end
	end
end

---
-- Applies the scaling
-- @param number scale
-- @realm client
function HUD:ApplyScale(scale)
	for _, elem in ipairs(self:GetElements()) do
		local el = hudelements.GetStored(elem)
		if el then
			local size = el:GetSize()
			local min_size = el:GetMinSize()

			el:SetMinSize(min_size.w * scale, min_size.h * scale)
			el:SetSize(size.w * scale, size.h * scale)
			el:PerformLayout()

			--reset position to new calculated default position
			local defaultPos = el:GetDefaults().basepos

			el:SetBasePos(defaultPos.x, defaultPos.y)
			el:PerformLayout()
		end
	end
end

---
-- This will reset all elements of the HUD and call @{HUDELEMENT:Reset} on its
-- elements. This will respect the parent -> child relation and only call this
-- on non-child elements.
-- @realm client
function HUD:Reset()
	self.basecolor = self.defaultcolor

	BaseClass.Reset(self)

	self:ApplyScale(self.scale)
end
