--- @ignore
-- @author Alf21

local function SendLayersData(layerTbl)
	local layerTblSize = #layerTbl

	net.WriteUInt(layerTblSize, ROLE_BITS) -- can't be greater than the maximum amount of roles

	for i = 1, layerTblSize do
		local currentLayer = layerTbl[i]
		local layerDepth = #currentLayer

		net.WriteUInt(layerDepth, ROLE_BITS) -- can't be greater than the maximum amount of roles

		for cDepth = 1, layerDepth do
			net.WriteUInt(currentLayer[cDepth], ROLE_BITS) -- the role's index
		end
	end
end

local function ReadLayersData()
	local layerTbl = {}
	local layerTblSize = net.ReadUInt(ROLE_BITS)

	for i = 1, layerTblSize do
		local currentLayer = {}
		local layerDepth = net.ReadUInt(ROLE_BITS)

		for cDepth = 1, layerDepth do
			currentLayer[cDepth] = net.ReadUInt(ROLE_BITS)
		end

		layerTbl[i] = currentLayer
	end

	return layerTbl
end

if SERVER then
	-- networkmessages for layer syncing
	util.AddNetworkString("TTT2SyncRolesLayer")

	net.Receive("TTT2SyncRolesLayer", function(_, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		local send = net.ReadBit() == 0
		local requestedRoleTbl = net.ReadUInt(ROLE_BITS) -- read the table the client requested

		if send then -- send data to the client
			local layerTbl

			-- ROLE_NONE = 3 is reserved and here used to indicate as a baserole request. If a valid baserole is given, the subrole list is requested. For further information, see @{roles.GenerateNewRoleID()} @{function}
			if requestedRoleTbl == ROLE_NONE then
				layerTbl = roleselection.baseroleLayers
			else
				layerTbl = roleselection.subroleLayers[requestedRoleTbl]
			end

			net.Start("TTT2SyncRolesLayer")

			net.WriteUInt(requestedRoleTbl, ROLE_BITS)

			SendLayersData(layerTbl or {})

			net.Send(ply)
		else -- receive data from the client
			-- ROLE_NONE = 3 is reserved and here used to indicate as a baserole request. If a valid baserole is given, the subrole list is requested. For further information, see @{roles.GenerateNewRoleID()} @{function}
			if requestedRoleTbl == ROLE_NONE then
				roleselection.baseroleLayers = ReadLayersData()
			else
				roleselection.subroleLayers[requestedRoleTbl] = ReadLayersData()
			end

			roleselection.SaveLayers()
		end
	end)

	return
end

local PANEL = {}

function PANEL:Init()
	DDragBase.Init(self)

	self:SetDropPos("2468")
	self:MakeDroppable("layerPanel")

	self.m_iLeftMargin = 0
end

function PANEL:GetLeftMargin()
	return self.m_iLeftMargin
end

function PANEL:SetLeftMargin(leftMargin)
	self.m_iLeftMargin = leftMargin
end

function PANEL:GetDnDs()
	local dnds = {}
	local children = self:GetChildren()

	for i = 1, #children do
		local child = children[i]

		if child.subrole then
			dnds[#dnds + 1] = child
		end
	end

	return dnds
end

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


derma.DefineControl("DDraggableRolesLayerBase", "", PANEL, "DDragBase")

PANEL = {}

function PANEL:Init()
	DDraggableRolesLayerBase.Init(self)

	self.layerList = {}
	self.layerLabels = {}
end

function PANEL:UpdateLayerLabels(maxLayers)
	for i = 1, maxLayers do
		if self.layerLabels[i] then continue end

		self.layerLabels[i] = vgui.Create("DLabel", self)
		self.layerLabels[i]:SetText("Layer " .. i)
		self.layerLabels[i]:SetFont("DermaDefaultBold")
	end

	if #self.layerLabels <= maxLayers then return end

	for i = maxLayers + 1, #self.layerLabels do
		self.layerLabels[i]:Remove()

		self.layerLabels[i] = nil
	end
end

function PANEL:OnDropped(droppedPnl, pos, closestPnl)
	local dropLayer, dropDepth = self:GetCurrentLayerDepth(droppedPnl.subrole)

	if dropLayer then
		table.remove(self.layerList[dropLayer], dropDepth) -- remove dropped panel from old position

		-- clear old layer if empty
		if #self.layerList[dropLayer] < 1 then
			table.remove(self.layerList, dropLayer)
		end
	end

	if pos == 6 or pos == 4 then -- right or left
		local newLayer, newDepth = self:GetCurrentLayerDepth(closestPnl.subrole)

		table.insert(self.layerList[newLayer], pos == 4 and newDepth or newDepth + 1, droppedPnl.subrole) -- insert dropped panel into the existing layer
	elseif pos == 8 or pos == 2 then -- top or bottom
		local newLayer = self:GetCurrentLayerDepth(closestPnl.subrole)

		table.insert(self.layerList, pos == 8 and newLayer or newLayer + 1, {droppedPnl.subrole}) -- insert dropped panel into a new layer
	end

	if not IsValid(self.senderPnl) then return end

	self.senderPnl.cachedTbl[droppedPnl.subrole] = nil -- remove from sender's cached list
end

function PANEL:OnModified()
	-- needed if the first element is dropped from sender's cached list
	local children = self:GetDnDs()
	local maxLayers	= #self:GetLayers()

	if #children == 1 and maxLayers == 0 then
		local droppedPnl = children[1]

		self.layerList[1] = {droppedPnl.subrole} -- insert dropped panel into a new layer

		if not IsValid(self.senderPnl) then return end

		self.senderPnl.cachedTbl[droppedPnl.subrole] = nil -- remove from sender's cached list

		maxLayers = 1
	end

	self:UpdateLayerLabels(maxLayers)
end

function PANEL:SetLayers(tbl)
	self.layerList = tbl
end

function PANEL:GetLayers()
	return self.layerList
end

function PANEL:GetCurrentLayerDepth(subrole)
	for layer = 1, #self.layerList do
		local currentLayerTbl = self.layerList[layer]

		for depth = 1, #currentLayerTbl do
			if currentLayerTbl[depth] == subrole then
				return layer, depth
			end
		end
	end
end

function PANEL:PerformLayout(width, height)
	local children = self:GetDnDs()
	local maxLayers = 0

	for i = 1, #children do
		local v = children[i]
		local layer, depth = self:GetCurrentLayerDepth(v.subrole)

		if maxLayers < layer then
			maxLayers = layer
		end

		v:SetPos(self:GetLeftMargin() + 5 + (depth - 1) * 69, 5 + (layer - 1) * 69)
	end

	for i = 1, #self.layerLabels do
		self.layerLabels[i]:SetPos(5, 5 + (i - 1) * 69 + 20)
	end

	self:SetTall(10 + maxLayers * 69)
end

function PANEL:InitRoles(layeredRoles)
	self:SetLayers(layeredRoles)

	local maxLayers = #layeredRoles

	for layer = 1, maxLayers do
		local currentLayerTbl = layeredRoles[layer]

		for i = 1, #currentLayerTbl do
			local subrole = currentLayerTbl[i]
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

	self:UpdateLayerLabels(maxLayers)
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
	self.m_iPadding = 0
	self.m_iLeftMargin = 0

	local canvas = self:GetCanvas()
	canvas:SetDropPos("46")
	canvas:SetPaintBackground(true)
	canvas:SetBackgroundColor(Color(100, 100, 100))

	self.m_pLayerLabel = vgui.Create("DLabel", self)
	self.m_pLayerLabel:SetText("Not\nlayered")
	self.m_pLayerLabel:SetFont("DermaDefaultBold")
	self.m_pLayerLabel:SetTall(28)

	self:MakeDroppable("layerPanel")
	self:SetShowDropTargets(true)
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

		if not self.cachedTbl[child.subrole] then -- missing in the cache, so added
			-- remove from layer
			local dropLayer, dropDepth = self.receiverPnl:GetCurrentLayerDepth(child.subrole)
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
	self.receiverPnl:OnModified()
	self.receiverPnl:InvalidateLayout()

	-- update cache
	self.cachedTbl = {}

	for i = 1, #children do
		local child = children[i]

		if not self.cachedTbl[child.subrole] then -- add
			self.cachedTbl[child.subrole] = true
		end
	end

	self:InvalidateLayout()
end

function PANEL:PerformLayout(width, height)
	local canvas = self.pnlCanvas
	local w, h = self:GetSize()

	canvas:SetTall(h)

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

		x = x + v:GetWide() - self.m_iOverlap + self.m_iPadding
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

	self.m_pLayerLabel:SetPos(5, 25)
end

-- .Panels in DHorizontalScroller seems to be useless
derma.DefineControl("DDraggableRolesLayerSender", "", PANEL, "DHorizontalScroller")


local function GetLayerableBaserolesWithSubroles()
	local availableBaseRolesTbl = {}
	local availableSubRolesTbl = {}
	local availableBaseRolesAmount = 0

	local roleList = roles.GetList()

	for i = 1, #roleList do
		local roleData = roleList[i]

		-- if the role was created with the intention of never getting selected without any special fulfilled condition, it should be excluded from the layering.
		-- here, we don't care about server settings like whether all special roles were deactivated or similar things. Unselectable roles (because of server-related settings)
		-- are automatically excluded in the selection process
		-- But we could gray the roles that aren't selectable because of server settings, to simplify the layering process?
		if roleData.notSelectable then continue end

		if not roleData:IsBaseRole() then
			local baserole = roleData:GetBaseRole()

			availableSubRolesTbl[baserole] = availableSubRolesTbl[baserole] or {}
			availableSubRolesTbl[baserole][#availableSubRolesTbl[baserole] + 1] = roleData.index
		else
			availableBaseRolesAmount = availableBaseRolesAmount + 1

			availableBaseRolesTbl[availableBaseRolesAmount] = roleData.index
		end
	end

	-- now get the subroles if there are more than 1 subrole of a related baserole
	for cBase = 1, availableBaseRolesAmount do
		local baserole = availableBaseRolesTbl[cBase]
		local currentSubrolesTbl = availableSubRolesTbl[baserole]

		if currentSubrolesTbl == nil or #currentSubrolesTbl < 2 then -- related subroles table
			availableSubRolesTbl[baserole] = nil -- reset if not enough related subroles so a layer wouldn't make any sense
		end
	end

	-- all selectable baseroles, all selectable subroles with related baseroles
	return availableBaseRolesTbl, availableSubRolesTbl
end

local function CreateLayer(roleIndex, layers)
	local leftRoles = {}
	local baseroleList, subroleList = GetLayerableBaserolesWithSubroles()
	local roleList

	if roleIndex == ROLE_NONE then
		roleList = baseroleList
	else
		roleList = subroleList[roleIndex]
	end

	if #roleList < 2 then return end -- a layer wouldn't make any sense if there are less than 2 available entries / related roles

	for cRoles = 1, #roleList do
		local subrole = roleList[cRoles]

		if subrole == ROLE_TRAITOR or subrole == ROLE_INNOCENT then continue end -- don't insert roles that are getting automatically / statically selected

		local found = false

		for cLayer = 1, #layers do
			local currentLayer = layers[cLayer]

			for cEntry = 1, #currentLayer do
				if currentLayer[cEntry] == subrole then
					found = true

					break
				end
			end

			if found then break end
		end

		if found then continue end

		leftRoles[#leftRoles + 1] = subrole
	end

	local title = (roleIndex == ROLE_NONE and "Baserole" or LANG.TryTranslation(roles.GetByIndex(roleIndex).name)) .. " layers"

	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrW() - 50, ScrH() - 50)
	frame:SetTitle(title)

	local comboBox = vgui.Create("DComboBox", frame)
	comboBox:Dock(TOP)
	comboBox:SetValue(title)

	if roleIndex ~= ROLE_NONE then
		comboBox:AddChoice("Baserole layers", ROLE_NONE)
	end

	for subrole in pairs(subroleList) do
		if subrole == roleIndex then continue end

		comboBox:AddChoice(LANG.TryTranslation(roles.GetByIndex(subrole).name) .. " layers", subrole)
	end

	-- ugly, but working for now. Close the frame and request a new list. A realtime refresh would be cooler
	function comboBox:OnSelect(index, value, data)
		frame:Close()

		net.Start("TTT2SyncRolesLayer")
		net.WriteBit(0) -- Request data = 0, Send data = 1
		net.WriteUInt(data, ROLE_BITS) -- ROLE_NONE = 3 is reserved and here used to indicate as a baserole request. If a valid baserole is given, the subrole list is requested. For further information, see @{roles.GenerateNewRoleID()} @{function}
		net.SendToServer()
	end

	local dragbaseScrollPanel = vgui.Create("DScrollPanel", frame)
	dragbaseScrollPanel:Dock(FILL)

	-- modify the canvas
	local canvas = dragbaseScrollPanel:Add("DDraggableRolesLayerReceiver")
	canvas:SetLeftMargin(100)
	canvas:Dock(TOP)
	canvas:InitRoles(layers)

	local draggableRolesBase = vgui.Create("DDraggableRolesLayerSender", frame)
	draggableRolesBase:SetLeftMargin(100)
	draggableRolesBase:Dock(TOP)
	draggableRolesBase:SetTall(74) -- iconsSize (64) + 2 * padding (5)
	draggableRolesBase:SetPadding(5)
	draggableRolesBase:SetReceiver(canvas)

	for i = 1, #leftRoles do
		local subrole = leftRoles[i]
		local roleData = roles.GetByIndex(subrole)

		local ic = vgui.Create("DRoleImage", draggableRolesBase)
		ic:SetSize(64, 64)
		ic:SetImage("vgui/ttt/dynamic/icon_base")
		ic:SetImageColor(roleData.color)

		ic:SetImage2("vgui/ttt/dynamic/icon_base_base")
		ic:SetImageOverlay("vgui/ttt/dynamic/icon_base_base_overlay")

		ic.subrole = subrole

		ic:SetRoleIconImage(roleData.icon)
		ic:SetTooltip(LANG.TryTranslation(roleData.name))
		ic:Droppable("layerPanel")

		draggableRolesBase:AddPanel(ic)
	end

	canvas:SetSender(draggableRolesBase)

	-- Send data to the server on close
	function frame:OnClose()
		net.Start("TTT2SyncRolesLayer")
		net.WriteBit(1) -- Send data

		net.WriteUInt(roleIndex, ROLE_BITS)

		SendLayersData(layers)

		net.SendToServer()
	end

	frame:Center()
	frame:MakePopup()
end

concommand.Add("ttt2_edit_rolelayering", function()
	if not LocalPlayer():IsAdmin() then return end

	net.Start("TTT2SyncRolesLayer")
	net.WriteBit(0) -- Request data = 0, Send data = 1
	net.WriteUInt(ROLE_NONE, ROLE_BITS) -- ROLE_NONE = 3 is reserved and here used to indicate as a baserole request. If a valid baserole is given, the subrole list is requested. For further information, see @{roles.GenerateNewRoleID()} @{function}
	net.SendToServer()
end)

-- received layered table
net.Receive("TTT2SyncRolesLayer", function()
	local roleIndex = net.ReadUInt(ROLE_BITS)

	-- get the role-index value-based table and directly convert it into a role-data value-based table
	local layerTbl = ReadLayersData()

	-- create the layering DnD-VGUI
	CreateLayer(roleIndex, layerTbl)
end)
