---
-- Voicechat popup
-- @module VOICE

local GetTranslation = LANG.GetTranslation
local string = string
local math = math
local net = net
local player = player
local IsValid = IsValid
local hook = hook

VOCIE_MODE_GLOBAL = 0
VOICE_MODE_TEAM = 1
VOICE_MODE_SPEC = 2

-- voicechat stuff
VOICE = {}

local MutedState

VOICE.cv = {
    ---
    -- @realm client
    -- stylua: ignore
    duck_spectator = CreateConVar("ttt2_voice_duck_spectator", "0", {FCVAR_ARCHIVE}),
    ---
    -- @realm client
    -- stylua: ignore
    duck_spectator_amount = CreateConVar("ttt2_voice_cvDuckSpectator_amount", "0", {FCVAR_ARCHIVE}),

    ---
    -- @realm client
    -- stylua: ignore
    scaling_mode = CreateConVar("ttt2_voice_scaling", "linear", {FCVAR_ARCHIVE}),

    ---
    -- @realm client
    -- stylua: ignore
    activation_mode = CreateConVar("ttt2_voice_activation", "ptt", {FCVAR_ARCHIVE}),
}

local function CreateVoiceTable()
    if not sql.TableExists("ttt2_voice") then
        local query =
            "CREATE TABLE ttt2_voice (guid TEXT PRIMARY KEY, mute INTEGER DEFAULT 0, volume REAL DEFAULT 1)"
        sql.Query(query)
    end
end

CreateVoiceTable()

local function VoiceTryEnable()
    local client = LocalPlayer()

    if not client:IsSpeakingInVoice() and VOICE.CanSpeak() and VOICE.CanEnable() then
        client:SetSpeakingInVoice(true)

        VOICE.isTeam = false

        permissions.EnableVoiceChat(true)

        return true
    end

    return false
end

local function VoiceTryDisable()
    local client = LocalPlayer()

    if not VOICE.isTeam then
        client:SetSpeakingInVoice(false)

        permissions.EnableVoiceChat(false)

        return true
    end

    return false
end

local function VoiceToggle()
    if VOICE.IsSpeaking() then
        return VoiceTryDisable()
    else
        return VoiceTryEnable()
    end
end

VOICE.ActivationModes = {
    ptt = { OnPressed = VoiceTryEnable, OnReleased = VoiceTryDisable, OnJoin = VoiceTryDisable },
    ptm = { OnPressed = VoiceTryDisable, OnReleased = VoiceTryEnable, OnJoin = VoiceTryEnable },
    toggle_disabled = { OnPressed = VoiceToggle, OnJoin = VoiceTryDisable },
    toggle_enabled = { OnPressed = VoiceToggle, OnJoin = VoiceTryEnable },
}

---
-- Generates a fake voice spectrum based on the player voice volume that looks like
-- the restult of an FFT.
-- @param Player ply The player that should generate a fake voice spectrum
-- @param[default=16] number stepCount Defines the result's resolution
-- @return table Returns the table with the fake spectrum
-- @realm client
function VOICE.GetFakeVoiceSpectrum(ply, stepCount)
    stepCount = stepCount or 16

    ply.lastSteps = ply.lastSteps or {}

    -- at first the volume is boosted and limited so that the voice level range
    -- makes a nice sweep over the whole spectrum
    local volume = math.min(4, ply:VoiceVolume() * 6 + math.Rand(-0.2, 0.2))

    local biggestValue = 0

    for i = 1, stepCount do
        local progress = (i - 1) / stepCount

        -- the base for the fake spectrum is a simple sweep over the whole range
        local value = 2 ^ (-(volume * 4 - 2.2 - progress * 4) ^ 2)

        -- since most people talk a bit quiet, we add a signal to the end of the spectrum
        value = value + 2 ^ (-(4.5 - 4 * progress) ^ 2) * ply:VoiceVolume() ^ 0.5

        -- also the whole spectrum is linearly shifted, when the voice is louder
        value = value + 2.5 * ply:VoiceVolume()

        -- to decrease jumpyness a slow lerp is put on top which smoothes everything
        value = Lerp(7.5 * FrameTime(), ply.lastSteps[i] or 0, value)

        -- then a random value is put on top that makes it look less static and slow
        value = value + math.Rand(-0.2 * value ^ 2, 0.2 * value ^ 2)
        value = math.max(0, value)

        -- in the last step a fast lerp is applied that only takes the edge of the random noise
        ply.lastSteps[i] = Lerp(150 * FrameTime(), ply.lastSteps[i] or 0, value)

        biggestValue = math.max(biggestValue, value)
    end

    -- make sure that the spectrum never surpasses 1; if the values are too big, the spectrum
    -- is normalized
    if biggestValue > 1.0 then
        for i = 1, stepCount do
            ply.lastSteps[i] = ply.lastSteps[i] / biggestValue
        end
    end

    return ply.lastSteps
end

---
-- Sets the mode of the voice panel.
-- @param Player ply The player whose voice mode should be set
-- @param number mode The voice mode
-- @realm client
function VOICE.SetVoiceMode(ply, mode)
    ply.voiceMode = mode
end

---
-- Returns the mode of the voice panel.
-- @param Player ply The player whose vocie mode should be read
-- @return number The mode of the voice panel
-- @realm client
function VOICE.GetVoiceMode(ply)
    return ply.voiceMode or VOICE_MODE_GLOBAL
end

---
-- Returns the color of the voice panel.
-- @param Player ply The player whose voice color should be read
-- @return Color The color of the voice panel
-- @realm client
function VOICE.GetVoiceColor(ply)
    if VOICE.GetVoiceMode(ply) == VOICE_MODE_GLOBAL then
        return INNOCENT.color
    else
        return TEAMS[ply:GetTeam()].color
    end
end

---
-- Creates a closure that dynamically calls a function from VOICE.ActivationModes depending on the current mode.
-- @param string func The name of the function to call on the current voice activation mode
-- @return function A closure that calls the function on the current voice activation mode, if it exists
-- @realm client
function VOICE.ActivationModeFunc(functionName)
    return function()
        local mode = VOICE.ActivationModes[VOICE.cv.activation_mode:GetString()]
        if istable(mode) and isfunction(mode[functionName]) then
            return mode[functionName]()
        end
    end
end

hook.Add("TTT2FinishedLoading", "TTT2ActivateVoiceChat", VOICE.ActivationModeFunc("OnJoin"))

local function VoiceTeamTryEnable()
    local client = LocalPlayer()

    if not client:IsSpeakingInVoice() and VOICE.CanSpeak() and VOICE.CanTeamEnable() then
        client:SetSpeakingInVoice(true)

        VOICE.isTeam = true

        permissions.EnableVoiceChat(true)

        return true
    end

    return false
end

local function VoiceTeamTryDisable()
    local client = LocalPlayer()

    if VOICE.isTeam then
        client:SetSpeakingInVoice(false)

        permissions.EnableVoiceChat(false)

        return true
    end

    return false
end

---
-- Checks if a player can enable the team voice chat.
-- @return boolean Returns if the player is able to use the team voice chat
-- @realm client
function VOICE.CanTeamEnable()
    local client = LocalPlayer()

    ---
    -- @realm client
    -- stylua: ignore
    if hook.Run("TTT2CanUseVoiceChat", client, true) == false then
        return false
    end

    if not IsValid(client) then
        return false
    end

    local clientrd = client:GetSubRoleData()
    local tm = client:GetTeam()

    if
        client:IsActive()
        and tm ~= TEAM_NONE
        and not TEAMS[tm].alone
        and not clientrd.unknownTeam
        and not clientrd.disabledTeamVoice
    then
        return true
    end
end

---
-- Checks if a player can enable the global voice chat.
-- @return boolean Returns if the player is able to use the global voice chat
-- @realm client
function VOICE.CanEnable()
    local client = LocalPlayer()

    ---
    -- @realm client
    -- stylua: ignore
    if hook.Run("TTT2CanUseVoiceChat", client, false) == false then
        return false
    end

    return true
end

-- register a binding for the general voicechat
bind.Register(
    "ttt2_voice",
    VOICE.ActivationModeFunc("OnPressed"),
    VOICE.ActivationModeFunc("OnReleased"),
    "header_bindings_ttt2",
    "label_bind_voice",
    input.GetKeyCode(input.LookupBinding("+voicerecord") or KEY_X)
)

-- register a binding for the team voicechat
bind.Register(
    "ttt2_voice_team",
    VoiceTeamTryEnable,
    VoiceTeamTryDisable,
    "header_bindings_ttt2",
    "label_bind_voice_team",
    KEY_T
)

---
-- Called when a @{Player} starts using voice chat.
-- @param Player ply @{Player} who started using voice chat
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerStartVoice
-- @local
function GM:PlayerStartVoice(ply)
    if not IsValid(ply) then
        return
    end

    local plyRoleData = ply:GetSubRoleData()

    local client = LocalPlayer()
    local clientTeam = client:GetTeam()
    local clientRoleData = client:GetSubRoleData()

    if ply ~= client then
        -- if someone else than us starts talking, the UI should be updated as well
        ply:SetSpeakingInVoice(true)
    else
        client[client:GetTeam() .. "_gvoice"] = not VOICE.isTeam

        -- notify server this if this is a global voice chat
        net.Start("TTT2RoleGlobalVoice")
        net.WriteBool(not VOICE.isTeam)
        net.SendToServer()
    end

    VOICE.UpdatePlayerVoiceVolume(ply)

    -- handle voice panel color / mode
    local mode = VOICE_MODE_GLOBAL

    if ply:IsSpec() then
        mode = VOICE_MODE_SPEC
    elseif
        client:IsActive()
        and clientTeam ~= TEAM_NONE
        and not clientRoleData.unknownTeam
        and not clientRoleData.disabledTeamVoice
        and not TEAMS[clientTeam].alone
    then
        if ply == client then
            if not client[clientTeam .. "_gvoice"] then
                mode = VOICE_MODE_TEAM
            end
        elseif
            ply:IsInTeam(client)
            and not (plyRoleData.disabledTeamVoice or clientRoleData.disabledTeamVoiceRecv)
        then
            if not ply[clientTeam .. "_gvoice"] then
                mode = VOICE_MODE_TEAM
            end
        end
    end

    ---
    -- @realm client
    -- stylua: ignore
    mode = hook.Run("TTT2ModifyVoiceChatMode", ply, mode) or mode

    VOICE.SetVoiceMode(ply, mode)

    -- add animation when player is speaking in voice
    if
        not (
            ply:IsActive()
            and not plyRoleData.unknownTeam
            and not plyRoleData.disabledTeamVoice
            and not clientRoleData.disabledTeamVoiceRecv
        )
        or (clientTeam ~= TEAM_NONE and not TEAMS[clientTeam].alone)
            and ply[clientTeam .. "_gvoice"]
    then
        ply:AnimPerformGesture(ACT_GMOD_IN_CHAT)
    end
end

local function ReceiveVoiceState()
    local idx = net.ReadUInt(7) + 1 -- we -1 serverside
    local isGlobal = net.ReadBit() == 1

    -- prevent glitching due to chat starting/ending across round boundary
    if GAMEMODE.round_state ~= ROUND_ACTIVE then
        return
    end

    local lply = LocalPlayer()
    if not IsValid(lply) then
        return
    end

    local ply = player.GetByID(idx)

    if not IsValid(ply) or not ply.GetSubRoleData then
        return
    end

    local plyrd = ply:GetSubRoleData()

    if
        not ply:IsActive()
        or plyrd.unknownTeam
        or plyrd.disabledTeamVoice
        or lply:GetSubRoleData().disabledTeamVoiceRecv
    then
        return
    end

    local tm = ply:GetTeam()

    if tm == TEAM_NONE or TEAMS[tm].alone then
        return
    end

    ply[tm .. "_gvoice"] = isGlobal
end
net.Receive("TTT_RoleVoiceState", ReceiveVoiceState)

---
-- Called when @{Player} stops using voice chat.
-- @param Player ply @{Player} who stopped talking
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerEndVoice
-- @local
function GM:PlayerEndVoice(ply)
    if not IsValid(ply) then
        return
    end

    local plyTeam = ply:GetTeam()

    -- if someone else than us stops talking, the UI should be updated as well
    if ply ~= LocalPlayer() then
        ply:SetSpeakingInVoice(false)
    end

    if plyTeam ~= TEAM_NONE and not TEAMS[plyTeam].alone then
        ply[plyTeam .. "_gvoice"] = false
    end
end

--local MuteStates = {MUTE_NONE, MUTE_TERROR, MUTE_ALL, MUTE_SPEC}

local MuteText = {
    [MUTE_NONE] = "",
    [MUTE_TERROR] = "mute_living",
    [MUTE_ALL] = "mute_all",
    [MUTE_SPEC] = "mute_specs",
}

local function SetMuteState(state)
    if not MutedState then
        return
    end

    MutedState:SetText(string.upper(GetTranslation(MuteText[state])))
    MutedState:SetVisible(state ~= MUTE_NONE)
end

local mute_state = MUTE_NONE

---
-- Switches the mute state to the next in the list or to the given one
-- @param number force_state
-- @return number the new mute_state
-- @realm client
function VOICE.CycleMuteState(force_state)
    mute_state = force_state or next(MuteText, mute_state)

    if not mute_state then
        mute_state = MUTE_NONE
    end

    SetMuteState(mute_state)

    return mute_state
end

VOICE.battery_max = 100
VOICE.battery_min = 10

---
-- Scales a linear volume into a Power 4 value.
-- @param number volume
-- @realm client
function VOICE.LinearToPower4(volume)
    return math.Clamp(math.pow(volume, 4), 0, 1)
end

---
-- Scales a linear volume into a Log value.
-- @param number volume
-- @realm client
function VOICE.LinearToLog(volume)
    local rolloff_cutoff = 0.1
    local log_a = math.pow(1 / 10, 60 / 20)
    local log_b = math.log(1 / log_a)

    local vol = log_a * math.exp(log_b * volume)
    if volume < rolloff_cutoff then
        local log_rolloff = 10 * log_a * math.exp(log_b * rolloff_cutoff)
        vol = volume * log_rolloff
    end

    return math.Clamp(vol, 0, 1)
end

---
-- Passes along the input linear volume value.
-- @param number volume
-- @realm client
function VOICE.LinearToLinear(volume)
    return volume
end

VOICE.ScalingFunctions = {
    power4 = VOICE.LinearToPower4,
    log = VOICE.LinearToLog,
    linear = VOICE.LinearToLinear,
}

---
-- Gets the stored volume for the player's voice.
-- @param Player ply
-- @realm client
function VOICE.GetPreferredPlayerVoiceVolume(ply)
    local val = sql.QueryValue(
        "SELECT volume FROM ttt2_voice WHERE guid = " .. SQLStr(ply:SteamID64()) .. " LIMIT 1"
    )
    if val == nil then
        return 1
    end
    return tonumber(val)
end

---
-- Sets the stored volume for the player's voice.
-- @param Player ply
-- @param number volume
-- @realm client
function VOICE.SetPreferredPlayerVoiceVolume(ply, volume)
    return sql.Query(
        "REPLACE INTO ttt2_voice ( guid, volume ) VALUES ( "
            .. SQLStr(ply:SteamID64())
            .. ", "
            .. SQLStr(volume)
            .. " )"
    )
end

---
-- Gets the stored mute state for the player's voice.
-- @param Player ply
-- @realm client
function VOICE.GetPreferredPlayerVoiceMuted(ply)
    local val = sql.QueryValue(
        "SELECT mute FROM ttt2_voice WHERE guid = " .. SQLStr(ply:SteamID64()) .. " LIMIT 1"
    )
    if val == nil then
        return false
    end
    return tobool(val)
end

---
-- Sets the stored mute state for the player's voice.
-- @param Player ply
-- @param boolean is_muted
-- @realm client
function VOICE.SetPreferredPlayerVoiceMuted(ply, is_muted)
    return sql.Query(
        "REPLACE INTO ttt2_voice ( guid, mute ) VALUES ( "
            .. SQLStr(ply:SteamID64())
            .. ", "
            .. SQLStr(is_muted and 1 or 0)
            .. " )"
    )
end

---
-- Refreshes and applies the preferred volume and mute state for a player's voice.
-- @param Player ply
-- @realm client
function VOICE.UpdatePlayerVoiceVolume(ply)
    local mute = VOICE.GetPreferredPlayerVoiceMuted(ply)
    if ply.SetMute then
        ply:SetMute(mute)
    end

    local vol = VOICE.GetPreferredPlayerVoiceVolume(ply)
    if VOICE.cv.duck_spectator:GetBool() and ply:IsSpec() then
        vol = vol * (1 - VOICE.cv.duck_spectator_amount:GetFloat())
    end
    local out_vol = vol

    local func = VOICE.ScalingFunctions[VOICE.cv.scaling_mode:GetString()]
    if isfunction(func) then
        out_vol = func(vol)
    end

    ply:SetVoiceVolumeScale(out_vol)

    return out_vol, mute
end

---
-- Initializes the voice battery
-- @realm client
function VOICE.InitBattery()
    LocalPlayer().voice_battery = VOICE.battery_max
end

local function GetRechargeRate()
    local r = GetGlobalFloat("ttt_voice_drain_recharge", 0.05)

    if LocalPlayer().voice_battery < VOICE.battery_min then
        r = r * 0.5
    end

    return r
end

local function GetDrainRate()
    local ply = LocalPlayer()

    if
        not IsValid(ply)
        or ply:IsSpec()
        or not GetGlobalBool("ttt_voice_drain", false)
        or GetRoundState() ~= ROUND_ACTIVE
    then
        return 0
    end

    local plyRoleData = ply:GetSubRoleData()

    if ply:IsAdmin() or (plyRoleData.isPublicRole and plyRoleData.isPolicingRole) then
        return GetGlobalFloat("ttt_voice_drain_admin", 0)
    else
        return GetGlobalFloat("ttt_voice_drain_normal", 0)
    end
end

local function IsRoleChatting(ply)
    local plyTeam = ply:GetTeam()
    local plyRoleData = ply:GetSubRoleData()

    return ply:IsActive()
        and not plyRoleData.unknownTeam
        and not plyRoleData.disabledTeamVoice
        and not LocalPlayer():GetSubRoleData().disabledTeamVoiceRecv
        and plyTeam ~= TEAM_NONE
        and not TEAMS[plyTeam].alone
        and not ply[plyTeam .. "_gvoice"]
end

---
-- Updates the voice battery
-- @note Called every @{GM:Tick}
-- @realm client
-- @internal
function VOICE.Tick()
    if not GetGlobalBool("ttt_voice_drain", false) then
        return
    end

    local client = LocalPlayer()

    if VOICE.IsSpeaking() and not IsRoleChatting(client) then
        client.voice_battery = client.voice_battery - GetDrainRate()

        if not VOICE.CanSpeak() then
            client.voice_battery = 0

            permissions.EnableVoiceChat(false)
        end
    elseif client.voice_battery < VOICE.battery_max then
        client.voice_battery = client.voice_battery + GetRechargeRate()
    end
end

---
-- Returns whether the local @{Player} is speaking
-- @note @{Player:IsSpeaking} does not work for local @{Player}
-- @return boolean
-- @realm client
function VOICE.IsSpeaking()
    return LocalPlayer().speaking
end

---
-- Sets whether the local @{Player} is speaking
-- @param boolean state
-- @realm client
function VOICE.SetSpeaking(state)
    LocalPlayer().speaking = state
end

---
-- Returns whether the local @{Player} is able to speak
-- @return boolean
-- @realm client
function VOICE.CanSpeak()
    if not GetGlobalBool("sv_voiceenable", true) then
        return false
    end

    if not GetGlobalBool("ttt_voice_drain", false) then
        return true
    end

    local client = LocalPlayer()

    return client.voice_battery > VOICE.battery_min or IsRoleChatting(client)
end

---
-- This hook can be used to modify the background color of the voice chat
-- box that is rendered on the client. This is done by setting the voice chat mode.
-- @param ply The player that started a voice chat
-- @param number mode The voice chat mode that is used if this hook does not modify it
-- @return number The new and modified mode
-- @hook
-- @realm client
function GM:TTT2ModifyVoiceChatMode(ply, mode) end
