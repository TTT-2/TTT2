---
-- @class PANEL
-- @section TTT2:DHelpbox

local PANEL = {}

---
-- @ignore
function PANEL:Init()
    self:BaseClass().Init(self)

    self:SetTextAlign(TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    self:SetPadding(10, 5)
    self:SetBorder(4, 0, 0, 0)
    self:FitToContentY(true)
end

---
-- @ignore
function PANEL:OnVSkinUpdate()
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

derma.DefineControl(
    "TTT2:DHelpbox",
    "The basic Panel everything in TTT2 is based on",
    PANEL,
    "TTT2:DPanel"
)
