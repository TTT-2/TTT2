---
-- Communicating game state to players
-- @section GameMessage

local net = net
local string = string
local table = table
local IsValid = IsValid
local playerGetAll = player.GetAll

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
-- Subrole-specific message that will appear in a special color.
-- @param nil|Player|table ply_or_rfilter
-- @param string msg
-- @realm server
-- @deprecated
function TraitorMsg(ply_or_rfilter, msg)
    PlayerMsg(ply_or_rfilter, msg, true)
end

-- Teamchat
local function RoleChatMsg(sender, msg)
    local senderTeam = sender:GetTeam()
    local senderRoleData = sender:GetSubRoleData()

    if
        senderTeam == TEAM_NONE
        or senderRoleData.unknownTeam
        or senderRoleData.disabledTeamChat
        or TEAMS[senderTeam].alone
        ---
        -- @realm server
        or hook.Run("TTT2AvoidTeamChat", sender, senderTeam, msg) == false
    then
        return
    end

    net.Start("TTT_RoleChat")
    net.WritePlayer(sender)
    net.WriteString(msg)
    net.Send(GetTeamChatFilter(senderTeam))
end

---
-- Round start info popup.
-- @realm server
-- @internal
function ShowRoundStartPopup()
    local plys = playerGetAll()

    for i = 1, #plys do
        local ply = plys[i]

        if not IsValid(ply) or not ply:IsTerror() then
            continue
        end

        ply:ConCommand("ttt_cl_startpopup")
    end
end

---
-- Returns a list of filtered @{Player}s.
-- @param function pred
-- @return table
-- @realm server
function GetPlayerFilter(pred)
    local filter = {}
    local plys = playerGetAll()

    for i = 1, #plys do
        local ply = plys[i]

        if not pred(ply) then
            continue
        end

        filter[#filter + 1] = ply
    end

    return filter
end

---
-- Returns a list of filtered @{Player}s by the team.
-- @param string team
-- @param boolean aliveOnly
-- @param boolean ignoreUnknownTeam
-- @return table
-- @realm server
function GetTeamFilter(team, aliveOnly, ignoreUnknownTeam)
    return GetPlayerFilter(function(p)
        return team ~= TEAM_NONE
            and not TEAMS[team].alone
            and p:GetTeam() == team
            and (ignoreUnknownTeam or not p:GetSubRoleData().unknownTeam)
            and (not aliveOnly or p:IsTerror())
    end)
end

---
-- Returns a list of all @{Players} of the Innocent team.
-- @param boolean aliveOnly
-- @return table
-- @realm server
-- @see GetTeamFilter
function GetInnocentFilter(aliveOnly)
    return GetTeamFilter(TEAM_INNOCENT, aliveOnly)
end

---
-- Returns a list of all @{Players} of the Traitor team.
-- @param boolean aliveOnly
-- @return table
-- @realm server
-- @see GetTeamFilter
function GetTraitorFilter(aliveOnly)
    return GetTeamFilter(TEAM_TRAITOR, aliveOnly)
end

---
-- Returns a list of filtered @{Player}s by the @{ROLE}'s index.
-- @note If a BaseRole is given, this will return true for all its SubRoles.
-- If you just want to filter for a specific SubRole, use @{GetSubRoleFilter} instead
-- @param number subrole
-- @param boolean aliveOnly
-- @return table
-- @realm server
-- @see Player:IsRole
function GetRoleFilter(subrole, aliveOnly)
    return GetPlayerFilter(function(p)
        return p:IsRole(subrole) and (not aliveOnly or p:IsTerror())
    end)
end

---
-- Returns a list of filtered @{Player}s by the @{ROLE}'s SubRole index.
-- @param number subrole
-- @param boolean aliveOnly
-- @return table
-- @realm server
function GetSubRoleFilter(subrole, aliveOnly)
    return GetPlayerFilter(function(p)
        return p:GetSubRole() == subrole and (not aliveOnly or p:IsTerror())
    end)
end

---
-- Returns a list of all @{Players} of the Detective @{ROLE}'s index.
-- @param boolean aliveOnly
-- @return table
-- @realm server
-- @see GetRoleFilter
function GetDetectiveFilter(aliveOnly)
    return GetRoleFilter(ROLE_DETECTIVE, aliveOnly)
end

---
-- Returns a list of all @{Players} of a specific @{ROLE}'s index that are able to chat.
-- @param number subrole
-- @param boolean aliveOnly
-- @return table
-- @realm server
function GetRoleChatFilter(subrole, aliveOnly)
    if roles.GetByIndex(subrole).disabledTeamChat then
        return {}
    end

    return GetPlayerFilter(function(p)
        return p:IsRole(subrole)
            and not p:GetSubRoleData().disabledTeamChatRecv
            and (not aliveOnly or p:IsTerror())
    end)
end

---
-- Returns a list of all @{Players} of a specific team that are able to chat.
-- @param string team
-- @param boolean aliveOnly
-- @return table
-- @realm server
function GetTeamChatFilter(team, aliveOnly)
    return GetPlayerFilter(function(ply)
        local plyRoleData = ply:GetSubRoleData()

        return team ~= TEAM_NONE
            and not TEAMS[team].alone
            and ply:GetTeam() == team
            and not plyRoleData.unknownTeam
            and not plyRoleData.disabledTeamChatRecv
            and (not aliveOnly or ply:IsTerror())
    end)
end

---
-- Returns a list of filtered @{Player}s.
-- This filters the team members of a given @{Player}
-- @param Player ply
-- @param boolean aliveOnly
-- @return table
-- @realm server
function GetTeamMemberFilter(ply, aliveOnly)
    return GetPlayerFilter(function(p)
        return p:IsInTeam(ply) and (not aliveOnly or p:IsTerror())
    end)
end

-- Communication control

---
-- @realm server
local cv_ttt_spectators_chat_globally =
    CreateConVar("ttt_spectators_chat_globally", "0", { FCVAR_ARCHIVE, FCVAR_NOTIFY })

---
-- Returns whether or not the @{Player} can see the other @{Player}'s chat.
-- @param string text The chat text
-- @param boolean teamOnly If the message is team-only
-- @param Player listener The player receiving the message
-- @param Player sender The player sending the message.
-- @return boolean Returns if a player can see the player's chat
-- @hook
-- @realm server
-- @internal
function GM:PlayerCanSeePlayersChat(text, teamOnly, listener, sender)
    if not IsValid(listener) then
        return false
    end

    if not IsValid(sender) then
        if IsEntity(sender) then
            return true
        end

        return false
    end

    local senderIsSpectator = sender:Team() == TEAM_SPEC
    local listenerIsSpectator = listener:Team() == TEAM_SPEC
    local senderRoleData = sender:GetSubRoleData()

    if
        gameloop.GetRoundState() ~= ROUND_ACTIVE -- Round isn't active
        or cv_ttt_spectators_chat_globally:GetBool() -- Spectators can chat freely
        or not gameloop.IsDetectiveMode() -- Mumbling
        or not senderIsSpectator and not teamOnly -- General Chat
        or not senderIsSpectator
            and teamOnly
            and ( -- Team Chat
                sender:IsInTeam(listener)
                and not senderRoleData.unknownTeam
                and not senderRoleData.disabledTeamChat
                and not listener:GetSubRoleData().disabledTeamChatRecv
                ---
                -- @realm server
                and hook.Run("TTT2CanSeeChat", listener, sender, teamOnly) ~= true
            )
        or senderIsSpectator and listenerIsSpectator -- If the sender and listener are spectators
    then
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
    "mfrrm",
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

    if gameloop.GetRoundState() == ROUND_ACTIVE then
        local team_spec = ply:Team() == TEAM_SPEC

        if team_spec and not gameloop.IsDetectiveMode() then
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
            if
                ply:GetSubRoleData().disabledGeneralChat
                or hook.Run("TTT2AvoidGeneralChat", ply, text) == false
            then
                return ""
            end
        end
    end

    return text or ""
end

---
-- @realm server
local ttt_lastwords = CreateConVar("ttt_lastwords_chatprint", "0", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

local LastWordContext = {
    [KILL_NORMAL] = "",
    [KILL_SUICIDE] = " *kills self*",
    [KILL_FALL] = " *SPLUT*",
    [KILL_BURN] = " *crackle*",
}

local function LastWordsMsg(ply, words)
    -- only append "--" if there's no ending interpunction
    local final = string.match(words, "[\\.\\!\\?]$") ~= nil

    -- add optional context relating to death type
    local context = LastWordContext[ply.death_type] or ""

    local lastWordsStr = words .. (final and "" or "--") .. context

    ---
    -- @realm server
    if hook.Run("TTTLastWordsMsg", ply, lastWordsStr, words) ~= true then
        net.Start("TTT_LastWordsMsg")
        net.WritePlayer(ply)
        net.WriteString(lastWordsStr)
        net.Broadcast()
    end
end

local function deathrec(ply, cmd, args)
    if not IsValid(ply) or ply:Alive() or #args <= 1 then
        return
    end

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
            rag.lastid = { ent = ent, t = CurTime() }
        end
    end

    -- last words
    local words = string.Trim(args[3])

    -- nothing of interest
    if string.len(words) < 2 then
        return
    end

    -- ignore admin commands
    local firstchar = string.sub(words, 1, 1)

    if firstchar == "!" or firstchar == "@" or firstchar == "/" then
        return
    end

    if ttt_lastwords:GetBool() or ply.death_type == KILL_FALL then
        LastWordsMsg(ply, words)
    end

    if rag and not rag.last_words then
        rag.last_words = words
    end
end
concommand.Add("_deathrec", deathrec)

local function ttt_radio_send(ply, cmd, args)
    if not IsValid(ply) or not ply:IsTerror() or #args ~= 2 then
        return
    end

    local msgName = args[1]
    local msgTarget = args[2]

    local name = ""
    local ragPlayerNick = nil

    if tonumber(msgTarget) then
        -- player or corpse ent idx
        local ent = Entity(tonumber(msgTarget))

        if IsValid(ent) then
            if ent:IsPlayer() then
                name = ent:Nick()
            elseif ent:IsPlayerRagdoll() then
                name = LANG.NameParam("quick_corpse_id")
                ragPlayerNick = CORPSE.GetPlayerNick(ent, "A Terrorist")
            end
        end

        msgTarget = ent
    else
        -- lang string
        name = LANG.NameParam(msgTarget)
    end

    ---
    -- @realm server
    if hook.Run("TTTPlayerRadioCommand", ply, msgName, msgTarget) then
        return
    end

    net.Start("TTT_RadioMsg")
    net.WritePlayer(ply)
    net.WriteString(msgName)
    net.WriteString(name)

    if ragPlayerNick then
        net.WriteString(ragPlayerNick)
    end

    net.Broadcast()
end
concommand.Add("_ttt_radio_send", ttt_radio_send)

---
-- Called when a player tries to use a quickchat/radio command. You can use this
-- for anti-spam measures or to replace or modify a message.
-- @param Player ply The player that tries to send a message command
-- @param string msgName The message identifier, such as `quick_yes` for `Yes.`
-- @param number|string msgTarget The target part of the command (an entity index if it's a
-- player or identified corpse, an identifier like "quick_nobody" if not)
-- @return[default=nil] boolean Return true to not send this message
-- @hook
-- @realm server
function GM:TTTPlayerRadioCommand(ply, msgName, msgTarget) end

---
-- Called when a player tries to speak their last words on death
-- @param Player ply The player that is sending their last words
-- @param string msg The last words that is about to be sent
-- @param string msgOriginal The original unmodified message
-- @return[default=nil] boolean Return true to block last words
-- @hook
-- @realm server
function GM:TTTLastWordsMsg(ply, msg, msgOriginal) end

---
-- Whether or not the @{Player} can receive the chat message.
-- @param Player reader The @{Player} who can receive chat
-- @param Player sender The @{Player} who sends the text message
-- @param boolean isTeam Are they trying to use the team chat
-- @return[default=true] boolean Return true if the reader should be able to see the message of the sender, false if they shouldn't
-- @hook
-- @realm server
function GM:TTT2CanSeeChat(reader, sender, isTeam)
    return true
end

---
-- Cancelable hook to block a team chat message.
-- @param Player sender The player that sends the message.
-- @param string team The team identifier
-- @param string msg The message that is about to be sent
-- @return nil|boolean Return false to block message
-- @hook
-- @realm server
function GM:TTT2AvoidTeamChat(sender, team, msg) end

---
-- Cancelable hook to block a general chat message.
-- @param Player sender The player that sends the message.
-- @param string msg The message that is about to be sent
-- @return nil|boolean Return false to block message
-- @hook
-- @realm server
function GM:TTT2AvoidGeneralChat(sender, msg) end
