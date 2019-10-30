---
-- simple player-based networking system, just a temporary solution to tackle the problem of delay-synced NWVars

local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

local defaultNetworkingDataTable = {
	firstFound = {value = 0, type = "number", unsigned = true},
	lastFound = {value = 0, type = "number", unsigned = true},
	roleFound = {value = false, type = "bool"},
	bodyFound = {value = false, type = "bool"},
}

local function ReadNetworkingData(ply, k)
	if SERVER then return end

	local v = defaultNetworkingDataTable[k]
	if not v then return end

	if v.type == "number" then
		if v.unsigned then
			ply:SetNetworkingData(k, net.ReadUInt(v.bits or 32))
		else
			ply:SetNetworkingData(k, net.ReadInt(v.bits or 32))
		end
	elseif v.type == "bool" then
		ply:SetNetworkingData(k, net.ReadBool())
	else
		ply:SetNetworkingData(k, net.ReadString())
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
	else
		net.WriteString(v.value)
	end
end

for k, v in pairs(defaultNetworkingDataTable) do
	local nwStr = "TTT2SyncNetworkingData_" .. k

	if SERVER then
		util.AddNetworkString(nwStr)
	end

	defaultNetworkingDataTable[k].nwStr = nwStr

	if CLIENT then
		net.Receive(nwStr, function()
			local ply = net.ReadEntity()
			if not IsValid(ply) then return end

			ReadNetworkingData(ply, k)
		end)
	end
end

---
-- Returns the stored networking key
-- @param string key
-- @return any value
function plymeta:GetNetworkingData(key)
	self.networking = self.networking or table.Copy(defaultNetworkingDataTable)

	if not self.networking[key] then return end

	return self.networking[key].value
end

---
-- Sets the networking data
-- @warning this does not sync the data like a NWVar!
-- @param string key
-- @param any value
function plymeta:SetNetworkingData(key, val, ply_or_rf)
	self.networking = self.networking or table.Copy(defaultNetworkingDataTable)

	local dataTbl = self.networking[key]

	-- do not allow new entries that possible are not shared! Prevent async issues
	if dataTbl == nil then
		MsgN("[TTT2] New networking keys are not allowed in ply:SetNetworkingData() function.")

		return
	end

	if dataTbl.value == val then return end

	hook.Run("TTT2UpdatingNetworkingData", self, key, val)

	dataTbl.value = val

	if SERVER then
		net.Start(dataTbl.nwStr)
		net.WriteEntity(self)

		WriteNetworkingData(self, key)

		if ply_or_rf then
			net.Send(ply_or_rf)
		else
			net.Broadcast()
		end
	end
end

if SERVER then
	util.AddNetworkString("TTT2SyncNetworkingData")

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
else
	local function TTT2SyncNetworkingData()
		local ply = net.ReadEntity()
		if not IsValid(ply) then return end

		for k, v in pairs(defaultNetworkingDataTable) do
			ReadNetworkingData(ply, k)
		end
	end
	net.Receive("TTT2SyncNetworkingData", TTT2SyncNetworkingData)
end

function plymeta:ResetNetworkingData()
	self.networking = table.Copy(defaultNetworkingDataTable)
end
