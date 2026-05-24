---
-- @class PANEL
-- @section TTT2:DPanel/Box

---
-- @accessor boolean
-- @realm client
AccessorFunc(METAPANEL, "m_bPaintBackground", "PaintBackground", FORCE_BOOL)

---
-- @accessor Color
-- @realm client
AccessorFunc(METAPANEL, "m_cColor", "Color", FORCE_COLOR, true)

---
-- @accessor Color
-- @realm client
AccessorFunc(METAPANEL, "m_cOutlineColor", "OutlineColor", FORCE_COLOR, true)

---
-- @accessor number
-- @realm client
AccessorFunc(METAPANEL, "m_nColorShift", "ColorShift", FORCE_NUMBER, true)

---
-- @accessor number
-- @realm client
AccessorFunc(METAPANEL, "m_nOutlineColorShift", "OutlineColorShift", FORCE_NUMBER, true)

---
-- Enables a pulsating background flash color used to hightlight things. The
-- color is determined automatically by the panel color.
-- @param boolean state Set to true to enable pulsating background.
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:EnableFlashColor(state)
    self.m_bEnableFlashColor = state

    self:InvalidateLayout() -- rebuild in next frame

    return self
end

---
-- Checks whether the panel has background flash color enabled.
-- @return boolean Returns true if the flash color is enabled
-- @realm client
function METAPANEL:HasFlashColor()
    return self.m_bEnableFlashColor or false
end

---
-- Enables a corner radius. If set to false, the box is a normal rectange, if set to true, the
-- box has rounded corners.
-- @note Backgroun drawing has to be enabled.
-- @param boolean ... Set to true to enable corner radius, can be either 1 or 4 parameters
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:EnableCornerRadius(...)
    local state = { ... }

    if #state == 1 then
        self.m_bCornerRadiusTopLeft = state[1]
        self.m_bCornerRadiusTopRight = state[1]
        self.m_bCornerRadiusBottomLeft = state[1]
        self.m_bCornerRadiusBottomRight = state[1]
    elseif #state == 4 then
        self.m_bCornerRadiusTopLeft = state[1]
        self.m_bCornerRadiusTopRight = state[2]
        self.m_bCornerRadiusBottomLeft = state[3]
        self.m_bCornerRadiusBottomRight = state[4]
    else
        ErrorNoHaltWithStack(
            "[TTT2] PANEL:EnableCornerRadius expects 1 or 4 arguments, "
                .. tostring(#state)
                .. " were provided."
        )
    end

    self:InvalidateLayout() -- rebuild in next frame

    return self
end

---
-- Checks whether this panel has a simple (all corners are the same) corner radius enabled.
-- @return boolean Returns true if the corner radius is enabled
-- @realm client
function METAPANEL:HasCornerRadius()
    return self.m_bCornerRadiusTopLeft or false
end

---
-- Returns a list of all four corners and if they have a defined radius.
-- @return boolean Corner radius state for the top left corner
-- @return boolean Corner radius state for the top right corner
-- @return boolean Corner radius state for the bottom left corner
-- @return boolean Corner radius state for the bottom right corner
-- @realm client
function METAPANEL:GetCornerRadius()
    return self.m_bCornerRadiusTopLeft or false,
        self.m_bCornerRadiusTopRight or false,
        self.m_bCornerRadiusBottomLeft or false,
        self.m_bCornerRadiusBottomRight or false
end

---
-- Sets the outline thickness of a panel.
-- @note If one parameter is provided, this value is for all four sides. If two values
-- are provided, the first is for the vertival outlines, the second for the horizontal.
-- If four are provided they are set left, top, right, bottom.
-- @param number ... The outline thickness
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetOutline(...)
    local sizes = { ... }

    if #sizes == 0 then
        self.m_nOutlineLeft = nil
        self.m_nOutlineTop = nil
        self.m_nOutlineRight = nil
        self.m_nOutlineBottom = nil
    elseif #sizes == 1 then
        self.m_nOutlineLeft = sizes[1]
        self.m_nOutlineTop = sizes[1]
        self.m_nOutlineRight = sizes[1]
        self.m_nOutlineBottom = sizes[1]
    elseif #sizes == 2 then
        self.m_nOutlineLeft = sizes[1]
        self.m_nOutlineTop = sizes[2]
        self.m_nOutlineRight = sizes[1]
        self.m_nOutlineBottom = sizes[2]
    elseif #sizes == 4 then
        self.m_nOutlineLeft = sizes[1]
        self.m_nOutlineTop = sizes[2]
        self.m_nOutlineRight = sizes[3]
        self.m_nOutlineBottom = sizes[4]
    else
        ErrorNoHaltWithStack(
            "[TTT2] PANEL:SetOutline expects 1, 2 or 4 arguments, "
                .. tostring(#sizes)
                .. " were provided."
        )
    end

    self:InvalidateLayout() -- rebuild in next frame

    return self
end

---
-- Checks whether the panel has an outline applied.
-- @return boolean Returns true if the panel has an outline
-- @realm client
function METAPANEL:HasOutline()
    return self.m_nOutlineLeft ~= nil
end

---
-- Gets the outline ticknesses for all four sides.
-- @return number The left outline
-- @return number The top outline
-- @return number The right outline
-- @return number The bottom outline
-- @realm client
function METAPANEL:GetOutline()
    return self.m_nOutlineLeft, self.m_nOutlineTop, self.m_nOutlineRight, self.m_nOutlineBottom
end
