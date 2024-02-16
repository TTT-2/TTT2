---
-- @class PANEL
-- @desc why can't the default label scroll? welcome to gmod
-- @section ScrollLabel

PANEL = {}

local timer = timer
local IsValid = IsValid
local vgui = vgui

---
-- @ignore
function PANEL:Init()
    self.Label = vgui.Create("DLabel", self)
    self.Label:SetPos(0, 0)

    self.Scroll = vgui.Create("DVScrollBar", self)
end

---
-- @return string
-- @realm client
function PANEL:GetLabel()
    return self.Label
end

---
-- @param number dlta
-- @realm client
function PANEL:OnMouseWheeled(dlta)
    if not self.Scroll then
        return
    end

    self.Scroll:AddScroll(dlta * -2)

    self:InvalidateLayout()
end

---
-- @param boolean st
-- @realm client
function PANEL:SetScrollEnabled(st)
    self.Scroll:SetEnabled(st)
end

---
-- enable/disable scrollbar depending on content size
-- @realm client
function PANEL:UpdateScrollState()
    if not self.Scroll then
        return
    end

    self.Scroll:SetScroll(0)
    self:SetScrollEnabled(false)

    self.Label:SetSize(self:GetWide(), self:GetTall())
    self.Label:SizeToContentsY()

    self:SetScrollEnabled(self.Label:GetTall() > self:GetTall())

    self.Label:InvalidateLayout(true)
    self:InvalidateLayout(true)
end

---
-- @param string txt
-- @realm client
function PANEL:SetText(txt)
    if not self.Label then
        return
    end

    self.Label:SetText(txt)
    self:UpdateScrollState()

    -- I give up. VGUI, you have won. Here is your ugly hack to make the label
    -- resize to the proper height, after you have completely mangled it the
    -- first time I call SizeToContents. I don't know how or what happens to the
    -- Label's internal state that makes it work when resizing a second time a
    -- tick later (it certainly isn't any variant of PerformLayout I can find),
    -- but it does.
    local pnl = self.Panel

    timer.Simple(0, function()
        if IsValid(pnl) then
            pnl:UpdateScrollState()
        end
    end)
end

---
-- @ignore
function PANEL:PerformLayout()
    if not self.Scroll then
        return
    end

    self.Label:SetVisible(self:IsVisible())

    self.Scroll:SetPos(self:GetWide() - 16, 0)
    self.Scroll:SetSize(16, self:GetTall())

    local was_on = self.Scroll.Enabled

    self.Scroll:SetUp(self:GetTall(), self.Label:GetTall())
    self.Scroll:SetEnabled(was_on) -- setup mangles enabled state

    self.Label:SetPos(0, self.Scroll:GetOffset())
    self.Label:SetSize(self:GetWide() - (self.Scroll.Enabled and 16 or 0), self.Label:GetTall())
end

vgui.Register("ScrollLabel", PANEL, "Panel")
