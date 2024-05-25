---
-- Handles the whole round structure. The game always starts in the prepare phase. Then it
-- advances to begin, only to end in End. To start a new round, the post round is triggered
-- which starts the map cleanup. Once that cleanup is done, the game moves on with the next
-- prepare phase.
-- @author Mineotopia
-- @module round

if SERVER then
    AddCSLuaFile()

    util.AddNetworkString("TTT_ClearClientState")
end

---
-- @realm server
-- stylua: ignore
local cvLevelTimeLimit = CreateConVar("ttt_time_limit_minutes", "75", SERVER and {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED)

---
-- @realm server
-- stylua: ignore
local cvRoundLimit = CreateConVar("ttt_round_limit", "6", SERVER and {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED)


---
-- @realm server
-- stylua: ignore
local cvDetectiveMode = CreateConVar("ttt_sherlock_mode", "1", SERVER and {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED)

---
-- @realm server
-- stylua: ignore
local cvHasteMode = CreateConVar("ttt_sherlock_mode", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

gameloop = {}

if SERVER then
    ---
    -- @realm server
    -- stylua: ignore
    local cvDurationPrepPhase = CreateConVar("ttt_preptime_seconds", "30", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

    ---
    -- @realm server
    -- stylua: ignore
    local cvDurationFirstPrepPhase = CreateConVar("ttt_firstpreptime", "60", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

    ---
    -- @realm server
    -- stylua: ignore
    local cvDurationRound = CreateConVar("ttt_roundtime_minutes", "10", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

    ---
    -- @realm server
    -- stylua: ignore
    local cvDurationEndPhase = CreateConVar("ttt_posttime_seconds", "30", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

    ---
    -- @realm server
    -- stylua: ignore
    local cvTimeHasteStarting = CreateConVar("ttt_haste_starting_minutes", "5", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

    ---
    -- @realm server
    -- stylua: ignore
    local cvMinPlayers = CreateConVar("ttt_minimum_players", "2", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

    -- defines if this is the first round played on this level, some special
    -- care should be taken if it is the first round
    gameloop.firstRound = true

    -- the time when the current round started
    gameloop.timeRoundStart = 0

    -- the win type when triggered by a map
    gameloop.mapWinType = WIN_NONE

    function gameloop.Initialize()
        gameloop.SetRoundsLeft(cvRoundLimit:GetInt())

        SetRoundState(ROUND_WAIT)

        gameloop.WaitForPlayers()
    end

    function gameloop.Prepare()
        -- if not enough players are available, we go into a idle state where
        -- the game periodically tries again to start a new round until enough
        -- player were found
        if gameloop.CheckForAbort() then --TODO new function
            return
        end

        -- some addons like (map-)vote addons might want to delay the next prep phase
        -- therefore this hook here allows the prepare round to be delayed

        ---
        -- @realm server
        -- stylua: ignore
        local shouldDelayRound, lengthDelay = hook.Run("TTTDelayRoundStartForVote")

        if shouldDelayRound then
            lengthDelay = lengthDelay or 30

            LANG.MsgAll("round_voting", { num = lengthDelay })

            timer.Create("delayedprep", lengthDelay, 1, gameloop.Prepare)

            return
        end

        -- update the round state that is used to determine how the game behaves
        SetRoundState(ROUND_PREP)

        -- triggers the round state output for every map setting entity
        ents.TTT.TriggerRoundStateOutputs(ROUND_PREP)

        -- create a timer to schedule the round begin
        local timePrepPhase = cvDurationPrepPhase:GetInt()

        if gameloop.firstRound then
            timePrepPhase = cvDurationFirstPrepPhase:GetInt()

            gameloop.firstRound = false

            -- the start time is set once the first prep phase begins
            -- that way idling on a map doesn't decrease the map time
            gameloop.SetLevelStartTime(CurTime())
        end

        gameloop.mapWinType = WIN_NONE

        -- reset the role of all players on the server and client
        -- this is important because SendFullStateUpdate only sends changes to the client
        roleselection.ResetAllPlayers()

        gameloop.ClearClientState()

        -- TODO: if a player is ready via `TTT2PlayerFinishedReloading` or `TTT2PlayerReady` these
        -- timers should be updated again
        gameloop.SetPhaseEnd(CurTime() + timePrepPhase)

        -- starts the preparing phase timer that transitions from the preparing phase to the active round
        timer.Create("prep2begin", timePrepPhase, 1, gameloop.Begin)

        ---
        -- @realm server
        -- stylua: ignore
        hook.Run("TTT2PrePrepareRound", timePrepPhase)

        ---
        -- @realm server
        -- stylua: ignore
        hook.Run("TTTPrepareRound")

        LANG.Msg("round_begintime", { num = timePrepPhase })
    end

    function gameloop.Begin()
        -- check for low-karma players that weren't kicked/banned on round end
        KARMA.RoundBegin()

        -- if not enough players are available, we go into a idle state where
        -- the game periodically tries again to start a new round until enough
        -- player were found
        if gameloop.CheckForAbort() then
            return
        end

        -- respawn players that died during the preparing phase
        entspawn.SpawnPlayers(true)

        -- remove their ragdolls as well
        ents.TTT.RemoveRagdolls(true)

        -- select role; this is where things really start so we can't abort anymore
        -- this function also syncs the roles to all connected clients
        roleselection.SelectRoles()

        -- update the round state that is used to determine how the game behaves
        SetRoundState(ROUND_ACTIVE)

        -- triggers the round state output for every map setting entity
        ents.TTT.TriggerRoundStateOutputs(ROUND_ACTIVE)

        local timeRoundEnd = CurTime() + cvDurationRound:GetInt() * 60

        if gameloop.IsHasteMode() then
            timeRoundEnd = CurTime() + cvTimeHasteStarting:GetInt() * 60

            -- this is a "fake" time shown to innocents, showing the end time if no
            -- one would have been killed, it has no gameplay effect
            SetGlobalFloat("ttt_haste_end", timeRoundEnd)
        end

        gameloop.SetPhaseEnd(timeRoundEnd)

        -- Start the win condition check timer
        StartWinChecks() -- todo new function/s
        StartNameChangeChecks() -- todo new function

        -- todo: trigger the menu at round begin with role info
        --timer.Simple(1.5, TellTraitorsAboutTraitors)
        --timer.Simple(2.5, ShowRoundStartPopup)

        ServerLog("Round proper has begun...\n")

        ---
        -- @realm server
        -- stylua: ignore
        hook.Run("TTT2PreBeginRound")

        ---
        -- @realm server
        -- stylua: ignore
        hook.Run("TTTBeginRound")
    end

    function gameloop.End(result)
        KARMA.RoundEnd()

        -- update the round state that is used to determine how the game behaves
        SetRoundState(ROUND_POST)

        -- triggers the round state output for every map setting entity
        ents.TTT.TriggerRoundStateOutputs(ROUND_POST, result)

        PrintResultMessage(result) -- todo what does this do?

        local timeEndPhase = math.max(5, cvDurationEndPhase:GetInt())

        --LANG.Msg("win_showreport", { num = timeEndPhase }) -- todo remove as well

        timer.Create("end2prep", timeEndPhase, 1, gameloop.Post)

        gameloop.SetPhaseEnd(CurTime() + timeEndPhase)

        -- Stop checking for wins
        StopWinChecks()

        -- send each client the role setup, reveal every player
        local rlsList = roles.GetList()

        for i = 1, #rlsList do
            SendSubRoleList(rlsList[i].index)
        end

        -- We may need to start a timer for a mapswitch, or start a vote
        if GetGlobalBool("ttt_session_limits_enabled") then
            gameloop.CheckForMapSwitch()
        end

        ---
        -- @realm server
        -- stylua: ignore
        hook.Run("TTT2PreEndRound", result, timeEndPhase)

        ---
        -- @realm server
        -- stylua: ignore
        hook.Run("TTTEndRound", result)
    end

    function gameloop.Post()
        gameloop.DecreaseRoundsLeft()

        game.CleanUpMap(false, nil, ents.TTT.FixParentedPostCleanup)

        -- todo move somewhere else?
        -- Strip players now, so that their weapons are not seen by ReplaceEntities
        --local plys = player.GetAll()

        --for i = 1, #plys do
        --local v = plys[i]

        --v:StripWeapons()
        --plys[i]:SetRole(ROLE_NONE)
        --end

        --SendFullStateUpdate()

        -- Remove ULX /me command. (the /me command is the only thing this hook does)
        hook.Remove("PlayerSay", "ULXMeCheck")
    end

    function gameloop.Reset()
        gameloop.firstRound = true
        gameloop.SetRoundsLeft(cvRoundLimit:GetInt())
        gameloop.SetLevelStartTime(CurTime())

        SetRoundState(ROUND_WAIT)
        gameloop.WaitForPlayers()
    end

    function gameloop.ClearClientState(ply)
        net.Start("TTT_ClearClientState")

        if IsValid(ply) then
            net.Send(ply)
        else
            net.Broadcast()
        end
    end

    -- todo maybe called at any time a player is ready to update/clear all important variables
    function gameloop.PlayerReady(ply)
        gameloop.ClearClientState(ply)

        -- set the synced data to ROLE_NONE, TEAM_NONE on the server so a new full update
        -- is forced for this client
        RoleResetForPlayer(ply)

        -- this should fix issues where late joiners don't receive the data
        SendFullStateUpdate()
    end

    ---
    -- Sets the synced phase end time variable
    -- @param number time time
    -- @realm server
    -- @internal
    function gameloop.SetPhaseEnd(time)
        SetGlobalFloat("ttt_round_end", time)
    end

    function gameloop.SetLevelStartTime(time)
        SetGlobalFloat("ttt_map_start", time)
    end

    function gameloop.SetRoundsLeft(num)
        SetGlobalInt("ttt_rounds_left", num)
    end

    function gameloop.DecreaseRoundsLeft(num)
        num = num or 1

        gameloop.SetRoundsLeft(math.max(0, gameloop.GetRoundsLeft() - num))
    end

    function gameloop.HasEnoughPlayers()
        local ready = 0

        -- only count truly available players, i.e. no forced specs
        local plys = player.GetAll()

        for i = 1, #plys do
            local ply = plys[i]

            if not IsValid(ply) or not ply:ShouldSpawn() then
                continue
            end

            ready = ready + 1
        end

        return ready >= cvMinPlayers:GetInt()
    end

    ---
    -- This @{function} is used to create the timers that checks
    -- whether is the round is able to start (enough players?)
    -- @note Used to be in Think/Tick, now in a timer
    -- @note this stops @{WaitForPlayers}
    -- @realm server
    -- @see WaitForPlayers
    -- @internal
    function gameloop.WaitingForPlayersChecker()
        if GetRoundState() ~= ROUND_WAIT or not gameloop.HasEnoughPlayers() then
            return
        end

        timer.Create("wait2prep", 1, 1, gameloop.Post)
        timer.Stop("waitingforply")
    end

    ---
    -- Start waiting for players
    -- @realm server
    -- @see WaitingForPlayersChecker
    -- @internal
    function gameloop.WaitForPlayers()
        SetRoundState(ROUND_WAIT)

        if timer.Start("waitingforply") then
            return
        end

        timer.Create("waitingforply", 2, 0, gameloop.WaitingForPlayersChecker)
    end

    ---
    -- Stops the timers in order to restart a gameloop.
    -- @realm server
    function gameloop.StopTimers()
        -- remove all timers
        timer.Stop("wait2prep")
        timer.Stop("prep2begin")
        timer.Stop("end2prep")
        timer.Stop("winchecker")
    end

    ---
    -- Make sure we have the players to do a round, people can leave during our
    -- preparations so we'll call this numerous times
    -- @return boolean
    -- @realm server
    function gameloop.CheckForAbort()
        if not gameloop.HasEnoughPlayers() then
            LANG.Msg("round_minplayers")

            gameloop.StopTimers()
            gameloop.WaitForPlayers()

            return true
        end

        return false
    end

    ---
    -- Checks whether the map is able to switch based on round limits and time limits.
    -- @realm server
    -- @internal
    function gameloop.CheckForMapSwitch()
        local roundsLeft = gameloop.GetRoundsLeft()
        local timeLeft = gameloop.GetLevelTimeLeft()
        local nextMap = string.upper(game.GetMapNext())

        if roundsLeft <= 0 or timeLeft <= 0 then
            gameloop.StopTimers()
            gameloop.SetPhaseEnd(CurTime())

            ---
            -- @realm server
            -- stylua: ignore
            hook.Run("TTT2LoadNextMap", nextMap, roundsLeft, timeLeft)
        else
            LANG.Msg("limit_left", { num = roundsLeft, time = math.ceil(timeLeft / 60) })
        end
    end
end

if CLIENT then
    net.Receive("TTT_ClearClientState", function()
        ---
        -- @realm client
        -- stylua: ignore
        hook.Run("ClearClientState")
    end)
end

function gameloop.GetPhaseEnd()
    return GetGlobalFloat("ttt_round_end", 0)
end

function gameloop.GetLevelStartTime()
    return GetGlobalFloat("ttt_map_start", 0)
end

function gameloop.GetRoundsLeft()
    return GetGlobalInt("ttt_rounds_left", 0)
end

function gameloop.GetLevelTimeLeft()
    return math.max(0, cvLevelTimeLimit:GetInt() * 60 - CurTime() + gameloop.GetLevelStartTime())
end

---
-- Returns whether the detective mode is enabled
-- @return boolean
-- @realm shared
function gameloop.IsDetectiveMode()
    return cvDetectiveMode:GetBool()
end

---
-- Returns whether the haste mode is enabled
-- @return boolean
-- @realm shared
function gameloop.IsHasteMode()
    return cvHasteMode:GetBool()
end

DetectiveMode = gameloop.IsDetectiveMode
HasteMode = gameloop.IsHasteMode

-- HOOKS to sv main --

if SERVER then
---
-- @realm server
-- stylua: ignore
local cvPreferMapModels = CreateConVar("ttt2_prefer_map_models", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
local cvSelectModelPerRound = CreateConVar("ttt2_select_model_per_round", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

    function GM:TTT2PrePrepareRound(duration)
        events.Reset()
        KARMA.RoundPrepare()

        -- todo: this muting here seems like a bad idea - rework?
        -- mute for a second around role selection, to counter a dumb exploit
        -- related to team voice mics cutting off for a second when they're selected
        timer.Create("selectmute", duration - 1, 1, function()
            MuteForRestart(true)
        end)

        -- undo the roundrestart mute, though they will once again be muted for the
        -- selectmute timer
        timer.Create("restartmute", 1, 1, function()
            MuteForRestart(false)
        end)

        -- sets the player model
        -- supports map models or random player models
        if cvPreferMapModels:GetBool() and self.force_plymodel and self.force_plymodel ~= "" then
            self.playermodel = self.force_plymodel
        elseif cvSelectModelPerRound:GetBool() then
            self.playermodel = playermodels.GetRandomPlayerModel()
        end

    ---
    -- @realm server
    -- stylua: ignore
    self.playercolor = hook.Run("TTTPlayerColor", self.playermodel)
    end

    function GM:TTT2PreBeginRound(duration)
        -- remove decals
        util.ClearDecals()

        timer.Create("selectmute", 1, 1, function()
            MuteForRestart(false)
        end)

        ResetDamageLog()

        events.Trigger(EVENT_SELECTED)

        self:UpdatePlayerLoadouts() -- needs to happen when round_active

        ARMOR:InitPlayerArmor()

        local plys = player.GetAll()

        for i = 1, #plys do
            local ply = plys[i]

            ply:ResetRoundDeathCounter()

            -- a player should be considered "was active in round" if they received a role
            ply:SetActiveInRound(ply:Alive() and ply:IsTerror())
        end

        credits.ResetTeamStates()
    end

    function GM:TTT2PreEndRound(result, duration)
        events.Trigger(EVENT_FINISH, result)

        events.UpdateScoreboard()

        -- send the clients the round log, players will be shown the report
        events.StreamToClients()
    end
end
