---
-- @class PANEL
-- @section SimpleRoleIcon

local math = math
local surface = surface
local vgui = vgui

local matHover = Material("vgui/spawnmenu/hover")

local PANEL = {}

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_iIconSize", "IconSize")

---
-- @ignore
function PANEL:Init()
    self.Icon = vgui.Create("DRoleImage", self)
    self.Icon:SetMouseInputEnabled(false)
    self.Icon:SetKeyboardInputEnabled(false)

    self.animPress = Derma_Anim("Press", self, self.PressedAnim)

    self:SetIconSize(64)
end

---
-- @param number mcode mouse key / code
-- @realm client
function PANEL:OnMousePressed(mcode)
    if mcode == MOUSE_LEFT then
        self:DoClick()

        self.animPress:Start(0.1)
    end
end

---
-- @realm client
function PANEL:OnMouseReleased() end

---
-- @realm client
function PANEL:DoClick() end

---
-- @realm client
function PANEL:OpenMenu() end

---
-- @ignore
function PANEL:ApplySchemeSettings() end

local oldPaintOver = PANEL.PaintOver

---
-- @param number w width
-- @param number h height
-- @realm client
function PANEL:PaintOver(w, h)
    if self.toggled then
        surface.SetDrawColor(0, 200, 0, 255)
        surface.SetMaterial(matHover)

        self:DrawTexturedRect()
    end

    if isfunction(oldPaintOver) then
        oldPaintOver(self, w, h)
    end
end

---
-- @realm client
function PANEL:OnCursorEntered()
    self.PaintOverOld = self.PaintOver
    self.PaintOver = self.PaintOverHovered
end

---
-- @realm client
function PANEL:OnCursorExited()
    if self.PaintOver == self.PaintOverHovered then
        self.PaintOver = self.PaintOverOld
    end
end

---
-- @realm client
function PANEL:PaintOverHovered()
    if self.animPress:Active() or self.toggled then
        return
    end

    surface.SetDrawColor(255, 255, 255, 80)
    surface.SetMaterial(matHover)

    self:DrawTexturedRect()
end

---
-- @ignore
function PANEL:PerformLayout()
    if self.animPress:Active() then
        return
    end

    self:SetSize(self.m_iIconSize, self.m_iIconSize)

    self.Icon:StretchToParent(0, 0, 0, 0)
end

---
-- @param Material icon
-- @realm client
function PANEL:SetIcon(icon)
    self.Icon:SetImage(icon)
end

---
-- @return Material
-- @realm client
function PANEL:GetIcon()
    return self.Icon:GetImage()
end

---
-- @param Color c
-- @realm client
function PANEL:SetIconColor(c)
    self.Icon:SetImageColor(c)
end

---
-- @ignore
function PANEL:Think()
    self.animPress:Run()
end

---
-- @param table anim
-- @param number delta
-- @param table data
-- @realm client
function PANEL:PressedAnim(anim, delta, data)
    if anim.Started then
        return
    end

    if anim.Finished then
        self.Icon:StretchToParent(0, 0, 0, 0)

        return
    end

    local border = math.sin(delta * math.pi) * (self.m_iIconSize * 0.05)

    self.Icon:StretchToParent(border, border, border, border)
end

---
-- @param boolean b
-- @realm client
function PANEL:Toggle(b)
    self.toggled = b
end

vgui.Register("SimpleRoleIcon", PANEL, "Panel")
