---- Communicating game state to players

local net = net
local string = string
local table = table
local ipairs = ipairs
local IsValid = IsValid

-- NOTE: most uses of the Msg functions here have been moved to the LANG
-- functions. These functions are essentially deprecated, though they won't be
-- removed and can safely be used by SWEPs and the like.

function GameMsg(msg)
	net.Start("TTT_GameMsg")
	net.WriteString(msg)
	net.WriteBit(false)
	net.Broadcast()
end

function CustomMsg(ply_or_rf, msg, clr)
	clr = clr or COLOR_WHITE

	net.Start("TTT_GameMsgColor")
	net.WriteString(msg)
	net.WriteUInt(clr.r, 8)
	net.WriteUInt(clr.g, 8)
	net.WriteUInt(clr.b, 8)

	if ply_or_rf then
		net.Send(ply_or_rf)
	else
		net.Broadcast()
	end
end

-- Basic status message to single player or a recipientfilter
function PlayerMsg(ply_or_rf, msg, traitor_only)
	net.Start("TTT_GameMsg")
	net.WriteString(msg)
	net.WriteBit(traitor_only)

	if ply_or_rf then
		net.Send(ply_or_rf)
	else
		net.Broadcast()
	end
end

-- Traitor-specific message that will appear in a special color
function TraitorMsg(ply_or_rfilter, msg)
	PlayerMsg(ply_or_rfilter, msg, true)
end

-- Traitorchat
local function RoleChatMsg(sender, role, msg)
	net.Start("TTT_RoleChat")
	net.WriteUInt(role, ROLE_BITS)
	net.WriteEntity(sender)
	net.WriteString(msg)
	net.Send(GetRoleFilter(role))
end


-- Round start info popup
function ShowRoundStartPopup()
	for _, v in ipairs(player.GetAll()) do
		if IsValid(v) and v:Team() == TEAM_TERROR and v:Alive() then
			v:ConCommand("ttt_cl_startpopup")
		end
	end
end

function GetPlayerFilter(pred)
	local filter = {}

	for _, v in ipairs(player.GetAll()) do
		if IsValid(v) and pred(v) then
			table.insert(filter, v)
		end
	end

	return filter
end

-- fix for addons
function GetInnocentFilter(alive_only)
	return GetRoleTeamFilter(TEAM_INNO, alive_only)
end

function GetTraitorFilter(alive_only)
	return GetRoleTeamFilter(TEAM_TRAITOR, alive_only)
end

function GetDetectiveFilter(alive_only)
	return GetRoleFilter(ROLES.DETECTIVE.index, alive_only)
end
-- end fix

function GetRoleFilter(role, alive_only)
	return GetPlayerFilter(function(p)
		return p:IsRole(role) and (not alive_only or p:IsTerror())
	end)
end

function GetRoleTeamFilter(team, alive_only)
	return GetPlayerFilter(function(p)
		return p:HasTeamRole(team) and (not alive_only or p:IsTerror())
	end)
end

function GetTeamMemberFilter(ply, alive_only)
	return GetPlayerFilter(function(p)
		return p:IsTeamMember(ply) and (not alive_only or p:IsTerror())
	end)
end

function GetAllRolesFilterWOTeams(teamTbl, alive_only)
	return GetPlayerFilter(function(p)
		return not table.HasValue(teamTbl, p:GetRoleData().team) and (not alive_only or p:IsTerror())
	end)
end

function GetSpecialRoleFilter(role, alive_only)
	local roleData = GetRoleByIndex(role)

	return GetPlayerFilter(function(p)
		return (roleData.visibleForTraitors and not p:HasTeamRole(TEAM_TRAITOR) or not roleData.visibleForTraitors) and (not alive_only or p:IsTerror())
	end)
end

---- Communication control
CreateConVar("ttt_limit_spectator_chat", "1", FCVAR_ARCHIVE + FCVAR_NOTIFY)

function GM:PlayerCanSeePlayersChat(text, team_only, listener, speaker)
	if not IsValid(listener) then return false end

	if not IsValid(speaker) then
		if IsEntity(speaker) then
			return true
		else
			return false
		end
	end

	local sTeam = speaker:Team() == TEAM_SPEC
	local lTeam = listener:Team() == TEAM_SPEC

	if GetRoundState() ~= ROUND_ACTIVE or	-- Round isn't active
	not GetConVar("ttt_limit_spectator_chat"):GetBool() or	-- Spectators can chat freely
	not DetectiveMode() or	-- Mumbling
	not sTeam and (team_only and not speaker:IsSpecial() or not team_only) or	-- If someone alive talks (and not a special role in teamchat's case)
	not sTeam and team_only and speaker:GetRole() == listener:GetRole() or
	sTeam and lTeam then	-- If the speaker and listener are spectators
		return true
	end

	return false
end

local mumbles = {
	"mumble",
	"mm",
	"hmm",
	"hum",
	"mum",
	"mbm",
	"mble",
	"ham",
	"mammaries",
	"political situation",
	"mrmm",
	"hrm",
	"uzbekistan",
	"mumu",
	"cheese export",
	"hmhm",
	"mmh",
	"mumble",
	"mphrrt",
	"mrh",
	"hmm",
	"mumble",
	"mbmm",
	"hmml",
	"mfrrm"
}

-- While a round is active, spectators can only talk among themselves. When they
-- try to speak to all players they could divulge information about who killed
-- them. So we mumblify them. In detective mode, we shut them up entirely.
function GM:PlayerSay(ply, text, team_only)
	if not IsValid(ply) then return text or "" end

	if GetRoundState() == ROUND_ACTIVE then
		local team = ply:Team() == TEAM_SPEC

		if team and not DetectiveMode() then
			local filtered = {}

			for _, v in ipairs(string.Explode(" ", text)) do
				-- grab word characters and whitelisted interpunction
				-- necessary or leetspeek will be used (by trolls especially)
				local word, interp = string.match(v, "(%a*)([%.,!%?]*)")

				if word ~= "" then
					table.insert(filtered, mumbles[math.random(1, #mumbles)] .. interp)
				end
			end

			-- make sure we have something to say
			if #filtered < 1 then
				table.insert(filtered, mumbles[math.random(1, #mumbles)])
			end

			table.insert(filtered, 1, "[MUMBLED]")

			return table.concat(filtered, " ")
		elseif team_only and not team and ply:IsSpecial() then
			RoleChatMsg(ply, ply:GetRole(), text)

			return ""
		end
	end

	return text or ""
end

local ttt_lastwords = CreateConVar("ttt_lastwords_chatprint", "0")

local LastWordContext = {
	[KILL_NORMAL] = "",
	[KILL_SUICIDE] = " *kills self*",
	[KILL_FALL] = " *SPLUT*",
	[KILL_BURN] = " *crackle*"
}

local function LastWordsMsg(ply, words)
	-- only append "--" if there's no ending interpunction
	local final = string.match(words, "[\\.\\!\\?]$") ~= nil

	-- add optional context relating to death type
	local context = LastWordContext[ply.death_type] or ""

	net.Start("TTT_LastWordsMsg")
	net.WriteEntity(ply)
	net.WriteString(words .. (final and "" or "--") .. context)
	net.Broadcast()
end

local function LastWords(ply, cmd, args)
	if IsValid(ply) and not ply:Alive() and #args > 1 then
		local id = tonumber(args[1])

		if id and ply.last_words_id and id == ply.last_words_id then
			-- never allow multiple last word stuff
			ply.last_words_id = nil

			-- we will be storing this on the ragdoll
			local rag = ply.server_ragdoll

			if not (IsValid(rag) and rag.player_ragdoll) then
				rag = nil
			end

			--- last id'd person
			local last_seen = tonumber(args[2])

			if last_seen then
				local ent = Entity(last_seen)

				if IsValid(ent) and ent:IsPlayer() and rag and not rag.lastid then
					rag.lastid = {ent = ent, t = CurTime()}
				end
			end

			--- last words
			local words = string.Trim(args[3])

			-- nothing of interest
			if string.len(words) < 2 then return end

			-- ignore admin commands
			local firstchar = string.sub(words, 1, 1)

			if firstchar == "!" or firstchar == "@" or firstchar == "/" then return end

			if ttt_lastwords:GetBool() or ply.death_type == KILL_FALL then
				LastWordsMsg(ply, words)
			end

			if rag and not rag.last_words then
				rag.last_words = words
			end
		else
			ply.last_words_id = nil
		end
	end
end
concommand.Add("_deathrec", LastWords)

-- Override or hook in plugin for spam prevention and whatnot. Return true
-- to block a command.
function GM:TTTPlayerRadioCommand(ply, msg_name, msg_target)

end

local function RadioCommand(ply, cmd, args)
	if IsValid(ply) and ply:IsTerror() and #args == 2 then
		local msg_name = args[1]
		local msg_target = args[2]

		local name = ""
		local rag_name = nil

		if tonumber(msg_target) then
			-- player or corpse ent idx
			local ent = Entity(tonumber(msg_target))

			if IsValid(ent) then
				if ent:IsPlayer() then
					name = ent:Nick()
				elseif ent:GetClass() == "prop_ragdoll" then
					name = LANG.NameParam("quick_corpse_id")
					rag_name = CORPSE.GetPlayerNick(ent, "A Terrorist")
				end
			end

			msg_target = ent
		else
			-- lang string
			name = LANG.NameParam(msg_target)
		end

		if hook.Call("TTTPlayerRadioCommand", GAMEMODE, ply, msg_name, msg_target) then
			return
		end

		net.Start("TTT_RadioMsg")
		net.WriteEntity(ply)
		net.WriteString(msg_name)
		net.WriteString(name)

		if rag_name then
			net.WriteString(rag_name)
		end

		net.Broadcast()
	end
end
concommand.Add("_ttt_radio_send", RadioCommand)
