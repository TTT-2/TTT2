---
-- @class PANEL
-- @section DVScrollBarTTT2

local PANEL = {}

---
-- @ignore
function PANEL:Init()
    self.offset = 0
    self.scroll = 0
    self.canvasSize = 1
    self.barSize = 1

    self.btnGrip = vgui.Create("DScrollBarGrip", self)

    self:SetSize(15, 15)
end

---
-- @param boolean b
-- @realm client
function PANEL:SetEnabled(b)
    if not b then
        self.offset = 0
        self:SetScroll(0)
        self.hasChanged = true
    end

    self:SetMouseInputEnabled(b)
    self:SetVisible(b)

    if self.enabled ~= b then
        self:GetParent():InvalidateLayout()

        if self:GetParent().OnScrollbarAppear then
            self:GetParent():OnScrollbarAppear()
        end
    end

    self.enabled = b
end

---
-- @return number
-- @realm client
function PANEL:Value()
    return self.Pos
end

---
-- @return[default=1] number
-- @realm client
function PANEL:BarScale()
    if self.barSize == 0 then
        return 1
    end

    return self.barSize / (self.canvasSize + self.barSize)
end

---
-- @param number barSize
-- @param number canvasSize
-- @realm client
function PANEL:SetUp(barSize, canvasSize)
    self.barSize = barSize
    self.canvasSize = math.max(canvasSize - barSize, 1)

    self:SetEnabled(canvasSize > barSize)

    self:InvalidateLayout()
end

---
-- @param number dlta
-- @return boolean
-- @realm client
function PANEL:OnMouseWheeled(dlta)
    if not self:IsVisible() then
        return false
    end

    return self:AddScroll(dlta * -2)
end

---
-- @param number dlta
-- @return boolean
-- @realm client
function PANEL:AddScroll(dlta)
    local oldScroll = self:GetScroll()

    dlta = dlta * 25

    self:SetScroll(self:GetScroll() + dlta)

    return oldScroll ~= self:GetScroll()
end

---
-- @param number scrll
-- @realm client
function PANEL:SetScroll(scrll)
    if not self.enabled then
        self.scroll = 0

        return
    end

    self.scroll = math.Clamp(scrll, 0, self.canvasSize)

    self:InvalidateLayout()

    local parent = self:GetParent()

    if isfunction(parent.OnVScroll) then
        parent:OnVScroll(self:GetOffset())
    else
        parent:InvalidateLayout()
    end
end

---
-- @param number scrll
-- @param number length
-- @param number delay
-- @param number ease
-- @realm client
function PANEL:AnimateTo(scrll, length, delay, ease)
    local anim = self:NewAnimation(length, delay, ease)

    anim.startPos = self.scroll
    anim.targetPos = scrll

    anim.Think = function(_, pnl, fraction)
        pnl:SetScroll(Lerp(fraction, anim.startPos, anim.targetPos))
    end
end

---
-- @return[default=0] number
-- @realm client
function PANEL:GetScroll()
    if not self.enabled then
        self.scroll = 0
    end

    return self.scroll
end

---
-- @return[default=0] number
-- @realm client
function PANEL:GetOffset()
    if not self.enabled then
        return 0
    end

    return self.scroll * -1
end

---
-- @ignore
function PANEL:Think() end

---
-- @ignore
function PANEL:Paint(w, h) end

---
-- @realm client
function PANEL:OnMousePressed()
    local _, y = self:CursorPos()

    local pageSize = self.barSize

    if y > self.btnGrip.y then
        self:SetScroll(self:GetScroll() + pageSize)
    else
        self:SetScroll(self:GetScroll() - pageSize)
    end
end

---
-- @realm client
function PANEL:OnMouseReleased()
    self.dragging = false
    self.draggingCanvas = nil
    self:MouseCapture(false)

    self.btnGrip.Depressed = false
    self.btnGrip.Hovered = false
end

---
-- @realm client
function PANEL:OnCursorMoved()
    if not self.enabled or not self.dragging then
        return
    end

    local _, y = self:ScreenToLocal(0, gui.MouseY())

    y = (y - self.holdPos) / (self:GetTall() - self.btnGrip:GetTall())

    self:SetScroll(y * self.canvasSize)
end

---
-- @realm client
function PANEL:Grip()
    if not self.enabled or self.barSize == 0 then
        return
    end

    self:MouseCapture(true)
    self.dragging = true

    local _, y = self.btnGrip:ScreenToLocal(0, gui.MouseY())

    self.holdPos = y

    self.btnGrip.Depressed = true
end

---
-- @ignore
function PANEL:PerformLayout()
    local wide = self:GetWide()

    local barSize = math.max(self:BarScale() * self:GetTall(), 10)
    local track = self:GetTall() - barSize + 1
    local scroll = self:GetScroll() / self.canvasSize * track

    self.btnGrip:SetPos(0, scroll)
    self.btnGrip:SetSize(wide, barSize)
end

derma.DefineControl("DVScrollBarTTT2", "A Scrollbar", PANEL, "Panel")
