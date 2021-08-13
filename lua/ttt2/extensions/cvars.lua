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

		net.Start("TTT2ServerConVarGetValue")
		net.WriteUInt(messageIdentifier, identityBitCount)
		net.WriteString(conVarName)
		net.SendToServer()
	end

	net.Receive("TTT2ServerConVarGetValue", function(len)
		if len <  1 then return end

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

		net.Start("TTT2ChangeServerConVar")
		net.WriteString(conVarName)
		net.WriteString(value)
		net.Broadcast()

		RunConsoleCommand(conVarName, value)
	end)

	net.Receive("TTT2ServerConVarGetValue", function(len, ply)
		if len < 1 then return end

		local identifier = net.ReadUInt(identityBitCount)
		local conVarName = net.ReadString()

		net.Start("TTT2ServerConVarGetValue")
		net.WriteUInt(identifier, identityBitCount)

		local isSuccess = ConVarExists(conVarName) and IsValid(ply) and ply:IsSuperAdmin()
		net.WriteBool(isSuccess)

		if isSuccess then
			net.WriteString(conVarName)
			net.WriteString(GetConVar(conVarName):GetString())
		end

		net.Send(ply)
	end)
end
