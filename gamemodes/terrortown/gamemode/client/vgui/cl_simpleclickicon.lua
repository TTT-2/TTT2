---
-- @class PANEL
-- @desc Altered version of gmod's SpawnIcon
-- This panel does not deal with models and such
-- @section SimpleClickIcon

local matHover = Material("vgui/spawnmenu/hover")

local PANEL = {}

local math = math
local ipairs = ipairs
local IsValid = IsValid
local surface = surface
local draw = draw
local vgui = vgui

---
-- @accessor number
-- @realm client
AccessorFunc(PANEL, "m_iIconSize", "IconSize")

---
-- @ignore
function PANEL:Init()
    self.Icon = vgui.Create("DImage", self)
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
        if self.OnClick then
            self:OnClick()
        end

        self.animPress:Start(0.1)
    end
end

---
-- @realm client
function PANEL:OnMouseReleased() end

---
-- @param boolean b
-- @realm client
function PANEL:Toggle(b)
    self.toggled = b
end

---
-- @realm client
function PANEL:OpenMenu() end

---
-- @realm client
function PANEL:OnCursorEntered() end

---
-- @realm client
function PANEL:OnCursorExited() end

---
-- @ignore
function PANEL:ApplySchemeSettings() end

---
-- @ignore
function PANEL:PaintOver()
    if self.animPress:Active() then
        return
    end

    if self.toggled then
        surface.SetDrawColor(0, 200, 0, 255)
        surface.SetMaterial(matHover)

        self:DrawTexturedRect()
    end
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

-- @param Material icon
-- @realm client
function PANEL:SetMaterial(material)
    self.Icon:SetMaterial(material)
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

    local border = math.sin(delta * math.pi) * self.m_iIconSize * 0.05

    self.Icon:StretchToParent(border, border, border, border)
end

vgui.Register("SimpleClickIcon", PANEL, "Panel")

---
-- @section LayeredClickIcon

PANEL = {} -- reset

---
-- @ignore
function PANEL:Init()
    self.Layers = {}
end

---
-- Add a panel to this icon. Most recent addition will be the top layer.
-- @param Panel pnl
-- @realm client
function PANEL:AddLayer(pnl)
    if not IsValid(pnl) then
        return
    end

    pnl:SetParent(self)

    pnl:SetMouseInputEnabled(false)
    pnl:SetKeyboardInputEnabled(false)

    self.Layers[#self.Layers + 1] = pnl
end

---
-- @ignore
function PANEL:PerformLayout()
    if self.animPress:Active() then
        return
    end

    self:SetSize(self.m_iIconSize, self.m_iIconSize)

    self.Icon:StretchToParent(0, 0, 0, 0)

    for _, p in ipairs(self.Layers) do
        p:SetPos(0, 0)
        p:InvalidateLayout()
    end
end

---
-- @param Panel pnl
-- @realm client
function PANEL:EnableMousePassthrough(pnl)
    for _, p in ipairs(self.Layers) do
        if p == pnl then
            p.OnMousePressed = function(s, mc)
                s:GetParent():OnMousePressed(mc)
            end

            p.OnCursorEntered = function(s)
                s:GetParent():OnCursorEntered()
            end

            p.OnCursorExited = function(s)
                s:GetParent():OnCursorExited()
            end

            p:SetMouseInputEnabled(true)
        end
    end
end

---
-- @param number mcode mouse key / code
-- @realm client
function PANEL:OnMousePressed(mcode)
    if mcode == MOUSE_LEFT then
        if self.OnClick then
            self:OnClick()
        end

        self.animPress:Start(0.1)
    end
end

vgui.Register("LayeredClickIcon", PANEL, "SimpleClickIcon")

---
-- Avatar icon
-- @section SimpleClickIconAvatar

PANEL = {}

---
-- @ignore
function PANEL:Init()
    self.imgAvatar = vgui.Create("AvatarImage", self)
    self.imgAvatar:SetMouseInputEnabled(false)
    self.imgAvatar:SetKeyboardInputEnabled(false)

    self.imgAvatar.PerformLayout = function(s)
        s:Center()
    end

    self:SetAvatarSize(32)
    self:AddLayer(self.imgAvatar)
end

---
-- @param number s
-- @realm client
function PANEL:SetAvatarSize(s)
    self.imgAvatar:SetSize(s, s)
end

---
-- @param Player ply
-- @realm client
function PANEL:SetPlayer(ply)
    self.imgAvatar:SetPlayer(ply)
end

---
-- @param number mcode mouse key / code
-- @realm client
function PANEL:OnMousePressed(mcode)
    if mcode == MOUSE_LEFT then
        if self.OnClick then
            self:OnClick()
        end

        self.animPress:Start(0.1)
    end
end

vgui.Register("SimpleClickIconAvatar", PANEL, "LayeredClickIcon")

---
-- Labelled icon
-- @section SimpleClickIconLabelled

PANEL = {}

---
-- @accessor string
-- @realm client
AccessorFunc(PANEL, "IconText", "IconText")

---
-- @accessor Color
-- @realm client
AccessorFunc(PANEL, "IconTextColor", "IconTextColor")

---
-- @accessor string
-- @realm client
AccessorFunc(PANEL, "IconFont", "IconFont")

---
-- @accessor table
-- @realm client
AccessorFunc(PANEL, "IconTextShadow", "IconTextShadow")

---
-- @accessor table
-- @realm client
AccessorFunc(PANEL, "IconTextPos", "IconTextPos")

---
-- @ignore
function PANEL:Init()
    self:SetIconText("")
    self:SetIconTextColor(Color(255, 200, 0))
    self:SetIconFont("TargetID")
    self:SetIconTextShadow({ opacity = 255, offset = 2 })
    self:SetIconTextPos({ 32, 32 })

    -- DPanelSelect loves to overwrite its children's PaintOver hooks and such,
    -- so have to use a dummy panel to do some custom painting.
    self.FakeLabel = vgui.Create("Panel", self)
    self.FakeLabel.PerformLayout = function(s)
        s:StretchToParent(0, 0, 0, 0)
    end

    self:AddLayer(self.FakeLabel)

    return self.BaseClass.Init(self)
end

---
-- @ignore
function PANEL:PerformLayout()
    self:SetLabelText(
        self:GetIconText(),
        self:GetIconTextColor(),
        self:GetIconFont(),
        self:GetIconTextPos()
    )

    return self.BaseClass.PerformLayout(self)
end

---
-- @param Color color
-- @param string font
-- @param table shadow
-- @param table pos
-- @realm client
function PANEL:SetIconProperties(color, font, shadow, pos)
    self:SetIconTextColor(color or self:GetIconTextColor())
    self:SetIconFont(font or self:GetIconFont())
    self:SetIconTextShadow(shadow or self:GetIconShadow())
    self:SetIconTextPos(pos or self:GetIconTextPos())
end

---
-- @param string text
-- @param Color color
-- @param string font
-- @param table pos
-- @realm client
function PANEL:SetLabelText(text, color, font, pos)
    if self.FakeLabel then
        local spec = {
            pos = pos,
            color = color,
            text = text,
            font = font,
            xalign = TEXT_ALIGN_CENTER,
            yalign = TEXT_ALIGN_CENTER,
        }

        local shadow = self:GetIconTextShadow()
        local opacity = shadow and shadow.opacity or 0
        local offset = shadow and shadow.offset or 0
        local drawfn = shadow and draw.TextShadow or draw.Text

        self.FakeLabel.Paint = function()
            drawfn(spec, offset, opacity)
        end
    end
end

---
-- @param number mcode mouse key / code
-- @realm client
function PANEL:OnMousePressed(mcode)
    if mcode == MOUSE_LEFT then
        if self.OnClick then
            self:OnClick()
        end

        self.animPress:Start(0.1)
    end
end

vgui.Register("SimpleClickIconLabelled", PANEL, "LayeredClickIcon")
