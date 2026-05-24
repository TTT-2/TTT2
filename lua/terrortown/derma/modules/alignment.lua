---
-- @class PANEL
-- @section TTT2:DPanel/Alignment

---
-- @accessor number
-- @realm client
AccessorFunc(METAPANEL, "m_nVerticalTextAlign", "VerticalTextAlign", FORCE_NUMBER, true)

---
-- @accessor number
-- @realm client
AccessorFunc(METAPANEL, "m_nHorizontalTextAlign", "HorizontalTextAlign", FORCE_NUMBER, true)

---
-- @accessor boolean
-- @realm client
AccessorFunc(METAPANEL, "m_bVerticalAlignment", "VerticalAlignment", FORCE_BOOL_HAS, true)

---
-- Sets the padding of a panel.
-- @note If one parameter is provided, this value is for all four sides. If two values
-- are provided, the first is for the vertival padding, the second for the horizontal.
-- If four are provided they are set left, top, right, bottom.
-- @param number ... The padding
-- @return Panel Returns the panel itself
-- @realm client
function METAPANEL:SetPadding(...)
    local padding = { ... }

    if #padding == 0 then
        self.m_nPaddingLeft = nil
        self.m_nPaddingTop = nil
        self.m_nPaddingRight = nil
        self.m_nPaddingBottom = nil
    elseif #padding == 1 then
        self.m_nPaddingLeft = padding[1]
        self.m_nPaddingTop = padding[1]
        self.m_nPaddingRight = padding[1]
        self.m_nPaddingBottom = padding[1]
    elseif #padding == 2 then
        self.m_nPaddingLeft = padding[1]
        self.m_nPaddingTop = padding[2]
        self.m_nPaddingRight = padding[1]
        self.m_nPaddingBottom = padding[2]
    elseif #padding == 4 then
        self.m_nPaddingLeft = padding[1]
        self.m_nPaddingTop = padding[2]
        self.m_nPaddingRight = padding[3]
        self.m_nPaddingBottom = padding[4]
    else
        ErrorNoHaltWithStack(
            "[TTT2] PANEL:SetPadding expects 1, 2 or 4 arguments, "
                .. tostring(#padding)
                .. " were provided."
        )
    end

    self:InvalidateLayout() -- rebuild in next frame

    return self
end

---
-- Gets the padding for all four sides.
-- @return number Left padding
-- @return number Top padding
-- @return number Right padding
-- @return number Bottom padding
-- @realm client
function METAPANEL:GetPadding()
    return self.m_nPaddingLeft or 0,
        self.m_nPaddingTop or 0,
        self.m_nPaddingRight or 0,
        self.m_nPaddingBottom or 0
end
