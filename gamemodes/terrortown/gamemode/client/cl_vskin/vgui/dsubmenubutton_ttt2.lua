---
-- @class PANEL
-- @section DSubmenuButtonTTT2

local PANEL = {}

---
-- @ignore
function PANEL:Init()
    self:BaseClass().Init(self)

    -- enable toggling when selecting
    self:SetIsToggle(true)
    self:SetToggle(false)

    -- set visual defaults
    self:SetTextAlign(TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- paint hook name is set so that the post hook can be
    -- used to render badge
    self:SetPaintHookName("SubmenuButton")

    -- TODO maybe somthing for perform layout:
    --settingsButton.PerformLayout = function(panel)
    --    panel:SetSize(panel:GetParent():GetWide(), heightNavButton)
    --end
end

---
-- @ignore
function PANEL:OnVSkinUpdate()
    local colorBackground, colorText, colorIcon, colorOutline

    -- PANEL DISABLED
    -- (not implemented for now)

    -- PANEL IS PRESSED
    if self:IsDepressed() or self:IsSelected() or self:GetToggle() then
        colorBackground =
            util.GetAlphaColor(self:GetColor() or util.GetActiveColor(vskin.GetAccentColor()), 50)
        colorText =
            util.GetActiveColor(util.GetChangedColor(util.GetDefaultColor(colorBackground), 25))
        colorIcon = util.GetActiveColor(util.GetChangedColor(COLOR_WHITE, 32))
        colorOutline = self:GetOutlineColor() or util.GetActiveColor(vskin.GetAccentColor())

    -- PANEL IS HOVERED or NORMAL COLORS
    else
        colorBackground =
            util.GetAlphaColor(self:GetColor() or util.GetHoverColor(vskin.GetAccentColor()), 50)
        colorText =
            util.GetHoverColor(util.GetChangedColor(util.GetDefaultColor(colorBackground), 75))
        colorIcon = util.GetHoverColor(util.GetChangedColor(COLOR_WHITE, 48))
        colorOutline = self:GetOutlineColor() or util.GetHoverColor(vskin.GetAccentColor())
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

derma.DefineControl(
    "TTT2:DSubmenuButton",
    "A spin on TTT2's button that has some extra features for the submenu list",
    PANEL,
    "TTT2:DButton"
)
