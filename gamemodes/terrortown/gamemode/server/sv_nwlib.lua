local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

util.AddNetworkString("TTT2SyncNetworkingData")
util.AddNetworkString("TTT2SyncNetworkingNewData")
util.AddNetworkString("TTT2RequestNetworkingData")
util.AddNetworkString("TTT2RemovePlayerNetworkingData")

function NWLib.WriteNetworkingData(data, val)
	if not data then return end

	if data.type == "number" then
		if data.unsigned then
			net.WriteUInt(val, data.bits or 32)
		else
			net.WriteInt(val, data.bits or 32)
		end
	elseif data.type == "bool" then
		net.WriteBool(val)
	elseif data.type == "float" then
		net.WriteFloat(val)
	else
		net.WriteString(val)
	end
end

function NWLib.WriteNewDataTbl(index, key, data, val)
	net.WriteUInt(index - 1, 16) -- there is no table with index 0 so decreasing it
	net.WriteString(key)
	net.WriteString(data.type)
	net.WriteUInt(data.bits - 1, 5) -- max 32 bits
	net.WriteBool(data.unsinged)

	NWLib.WriteNetworkingData(data, val)
end

function plymeta:InsertNewNetworkingData(key, plyVals, data, ply_or_rf)
	-- reserving network message for networking data
	local nwStr = NWLib.GenerateNetworkingDataString(key)

	util.AddNetworkString(nwStr)

	-- TODO sync dataTbl once and write val for each player afterwards

	for ply, val in pairs(plyVals) do
		-- insert new data in networking storage
		local dataTbl = {}
		dataTbl.key = key
		dataTbl.value = NWLib.ParseData(val, data.type)
		dataTbl.type = data.type
		dataTbl.bits = data.bits
		dataTbl.unsinged = data.unsigned

		local index = #NWLib.syncedDataTable[self][ply] + 1

		NWLib.syncedDataTable[self][ply][index] = dataTbl
		NWLib.lookupTable[self][ply][key] = dataTbl

		-- adding networking data to synced table and data with the same message
		net.Start("TTT2SyncNetworkingNewData")
		net.WriteEntity(ply)

		NWLib.WriteNewDataTbl(index, key, data, dataTbl.value)

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
		NWLib.WriteNewDataTbl(index, key, data, dataTbl.value)
		NWLib.WriteNetworkingData(data, tmpTbl[i].value)
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
