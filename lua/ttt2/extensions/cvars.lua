---
-- cvars extensions
-- @author ZenBreaker
-- @module cvars

if SERVER then
    AddCSLuaFile()
end

local cvars = cvars

local messageIdentifier = 0
local identityBitCount = 8
local maxUInt = 2 ^ identityBitCount - 1

local serverConVars = {}
local functionCache = {}

local sendRequestsNextUpdate = false
local requestCacheSize = 0
local requestCache = {}

local playersCache = {}
local broadcastTable = {}

if CLIENT then
    ---
    -- Checks if the conVar exists on the server or was already cached
    -- @param string conVarName
    -- @param function OnReceiveFunc The function that gets called with a boolean whether the conVar exists
    -- @realm client
    function cvars.ConVarExistsOnServer(conVarName, OnReceiveFunc)
        if serverConVars[conVarName] then
            OnReceiveFunc(true)

            return
        end

        messageIdentifier = messageIdentifier % maxUInt + 1
        functionCache[messageIdentifier] = OnReceiveFunc

        net.Start("TTT2ConVarExistsOnServer")
        net.WriteUInt(messageIdentifier, identityBitCount)
        net.WriteString(conVarName)
        net.SendToServer()
    end

    net.Receive("TTT2ConVarExistsOnServer", function(len)
        if len < 1 then
            return
        end

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
        if len < 1 then
            return
        end

        local conVarName = net.ReadString()
        local conVar = serverConVars[conVarName] or { value = "" }

        local oldValue = conVar.value
        local newValue = net.ReadString()

        conVar.value = newValue
        serverConVars[conVarName] = conVar

        cvars.OnConVarChanged(conVarName, oldValue, newValue)
    end)

    local function SendAllServerConVarRequests()
        sendRequestsNextUpdate = false

        if requestCacheSize < 1 then
            return
        end

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
    end

    ---
    -- Get the conVar's current and default value of if it exists on the server or was already cached
    -- @param string conVarName
    -- @param function OnReceiveFunc The function that gets called with the following parameters: boolean, whether the convar exists; any, the value of the convar; any, the default of the convar
    -- @realm client
    function cvars.ServerConVarGetValue(conVarName, OnReceiveFunc)
        local conVar = serverConVars[conVarName] or {}

        if conVar.value and conVar.default then
            OnReceiveFunc(true, conVar.value, conVar.default)

            return
        end

        messageIdentifier = messageIdentifier % maxUInt + 1
        functionCache[messageIdentifier] = OnReceiveFunc

        requestCacheSize = requestCacheSize + 1
        requestCache[requestCacheSize] = { identifier = messageIdentifier, conVarName = conVarName }

        if not sendRequestsNextUpdate then
            sendRequestsNextUpdate = true

            timer.Simple(0, SendAllServerConVarRequests)
        end
    end

    net.Receive("TTT2ServerConVarGetValue", function(len)
        if len < 1 then
            return
        end

        local requestSize = net.ReadUInt(identityBitCount)

        for i = 1, requestSize do
            local identifier = net.ReadUInt(identityBitCount)
            local wasSuccess = net.ReadBool()
            local value = nil
            local default = nil

            if wasSuccess then
                local conVarName = net.ReadString()
                value = net.ReadString()
                default = net.ReadString()
                serverConVars[conVarName] = {
                    value = value,
                    default = default,
                }
            end

            local receiveFunc = functionCache[identifier]

            if isfunction(receiveFunc) then
                receiveFunc(wasSuccess, value, default)
                functionCache[identifier] = nil
            end
        end
    end)
elseif SERVER then
    util.AddNetworkString("TTT2ConVarExistsOnServer")
    util.AddNetworkString("TTT2ChangeServerConVar")
    util.AddNetworkString("TTT2ServerConVarGetValue")

    net.Receive("TTT2ConVarExistsOnServer", function(len, ply)
        if len < 1 then
            return
        end

        local identifier = net.ReadUInt(identityBitCount)
        local conVarName = net.ReadString()

        net.Start("TTT2ConVarExistsOnServer")
        net.WriteUInt(identifier, identityBitCount)
        net.WriteBool(ConVarExists(conVarName))
        net.Send(ply)
    end)

    net.Receive("TTT2ChangeServerConVar", function(len, ply)
        if len < 1 then
            return
        end

        local conVarName = net.ReadString()
        local value = net.ReadString()

        if not admin.IsAdmin(ply) then
            return
        end

        RunConsoleCommand(conVarName, value)
    end)

    local function BroadcastServerConVarChanges(conVarName, oldValue, newValue)
        if oldValue == newValue then
            return
        end

        net.Start("TTT2ChangeServerConVar")
        net.WriteString(conVarName)
        net.WriteString(newValue)
        net.Send(broadcastTable)
    end

    net.Receive("TTT2ServerConVarGetValue", function(len, ply)
        if len < 1 then
            return
        end

        local isAdmin = admin.IsAdmin(ply)

        requestCacheSize = net.ReadUInt(identityBitCount)
        requestCache = {}

        for i = 1, requestCacheSize do
            local identifier = net.ReadUInt(identityBitCount)
            local conVarName = net.ReadString()

            requestCache[i] = { identifier = identifier, conVarName = conVarName }
        end

        net.Start("TTT2ServerConVarGetValue")
        net.WriteUInt(requestCacheSize, identityBitCount)

        for i = 1, requestCacheSize do
            local request = requestCache[i]
            local isSuccess = ConVarExists(request.conVarName) and isAdmin

            net.WriteUInt(request.identifier, identityBitCount)
            net.WriteBool(isSuccess)

            if not isSuccess then
                continue
            end

            net.WriteString(request.conVarName)

            local conVar = GetConVar(request.conVarName)

            net.WriteString(conVar:GetString())
            net.WriteString(conVar:GetDefault())

            cvars.AddChangeCallback(
                request.conVarName,
                BroadcastServerConVarChanges,
                "TTT2ServerConVarGetValueCallback"
            )
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
        if not IsValid(ply) or not playersCache[ply:SteamID64()] then
            return
        end

        playersCache[ply:SteamID64()] = nil
        table.RemoveByValue(broadcastTable, ply)
    end)
end
