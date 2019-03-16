local base = "dynamic_hud_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

HUDELEMENT.elements = {}
HUDELEMENT.element_margin = 0

function HUDELEMENT:Draw()
    local running_y = self.pos.y

    for k, el in ipairs(self.elements) do
        self:DrawElement(k, self.pos.x, running_y, self.size.w, el.h)
        running_y = running_y + el.h + self.element_margin
    end

    local totalHeight = running_y - self.pos.y
    self:SetSize(self.size.w, -totalHeight)
end

--[[----------------------------------------------------------------------------
	Name: DrawElement(number i, number x, number y, number w, number h)
	Desc: Override this function to determine how your element i will be drawn,
          given a position and size
--]]-----------------------------------------------------------------------------
function HUDELEMENT:DrawElement(i, x, y, w, h)

end

--[[----------------------------------------------------------------------------
	Name: SetElements(table elements)
	Desc: Pass a list of elements, which should be drawn. Each element needs
          a height h.
--]]-----------------------------------------------------------------------------
function HUDELEMENT:SetElements(elements)
    self.elements = elements
end

--[[----------------------------------------------------------------------------
	Name: SetElementMargin(number margin)
	Desc: Sets the margin between the elements
--]]-----------------------------------------------------------------------------
function HUDELEMENT:SetElementMargin(margin)
    self.element_margin = margin
end
