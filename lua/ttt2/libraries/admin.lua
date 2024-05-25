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

---
-- Restarts the current round.
-- @note When called on the client the local player had to be a super admin.
-- @realm shared
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

---
-- Kills the given player.
-- @param Player ply The player to kill
-- @note When called on the client the local player had to be a super admin.
-- @realm shared
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

---
-- Teleports a player to the provided position.
-- @param Player ply The player to teleport
-- @param Vector pos The position
-- @note The player has to be alive to be teleported.
-- @note When called on the client the local player had to be a super admin.
-- @realm shared
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

---
-- Respawns a player at the provided position.
-- @param Player ply The player to respawn
-- @param Vector pos The position
-- @note The player has to be dead to be respawned.
-- @note When called on the client the local player had to be a super admin.
-- @realm shared
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

---
-- Adds the given amount of credits to that player.
-- @param Player ply The player to receive credits
-- @param number The amount of credits the player should receive
-- @note When called on the client the local player had to be a super admin.
-- @realm shared
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

---
-- Sets the health of the given player.
-- @param Player ply The player that should update their health
-- @param number The amount of health the player should receive
-- @note When called on the client the local player had to be a super admin.
-- @realm shared
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

---
-- Sets the armor of the given player.
-- @param Player ply The player that should update their armor
-- @param number The amount of armor the player should receive
-- @note When called on the client the local player had to be a super admin.
-- @realm shared
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
        ---
        -- @realm server
        -- stylua: ignore
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
