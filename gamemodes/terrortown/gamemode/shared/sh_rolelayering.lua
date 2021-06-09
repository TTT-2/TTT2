--- @ignore
-- @author Alf21
-- @author Mineotopia

rolelayering = {}

local function SendLayerData(layerTable)
	local layerTableSize = #layerTable

	net.WriteUInt(layerTableSize, ROLE_BITS)

	for i = 1, layerTableSize do
		local currentLayer = layerTable[i]
		local layerDepth = #currentLayer

		net.WriteUInt(layerDepth, ROLE_BITS)

		for cDepth = 1, layerDepth do
			-- the role's index
			net.WriteUInt(currentLayer[cDepth], ROLE_BITS)
		end
	end
end

local function ReadLayerData()
	local layerTable = {}
	local layerTableSize = net.ReadUInt(ROLE_BITS)

	for i = 1, layerTableSize do
		local currentLayer = {}
		local layerDepth = net.ReadUInt(ROLE_BITS)

		for cDepth = 1, layerDepth do
			currentLayer[cDepth] = net.ReadUInt(ROLE_BITS)
		end

		layerTable[i] = currentLayer
	end

	return layerTable
end

function rolelayering.GetLayerableBaserolesWithSubroles()
	local availableBaseRolesTable = {}
	local availableSubRolesTable = {}
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

			availableSubRolesTable[baserole] = availableSubRolesTable[baserole] or {}
			availableSubRolesTable[baserole][#availableSubRolesTable[baserole] + 1] = roleData.index
		else
			availableBaseRolesAmount = availableBaseRolesAmount + 1

			availableBaseRolesTable[availableBaseRolesAmount] = roleData.index
		end
	end

	-- now get the subroles if there are more than 1 subrole of a related baserole
	for cBase = 1, availableBaseRolesAmount do
		local baserole = availableBaseRolesTable[cBase]
		local currentSubrolesTable = availableSubRolesTable[baserole]

		if currentSubrolesTable == nil or #currentSubrolesTable < 2 then -- related subroles table
			availableSubRolesTable[baserole] = nil -- reset if not enough related subroles so a layer wouldn't make any sense
		end
	end

	-- all selectable baseroles, all selectable subroles with related baseroles
	return availableBaseRolesTable, availableSubRolesTable
end

if SERVER then
	util.AddNetworkString("TTT2SyncRolelayerData")

	net.Receive("TTT2SyncRolelayerData", function(_, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		-- ROLE_NONE = 3 is reserved and here used to indicate a baserole request. If a valid baserole is given, the
		-- subrole list is requested. For further information, see @{roles.GenerateNewRoleID()} @{function}

		-- requests are only sent back to the player, data updates are broadcasted
		local isDataUpdated = net.ReadBit() == 1

		-- read the table the client requested
		local requestedRoleTable = net.ReadUInt(ROLE_BITS)

		-- define a table of receivers for the netmessage
		local receiverTable

		if isDataUpdated then
			if requestedRoleTable == ROLE_NONE then
				roleselection.baseroleLayers = ReadLayerData()
			else
				roleselection.subroleLayers[requestedRoleTable] = ReadLayerData()
			end

			roleselection.SaveLayers()

			-- send back to everyone but the person updating the data
			local plys = player.GetAll()

			for i = 1, #plys do
				local p = plys[i]

				if p == ply then continue end

				receiverTable[#receiverTable + 1] = ply
			end
		else
			receiverTable = {ply}
		end

		-- always send back data to the clients if something happened
		local layerTable

		if requestedRoleTable == ROLE_NONE then
			layerTable = roleselection.baseroleLayers
		else
			layerTable = roleselection.subroleLayers[requestedRoleTable]
		end

		net.Start("TTT2SyncRolelayerData")
		net.WriteUInt(requestedRoleTable, ROLE_BITS)

		SendLayerData(layerTable or {})

		net.Send(receiverTable)
	end)
end

if CLIENT then
	function rolelayering.RequestDataFromServer(role)
		role = role or ROLE_NONE

		net.Start("TTT2SyncRolelayerData")
		net.WriteBit(0) -- Request data = 0, Send data = 1
		net.WriteUInt(role, ROLE_BITS)
		net.SendToServer()
	end

	net.Receive("TTT2SyncRolelayerData", function()
		local roleIndex = net.ReadUInt(ROLE_BITS)

		-- get the role-index value-based table and directly convert it into a role-data value-based table
		local layerTable = ReadLayerData()

		hook.Run("TTT2ReceivedRolelayerData", roleIndex, layerTable)
	end)
end
































if SERVER then
	-- networkmessages for layer syncing
	util.AddNetworkString("TTT2SyncRolesLayer")

	net.Receive("TTT2SyncRolesLayer", function(_, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		local send = net.ReadBit() == 0
		local requestedRoleTable = net.ReadUInt(ROLE_BITS) -- read the table the client requested

		if send then -- send data to the client
			local layerTable

			-- ROLE_NONE = 3 is reserved and here used to indicate as a baserole request. If a valid baserole is given, the subrole list is requested. For further information, see @{roles.GenerateNewRoleID()} @{function}
			if requestedRoleTable == ROLE_NONE then
				layerTable = roleselection.baseroleLayers
			else
				layerTable = roleselection.subroleLayers[requestedRoleTable]
			end

			net.Start("TTT2SyncRolesLayer")

			net.WriteUInt(requestedRoleTable, ROLE_BITS)

			SendLayerData(layerTable or {})

			net.Send(ply)
		else -- receive data from the client
			-- ROLE_NONE = 3 is reserved and here used to indicate as a baserole request. If a valid baserole is given, the subrole list is requested. For further information, see @{roles.GenerateNewRoleID()} @{function}
			if requestedRoleTable == ROLE_NONE then
				roleselection.baseroleLayers = ReadLayerData()
			else
				roleselection.subroleLayers[requestedRoleTable] = ReadLayerData()
			end

			roleselection.SaveLayers()
		end
	end)

	return
end



local function GetLayerableBaserolesWithSubroles()
	local availableBaseRolesTable = {}
	local availableSubRolesTable = {}
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

			availableSubRolesTable[baserole] = availableSubRolesTable[baserole] or {}
			availableSubRolesTable[baserole][#availableSubRolesTable[baserole] + 1] = roleData.index
		else
			availableBaseRolesAmount = availableBaseRolesAmount + 1

			availableBaseRolesTable[availableBaseRolesAmount] = roleData.index
		end
	end

	-- now get the subroles if there are more than 1 subrole of a related baserole
	for cBase = 1, availableBaseRolesAmount do
		local baserole = availableBaseRolesTable[cBase]
		local currentSubrolesTable = availableSubRolesTable[baserole]

		if currentSubrolesTable == nil or #currentSubrolesTable < 2 then -- related subroles table
			availableSubRolesTable[baserole] = nil -- reset if not enough related subroles so a layer wouldn't make any sense
		end
	end

	-- all selectable baseroles, all selectable subroles with related baseroles
	return availableBaseRolesTable, availableSubRolesTable
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

		SendLayerData(layers)

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
	local layerTable = ReadLayerData()

	-- create the layering DnD-VGUI
	CreateLayer(roleIndex, layerTable)
end)
