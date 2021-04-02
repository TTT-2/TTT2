---
-- @class PANEL
-- @desc Altered version of gmod's SpawnIcon
-- This panel does not deal with models and such
-- @section ShopEditButton

local GetTranslation = LANG.GetTranslation
local math = math
local vgui = vgui

local PANEL = {}

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
-- @param number mcode
-- @realm client
function PANEL:OnMousePressed(mcode)
	if mcode == MOUSE_LEFT then
		self:DoClick()

		self.animPress:Start(0.1)
	end
end

---
-- @realm client
function PANEL:OnMouseReleased()

end

---
-- @realm client
function PANEL:DoClick()

end

---
-- @realm client
function PANEL:OpenMenu()

end

---
-- @ignore
function PANEL:ApplySchemeSettings()

end

---
-- @realm client
function PANEL:OnCursorEntered()

end

---
-- @realm client
function PANEL:OnCursorExited()

end

---
-- @ignore
function PANEL:PerformLayout()
	if self.animPress:Active() then return end

	self:SetSize(self.m_iIconSize, self.m_iIconSize)

	self.Icon:StretchToParent(0, 0, 0, 0)
end

---
-- @param Material icon
-- @realm client
function PANEL:SetIcon(icon)
	self.Icon:SetImage(icon)
end

----
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
	if anim.Started then return end

	if anim.Finished then
		self.Icon:StretchToParent(0, 0, 0, 0)

		return
	end

	local border = math.sin(delta * math.pi) * (self.m_iIconSize * 0.05)

	self.Icon:StretchToParent(border, border, border, border)
end

vgui.Register("ShopEditButton", PANEL, "Panel")

---
-- @section ShopEditorChildFrame

PANEL = {}

---
-- @accessor function
-- @realm client
AccessorFunc(PANEL, "m_fPrevFunc", "PrevFunc")

---
-- @ignore
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
