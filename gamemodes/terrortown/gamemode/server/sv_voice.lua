---
-- @section voice_manager
-- @desc Mute players when we are about to run map cleanup, because it might cause
-- net buffer overflows on clients.

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
local cv_ttt_limit_spectator_voice = CreateConVar("ttt_limit_spectator_voice", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

local sv_voiceenable = GetConVar("sv_voiceenable")

local loc_voice = CreateConVar("ttt_locational_voice", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

hook.Add("TTT2SyncGlobals", "AddVoiceGlobals", function()
	SetGlobalBool(sv_voiceenable:GetName(), sv_voiceenable:GetBool())
	SetGlobalBool(loc_voice:GetName(), loc_voice:GetBool())
end)

cvars.AddChangeCallback(loc_voice:GetName(), function(cv, old, new)
	SetGlobalBool(loc_voice:GetName(), tobool(tonumber(new)))
end)

local function PlayerCanHearSpectator(listener, speaker, roundState)
	local isSpec = listener:IsSpec()
	-- limited if specific convar is on, or we're in detective mode
	local limit = DetectiveMode() or cv_ttt_limit_spectator_voice:GetBool()

	return isSpec or not limit or roundState ~= ROUND_ACTIVE, not isSpec and loc_voice:GetBool() and roundState ~= ROUND_POST
end

local function PlayerCanHearTeam(listener, speaker, speakerTeam)
	local speakerSubRoleData = speaker:GetSubRoleData()

	-- Speaker checks
	if speakerTeam == TEAM_NONE or speakerSubRoleData.unknownTeam or speakerSubRoleData.disabledTeamVoice then return false, false end
	-- Listener checks
	if listener:GetSubRoleData().disabledTeamVoiceRecv or not listener:IsActive() or not listener:IsInTeam(speaker) then return false, false end
	if TEAMS[speakerTeam].alone then return false, false end

	return true, loc_voice:GetBool()
end

local function PlayerIsMuted(listener, speaker)
	-- Enforced silence and specific mute
	if mute_all or listener:IsSpec() and listener.mute_team == speaker:Team() or listener.mute_team == MUTE_ALL then return true end
end

local function PlayerCanHearGlobal(roundState)
	return true, loc_voice:GetBool() and roundState ~= ROUND_POST
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
-- @ref https://wiki.garrysmod.com/page/GM/PlayerCanHearPlayersVoice
-- @local
function GM:PlayerCanHearPlayersVoice(listener, speaker)
	if speaker.blockVoice then return false, false end

	if not IsValid(speaker) or not IsValid(listener) or listener == speaker then
		return false, false
	end

	local speakerTeam = speaker:GetTeam()
	local roundState = GetRoundState()
	local isGlobalVoice = speaker[speakerTeam .. "_gvoice"]

	if PlayerIsMuted(listener, speaker) then
		return false, false
	end

	-- custom post-settings
	local can_hear, is_locational = hook.Run("TTT2CanHearVoiceChat", listener, speaker, not isGlobalVoice)

	if can_hear ~= nil then
		return can_hear, is_locational or false
	end

	if speaker:IsSpec() and isGlobalVoice then
		-- Check that the speaker was not previously sending voice on the team chat
		return PlayerCanHearSpectator(listener, speaker, roundState)
	elseif isGlobalVoice then
		return PlayerCanHearGlobal(roundState)
	else
		return PlayerCanHearTeam(listener, speaker, speakerTeam)
	end
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
function GM:TTT2CanHearVoiceChat(listener, speaker, isTeam)

end

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
	if not IsValid(ply) then return end

	ply[ply:GetTeam() .. "_gvoice"] = isGlobal
	ply.blockVoice = hook.Run("TTT2CanUseVoiceChat", ply, not isGlobal) == false

	SendRoleVoiceState(ply)
end

local function NetRoleGlobalVoice(len, ply)
	local isGlobal = net.ReadBool()

	RoleGlobalVoice(ply, isGlobal)
end
net.Receive("TTT2RoleGlobalVoice", NetRoleGlobalVoice)

local function ConCommandRoleGlobalVoice(ply, cmd, args)
	if #args ~= 1 then return end

	local isGlobal = tobool(args[1])

	RoleGlobalVoice(ply, isGlobal)
end
concommand.Add("tvog", ConCommandRoleGlobalVoice)

local function MuteTeam(ply, state)
	if not IsValid(ply) then return end

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
		LANG.Msg(ply, "mute_team", {team = team.GetName(state)}, MSG_CHAT_PLAIN)
	end
end

local function NetMuteTeam(len, ply)
	local state = net.ReadBool()

	MuteTeam(ply, state)
end
net.Receive("TTT2MuteTeam", NetMuteTeam)

local function ConCommandMuteTeam(ply, cmd, args)
	if not #args == 1 and tonumber(args[1]) then return end

	local state = tonumber(args[1])

	MuteTeam(ply, state)
end
concommand.Add("ttt_mute_team", ConCommandMuteTeam)
