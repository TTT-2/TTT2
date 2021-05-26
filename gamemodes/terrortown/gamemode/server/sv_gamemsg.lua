---
-- Communicating game state to players
-- @section GameMessage

local net = net
local string = string
local table = table
local IsValid = IsValid

---
-- Sends a GameMessage to every @{Player}
-- @note most uses of the Msg functions here have been moved to the LANG
-- functions. These functions are essentially deprecated, though they won't be
-- removed and can safely be used by SWEPs and the like.
-- @param string msg
-- @realm server
-- @deprecated
function GameMsg(msg)
	net.Start("TTT_GameMsg")
	net.WriteString(msg)
	net.WriteBit(false)
	net.Broadcast()
end

---
-- Sends a custom GameMessage to a group of @{Player} in a specific @{Color}
-- @param nil|Player|table ply_or_rf
-- @param string msg
-- @param Color c
-- @realm server
-- @deprecated
function CustomMsg(ply_or_rf, msg, c)
	c = c or COLOR_WHITE

	net.Start("TTT_GameMsgColor")
	net.WriteString(msg)
	net.WriteUInt(c.r, 8)
	net.WriteUInt(c.g, 8)
	net.WriteUInt(c.b, 8)

	if ply_or_rf then
		net.Send(ply_or_rf)
	else
		net.Broadcast()
	end
end

---
-- Basic status message to single player or a recipientfilter
-- @param nil|Player|table ply_or_rf
-- @param string msg
-- @param boolean traitor_only
-- @realm server
-- @deprecated
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

---
-- Subrole-specific message that will appear in a special color
-- @param nil|Player|table ply_or_rfilter
-- @param string msg
-- @realm server
-- @deprecated
function TraitorMsg(ply_or_rfilter, msg)
	PlayerMsg(ply_or_rfilter, msg, true)
end

-- Teamchat
local function RoleChatMsg(sender, msg)
	local tm = sender:GetTeam()

	---
	-- @realm server
	if tm == TEAM_NONE or sender:GetSubRoleData().unknownTeam or sender:GetSubRoleData().disabledTeamChat or TEAMS[tm].alone or hook.Run("TTT2AvoidTeamChat", sender, tm, msg) == false then return end

	net.Start("TTT_RoleChat")
	net.WriteEntity(sender)
	net.WriteString(msg)
	net.Send(GetTeamChatFilter(tm))
end

---
-- Round start info popup
-- @realm server
-- @internal
function ShowRoundStartPopup()
	local plys = player.GetAll()

	for i = 1, #plys do
		local v = plys[i]

		if not IsValid(v) or v:Team() ~= TEAM_TERROR or not v:Alive() then continue end

		v:ConCommand("ttt_cl_startpopup")
	end
end

---
-- Returns a list of filtered @{Player}s
-- @param function pred
-- @return table
-- @realm server
function GetPlayerFilter(pred)
	local filter = {}
	local plys = player.GetAll()

	for i = 1, #plys do
		if not pred(plys[i]) then continue end

		filter[#filter + 1] = plys[i]
	end

	return filter
end

---
-- Returns a list of filtered @{Player}s by the team
-- @param string team
-- @param boolean alive_only
-- @return table
-- @realm server
function GetTeamFilter(team, alive_only)
	return GetPlayerFilter(function(p)
		return team ~= TEAM_NONE and not TEAMS[team].alone and p:GetTeam() == team and not p:GetSubRoleData().unknownTeam and (not alive_only or p:IsTerror())
	end)
end

---
-- Returns a list of all @{Players} of the Innocent team
-- @param boolean alive_only
-- @return table
-- @realm server
-- @see GetTeamFilter
function GetInnocentFilter(alive_only)
	return GetTeamFilter(TEAM_INNOCENT, alive_only)
end

---
-- Returns a list of all @{Players} of the Traitor team
-- @param boolean alive_only
-- @return table
-- @realm server
-- @see GetTeamFilter
function GetTraitorFilter(alive_only)
	return GetTeamFilter(TEAM_TRAITOR, alive_only)
end

---
-- Returns a list of filtered @{Player}s by the @{ROLE}'s index
-- @note If a BaseRole is given, this will return true for all its SubRoles.
-- If you just want to filter for a specific SubRole, use @{GetSubRoleFilter} instead
-- @param number subrole
-- @param boolean alive_only
-- @return table
-- @realm server
-- @see Player:IsRole
function GetRoleFilter(subrole, alive_only)
	return GetPlayerFilter(function(p)
		return p:IsRole(subrole) and (not alive_only or p:IsTerror())
	end)
end

---
-- Returns a list of filtered @{Player}s by the @{ROLE}'s SubRole index
-- @param number subrole
-- @param boolean alive_only
-- @return table
-- @realm server
function GetSubRoleFilter(subrole, alive_only)
	return GetPlayerFilter(function(p)
		return p:GetSubRole() == subrole and (not alive_only or p:IsTerror())
	end)
end

---
-- Returns a list of all @{Players} of the Detective @{ROLE}'s index
-- @param boolean alive_only
-- @return table
-- @realm server
-- @see GetRoleFilter
function GetDetectiveFilter(alive_only)
	return GetRoleFilter(ROLE_DETECTIVE, alive_only)
end

---
-- Returns a list of all @{Players} of a specific @{ROLE}'s index that are able to chat
-- @param number subrole
-- @param boolean alive_only
-- @return table
-- @realm server
function GetRoleChatFilter(subrole, alive_only)
	if roles.GetByIndex(subrole).disabledTeamChat then
		return {}
	end

	return GetPlayerFilter(function(p)
		return p:IsRole(subrole) and not p:GetSubRoleData().disabledTeamChatRec and (not alive_only or p:IsTerror())
	end)
end

---
-- Returns a list of all @{Players} of a specific team that are able to chat
-- @param string team
-- @param boolean alive_only
-- @return table
-- @realm server
function GetTeamChatFilter(team, alive_only)
	return GetPlayerFilter(function(p)
		return team ~= TEAM_NONE and not TEAMS[team].alone and p:GetTeam() == team and not p:GetSubRoleData().unknownTeam and not p:GetSubRoleData().disabledTeamChatRec and (not alive_only or p:IsTerror())
	end)
end

---
-- Returns a list of filtered @{Player}s.
-- This filters the team members of a given @{Player}
-- @param Player ply
-- @param boolean alive_only
-- @return table
-- @realm server
function GetTeamMemberFilter(ply, alive_only)
	return GetPlayerFilter(function(p)
		return p:IsInTeam(ply) and (not alive_only or p:IsTerror())
	end)
end

-- Communication control

---
-- @realm server
local cv_ttt_limit_spectator_chat = CreateConVar("ttt_limit_spectator_chat", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY})

---
-- Returns whether or not the @{Player} can see the other @{Player}'s chat.
-- @param string text
-- @param boolean teamOnly
-- @param Player reader
-- @param Player sender
-- @return boolean
-- @hook
-- @realm server
-- @internal
function GM:PlayerCanSeePlayersChat(text, teamOnly, reader, sender)
	if not IsValid(reader) then
		return false
	end

	if not IsValid(sender) then
		if IsEntity(sender) then
			return true
		end

		return false
	end

	local sTeam = sender:Team() == TEAM_SPEC
	local lTeam = reader:Team() == TEAM_SPEC

	if GetRoundState() ~= ROUND_ACTIVE -- Round isn't active
	or not cv_ttt_limit_spectator_chat:GetBool() -- Spectators can chat freely
	or not DetectiveMode() -- Mumbling
	or not sTeam and not teamOnly -- General Chat
	or not sTeam and teamOnly and ( -- Team Chat
		sender:IsInTeam(reader)
		and not sender:GetSubRoleData().unknownTeam
		and not sender:GetSubRoleData().disabledTeamChat
		and not reader:GetSubRoleData().disabledTeamChatRecv
		---
		-- @realm server
		and hook.Run("TTT2CanSeeChat", reader, sender, teamOnly) ~= true
	) or sTeam and lTeam then -- If the sender and reader are spectators
		return true
	end

	return false
end

---
-- Whether or not the @{Player} can receive the chat message.
-- @param Player reader @{Player} who can receive chat
-- @param Player sender @{Player} who sends the text message
-- @param boolean isTeam Are they trying to use the team chat
-- @return[default=true] boolean Return true if the reader should be able to see the message of the sender, false if they shouldn't
-- @hook
-- @realm server
function GM:TTT2CanSeeChat(reader, sender, isTeam)
	return true
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

---
-- While a round is active, spectators can only talk among themselves. When they
-- try to speak to all players they could divulge information about who killed
-- them. So we mumblify them. In detective mode, we shut them up entirely.
-- @param Player ply
-- @param string text
-- @param boolean teamOnly
-- @return string
-- @hook
-- @realm server
-- @internal
function GM:PlayerSay(ply, text, teamOnly)
	if not IsValid(ply) then
		return text or ""
	end

	if GetRoundState() == ROUND_ACTIVE then
		local team_spec = ply:Team() == TEAM_SPEC

		if team_spec and not DetectiveMode() then
			local filtered = {}
			local parts = string.Explode(" ", text)

			for i = 1, #parts do
				-- grab word characters and whitelisted interpunction
				-- necessary or leetspeek will be used (by trolls especially)
				local word, interp = string.match(parts[i], "(%a*)([%.,!%?]*)")

				if word ~= "" then
					filtered[#filtered + 1] = mumbles[math.random(#mumbles)] .. interp
				end
			end

			-- make sure we have something to say
			if #filtered < 1 then
				filtered[#filtered + 1] = mumbles[math.random(#mumbles)]
			end

			table.insert(filtered, 1, "[MUMBLED]")

			return table.concat(filtered, " ")
		elseif teamOnly and not team_spec then -- Team Chat handling
			RoleChatMsg(ply, text)

			return ""
		elseif not team_spec then -- General Chat handling
			---
			-- @realm server
			if ply:GetSubRoleData().disabledGeneralChat or hook.Run("TTT2AvoidGeneralChat", ply, text) == false then
				return ""
			end
		end
	end

	return text or ""
end

---
-- @realm server
local ttt_lastwords = CreateConVar("ttt_lastwords_chatprint", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

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

local function deathrec(ply, cmd, args)
	if not IsValid(ply) or ply:Alive() or #args <= 1 then return end

	local id = tonumber(args[1])

	if not id or not ply.last_words_id or id ~= ply.last_words_id then
		ply.last_words_id = nil

		return
	end

	-- never allow multiple last word stuff
	ply.last_words_id = nil

	-- we will be storing this on the ragdoll
	local rag = ply.server_ragdoll

	if not (IsValid(rag) and rag.player_ragdoll) then
		rag = nil
	end

	-- last id'd person
	local last_seen = tonumber(args[2])

	if last_seen then
		local ent = Entity(last_seen)

		if IsValid(ent) and ent:IsPlayer() and rag and not rag.lastid then
			rag.lastid = {ent = ent, t = CurTime()}
		end
	end

	-- last words
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
end
concommand.Add("_deathrec", deathrec)

---
-- Override or hook in plugin for spam prevention and whatnot. Return true
-- to block a command.
-- @param Player ply
-- @param string msg_name
-- @param Player msg_target
-- @return[default=nil] boolean
-- @hook
-- @realm server
function GM:TTTPlayerRadioCommand(ply, msg_name, msg_target)

end

local function ttt_radio_send(ply, cmd, args)
	if not IsValid(ply) or not ply:IsTerror() or #args ~= 2 then return end

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

	---
	-- @realm server
	if hook.Run("TTTPlayerRadioCommand", ply, msg_name, msg_target) then return end

	net.Start("TTT_RadioMsg")
	net.WriteEntity(ply)
	net.WriteString(msg_name)
	net.WriteString(name)

	if rag_name then
		net.WriteString(rag_name)
	end

	net.Broadcast()
end
concommand.Add("_ttt_radio_send", ttt_radio_send)
