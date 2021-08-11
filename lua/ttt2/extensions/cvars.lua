---
-- cvars extensions
-- @author ZenBreaker
-- @module cvars

if SERVER then
	AddCSLuaFile()
end

local cvars = cvars

local messageIdentifier = -1
local identityBitCount = 8
local maxUInt = 2 ^ identityBitCount
local serverConVars = {}
local conVarNameCache = {}
local functionCache = {}
local netWriter = {
				["int"] = net.WriteInt,
				["float"] = net.WriteFloat,
				["bool"] = net.WriteBool,
				["string"] = net.WriteString,
				}
local netReader = {
				["int"] = net.ReadInt,
				["float"] = net.ReadFloat,
				["bool"] = net.ReadBool,
				["string"] = net.ReadString,
				}
local conVarGetValue = {
				["int"] = ConVar.GetInt,
				["float"] = ConVar.GetFloat,
				["bool"] = ConVar.GetBool,
				["string"] = ConVar.GetString,
				}

-- Determine necessary rights here, either .IsAdmin or .IsSuperAdmin
local IsAdmin = Player.IsAdmin

if CLIENT then
	function cvars.RegisterServerConVar(conVarName, type, bitCount)
		serverConVars[conVarName] = {type = type, bitCount = bitCount}

		net.Start("TTT2RegisterConVarType")
		net.WriteString(conVarName)
		net.WriteString(type)
		net.WriteUInt(bitCount or 0, identityBitCount)
		net.SendToServer()
	end

	function cvars.ConVarExistsOnServer(conVarName, OnReceiveFunc)
		messageIdentifier = (messageIdentifier + 1) % maxUInt
		functionCache[messageIdentifier] = OnReceiveFunc

		net.Start("TTT2ConVarExistsOnServer")
		net.WriteUInt(messageIdentifier, identityBitCount)
		net.WriteString(conVarName)
		net.SendToServer()
	end

	net.Receive("TTT2ConVarExistsOnServer", function(len)
		if len <  1 then return end

		local identifier = net.ReadUInt(identityBitCount)
		local conVarExists = net.ReadBool()
		local receiveFunc = functionCache[identifier]

		if isfunction(receiveFunc) then
			receiveFunc(conVarExists)
		end
	end)

	local function ChangeServerConVar(conVarName, value, OnReceiveFunc)
		local serverConVar = serverConVars[conVarName]
		local netWrite = netWriter[serverConVar.type]

		if not isfunction(netWriter) then return end

		messageIdentifier = (messageIdentifier + 1) % maxUInt
		functionCache[messageIdentifier] = OnReceiveFunc

		net.Start("TTT2ChangeServerConVar")
		net.WriteUInt(messageIdentifier, identityBitCount)
		net.WriteString(conVarName)
		netWrite(value, serverConVar.bitCount)
		net.SendToServer()
	end

	function cvars.ChangeServerConVar(conVarName, value, OnReceiveFunc, type, bitCount)
		if not serverConVars[conVarName] then
			if not type or (type == "int" and not bitCount) then
				OnReceiveFunc(false)
				return
			end

			cvars.ConVarExistsOnServer(conVarName, function(conVarExists)
				if not conVarExists then
					OnReceiveFunc(false)
					return
				end

				cvars.RegisterServerConVar(conVarName, type, bitCount)
				ChangeServerConVar(conVarName, value, OnReceiveFunc)
			end)

			return
		end

		ChangeServerConVar(conVarName, value, OnReceiveFunc)
	end

	net.Receive("TTT2ChangeServerConVar", function(len)
		if len <  1 then return end

		local identifier = net.ReadUInt(identityBitCount)
		local wasSuccess = net.ReadBool()
		local receiveFunc = functionCache[identifier]

		if isfunction(receiveFunc) then
			receiveFunc(wasSuccess)
		end
	end)

	function cvars.ServerConVarGetValue(conVarName, OnReceiveFunc, type, bitCount)
		messageIdentifier = (messageIdentifier + 1) % maxUInt
		conVarNameCache[messageIdentifier] = conVarName
		functionCache[messageIdentifier] = OnReceiveFunc

		net.Start("TTT2ServerConVarGetValue")
		net.WriteUInt(messageIdentifier, identityBitCount)
		net.WriteString(conVarName)

		local additionalInfo = type and not (type == "int" and not bitCount)
		net.WriteBool(additionalInfo)

		local serverConVar = serverConVars[conVarName]
		if serverConVar then
			type = serverConVar.type
			bitCount = serverConVar.bitCount
		end

		if additionalInfo then
			net.WriteString(type)
			net.WriteUInt(bitCount or 0, identityBitCount)
		end

		net.SendToServer()
	end

	net.Receive("TTT2ServerConVarGetValue", function(len)
		if len <  1 then return end

		local identifier = net.ReadUInt(identityBitCount)
		local wasSuccess = net.ReadBool()
		local value = nil

		if wasSuccess then
			local conVar = serverConVars[conVarNameCache[identifier]]
			local netRead = netReader[conVar.type]

			value = netRead(conVar.bitCount)
		end

		local receiveFunc = functionCache[identifier]

		if isfunction(receiveFunc) then
			receiveFunc(wasSuccess, value)
		end
	end)
elseif SERVER then
	util.AddNetworkString("TTT2RegisterConVarType")
	util.AddNetworkString("TTT2ConVarExistsOnServer")
	util.AddNetworkString("TTT2ChangeServerConVar")
	util.AddNetworkString("TTT2ServerConVarGetValue")

	local function RegisterConVarTypeRequest(len, ply)
		if len < 1 then return end

		local conVarName = net.ReadString()
		local type = net.ReadString()
		local bitCount = net.ReadUInt(identityBitCount)

		if not IsAdmin(ply) and not ConVarExists(conVarName) then return end

		if bitCount == 0 then
			bitCount = nil
		end

		serverConVars[conVarName] = {type = type, bitCount = bitCount, conVar = GetConVar(conVarName)}
	end

	net.Receive("TTT2RegisterConVarType", RegisterConVarTypeRequest)

	local function ConVarExistsRequest(len, ply)
		if len < 1 then return end

		local identifier = net.ReadUInt(identityBitCount)
		local conVarName = net.ReadString()

		net.Start("TTT2ConVarExistsOnServer")
		net.WriteUInt(identifier, identityBitCount)
		net.WriteBool(ConVarExists(conVarName))
		net.Send(ply)
	end

	net.Receive("TTT2ConVarExistsOnServer", ConVarExistsRequest)

	local function ChangeServerConVarRequest(len, ply)
		if len < 1 then return end

		local identifier = net.ReadUInt(identityBitCount)
		local conVarName = net.ReadString()
		local conVar = serverConVars[conVarName]

		local netRead = netReader[conVar.type]
		local value = netRead(conVar.bitCount)

		net.Start("TTT2ChangeServerConVar")
		net.WriteUInt(identifier, identityBitCount)

		local isSuccess = IsAdmin(ply)

		net.WriteBool(isSuccess)
		net.Send(ply)

		if not isSuccess then return end

		RunConsoleCommand(conVarName, value)
	end

	net.Receive("TTT2ChangeServerConVar", ChangeServerConVarRequest)

	local function ConVarGetValueRequest(len, ply)
		if len < 1 then return end

		local identifier = net.ReadUInt(identityBitCount)
		local conVarName = net.ReadString()
		local additionalInfo = net.ReadBool()

		local type
		local bitCount

		if additionalInfo then
			type = net.ReadString()
			bitCount = net.ReadUInt(identityBitCount)
		end

		net.Start("TTT2ServerConVarGetValue")
		net.WriteUInt(identifier, identityBitCount)

		local serverConVar = serverConVars[conVarName]
		local isSuccess = IsAdmin(ply) and (serverConVar or additionalInfo)
		net.WriteBool(isSuccess)

		if isSuccess then
			local conVar = serverConVar and serverConVar.conVar or {type = type, bitCount = bitCount}
			local getValue = conVarGetValue[serverConVar.type]

			local netWrite = netWriter[serverConVar.type]

			netWrite(getValue(conVar), serverConVar.bitCount)
		end

		net.Send(ply)
	end

	net.Receive("TTT2ServerConVarGetValue", ConVarGetValueRequest)
end
