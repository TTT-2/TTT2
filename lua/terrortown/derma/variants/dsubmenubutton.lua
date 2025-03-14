---
-- @class PANEL
-- @section TTT2:DSubmenuButton

DPANEL.derma = {
    className = "TTT2:DSubmenuButton",
    description = "A spin on TTT2's button that has some extra features for the submenu list",
    baseClassName = "TTT2:DButton",
}

local heightNavButton = 50

---
-- @ignore
function DPANEL:Init()
    -- toggle is disabled and set manually on click
    self:SetIsToggle(false)
    self:SetToggle(false)

    -- set visual defaults
    self:SetTextAlign(TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    self:SetFont("DermaTTT2SubMenuButtonTitle")
    self:SetOutline(vskin.GetBorderSize(), 0, 0, 0)
    self:SetPadding(18 + vskin.GetBorderSize(), 0)
end

---
-- @ignore
function DPANEL:OnRebuildLayout(w, h)
    self:SetSize(self:GetParent():GetWide(), heightNavButton)

    DBase("TTT2:DButton").OnRebuildLayout(self, w, h)
end

---
-- @ignore
function DPANEL:OnVSkinUpdate()
    local parentColor = self:GetParentVSkinColor() or vskin.GetBackgroundColor()

    local colorBackground, colorText, colorIcon, colorOutline

    -- PANEL DISABLED
    -- (not implemented for now)

    -- PANEL IS PRESSED
    if self:IsDepressed() or self:IsSelected() or self:GetToggle() then
        colorBackground = util.GetMergedColor(
            self:GetColor() or util.GetActiveColor(vskin.GetAccentColor()),
            parentColor,
            50
        )
        colorText =
            util.GetActiveColor(util.GetChangedColor(util.GetDefaultColor(colorBackground), 25))
        colorIcon = util.GetActiveColor(util.GetChangedColor(COLOR_WHITE, 32))
        colorOutline = self:GetOutlineColor() or util.GetActiveColor(vskin.GetAccentColor())

    -- PANEL IS HOVERED
    elseif self:IsHovered() then
        colorBackground = util.GetMergedColor(
            self:GetColor() or util.GetHoverColor(vskin.GetAccentColor()),
            parentColor,
            50
        )
        colorText =
            util.GetHoverColor(util.GetChangedColor(util.GetDefaultColor(colorBackground), 75))
        colorIcon = util.GetHoverColor(util.GetChangedColor(COLOR_WHITE, 48))
        colorOutline = self:GetOutlineColor() or util.GetHoverColor(vskin.GetAccentColor())

    -- NORMAL COLORS
    else
        colorBackground = self:GetColor()
            or self:GetParentVSkinColor()
            or vskin.GetBackgroundColor()
        colorText = util.GetChangedColor(util.GetDefaultColor(colorBackground), 75)
        colorIcon = util.GetHoverColor(util.GetChangedColor(COLOR_WHITE, 32))
        colorOutline = colorBackground
    end

    self:ApplyVSkinColor("background", colorBackground)
    self:ApplyVSkinColor("text", colorText)
    self:ApplyVSkinColor("description", colorText)
    self:ApplyVSkinColor("icon", colorIcon)
    self:ApplyVSkinColor("outline", colorOutline)
    self:ApplyVSkinColor("flash", colorText)
end

---
-- @param Material badge
-- @realm client
function DPANEL:SetIconBadge(badge)
    --self.contents.iconBadge = badge

    return self
end

---
-- @return Material|nil
-- @realm client
function DPANEL:GetIconBadge()
    return self.contents.iconBadge
end

---
-- @param number size
-- @realm client
function DPANEL:SetIconBadgeSize(size)
    --self.contents.iconBadgeSize = size

    return self
end

---
-- @return number
-- @realm client
function DPANEL:GetIconBadgeSize()
    return self.contents.iconBadgeSize
end
