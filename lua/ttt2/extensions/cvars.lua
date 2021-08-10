---
-- cvars exentsions
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

if CLIENT then
	local function ChangeServerConVar(conVarName, value, OnReceiveFunc)
		local serverConVar = serverConVars[conVarName]
		local netWrite = netWriter[serverConVar.type]

		if not isfunction(netWriter) then return end

		messageIdentifier = (messageIdentifier + 1) % maxUInt
		functionCache[messageIdentifier] = OnReceiveFunc

		net.Start("TTT2ChangeServerConVar")
		net.WriteUInt(messageIdentifier, identityBitCount)
		net.WriteString(conVarName, serverConVar.bitCount)
		netWrite(value)
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

	function cvars.RegisterServerConVar(conVarName, type, bitCount)
		serverConVars[conVarName] = {type = type, bitCount = bitCount}

		net.Start("TTT2RegisterConVarType")
		net.WriteString(conVarName)
		net.WriteString(type)
		net.WriteUInt(bitCount or 0, identityBitCount)
		net.SendToServer()
	end
elseif SERVER then
	util.AddNetworkString("TTT2ChangeServerConVar")
	util.AddNetworkString("TTT2ConVarExistsOnServer")
	util.AddNetworkString("TTT2RegisterConVarType")

	local function ReceiveChangeServerConVar(len, ply)
		if len < 1 then return end

		local identifier = net.ReadUInt(identityBitCount)
		local conVarName = net.ReadString()
		local conVar = serverConVars[conVarName]

		local netRead = netReader[conVar.type]
		local value = netRead(conVar.bitCount)

		net.Start("TTT2ChangeServerConVar")
		net.WriteUInt(identifier, identityBitCount)

		local isSuccess = ply:IsAdmin()

		net.WriteBool(isSuccess)
		net.Send(ply)

		if not isSuccess then return end

		RunConsoleCommand(conVarName, value)
	end

	net.Receive("TTT2ChangeServerConVar", ReceiveChangeServerConVar)

	local function ReceiveConVarExistsRequest(len, ply)
		if len < 1 then return end

		local identifier = net.ReadUInt(identityBitCount)
		local conVarName = net.ReadString()

		net.Start("TTT2ConVarExistsOnServer")
		net.WriteUInt(identifier, identityBitCount)
		net.WriteBool(ConVarExists(conVarName))
		net.Send(ply)
	end

	net.Receive("TTT2ConVarExistsOnServer", ReceiveConVarExistsRequest)

	local function RegisterConVarType(len, ply)
		if len < 1 then return end

		local conVarName = net.ReadString()
		local type = net.ReadString()
		local bitCount = net.ReadUInt(identityBitCount)

		if not ply:IsAdmin() and not ConVarExists(conVarName) then return end

		if bitCount == 0 then
			bitCount = nil
		end

		serverConVars[conVarName] = {type = type, bitCount = bitCount}
	end

	net.Receive("TTT2RegisterConVarType", RegisterConVarType)
end