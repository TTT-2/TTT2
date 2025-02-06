---
-- @class PANEL
-- @section TTT2:DMainMenuButton

local PANEL = {}

---
-- @ignore
function PANEL:Init()
    DBase("TTT2:DButton").Init(self)

    self:SetFont("DermaTTT2MenuButtonTitle")
    self:SetDescriptionFont("DermaTTT2MenuButtonDescription")
    self:SetOutline(1)
    self:SetPadding(15)
    self:SetTextAlign(TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

---
-- @ignore
function PANEL:OnVSkinUpdate()
    local colorBackground, colorText, colorDescription, colorIcon, colorOutline

    -- PANEL DISABLED
    -- (not implemented for now)

    -- PANEL IS PRESSED or PANEL IS HOVERED
    if self:IsDepressed() or self:IsSelected() or self:GetToggle() or self:IsHovered() then
        colorBackground = self:GetColor() or vskin.GetBackgroundColor()
        colorText = util.GetChangedColor(util.GetDefaultColor(colorBackground), 50)
        colorDescription = util.GetChangedColor(util.GetDefaultColor(colorBackground), 135)
        colorIcon = util.GetChangedColor(util.GetDefaultColor(colorBackground), 160)
        colorOutline = util.GetChangedColor(
            util.GetDefaultColor(self:GetOutlineColor() or colorBackground),
            135
        )

    -- NORMAL COLORS
    else
        colorBackground = self:GetColor() or vskin.GetBackgroundColor()
        colorText = util.GetChangedColor(util.GetDefaultColor(colorBackground), 65)
        colorDescription = util.GetChangedColor(util.GetDefaultColor(colorBackground), 145)
        colorIcon = util.GetChangedColor(util.GetDefaultColor(colorBackground), 170)
        colorOutline = util.GetChangedColor(
            util.GetDefaultColor(self:GetOutlineColor() or colorBackground),
            170
        )
    end

    self:ApplyVSkinColor("background", colorBackground)
    self:ApplyVSkinColor("text", colorText)
    self:ApplyVSkinColor("description", colorDescription)
    self:ApplyVSkinColor("icon", colorIcon)
    self:ApplyVSkinColor("outline", colorOutline)
    self:ApplyVSkinColor("flash", colorText)
end

derma.DefineControl(
    "TTT2:DMainMenuButton",
    "The button made for the main menu",
    PANEL,
    "TTT2:DButton"
)
