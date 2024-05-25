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
    util.AddNetworkString("TTT_RoundState")
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
local cvHasteMode = CreateConVar("ttt_sherlock_mode", "1", SERVER and {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED)

---
-- @realm server
-- stylua: ignore
local cvSessionLimits = CreateConVar("ttt_session_limits_enabled", "1", SERVER and {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED)

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

    ---
    -- @realm server
    -- stylua: ignore
    local cvPreventWin = CreateConVar("ttt_debug_preventwin", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

    ---
    -- @realm server
    -- stylua: ignore
    local cvNameChangeKick = CreateConVar("ttt_namechange_kick", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

    ---
    -- @realm server
    -- stylua: ignore
    local cvNameChangeKickBanTime = CreateConVar("ttt_namechange_bantime", "10", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

    -- defines if this is the first round played on this level, some special
    -- care should be taken if it is the first round
    gameloop.firstRound = true

    -- the time when the current round started
    gameloop.timeRoundStart = 0

    -- the win type when triggered by a map
    gameloop.mapWinType = WIN_NONE

    function gameloop.Initialize()
        gameloop.SetRoundsLeft(cvRoundLimit:GetInt())

        gameloop.SetRoundState(ROUND_WAIT)

        gameloop.WaitForPlayers()
    end

    function gameloop.Prepare()
        -- if not enough players are available, we go into a idle state where
        -- the game periodically tries again to start a new round until enough
        -- player were found
        if gameloop.CheckForAbort() then
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
        gameloop.SetRoundState(ROUND_PREP)

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
        gameloop.SetRoundState(ROUND_ACTIVE)

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
        gameloop.StartWinChecks()
        gameloop.StartNameChangeChecks()

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
        gameloop.SetRoundState(ROUND_POST)

        -- triggers the round state output for every map setting entity
        ents.TTT.TriggerRoundStateOutputs(ROUND_POST, result)

        -- print the round result to the console
        PrintResultMessage(result)

        local timeEndPhase = math.max(5, cvDurationEndPhase:GetInt())

        timer.Create("end2prep", timeEndPhase, 1, gameloop.Post)

        gameloop.SetPhaseEnd(CurTime() + timeEndPhase)
        gameloop.StopWinChecks()

        -- send each client the role setup, reveal every player
        local rlsList = roles.GetList()

        for i = 1, #rlsList do
            SendSubRoleList(rlsList[i].index)
        end

        -- We may need to start a timer for a mapswitch, or start a vote
        gameloop.CheckForMapSwitch()

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

        -- Remove ULX /me command. (the /me command is the only thing this hook does)
        hook.Remove("PlayerSay", "ULXMeCheck")
    end

    local function NameChangeKick()
        if not cvNameChangeKick:GetBool() then
            timer.Remove("namecheck")

            return
        end

        if gameloop.GetRoundState() ~= ROUND_ACTIVE then
            return
        end

        local plys = player.GetAll()

        for i = 1, #plys do
            local ply = plys[i]

            if not ply.spawn_nick then
                ply.spawn_nick = ply:Nick()

                continue
            end

            ---
            -- @realm server
            -- stylua: ignore
            if
                ply:IsBot()
                or not ply.has_spawned
                or ply.spawn_nick == ply:Nick()
                or hook.Run("TTTNameChangeKick", ply)
            then
                continue
            end

            local timeBan = cvNameChangeKickBanTime:GetInt()
            local textMessage = "Changed name during a round"

            if timeBan > 0 then
                ply:KickBan(timeBan, textMessage)
            else
                ply:Kick(textMessage)
            end
        end
    end

    ---
    -- This function is used to install a timer that checks for name changes.
    -- and kicks @{Player} if it's activated.
    -- @realm server
    -- @internal
    function gameloop.StartNameChangeChecks()
        if not cvNameChangeKick:GetBool() then
            return
        end

        -- bring nicks up to date, may have been changed during prep/post
        local plys = player.GetAll()

        for i = 1, #plys do
            local ply = plys[i]

            ply.spawn_nick = ply:Nick()
        end

        if not timer.Exists("namecheck") then
            timer.Create("namecheck", 3, 0, NameChangeKick)
        end
    end

    ---
    -- This is the win condition checker
    -- @realm server
    -- @internal
    local function WinChecker()
        if gameloop.GetRoundState() ~= ROUND_ACTIVE or cvPreventWin:GetBool() then
            return
        end

        if CurTime() > GetGlobalFloat("ttt_round_end", 0) then
            gameloop.End(WIN_TIMELIMIT)
        else
            ---
            -- @realm server
            -- stylua: ignore
            local win = hook.Run("TTT2PreWinChecker", preventWin)

            ---
            -- @realm server
            -- stylua: ignore
            win = win or hook.Run("TTTCheckForWin", preventWin)

            if win == WIN_NONE then
                return
            end

            gameloop.End(win)
        end
    end

    ---
    -- This function install the win condition checker (with a timer).
    -- @realm server
    -- @internal
    function gameloop.StartWinChecks()
        if not timer.Start("winchecker") then
            timer.Create("winchecker", 0.5, 0, WinChecker)
        end
    end

    ---
    -- This function stops the win condition checker (the timer).
    -- @realm server
    -- @internal
    function gameloop.StopWinChecks()
        timer.Stop("winchecker")
    end

    function gameloop.Reset()
        gameloop.firstRound = true
        gameloop.SetRoundsLeft(cvRoundLimit:GetInt())
        gameloop.SetLevelStartTime(CurTime())

        gameloop.SetRoundState(ROUND_WAIT)
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

    function gameloop.PlayerReady(ply)
        gameloop.ClearClientState(ply)
        gameloop.SendRoundState(ply)

        -- set the synced data to ROLE_NONE, TEAM_NONE on the server so a new full update
        -- is forced for this client
        RoleResetForPlayer(ply)

        -- this should fix issues where late joiners don't receive the data
        SendFullStateUpdate()

        -- maybe we need to trigegr syncing of global bools/ints as well? or are they automatically
        -- synced on connect?
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
        if gameloop.GetRoundState() ~= ROUND_WAIT or not gameloop.HasEnoughPlayers() then
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
        gameloop.SetRoundState(ROUND_WAIT)

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
        if not gameloop.HasLevelLimits() then
            return
        end

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

    ---
    -- This function is used to trigger the round syncing. It is called automatically if
    -- the state is updated by @{gameloop.SetRoundState}.
    -- @param[opt] Player ply if nil, this will broadcast to every connected @{PLayer}
    -- @realm server
    function gameloop.SendRoundState(ply)
        net.Start("TTT_RoundState")
        net.WriteUInt(gameloop.GetRoundState(), 3)

        if IsValid(ply) then
            net.Send(ply)
        else
            net.Broadcast()
        end
    end

    ---
    -- Sets the current round state
    -- @param number state The new round state
    -- @realm server
    function gameloop.SetRoundState(state)
        gameloop.roundState = state
        gameloop.SendRoundState()

        events.Trigger(EVENT_GAME, state)
    end
end

if CLIENT then
    ---
    -- @realm client
    -- stylua: ignore
    local cvSoundCues = CreateConVar("ttt_cl_soundcues", "0", FCVAR_ARCHIVE, "Optional sound cues on round start and end")

    local cues = {
        Sound("ttt/thump01e.mp3"),
        Sound("ttt/thump02e.mp3"),
    }

    local function PlaySoundCue()
        if not cvSoundCues:GetBool() then
            return
        end

        surface.PlaySound(cues[math.random(#cues)])
    end

    function gameloop.RoundStateChange(oldRoundState, newRoundState)
        if nnewRoundState == ROUND_PREP then
            EPOP:Clear()

            -- show warning to spec mode players
            if GetConVar("ttt_spectator_mode"):GetBool() and IsValid(LocalPlayer()) then
                LANG.Msg("spec_mode_warning", nil, MSG_CHAT_WARN)
            end

            -- reset cached server language in case it has changed
            RunConsoleCommand("_ttt_request_serverlang")

            -- clear decals in cache from previous round
            util.ClearDecals()

            local client = LocalPlayer()

            -- Resets bone positions that fixes broken fingers on bad addons.
            -- When late-joining a server this function is executed before the local player
            -- is completely set up. Therefore we safeguard this with this check.
            if IsValid(client) and isfunction(client.GetViewModel) then
                weaponrenderer.ResetBonePositions(client:GetViewModel())
            end
        elseif newRoundState == ROUND_ACTIVE then
            VOICE.CycleMuteState(MUTE_NONE)

            CLSCORE:ClearPanel()

            -- people may have died and been searched during prep
            local plys = playerGetAll()
            for i = 1, #plys do
                bodysearch.ResetSearchResult(plys[i])
            end

            -- clear blood decals produced during prep
            util.ClearDecals()

            GAMEMODE.StartingPlayers = #util.GetAlivePlayers()

            PlaySoundCue()
        elseif newRoundState == ROUND_POST then
            RunConsoleCommand("ttt_cl_traitorpopup_close")

            PlaySoundCue()
        end

        -- stricter checks when we're talking about hooks, because this function may
        -- be called with for example old = WAIT and new = POST, for newly connecting
        -- players, which hooking code may not expect
        if newRoundState == ROUND_PREP then
            ---
            -- Can enter PREP from any phase due to ttt_roundrestart
            -- @realm shared
            -- stylua: ignore
            hook.Run("TTTPrepareRound")
        elseif oldRoundState == ROUND_PREP and n == ROUND_ACTIVE then
            ---
            -- @realm shared
            -- stylua: ignore
            hook.Run("TTTBeginRound")
        elseif oldRoundState == ROUND_ACTIVE and n == ROUND_POST then
            ---
            -- @realm shared
            -- stylua: ignore
            hook.Run("TTTEndRound")
        end

        -- whatever round state we get, clear out the voice flags
        local winTeams = roles.GetWinTeams()
        local plys = player.GetAll()

        for i = 1, #plys do
            for k = 1, #winTeams do
                plys[i][winTeams[k] .. "_gvoice"] = false
            end
        end
    end

    net.Receive("TTT_ClearClientState", function()
        ---
        -- @realm client
        -- stylua: ignore
        hook.Run("ClearClientState")
    end)

    -- Round state comm
    net.Receive("TTT_RoundState", function()
        local oldRoundState = gameloop.GetRoundState()

        gameloop.roundState = net.ReadUInt(3)

        if oldRoundState ~= gameloop.roundState then
            gameloop.RoundStateChange(oldRoundState, gameloop.roundState)
        end

        Dev(1, "New round state: " .. gameloop.roundState)
    end)
end

---
-- Returns the current round state.
-- @return number
-- @realm shared
function gameloop.GetRoundState()
    return gameloop.roundState
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
-- Returns whether the detective mode is enabled.
-- @return boolean
-- @realm shared
function gameloop.IsDetectiveMode()
    return cvDetectiveMode:GetBool()
end

---
-- Returns whether the haste mode is enabled.
-- @return boolean
-- @realm shared
function gameloop.IsHasteMode()
    return cvHasteMode:GetBool()
end

---
-- Returns whether the level has session limits like time or round count.
-- @return boolean
-- @realm shared
function gameloop.HasLevelLimits()
    return cvSessionLimits:GetBool()
end

-- old function name aliases
DetectiveMode = gameloop.IsDetectiveMode
HasteMode = gameloop.IsHasteMode
SetRoundState = gameloop.SetRoundState
GetRoundState = gameloop.GetRoundState
