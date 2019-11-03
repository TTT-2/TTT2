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

if SERVER then
	util.AddNetworkString("TTT2SyncNetworkingData")
	util.AddNetworkString("TTT2SyncNetworkingNewData")
	util.AddNetworkString("TTT2RequestNetworkingData")
	util.AddNetworkString("TTT2RemovePlayerNetworkingData")
end

--[[
firstFound = {value = 0, type = "number", unsigned = true},
lastFound = {value = 0, type = "number", unsigned = true},
roleFound = {value = false, type = "bool"},
bodyFound = {value = false, type = "bool"},
]]--

local lookupTable = lookupTable or {} -- this should not be accessable externally. A simple key-value transformed and networked syncedDataTable copy
local syncedDataTable = SERVER and (syncedDataTable or {}) or nil -- iteratable table, e.g. {key = lastFound, value = 0, type = "number", unsigned = true}
local playerReady = SERVER and (playerReady or {}) or nil -- key = player, value = bool; Stores which player is ready to receive data

local function GetNetworkingFallbackTable()
	return setmetatable({}, lookupTable)
end

local function ReadNetworkingData(ply, k)
	if SERVER then return end

	local v = lookupTable[k]
	if not v then return end

	if v.type == "number" then
		if v.unsigned then
			ply:SetNetworkingUInt(k, net.ReadUInt(v.bits or 32))
		else
			ply:SetNetworkingInt(k, net.ReadInt(v.bits or 32))
		end
	elseif v.type == "bool" then
		ply:SetNetworkingBool(k, net.ReadBool())
	elseif v.type == "float" then
		ply:SetNetworkingFloat(k, net.ReadFloat())
	else
		ply:SetNetworkingString(k, net.ReadString())
	end
end

local function WriteNetworkingData(ply, k)
	if CLIENT or not ply.networking then return end

	local v = ply.networking[k]
	if v == nil then return end

	if v.type == "number" then
		if v.unsigned then
			net.WriteUInt(v.value, v.bits or 32)
		else
			net.WriteInt(v.value, v.bits or 32)
		end
	elseif v.type == "bool" then
		net.WriteBool(v.value)
	elseif v.type == "float" then
		net.WriteFloat(v.value)
	else
		net.WriteString(v.value)
	end
end

---
-- Returns the stored networking key
-- @param string key
-- @return any value
function plymeta:GetNetworkingRawData(key)
	self.networking = self.networking or GetNetworkingFallbackTable()

	if not self.networking[key] then return end

	return self.networking[key].value
end

function plymeta:GetNetworkingBool(key)
	return tonumber(self:GetNetworkingRawData(key) or 0) == 1
end

function plymeta:GetNetworkingInt(key)
	return tonumber(self:GetNetworkingRawData(key) or 0)
end

function plymeta:GetNetworkingUInt(key)
	return tonumber(self:GetNetworkingRawData(key) or 0)
end

function plymeta:GetNetworkingFloat(key)
	return tonumber(self:GetNetworkingRawData(key) or 0)
end

function plymeta:GetNetworkingString(key)
	return tostring(self:GetNetworkingRawData(key) or "")
end

if SERVER then
	---
	-- Returns whether the player is able to receive networking data
	-- @return bool
	function plymeta:IsNetworkingSynced()
		return playerReady[self] == true
	end

	---
	-- Sets the networking data
	-- @warning this does not sync the data like a NWVar!
	-- @param string key
	-- @param any value
	function plymeta:SetNetworkingRawData(key, data, ply_or_rf)
		local val = data.value

		self.networking = self.networking or GetNetworkingFallbackTable()

		local dataTbl = self.networking[key]
		if dataTbl.value == val then return end

		local oldVal = dataTbl.value

		hook.Run("TTT2UpdatingNetworkingData", self, key, oldVal, val)

		dataTbl.value = val

		local plys = ply_or_rf or player.GetAll()
		local tmp = {}
		local ply

		for i = 1, #plys do
			ply = plys[i]

			if not ply:IsNetworkingSynced() then continue end

			tmp[#tmp + 1] = ply
		end

		if oldVal == nil then
			-- insert new data in networking storage
			local dataTbl = {}
			dataTbl.key = key
			dataTbl.value = nil
			dataTbl.type = data.type
			dataTbl.bits = data.bits
			dataTbl.unsinged = data.unsigned

			local index = #syncedDataTable + 1

			syncedDataTable[index] = dataTbl
			lookupTable[key] = dataTbl

			-- reserving network message for networking data
			local nwStr = "TTT2SyncNetworkingData_" .. key

			util.AddNetworkString(nwStr)

			lookupTable[key].nwStr = nwStr

			-- adding networking data to synced table and data with the same message
			net.Start("TTT2SyncNetworkingNewData")

			net.WriteUInt(index - 1, 16) -- there is no table with index 0 so decreasing it
			net.WriteString(key)
			net.WriteString(data.type)
			net.WriteUInt(data.bits - 1, 5) -- max 32 bits
			net.WriteBool(data.unsinged)
			net.WriteEntity(self)

			WriteNetworkingData(self, key)

			net.Send(tmp)

			return
		end

		if SERVER then
			net.Start(dataTbl.nwStr)
			net.WriteEntity(self)

			WriteNetworkingData(self, key)

			net.Send(tmp)
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
	-- Syncs the networking data of a @{Player} with the current @{Player} COMPLETELY
	function plymeta:SyncNetworkingData(ply)
		if not ply.networking then return end

		net.Start("TTT2SyncNetworkingData")
		net.WriteEntity(ply)

		for k in pairs(ply.networking) do
			WriteNetworkingData(ply, k)
		end

		net.Send(self)
	end

	local function TTT2RequestNetworkingData(_, ply)
		if not IsValid(ply) then return end

		playerReady[ply] = true

		hook.Run("TTT2SyncNetworkingData", ply)

		ply:SyncNetworkingData()
	end
	net.Receive("TTT2RequestNetworkingData", TTT2RequestNetworkingData)

	-- player disconnecting
	hook.Add("PlayerDisconnected", "TTT2RemovePlayerNetworkingData", function(ply)
		playerReady[ply] = nil

		-- TODO clean tables including ply
	end)
else
	-- player requesting data
	hook.Add("SetupMove", "TTT2SetupNetworking", function(ply)
		if ply ~= LocalPlayer() or ply.networkInitialized then return end

		ply.networkInitialized = true

		net.Start("TTT2RequestNetworkingData")
		net.SendToServer()
	end)

	local function TTT2SyncNetworkingNewData()
		local index = net.ReadUInt(16) + 1
		local key = net.ReadString()

		-- insert new data in networking storage
		local dataTbl = {}
		dataTbl.key = key
		dataTbl.type = net.ReadString()
		dataTbl.bits = net.ReadUInt(5) + 1 -- max 32 bits
		dataTbl.unsinged = net.ReadBool()
		dataTbl.value = nil

		syncedDataTable[index] = dataTbl
		lookupTable[key] = dataTbl

		local ply = net.ReadEntity()
		if IsValid(ply) then
			WriteNetworkingData(ply, key)
		end

		local nwStr = "TTT2SyncNetworkingData_" .. key

		lookupTable[key].nwStr = nwStr

		local function RecFnc()
			local ply = net.ReadEntity()
			if not IsValid(ply) then return end

			ReadNetworkingData(ply, key)
		end
		net.Receive(nwStr, RecFnc)
	end
	net.Receive("TTT2SyncNetworkingNewData", TTT2SyncNetworkingNewData)

	local function TTT2SyncNetworkingData()
		local ply = net.ReadEntity()
		if not IsValid(ply) then return end

		for k, v in pairs(lookupTable) do
			ReadNetworkingData(ply, k)
		end
	end
	net.Receive("TTT2SyncNetworkingData", TTT2SyncNetworkingData)
end
