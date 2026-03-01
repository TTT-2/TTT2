---
-- @class PANEL
-- @section TTT2:DLabel

-- HOOKS ATTACHABLE WITH ON FOR TTT2:DLABEL:
-- engine:
--   Think
--   CursorEntered
--   CursorExited
-- custom:
--   OnDepressed(mouseCode)
--   OnReleased(mouseCode)
--   OnToggled(mouseCode)
--   OnLeftClick
--   OnLeftClickInternal
--   OnRightClick
--   OnMiddleClick
--   OnDoubleClick
--   OnDoubleClickInternal
--   OnVSkinUpdate
--   OnTranslationUpdate
--   OnRebuildLayout
--   VSkinColorPostProcess

---
-- @accessor boolean
-- @realm client
AccessorFunc(DPANEL, "m_bIsMenuComponent", "IsMenu", FORCE_BOOL) -- ??? needed in TTT2:DComboBox?

DPANEL.derma = {
    className = "TTT2:DLabel",
    description = "The basic Label everything in TTT2 is based on",
    baseClassName = "Label",
}

DPANEL.implements = {
    -- core elements contain method chaining, paint hooks and ttt2 dlabel core features
    "core",
    -- box, as the name implies, contains the background box and its outline
    "box",
    -- text has everything related to text and description
    "text",
    -- icon handles the addition of icons
    "icon",
    -- text, description and icon can have different alignments, this is set in this module
    "alignment",
    -- dynamic things contain coloring, translating, rescaling to fit contents and automatic positioning of text/icons
    "dynamic",
    -- functions related to tooltips
    "tooltip",
}

-- @ignore
function DPANEL:Init()
    -- disable toggling and set state to false
    self:SetIsToggle(false)
    self:SetToggle(false)

    -- set visual defaults
    self:SetPaintBackground(true)
    self:SetTall(20)
    self:SetFont("DermaTTT2Text")
    self:SetDescriptionFont("DermaTTT2Text")
    self:SetTextAlign(TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    self:SetVerticalAlignment(false)
    self:SetPadding(8)

    -- set the defaults for the tooltip
    self:SetTooltipFixedPosition(nil)
    self:SetTooltipFixedSize(nil)
    self:SetTooltipOpeningDelay(0)
    self:SetTooltipFont("DermaTTT2Text")
    self:SetTooltipArrowSize(8)
end

-- @ignore
function DPANEL:OnVSkinUpdate()
    local colorBackground = self:GetColor()
        or self:GetParentVSkinColor()
        or vskin.GetBackgroundColor()
    local colorText = util.GetDefaultColor(colorBackground)
    local colorOutline = self:GetOutlineColor() or colorText

    self:ApplyVSkinColor("background", colorBackground)
    self:ApplyVSkinColor("text", colorText)
    self:ApplyVSkinColor("description", colorText)
    self:ApplyVSkinColor("icon", colorText)
    self:ApplyVSkinColor("outline", colorOutline)
    self:ApplyVSkinColor("flash", colorText)
end
