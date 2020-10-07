local PANEL = {}

AccessorFunc(PANEL, "Padding", "Padding")
AccessorFunc(PANEL, "pnlCanvas", "Canvas")

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

function PANEL:AddItem(pnl)
	pnl:SetParent(self:GetCanvas())
end

function PANEL:OnChildAdded(child)
	self:AddItem(child)
end

function PANEL:SizeToContents()
	self:SetSize(self.pnlCanvas:GetSize())
end

function PANEL:GetVBar()
	return self.vBar
end

function PANEL:GetCanvas()
	return self.pnlCanvas
end

function PANEL:InnerWidth()
	return self:GetCanvas():GetWide()
end

function PANEL:Rebuild()
	self:GetCanvas():SizeToChildren(false, true)

	if self.m_bNoSizing and self:GetCanvas():GetTall() < self:GetTall() then
		self:GetCanvas():SetPos(0, (self:GetTall() - self:GetCanvas():GetTall()) * 0.5)
	end
end

function PANEL:OnMouseWheeled(dlta)
	return self.vBar:OnMouseWheeled(dlta)
end

function PANEL:OnVScroll(iOffset)
	self.pnlCanvas:SetPos(0, iOffset)
end

function PANEL:ScrollToChild(panel)
	self:InvalidateLayout(true)

	local _, y = self.pnlCanvas:GetChildPosition(panel)
	local _, h = panel:GetSize()

	y = y + h * 0.5
	y = y - self:GetTall() * 0.5

	self.vBar:AnimateTo(y, 0.5, 0, 0.5)
end

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

function PANEL:PerformLayout()
	self:PerformLayoutInternal()
end

function PANEL:Clear()
	return self.pnlCanvas:Clear()
end

derma.DefineControl("DScrollPanelTTT2", "", PANEL, "DPanel")
