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
	util.AddNetworkString("TTT2RequestNetworkingData")
	util.AddNetworkString("TTT2RemovePlayerNetworkingData")
end

--[[
firstFound = {value = 0, type = "number", unsigned = true},
lastFound = {value = 0, type = "number", unsigned = true},
roleFound = {value = false, type = "bool"},
bodyFound = {value = false, type = "bool"},
]]--

local syncedDataTable = syncedDataTable or {} -- iteratable  table, e.g. {key = lastFound, value = 0, type = "number", unsigned = true}
local lookupTable = lookupTable or {} -- this should not be accessable externally. A simple key-value transformed TTT2NW.syncedDataTable copy
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

--[[ TODO
for k, v in pairs(lookupTable) do
	local nwStr = "TTT2SyncNetworkingData_" .. k

	if SERVER then
		util.AddNetworkString(nwStr)
	end

	lookupTable[k].nwStr = nwStr

	if CLIENT then
		net.Receive(nwStr, function()
			local ply = net.ReadEntity()
			if not IsValid(ply) then return end

			ReadNetworkingData(ply, k)
		end)
	end
end
]]--

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

		if oldVal == nil then
				-- TODO add networking data to synced table
				-- TODO add message to queue
				-- TODO if ready, send data to the stored players

			return
		end

		if SERVER then
			net.Start(dataTbl.nwStr)
			net.WriteEntity(self)

			WriteNetworkingData(self, key)

			--if ply_or_rf then
			--	net.Send(ply_or_rf)
			--else
				local plys = player.GetAll()
				local tmp = {}
				local ply

				for i = 1, #plys do
					ply = plys[i]

					if not ply:IsNetworkingSynced() then continue end

					tmp[#tmp + 1] = ply
				end

				net.Send(tmp)
			--end
		end
	end

	function plymeta:SetNetworkingBool(key, val)
		self:SetNetworkingRawData(key, {
			value = val,
			type = "bool",
		})
	end

	function plymeta:SetNetworkingInt(key, val)
		self:SetNetworkingRawData(key, {
			value = val,
			type = "number",
		})
	end

	function plymeta:SetNetworkingUInt(key, val)
		self:SetNetworkingRawData(key, {
			value = val,
			type = "number",
			unsinged = true,
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

	local function TTT2SyncNetworkingData()
		local ply = net.ReadEntity()
		if not IsValid(ply) then return end

		for k, v in pairs(lookupTable) do
			ReadNetworkingData(ply, k)
		end
	end
	net.Receive("TTT2SyncNetworkingData", TTT2SyncNetworkingData)
end
