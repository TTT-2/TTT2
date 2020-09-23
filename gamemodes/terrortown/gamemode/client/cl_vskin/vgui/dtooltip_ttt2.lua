local PANEL = {}

function PANEL:Init()
	self:SetText("")
	self:SetDrawOnTop(true)

	self.deleteContentsOnClose = false

	self.sizeArrow = 8
end

function PANEL:UpdateColours(skin)
	return self:SetTextStyleColor(skin.Colours.TooltipText)
end

function PANEL:SetContents(panel, bDelete)
	panel:SetParent(self)

	self.contents = panel
	self.deleteContentsOnClose = bDelete or false
	self.contents:SizeToContents()
	self:InvalidateLayout(true)

	self.contents:SetVisible(false)
end

function PANEL:PerformLayout()
	if not IsValid(self.targetPanel) then return end

	if self.targetPanel:HasTooltipFixedSize() then
		self:SetSize(self.targetPanel:GetTooltipFixedSize())
	elseif IsValid(self.contents) then
		self:SetWide(self.contents:GetWide() + 8)
		self:SetTall(self.contents:GetTall() + 8)
	else
		local w, h = draw.GetTextSize(self:GetText(), self:GetFont())

		self:SetSize(w + 20, h + 8 + self.sizeArrow)
	end

	if IsValid(self.contents) then
		self.contents:SetPos(1, self.sizeArrow + 1)
		self.contents:SetVisible(true)
	end
end

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

function PANEL:Paint(w, h)
	self:PositionTooltip()

	derma.SkinHook("Paint", "TooltipTTT2", self, w, h)
end

function PANEL:OpenForPanel(panel)
	self.targetPanel = panel

	self:PositionTooltip()
	self:SetSkin(panel:GetSkin().Name)
	self:SetVisible(false)

	timer.Simple(self.targetPanel:GetTooltipOpeningDelay(), function()
		if not IsValid(self) or not IsValid(self.targetPanel) then return end

		self:PositionTooltip()
		self:SetVisible(true)
	end)
end

function PANEL:Close()
	if not self.deleteContentsOnClose and IsValid(self.contents) then
		self.contents:SetVisible(false)
		self.contents:SetParent(nil)
	end

	self:Remove()
end

function PANEL:GetText()
	return self.targetPanel:GetTooltipText() or ""
end

function PANEL:HasText()
	if not IsValid(self.targetPanel) then return end

	return self.targetPanel:HasTooltipText()
end

function PANEL:GetFont()
	return self.targetPanel:GetTooltipFont() or "Default"
end

derma.DefineControl("DTooltipTTT2", "", PANEL, "DLabel")
