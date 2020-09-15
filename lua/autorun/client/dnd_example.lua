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

	if table.HasValue(drops, closest) or not bDoDrop and not self:GetUseLiveDrag() then return end

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

		if isfunction(closest.OnDropped) then
			closest:OnDropped(v, drop)
		end
	end

	self:OnModified()
end

function PANEL:PerformLayout(width, height)
	for k, v in ipairs(self:GetChildren()) do
		local layer, depth = DNDGetCurrentLayerDepth(v.Name)

		v:SetPos(5 + depth * 50, 5 + layer * 22)
	end
end

derma.DefineControl("DDragBase2", "", PANEL, "DDragBase")

local layerList = {
	[1] = {"KeyKey", "NoNo"},
	[2] = {"......"},
	[3] = {"YoYo"},
	[4] = {"YesYes"},
	[5] = {"NahNah"},
	[6] = {"HmmHmm"}
}

function DNDGetCurrentLayerDepth(name)
	for layer = 1, #layerList do
		local currentLayerTbl = layerList[layer]

		for depth = 1, #currentLayerTbl do
			if currentLayerTbl[depth] == name then
				return layer, depth
			end
		end
	end

	return #layerList + 1, 1
end

concommand.Add("testDND", function()
	local frame = vgui.Create("DFrame")
	frame:SetSize(500, 500)
	frame:Center()
	frame:MakePopup()

	local dragbase = vgui.Create("DDragBase2", frame)
	dragbase:Dock(FILL)
	dragbase:MakeDroppable("test")
	dragbase:SetDropPos("826")

	function dragbase:OnModified()
		self:InvalidateLayout()
	end

	for layer = 1, #layerList do
		local currentLayerTbl = layerList[layer]

		for i = 1, #currentLayerTbl do
			local butt = dragbase:Add("DButton")
			butt:SetPos(25, (i - 1) * 25)
			butt:SetWidth(50)
			butt:Droppable("test")

			butt.Name = currentLayerTbl[i]
			butt.Layer = layer
			butt.Depth = i

			butt:SetText(butt.Name)

			function butt:OnDropped(droppedPnl, pos)
				local dropLayer, dropDepth = DNDGetCurrentLayerDepth(droppedPnl.Name)

				table.remove(layerList[dropLayer], dropDepth) -- remove dropped panel from old position

				-- clear old layer if empty
				if #layerList[dropLayer] < 1 then
					table.remove(layerList, dropLayer)
				end

				if pos == 6 then -- right
					local newLayer, newDepth = DNDGetCurrentLayerDepth(self.Name)

					table.insert(layerList[newLayer], newDepth + 1, droppedPnl.Name) -- insert dropped panel into the existing layer
				elseif pos == 8 or pos == 2 then -- top or bottom
					local newLayer = DNDGetCurrentLayerDepth(self.Name)

					table.insert(layerList, pos == 8 and newLayer or newLayer + 1, {droppedPnl.Name}) -- insert dropped panel into a new layer
				end
			end

			butt.id = i - 1
		end
	end
end)
