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
		local receiverTable = {}

		if isDataUpdated then
			local layerData = ReadLayerData()

			if requestedRoleTable == ROLE_NONE then
				roleselection.baseroleLayers = layerData
			else
				roleselection.subroleLayers[requestedRoleTable] = layerData
			end

			roleselection.SaveLayers()

			if #layerData == 0 then -- is a reset
				receiverTable = player.GetAll()
			else
				-- send back to everyone but the person updating the data
				local plys = player.GetAll()

				for i = 1, #plys do
					local p = plys[i]

					if p == ply then continue end

					receiverTable[#receiverTable + 1] = ply
				end
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

	function rolelayering.SendDataToServer(roleIndex, layers)
		net.Start("TTT2SyncRolelayerData")
		net.WriteBit(1) -- Request data = 0, Send data = 1

		net.WriteUInt(roleIndex, ROLE_BITS)

		SendLayerData(layers)

		net.SendToServer()
	end
end
