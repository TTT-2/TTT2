---
-- @class PANEL
-- @section DInfoItemTTT2

local PANEL = {}

---
-- @ignore
function PANEL:Init()
    self:SetContentAlignment(5)

    self:SetTall(22)
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)

    self.data = {}
end

---
-- @param table data
-- @realm client
function PANEL:SetData(data)
    self.data = data
end

---
-- @return string|nil
-- @realm client
function PANEL:GetText()
    return self.data.text.text
end

---
-- @return string
-- @realm client
function PANEL:GetTitle()
    return self.data.text.title
end

---
-- @return Material|nil
-- @realm client
function PANEL:GetIcon()
    return self.data.iconMaterial
end

---
-- @return boolean
-- @realm client
function PANEL:HasIcon()
    return self.data.iconMaterial ~= nil
end

---
-- @return Color|nil
-- @realm client
function PANEL:GetColor()
    return self.data.colorBox
end

---
-- @return string
-- @realm client
function PANEL:GetIconText()
    if not self:HasIconTextFunction() then
        return ""
    end

    return self.data.iconText()
end

---
-- @return boolean
-- @realm client
function PANEL:HasIconTextFunction()
    return isfunction(self.data.iconText)
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "InfoItemTTT2", self, w, h)

    return false
end

derma.DefineControl(
    "DInfoItemTTT2",
    "An info box that can contain an icon, a header text and a description area",
    PANEL,
    "DPanelTTT2"
)
