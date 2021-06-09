---
-- @class PANEL
-- @section DDragSenderTTT2

local PANEL = {}

function PANEL:Init()
	DIconLayout.Init(self)

	self.cachedTable = {}
	self.m_iPadding = 0
	self.m_iLeftMargin = 0

	--local canvas = self:GetCanvas()
	--canvas:SetDropPos("46")
	--canvas:SetPaintBackground(true)
	--canvas:SetBackgroundColor(Color(100, 100, 100))

	self.m_pLayerLabel = vgui.Create("DLabel", self)
	self.m_pLayerLabel:SetText("Not\nlayered")
	self.m_pLayerLabel:SetFont("DermaDefaultBold")
	self.m_pLayerLabel:SetTall(28)

	self:MakeDroppable("layerPanel")
	--self:SetShowDropTargets(true)
end

function PANEL:GetPadding()
	return self.m_iPadding
end

function PANEL:SetPadding(padding)
	self.m_iPadding = padding
end

function PANEL:GetLeftMargin()
	return self.m_iLeftMargin
end

function PANEL:SetLeftMargin(leftMargin)
	self.m_iLeftMargin = leftMargin
end

function PANEL:GetDnDs()
	local children = self:GetChildren()
	local validChildren = {}

	for i = 1, #children do
		local child = children[i]

		-- not a valid child with a subrole, skip
		if not child.subrole then continue end

		validChildren[#validChildren + 1] = child
	end

	return validChildren
end

function PANEL:SetReceiver(receiverPnl)
	self.receiverPnl = receiverPnl
end

function PANEL:OnModified()
	if not IsValid(self.receiverPnl) then return end

	print("modified sender")

	local children = self:GetDnDs()

	PrintTable(children)
	for i = 1, #children do
		local child = children[i]

		print("child:")
		print(child)
		print("subrole: " .. tostring(child.subrole))

		-- already cached, skipping
		if self.cachedTable[child.subrole] then continue end

		-- remove from layer
		local dropLayer, dropDepth = self.receiverPnl:GetCurrentLayerDepth(child.subrole)

		print("dropLayer, dropDepth")
		print(dropLayer, dropDepth)

		-- not contained in layer
		if dropLayer == nil then continue end

		local layerList = self.receiverPnl:GetLayers()

		print("layerList")
		PrintTable(layerList)

		-- remove dropped panel from old position
		table.remove(layerList[dropLayer], dropDepth)

		-- clear old layer if empty
		if #layerList[dropLayer] < 1 then
			table.remove(layerList, dropLayer)
		end
	end

	print("cached Table1 ----")
	PrintTable(self.cachedTable)

	-- update receiver
	self.receiverPnl:OnModified()
	self.receiverPnl:InvalidateLayout()

	-- update cache
	self.cachedTable = {}

	for i = 1, #children do
		local child = children[i]

		-- not a valid child with a subrole, skip
		if not child.subrole then continue end

		if not self.cachedTable[child.subrole] then
			self.cachedTable[child.subrole] = true
		end
	end

	print("cached Table2 ----")
	PrintTable(self.cachedTable)

	self:InvalidateLayout()
end

function PANEL:Paint(w, h)
	draw.Box(0, 0, w, h, COLOR_RED)

	return false
end

function PANEL:PerformLayout(width, height)
	--local canvas = self.pnlCanvas
	local w, h = self:GetSize()

	--canvas:SetTall(h)

	local x = self:GetLeftMargin() + self.m_iPadding

	local children = self:GetDnDs()
	local childrenCount = #children

	for i = 1, childrenCount do
		local v = children[i]

		if not IsValid(v) or not v:IsVisible() then continue end

		v:SetPos(x, self.m_iPadding)
		v:SetTall(h - self.m_iPadding * 2)

		if isfunction(v.ApplySchemeSettings) then
			v:ApplySchemeSettings()
		end

		--x = x + v:GetWide() - self.m_iOverlap + self.m_iPadding
		x = x + v:GetWide() + self.m_iPadding
	end

	--canvas:SetWide(math.max(x + self.m_iOverlap, w))

	--if w < canvas:GetWide() then
	--	self.OffsetX = math.Clamp(self.OffsetX, 0, canvas:GetWide() - self:GetWide())
	--else
	--	self.OffsetX = 0
	--end
--
	--canvas.x = self.OffsetX * -1

	--self.btnLeft:SetSize(15, 15)
	--self.btnLeft:AlignLeft(4)
	--self.btnLeft:AlignBottom(5)

	--self.btnRight:SetSize(15, 15)
	--self.btnRight:AlignRight(4)
	--self.btnRight:AlignBottom(5)

	--self.btnLeft:SetVisible(canvas.x < 0)
	--self.btnRight:SetVisible(canvas.x + canvas:GetWide() > self:GetWide())

	self.m_pLayerLabel:SetPos(5, 25)
end

function PANEL:OnDropChildCheck(closestChild, direction)
	if #self:GetDnDs() == 0 and direction == 6 then
		return true
	else
		return closestChild.subrole ~= nil
	end
end

-- .Panels in DHorizontalScroller seems to be useless
derma.DefineControl("DDragSenderTTT2", "", PANEL, "DDragBaseTTT2")
