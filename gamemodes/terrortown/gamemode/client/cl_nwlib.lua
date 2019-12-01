local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
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
	dataTbl.unsigned = net.ReadBool()
	dataTbl.value = nil

	NWLib.syncedDataTable[ply] = NWLib.syncedDataTable[ply] or {}
	NWLib.syncedDataTable[ply][index] = dataTbl

	NWLib.lookupTable[ply] = NWLib.lookupTable[ply] or {}
	NWLib.lookupTable[ply][key] = dataTbl

	local function RecFnc()
		local ply = net.ReadEntity()
		if not IsValid(ply) then return end

		if not NWLib.lookupTable[ply] then return end

		local data = NWLib.lookupTable[ply][k]
		if not data then return end

		data.value = nwlib.ReadNetworkingData(dataTbl) -- TODO
	end
	net.Receive(nwStr, RecFnc)
end
net.Receive("TTT2SyncNetworkingNewData", TTT2SyncNetworkingNewData)

local function TTT2SyncNetworkingData()
	local client = LocalPlayer()
	if not IsValid(client) then return end

	local tmpTbl = NWLib.syncedDataTable[client]

	if not NWLib.lookupTable[ply] then return end

	for i = 1, #tmpTbl do
		local tbl = tmpTbl[i]
		local key = tbl.key

		local data = NWLib.lookupTable[ply][key]
		if not data then continue end

		data.value = nwlib.ReadNetworkingData(tbl) -- TODO
	end
end
net.Receive("TTT2SyncNetworkingData", TTT2SyncNetworkingData)
