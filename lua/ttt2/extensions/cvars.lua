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
local functionCache = {}

local requestCacheSize = 0
local requestCache = {}

local playersCache = {}
local broadcastTable = {}

if CLIENT then
	---
	-- Checks if the conVar exists on the server or was already cached
	-- @param string conVarName
	-- @param function OnReceiveFunc(conVarExists) The function that gets called with the result if the conVar exists
	-- @realm client
	function cvars.ConVarExistsOnServer(conVarName, OnReceiveFunc)
		if serverConVars[conVarName] then
			OnReceiveFunc(true)
			return
		end

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
			functionCache[identifier] = nil
		end
	end)

	---
	-- Changes the conVar on the server if it exists and the user has admin rights
	-- @param string conVarName
	-- @param any value 
	-- @note ConVar values are saved as strings and are therefore converted
	-- @realm client
	function cvars.ChangeServerConVar(conVarName, value)
		net.Start("TTT2ChangeServerConVar")
		net.WriteString(conVarName)
		net.WriteString(tostring(value))
		net.SendToServer()
	end

	net.Receive("TTT2ChangeServerConVar", function(len)
		if len <  1 then return end

		local conVarName = net.ReadString()
		local oldValue = serverConVars[conVarName] or ""
		local newValue = net.ReadString()

		serverConVars[conVarName] = newValue

		cvars.OnConVarChanged(conVarName, oldValue, newValue)
	end)

	---
	-- Get the value of the conVar if it exists on the server or was already cached
	-- @param string conVarName
	-- @param function OnReceiveFunc(conVarExists, value) The function that gets called with the results if the conVar exists
	-- @realm client
	function cvars.ServerConVarGetValue(conVarName, OnReceiveFunc)
		if serverConVars[conVarName] then
			OnReceiveFunc(true, serverConVars[conVarName])
			return
		end

		messageIdentifier = (messageIdentifier + 1) % maxUInt
		functionCache[messageIdentifier] = OnReceiveFunc

		requestCacheSize = requestCacheSize + 1
		requestCache[requestCacheSize] = {identifier = messageIdentifier, conVarName = conVarName}
	end

	hook.Add("Think", "TTT2CheckServerConVarRequests", function()
		if requestCacheSize < 1 then return end

		net.Start("TTT2ServerConVarGetValue")
		net.WriteUInt(requestCacheSize, identityBitCount)

		for i = 1, requestCacheSize do
			local request = requestCache[i]

			net.WriteUInt(request.identifier, identityBitCount)
			net.WriteString(request.conVarName)
		end

		net.SendToServer()

		requestCacheSize = 0
		requestCache = {}
	end)

	net.Receive("TTT2ServerConVarGetValue", function(len)
		if len <  1 then return end

		local requestSize = net.ReadUInt(identityBitCount)

		for i = 1, requestSize do
			local identifier = net.ReadUInt(identityBitCount)
			local wasSuccess = net.ReadBool()
			local value = nil

			if wasSuccess then
				local conVarName = net.ReadString()
				value = net.ReadString()
				serverConVars[conVarName] = value
			end

			local receiveFunc = functionCache[identifier]

			if isfunction(receiveFunc) then
				receiveFunc(wasSuccess, value)
				functionCache[identifier] = nil
			end
		end

	end)
elseif SERVER then
	util.AddNetworkString("TTT2ConVarExistsOnServer")
	util.AddNetworkString("TTT2ChangeServerConVar")
	util.AddNetworkString("TTT2ServerConVarGetValue")

	net.Receive("TTT2ConVarExistsOnServer", function(len, ply)
		if len < 1 then return end

		local identifier = net.ReadUInt(identityBitCount)
		local conVarName = net.ReadString()

		net.Start("TTT2ConVarExistsOnServer")
		net.WriteUInt(identifier, identityBitCount)
		net.WriteBool(ConVarExists(conVarName))
		net.Send(ply)
	end)

	net.Receive("TTT2ChangeServerConVar", function(len, ply)
		if len < 1 then return end

		local conVarName = net.ReadString()
		local value = net.ReadString()

		if not IsValid(ply) or not ply:IsSuperAdmin() then return end

		RunConsoleCommand(conVarName, value)
	end)

	local function BroadcastServerConVarChanges(conVarName, oldValue, newValue)
		if oldValue == newValue then return end

		net.Start("TTT2ChangeServerConVar")
		net.WriteString(conVarName)
		net.WriteString(newValue)
		net.Send(broadcastTable)
	end

	net.Receive("TTT2ServerConVarGetValue", function(len, ply)
		if len < 1 then return end

		local isAdmin = IsValid(ply) and ply:IsSuperAdmin()

		requestCacheSize = net.ReadUInt(identityBitCount)
		requestCache = {}

		for i = 1, requestCacheSize do
			local identifier = net.ReadUInt(identityBitCount)
			local conVarName = net.ReadString()

			requestCache[i] = {identifier = identifier, conVarName = conVarName}
		end

		net.Start("TTT2ServerConVarGetValue")
		net.WriteUInt(requestCacheSize, identityBitCount)

		for i = 1, requestCacheSize do
			local request = requestCache[i]
			local isSuccess = ConVarExists(request.conVarName) and isAdmin

			net.WriteUInt(request.identifier, identityBitCount)
			net.WriteBool(isSuccess)

			if not isSuccess then continue end

			net.WriteString(request.conVarName)
			net.WriteString(GetConVar(request.conVarName):GetString())

			cvars.AddChangeCallback(request.conVarName, BroadcastServerConVarChanges, "TTT2ServerConVarGetValueCallback")
		end

		net.Send(ply)

		if isAdmin then
			local plyId = ply:SteamID64()

			if not playersCache[plyId] then
				playersCache[plyId] = true
				broadcastTable[#broadcastTable + 1] = ply
			end
		end
	end)

	hook.Add("PlayerDisconnected", "TTT2RemovePlayerOfConVarBroadcastTable", function(ply)
		if not IsValid(ply) or not playersCache[ply:SteamID64()] then return end

		playersCache[ply:SteamID64()] = nil
		table.RemoveByValue(broadcastTable, ply)
	end)
end
