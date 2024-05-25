---
-- Trouble in Terrorist Town 2

ttt_include("sh_init")

ttt_include("sh_cvar_handler")

ttt_include("sh_sprint")
ttt_include("sh_main")
ttt_include("sh_shop")
ttt_include("sh_shopeditor")
ttt_include("sh_network_sync")
ttt_include("sh_door")
ttt_include("sh_voice")
ttt_include("sh_printmessage_override")
ttt_include("sh_speed")
ttt_include("sh_marker_vision_element")

ttt_include("sv_network_sync")
ttt_include("sv_hud_manager")
ttt_include("sv_shopeditor")
ttt_include("sv_karma")
ttt_include("sv_entity")
ttt_include("sv_inventory")

ttt_include("sh_scoring")

ttt_include("sv_admin")
ttt_include("sv_networking")
ttt_include("sv_propspec")
ttt_include("sv_shop")
ttt_include("sv_weaponry")
ttt_include("sv_gamemsg")
ttt_include("sv_voice")
ttt_include("sv_ent_replace")
ttt_include("sv_scoring")
ttt_include("sv_corpse")
ttt_include("sv_status")
ttt_include("sv_eventpopup")

ttt_include("sv_armor")
ttt_include("sh_armor")

ttt_include("sh_player_ext")

ttt_include("sv_player_ext")
ttt_include("sv_player")

ttt_include("sv_addonchecker")
ttt_include("sv_roleselection")
ttt_include("sh_rolelayering")

include("ttt2/libraries/entspawn.lua")
include("ttt2/libraries/plyspawn.lua")
include("ttt2/libraries/entity_outputs.lua")
include("ttt2/libraries/credits.lua")

-- Localize stuff we use often. It's like Lua go-faster stripes.
local math = math
local table = table
local net = net
local player = player
local timer = timer
local util = util
local IsValid = IsValid
local hook = hook
local playerGetAll = player.GetAll

---
-- @realm server
-- stylua: ignore
local ttt_haste = CreateConVar("ttt_haste", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
CreateConVar("ttt_haste_minutes_per_death", "0.5", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

-- Credits

---
-- @realm server
-- stylua: ignore
CreateConVar("ttt_credits_award_pct", "0.35", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
CreateConVar("ttt_credits_award_size", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
CreateConVar("ttt_credits_award_repeat", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
CreateConVar("ttt_credits_award_kill", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
local ttt_session_limits_enabled = CreateConVar("ttt_session_limits_enabled", "1", SERVER and {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED)

---
-- @realm server
-- stylua: ignore
local idle_enabled = CreateConVar("ttt_idle", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
local idle_time = CreateConVar("ttt_idle_limit", "180", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
local voice_drain = CreateConVar("ttt_voice_drain", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
local voice_drain_normal = CreateConVar("ttt_voice_drain_normal", "0.2", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
local voice_drain_admin = CreateConVar("ttt_voice_drain_admin", "0.05", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
local voice_drain_recharge = CreateConVar("ttt_voice_drain_recharge", "0.05", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
local namechangekick = CreateConVar("ttt_namechange_kick", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
local namechangebtime = CreateConVar("ttt_namechange_bantime", "10", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
local ttt_detective = CreateConVar("ttt_sherlock_mode", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
CreateConVar("ttt2_prep_respawn", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Respawn if dead in preparing time")

---
-- @realm server
-- stylua: ignore
local map_switch_delay = CreateConVar("ttt2_map_switch_delay", "15", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Time that passes before the map is changed after the last round ends or the timer runs out", 0)

---
-- @realm server
-- stylua: ignore
CreateConVar("ttt_identify_body_woconfirm", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Toggles whether ragdolls should be confirmed in DetectiveMode() without clicking on confirm espacially")

---
-- @realm server
-- stylua: ignore
local confirm_team = CreateConVar("ttt2_confirm_team", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Show team of confirmed player")

---
-- @realm server
-- stylua: ignore
CreateConVar("ttt2_confirm_killlist", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Confirm players in kill list")

---
-- @realm server
-- stylua: ignore
CreateConVar("ttt_enforce_playermodel", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Whether or not to enforce terrorist playermodels. Set to 0 for compatibility with Enhanced Playermodel Selector")

---
-- @realm server
-- stylua: ignore
local ttt_dbgwin = CreateConVar("ttt_debug_preventwin", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
-- stylua: ignore
CreateConVar("ttt_newroles_enabled", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

-- Pool some network names.
util.AddNetworkString("TTT_RoundState")
util.AddNetworkString("TTT_GameMsg")
util.AddNetworkString("TTT_GameMsgColor")
util.AddNetworkString("TTT_RoleChat")
util.AddNetworkString("TTT_RoleVoiceState")
util.AddNetworkString("TTT_LastWordsMsg")
util.AddNetworkString("TTT_RadioMsg")
util.AddNetworkString("TTT_ReportStream")
util.AddNetworkString("TTT_LangMsg")
util.AddNetworkString("TTT_ServerLang")
util.AddNetworkString("TTT_Equipment")
util.AddNetworkString("TTT_Credits")
util.AddNetworkString("TTT_Bought")
util.AddNetworkString("TTT_BoughtItem")
util.AddNetworkString("TTT_InterruptChat")
util.AddNetworkString("TTT_PlayerSpawned")
util.AddNetworkString("TTT_PlayerDied")
util.AddNetworkString("TTT_CorpseCall")
util.AddNetworkString("TTT_PerformGesture")
util.AddNetworkString("TTT_Role")
util.AddNetworkString("TTT_RoleList")
util.AddNetworkString("TTT_ConfirmUseTButton")
util.AddNetworkString("TTT_C4Config")
util.AddNetworkString("TTT_C4DisarmResult")
util.AddNetworkString("TTT_ScanResult")
util.AddNetworkString("TTT_FlareScorch")
util.AddNetworkString("TTT_Radar")
util.AddNetworkString("TTT_Spectate")

util.AddNetworkString("TTT2TestRole")
util.AddNetworkString("TTT2SyncShopsWithServer")
util.AddNetworkString("TTT2DevChanges")
util.AddNetworkString("TTT2ReceiveTBEq")
util.AddNetworkString("TTT2ReceiveGBEq")
util.AddNetworkString("TTT2ResetTBEq")
util.AddNetworkString("TTT2PlayerAuthedShared")
util.AddNetworkString("TTT2ActivateTButton")
util.AddNetworkString("TTT2ToggleTButton")
util.AddNetworkString("TTT2SendTButtonConfig")
util.AddNetworkString("TTT2RequestTButtonConfig")
util.AddNetworkString("TTT2OrderEquipment")
util.AddNetworkString("TTT2RoleGlobalVoice")
util.AddNetworkString("TTT2MuteTeam")
util.AddNetworkString("TTT2UpdateHoldAimConvar")
util.AddNetworkString("TTT2FinishedReloading")

-- provide menu files by loading them from here:
fileloader.LoadFolder("terrortown/menus/score/", false, CLIENT_FILE)
fileloader.LoadFolder("terrortown/menus/gamemode/", false, CLIENT_FILE)
fileloader.LoadFolder("terrortown/menus/gamemode/", true, CLIENT_FILE)

-- provide and add autorun files
fileloader.LoadFolder("terrortown/autorun/client/", false, CLIENT_FILE, function(path)
    Dev(1, "Marked TTT2 client autorun file for distribution: ", path)
end)

fileloader.LoadFolder("terrortown/autorun/shared/", false, SHARED_FILE, function(path)
    Dev(1, "Marked and added TTT2 shared autorun file for distribution: ", path)
end)

fileloader.LoadFolder("terrortown/autorun/server/", false, SERVER_FILE, function(path)
    Dev(1, "Added TTT2 server autorun file: ", path)
end)

---
-- Called after the gamemode loads and starts.
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:Initialize
-- @local
function GM:Initialize()
    Dev(1, "Trouble In Terrorist Town 2 gamemode initializing...")
    admin.ShowVersion()

    -- Migrate all changes of TTT2
    migrations.Apply()

    ---
    -- @realm shared
    -- stylua: ignore
    hook.Run("TTT2Initialize")

    ---
    -- @realm shared
    -- stylua: ignore
    hook.Run("TTT2FinishedLoading")

    -- load default TTT2 language files or mark them as downloadable on the server
    -- load addon language files in a second pass, the core language files are loaded earlier
    fileloader.LoadFolder("terrortown/lang/", true, CLIENT_FILE, function(path)
        Dev(1, "Added TTT2 language file: ", path)
    end)

    fileloader.LoadFolder("lang/", true, CLIENT_FILE, function(path)
        ErrorNoHaltWithStack(
            "[DEPRECATION WARNING]: Loaded language file from 'lang/', this folder is deprecated. Please switch to 'terrortown/lang/'. Source: \""
                .. path
                .. "\""
        )
        Dev(1, "Added TTT2 language file: ", path)
    end)

    -- load vskin files
    fileloader.LoadFolder("terrortown/vskin/", false, CLIENT_FILE, function(path)
        Dev(1, "Added TTT2 vskin file: ", path)
    end)

    roleselection.LoadLayers()

    ShopEditor.SetupShopEditorCVars()
    ShopEditor.CreateShopDBs()

    -- register synced player variables
    player.RegisterSettingOnServer("enable_dynamic_fov", "bool")

    -- Force friendly fire to be enabled. If it is off, we do not get lag compensation.
    RunConsoleCommand("mp_friendlyfire", "1")

    -- Default crowbar unlocking settings, may be overridden by config entity
    self.crowbar_unlocks = {
        [OPEN_DOOR] = true,
        [OPEN_ROT] = true,
        [OPEN_BUT] = true,
        [OPEN_NOTOGGLE] = true,
    }

    -- More map config ent defaults
    self.force_plymodel = ""
    self.propspec_allow_named = true

    self.MapWin = WIN_NONE
    self.AwardedCredits = false
    self.AwardedCreditsDead = 0

    self.round_state = ROUND_WAIT
    self.FirstRound = true
    self.RoundStartTime = 0
    self.roundCount = 0

    self.DamageLog = {}
    self.LastRole = {}

    -- Delay reading of cvars until config has definitely loaded
    self.cvar_init = false

    SetGlobalFloat("ttt_round_end", -1)
    SetGlobalFloat("ttt_haste_end", -1)

    -- For the paranoid
    math.randomseed(os.time())
    math.random()
    math.random()
    math.random()

    gameloop.Initialize()

    if cvars.Number("sv_alltalk", 0) > 0 then
        ErrorNoHalt(
            "TTT2 WARNING: sv_alltalk is enabled. Dead players will be able to talk to living players. TTT2 will now attempt to set sv_alltalk 0.\n"
        )

        RunConsoleCommand("sv_alltalk", "0")
    end

    if not IsMounted("cstrike") then
        ErrorNoHalt(
            "TTT2 WARNING: CS:S does not appear to be mounted by GMod. Things may break in strange ways. Server admin? Check the TTT readme for help.\n"
        )
    end

    ---
    -- @realm shared
    -- stylua: ignore
    hook.Run("PostInitialize")
end

---
-- This hook is called to initialize the ConVars.
-- @note Used to do this in Initialize, but server cfg has not always run yet by that point.
-- @hook
-- @realm server
function GM:InitCvars()
    Dev(1, "TTT2 initializing ConVar settings...")

    self:SyncGlobals()

    KARMA.InitState()

    self.cvar_init = true
end

---
-- Called when the game(server) needs to update the text shown in the server browser as the gamemode.
-- @return string The text to be shown in the server browser as the gamemode
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:GetGameDescription
-- @local
function GM:GetGameDescription()
    return self.Name
end

---
-- This hook is used to initialize @{ITEM}s, @{Weapon}s and the shops.
-- Called after all the entities are initialized.
-- @note At this point the client only knows about the entities that are within the spawnpoints' PVS.
-- For instance, if the server sends an entity that is not within this
-- <a href="https://en.wikipedia.org/wiki/Potentially_visible_set">PVS</a>,
-- the client will receive it as NULL entity.
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:InitPostEntity
-- @local
function GM:InitPostEntity()
    self:InitCvars()

    Dev(1, "[TTT2][INFO] Client post-init...")

    ---
    -- @realm shared
    -- stylua: ignore
    hook.Run("TTTInitPostEntity")

    -- load entity spawns from file / map
    entspawnscript.OnLoaded()

    items.MigrateLegacyItems()
    items.OnLoaded()

    -- load all HUDs
    huds.OnLoaded()

    -- load all HUD elements
    hudelements.OnLoaded()

    local sweps = weapons.GetList()

    for i = 1, #sweps do
        local eq = sweps[i]

        -- Check if an equipment has an id or ignore it
        -- @realm server
        -- stylua: ignore
        if not hook.Run("TTT2RegisterWeaponID", eq) then continue end

        -- Insert data into role fallback tables
        InitDefaultEquipment(eq)

        eq.CanBuy = {} -- reset normal weapons equipment
    end

    -- init hudelements fns
    local hudElems = hudelements.GetList()

    for i = 1, #hudElems do
        local hudelem = hudElems[i]

        if not hudelem.togglable then
            continue
        end

        local nm = "ttt2_elem_toggled_" .. hudelem.id

        ---
        -- @name ttt2_elem_toggled_[HUDELEMENT_NAME]
        -- @realm server
        -- stylua: ignore
        local ret = CreateConVar(nm, "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

        SetGlobalBool(nm, ret:GetBool())

        cvars.AddChangeCallback(nm, function(cvarName, old, new)
            SetGlobalBool(cvarName, tobool(new))
        end, "CVAR_" .. nm)
    end

    -- initialize fallback shops
    InitFallbackShops()

    ---
    -- @realm server
    -- stylua: ignore
    hook.Run("PostInitPostEntity")

    ---
    -- @realm server
    -- stylua: ignore
    hook.Run("InitFallbackShops")

    ---
    -- @realm server
    -- stylua: ignore
    hook.Run("LoadedFallbackShops")

    -- initialize the equipment
    LoadShopsEquipment()

    Dev(1, "[TTT2][INFO] Shops initialized...")
    TTT2ShopFallbackInitialized = true

    WEPS.ForcePrecache()

    -- precache player models
    playermodels.PrecacheModels()

    -- initialize playermodel database
    playermodels.Initialize()

    -- set the default random playermodel
    self.playermodel = playermodels.GetRandomPlayerModel()
    self.playercolor = COLOR_WHITE

    timer.Simple(0, function()
        addonChecker.Check()
    end)
end

---
-- Called when a map I/O event occurs.
-- @param Entity ent Entity that receives the input
-- @param string input The input name. Is not guaranteed to be a valid input on the entity.
-- @param Entity activator Activator of the input
-- @param Entity caller Caller of the input
-- @param any data Data provided with the input
-- @return boolean Return true to prevent this input from being processed.
-- @ref https://wiki.facepunch.com/gmod/GM:AcceptInput
-- @hook
-- @realm server
function GM:AcceptInput(ent, name, activator, caller, data)
    return door.AcceptInput(ent, name, activator, caller, data)
end

---
-- This hook is used to sync the global networked vars.
-- @note ConVar replication is broken in GMod, so we do this.
-- I don't like it any more than you do, dear reader.
-- @hook
-- @realm server
function GM:SyncGlobals()
    SetGlobalBool("ttt_detective", ttt_detective:GetBool())
    SetGlobalBool(ttt_haste:GetName(), ttt_haste:GetBool())
    SetGlobalBool(ttt_session_limits_enabled:GetName(), ttt_session_limits_enabled:GetBool())
    SetGlobalInt(idle_time:GetName(), idle_time:GetInt())
    SetGlobalBool(idle_enabled:GetName(), idle_enabled:GetBool())

    SetGlobalBool(voice_drain:GetName(), voice_drain:GetBool())
    SetGlobalFloat(voice_drain_normal:GetName(), voice_drain_normal:GetFloat())
    SetGlobalFloat(voice_drain_admin:GetName(), voice_drain_admin:GetFloat())
    SetGlobalFloat(voice_drain_recharge:GetName(), voice_drain_recharge:GetFloat())

    local rlsList = roles.GetList()

    for i = 1, #rlsList do
        local abbr = rlsList[i].abbr

        SetGlobalString(
            "ttt_" .. abbr .. "_shop_fallback",
            GetConVar("ttt_" .. abbr .. "_shop_fallback"):GetString()
        )
    end

    SetGlobalBool("ttt2_confirm_team", confirm_team:GetBool())

    ---
    -- @realm server
    -- stylua: ignore
    hook.Run("TTT2SyncGlobals")
end

cvars.AddChangeCallback(ttt_detective:GetName(), function(cv, old, new)
    SetGlobalBool("ttt_detective", tobool(tonumber(new)))
end)

cvars.AddChangeCallback(ttt_haste:GetName(), function(cv, old, new)
    SetGlobalBool(ttt_haste:GetName(), tobool(tonumber(new)))
end)

cvars.AddChangeCallback(ttt_session_limits_enabled:GetName(), function(cv, old, new)
    SetGlobalBool(ttt_session_limits_enabled:GetName(), tobool(tonumber(new)))
end)

cvars.AddChangeCallback(idle_time:GetName(), function(cv, old, new)
    SetGlobalInt(idle_time:GetName(), tonumber(new))
end)

cvars.AddChangeCallback(idle_enabled:GetName(), function(cv, old, new)
    SetGlobalBool(idle_enabled:GetName(), tobool(tonumber(new)))
end)

cvars.AddChangeCallback(voice_drain:GetName(), function(cv, old, new)
    SetGlobalBool(voice_drain:GetName(), tobool(tonumber(new)))
end)

cvars.AddChangeCallback(voice_drain_normal:GetName(), function(cv, old, new)
    SetGlobalFloat(voice_drain_normal:GetName(), tonumber(new))
end)

cvars.AddChangeCallback(voice_drain_admin:GetName(), function(cv, old, new)
    SetGlobalFloat(voice_drain_admin:GetName(), tonumber(new))
end)

cvars.AddChangeCallback(voice_drain_recharge:GetName(), function(cv, old, new)
    SetGlobalFloat(voice_drain_recharge:GetName(), tonumber(new))
end)

---
-- This @{function} is used to load the shop equipments
-- @realm server
-- @internal
function LoadShopsEquipment()
    -- initialize shop equipment
    local rlsList = roles.GetList()

    for i = 1, #rlsList do
        local roleData = rlsList[i]

        local shopFallback = GetConVar("ttt_" .. roleData.abbr .. "_shop_fallback"):GetString()
        if shopFallback ~= roleData.name then
            continue
        end

        LoadSingleShopEquipment(roleData)
    end
end

---
-- This @{function} is used to trigger the round syncing
-- @param number state the round state
-- @param[opt] Player ply if nil, this will broadcast to every connected @{PLayer}
-- @realm server
function SendRoundState(state, ply)
    net.Start("TTT_RoundState")
    net.WriteUInt(state, 3)

    if IsValid(ply) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

---
-- Sets the current round state
-- @note Round state is encapsulated by set/get so that it can easily be changed to
-- eg. a networked var if this proves more convenient
-- @param number state
-- @realm server
function SetRoundState(state)
    GAMEMODE.round_state = state

    events.Trigger(EVENT_GAME, state)

    SendRoundState(state)
end

---
-- Returns the current round state
-- @note Round state is encapsulated by set/get so that it can easily be changed to
-- eg. a networked var if this proves more convenient
-- @return number
-- @realm server
function GetRoundState()
    return GAMEMODE.round_state
end

---
-- Fixes a spectator bug in the beginning
-- @note When a player initially spawns after mapload, everything is a bit strange
-- just making him spectator for some reason does not work right. Therefore,
-- we regularly check for these broken spectators while we wait for players
-- and immediately fix them.
-- @realm server
-- @internal
function FixSpectators()
    local plys = playerGetAll()

    for i = 1, #plys do
        local ply = plys[i]

        if not ply:IsSpec() or ply:GetRagdollSpec() or ply:GetMoveType() >= MOVETYPE_NOCLIP then
            continue
        end

        ply:Spectate(OBS_MODE_ROAMING)
    end
end

---
-- This is the win condition checker
-- @note Used to be in think, now a timer
-- @realm server
-- @internal
local function WinChecker()
    if GetRoundState() ~= ROUND_ACTIVE then
        return
    end

    if CurTime() > GetGlobalFloat("ttt_round_end", 0) and not ttt_dbgwin:GetBool() then
        gameloop.End(WIN_TIMELIMIT)
    elseif not ttt_dbgwin:GetBool() then
        ---
        -- @realm server
        -- stylua: ignore
        win = hook.Run("TTT2PreWinChecker")

        ---
        -- @realm server
        -- stylua: ignore
        win = win or hook.Run("TTTCheckForWin")

        if win == WIN_NONE then
            return
        end

        gameloop.End(win)
    end
end

local function NameChangeKick()
    if not namechangekick:GetBool() then
        timer.Remove("namecheck")

        return
    end

    if GetRoundState() ~= ROUND_ACTIVE then
        return
    end

    local plys = playerGetAll()

    for i = 1, #plys do
        local ply = plys[i]

        if not ply.spawn_nick then
            ply.spawn_nick = ply:Nick()

            continue
        end

        ---
        -- @realm server
        -- stylua: ignore
        if ply:IsBot() or not ply.has_spawned or ply.spawn_nick == ply:Nick() or hook.Run("TTTNameChangeKick", ply) then continue end

        local t = namechangebtime:GetInt()
        local msg = "Changed name during a round"

        if t > 0 then
            ply:KickBan(t, msg)
        else
            ply:Kick(msg)
        end
    end
end

---
-- This @{function} is used to install a timer that checks for name changes
-- and kicks @{Player} if it's activated
-- @realm server
-- @internal
function StartNameChangeChecks()
    if not namechangekick:GetBool() then
        return
    end

    -- bring nicks up to date, may have been changed during prep/post
    local plys = playerGetAll()

    for i = 1, #plys do
        local ply = plys[i]

        ply.spawn_nick = ply:Nick()
    end

    if not timer.Exists("namecheck") then
        timer.Create("namecheck", 3, 0, NameChangeKick)
    end
end

---
-- This function install the win condition checker (with a timer)
-- @realm server
-- @internal
-- @see StopWinChecks
function StartWinChecks()
    if not timer.Start("winchecker") then
        timer.Create("winchecker", 1, 0, WinChecker)
    end
end

---
-- This function stops the win condition checker (the timer)
-- @realm server
-- @internal
-- @see StartWinChecks
function StopWinChecks()
    timer.Stop("winchecker")
end

---
-- Called right before the map cleans up (usually because @{game.CleanUpMap} was called)
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PreCleanupMap
-- @local
function GM:PreCleanupMap()
    ents.TTT.FixParentedPreCleanup()

    entityOutputs.CleanUp()

    -- While cleaning up the map, disable random weapons directly spawning
    entspawn.SetForcedRandomSpawn(false)
end

---
-- Called right after the map has cleaned up (usually because game.CleanUpMap was called)
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PostCleanupMap
-- @local
function GM:PostCleanupMap()
    entityOutputs.SetUp()

    entspawn.HandleSpawns()

    -- After map cleanup enable 'env_entity_maker'-entities to force spawn random weapons and ammo
    -- This is necessary for maps like 'ttt_lttp_kakariko_a5', that only initialize 'ttt_random_weapon'-entities
    -- after destroying vases and were therefore not affected by our entspawn-system
    entspawn.SetForcedRandomSpawn(true)
    ---
    -- @realm server
    -- stylua: ignore
    hook.Run("TTT2PostCleanupMap")

    door.SetUp()

    gameloop.Prepare()
end

---
-- Increases the global round end time var
-- @param number endtime time (addition)
-- @realm server
-- @internal
function IncRoundEnd(incr)
    SetRoundEnd(GetGlobalFloat("ttt_round_end", 0) + incr)
end

local function TraitorSorting(a, b)
    return a and b and a:upper() < b:upper()
end

---
-- Tells the Traitors about their team mates
-- @realm server
function TellTraitorsAboutTraitors()
    local traitornicks = {}
    local plys = playerGetAll()

    for i = 1, #plys do
        local v = plys[i]

        if v:GetTeam() ~= TEAM_TRAITOR then
            continue
        end

        traitornicks[#traitornicks + 1] = v:Nick()
    end

    for i = 1, #plys do
        local v = plys[i]

        if v:GetTeam() ~= TEAM_TRAITOR then
            continue
        end

        local tmp = table.Copy(traitornicks)

        ---
        -- @realm server
        -- stylua: ignore
        local shouldShow = hook.Run("TTT2TellTraitors", tmp, v)

        if shouldShow == false or tmp == nil or #tmp == 0 then
            continue
        end

        if #tmp == 1 then
            LANG.Msg(v, "round_traitors_one", nil, MSG_MSTACK_ROLE)

            return
        end

        if #tmp >= 3 then
            table.sort(tmp, TraitorSorting)
        end

        local names = ""

        for k = 1, #tmp do
            local name = tmp[k]
            if name == v:Nick() then
                continue
            end

            names = names .. name .. ", "
        end

        names = string.sub(names, 1, -3)

        LANG.Msg(v, "round_traitors_more", { names = names }, MSG_MSTACK_ROLE)
    end
end

---
-- Prints round results / win conditions to the server log
-- @param string result the winner team
-- @realm server
-- @internal
function PrintResultMessage(result)
    ServerLog("Round ended.\n")

    if result == WIN_TIMELIMIT then
        LANG.Msg("win_time")
        ServerLog("Result: timelimit reached, traitors lose.\n")

        return
    elseif result == WIN_NONE or result == TEAM_NONE then
        LANG.Msg("win_nones")
        ServerLog("Result: No-one wins.\n")

        return
    else
        if isnumber(result) then
            if result == WIN_TRAITOR then
                result = TEAM_TRAITOR
            elseif result == WIN_INNOCENT then
                result = TEAM_INNOCENT
            end
        end

        LANG.Msg("win_" .. result) -- TODO translation
        ServerLog("Result: " .. result .. " wins.\n") -- TODO translation

        return
    end
end

net.Receive("TTT2FinishedReloading", function(_, ply)
    ---
    -- @realm server
    -- stylua: ignore
    hook.Run("TTT2PlayerFinishedReloading", ply)
end)

---
-- Called when gamemode has been reloaded by auto refresh.
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:OnReloaded
function GM:OnReloaded()
    -- load all roles
    roles.OnLoaded()

    -- reload entity spawns from file
    entspawnscript.OnLoaded()

    -- load all items
    items.OnLoaded()

    -- load all HUDs
    huds.OnLoaded()

    -- load all HUD elements
    hudelements.OnLoaded()

    -- reload everything from the playermodels
    playermodels.Initialize()

    map.InitializeList()

    -- set the default random playermodel
    self.playermodel = playermodels.GetRandomPlayerModel()
    self.playercolor = COLOR_WHITE

    -- register synced player variables
    player.RegisterSettingOnServer("enable_dynamic_fov", "bool")

    ---
    -- @realm shared
    -- stylua: ignore
    hook.Run("TTT2RolesLoaded")

    ---
    -- @realm shared
    -- stylua: ignore
    hook.Run("TTT2BaseRoleInit")

    ---
    -- @realm shared
    -- stylua: ignore
    hook.Run("TTT2FinishedLoading")
end

---
-- Called if the map triggers the end based on some defined win or end conditions
-- @param string wintype
-- @hook
-- @realm server
function GM:MapTriggeredEnd(wintype)
    if wintype ~= WIN_NONE then
        gameloop.mapWinType = wintype
    else
        -- print alert and hint for contact
        ErrorNoHaltWithStack("\n\nCalled hook 'GM:MapTriggeredEnd' with incorrect wintype\n\n")
    end
end

function GM:PlayerAuthed(ply, steamid, uniqueid)
    net.Start("TTT2PlayerAuthedShared")
    net.WriteString(not ply:IsBot() and util.SteamIDTo64(steamid) or "")
    net.WriteString((ply and ply:Nick()) or "UNKNOWN")
    net.Broadcast()
end

---
-- This hook is used to sync the global networked vars. It is run in @{GM:SyncGlobals} after the
-- TTT2 globals are synced.
-- @hook
-- @realm server
function GM:TTT2SyncGlobals() end

---
-- This hook is run before @{GM:TTTCheckForWin} and should be used for custom winconditions in
-- roles. Because this hook will prevent the default hook from being run if a result is returned.
-- @return nil|string The team identifier of the winning team
-- @hook
-- @realm server
function GM:TTT2PreWinChecker() end

---
-- Called after a player changed their nickname.
-- @param Player ply The player who changed their name
-- @return nil|boolean Return true to prevent the kick of the player
-- @hook
-- @realm server
function GM:TTTNameChangeKick(ply) end

---
-- A hook to prevent a traitor from receiving the list of their mates.
-- @param table traitorNicks A table of all traitor nicknames
-- @param Player ply The player who should be informed
-- @return nil|boolean Return false to prevent the player from receiving the
-- name of their mates
-- @hook
-- @realm server
function GM:TTT2TellTraitors(traitorNicks, ply) end

---
-- Can be used to modify the table of teams with alive players. This hook is
-- used in the default win condition.
-- @note A dead player that is revived is counted as alive as well if the revival mode
-- ist set to blocking mode.
-- @param table alives The table of teams which have at least one player still alive
-- @hook
-- @realm server
function GM:TTT2ModifyWinningAlives(alives) end

---
-- Called if CheckForMapSwitch has determined that a map change should happen.
-- @note Can be used for custom map voting system. Just hook this and return true to override.
-- @param string nextmap Next map that would be loaded according to the file that is set by the mapcyclefile convar
-- @param number roundsLeft Number of rounds left before the next map switch
-- @param number timeLeft Time left before the next map switch in seconds
-- @hook
-- @realm server
function GM:TTT2LoadNextMap(nextmap, roundsLeft, timeLeft)
    if roundsLeft <= 0 then
        LANG.Msg("limit_round", { mapname = nextmap })
    elseif timeLeft <= 0 then
        LANG.Msg("limit_time", { mapname = nextmap })
    end

    timer.Simple(map_switch_delay:GetFloat(), game.LoadNextMap)
end

---
-- Adds a delay before the round begings. This is called before @{GM:TTTPrepareRound}.
-- @note Can be used for custom voting systems
-- @return[default=false] boolean Whether there should be a delay
-- @return[default=nil] number Delay in seconds
-- @hook
-- @realm server
function GM:TTTDelayRoundStartForVote()
    return false
end

---
-- Win checker hook to add your own win conditions.
-- @note The most basic win check is whether both sides have one player alive.
-- @return nil|string The team identifier of the winning team
-- @hook
-- @realm server
function GM:TTTCheckForWin()
    if not ttt_dbgwin or ttt_dbgwin:GetBool() then
        return WIN_NONE
    end

    if gameloop.mapWinType ~= WIN_NONE then
        return gameloop.mapWinType
    end

    local aliveTeams = {}
    local plys = playerGetAll()

    for i = 1, #plys do
        local ply = plys[i]
        local team = ply:GetTeam()

        if
            (ply:IsTerror() or ply:IsBlockingRevival())
            and not ply:GetSubRoleData().preventWin
            and team ~= TEAM_NONE
        then
            aliveTeams[#aliveTeams + 1] = team
        end

        -- special case: The revival blocks the round end
        if ply:GetRevivalBlockMode() == REVIVAL_BLOCK_ALL then
            return WIN_NONE
        end
    end

    ---
    -- @realm server
    -- stylua: ignore
    hook.Run("TTT2ModifyWinningAlives", aliveTeams)

    local checkedTeams = {}
    local b = 0

    for i = 1, #aliveTeams do
        local team = aliveTeams[i]

        if team == TEAM_NONE then
            continue
        end

        if not checkedTeams[team] or TEAMS[team].alone then
            -- prevent win of custom role -> maybe own win conditions
            b = b + 1

            -- check
            checkedTeams[team] = true
        end

        -- if 2 teams alive
        if b == 2 then
            break
        end
    end

    if b > 1 then -- if >= 2 teams alive: no one wins
        return WIN_NONE -- early out
    elseif b == 1 then -- just 1 team is alive
        return aliveTeams[1]
    else -- rare case: nobody is alive, e.g. because of an explosion
        return TEAM_NONE -- none_win
    end
end

---
-- Called when a player is ready again after they reloaded their game. Can be used to send
-- data that is needed after a reload.
-- @param Player ply The player that finished the reloading
-- @hook
-- @realm server
function GM:TTT2PlayerFinishedReloading(ply)
    map.SyncToClient(ply)
end
