---
-- Admin commands
-- @section AdminCommands

local math = math
local table = table
local player = player
local pairs = pairs
local ipairs = ipairs
local util = util
local IsValid = IsValid
local playerGetAll = player.GetAll

local function GetPrintFn(ply)
    if IsValid(ply) then
        return function(...)
            local t = ""

            for _, a in ipairs({ ... }) do
                t = t .. "\t" .. a
            end

            ply:PrintMessage(HUD_PRINTCONSOLE, t)
        end
    else
        return print
    end
end

local function TraitorSort(a, b)
    if not IsValid(a) then
        return true
    end

    if not IsValid(b) then
        return false
    end

    if a:GetTeam() == TEAM_TRAITOR and b:GetTeam() ~= TEAM_TRAITOR then
        return true
    end

    return false
end

---
-- Prints a list of all available Traitors in this round
-- @param Player ply
-- @realm server
function PrintTraitors(ply)
    if not IsValid(ply) or admin.IsAdmin(ply) then
        ServerLog(Format("%s used ttt_print_traitors\n", IsValid(ply) and ply:Nick() or "console"))

        local pr = GetPrintFn(ply)
        local ps = playerGetAll()

        table.sort(ps, TraitorSort)

        for _, p in ipairs(ps) do
            pr(string.upper(p:GetTeam()), ": ", p:Nick())
        end
    end
end
concommand.Add("ttt_print_traitors", PrintTraitors)

---
-- Prints the @{Player}s connected with their UserGroup
-- @param Player ply
-- @realm server
function PrintGroups(ply)
    local pr = GetPrintFn(ply)

    pr("User", "-", "Group")

    local plys = playerGetAll()
    for i = 1, #plys do
        local p = plys[i]
        pr(p:Nick(), "-", p:GetNWString("UserGroup"))
    end
end
concommand.Add("ttt_print_usergroups", PrintGroups)

---
-- Prints a killer report / log
-- @param Player ply
-- @realm server
function PrintReport(ply)
    local pr = GetPrintFn(ply)

    if not IsValid(ply) or admin.IsAdmin(ply) then
        ServerLog(
            Format("%s used ttt_print_adminreport\n", IsValid(ply) and ply:Nick() or "console")
        )

        for _, e in pairs(SCORE.Events) do
            if e.id == EVENT_KILL then
                if e.att.sid64 == -1 then
                    pr("<something> killed " .. e.vic.ni .. "[" .. string.upper(e.vic.t) .. "]")
                else
                    local as = "[" .. string.upper(e.att.t) .. "]"
                    local vs = "[" .. string.upper(e.vic.t) .. "]"

                    pr(as .. e.att.ni .. " killed " .. vs .. e.vic.ni)
                end
            end
        end
    else
        if IsValid(ply) then
            pr("You do not appear to be RCON or a superadmin!")
        end
    end
end
concommand.Add("ttt_print_adminreport", PrintReport)

local function PrintKarma(ply)
    local pr = GetPrintFn(ply)

    if not IsValid(ply) or admin.IsAdmin(ply) then
        ServerLog(Format("%s used ttt_print_karma\n", IsValid(ply) and ply:Nick() or "console"))

        KARMA.PrintAll(pr)
    else
        if IsValid(ply) then
            pr("You do not appear to be RCON or a superadmin!")
        end
    end
end
concommand.Add("ttt_print_karma", PrintKarma)

---
-- @realm server
local cv_ttt_highlight_admins =
    CreateConVar("ttt_highlight_admins", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
local cv_ttt_highlight_dev = CreateConVar("ttt_highlight_dev", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
local cv_ttt_highlight_vip = CreateConVar("ttt_highlight_vip", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
local cv_ttt_highlight_addondev =
    CreateConVar("ttt_highlight_addondev", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
local cv_ttt_highlight_supporter =
    CreateConVar("ttt_highlight_supporter", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

hook.Add("TTT2SyncGlobals", "AddScoreboardGlobals", function()
    SetGlobalBool(cv_ttt_highlight_admins:GetName(), cv_ttt_highlight_admins:GetBool())
    SetGlobalBool(cv_ttt_highlight_dev:GetName(), cv_ttt_highlight_dev:GetBool())
    SetGlobalBool(cv_ttt_highlight_vip:GetName(), cv_ttt_highlight_vip:GetBool())
    SetGlobalBool(cv_ttt_highlight_addondev:GetName(), cv_ttt_highlight_addondev:GetBool())
    SetGlobalBool(cv_ttt_highlight_supporter:GetName(), cv_ttt_highlight_supporter:GetBool())
end)

cvars.AddChangeCallback(cv_ttt_highlight_admins:GetName(), function(cv, old, new)
    SetGlobalBool(cv_ttt_highlight_admins:GetName(), tobool(tonumber(new)))
end)
cvars.AddChangeCallback(cv_ttt_highlight_dev:GetName(), function(cv, old, new)
    SetGlobalBool(cv_ttt_highlight_dev:GetName(), tobool(tonumber(new)))
end)
cvars.AddChangeCallback(cv_ttt_highlight_vip:GetName(), function(cv, old, new)
    SetGlobalBool(cv_ttt_highlight_vip:GetName(), tobool(tonumber(new)))
end)
cvars.AddChangeCallback(cv_ttt_highlight_addondev:GetName(), function(cv, old, new)
    SetGlobalBool(cv_ttt_highlight_addondev:GetName(), tobool(tonumber(new)))
end)
cvars.AddChangeCallback(cv_ttt_highlight_supporter:GetName(), function(cv, old, new)
    SetGlobalBool(cv_ttt_highlight_supporter:GetName(), tobool(tonumber(new)))
end)

---
-- @realm server
local dmglog_console =
    CreateConVar("ttt_log_damage_for_console", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
local dmglog_save = CreateConVar("ttt_damagelog_save", "0", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

local function PrintDamageLog(ply)
    local pr = GetPrintFn(ply)

    if not IsValid(ply) or admin.IsAdmin(ply) or gameloop.GetRoundState() ~= ROUND_ACTIVE then
        ServerLog(Format("%s used ttt_print_damagelog\n", IsValid(ply) and ply:Nick() or "console"))
        pr("*** Damage log:\n")

        if not dmglog_console:GetBool() then
            pr("Damage logging for console disabled. Enable with ttt_log_damage_for_console 1.")
        end

        for _, txt in ipairs(GAMEMODE.DamageLog) do
            pr(txt)
        end

        pr("*** Damage log end.")
    else
        if IsValid(ply) then
            pr("You do not appear to be RCON or a superadmin, nor are we in the post-round phase!")
        end
    end
end
concommand.Add("ttt_print_damagelog", PrintDamageLog)

local function SaveDamageLog()
    if not dmglog_save:GetBool() then
        return
    end

    local text = ""

    if #GAMEMODE.DamageLog == 0 then
        text = "Damage log is empty."
    else
        for _, txt in ipairs(GAMEMODE.DamageLog) do
            text = text .. txt .. "\n"
        end
    end

    local fname = Format("terrortown/logs/dmglog_%s_%d.txt", os.date("%d%b%Y_%H%M"), os.time())

    file.Write(fname, text)
end
hook.Add("TTTEndRound", "ttt_damagelog_save_hook", SaveDamageLog)

---
-- Adds a text to the DamageLog list
-- @param string txt
-- @realm server
function DamageLog(txt)
    local timestamp = math.max(0, CurTime() - gameloop.timeRoundStart)

    txt = util.SimpleTime(timestamp, "%02i:%02i.%02i - ") .. txt

    ServerLog(txt .. "\n")

    if dmglog_console:GetBool() or dmglog_save:GetBool() then
        table.insert(GAMEMODE.DamageLog, txt)
    end
end

---
-- Resets the damage log to an empty table.
-- @realm server
function ResetDamageLog()
    GAMEMODE.DamageLog = {}
end

---
-- @realm server
local ttt_bantype = CreateConVar("ttt_ban_type", "autodetect", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

local function DetectServerPlugin()
    if ULib and ULib.kickban then
        return "ulx"
    elseif evolve and evolve.Ban then
        return "evolve"
    elseif exsto and exsto.GetPlugin("administration") then
        return "exsto"
    else
        return "gmod"
    end
end

local function StandardBan(ply, length, reason)
    RunConsoleCommand("banid", length, ply:UserID())

    ply:Kick(reason)
end

local ban_functions = {
    ulx = ULib and ULib.kickban, -- has (ply, length, reason) signature
    evolve = function(p, l, r)
        evolve:Ban(p:UniqueID(), l * 60, r) -- time in seconds
    end,
    sm = function(p, l, r)
        game.ConsoleCommand(Format("sm_ban \"#%s\" %d \"%s\"\n", p:SteamID64(), l, r))
    end,
    exsto = function(p, l, r)
        local adm = exsto.GetPlugin("administration")

        if adm and adm.Ban then
            adm:Ban(nil, p, l, r)
        end
    end,
    gmod = StandardBan,
}

local function BanningFunction()
    local bantype = string.lower(ttt_bantype:GetString())

    if bantype == "autodetect" then
        bantype = DetectServerPlugin()
    end

    Dev(2, "Banning using " .. bantype .. " method.")

    return ban_functions[bantype] or ban_functions["gmod"]
end

---
-- Kicks and bans a @{Player} from the server
-- @param Player ply the target @{Player}
-- @param number length time of the ban
-- @param string reason
-- @realm server
function PerformKickBan(ply, length, reason)
    local banfn = BanningFunction()

    banfn(ply, length, reason)
end
