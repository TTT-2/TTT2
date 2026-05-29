---
-- radio commands, text chat stuff
-- @section chat_manager

DEFINE_BASECLASS("gamemode_base")

local GetTranslation = LANG.GetTranslation
local string = string
local chat = chat
local net = net

local color_1 = Color(150, 150, 150)
local color_2 = Color(50, 200, 255)
local color_3 = Color(0, 200, 0)
local color_4 = Color(255, 200, 20)
local color_5 = Color(255, 255, 200)

local function LastWordsRecv()
    local sender = net.ReadPlayer()
    local words = net.ReadString()

    local validSender = IsValid(sender)

    local was_detective = validSender and sender:IsDetective()
    local nick = validSender and sender:Nick() or "<Unknown>"

    chat.AddText(
        color_1,
        Format("(%s) ", string.upper(GetTranslation("last_words"))),
        was_detective and color_2 or color_3,
        nick,
        COLOR_WHITE,
        ": " .. words
    )
end
net.Receive("TTT_LastWordsMsg", LastWordsRecv)

local function TTT_RoleChat()
    local sender = net.ReadPlayer()
    if not IsValid(sender) then
        return
    end

    local text = net.ReadString()
    local roleData = sender:GetSubRoleData() -- use cached role

    chat.AddText(
        sender:GetRoleColor(),
        Format("(%s) ", string.upper(GetTranslation(roleData.name))),
        color_4,
        sender:Nick(),
        color_5,
        ": " .. text
    )
end
net.Receive("TTT_RoleChat", TTT_RoleChat)

--
-- Returns the color for the given entity's team.
-- @param Entity ent The @{Entity}
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:GetTeamColor
-- @local
function GM:GetTeamColor(ent)
    -- don't reveal that a player has died when they happen to chat or voicechat at the moment of death
    if
        not LocalPlayer():IsSpec()
        and ent:IsPlayer()
        and ent:IsSpec()
        and ScoreGroup(ent) == GROUP_NOTFOUND
    then
        --
        -- @realm client
        return hook.Run("GetTeamNumColor", TEAM_TERROR)
    end

    return BaseClass.GetTeamColor(self, ent)
end

---
-- Called when a message is printed to the chat box. Note, that this isn't
-- working with @{Player} messages even though there are arguments for it.<br />
-- For @{Player} messages see @{GM:PlayerSay} and @{GM:OnPlayerChat}
-- @note special processing for certain special chat types
-- @param number idx The index of the @{Player}
-- @param string name The name of the @{Player}
-- @param string text The text that is being sent
-- @param string type Chat filter type. Possible values are:
-- <ul>
-- <li>joinleave - @{Player} join and leave messages</li>
-- <li>namechange - @{Player} name change messages</li>
-- <li>servermsg - Server messages such as convar changes</li>
-- <li>teamchange - Team changes?</li>
-- <li>chat - (Obsolete?) @{Player} chat?</li>
-- <li>none - A fallback value</li>
-- </ul>
-- @return boolean Return true to suppress the chat message
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:ChatText
-- @local
function GM:ChatText(idx, name, text, type)
    if type == "joinleave" and string.find(text, "Changed name during a round") then
        -- prevent nick from showing up
        chat.AddText(LANG.GetTranslation("name_kick"))

        return true
    end

    return BaseClass.ChatText(self, idx, name, text, type)
end

---
-- Detectives have a blue name, in both chat and radio messages
-- @param Player ply
-- @param string text
-- @realm client
function AddDetectiveText(ply, text)
    chat.AddText(roles.DETECTIVE.color, ply:Nick(), COLOR_WHITE, ": " .. text)
end

---
-- Called whenever a @{Player} sends a chat message. For the serverside equivalent, see @{GM:PlayerSay}.
-- @note The text input of this hook depends on @{GM:PlayerSay}.
-- If it is suppressed on the server, it will be suppressed on the client.
-- @param Player ply The @{Player}
-- @param string text The message's text
-- @param boolean teamchat Is the @{Player} typing in team chat?
-- @param boolean isDead Is the @{Player} dead?
-- @return boolean Should the message be suppressed?
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:OnPlayerChat
-- @local
function GM:OnPlayerChat(ply, text, teamChat, isDead)
    if not IsValid(ply) then
        return BaseClass.OnPlayerChat(self, ply, text, teamChat, isDead)
    end

    local plyRoleData = ply:GetSubRoleData()

    -- send detective-like message if role is public policing role
    -- note: while it seems like is not nessecary to check if the role is public because
    -- only a public role is synced, this is still checked here to make sure it works
    -- well with revivals. A non-public role won't be counted as public policing role
    -- if they were revived and their role is known.
    if ply:IsActive() and plyRoleData.isPolicingRole and plyRoleData.isPublicRole then
        AddDetectiveText(ply, text)

        return true
    end

    local sTeam = ply:Team() == TEAM_SPEC

    if sTeam and not isDead then
        isDead = true
    end

    if teamChat and (sTeam or ply:GetSubRoleData().unknownTeam) then
        teamChat = false
    end

    return BaseClass.OnPlayerChat(self, ply, text, teamChat, isDead)
end

local last_chat = ""

---
-- Called whenever the content of the user's chat input box is changed.
-- @param string text The new contents of the input box
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:ChatTextChanged
-- @local
function GM:ChatTextChanged(text)
    last_chat = text
end

---
-- Interrupts the chat
-- @realm client
-- @internal
function ChatInterrupt()
    local client = LocalPlayer()
    local id = net.ReadUInt(32)

    local last_seen = IsValid(client.last_id) and client.last_id:EntIndex() or 0
    local last_words = "."

    if last_chat == "" then
        if RADIO.LastRadio.t > CurTime() - 2 then
            last_words = RADIO.LastRadio.msg
        end
    else
        last_words = last_chat
    end

    RunConsoleCommand("_deathrec", tostring(id), tostring(last_seen), last_words)
end
net.Receive("TTT_InterruptChat", ChatInterrupt)
