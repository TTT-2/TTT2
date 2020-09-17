local PANEL = {}

function PANEL:DropAction_Normal(drops, bDoDrop, command, x, y)
	local closest = self:GetClosestChild(x, y)

	if not IsValid(closest) then
		return self:DropAction_Simple(drops, bDoDrop, command, x, y)
	end

	-- This panel is only meant to be copied from, not editednot 
	if self:GetReadOnly() then return end

	local h = closest:GetTall()
	local w = closest:GetWide()

	local disty = y - (closest.y + h * 0.5)
	local distx = x - (closest.x + w * 0.5)

	local drop = 0

	if self.bDropCenter then drop = 5 end

	if disty < 0 and self.bDropTop and (drop == 0 or math.abs(disty) > h * 0.1) then drop = 8 end
	if disty >= 0 and self.bDropBottom and (drop == 0 or math.abs(disty) > h * 0.1) then drop = 2 end
	if distx < 0 and self.bDropLeft and (drop == 0 or math.abs(distx) > w * 0.1) then drop = 4 end
	if distx >= 0 and self.bDropRight and (drop == 0 or math.abs(distx) > w * 0.1) then drop = 6 end

	self:UpdateDropTarget(drop, closest)

	if table.HasValue(drops, closest) or not bDoDrop and not self:GetUseLiveDrag() or #drops < 1 then return end

	-- This keeps the drop order the same,
	-- whether we add it before an object or after
	if drop == 6 or drop == 2 then
		drops = table.Reverse(drops)
	end

	for i = 1, #drops do
		local v = drops[i]

		-- Don't drop one of our parents onto us
		-- because we'll be sucked into a vortex
		if v:IsOurChild(self) then continue end

		-- Copy the panel if we are told to from the DermaMenu(), or if we are moving from a read only panel to a not read only one.
		if v.Copy
		and (command and command == "copy"
			or (IsValid(v:GetParent()) and v:GetParent().GetReadOnly and v:GetParent():GetReadOnly() and v:GetParent():GetReadOnly() ~= self:GetReadOnly())
		) then
			v = v:Copy()
		end

		v = v:OnDrop(self)

		if drop == 5 then
			closest:DroppedOn(v)
		end

		if drop == 8 or drop == 4 then
			v:SetParent(self)
			v:MoveToBefore(closest)
		end

		if drop == 2 or drop == 6 then
			v:SetParent(self)
			v:MoveToAfter(closest)
		end

		self:OnDropped(v, drop, closest)
	end

	self:OnModified()
end

function PANEL:OnDropped(droppedPnl, pos, closestPnl)

end

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)
	self:SetMouseInputEnabled(true)
	self:SetPaintBackground(false)
	self:SetReadOnly(false)

	self:SetDropPos("826")
	self:MakeDroppable("layerPanel")
end


derma.DefineControl("DDraggableRolesLayerBase", "", PANEL, "DDragBase")

PANEL = {}

function PANEL:Init()
	DDraggableRolesLayerBase.Init(self)

	self.layerList = {}
end

function PANEL:OnDropped(droppedPnl, pos, closestPnl)
	local dropLayer, dropDepth = self:GetCurrentLayerDepth(droppedPnl.roleData)

	if dropLayer then
		table.remove(self.layerList[dropLayer], dropDepth) -- remove dropped panel from old position

		-- clear old layer if empty
		if #self.layerList[dropLayer] < 1 then
			table.remove(self.layerList, dropLayer)
		end
	end

	if pos == 6 then -- right
		local newLayer, newDepth = self:GetCurrentLayerDepth(closestPnl.roleData)

		table.insert(self.layerList[newLayer], newDepth + 1, droppedPnl.roleData) -- insert dropped panel into the existing layer
	elseif pos == 8 or pos == 2 then -- top or bottom
		local newLayer = self:GetCurrentLayerDepth(closestPnl.roleData)

		table.insert(self.layerList, pos == 8 and newLayer or newLayer + 1, {droppedPnl.roleData}) -- insert dropped panel into a new layer
	end

	if not IsValid(self.senderPnl) then return end

	self.senderPnl.cachedTbl[droppedPnl.roleData] = nil -- remove from sender's cached list
end

function PANEL:OnModified()
	-- needed if the first element is dropped from sender's cached list
	local children = self:GetChildren()

	if #children == 1 and #self:GetLayers() == 0 then
		local droppedPnl = children[1]

		self.layerList[1] = {droppedPnl.roleData} -- insert dropped panel into a new layer

		if not IsValid(self.senderPnl) then return end

		self.senderPnl.cachedTbl[droppedPnl.roleData] = nil -- remove from sender's cached list
	end
end

function PANEL:SetLayers(tbl)
	self.layerList = tbl
end

function PANEL:GetLayers()
	return self.layerList
end

function PANEL:GetCurrentLayerDepth(name)
	for layer = 1, #self.layerList do
		local currentLayerTbl = self.layerList[layer]

		for depth = 1, #currentLayerTbl do
			if currentLayerTbl[depth] == name then
				return layer, depth
			end
		end
	end
end

function PANEL:PerformLayout(width, height)
	local children = self:GetChildren()

	for i = 1, #children do
		local v = children[i]
		local layer, depth = self:GetCurrentLayerDepth(v.roleData)

		v:SetPos(5 + (depth - 1) * 69, 5 + (layer - 1) * 69)
	end
end

function PANEL:InitRoles(layeredRoles)
	self:SetLayers(layeredRoles)

	for layer = 1, #layeredRoles do
		local currentLayerTbl = layeredRoles[layer]

		for i = 1, #currentLayerTbl do
			local roleData = currentLayerTbl[i]

			-- create the role icon
			local ic = vgui.Create("DRoleImage", self)
			ic:SetSize(64, 64)
			ic:SetImage("vgui/ttt/dynamic/icon_base")
			ic:SetImageColor(roleData.color)

			ic:SetImage2("vgui/ttt/dynamic/icon_base_base")
			ic:SetImageOverlay("vgui/ttt/dynamic/icon_base_base_overlay")

			ic.roleData = roleData

			ic:SetRoleIconImage(roleData.icon)
			ic:SetTooltip(LANG.TryTranslation(roleData.name))
			ic:Droppable("layerPanel")

			self:Add(ic)
		end
	end
end

function PANEL:SetSender(senderPnl)
	self.senderPnl = senderPnl
end

function PANEL:GetSender()
	return self.senderPnl
end


derma.DefineControl("DDraggableRolesLayerReceiver", "", PANEL, "DDraggableRolesLayerBase")

PANEL = {}

function PANEL:Init()
	DHorizontalScroller.Init(self)

	self.cachedTbl = {}
	self.m_padding = 0

	local canvas = self:GetCanvas()
	canvas:SetDropPos("6")
	canvas:SetPaintBackground(true)
	canvas:SetBackgroundColor(Color(100, 100, 100))

	self:MakeDroppable("layerPanel")
	self:SetShowDropTargets(true)
end

function PANEL:GetPadding()
	return self.m_padding
end

function PANEL:SetPadding(padding)
	self.m_padding = padding
end

function PANEL:GetDnDs()
	return self:GetCanvas():GetChildren()
end

function PANEL:SetReceiver(receiverPnl)
	self.receiverPnl = receiverPnl
end

function PANEL:OnDragModified()
	if not IsValid(self.receiverPnl) then return end

	local children = self:GetDnDs()

	for i = 1, #children do
		local child = children[i]

		if not self.cachedTbl[child.roleData] then -- missing in the cache, so added
			-- remove from layer
			local dropLayer, dropDepth = self.receiverPnl:GetCurrentLayerDepth(child.roleData)
			if dropLayer == nil then continue end -- not contained in layer

			local layerList = self.receiverPnl:GetLayers()

			table.remove(layerList[dropLayer], dropDepth) -- remove dropped panel from old position

			-- clear old layer if empty
			if #layerList[dropLayer] < 1 then
				table.remove(layerList, dropLayer)
			end
		end
	end

	-- update receiver
	self.receiverPnl:InvalidateLayout()

	-- update cache
	self.cachedTbl = {}

	for i = 1, #children do
		local child = children[i]

		if not self.cachedTbl[child.roleData] then -- add
			self.cachedTbl[child.roleData] = true
		end
	end

	self:InvalidateLayout()
end

function PANEL:PerformLayout(width, height)
	local canvas = self.pnlCanvas
	local w, h = self:GetSize()

	canvas:SetTall(h)

	local x = self.m_padding

	local children = self:GetDnDs()
	local childrenCount = #children

	for i = 1, childrenCount do
		local v = children[i]

		if not IsValid(v) or not v:IsVisible() then continue end

		v:SetPos(x, self.m_padding)
		v:SetTall(h - self.m_padding * 2)

		if isfunction(v.ApplySchemeSettings) then
			v:ApplySchemeSettings()
		end

		x = x + v:GetWide() - self.m_iOverlap + self.m_padding
	end

	canvas:SetWide(math.max(x + self.m_iOverlap, w))

	if w < canvas:GetWide() then
		self.OffsetX = math.Clamp(self.OffsetX, 0, canvas:GetWide() - self:GetWide())
	else
		self.OffsetX = 0
	end

	canvas.x = self.OffsetX * -1

	self.btnLeft:SetSize(15, 15)
	self.btnLeft:AlignLeft(4)
	self.btnLeft:AlignBottom(5)

	self.btnRight:SetSize(15, 15)
	self.btnRight:AlignRight(4)
	self.btnRight:AlignBottom(5)

	self.btnLeft:SetVisible(canvas.x < 0)
	self.btnRight:SetVisible(canvas.x + canvas:GetWide() > self:GetWide())
end

-- TODO .Panels in DHorizontalScroller seems to be useless
derma.DefineControl("DDraggableRolesLayerSender", "", PANEL, "DHorizontalScroller")


-- TODO fetch roleselection.baseroleLayers from server and update them when finished
local testDNDLayers = {}

-- currently, just baserole layering is supported. For subroles, there have to be a dropdown (for baseroles) that toggles a list of available related subroles (for layering)
concommand.Add("testDND", function()
	local layers = testDNDLayers --roleselection.baseroleLayers
	local leftRoles = {}
	local roleList = roles.GetList()

	for cRoles = 1, #roleList do
		local roleData = roleList[cRoles]

		if roleData.notSelectable or not roleData:IsBaseRole() or roleData == TRAITOR or roleData == INNOCENT then continue end -- don't insert unselectable roles or subroles

		local found = false

		for cLayer = 1, #layers do
			local currentLayer = layers[cLayer]

			for cEntry = 1, #currentLayer do
				if currentLayer[cEntry].index == roleData.index then
					found = true

					break
				end
			end

			if found then break end
		end

		if found then continue end

		leftRoles[#leftRoles + 1] = roleData
	end

	local frame = vgui.Create("DFrame")
	frame:SetSize(500, 500)

	local dragbase = vgui.Create("DDraggableRolesLayerReceiver", frame)
	dragbase:Dock(FILL)
	dragbase:InitRoles(layers)

	local draggableRolesBase = vgui.Create("DDraggableRolesLayerSender", frame)
	draggableRolesBase:Dock(TOP)
	draggableRolesBase:SetTall(74) -- iconsSize (64) + 2 * padding (5)
	draggableRolesBase:SetPadding(5)
	draggableRolesBase:SetReceiver(dragbase)

	for i = 1, #leftRoles do
		local roleData = leftRoles[i]

		local ic = vgui.Create("DRoleImage", draggableRolesBase)
		ic:SetSize(64, 64)
		ic:SetImage("vgui/ttt/dynamic/icon_base")
		ic:SetImageColor(roleData.color)

		ic:SetImage2("vgui/ttt/dynamic/icon_base_base")
		ic:SetImageOverlay("vgui/ttt/dynamic/icon_base_base_overlay")

		ic.roleData = roleData

		ic:SetRoleIconImage(roleData.icon)
		ic:SetTooltip(LANG.TryTranslation(roleData.name))
		ic:Droppable("layerPanel")

		draggableRolesBase:AddPanel(ic)
	end

	dragbase:SetSender(draggableRolesBase)

	frame:Center()
	frame:MakePopup()
end)
