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
	local dropLayer, dropDepth = self:GetCurrentLayerDepth(droppedPnl.Name)

	if dropLayer then
		table.remove(self.layerList[dropLayer], dropDepth) -- remove dropped panel from old position

		-- clear old layer if empty
		if #self.layerList[dropLayer] < 1 then
			table.remove(self.layerList, dropLayer)
		end
	end

	if pos == 6 then -- right
		local newLayer, newDepth = self:GetCurrentLayerDepth(closestPnl.Name)

		table.insert(self.layerList[newLayer], newDepth + 1, droppedPnl.Name) -- insert dropped panel into the existing layer
	elseif pos == 8 or pos == 2 then -- top or bottom
		local newLayer = self:GetCurrentLayerDepth(closestPnl.Name)

		table.insert(self.layerList, pos == 8 and newLayer or newLayer + 1, {droppedPnl.Name}) -- insert dropped panel into a new layer
	end

	if not IsValid(self.senderPnl) then return end

	self.senderPnl.cachedTbl[droppedPnl.Name] = nil -- remove from sender's cached list
end

function PANEL:OnModified()
	-- needed if the first element is dropped from sender's cached list
	local children = self:GetChildren()

	if #children == 1 and #self:GetLayers() == 0 then
		local droppedPnl = children[1]

		self.layerList[1] = {droppedPnl.Name} -- insert dropped panel into a new layer

		if not IsValid(self.senderPnl) then return end

		self.senderPnl.cachedTbl[droppedPnl.Name] = nil -- remove from sender's cached list
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
		local layer, depth = self:GetCurrentLayerDepth(v.Name)

		v:SetPos(5 + depth * 50, 5 + layer * 22)
	end
end

function PANEL:AddRole(layer, identifier)
	local layers = self:GetLayers()
	local currentLayer = layers[layer]

	if currentLayer == nil then
		currentLayer = {}
		layers[layer] = currentLayer
	end

	currentLayer[#currentLayer + 1] = identifier

	-- create the button
	local butt = self:Add("DButton")
	butt:SetWidth(50)
	butt:Droppable("layerPanel")
	butt:SetText(identifier)

	butt.Name = identifier
end

function PANEL:InitRoles(layeredRoles)
	for layer = 1, #layeredRoles do
		local currentLayerTbl = layeredRoles[layer]

		for i = 1, #currentLayerTbl do
			self:AddRole(layer, currentLayerTbl[i])
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
	DDraggableRolesLayerBase.Init(self)

	self.cachedTbl = {}
end

function PANEL:PerformLayout(width, height)
	local children = self:GetChildren()

	for i = 1, #children do
		children[i]:SetPos(5 + (i - 1) * 50, 5)
	end
end

function PANEL:SetReceiver(receiverPnl)
	self.receiverPnl = receiverPnl
end

function PANEL:OnModified()
	if not IsValid(self.receiverPnl) then return end

	local children = self:GetChildren()

	for i = 1, #children do
		local child = children[i]

		if not self.cachedTbl[child.Name] then -- missing in the cache, so added
			-- remove from layer
			local dropLayer, dropDepth = self.receiverPnl:GetCurrentLayerDepth(child.Name)
			if dropLayer == nil then continue end -- not contained in layer

			local layerList = self.receiverPnl:GetLayers()

			table.remove(layerList[dropLayer], dropDepth) -- remove dropped panel from old position

			-- clear old layer if empty
			if #layerList[dropLayer] < 1 then
				table.remove(layerList, dropLayer)
			end
		end
	end

	-- update cache
	self.cachedTbl = {}

	for i = 1, #children do
		local child = children[i]

		if not self.cachedTbl[child.Name] then -- add
			self.cachedTbl[child.Name] = true
		end
	end
end


derma.DefineControl("DDraggableRolesLayerSender", "", PANEL, "DDraggableRolesLayerBase")


concommand.Add("testDND", function()
	local frame = vgui.Create("DFrame")
	frame:SetSize(500, 500)

	local dragbase = vgui.Create("DDraggableRolesLayerReceiver", frame)
	dragbase:Dock(FILL)
	dragbase:InitRoles({
		[1] = {"KeyKey", "NoNo"},
		[2] = {"......"},
		[3] = {"YoYo"},
		[4] = {"YesYes"},
		[5] = {"NahNah"},
		[6] = {"HmmHmm"}
	})

	local draggableRolesBase = vgui.Create("DDraggableRolesLayerSender", frame)
	draggableRolesBase:Dock(TOP)
	draggableRolesBase:SetDropPos("6")
	draggableRolesBase:SetPaintBackground(true)
	draggableRolesBase:SetBackgroundColor(Color(100, 100, 100))
	draggableRolesBase:SetReceiver(dragbase)

	for i = 0, 5 do
		local butt = draggableRolesBase:Add("DButton")
		butt:SetWidth(50)
		butt:Droppable("layerPanel")
		butt:SetText("Hey" .. i)

		butt.Name = "Hey" .. i
	end

	dragbase:SetSender(draggableRolesBase)

	frame:Center()
	frame:MakePopup()
end)
