---
-- @class PANEL
-- @section DDragReceiverTTT2

local PANEL = {}

function PANEL:Init()
	DDragBaseTTT2.Init(self)

	self.layerList = {}
	self.layerLabels = {}

	self.m_iPadding = 5
end

function PANEL:SetPadding(padding)
	self.m_iPadding = padding
end

function PANEL:UpdateLayerLabels(layerCount)
	for i = 1, layerCount do
		if self.layerLabels[i] then continue end

		self.layerLabels[i] = vgui.Create("DLabel", self)
		self.layerLabels[i]:SetText("Layer " .. i)
		self.layerLabels[i]:SetFont("DermaDefaultBold")
	end

	if #self.layerLabels <= layerCount then return end

	for i = layerCount + 1, #self.layerLabels do
		self.layerLabels[i]:Remove()

		self.layerLabels[i] = nil
	end
end

function PANEL:OnDropped(droppedPnl, pos, closestPnl)
	local dropLayer, dropDepth = self:GetCurrentLayerDepth(droppedPnl.subrole)

	print("dopped new element")
	print(droppedPnl)
	print(pos)
	print(closestPnl)

	if dropLayer then
		-- remove dropped panel from old position
		table.remove(self.layerList[dropLayer], dropDepth)

		-- clear old layer if empty
		if #self.layerList[dropLayer] < 1 then
			table.remove(self.layerList, dropLayer)
		end
	end

	if pos == 6 or pos == 4 then -- right or left
		local newLayer, newDepth = self:GetCurrentLayerDepth(closestPnl.subrole)

		-- insert dropped panel into the existing layer
		table.insert(
			self.layerList[newLayer],
			pos == 4 and newDepth or newDepth + 1,
			droppedPnl.subrole
		)
	elseif pos == 8 or pos == 2 then -- top or bottom
		local newLayer = self:GetCurrentLayerDepth(closestPnl.subrole)

		-- insert dropped panel into a new layer
		table.insert(
			self.layerList,
			pos == 8 and newLayer or newLayer + 1,
			{droppedPnl.subrole}
		)
	end

	if not IsValid(self.senderPnl) then return end

	-- remove from sender's cached list
	self.senderPnl.cachedTable[droppedPnl.subrole] = nil
end

function PANEL:OnModified()
	-- needed if the first element is dropped from sender's cached list
	local children = self:GetDnDs()
	local layerCount = #self:GetLayers()

	print("on modified receiver")

	if #children == 1 and layerCount == 0 then
		local droppedPnl = children[1]

		-- insert dropped panel into a new layer
		self.layerList[1] = {droppedPnl.subrole}

		if not IsValid(self.senderPnl) then return end

		-- remove from sender's cached list
		self.senderPnl.cachedTable[droppedPnl.subrole] = nil

		layerCount = 1
	end

	self:UpdateLayerLabels(layerCount)
end

function PANEL:SetLayers(tbl)
	self.layerList = tbl
end

function PANEL:GetLayers()
	return self.layerList
end

function PANEL:GetCurrentLayerDepth(subrole)
	for layer = 1, #self.layerList do
		local currentLayerTable = self.layerList[layer]

		for depth = 1, #currentLayerTable do
			if currentLayerTable[depth] ~= subrole then continue end

			return layer, depth
		end
	end
end

function PANEL:PerformLayout(width, height)
	local w, h = self:GetSize()
	local childW, childH = self:GetChildSize()

	local children = self:GetDnDs()

	local xStart = self:GetLeftMargin() + self.m_iPadding
	local x = xStart
	local y = self.m_iPadding

	local sortedChildren = {}

	-- pre sort children so the rendering part is easier
	for i = 1, #children do
		local child = children[i]
		local layer, depth = self:GetCurrentLayerDepth(child.subrole)

		sortedChildren[layer] = sortedChildren[layer] or {}
		sortedChildren[layer][depth] = child
	end

	for i = 1, #sortedChildren do
		local layerChildren = sortedChildren[i]

		local yRow = y

		for k = 1, #layerChildren do
			local child = layerChildren[k]

			child:SetPos(x, y)

			-- skip to next row if row is full
			local xNext = x + child:GetWide() + self.m_iPadding

			if xNext + childW > w and k < #layerChildren then
				y = y + childH + self.m_iPadding
				x = xStart
			else
				x = xNext
			end
		end

		x = xStart
		y = y + (childH + self.m_iPadding)

		self.layerLabels[i]:SetPos(5, yRow + 0.5 * (y - yRow - self.layerLabels[i]:GetTall()))
	end

	self:SetTall(y)
end

function PANEL:InitRoles(layeredRoles)
	self:SetLayers(layeredRoles)

	local layerCount = #layeredRoles

	for layer = 1, layerCount do
		local currentLayerTable = layeredRoles[layer]

		for i = 1, #currentLayerTable do
			local subrole = currentLayerTable[i]
			local roleData = roles.GetByIndex(subrole)

			-- create the role icon
			local ic = vgui.Create("DRoleImage", self)
			ic:SetSize(64, 64)
			ic:SetImage("vgui/ttt/dynamic/icon_base")
			ic:SetImageColor(roleData.color)

			ic:SetImage2("vgui/ttt/dynamic/icon_base_base")
			ic:SetImageOverlay("vgui/ttt/dynamic/icon_base_base_overlay")

			ic.subrole = subrole

			ic:SetRoleIconImage(roleData.icon)
			ic:SetTooltip(LANG.TryTranslation(roleData.name))
			ic:Droppable("layerPanel")

			self:Add(ic)
		end
	end

	self:UpdateLayerLabels(layerCount)
end

function PANEL:SetSender(senderPnl)
	self.senderPnl = senderPnl
end

function PANEL:GetSender()
	return self.senderPnl
end

function PANEL:OnDropChildCheck(closestChild)
	return closestChild.subrole ~= nil
end

derma.DefineControl("DDragReceiverTTT2", "", PANEL, "DDragBaseTTT2")
