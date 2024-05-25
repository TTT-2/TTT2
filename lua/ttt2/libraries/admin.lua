---
-- Shared administrative functions
-- @author Mineotopia
-- @module admin

if SERVER then
    AddCSLuaFile()

    util.AddNetworkString("TTT2AdminCommand")
end

local ADMIN_COMMAND_RESTART = 1
local ADMIN_COMMAND_RESET = 2
local ADMIN_COMMAND_SLAY = 3
local ADMIN_COMMAND_TELEPORT = 4
local ADMIN_COMMAND_RESPAWN = 5
local ADMIN_COMMAND_CREDITS = 6
local ADMIN_COMMAND_HEALTH = 7
local ADMIN_COMMAND_ARMOR = 8

admin = {}

---
-- Restarts the current gameloop.
-- @note When called on the client the local player has to be a super admin.
-- @realm shared
function admin.RoundRestart()
    if CLIENT then
        net.Start("TTT2AdminCommand")
        net.WriteUInt(ADMIN_COMMAND_RESTART, 4)
        net.SendToServer()
    end

    if SERVER then
        gameloop.StopTimers()
        gameloop.Post()
    end
end

---
-- Resets the current level.
-- @note When called on the client the local player has to be a super admin.
-- @realm shared
function admin.LevelReset()
    if CLIENT then
        net.Start("TTT2AdminCommand")
        net.WriteUInt(ADMIN_COMMAND_RESET, 4)
        net.SendToServer()
    end

    if SERVER then
        gameloop.StopTimers()
        gameloop.Reset()

        --todo set karma and score
    end
end

---
-- Kills the given player.
-- @param Player ply The player to kill
-- @note When called on the client the local player has to be a super admin.
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
-- @note When called on the client the local player has to be a super admin.
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
-- @note When called on the client the local player has to be a super admin.
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
-- @note When called on the client the local player has to be a super admin.
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
-- @note When called on the client the local player has to be a super admin.
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
-- @note When called on the client the local player has to be a super admin.
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
        elseif command == ADMIN_COMMAND_RESET then
            admin.LevelReset()
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

    ---
    -- Version announce also used in @{GM:Initialize}.
    -- @param Player ply The player that shoulld receive the version message
    -- @realm server
    function admin.ShowVersion(ply)
        local text = Format(
            "This is [TTT2] Trouble in Terrorist Town 2 (Advanced Update) - by the TTT2 Dev Team (v%s)\n",
            GAMEMODE.Version
        )

        if IsValid(ply) then
            LANG.Msg(ply, text, nil, MSG_MSTACK_WARN)
        else
            Msg(text)
        end
    end

    -- CLASSIC TTT COMMANDS

    concommand.Add("ttt_roundrestart", admin.RoundRestart)

    concommand.Add("ttt_version", admin.ShowVersion)
end
