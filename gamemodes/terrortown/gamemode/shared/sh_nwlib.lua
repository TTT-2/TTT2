---
-- simple player-based networking system, just a temporary solution to tackle the problem of delay-synced NWVars

-- TODO request from client (SetupMove hook), hook and answer from server
-- TODO remove player from syncedPlayer list if disconnected
-- TODO networking limit of 65535 bits
-- TODO add syncing list, like net.WriteX -> decreasing amount of network message and compress into one. Using ply:PushNetworkingData or smth
--			instead of writing string as index, writing number for list index

local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

NWLib = NWLib or {}

--[[
firstFound = {value = 0, type = "number", unsigned = true},
lastFound = {value = 0, type = "number", unsigned = true},
roleFound = {value = false, type = "bool"},
bodyFound = {value = false, type = "bool"},
]]--

-- these tables have on server two included tables:
-- 		T1: key == player connected with the data
-- 		T2: key == player the data is about
-- on clients, there is just one table, because the client just needs to know about his own data storage (T1 key == player the data is about)
NWLib.lookupTable = NWLib.lookupTable or {} -- this should not be accessable externally. A simple key-value transformed and networked NWLib.syncedDataTable copy with same data references!
NWLib.syncedDataTable = NWLib.syncedDataTable or {} -- iteratable table, e.g. {key = lastFound, value = 0, type = "number", unsigned = true}

function NWLib.ParseData(val, typ)
	if data.type == "number" or data.type == "float" then
		return tonumber(val)
	elseif data.type == "bool" then
		return tobool(val)
	end

	return tostring(val)
end

function NWLib.GenerateNetworkingDataString(key)
	return "TTT2SyncNetworkingData_" .. key
end

---
-- Returns whether the player is able to receive networking data
-- @return bool
function plymeta:IsNetworkingSynced()
  return NWLib.lookupTable[self] ~= nil
end

---
-- Sets the networking data
-- @warning this does not sync the data like a NWVar!
-- @param string key
-- @param table data
-- @param table ply_or_rf
function plymeta:SetNetworkingRawData(key, data, ply_or_rf)
	if data == nil then return end

	local val = data.value
	local plys = ply_or_rf or player.GetAll()
	local tmp = SERVER and {} or nil
	local ply, oldVal
	local missingValPlys = SERVER and {} or nil
	local plyVals = SERVER and {} or nil

	for i = 1, #plys do
		ply = plys[i]

		local dataTbl = SERVER and NWLib.lookupTable[self][ply][key] or NWLib.lookupTable[ply][key]

		oldVal = dataTbl and dataTbl.value or nil

		if oldVal ~= nil then
			val = hook.Run("TTT2UpdatingNetworkingData", self, ply, key, oldVal, val) or val
		else
			val = hook.Run("TTT2InitializeNetworkingData", self, ply, key, val) or val
		end

		if oldVal == val then continue end

		dataTbl.value = val

		if CLIENT then continue end

		plyVals[ply] = val

		if oldVal == nil then
			missingValPlys[#missingValPlys + 1] = ply

			continue
		end

		local index = tostring(val)

		tmp[index] = tmp[index] or {}
		tmp[index][#tmp[index] + 1] = ply
	end

	if CLIENT then return end

	if #missingValPlys > 0 then
		self:InsertNewNetworkingData(key, plyVals, data, missingValPlys)
	end

	local nwStr = NWLib.GenerateNetworkingDataString(key)

	for val, plyTbl in pairs(tmp) do
		net.Start(nwStr)
		net.WriteEntity(self)

		NWLib.WriteNetworkingData(data, val)

		net.Send(plyTbl)
	end
end

function plymeta:SetNetworkingBool(key, val)
	self:SetNetworkingRawData(key, {
		value = val,
		type = "bool",
	})
end

function plymeta:SetNetworkingInt(key, val, bits)
	self:SetNetworkingRawData(key, {
		value = val,
		type = "number",
		bits = bits,
	})
end

function plymeta:SetNetworkingUInt(key, val, bits)
	self:SetNetworkingRawData(key, {
		value = val,
		type = "number",
		unsinged = true,
		bits = bits,
	})
end

function plymeta:SetNetworkingFloat(key, val)
	self:SetNetworkingRawData(key, {
		value = val,
		type = "float",
	})
end

function plymeta:SetNetworkingString(key, val)
	self:SetNetworkingRawData(key, {
		value = val,
		type = "string",
	})
end

---
-- Returns the stored networking key
-- @param string key
-- @return any value
function plymeta:GetNetworkingRawData(target, key)
	if not self:IsNetworkingSynced() or not target:IsNetworkingSynced() then return end

	local data = CLIENT and NWLib.lookupTable[target][key] or NWLib.lookupTable[self][target][key]
	if data == nil then return end

	return data.value
end

function plymeta:GetNetworkingBool(target, key)
	return tonumber(self:GetNetworkingRawData(target, key) or 0) == 1
end

function plymeta:GetNetworkingInt(target, key)
	return tonumber(self:GetNetworkingRawData(target, key) or 0)
end

function plymeta:GetNetworkingUInt(target, key)
	return tonumber(self:GetNetworkingRawData(target, key) or 0)
end

function plymeta:GetNetworkingFloat(target, key)
	return tonumber(self:GetNetworkingRawData(target, key) or 0)
end

function plymeta:GetNetworkingString(target, key)
	return tostring(self:GetNetworkingRawData(target, key) or "")
end
