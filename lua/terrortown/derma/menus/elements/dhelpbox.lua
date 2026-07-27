---
-- @class PANEL
-- @section TTT2:DHelpbox

DPANEL.derma = {
    className = "TTT2:DHelpbox",
    description = "The helpbox with wordwrap that is used in menus",
    baseClassName = "TTT2:DPanel",
}

---
-- @ignore
function DPANEL:Init()
    self:SetTextAlign(TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    self:SetPadding(10, 5)
    self:SetOutline(4, 0, 0, 0)
    self:SetFitToContentY(true)
end

---
-- @ignore
function DPANEL:OnVSkinUpdate()
    local colorBackground = util.GetChangedColor(vskin.GetBackgroundColor(), 20)
    local colorText = util.GetChangedColor(util.GetDefaultColor(colorBackground), 40)
    local colorOutline = util.GetChangedColor(vskin.GetBackgroundColor(), 80)

    if not self:IsEnabled() then
        colorBackground = ColorAlpha(colorBackground, 100)
        colorText = ColorAlpha(colorText, 50)
        colorOutline = ColorAlpha(colorOutline, 100)
    end

    self:ApplyVSkinColor("background", colorBackground)
    self:ApplyVSkinColor("text", colorText)
    self:ApplyVSkinColor("description", colorText)
    self:ApplyVSkinColor("icon", colorText)
    self:ApplyVSkinColor("outline", colorOutline)
    self:ApplyVSkinColor("flash", colorText)
end
