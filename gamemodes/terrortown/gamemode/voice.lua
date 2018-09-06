-- Mute players when we are about to run map cleanup, because it might cause
-- net buffer overflows on clients.
local mute_all = false

function MuteForRestart(state)
	mute_all = state
end

---- Communication control
CreateConVar("ttt_limit_spectator_voice", "1", FCVAR_ARCHIVE + FCVAR_NOTIFY)

local loc_voice = CreateConVar("ttt_locational_voice", "0")

-- Of course voice has to be limited as well
function GM:PlayerCanHearPlayersVoice(listener, speaker)
	-- Enforced silence
	if mute_all then
		return false, false
	end

	if not IsValid(speaker) or not IsValid(listener) or listener == speaker then
		return false, false
	end
	
	if listener:HasTeamRole(TEAM_INNO) or speaker:HasTeamRole(TEAM_INNO) then
		return false, false
	end

	-- limited if specific convar is on, or we're in detective mode -- TODO in TTT2 - Det speak with each other? Currently unavailable
	local limit = DetectiveMode() or GetConVar("ttt_limit_spectator_voice"):GetBool()

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
	hook.Run("TTT2_PostPlayerCanHearPlayersVoice", listener, speaker)

	-- Traitors "team"chat by default, non-locationally
	if (not speaker:GetRoleData().unknownTeam or speaker:HasTeamRole(TEAM_TRAITOR)) and speaker:IsActive() and speaker:IsTeamMember(listener) then
		if speaker[speaker:GetRoleData().team .. "_gvoice"] then
			return true, loc_voice:GetBool()
		elseif listener:IsActive() and listener:IsTeamMember(speaker) then
			return true, false
		else
			-- unless [TEAM_TRAITOR]_gvoice is true, normal innos can't hear speaker
			return false, false
		end
	end
	
	if not speaker:IsTeamMember(listener) or speaker:GetRoleData().unknownTeam then
		return false, false
	end

	return true, (loc_voice:GetBool() and GetRoundState() ~= ROUND_POST)
end

local function SendRoleVoiceState(speaker)
	local state = speaker[speaker:GetRoleData().team .. "_gvoice"]

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
	if not IsValid(ply) or not (ply:IsActive() and not ply:HasTeamRole(TEAM_INNO)) then return end
	
	local rd = ply:GetRoleData()
	
	if rd.unknownTeam then return end
	
	if #args ~= 1 then return end
	
	local state = tonumber(args[1])

	ply[ply:GetRoleData().team .. "_gvoice"] = (state == 1)
	
	SendRoleVoiceState(ply)
end
concommand.Add("rvog", RoleGlobalVoice)

local function MuteTeam(ply, cmd, args)
	if not IsValid(ply) then return end
	
	if not #args == 1 and tonumber(args[1]) then return end
	
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
