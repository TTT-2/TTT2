---
-- @class PANEL
-- @section DSubmenuButtonTTT2

local PANEL = {}

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bBorder", "DrawBorder", FORCE_BOOL)

---
-- @ignore
function PANEL:Init()
    self:SetContentAlignment(5)

    self:SetDrawBorder(true)
    self:SetPaintBackground(true)

    self:SetTall(22)
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)

    self:SetCursor("hand")
    self:SetText("")

    self.contents = {
        title = "",
        title_font = "DermaTTT2SubMenuButtonTitle",
        icon = nil,
        iconFullSize = false,
        iconBadge = nil,
        iconBadgeSize = 0,
        selected = false,
    }
end

---
-- @return boolean
-- @realm client
function PANEL:IsDown()
    return self.Depressed
end

---
-- @param Material badge
-- @realm client
function PANEL:SetIconBadge(badge)
    self.contents.iconBadge = badge
end

---
-- @return Material|nil
-- @realm client
function PANEL:GetIconBadge()
    return self.contents.iconBadge
end

---
-- @param number size
-- @realm client
function PANEL:SetIconBadgeSize(size)
    self.contents.iconBadgeSize = size
end

---
-- @return number
-- @realm client
function PANEL:GetIconBadgeSize()
    return self.contents.iconBadgeSize
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
-- @param Material iconMat
-- @param boolean iconFullSize
-- @realm client
function PANEL:SetIcon(iconMat, iconFullSize)
    self.contents.icon = iconMat
    self.contents.iconFullSize = tobool(iconFullSize)
end

---
-- @return icon
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
-- @return boolean
-- @realm client
function PANEL:IsIconFullSize()
    return self.contents.iconFullSize
end

---
-- @param boolean active
-- @realm client
function PANEL:SetActive(active)
    self.contents.active = active == nil and true or active
end

---
-- @return boolean
-- @realm client
function PANEL:IsActive()
    return self.contents.active or false
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "SubMenuButtonTTT2", self, w, h)

    return false
end

---
-- @ignore
function PANEL:PerformLayout()
    DLabel.PerformLayout(self)
end

---
-- @param string strName
-- @param string strArgs
-- @realm client
function PANEL:SetConsoleCommand(strName, strArgs)
    self.DoClick = function(slf, val)
        RunConsoleCommand(strName, strArgs)
    end
end

---
-- @ignore
function PANEL:SizeToContents()
    local w, h = self:GetContentSize()

    self:SetSize(w + 8, h + 4)
end

derma.DefineControl("DSubmenuButtonTTT2", "A standard Button", PANEL, "DButtonTTT2")
