if SERVER then
	AddCSLuaFile()
end

---
-- complex player-based networking system, just a temporary solution to tackle the problem of delay-synced NWVars

-- TODO networking limit of 65535 bits
-- TODO add syncing list, like net.WriteX -> decreasing amount of network message and compress into one. Using ply:PushNetworkingData or smth
--			instead of writing string as index, writing number for list index
-- TODO add global function to keep some vars everytime synced like nwvars (not player based)

local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

---
-- Initializes the data storage for a player
function plymeta:InitializeNetworkingData(initial)
	-- these tables have on server two included tables:
	-- 		T1: key == player connected with the data
	-- 		T2: key == player the data is about
	-- on clients, there is just one table, because the client just needs to know about his own data storage (T1 key == player the data is about)

	self.nwlib = self.nwlib or {}
	self.nwlib.lookUp = self.nwlib.lookUp or {} -- this should not be accessable externally. A simple key-value transformed and networked plymeta.nwlib.synced copy with same data references!
	self.nwlib.synced = self.nwlib.synced or {} -- iteratable table, e.g. {key = lastFound, value = 0, type = "number", unsigned = true}

	local sid64 = SERVER and self:SteamID64() or nil

	if SERVER then
		self.nwlib.lookUp[sid64] = self.nwlib.lookUp[sid64] or {}
		self.nwlib.synced[sid64] = self.nwlib.synced[sid64] or {}
	end

	if not initial then return end

	local plys = player.GetAll()
	local dataHolder

	for i = 1, #plys do
		if SERVER then
			dataHolder = plys[i].nwlib

			-- insert requesting player with default data for any player (including own player (self))
			dataHolder.synced[sid64] = {}
			dataHolder.lookUp[sid64] = {}
		else
			dataHolder = plys[i]:InitializeNetworkingData(false) -- initialize new data for any player
		end
	end
end

---
-- Returns whether the player is able to receive networking data
-- @return bool
function plymeta:IsNetworkingSynced()
  return SERVER and self.nwlib ~= nil or self.nwlib.isSynced == true
end

--------------------------------------------------------------------------------
------------------------------------ SETTER ------------------------------------
--------------------------------------------------------------------------------

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
	local ply, oldVal, sid64
	local missingValPlys = SERVER and {} or nil
	local plyVals = SERVER and {} or nil

	for i = 1, #plys do
		ply = plys[i]
		sid64 = ply:SteamID64()

		local dataTbl = SERVER and self.nwlib.lookUp[sid64][key] or ply.nwlib.lookUp[key]

		oldVal = dataTbl and dataTbl.value or nil

		if oldVal ~= nil then
			val = hook.Run("NWLibUpdateData", self, ply, key, oldVal, val) or val
		else
			val = hook.Run("NWLibInitializeData", self, ply, key, val) or val
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

	local nwStr = nwlib.GenerateNetworkingDataString(key)

	for val, plyTbl in pairs(tmp) do
		net.Start(nwStr)
		net.WriteEntity(self)

		nwlib.WriteNetworkingData(data, val)

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
		unsigned = true,
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

--------------------------------------------------------------------------------
------------------------------------ GETTER ------------------------------------
--------------------------------------------------------------------------------

---
-- Returns the stored networking key
-- @param string key
-- @return any value
function plymeta:GetNetworkingRawData(target, key)
	if not self:IsNetworkingSynced() or not target:IsNetworkingSynced() then return end

	local data = CLIENT and target.nwlib.lookUp[key] or self.nwlib.lookUp[target:SteamID64()][key]
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
