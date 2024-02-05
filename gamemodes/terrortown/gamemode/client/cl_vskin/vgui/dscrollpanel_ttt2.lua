---
-- @class PANEL
-- @section DScrollPanelTTT2

local PANEL = {}

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "Padding", "Padding")

---
-- @accessor Panel
-- @realm client
AccessorFunc(PANEL, "pnlCanvas", "Canvas")

---
-- @ignore
function PANEL:Init()
    self.pnlCanvas = vgui.Create("Panel", self)

    self.pnlCanvas.OnMousePressed = function(slf, code)
        slf:GetParent():OnMousePressed(code)
    end

    self.pnlCanvas:SetMouseInputEnabled(true)

    self.pnlCanvas.PerformLayout = function(pnl)
        self:PerformLayoutInternal()
        self:InvalidateParent()
    end

    -- Create the scroll bar
    self.vBar = vgui.Create("DVScrollBarTTT2", self)
    self.vBar:Dock(RIGHT)

    self:SetPadding(0)
    self:SetMouseInputEnabled(true)

    -- This turns off the engine drawing
    self:SetPaintBackgroundEnabled(false)
    self:SetPaintBorderEnabled(false)
    self:SetPaintBackground(false)
end

---
-- @param Panel pnl
-- @realm client
function PANEL:AddItem(pnl)
    pnl:SetParent(self:GetCanvas())
end

---
-- @param Panel child
-- @realm client
function PANEL:OnChildAdded(child)
    self:AddItem(child)
end

---
-- @ignore
function PANEL:SizeToContents()
    self:SetSize(self.pnlCanvas:GetSize())
end

---
-- @return Panel
-- @realm client
function PANEL:GetVBar()
    return self.vBar
end

---
-- @return number
-- @realm client
function PANEL:InnerWidth()
    return self:GetCanvas():GetWide()
end

---
-- @realm client
function PANEL:Rebuild()
    self:GetCanvas():SizeToChildren(false, true)

    if self.m_bNoSizing and self:GetCanvas():GetTall() < self:GetTall() then
        self:GetCanvas():SetPos(0, (self:GetTall() - self:GetCanvas():GetTall()) * 0.5)
    end
end

---
-- @param number dlta
-- @return any
-- @realm client
function PANEL:OnMouseWheeled(dlta)
    return self.vBar:OnMouseWheeled(dlta)
end

---
-- @param number iOffset
-- @realm client
function PANEL:OnVScroll(iOffset)
    self.pnlCanvas:SetPos(0, iOffset)
end

---
-- @param Panel panel
-- @realm client
function PANEL:ScrollToChild(panel)
    self:InvalidateLayout(true)

    local _, y = self.pnlCanvas:GetChildPosition(panel)
    local _, h = panel:GetSize()

    y = y + h * 0.5
    y = y - self:GetTall() * 0.5

    self.vBar:AnimateTo(y, 0.5, 0, 0.5)
end

---
-- @ignore
function PANEL:PerformLayoutInternal()
    local tall = self.pnlCanvas:GetTall()
    local wide = self:GetWide()
    local yPos = 0

    self:Rebuild()

    self.vBar:SetUp(self:GetTall(), self.pnlCanvas:GetTall())

    yPos = self.vBar:GetOffset()

    if self.vBar.enabled then
        wide = wide - self.vBar:GetWide()
    end

    self.pnlCanvas:SetPos(0, yPos)
    self.pnlCanvas:SetWide(wide)

    self:Rebuild()

    if tall ~= self.pnlCanvas:GetTall() then
        self.vBar:SetScroll(self.vBar:GetScroll())
    end
end

---
-- @ignore
function PANEL:PerformLayout()
    self:PerformLayoutInternal()
end

---
-- @return boolean
-- @realm client
function PANEL:Clear()
    return self.pnlCanvas:Clear()
end

derma.DefineControl("DScrollPanelTTT2", "", PANEL, "DPanelTTT2")
