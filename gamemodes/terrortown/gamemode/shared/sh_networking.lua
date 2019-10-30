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

plymeta.networking = table.Copy(defaultNetworkingDataTable)

---
-- Returns the stored networking key
-- @param string key
-- @return any value
function plymeta:GetNetworkingData(key)
	if not self.networking[key] then return end

	return self.networking[key].value
end

---
-- Sets the networking data
-- @warning this does not sync the data like a NWVar!
-- @param string key
-- @param any value
function plymeta:SetNetworkingData(key, val)
	-- do not allow new entries that possible are not shared! Prevent async issues
	if self.networking[key] == nil then
		MsgN("[TTT2] New networking keys are not allowed in ply:SetNetworkingData() function.")

		return
	end

	if self.networking[key].value == val then return end

	self.networking[key].value = val

	-- TODO start cached network message if SERVER!
end

if SERVER then
	util.AddNetworkString("TTT2SyncNetworkingData")

	---
	-- Syncs the networking data of a @{Player} with the current @{Player} COMPLETELY
	function plymeta:SyncNetworkingData(ply)
		net.Start("TTT2SyncNetworkingData")
		net.WriteEntity(ply)

		for _, v in pairs(ply.networking) do
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

		net.Send(self)
	end
else
	local function TTT2SyncNetworkingData()
		local ply = net.ReadEntity()
		if not IsValid(ply) then return end

		for k, v in pairs(defaultNetworkingDataTable) do
			if v.type == "number" then
				if v.unsigned then
					ply.networking[k] = net.ReadUInt(v.bits or 32)
				else
					ply.networking[k] = net.ReadInt(v.bits or 32)
				end
			elseif v.type == "bool" then
				ply.networking[k] = net.ReadBool()
			else
				ply.networking[k] = net.ReadString()
			end
		end
	end
	net.Receive("TTT2SyncNetworkingData", TTT2SyncNetworkingData)
end

function plymeta:ResetNetworkingData()
	self.networking = table.Copy(defaultNetworkingDataTable)
end
