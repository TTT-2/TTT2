---
-- Shared language stuff
-- @module LANG

-- tbl is first created here on both server and client
-- could make it a module but meh
if LANG then
    return
end

LANG = {}

-- define LANG.Msg modes
MSG_MSTACK_ROLE = 0
MSG_MSTACK_WARN = 1
MSG_MSTACK_PLAIN = 2

MSG_CHAT_ROLE = 3
MSG_CHAT_WARN = 4
MSG_CHAT_PLAIN = 5

MSG_CONSOLE = 6

MSG_MODE_BITS = 3

util.IncludeClientFile("terrortown/gamemode/client/cl_lang.lua")

local net = net
local table = table
local pairs = pairs
local string = string

fileloader.LoadFolder("terrortown/lang/", false, CLIENT_FILE, function(path)
    Dev(1, "Added TTT2 core language file: ", path)
end)

if SERVER then
    local count = table.Count

    ---
    -- Sends a message to (a) specific target(s) in their selected language
    -- @param[opt] number|table|Player arg1 the target(s) that should receive this message
    -- @param string arg2 the translation key name
    -- @param any arg3
    -- @param any arg4 params
    -- @note Can be called as:
    --   1) LANG.Msg(ply, name, params, mode)  -- sent to ply
    --   2) LANG.Msg(name, params, mode)       -- sent to all
    --   3) LANG.Msg(role, name, params, mode) -- sent to plys with role
    -- @realm server
    function LANG.Msg(arg1, arg2, arg3, arg4)
        if isstring(arg1) then
            LANG.ProcessMsg(nil, arg1, arg2, arg3)
        elseif isnumber(arg1) then
            LANG.ProcessMsg(GetRoleChatFilter(arg1), arg2, arg3, arg4)
        else
            LANG.ProcessMsg(arg1, arg2, arg3, arg4)
        end
    end

    ---
    -- Sends a message to (a) specific target(s) in their selected language
    -- @param table|Player send_to the target(s) that should receive this message
    -- @param string name the translation key name
    -- @param any params params
    -- @param number mode [MSG_MSTACK_ROLE, MSG_MSTACK_WARN, MSG_MSTACK_PLAIN,
    -- MSG_CHAT_ROLE, MSG_CHAT_WARN, MSG_CHAT_PLAIN, MSG_CONSOLE]
    -- @realm server
    -- @internal
    function LANG.ProcessMsg(send_to, name, params, mode)
        -- don't want to send to null ents, but can't just IsValid send_to because
        -- it may be a recipientfilter, so type check first
        if type(send_to) == "Player" and not IsValid(send_to) then
            return
        end

        -- make mode valid, use MSG_MSTACK_PLAIN as default since it was always this way
        mode = mode or MSG_MSTACK_PLAIN

        -- number of keyval param pairs to send
        local c = params and count(params) or 0

        net.Start("TTT_LangMsg")
        net.WriteString(name)
        net.WriteUInt(mode, MSG_MODE_BITS)
        net.WriteUInt(c, 8)

        if c > 0 then
            for k, v in pairs(params) do
                -- assume keys are strings, but vals may be numbers
                net.WriteString(k)
                net.WriteString(tostring(v))
            end
        end

        if send_to then
            net.Send(send_to)
        else
            net.Broadcast()
        end
    end

    ---
    -- Sends a message to all players in their selected language
    -- @param string name the translation key name
    -- @param any params params
    -- @param number mode [MSG_MSTACK_ROLE, MSG_MSTACK_WARN, MSG_MSTACK_PLAIN,
    -- MSG_CHAT_ROLE, MSG_CHAT_WARN, MSG_CHAT_PLAIN, MSG_CONSOLE]
    -- @realm server
    -- @internal
    function LANG.MsgAll(name, params, mode)
        LANG.Msg(nil, name, params, mode)
    end

    ---
    -- @realm server
    local cv_ttt_lang_serverdefault = CreateConVar("ttt_lang_serverdefault", "en", FCVAR_ARCHIVE)

    local function ServerLangRequest(ply, cmd, args)
        if not IsValid(ply) then
            return
        end

        net.Start("TTT_ServerLang")
        net.WriteString(cv_ttt_lang_serverdefault:GetString())
        net.Send(ply)
    end

    concommand.Add("_ttt_request_serverlang", ServerLangRequest)
else -- CLIENT
    -- @ignore
    local function RecvMsg()
        local name = net.ReadString()
        local mode = net.ReadUInt(MSG_MODE_BITS)
        local c = net.ReadUInt(8)

        local params

        if c > 0 then
            params = {}

            for i = 1, c do
                params[net.ReadString()] = net.ReadString()
            end
        end

        -- this is LANG.ProcessMsg
        LANG.Msg(name, params, mode)
    end
    net.Receive("TTT_LangMsg", RecvMsg)

    -- maybe this really strange coding style has a reason ...
    LANG.Msg = LANG.ProcessMsg

    local function RecvServerLang()
        local lang_name = net.ReadString()

        lang_name = LANG.GetNameFromAlias(lang_name)

        if LANG.Strings[lang_name] then
            if LANG.IsServerDefault(GetConVar("ttt_language"):GetString()) then
                LANG.SetActiveLanguage(lang_name)
            end

            LANG.ServerLanguage = lang_name

            Dev(1, "Server default language is: ", lang_name)
        end
    end
    net.Receive("TTT_ServerLang", RecvServerLang)
end

---
-- It can be useful to send string names as params, that the client can then
-- localize before interpolating. However, we want to prevent user input like
-- nicknames from being localized, so mark string names with something users
-- can't input.
-- @param string name
-- @return string transformed name
-- @realm shared
function LANG.NameParam(name)
    return "LID\t" .. name
end

LANG.Param = LANG.NameParam

---
-- Returns the matches based on the transformation of @{LANG.NameParam}
-- @param string str
-- @return table list of matched params
-- @realm shared
function LANG.GetNameParam(str)
    return string.match(str, "^LID\t([%w_]+)$")
end
