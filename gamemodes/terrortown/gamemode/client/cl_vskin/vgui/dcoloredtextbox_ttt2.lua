---
-- @class PANEL
-- @section DColoredTextBoxTTT2

local PANEL = {}

---
-- @ignore
function PANEL:Init()
    self:SetText("")

    self.contents = {
        title = "",
        title_font = "DermaTTT2Text",
        opacity = 1.0,
        align = TEXT_ALIGN_CENTER,
        color = COLOR_WHITE,
        flashcolor = false,
        icon = nil,
        parent = nil,
        shift = 0,
    }
end

---
-- @param Panel parent
-- @param number shift
-- @realm client
function PANEL:SetDynamicColor(parent, shift)
    self.contents.parent = parent
    self.contents.shift = shift
end

---
-- @return boolean
-- @realm client
function PANEL:HasDynamicColor()
    return self.contents.parent ~= nil
end

---
-- @return Color
-- @realm client
function PANEL:GetDynamicParentColor()
    return self.contents.parent.dynBaseColor
end

---
-- @return Color
-- @realm client
function PANEL:GetDynamicParentColorShift()
    return self.contents.shift
end

---
-- @param string title
-- @realm client
function PANEL:SetTitle(title)
    self.contents.title = title or ""
end

---
-- @return string
-- @realm client
function PANEL:GetTitle()
    return self.contents.title
end

---
-- @param string title_font
-- @realm client
function PANEL:SetTitleFont(title_font)
    self.contents.title_font = title_font or ""
end

---
-- @return string
-- @realm client
function PANEL:GetTitleFont()
    return self.contents.title_font
end

---
-- @param number opacity
-- @realm client
function PANEL:SetTitleOpacity(opacity)
    self.contents.opacity = opacity or 1.0
end

---
-- @return number
-- @realm client
function PANEL:GetTitleOpacity()
    return self.contents.opacity
end

---
-- @param number align
-- @realm client
function PANEL:SetTitleAlign(align)
    self.contents.align = align or TEXT_ALIGN_CENTER
end

---
-- @return number
-- @realm client
function PANEL:GetTitleAlign()
    return self.contents.align
end

---
-- @param Color color
-- @realm client
function PANEL:SetColor(color)
    self.contents.color = color or COLOR_WHITE
end

---
-- @return Color
-- @realm client
function PANEL:GetColor()
    return self.contents.color
end

---
-- @param Color color
-- @realm client
function PANEL:EnableFlashColor(enb)
    self.contents.flashcolor = enb
end

---
-- @return boolean
-- @realm client
function PANEL:HasFlashColor()
    return self.contents.flashcolor or false
end

---
-- @param Material icon
-- @realm client
function PANEL:SetIcon(icon)
    self.contents.icon = icon
end

---
-- @return Material
-- @realm client
function PANEL:GetIcon()
    return self.contents.icon
end

---
-- @return boolean
-- @realm client
function PANEL:HasIcon()
    return self.contents.icon ~= nil
end

---
-- @param number w
-- @param number h
-- @realm client
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "ColoredTextBoxTTT2", self, w, h)

    return false
end

derma.DefineControl("DColoredTextBoxTTT2", "", PANEL, "DPanelTTT2")
