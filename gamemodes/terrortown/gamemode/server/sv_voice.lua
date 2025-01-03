---
-- Mute players when we are about to run map cleanup, because it might cause
-- net buffer overflows on clients.
-- @section voice_manager

local mute_all = false

local IsValid = IsValid
local hook = hook
local net = net

---
-- Updates the mute_all state
-- @param number state
-- @realm server
function MuteForRestart(state)
    mute_all = state
end

-- Communication control
local sv_voiceenable = GetConVar("sv_voiceenable")

---
-- @realm server
local cv_ttt_limit_spectator_voice =
    CreateConVar("ttt_limit_spectator_voice", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
local loc_voice = CreateConVar("ttt_locational_voice", "0", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
local loc_voice_prep =
    CreateConVar("ttt_locational_voice_prep", "0", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
local loc_voice_range =
    CreateConVar("ttt_locational_voice_range", "0", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

local loc_voice_range_sq = loc_voice_range:GetInt() ^ 2

hook.Add("TTT2SyncGlobals", "AddVoiceGlobals", function()
    SetGlobalBool(sv_voiceenable:GetName(), sv_voiceenable:GetBool())
    SetGlobalBool(loc_voice:GetName(), loc_voice:GetBool())
end)

cvars.AddChangeCallback(sv_voiceenable:GetName(), function(cv, old, new)
    SetGlobalBool(sv_voiceenable:GetName(), tobool(tonumber(new)))
end)

cvars.AddChangeCallback(loc_voice:GetName(), function(cv, old, new)
    SetGlobalBool(loc_voice:GetName(), tobool(tonumber(new)))
end)

cvars.AddChangeCallback(loc_voice_range:GetName(), function(cv, old, new)
    loc_voice_range_sq = tonumber(new) ^ 2
end)

local function LocationalVoiceIsActive(roundState)
    return loc_voice:GetBool()
        and roundState ~= ROUND_POST
        and (roundState ~= ROUND_PREP or loc_voice_prep:GetBool())
end

local function PlayerCanHearSpectator(listener, speaker, roundState)
    local isSpec = listener:IsSpec()

    -- limited if specific convar is on, or we're in detective mode
    local limit = gameloop.IsDetectiveMode() or cv_ttt_limit_spectator_voice:GetBool()

    return isSpec or not limit or roundState ~= ROUND_ACTIVE,
        not isSpec and LocationalVoiceIsActive(roundState)
end

local function PlayerCanHearTeam(listener, speaker, speakerTeam)
    local speakerSubRoleData = speaker:GetSubRoleData()

    -- Speaker checks
    if
        speakerTeam == TEAM_NONE
        or speakerSubRoleData.unknownTeam
        or speakerSubRoleData.disabledTeamVoice
    then
        return false, false
    end

    -- Listener checks
    if
        listener:GetSubRoleData().disabledTeamVoiceRecv
        or not listener:IsActive()
        or not listener:IsInTeam(speaker)
    then
        return false, false
    end

    if TEAMS[speakerTeam].alone then
        return false, false
    end

    return true, loc_voice:GetBool()
end

local function PlayerIsMuted(listener, speaker)
    -- Enforced silence and specific mute
    if
        mute_all
        or listener:IsSpec() and listener.mute_team == speaker:Team()
        or listener.mute_team == MUTE_ALL
    then
        return true
    end
end

local function PlayerCanHearGlobal(roundState)
    return true, LocationalVoiceIsActive(roundState)
end

---
-- Decides whether a @{Player} can hear another @{Player} using voice chat.
-- @note This hook is called several times a tick, so ensure your code is efficient.
-- @note Of course voice has to be limited as well
-- @param Player listener The listening @{Player}
-- @param Player speaker The talking @{Player}
-- @return boolean Return true if the listener should hear the talker, false if they shouldn't
-- @return boolean 3D sound. If set to true, will fade out the sound the further away listener is from the talker, the voice will also be in stereo, and not mono
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerCanHearPlayersVoice
-- @local
function GM:PlayerCanHearPlayersVoice(listener, speaker)
    if speaker.blockVoice then
        return false, false
    end

    if not IsValid(speaker) or not IsValid(listener) or listener == speaker then
        return false, false
    end

    local speakerTeam = speaker:GetTeam()
    local roundState = gameloop.GetRoundState()
    local isGlobalVoice = speaker[speakerTeam .. "_gvoice"]

    if PlayerIsMuted(listener, speaker) then
        return false, false
    end

    ---
    -- custom post-settings
    -- @realm server
    local can_hear, is_locational =
        hook.Run("TTT2CanHearVoiceChat", listener, speaker, not isGlobalVoice)

    if can_hear ~= nil then
        return can_hear, is_locational or false
    end

    if speaker:IsSpec() and isGlobalVoice then
        -- Check that the speaker was not previously sending voice on the team chat
        can_hear, is_locational = PlayerCanHearSpectator(listener, speaker, roundState)
    elseif isGlobalVoice then
        can_hear, is_locational = PlayerCanHearGlobal(roundState)
    else
        can_hear, is_locational = PlayerCanHearTeam(listener, speaker, speakerTeam)
    end

    -- If the listener is too far away from the speaker, they can't hear them at all
    if
        can_hear
        and is_locational
        and loc_voice_range_sq > 0
        and listener:GetPos():DistToSqr(speaker:GetPos()) > loc_voice_range_sq
    then
        can_hear = false
    end

    return can_hear, is_locational
end

---
-- Whether or not the @{Player} hear the voice chat.
-- @param Player listener @{Player} who can receive voice chat
-- @param Player speaker @{Player} who speaks
-- @param boolean isTeam Are they trying to use the team voice chat
-- @return boolean Return true if the listener should hear the talker, false if they shouldn't, nil if it should stay default
-- @return boolean 3D sound. If set to true, will fade out the sound the further away listener is from the talker, the voice will also be in stereo, and not mono
-- @hook
-- @realm server
function GM:TTT2CanHearVoiceChat(listener, speaker, isTeam) end

local function SendRoleVoiceState(speaker)
    -- send umsg to living traitors that this is traitor-only talk
    local rf = GetTeamMemberFilter(speaker, true)

    -- make it as small as possible, to get there as fast as possible
    -- we can fit it into a mere byte by being cheeky.
    net.Start("TTT_RoleVoiceState")
    net.WriteUInt(speaker:EntIndex() - 1, 7) -- player ids can only be 1-128
    net.WriteBit(speaker[speaker:GetTeam() .. "_gvoice"])

    if rf then
        net.Send(rf)
    else
        net.Broadcast()
    end
end

local function RoleGlobalVoice(ply, isGlobal)
    if not IsValid(ply) then
        return
    end

    ply[ply:GetTeam() .. "_gvoice"] = isGlobal

    ---
    -- @realm server
    ply.blockVoice = hook.Run("TTT2CanUseVoiceChat", ply, not isGlobal) == false

    SendRoleVoiceState(ply)
end

local function NetRoleGlobalVoice(len, ply)
    local isGlobal = net.ReadBool()

    RoleGlobalVoice(ply, isGlobal)
end
net.Receive("TTT2RoleGlobalVoice", NetRoleGlobalVoice)

local function ConCommandRoleGlobalVoice(ply, cmd, args)
    if #args ~= 1 then
        return
    end

    local isGlobal = tobool(args[1])

    RoleGlobalVoice(ply, isGlobal)
end
concommand.Add("tvog", ConCommandRoleGlobalVoice)

local function MuteTeam(ply, state)
    if not IsValid(ply) then
        return
    end

    if not ply:IsSpec() then
        ply.mute_team = -1

        return
    end

    ply.mute_team = state

    if state == MUTE_ALL then
        LANG.Msg(ply, "mute_all", nil, MSG_CHAT_PLAIN)
    elseif state == MUTE_NONE or state == TEAM_UNASSIGNED or not team.Valid(state) then
        LANG.Msg(ply, "mute_off", nil, MSG_CHAT_PLAIN)
    else
        LANG.Msg(
            ply,
            "mute_team",
            { team = LANG.NameParam(string.lower(team.GetName(state))) },
            MSG_CHAT_PLAIN
        )
    end
end

local function NetMuteTeam(len, ply)
    local state = net.ReadBool()

    MuteTeam(ply, state)
end
net.Receive("TTT2MuteTeam", NetMuteTeam)

local function ConCommandMuteTeam(ply, cmd, args)
    if #args ~= 1 and tonumber(args[1]) then
        return
    end

    local state = tonumber(args[1])

    MuteTeam(ply, state)
end
concommand.Add("ttt_mute_team", ConCommandMuteTeam)
