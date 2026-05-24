---
-- @class PANEL
-- @section TTT2:DSearchBar

DPANEL.derma = {
    className = "TTT2:DSearchBar",
    description = "The searchbar for TTT2 menus",
    baseClassName = "TTT2:DTextEntry",
}

---
-- @ignore
function DPANEL:Init()
    self:SetFont("DermaTTT2Text")
    self:SetPlaceholderText("searchbar_default_placeholder")

    self:EnableCornerRadius(false)
    self:SetOutline(0, 0, 0, vskin.GetBorderSize())
end

---
-- @ignore
function DPANEL:OnVSkinUpdate()
    local colorBackground, colorText, colorOutline

    -- PANEL DISABLED
    if not self:IsEnabled() then
        local colorDefault = util.GetDefaultColor(vskin.GetBackgroundColor())
        local colorAccentDisabled = util.GetChangedColor(colorDefault, 150)

        colorBackground = util.GetChangedColor(colorAccentDisabled, 120)
        colorText = ColorAlpha(util.GetDefaultColor(colorAccentDisabled), 220)
        colorOutline = util.ColorDarken(colorAccentDisabled, 50)

    -- PANEL IS HOVERED or PRESSED
    elseif self:IsHovered() or self:IsDepressed() or self:IsSelected() or self:IsFocused() then
        colorBackground = util.GetHoverColor(
            self:GetColor() or util.GetChangedColor(vskin.GetBackgroundColor(), 15)
        )
        colorText = util.GetChangedColor(util.GetDefaultColor(colorBackground), 80)
        colorOutline = self:GetOutlineColor() or util.GetHoverColor(vskin.GetAccentColor())

    -- NORMAL COLORS
    else
        colorBackground = self:GetColor() or util.GetChangedColor(vskin.GetBackgroundColor(), 20)
        colorText = util.GetChangedColor(util.GetDefaultColor(colorBackground), 75)
        colorOutline = self:GetOutlineColor() or vskin.GetAccentColor()
    end

    local textTyped = util.GetChangedColor(util.GetDefaultColor(colorBackground), 35)

    self:ApplyVSkinColor("background", colorBackground)
    self:ApplyVSkinColor("text", colorText)
    self:ApplyVSkinColor("description", colorText)
    self:ApplyVSkinColor("icon", colorText)
    self:ApplyVSkinColor("outline", colorOutline)
    self:ApplyVSkinColor("flash", colorText)

    self:ApplyVSkinColor("text_typed", textTyped)
    self:ApplyVSkinColor("text_suggestion", ColorAlpha(textTyped, 120))
    self:ApplyVSkinColor("text_selection", vskin.GetAccentColor())
end
