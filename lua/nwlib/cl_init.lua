-- TODO resetting disconnected player needed?

-- player requesting data
hook.Add("SetupMove", "NWLibSetupNetworking", function(ply)
	if ply ~= LocalPlayer() or ply.networkInitialized then return end

	ply.networkInitialized = true

	net.Start("NWLibRequestNetworkingData")
	net.SendToServer()
end)

local function NWLibSyncNetworkingNewData()
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

	ply.nwlib.synced[index] = dataTbl
	ply.nwlib.lookUp[key] = dataTbl

	local function RecFnc()
		local ply = net.ReadEntity()
		if not IsValid(ply) then return end

		local data = ply.nwlib.lookUp[k]
		if not data then return end

		data.value = nwlib.ReadNetworkingData(dataTbl) -- TODO
	end
	net.Receive(nwStr, RecFnc)
end
net.Receive("NWLibSyncNetworkingNewData", NWLibSyncNetworkingNewData)

local function NWLibSyncNetworkingData()
	local client = LocalPlayer()
	if not IsValid(client) then return end

	local tmpTbl = client.nwlib.synced

	for i = 1, #tmpTbl do
		local tbl = tmpTbl[i]
		local key = tbl.key

		local data = client.nwlib.lookUp[key]
		if not data then continue end

		data.value = nwlib.ReadNetworkingData(tbl) -- TODO
	end
end
net.Receive("NWLibSyncNetworkingData", NWLibSyncNetworkingData)

--------------------------------------------------------------------------------
--------------------------------- INITIAL SYNC ---------------------------------
--------------------------------------------------------------------------------

local function NWLibStartInitialNWDataSyncing()
	local requestingPly = net.ReadEntity()
	if not IsValid(requestingPly) then return end

	requestingPly:InitializeNetworkingData(LocalPlayer() == requestingPly)

	requestingPly.nwlib.isSynced = false
end
net.Receive("NWLibStartInitialNWDataSyncing", NWLibStartInitialNWDataSyncing)

local function NWLibFinishInitialNWDataSyncing()
	local requestingPly = net.ReadEntity()
	if not IsValid(requestingPly) then return end

	requestingPly.nwlib.isSynced = true
end
net.Receive("NWLibFinishInitialNWDataSyncing", NWLibFinishInitialNWDataSyncing)
