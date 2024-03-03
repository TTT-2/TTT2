---
-- @class PANEL
-- @section DPanelTTT2

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
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bDisabled", "Disabled")

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

    self.tooltip = {
        fixedPosition = nil,
        fixedSize = nil,
        delay = 0,
        text = "",
        font = "DermaTTT2Text",
        sizeArrow = 8,
    }

    local oldSetTooltipPanel = self.SetTooltipPanel

    self.SetTooltipPanel = function(slf, panel)
        slf:SetTooltipPanelOverride("DTooltipTTT2")

        oldSetTooltipPanel(slf, panel)
    end
end

---
-- @param boolean bDisabled
-- @realm client
function PANEL:SetDisabled(bDisabled)
    self.m_bDisabled = bDisabled

    if bDisabled then
        self:SetAlpha(75)
        self:SetMouseInputEnabled(false)
    else
        self:SetAlpha(255)
        self:SetMouseInputEnabled(true)
    end
end

---
-- @param boolean bEnabled
-- @realm client
function PANEL:SetEnabled(bEnabled)
    self:SetDisabled(not bEnabled)
end

---
-- @return boolean
-- @realm client
function PANEL:IsEnabled()
    return not self:GetDisabled()
end

---
-- @param number mousecode
-- @realm client
function PANEL:OnMousePressed(mousecode)
    if self:IsSelectionCanvas() and not dragndrop.IsDragging() then
        self:StartBoxSelection()

        return
    end

    if self:IsDraggable() then
        self:MouseCapture(true)
        self:DragMousePress(mousecode)
    end
end

---
-- @param number mousecode
-- @realm client
function PANEL:OnMouseReleased(mousecode)
    if self:EndBoxSelection() then
        return
    end

    self:MouseCapture(false)

    if self:DragMouseRelease(mousecode) then
        return
    end
end

---
-- @realm client
function PANEL:UpdateColours() end

---
-- @param number x
-- @param number y
-- @realm client
function PANEL:SetTooltipFixedPosition(x, y)
    self.tooltip.fixedPosition = {
        x = x,
        y = y,
    }
end

---
-- @return number, number
-- @realm client
function PANEL:GetTooltipFixedPosition()
    return self.tooltip.fixedPosition.x, self.tooltip.fixedPosition.y
end

---
-- @return boolean
-- @realm client
function PANEL:HasTooltipFixedPosition()
    return self.tooltip.fixedPosition ~= nil
end

---
-- @param number w
-- @param number h
-- @realm client
function PANEL:SetTooltipFixedSize(w, h)
    -- +2 are the outline pixels
    self.tooltip.fixedSize = {
        w = w + 2,
        h = h + self.tooltip.sizeArrow + 2,
    }
end

---
-- @return number, number
-- @realm client
function PANEL:GetTooltipFixedSize()
    return self.tooltip.fixedSize.w, self.tooltip.fixedSize.h
end

---
-- @realm client
function PANEL:HasTooltipFixedSize()
    return self.tooltip.fixedSize ~= nil
end

---
-- @param number delay
-- @realm client
function PANEL:SetTooltipOpeningDelay(delay)
    self.tooltip.delay = delay
end

---
-- @return number
-- @realm client
function PANEL:GetTooltipOpeningDelay()
    return self.tooltip.delay
end

---
-- @param string text
-- @realm client
function PANEL:SetTooltip(text)
    self:SetTooltipPanelOverride("DTooltipTTT2")

    self.tooltip.text = text
end

---
-- @return string
-- @realm client
function PANEL:GetTooltipText()
    return self.tooltip.text
end

---
-- @return boolean
-- @realm client
function PANEL:HasTooltipText()
    return self.tooltip.text ~= nil and self.tooltip.text ~= ""
end

---
-- @param string font
-- @realm client
function PANEL:SetTooltipFont(font)
    self.tooltip.font = font
end

---
-- @return string
-- @realm client
function PANEL:GetTooltipFont()
    return self.tooltip.font
end

---
-- @param Panel master
-- @realm client
function PANEL:SetMaster(master)
    if not IsValid(master) then
        return
    end

    self.master = master
end

---
-- @return number
-- @realm client
function PANEL:GetIndentationMargin()
    if not IsValid(self.master) then
        return 0
    end

    return 10 + self.master:GetIndentationMargin()
end

derma.DefineControl("DPanelTTT2", "", PANEL, "Panel")
