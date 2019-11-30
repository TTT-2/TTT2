local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

function NWLib.ReadNetworkingData(ply, k, data)
	if not NWLib.lookupTable[ply] then return end

	local data = NWLib.lookupTable[ply][k]
	if not data then return end

	if data.type == "number" then
		if data.unsigned then
			ply:SetNetworkingUInt(k, net.ReadUInt(data.bits or 32))
		else
			ply:SetNetworkingInt(k, net.ReadInt(data.bits or 32))
		end
	elseif data.type == "bool" then
		ply:SetNetworkingBool(k, net.ReadBool())
	elseif data.type == "float" then
		ply:SetNetworkingFloat(k, net.ReadFloat())
	else
		ply:SetNetworkingString(k, net.ReadString())
	end
end

function NWLib.ReadNewDataTbl()
	local index = net.ReadUInt(16) + 1
	local k = net.ReadString()

	local dataTbl = {}
	dataTbl.key = k
	dataTbl.typ = net.ReadString()
	dataTbl.bits = net.ReadUInt(5) + 1
	dataTbl.unsinged = net.ReadBool()

	-- TODO update data for any player with default one
	NWLib.syncedDataTable[client]
	NWLib.lookupTable[ply][k] = dataTbl

	NWLib.ReadNetworkingData(ply, k, dataTbl)

	return dataTbl
end

-- player requesting data
hook.Add("SetupMove", "TTT2SetupNetworking", function(ply)
	if ply ~= LocalPlayer() or ply.networkInitialized then return end

	ply.networkInitialized = true

	net.Start("TTT2RequestNetworkingData")
	net.SendToServer()
end)

local function TTT2SyncNetworkingNewData()
	local ply = net.ReadEntity()
	if not IsValid(ply) then return end

	local index = net.ReadUInt(16) + 1
	local key = net.ReadString()

	-- insert new data in networking storage
	local dataTbl = {}
	dataTbl.key = key
	dataTbl.type = net.ReadString()
	dataTbl.bits = net.ReadUInt(5) + 1 -- max 32 bits
	dataTbl.unsinged = net.ReadBool()
	dataTbl.value = nil

	NWLib.syncedDataTable[ply] = NWLib.syncedDataTable[ply] or {}
	NWLib.syncedDataTable[ply][index] = dataTbl

	NWLib.lookupTable[ply] = NWLib.lookupTable[ply] or {}
	NWLib.lookupTable[ply][key] = dataTbl

	local function RecFnc()
		local ply = net.ReadEntity()
		if not IsValid(ply) then return end

		NWLib.ReadNetworkingData(ply, key, dataTbl)
	end
	net.Receive(nwStr, RecFnc)
end
net.Receive("TTT2SyncNetworkingNewData", TTT2SyncNetworkingNewData)

local function TTT2SyncNetworkingData()
	local client = LocalPlayer()
	if not IsValid(client) then return end

	local tmpTbl = NWLib.syncedDataTable[client]

	for i = 1, #tmpTbl do
		NWLib.ReadNetworkingData(client, tmpTbl[i].key, tmpTbl[i])
	end
end
net.Receive("TTT2SyncNetworkingData", TTT2SyncNetworkingData)
