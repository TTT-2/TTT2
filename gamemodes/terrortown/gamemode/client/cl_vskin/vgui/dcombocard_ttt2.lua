---
-- @class PANEL
-- @section DComboCardTTT2

local PANEL = {}

---
-- @ignore
function PANEL:Init()
    self:SetContentAlignment(5)

    self:SetTall(22)
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)

    self:SetCursor("hand")
    self:SetFont("DermaTTT2TextLarge")

    -- remove label and overwrite function
    self:SetText("")
    self.SetText = function(slf, text)
        slf.data.text = text
    end

    self.data = {
        title = "",
        icon = nil,
        checked = false,
    }
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
-- @param string text
-- @realm client
function PANEL:SetTagText(text)
    self.data.tagtext = text
end

---
-- @return string
-- @realm client
function PANEL:GetTagText()
    return self.data.tagtext
end

---
-- @param Color color
-- @realm client
function PANEL:SetTagColor(color)
    self.data.tagcolor = color
end

---
-- @return Color
-- @realm client
function PANEL:GetTagColor()
    return self.data.tagcolor
end

---
-- @param number mode
-- @realm client
function PANEL:SetChecked(mode)
    self.data.checked = mode or false
end

---
-- @return number
-- @realm client
function PANEL:GetChecked()
    return self.data.checked
end

---
-- @param number keyCode
-- @realm client
function PANEL:OnMouseReleased(keyCode)
    self.BaseClass.OnMouseReleased(self, keyCode)

    if keyCode ~= MOUSE_LEFT then
        return
    end

    local parent = self:GetParent()

    if not IsValid(parent) then
        return
    end

    local oldChecked = self:GetChecked()

    self:SetChecked(true)

    local checked = parent.checked

    parent.checked = self

    self:OnClick(oldChecked, true)

    if not IsValid(checked) or checked == self then
        return
    end

    checked:SetChecked(false)
end

---
-- @param number old
-- @param number new
-- @realm client
function PANEL:OnClick(old, new) end

---
-- @return boolean
-- @realm client
function PANEL:IsDown()
    return self.Depressed
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "ComboCardTTT2", self, w, h)

    return false
end

derma.DefineControl(
    "DComboCardTTT2",
    "A special button where only one can be set at a time",
    PANEL,
    "DButtonTTT2"
)
