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
local cvLevelTimeLimit = CreateConVar(
    "ttt_time_limit_minutes",
    "75",
    SERVER and { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED } or FCVAR_REPLICATED
)

---
-- @realm server
local cvRoundLimit = CreateConVar(
    "ttt_round_limit",
    "6",
    SERVER and { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED } or FCVAR_REPLICATED
)

---
-- @realm server
local cvDetectiveMode = CreateConVar(
    "ttt_sherlock_mode",
    "1",
    SERVER and { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED } or FCVAR_REPLICATED
)

---
-- @realm server
local cvHasteMode = CreateConVar(
    "ttt_haste",
    "1",
    SERVER and { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED } or FCVAR_REPLICATED
)

---
-- @realm server
local cvSessionLimits = CreateConVar(
    "ttt_session_limits_mode",
    "1",
    SERVER and { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED } or FCVAR_REPLICATED
)

gameloop = {}

if SERVER then
    ---
    -- @realm server
    local cvDurationPrepPhase =
        CreateConVar("ttt_preptime_seconds", "30", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

    ---
    -- @realm server
    local cvDurationFirstPrepPhase =
        CreateConVar("ttt_firstpreptime", "60", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

    ---
    -- @realm server
    local cvDurationRound =
        CreateConVar("ttt_roundtime_minutes", "10", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

    ---
    -- @realm server
    local cvDurationEndPhase =
        CreateConVar("ttt_posttime_seconds", "30", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

    ---
    -- @realm server
    local cvTimeHasteStarting =
        CreateConVar("ttt_haste_starting_minutes", "5", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

    ---
    -- @realm server
    local cvMinPlayers = CreateConVar("ttt_minimum_players", "2", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

    ---
    -- @realm server
    local cvPreventWin = CreateConVar("ttt_debug_preventwin", "0", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

    ---
    -- @realm server
    local cvNameChangeKick =
        CreateConVar("ttt_namechange_kick", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

    ---
    -- @realm server
    local cvNameChangeKickBanTime =
        CreateConVar("ttt_namechange_bantime", "10", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

    -- defines if this is the first round played on this level, some special
    -- care should be taken if it is the first round
    gameloop.firstRound = true

    -- the time when the current round started
    gameloop.timeRoundStart = 0

    -- the win type when triggered by a map
    gameloop.mapWinType = WIN_NONE

    ---
    -- Initializes the game loop. Sets up all variables and starts waiting for players.
    -- Is valled from @{GM:Initialize}.
    -- @internal
    -- @realm server
    function gameloop.Initialize()
        gameloop.SetRoundsLeft(cvRoundLimit:GetInt())
        gameloop.SetPhaseEnd(-1)
        gameloop.SetHasteEnd(-1)
        gameloop.SetRoundState(ROUND_WAIT)

        gameloop.WaitForPlayers()
    end

    ---
    -- Starts the preparation phase. Handles all setup needed to prepare a new round.
    -- @internal
    -- @realm server
    function gameloop.Prepare()
        loadingscreen.End()

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

        -- make sure that the duration of the loading screen is added to the
        -- duration of the prep time
        timePrepPhase = timePrepPhase + loadingscreen.GetDuration()

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
        hook.Run("TTT2PrePrepareRound", timePrepPhase)

        ---
        -- @realm server
        hook.Run("TTTPrepareRound")

        LANG.Msg("round_begintime", { num = timePrepPhase })
    end

    ---
    -- Starts the active phase. Handles all setup needed to run an active round.
    -- @internal
    -- @realm server
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
            gameloop.SetHasteEnd(timeRoundEnd)
        end

        gameloop.SetPhaseEnd(timeRoundEnd)
        gameloop.StartWinChecks()
        gameloop.StartNameChangeChecks()

        ServerLog("Round proper has begun...\n")

        ---
        -- @realm server
        hook.Run("TTT2PreBeginRound")

        ---
        -- @realm server
        hook.Run("TTTBeginRound")
    end

    ---
    -- Starts the wnd phase. Handles all setup needed to end a round.
    -- @param string|number result The winning team or the win type
    -- @internal
    -- @realm server
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
        hook.Run("TTT2PreEndRound", result, timeEndPhase)

        ---
        -- @realm server
        hook.Run("TTTEndRound", result)
    end

    ---
    -- Is called after round end and cleans up the current round, calls the map cleanup and
    -- therefore prepares the start of the next round.
    -- @param[opt] boolean keepRoundCount Set to true to prevent the round count decrease
    -- @internal
    -- @realm server
    function gameloop.Post(keepRoundCount)
        loadingscreen.Begin()

        if not keepRoundCount then
            gameloop.DecreaseRoundsLeft()
        end

        -- delay the cleanup a bit so that the client starts the loading screen animation before the
        -- cleanup starts
        -- note: delaying by a single tick seemed to be ineffective
        timer.Simple(0.25, function()
            game.CleanUpMap(false, nil, ents.TTT.FixParentedPostCleanup)
        end)

        -- Remove ULX /me command. (the /me command is the only thing this hook does)
        hook.Remove("PlayerSay", "ULXMeCheck")
    end

    ---
    -- Resets the current level to its initial state. This not only restarts the round,
    -- it also resets everything so that it acts as if the level was changed.
    -- @internal
    -- @realm server
    function gameloop.Reset()
        gameloop.firstRound = true

        gameloop.SetRoundsLeft(cvRoundLimit:GetInt())
        gameloop.SetLevelStartTime(CurTime())
        gameloop.SetRoundState(ROUND_WAIT)

        gameloop.WaitForPlayers()
    end

    ---
    -- Clears the client state. This is needed for a new round to clear everything carried
    -- over from the previous round.
    -- @param[opt] Player ply Define a player here to only clear their state, leave nil to clear all players
    -- @internal
    -- @realm server
    function gameloop.ClearClientState(ply)
        net.Start("TTT_ClearClientState")

        if IsValid(ply) then
            net.Send(ply)
        else
            net.Broadcast()
        end
    end

    ---
    -- When a player is ready while the round is still active, they are updated with this function.
    -- It sets everything relevant to them. This is called from @{GM:TTT2PlayerReady.
    -- @param Player ply The player that just got ready
    -- @internal
    -- @realm server
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

            if
                ply:IsBot()
                or not ply.has_spawned
                or ply.spawn_nick == ply:Nick()
                ---
                -- @realm server
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

    local function WinChecker()
        if gameloop.GetRoundState() ~= ROUND_ACTIVE or cvPreventWin:GetBool() then
            return
        end

        if CurTime() > gameloop.GetPhaseEnd() then
            gameloop.End(WIN_TIMELIMIT)
        else
            ---
            -- @realm server
            local win = hook.Run("TTT2PreWinChecker")

            ---
            -- @realm server
            win = win or hook.Run("TTTCheckForWin")

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

    ---
    -- Increases the global round end time variable.
    -- @param number time The time addition
    -- @realm server
    -- @internal
    function gameloop.IncreasePhaseEnd(time)
        gameloop.SetPhaseEnd(gameloop.GetPhaseEnd() + time)
    end

    ---
    -- Sets the synced phase end time variable.
    -- @param number time time
    -- @realm server
    -- @internal
    function gameloop.SetPhaseEnd(time)
        SetGlobalFloat("ttt_round_end", time)
    end

    ---
    -- Sets the synced haste end time variable.
    -- @param number time time
    -- @realm server
    -- @internal
    function gameloop.SetHasteEnd(time)
        SetGlobalFloat("ttt_haste_end", time)
    end

    ---
    -- Sets the level start time. It is the time when the first preparing phase started.
    -- @param number time The start time
    -- @internal
    -- @realm server
    function gameloop.SetLevelStartTime(time)
        SetGlobalFloat("ttt_map_start", time)
    end

    ---
    -- Sets the amount of rounds left to be played on this level.
    -- @param number num The amount it is set to
    -- @internal
    -- @realm server
    function gameloop.SetRoundsLeft(num)
        SetGlobalInt("ttt_rounds_left", num)
    end

    ---
    -- Decresed the amount of rounds left to be played on this level.
    -- @param[default=1] number num The amount it is decreased by
    -- @internal
    -- @realm server
    function gameloop.DecreaseRoundsLeft(num)
        num = num or 1

        gameloop.SetRoundsLeft(math.max(0, gameloop.GetRoundsLeft() - num))
    end

    local function HasEnoughPlayers()
        local ready = 0

        -- only count truly available players, i.e. no forced specs
        local plys = player.GetAll()

        for i = 1, #plys do
            local ply = plys[i]

            if not IsValid(ply) or not ply:ShouldSpawn() or not ply:IsReady() then
                continue
            end

            ready = ready + 1
        end

        return ready >= cvMinPlayers:GetInt()
    end

    ---
    -- This function is used to create the timers that checks whether is the round
    -- is able to start.
    -- @return boolean Returns true if there are enough players for the next round
    -- @internal
    -- @realm server
    function gameloop.WaitingForPlayersChecker()
        if gameloop.GetRoundState() ~= ROUND_WAIT or not HasEnoughPlayers() then
            return false
        end

        gameloop.Post()

        timer.Stop("waitingforply")

        return true
    end

    ---
    -- Start waiting for players.
    -- @see gameloop.WaitingForPlayersChecker
    -- @internal
    -- @realm server
    function gameloop.WaitForPlayers()
        gameloop.SetRoundState(ROUND_WAIT)

        if gameloop.WaitingForPlayersChecker() or timer.Start("waitingforply") then
            return
        end

        timer.Create("waitingforply", 2, 0, gameloop.WaitingForPlayersChecker)
    end

    ---
    -- Make sure we have the players to do a round, people can leave during our
    -- preparations so we'll call this numerous times. Also stops the timers.
    -- @return boolean Returns if the round should be aborted because there are npt
    -- enough players for a valid round
    -- @internal
    -- @realm server
    function gameloop.CheckForAbort()
        if not HasEnoughPlayers() then
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

        if roundsLeft == 0 or timeLeft == 0 then
            gameloop.StopTimers()
            gameloop.SetPhaseEnd(CurTime())

            ---
            -- @realm server
            hook.Run("TTT2LoadNextMap", nextMap, roundsLeft, timeLeft)
        else
            LANG.Msg(
                "limit_left_session_mode_" .. gameloop.GetLevelLimitsMode(),
                { num = roundsLeft, time = math.ceil(timeLeft / 60) }
            )
        end
    end

    ---
    -- Stops the timers in order to restart a gameloop.
    -- @realm server
    function gameloop.StopTimers()
        timer.Stop("prep2begin")
        timer.Stop("end2prep")
        timer.Stop("winchecker")
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
        -- note: this is stored on the GAMEMODE table for two reasons:
        -- - it is compatible with addons that try to access this variable directly
        -- - it is hotreload safe because the table is kept on reload
        GAMEMODE.round_state = state

        gameloop.SendRoundState()

        events.Trigger(EVENT_GAME, state)
    end

    hook.Add("TTT2LoadNextMap", "MapVoteCompat", function(nextMap, roundsLeft, timeLeft)
        if not isfunction(CheckForMapSwitch) then
            return
        end

        ErrorNoHalt(
            "[TTT2] Using deprecated map vote overwrite. Replace your map vote addon and contact the addon developer."
        )

        CheckForMapSwitch()

        return true
    end)
end

if CLIENT then
    ---
    -- @realm client
    local cvSoundCues = CreateConVar(
        "ttt_cl_soundcues",
        "0",
        FCVAR_ARCHIVE,
        "Optional sound cues on round start and end"
    )

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

    ---
    -- Clientside function that handles the internal round state change.
    -- @param number oldRoundState The old round state
    -- @param number newRoundState The new round state
    -- @internal
    -- @realm client
    function gameloop.RoundStateChange(oldRoundState, newRoundState)
        if newRoundState == ROUND_PREP then
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
            local plys = player.GetAll()
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
            hook.Run("TTTPrepareRound")
        elseif oldRoundState == ROUND_PREP and newRoundState == ROUND_ACTIVE then
            ---
            -- @realm shared
            hook.Run("TTTBeginRound")
        elseif oldRoundState == ROUND_ACTIVE and newRoundState == ROUND_POST then
            ---
            -- @realm shared
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

    ---
    -- Returns the amount of rounds and time left until the map changes.
    -- @return number The amount of rounds left
    -- @return string The amount of time left as hh:mm:ss
    -- @realm client
    function gameloop.UntilMapChange()
        local roundsLeft = gameloop.GetRoundsLeft()
        local timeLeft = math.floor(gameloop.GetLevelTimeLeft())

        local hours = math.floor(timeLeft / 3600)

        timeLeft = timeLeft - math.floor(hours * 3600)

        local minutes = math.floor(timeLeft / 60)

        timeLeft = timeLeft - math.floor(minutes * 60)

        local seconds = math.floor(timeLeft)

        return roundsLeft, string.format("%02i:%02i:%02i", hours, minutes, seconds)
    end

    net.Receive("TTT_ClearClientState", function()
        ---
        -- @realm client
        hook.Run("ClearClientState")
    end)

    -- Round state comm
    net.Receive("TTT_RoundState", function()
        local oldRoundState = gameloop.GetRoundState()

        GAMEMODE.round_state = net.ReadUInt(3)

        if oldRoundState ~= GAMEMODE.round_state then
            gameloop.RoundStateChange(oldRoundState, GAMEMODE.round_state)
        end

        Dev(1, "New round state: " .. GAMEMODE.round_state)
    end)
end

---
-- Returns the current round state.
-- @return number The current round state
-- @realm shared
function gameloop.GetRoundState()
    return GAMEMODE.round_state
end

---
-- Returns the current phase end time.
-- @return number The phase end time
-- @realm shared
function gameloop.GetPhaseEnd()
    return GetGlobalFloat("ttt_round_end", 0)
end

---
-- Returns the current haste end time.
-- @return number The haste end time
-- @realm shared
function gameloop.GetHasteEnd()
    return GetGlobalFloat("ttt_haste_end", 0)
end

---
-- Returns the level start time.
-- @return number The level start time
-- @realm shared
function gameloop.GetLevelStartTime()
    return GetGlobalFloat("ttt_map_start", 0)
end

---
-- Returns the amount of rounds left on this level.
-- @return number The amound of rounds left
-- @realm shared
function gameloop.GetRoundsLeft()
    local sessionMode = gameloop.GetLevelLimitsMode()
    return (sessionMode == 1 or sessionMode == 3)
            and math.max(0, GetGlobalInt("ttt_rounds_left", 0))
        or -1
end

---
-- Returns the remaining time left on this level.
-- @return number The time left on this level
-- @realm shared
function gameloop.GetLevelTimeLeft()
    local sessionMode = gameloop.GetLevelLimitsMode()
    return (sessionMode == 1 or sessionMode == 2)
            and math.max(
                0,
                cvLevelTimeLimit:GetInt() * 60 - CurTime() + gameloop.GetLevelStartTime()
            )
        or -1
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
    return cvSessionLimits:GetInt() > 0
end

---
-- Returns the convar value of 'ttt_session_limits_mode'.
-- @return number The session limit mode
-- @realm shared
function gameloop.GetLevelLimitsMode()
    return cvSessionLimits:GetInt()
end

-- old function name aliases
DetectiveMode = gameloop.IsDetectiveMode
HasteMode = gameloop.IsHasteMode
SetRoundState = gameloop.SetRoundState
GetRoundState = gameloop.GetRoundState
