---
-- @class PANEL
-- @section ColoredBox

local PANEL = {}

local surface = surface

---
-- @accessor boolean
-- @realm client
AccessorFunc(PANEL, "m_bBorder", "Border")

---
-- @accessor Color
-- @realm client
AccessorFunc(PANEL, "m_Color", "Color")

--- @ignore
function PANEL:Init()
    self:SetBorder(true)
    self:SetColor(Color(0, 255, 0, 255))
end

--- @ignore
function PANEL:Paint()
    surface.SetDrawColor(self.m_Color.r, self.m_Color.g, self.m_Color.b, 255)

    self:DrawFilledRect()
end

--- @ignore
function PANEL:PaintOver()
    if not self.m_bBorder then
        return
    end

    surface.SetDrawColor(0, 0, 0, 255)

    self:DrawOutlinedRect()
end

derma.DefineControl("ColoredBox", "", PANEL, "DPanel")
