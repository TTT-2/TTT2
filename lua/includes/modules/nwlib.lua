local net = net
local tostring = tostring
local tonumber = tonumber
local tobool = tobool

module("nwlib", package.seeall)

---
-- @param string key
-- @param string typ
-- @param nil|number bits
-- @param nil|bool unsigned
-- @param any value
function GenerateDataTable(key, typ, bits, unsigned, value)
	local dataTbl = {}
	dataTbl.key = key
	dataTbl.type = typ

	if typ == "number" then
		dataTbl.bits = bits
		dataTbl.unsigned = unsigned
	end

	dataTbl.value = value

	return dataTbl
end

if SERVER then
	AddCSLuaFile()

	function WriteNetworkingData(data, val)
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

	---
	-- Initializes a new table data index for any player
	-- @local
	function WriteNewDataTbl(index, key, data, val)
		net.WriteUInt(index - 1, 16) -- there is no table with index 0 so decreasing it
		net.WriteString(key)
		net.WriteString(data.type)

		if data.type == "number" then
			net.WriteUInt(data.bits - 1, 5) -- max 32 bits
			net.WriteBool(data.unsigned)
		end

		WriteNetworkingData(data, val)
	end
else
	function ReadNetworkingData(data)
		if data.type == "number" then
			if data.unsigned then
				return net.ReadUInt(data.bits or 32)
			else
				return net.ReadInt(data.bits or 32)
			end
		elseif data.type == "bool" then
			return net.ReadBool()
		elseif data.type == "float" then
			return net.ReadFloat()
		else
			return net.ReadString()
		end
	end

	---
	-- Initializes a new table data index for any player
	-- @local
	function ReadNewDataTbl()
		local index = net.ReadUInt(16) + 1
		local k = net.ReadString()
		local typ = net.ReadString()

		local dataTbl

		if typ == "number" then
			dataTbl = GenerateDataTable(k, typ, net.ReadUInt(5) + 1, net.ReadBool())
		else
			dataTbl = GenerateDataTable(k, typ)
		end

		dataTbl.value = ReadNetworkingData(dataTbl)

		return dataTbl
	end
end

function GenerateNetworkingDataString(key)
	return "T2SND_" .. key
end

function ParseData(val, typ)
	if data.type == "number" or data.type == "float" then
		return tonumber(val)
	elseif data.type == "bool" then
		return tobool(val)
	end

	return tostring(val)
end
