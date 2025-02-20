---
-- @class PANEL
-- @section TTT2:DPanel/Tooltip

---
-- @param string text
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetTooltip(text)
    if text then
        self:SetTooltipPanelOverride("TTT2:DTooltip")
    end

    self._tooltip.text = text

    return self
end

-- TODO review this - do we actually need this? what of this code is needed? looks strange.
-- @param Panel panel The panel that should be attached
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetTooltipPanel(panel)
    if panel then
        self:SetTooltipPanelOverride("TTT2:DTooltip")
    end

    -- original code before the overwrite
    self.pnlTooltipPanel = panel

    if IsValid(panel) then
        panel:SetVisible(false)
    end

    return self
end

---
-- @param number x
-- @param number y
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetTooltipFixedPosition(x, y)
    self._tooltip.fixedPosition = {
        x = x,
        y = y,
    }

    return self
end

---
-- @return number, number
-- @realm client
function METAPANEL:GetTooltipFixedPosition()
    return self._tooltip.fixedPosition.x, self._tooltip.fixedPosition.y
end

---
-- @return boolean
-- @realm client
function METAPANEL:HasTooltipFixedPosition()
    return self._tooltip.fixedPosition ~= nil
end

---
-- @param number w
-- @param number h
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetTooltipFixedSize(w, h)
    -- +2 are the outline pixels
    self._tooltip.fixedSize = {
        w = (w or 0) + 2,
        h = (h or 0) + (self._tooltip.sizeArrow or 0) + 2,
    }

    return self
end

---
-- @return number, number
-- @realm client
function METAPANEL:GetTooltipFixedSize()
    return self._tooltip.fixedSize.w, self._tooltip.fixedSize.h
end

---
-- @realm client
function METAPANEL:HasTooltipFixedSize()
    return self._tooltip.fixedSize ~= nil
end

---
-- @param number delay
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetTooltipOpeningDelay(delay)
    self._tooltip.delay = delay

    return self
end

---
-- @return number
-- @realm client
function METAPANEL:GetTooltipOpeningDelay()
    return self._tooltip.delay
end

---
-- Sets the site of the tooltip arrow.
-- @param number size The size in pixels
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetTooltipArrowSize(size)
    self._tooltip.delay = sizeArrow

    return self
end

---
-- Returns the size of the tooltip arrow.
-- @return number
-- @realm client
function METAPANEL:GetTooltipArrowSize()
    return self._tooltip.sizeArrow
end

---
-- Returns the tooltip text.
-- @return string The tooltip text
-- @realm client
function METAPANEL:GetTooltipText()
    return self._tooltip.text
end

---
-- Checks whether the tooltip has any text set.
-- @return boolean Returns true if a non-empty string is sest
-- @realm client
function METAPANEL:HasTooltipText()
    return self._tooltip.text ~= nil and self._tooltip.text ~= ""
end

---
-- Sets the font of the tooltip if the tooltip is a single text.
-- @param string font The font name
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetTooltipFont(font)
    self._tooltip.font = font

    return self
end

---
-- Gets the font of the tooltip if the tooltip is a single text.
-- @return string The font name
-- @realm client
function METAPANEL:GetTooltipFont()
    return self._tooltip.font
end
