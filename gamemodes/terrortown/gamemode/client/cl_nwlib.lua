-- TODO resetting disconnected player needed?

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
	local typ = net.ReadString()

	-- insert new data in networking storage
	local dataTbl

	if typ == "number" then
		dataTbl = GenerateDataTable(key, typ, net.ReadUInt(5) + 1, net.ReadBool())
	else
		dataTbl = GenerateDataTable(key, typ)
	end

	ply.ttt2nwlib.synced[index] = dataTbl
	ply.ttt2nwlib.lookUp[key] = dataTbl

	local function RecFnc()
		local ply = net.ReadEntity()
		if not IsValid(ply) then return end

		local data = ply.ttt2nwlib.lookUp[k]
		if not data then return end

		data.value = nwlib.ReadNetworkingData(dataTbl) -- TODO
	end
	net.Receive(nwStr, RecFnc)
end
net.Receive("TTT2SyncNetworkingNewData", TTT2SyncNetworkingNewData)

local function TTT2SyncNetworkingData()
	local client = LocalPlayer()
	if not IsValid(client) then return end

	local tmpTbl = client.ttt2nwlib.synced

	for i = 1, #tmpTbl do
		local tbl = tmpTbl[i]
		local key = tbl.key

		local data = client.ttt2nwlib.lookUp[key]
		if not data then continue end

		data.value = nwlib.ReadNetworkingData(tbl) -- TODO
	end
end
net.Receive("TTT2SyncNetworkingData", TTT2SyncNetworkingData)

--------------------------------------------------------------------------------
--------------------------------- INITIAL SYNC ---------------------------------
--------------------------------------------------------------------------------

local function TTT2StartInitialNWDataSyncing()
	local requestingPly = net.ReadEntity()
	if not IsValid(requestingPly) then return end

	requestingPly:InitializeNetworkingData(LocalPlayer() == requestingPly)

	requestingPly.ttt2nwlib.isSynced = false
end
net.Receive("TTT2StartInitialNWDataSyncing", TTT2StartInitialNWDataSyncing)

local function TTT2FinishInitialNWDataSyncing()
	local requestingPly = net.ReadEntity()
	if not IsValid(requestingPly) then return end

	requestingPly.ttt2nwlib.isSynced = true
end
net.Receive("TTT2FinishInitialNWDataSyncing", TTT2FinishInitialNWDataSyncing)
