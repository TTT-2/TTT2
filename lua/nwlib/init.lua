AddCSLuaFile("cl_init.lua")

local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

util.AddNetworkString("NWLibSyncNetworkingData")
util.AddNetworkString("NWLibSyncNetworkingNewData")
util.AddNetworkString("NWLibRequestNetworkingData")
util.AddNetworkString("NWLibRemovePlayerNetworkingData")
util.AddNetworkString("NWLibStartInitialNWDataSyncing")
util.AddNetworkString("NWLibFinishInitialNWDataSyncing")
util.AddNetworkString("NWLibClearNWDataSyncedPlayer")

function plymeta:InsertNewNetworkingData(key, plyVals, data, ply_or_rf)
	-- reserving network message for networking data
	local nwStr = nwlib.GenerateNetworkingDataString(key)

	util.AddNetworkString(nwStr)

	-- TODO sync dataTbl once and write val for each player afterwards

	for ply, val in pairs(plyVals) do
		local sid64 = ply:SteamID64()

		-- insert new data in networking storage
		local dataTbl = GenerateDataTable(key, data.type, data.bits, data.unsigned, nwlib.ParseData(val, data.type))
		local index = #self.nwlib.synced[sid64] + 1

		self.nwlib.synced[sid64][index] = dataTbl
		self.nwlib.lookUp[sid64][key] = dataTbl

		-- adding networking data to synced table and data with the same message
		net.Start("NWLibSyncNetworkingNewData")
		net.WriteEntity(ply)

		nwlib.WriteNewDataTbl(index, key, data, dataTbl.value)

		net.Send(self)
	end
end

---
-- Initializes the networking data of a @{Player}
function plymeta:StartSyncingNetworkingData()
	if not self:IsNetworkingSynced() then return end

	net.Start("NWLibSyncNetworkingData")

	local tmpTbl = self.nwlib.synced[self:SteamID64()]

	for i = 1, #tmpTbl do
		nwlib.WriteNewDataTbl(index, key, data, dataTbl.value)
		nwlib.WriteNetworkingData(data, tmpTbl[i].value)
	end

	net.Send(self)
end

local function NWLibRequestNetworkingData(_, requestingPly)
	if not IsValid(requestingPly) then return end

	-- create a new player data storage
	requestingPly:InitializeNetworkingData(true)

	net.Start("NWLibStartInitialNWDataSyncing")
	net.WriteEntity(requestingPly)
	net.Broadcast()

	requestingPly:StartSyncingNetworkingData()

	hook.Run("NWLibSyncNetworkingData", requestingPly)

	net.Start("NWLibFinishInitialNWDataSyncing")
	net.WriteEntity(requestingPly)
	net.Broadcast()
end
net.Receive("NWLibRequestNetworkingData", NWLibRequestNetworkingData)

-- player disconnecting
hook.Add("PlayerDisconnected", "NWLibRemovePlayerNetworkingData", function(discPly)
	discPly.nwlib.synced = nil
	discPly.nwlib.lookUp = nil

	local steamid64 = discPly:SteamID64()
	local plys = player.GetAll()
	local dataHolderNWLib

	for i = 1, #plys do
		dataHolderNWLib = plys[i].nwlib

		dataHolderNWLib.synced[steamid64] = nil
		dataHolderNWLib.lookUp[steamid64] = nil
	end

	net.Start("NWLibClearNWDataSyncedPlayer")
	net.WriteString(steamid64)
	net.Broadcast()
end)
