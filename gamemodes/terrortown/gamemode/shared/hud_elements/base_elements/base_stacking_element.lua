---
-- @module HUDELEMENT
-- @section base_stacking_element

local base = "dynamic_hud_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

HUDELEMENT.elements = {}
HUDELEMENT.element_margin = 0
HUDELEMENT.lastCount = 0

---
-- Draws the @{HUDELEMENT}
-- @internal
-- @realm client
function HUDELEMENT:Draw()
    --set size beforehand if #elements was reduced to remove flickering
    if #self.elements < self.lastCount then
        local height = 0
        for k, el in ipairs(self.elements) do
            height = height + el.h + self.element_margin
        end

        self:SetSize(self.size.w, -height)
    end

    --draw all elements
    local running_y = self.pos.y

    for k, el in ipairs(self.elements) do
        self:DrawElement(k, self.pos.x, running_y, self.size.w, el.h)

        running_y = running_y + el.h + self.element_margin
    end

    local totalHeight = running_y - self.pos.y

    self.lastCount = #self.elements
    self:SetSize(self.size.w, - math.max(totalHeight, self.minsize.h))
end

---
-- Override this function to determine how your element i will be drawn, given a position and size
-- @param HUDELEMENT i
-- @param number x
-- @param number y
-- @param number w
-- @param number h
-- @hook
-- @realm client
function HUDELEMENT:DrawElement(i, x, y, w, h)

end

---
-- Pass a list of elements, which should be drawn. Each element needs a height h.
-- @param table elements list of @{HUDELEMENT}
-- @realm client
function HUDELEMENT:SetElements(elements)
    self.elements = elements
end

---
-- Sets the margin between the elements
-- @param number margin
-- @realm client
function HUDELEMENT:SetElementMargin(margin)
    self.element_margin = margin
end
