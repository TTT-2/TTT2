local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

util.AddNetworkString("TTT2SyncNetworkingData")
util.AddNetworkString("TTT2SyncNetworkingNewData")
util.AddNetworkString("TTT2RequestNetworkingData")
util.AddNetworkString("TTT2RemovePlayerNetworkingData")

function plymeta:InsertNewNetworkingData(key, plyVals, data, ply_or_rf)
	-- reserving network message for networking data
	local nwStr = nwlib.GenerateNetworkingDataString(key)

	util.AddNetworkString(nwStr)

	-- TODO sync dataTbl once and write val for each player afterwards

	for ply, val in pairs(plyVals) do
		-- insert new data in networking storage
		local dataTbl = {}
		dataTbl.key = key
		dataTbl.value = nwlib.ParseData(val, data.type)
		dataTbl.type = data.type
		dataTbl.bits = data.bits
		dataTbl.unsigned = data.unsigned

		local index = #NWLib.syncedDataTable[self][ply] + 1

		NWLib.syncedDataTable[self][ply][index] = dataTbl
		NWLib.lookupTable[self][ply][key] = dataTbl

		-- adding networking data to synced table and data with the same message
		net.Start("TTT2SyncNetworkingNewData")
		net.WriteEntity(ply)

		nwlib.WriteNewDataTbl(index, key, data, dataTbl.value)

		net.Send(self)
	end
end

---
-- Initializes the networking data of a @{Player}
function plymeta:InitializeNetworkingData()
	if not self:IsNetworkingSynced() or NWLib.lookupTable[self][self] == nil then return end

	net.Start("TTT2SyncNetworkingData")

	local tmpTbl = NWLib.syncedDataTable[self][self]

	for i = 1, #tmpTbl do
		nwlib.WriteNewDataTbl(index, key, data, dataTbl.value)
		nwlib.WriteNetworkingData(data, tmpTbl[i].value)
	end

	net.Send(self)
end

local function TTT2RequestNetworkingData(_, requestingPly)
	if not IsValid(requestingPly) then return end

	-- create a new player data storage
	NWLib.syncedDataTable[requestingPly] = {}
	NWLib.lookupTable[requestingPly] = {}

	local plys = player.GetAll()
	local dataHolder

	for i = 1, #plys do
		dataHolder = plys[i]

		-- insert requesting player with default data for any player (including requestingPly)
		NWLib.syncedDataTable[dataHolder][requestingPly] = {}
		NWLib.lookupTable[dataHolder][requestingPly] = {}
	end

	requestingPly:InitializeNetworkingData()

	hook.Run("TTT2SyncNetworkingData", requestingPly)
end
net.Receive("TTT2RequestNetworkingData", TTT2RequestNetworkingData)

-- player disconnecting
hook.Add("PlayerDisconnected", "TTT2RemovePlayerNetworkingData", function(discPly)
	NWLib.syncedDataTable[discPly] = nil
	NWLib.lookupTable[discPly] = nil

	local plys = player.GetAll()

	for i = 1, #plys do
		local dataHolder = plys[i]

		NWLib.syncedDataTable[dataHolder][discPly] = nil
		NWLib.lookupTable[dataHolder][discPly] = nil
	end
end)
