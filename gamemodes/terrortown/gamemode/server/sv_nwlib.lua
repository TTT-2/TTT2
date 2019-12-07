local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

util.AddNetworkString("TTT2SyncNetworkingData")
util.AddNetworkString("TTT2SyncNetworkingNewData")
util.AddNetworkString("TTT2RequestNetworkingData")
util.AddNetworkString("TTT2RemovePlayerNetworkingData")
util.AddNetworkString("TTT2StartInitialNWDataSyncing")
util.AddNetworkString("TTT2FinishInitialNWDataSyncing")
util.AddNetworkString("TTT2ClearNWDataSyncedPlayer")

function plymeta:InsertNewNetworkingData(key, plyVals, data, ply_or_rf)
	-- reserving network message for networking data
	local nwStr = nwlib.GenerateNetworkingDataString(key)

	util.AddNetworkString(nwStr)

	-- TODO sync dataTbl once and write val for each player afterwards

	for ply, val in pairs(plyVals) do
		local sid64 = ply:SteamID64()

		-- insert new data in networking storage
		local dataTbl = GenerateDataTable(key, data.type, data.bits, data.unsigned, nwlib.ParseData(val, data.type))
		local index = #self.ttt2nwlib.synced[sid64] + 1

		self.ttt2nwlib.synced[sid64][index] = dataTbl
		self.ttt2nwlib.lookUp[sid64][key] = dataTbl

		-- adding networking data to synced table and data with the same message
		net.Start("TTT2SyncNetworkingNewData")
		net.WriteEntity(ply)

		nwlib.WriteNewDataTbl(index, key, data, dataTbl.value)

		net.Send(self)
	end
end

---
-- Initializes the networking data of a @{Player}
function plymeta:StartSyncingNetworkingData()
	if not self:IsNetworkingSynced() then return end

	net.Start("TTT2SyncNetworkingData")

	local tmpTbl = self.ttt2nwlib.synced[self:SteamID64()]

	for i = 1, #tmpTbl do
		nwlib.WriteNewDataTbl(index, key, data, dataTbl.value)
		nwlib.WriteNetworkingData(data, tmpTbl[i].value)
	end

	net.Send(self)
end

local function TTT2RequestNetworkingData(_, requestingPly)
	if not IsValid(requestingPly) then return end

	-- create a new player data storage
	requestingPly:InitializeNetworkingData(true)

	net.Start("TTT2StartInitialNWDataSyncing")
	net.WriteEntity(requestingPly)
	net.Broadcast()

	requestingPly:StartSyncingNetworkingData()

	hook.Run("TTT2SyncNetworkingData", requestingPly)

	net.Start("TTT2FinishInitialNWDataSyncing")
	net.WriteEntity(requestingPly)
	net.Broadcast()
end
net.Receive("TTT2RequestNetworkingData", TTT2RequestNetworkingData)

-- player disconnecting
hook.Add("PlayerDisconnected", "TTT2RemovePlayerNetworkingData", function(discPly)
	discPly.ttt2nwlib.synced = nil
	discPly.ttt2nwlib.lookUp = nil

	local steamid64 = discPly:SteamID64()
	local plys = player.GetAll()
	local dataHolderNWLib

	for i = 1, #plys do
		dataHolderNWLib = plys[i].ttt2nwlib

		dataHolderNWLib.synced[steamid64] = nil
		dataHolderNWLib.lookUp[steamid64] = nil
	end

	net.Start("TTT2ClearNWDataSyncedPlayer")
	net.WriteString(steamid64)
	net.Broadcast()
end)
