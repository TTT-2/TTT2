local GetTranslation = LANG.GetTranslation

-- Altered version of gmod's SpawnIcon
-- This panel does not deal with models and such

local PANEL = {}

AccessorFunc(PANEL, "m_iIconSize", "IconSize")

function PANEL:Init()
	self.Icon = vgui.Create("DImage", self)
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

function PANEL:OnCursorEntered()

end

function PANEL:OnCursorExited()

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

vgui.Register("ShopEditButton", PANEL, "Panel")

PANEL = {}

AccessorFunc(PANEL, "m_fPrevFunc", "PrevFunc")

function PANEL:Init()
	local frame = self

	local bprev = vgui.Create("DButton", self)
	bprev:SetFont("Trebuchet22")
	bprev:SetPos(0, 0)
	bprev:SetText(GetTranslation("prev"))
	bprev:AlignLeft()
	bprev:SizeToContents()

	bprev.DoClick = function()
		if frame:GetPrevFunc() and isfunction(frame:GetPrevFunc()) then
			frame:GetPrevFunc()()
		end
	end
end

vgui.Register("ShopEditorChildFrame", PANEL, "DFrame")
