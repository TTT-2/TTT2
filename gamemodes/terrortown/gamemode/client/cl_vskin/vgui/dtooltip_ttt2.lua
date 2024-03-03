---
-- @class PANEL
-- @section DTooltipTTT2

local PANEL = {}

---
-- @ignore
function PANEL:Init()
    self:SetText("")
    self:SetDrawOnTop(true)

    self.deleteContentsOnClose = false
end

---
-- @param table skin
-- @return Color
-- @realm client
function PANEL:UpdateColours(skin)
    return self:SetTextStyleColor(skin.Colours.TooltipText)
end

---
-- @param Panel panel
-- @param boolean bDelete
-- @realm client
function PANEL:SetContents(panel, bDelete)
    panel:SetParent(self)

    self.contents = panel
    self.deleteContentsOnClose = bDelete or false
    self.contents:SizeToContents()
    self:InvalidateLayout(true)

    self.contents:SetVisible(false)
end

---
-- @ignore
function PANEL:PerformLayout()
    if not IsValid(self.targetPanel) then
        return
    end

    if self.targetPanel:HasTooltipFixedSize() then
        self:SetSize(self.targetPanel:GetTooltipFixedSize())
    elseif IsValid(self.contents) then
        self:SetWide(self.contents:GetWide() + 8)
        self:SetTall(self.contents:GetTall() + 8)
    else
        local w, h = draw.GetTextSize(LANG.TryTranslation(self:GetText()), self:GetFont())

        self:SetSize(w + 20, h + 8 + self.targetPanel.tooltip.sizeArrow)
    end

    if IsValid(self.contents) then
        self.contents:SetPos(1, self.targetPanel.tooltip.sizeArrow + 1)
        self.contents:SetVisible(true)
    end
end

---
-- @return number
-- @realm client
function PANEL:GetArrowSize()
    if not self.targetPanel.tooltip then
        return 0
    end

    return self.targetPanel.tooltip.sizeArrow
end

---
-- @realm client
function PANEL:PositionTooltip()
    if not IsValid(self.targetPanel) then
        self:Close()

        return
    end

    self:InvalidateLayout(true)

    local x, y

    if self.targetPanel:HasTooltipFixedPosition() then
        x, y = self.targetPanel:GetTooltipFixedPosition()
        parentX, parentY = self.targetPanel:GetParent():LocalToScreen(self.targetPanel:GetPos())

        x = x + parentX
        y = y + parentY
    else
        x, y = input.GetCursorPos()

        x = x + 10
        y = y + 20
    end

    self:SetPos(x, y)
end

---
-- @param number w
-- @param number h
-- @realm client
function PANEL:Paint(w, h)
    self:PositionTooltip()

    derma.SkinHook("Paint", "TooltipTTT2", self, w, h)
end

---
-- @param Panel panel
-- @realm client
function PANEL:OpenForPanel(panel)
    self.targetPanel = panel

    self:PositionTooltip()
    self:SetSkin(panel:GetSkin().Name)
    self:SetVisible(false)

    timer.Simple(self.targetPanel:GetTooltipOpeningDelay(), function()
        if not IsValid(self) or not IsValid(self.targetPanel) then
            return
        end

        self:PositionTooltip()
        self:SetVisible(true)
    end)
end

---
-- @realm client
function PANEL:Close()
    if not self.deleteContentsOnClose and IsValid(self.contents) then
        self.contents:SetVisible(false)
        self.contents:SetParent(nil)
    end

    self:Remove()
end

---
-- @realm client
function PANEL:GetText()
    return self.targetPanel:GetTooltipText() or ""
end

---
-- @realm client
function PANEL:HasText()
    if not IsValid(self.targetPanel) then
        return
    end

    return self.targetPanel:HasTooltipText()
end

---
-- @realm client
function PANEL:GetFont()
    return self.targetPanel:GetTooltipFont() or "Default"
end

derma.DefineControl("DTooltipTTT2", "", PANEL, "DLabel")
