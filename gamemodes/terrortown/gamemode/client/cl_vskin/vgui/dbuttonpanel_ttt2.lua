-- @class PANEL
-- @section DButtonPanelTTT2

local PANEL = {}

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bBackground", "PaintBackground", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bIsMenuComponent", "IsMenu", FORCE_BOOL)

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bDisableTabbing", "TabbingDisabled", FORCE_BOOL)

---
-- @accessor Color
-- @realm client
AccessorFunc(PANEL, "m_bgColor", "BackgroundColor")

---
-- @accessor Panel
-- @realm client
Derma_Hook(PANEL, "Paint", "Paint", "Panel")

---
-- @accessor Panel
-- @realm client
Derma_Hook(PANEL, "ApplySchemeSettings", "Scheme", "Panel")

---
-- @accessor Panel
-- @realm client
Derma_Hook(PANEL, "PerformLayout", "Layout", "Panel")

---
-- @ignore
function PANEL:Init()
    self:SetPaintBackground(true)

    -- This turns off the engine drawing
    self:SetPaintBackgroundEnabled(false)
    self:SetPaintBorderEnabled(false)
end

---
-- @ignore
function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "ButtonPanelTTT2", self, w, h)

    return false
end

---
-- @param boolean bEnabled
-- @realm client
function PANEL:SetEnabled(bEnabled)
    self.m_bEnabled = not bEnabled

    if bEnabled then
        self:SetAlpha(255)
        self:SetMouseInputEnabled(true)
    else
        self:SetAlpha(75)
        self:SetMouseInputEnabled(false)
    end
end

---
-- @return boolean
-- @realm client
function PANEL:IsEnabled()
    return self.m_bEnabled
end

---
-- @param number mcode
-- @realm client
function PANEL:OnMousePressed(mcode)
    if self:IsSelectionCanvas() and not dragndrop.IsDragging() then
        self:StartBoxSelection()

        return
    end

    if self:IsDraggable() then
        self:MouseCapture(true)
        self:DragMousePress(mcode)
    end
end

---
-- @param number mcode
-- @realm client
function PANEL:OnMouseReleased(mcode)
    if self:EndBoxSelection() then
        return
    end

    self:MouseCapture(false)
end

---
-- overwrites the base function with an empty function
-- @realm client
function PANEL:UpdateColours() end

derma.DefineControl("DButtonPanelTTT2", "", PANEL, "DPanelTTT2")
