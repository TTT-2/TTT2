---
-- @class PANEL
-- @section DRoleImageTTT2

local PANEL = {}

--- @ignore
function PANEL:Init()
	self.data = {
		color = COLOR_WHITE,
		icon = nil
	}
end

function PANEL:SetColor(color)
	self.data.color = color
end

function PANEL:GetColor()
	return self.data.color
end

function PANEL:SetMaterial(material)
	self.data.material = material
end

function PANEL:GetMaterial()
	return self.data.material
end

---
-- @ignore
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "RoleImageTTT2", self, w, h)

	return true
end

derma.DefineControl("DRoleImageTTT2", "A simple role image", PANEL, "DPanelTTT2")
