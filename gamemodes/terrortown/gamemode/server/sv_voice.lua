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

local loc_voice = CreateConVar("ttt_locational_voice", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

-- TODO
---
-- Decides whether a @{Player} can hear another @{Player} using voice chat.
-- @note This hook is called several times a tick, so ensure your code is efficient.
-- @note Of course voice has to be limited as well
-- @param Player listener The listening @{Player}
-- @param Player speaker The talking @{Player}
-- @return boolean Return true if the listener should hear the talker, false if they shouldn't
-- @return boolean 3D sound. If set to true, will fade out the sound the further away listener is from the talker, the voice will also be in stereo, and not mono
-- @todo Improve the code
-- @hook
-- @realm server
-- @ref https://wiki.garrysmod.com/page/GM/PlayerCanHearPlayersVoice
-- @local
function GM:PlayerCanHearPlayersVoice(listener, speaker)
	-- Enforced silence
	if mute_all then
		return false, false
	end

	if not IsValid(speaker) or not IsValid(listener) or listener == speaker then
		return false, false
	end

	-- limited if specific convar is on, or we're in detective mode
	local limit = DetectiveMode() or cv_ttt_limit_spectator_voice:GetBool()

	-- Spectators should not be heard by living players during round
	if speaker:IsSpec() and not listener:IsSpec() and limit and GetRoundState() == ROUND_ACTIVE then
		return false, false
	end

	-- Specific mute
	if listener:IsSpec() and listener.mute_team == speaker:Team() or listener.mute_team == MUTE_ALL then
		return false, false
	end

	-- Specs should not hear each other locationally
	if speaker:IsSpec() and listener:IsSpec() then
		return true, false
	end

	-- custom post-settings
	local res1, res2 = hook.Run("TTT2PostPlayerCanHearPlayersVoice", listener, speaker)

	if res1 ~= nil then
		return res1, res2 or false
	end

	-- Traitors "team"chat by default, non-locationally
	local tm = speaker:GetTeam()
	local sprd = speaker:GetSubRoleData()

	if tm ~= TEAM_NONE and speaker:IsActive() and not sprd.unknownTeam and not sprd.disabledTeamVoice and not listener:GetSubRoleData().disabledTeamVoiceRecv and not TEAMS[tm].alone then
		if speaker[tm .. "_gvoice"] then
			return true, loc_voice:GetBool()
		elseif listener:IsActive() and listener:IsInTeam(speaker) then
			return true, false
		else
			-- unless <Team>_gvoice is true, other teams can't hear speaker
			return false, false
		end
	end

	return true, loc_voice:GetBool() and GetRoundState() ~= ROUND_POST
end

local function SendRoleVoiceState(speaker)
	local tm = speaker:GetTeam()
	if tm == TEAM_NONE or TEAMS[tm].alone then return end

	local state = speaker[tm .. "_gvoice"]

	-- send umsg to living traitors that this is traitor-only talk
	local rf = GetTeamMemberFilter(speaker, true)

	-- make it as small as possible, to get there as fast as possible
	-- we can fit it into a mere byte by being cheeky.
	net.Start("TTT_RoleVoiceState")
	net.WriteUInt(speaker:EntIndex() - 1, 7) -- player ids can only be 1-128
	net.WriteBit(state)

	if rf then
		net.Send(rf)
	else
		net.Broadcast()
	end
end

local function RoleGlobalVoice(ply, cmd, args)
	if not IsValid(ply) or not ply:IsActive() or ply:GetSubRoleData().unknownTeam or ply:GetSubRoleData().disabledTeamVoice then return end

	local tm = ply:GetTeam()
	if tm == TEAM_NONE or TEAMS[tm].alone then return end

	if #args ~= 1 then return end

	local state = tonumber(args[1])

	ply[tm .. "_gvoice"] = state == 1

	SendRoleVoiceState(ply)
end
concommand.Add("tvog", RoleGlobalVoice)

local function MuteTeam(ply, cmd, args)
	if not IsValid(ply) or not #args == 1 and tonumber(args[1]) then return end

	if not ply:IsSpec() then
		ply.mute_team = -1

		return
	end

	local t = tonumber(args[1])

	ply.mute_team = t

	if t == MUTE_ALL then
		ply:ChatPrint("All muted.")
	elseif t == MUTE_NONE or t == TEAM_UNASSIGNED or not team.Valid(t) then
		ply:ChatPrint("None muted.")
	else
		ply:ChatPrint(team.GetName(t) .. " muted.")
	end
end
concommand.Add("ttt_mute_team", MuteTeam)
