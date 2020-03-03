
local PANEL = {}

AccessorFunc(PANEL, "m_bIsMenuComponent", "IsMenu", FORCE_BOOL)
AccessorFunc(PANEL, "m_bDraggable", "Draggable", FORCE_BOOL)
AccessorFunc(PANEL, "m_bSizable", "Sizable", FORCE_BOOL)
AccessorFunc(PANEL, "m_bScreenLock", "ScreenLock", FORCE_BOOL)
AccessorFunc(PANEL, "m_bDeleteOnClose", "DeleteOnClose", FORCE_BOOL)
AccessorFunc(PANEL, "m_bPaintShadow", "PaintShadow", FORCE_BOOL)

AccessorFunc(PANEL, "m_iMinWidth", "MinWidth", FORCE_NUMBER)
AccessorFunc(PANEL, "m_iMinHeight", "MinHeight", FORCE_NUMBER)

AccessorFunc(PANEL, "m_bBackgroundBlur", "BackgroundBlur", FORCE_BOOL)

function PANEL:Init()
	self:SetFocusTopLevel(true)
	self:SetPaintShadow(true)

	-- add close button
	self.btnClose = vgui.Create("DButton", self)
	self.btnClose:SetText("")
	self.btnClose:SetVisible(true)

	self.btnClose.DoClick = function(button)
		self:Close()
	end

	self.btnClose.Paint = function(panel, w, h)
		derma.SkinHook("Paint", "WindowCloseButton", panel, w, h)
	end

	-- add back button
	self.btnBack = vgui.Create("DButton", self)
	self.btnBack:SetText("")
	self.btnBack:SetVisible(true)

	self.btnBack.DoClick = function(button)

	end

	self.btnBack.Paint = function(panel, w, h)
		derma.SkinHook("Paint", "WindowBackButton", panel, w, h)
	end

	self:SetDraggable(true)
	self:SetSizable(false)
	self:SetScreenLock(false)
	self:SetDeleteOnClose(true)

	self:SetMinWidth(50)
	self:SetMinHeight(50)

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)

	self.m_fCreateTime = SysTime()

	self.title = {
		text = "Window",
		font = "DermaTTT2Title"
	}
end

function PANEL:SetTitle(strTitle)
	self.title.text = strTitle
end

function PANEL:GetTitle()
	return self.title.text
end

function PANEL:SetTitleFont(fontName)
	self.title.font = fontName
end

function PANEL:GetTitleFont()
	return self.title.font
end

function PANEL:ShowCloseButton(bShow)
	self.btnClose:SetVisible(bShow)
end

function PANEL:ShowBackButton(bShow)
	self.btnBack:SetVisible(bShow)
end

function PANEL:RegisterBackFunction(fn)
	self.btnBack.DoClick = fn
end

function PANEL:Close()
	self:SetVisible(false)

	if self:GetDeleteOnClose() then
		self:Remove()
	end

	self:OnClose()
end

function PANEL:OnClose()

end

function PANEL:Center()
	self:InvalidateLayout(true)
	self:CenterVertical()
	self:CenterHorizontal()
end

function PANEL:IsActive()
	if self:HasFocus() then
		return true
	end

	if vgui.FocusedHasParent(self) then
		return true
	end

	return false
end

function PANEL:Think()
	local mousex = math.Clamp(gui.MouseX(), 1, ScrW() - 1)
	local mousey = math.Clamp(gui.MouseY(), 1, ScrH() - 1)

	if self.Dragging then
		local x = mousex - self.Dragging[1]
		local y = mousey - self.Dragging[2]

		-- Lock to screen bounds if screenlock is enabled
		if (self:GetScreenLock()) then

			x = math.Clamp(x, 0, ScrW() - self:GetWide())
			y = math.Clamp(y, 0, ScrH() - self:GetTall())

		end

		self:SetPos(x, y)
	end

	if self.Sizing then
		local x = mousex - self.Sizing[1]
		local y = mousey - self.Sizing[2]
		local px, py = self:GetPos()

		if x < self.m_iMinWidth then
			x = self.m_iMinWidth
		elseif x > ScrW() - px and self:GetScreenLock() then
			x = ScrW() - px
		end

		if y < self.m_iMinHeight then
			y = self.m_iMinHeight
		elseif y > ScrH() - py and self:GetScreenLock() then
			y = ScrH() - py
		end

		self:SetSize(x, y)
		self:SetCursor("sizenwse")

		return
	end

	local screenX, screenY = self:LocalToScreen(0, 0)

	if self.Hovered and self.m_bSizable and mousex > (screenX + self:GetWide() - 20) and mousey > (screenY + self:GetTall() - VSKIN.GetHeaderHeight()) then
		self:SetCursor("sizenwse")

		return
	end

	if self.Hovered and self:GetDraggable() and mousey < (screenY + VSKIN.GetHeaderHeight()) then
		self:SetCursor("sizeall")

		return
	end

	self:SetCursor("arrow")

	-- Don't allow the frame to go higher than 0
	if self.y < 0 then
		self:SetPos(self.x, 0)
	end
end

function PANEL:Paint(w, h)
	if self.m_bBackgroundBlur then
		Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
	end

	derma.SkinHook("Paint", "Frame", self, w, h)

	return true
end

function PANEL:OnMousePressed()
	local screenX, screenY = self:LocalToScreen(0, 0)

	if self.m_bSizable and gui.MouseX() > (screenX + self:GetWide() - 20) and gui.MouseY() > (screenY + self:GetTall() - VSKIN.GetHeaderHeight()) then
		self.Sizing = {
			gui.MouseX() - self:GetWide(),
			gui.MouseY() - self:GetTall()
		}

		self:MouseCapture(true)

		return
	end

	if self:GetDraggable() and gui.MouseY() < (screenY + VSKIN.GetHeaderHeight()) then
		self.Dragging = {
			gui.MouseX() - self.x,
			gui.MouseY() - self.y
		}

		self:MouseCapture(true)

		return
	end
end

function PANEL:OnMouseReleased()
	self.Dragging = nil
	self.Sizing = nil
	self:MouseCapture(false)
end

function PANEL:PerformLayout()
	local size = VSKIN.GetHeaderHeight()

	self.btnClose:SetPos(self:GetWide() - size, 0)
	self.btnClose:SetSize(size, size)

	self.btnBack:SetPos(0, 0)
	self.btnBack:SetSize(100, size)
end

derma.DefineControl("DFrameTTT2", "A simple window", PANEL, "EditablePanel")
