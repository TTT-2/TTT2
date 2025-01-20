---
-- @class PANEL
-- @section DRoleImageTTT2

local PANEL = {}

--- @ignore
function PANEL:Init()
    self.data = {
        color = COLOR_WHITE,
        icon = nil,
        indicatorState = false,
    }
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
-- @param Material material
-- @realm client
function PANEL:SetMaterial(material)
    self.data.material = material
end

---
-- @return Material
-- @realm client
function PANEL:GetMaterial()
    return self.data.material
end

---
-- @realm client
function PANEL:DoRightClick()
    local newValue = not self:GetValue()

    self:SetValue(newValue)
    self:ValueChanged(newValue)
end

---
-- @param boolean state
-- @realm client
function PANEL:SetIsActiveIndicator(state)
    self.data.indicatorState = state
end

---
-- @return boolean
-- @realm client
function PANEL:GetIsActiveIndicator()
    return self.data.indicatorState or false
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "RoleImageTTT2", self, w, h)

    return true
end

derma.DefineControl("DRoleImageTTT2", "A simple role image", PANEL, "DButtonTTT2")
