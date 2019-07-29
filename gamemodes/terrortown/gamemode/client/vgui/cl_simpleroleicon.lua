---
-- @section SimpleRoleIcon

local math = math
local surface = surface
local vgui = vgui

local matHover = Material("vgui/spawnmenu/hover")

local PANEL = {}

AccessorFunc(PANEL, "m_iIconSize", "IconSize")

function PANEL:Init()
	self.Icon = vgui.Create("DRoleImage", self)
	self.Icon:SetMouseInputEnabled(false)
	self.Icon:SetKeyboardInputEnabled(false)

	self.animPress = Derma_Anim("Press", self, self.PressedAnim)

	self:SetIconSize(64)
end

function PANEL:OnMousePressed(mcode)
	if mcode == MOUSE_LEFT then
		self:DoClick()

		self.animPress:Start(0.1)
	end
end

function PANEL:OnMouseReleased()

end

function PANEL:DoClick()

end

function PANEL:OpenMenu()

end

function PANEL:ApplySchemeSettings()

end

local oldPaintOver = PANEL.PaintOver
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

function PANEL:OnCursorEntered()
	self.PaintOverOld = self.PaintOver
	self.PaintOver = self.PaintOverHovered
end

function PANEL:OnCursorExited()
	if self.PaintOver == self.PaintOverHovered then
		self.PaintOver = self.PaintOverOld
	end
end

function PANEL:PaintOverHovered()
	if self.animPress:Active() or self.toggled then return end

	surface.SetDrawColor(255, 255, 255, 80)
	surface.SetMaterial(matHover)

	self:DrawTexturedRect()
end

function PANEL:PerformLayout()
	if self.animPress:Active() then return end

	self:SetSize(self.m_iIconSize, self.m_iIconSize)

	self.Icon:StretchToParent(0, 0, 0, 0)
end

function PANEL:SetIcon(icon)
	self.Icon:SetImage(icon)
end

function PANEL:GetIcon()
	return self.Icon:GetImage()
end

function PANEL:SetIconColor(c)
	self.Icon:SetImageColor(c)
end

function PANEL:Think()
	self.animPress:Run()
end

function PANEL:PressedAnim(anim, delta, data)
	if anim.Started then return end

	if anim.Finished then
		self.Icon:StretchToParent(0, 0, 0, 0)

		return
	end

	local border = math.sin(delta * math.pi) * (self.m_iIconSize * 0.05)

	self.Icon:StretchToParent(border, border, border, border)
end

function PANEL:Toggle(b)
	self.toggled = b
end

vgui.Register("SimpleRoleIcon", PANEL, "Panel")
