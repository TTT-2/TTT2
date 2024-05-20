---
-- Shared administrative functions
-- @author Mineotopia
-- @module admin

if SERVER then
    AddCSLuaFile()

    util.AddNetworkString("TTT2AdminCommand")
end

local ADMIN_COMMAND_RESTART = 1
local ADMIN_COMMAND_SLAY = 2
local ADMIN_COMMAND_TELEPORT = 3
local ADMIN_COMMAND_RESPAWN = 4
local ADMIN_COMMAND_CREDITS = 5
local ADMIN_COMMAND_HEALTH = 6
local ADMIN_COMMAND_ARMOR = 7

admin = admin or {}

function admin.RoundRestart()
    if CLIENT then
        net.Start("TTT2AdminCommand")
        net.WriteUInt(ADMIN_COMMAND_RESTART, 4)
        net.SendToServer()
    end

    if SERVER then
        StopRoundTimers()
        PrepareRound()
    end
end

function admin.PlayerSlay(ply)
    if CLIENT then
        net.Start("TTT2AdminCommand")
        net.WriteUInt(ADMIN_COMMAND_SLAY, 4)
        net.WritePlayer(ply)
        net.SendToServer()
    end

    if SERVER then
        ply:Kill()
    end
end

function admin.PlayerTeleport(ply, pos)
    if CLIENT then
        net.Start("TTT2AdminCommand")
        net.WriteUInt(ADMIN_COMMAND_TELEPORT, 4)
        net.WritePlayer(ply)
        net.WriteVector(pos)
        net.SendToServer()
    end

    if SERVER then
        if not ply:IsTerror() then
            return
        end

        ply:SetPos(pos)
    end
end

function admin.PlayerRespawn(ply, pos)
    if CLIENT then
        net.Start("TTT2AdminCommand")
        net.WriteUInt(ADMIN_COMMAND_RESPAWN, 4)
        net.WritePlayer(ply)
        net.WriteVector(pos)
        net.SendToServer()
    end

    if SERVER then
        if ply:IsTerror() then
            return
        end

        ply:Revive(0, nil, nil, false, false, nil, pos)
    end
end

function admin.PlayerAddCredits(ply, amount)
    if CLIENT then
        net.Start("TTT2AdminCommand")
        net.WriteUInt(ADMIN_COMMAND_CREDITS, 4)
        net.WritePlayer(ply)
        net.WriteUInt(amount, 16)
        net.SendToServer()
    end

    if SERVER then
        ply:AddCredits(amount)
    end
end

function admin.PlayerSetHealth(ply, amount)
    if CLIENT then
        net.Start("TTT2AdminCommand")
        net.WriteUInt(ADMIN_COMMAND_HEALTH, 4)
        net.WritePlayer(ply)
        net.WriteUInt(amount, 16)
        net.SendToServer()
    end

    if SERVER then
        ply:SetHealth(amount)
    end
end

function admin.PlayerSetArmor(ply, amount)
    if CLIENT then
        net.Start("TTT2AdminCommand")
        net.WriteUInt(ADMIN_COMMAND_ARMOR, 4)
        net.WritePlayer(ply)
        net.WriteUInt(amount, 16)
        net.SendToServer()
    end

    if SERVER then
        ply:SetMaxArmor(math.max(ply:GetMaxArmor(), amount))
        ply:SetArmor(amount)
    end
end

if SERVER then
    net.Receive("TTT2AdminCommand", function(_, ply)
        if not IsValid(ply) or not hook.Run("TTT2AdminCheck", ply) then
            return
        end

        local command = net.ReadUInt(4)

        if command == ADMIN_COMMAND_RESTART then
            admin.RoundRestart()
        elseif command == ADMIN_COMMAND_SLAY then
            admin.PlayerSlay(net.ReadPlayer())
        elseif command == ADMIN_COMMAND_TELEPORT then
            admin.PlayerTeleport(net.ReadPlayer(), net.ReadVector())
        elseif command == ADMIN_COMMAND_RESPAWN then
            admin.PlayerRespawn(net.ReadPlayer(), net.ReadVector())
        elseif command == ADMIN_COMMAND_CREDITS then
            admin.PlayerAddCredits(net.ReadPlayer(), net.ReadUInt(16))
        elseif command == ADMIN_COMMAND_HEALTH then
            admin.PlayerSetHealth(net.ReadPlayer(), net.ReadUInt(16))
        elseif command == ADMIN_COMMAND_ARMOR then
            admin.PlayerSetArmor(net.ReadPlayer(), net.ReadUInt(16))
        end
    end)
end
