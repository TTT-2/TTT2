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
ttt_include("sh_entity")
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
local hook = hook
local playerGetAll = player.GetAll

---
-- @realm server
local cvPreferMapModels =
    CreateConVar("ttt2_prefer_map_models", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
local cvSelectModelPerRound =
    CreateConVar("ttt2_select_model_per_round", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
local cvSelectUniqueModelPerPlayer =
    CreateConVar("ttt2_select_unique_model_per_player", "0", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
CreateConVar("ttt_haste_minutes_per_death", "0.5", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

-- Credits

---
-- @realm server
CreateConVar("ttt_credits_award_pct", "0.35", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
CreateConVar("ttt_credits_award_size", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
CreateConVar("ttt_credits_award_repeat", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
CreateConVar("ttt_credits_award_kill", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
local idle_enabled = CreateConVar("ttt_idle", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
local idle_time = CreateConVar("ttt_idle_limit", "180", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

---
-- @realm server
CreateConVar(
    "ttt2_prep_respawn",
    "0",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE },
    "Respawn if dead in preparing time"
)

---
-- @realm server
local map_switch_delay = CreateConVar(
    "ttt2_map_switch_delay",
    "15",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE },
    "Time that passes before the map is changed after the last round ends or the timer runs out",
    0
)

---
-- @realm server
CreateConVar(
    "ttt_enforce_playermodel",
    "1",
    { FCVAR_NOTIFY, FCVAR_ARCHIVE },
    "Whether or not to enforce terrorist playermodels. Set to 0 for compatibility with Enhanced Playermodel Selector"
)

---
-- @realm server
CreateConVar("ttt_newroles_enabled", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

-- Pool some network names.
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
util.AddNetworkString("TTT_CorpseCall")
util.AddNetworkString("TTT_PerformGesture")
util.AddNetworkString("TTT_Role")
util.AddNetworkString("TTT_RoleList")
util.AddNetworkString("TTT_ConfirmUseTButton")
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
    hook.Run("TTT2Initialize")

    ---
    -- @realm shared
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

    self.DamageLog = {}
    self.LastRole = {}

    -- Delay reading of cvars until config has definitely loaded
    self.cvar_init = false

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
        if not hook.Run("TTT2RegisterWeaponID", eq) then
            continue
        end

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
        local ret = CreateConVar(nm, "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

        SetGlobalBool(nm, ret:GetBool())

        cvars.AddChangeCallback(nm, function(cvarName, old, new)
            SetGlobalBool(cvarName, tobool(new))
        end, "CVAR_" .. nm)
    end

    -- initialize fallback shops
    InitFallbackShops()

    ---
    -- @realm server
    hook.Run("PostInitPostEntity")

    ---
    -- @realm server
    hook.Run("InitFallbackShops")

    ---
    -- @realm server
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
    SetGlobalInt(idle_time:GetName(), idle_time:GetInt())
    SetGlobalBool(idle_enabled:GetName(), idle_enabled:GetBool())

    local rlsList = roles.GetList()

    for i = 1, #rlsList do
        local abbr = rlsList[i].abbr

        SetGlobalString(
            "ttt_" .. abbr .. "_shop_fallback",
            GetConVar("ttt_" .. abbr .. "_shop_fallback"):GetString()
        )
    end

    ---
    -- @realm server
    hook.Run("TTT2SyncGlobals")
end

cvars.AddChangeCallback(idle_time:GetName(), function(cv, old, new)
    SetGlobalInt(idle_time:GetName(), tonumber(new))
end)

cvars.AddChangeCallback(idle_enabled:GetName(), function(cv, old, new)
    SetGlobalBool(idle_enabled:GetName(), tobool(tonumber(new)))
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
    hook.Run("TTT2PostCleanupMap")

    door.SetUp()
    button.SetUp()

    gameloop.Prepare()
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

    button.SetUp()

    -- set the default random playermodel
    self.playermodel = playermodels.GetRandomPlayerModel()
    self.playercolor = COLOR_WHITE

    -- register synced player variables
    player.RegisterSettingOnServer("enable_dynamic_fov", "bool")

    ---
    -- @realm shared
    hook.Run("TTT2RolesLoaded")

    ---
    -- @realm shared
    hook.Run("TTT2BaseRoleInit")

    ---
    -- @realm shared
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

---
-- Called after the player is authenticated by Steam. This hook will also be called in singleplayer.
-- @param Player ply The player
-- @param string steamid The player's SteamID
-- @param string uniqueid The player's UniqueID
-- @book
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerAuthed
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
    if roundsLeft == 0 then
        LANG.Msg("limit_round", { mapname = nextmap })
    elseif timeLeft == 0 then
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

---
-- Called before @{GM:TTTPrepareRound} and is mostly intended for internal setups and round preparation.
-- @param number duration The duration of this phase
-- @hook
-- @realm server
function GM:TTT2PrePrepareRound(duration)
    events.Reset()
    KARMA.RoundPrepare()

    -- todo: this muting here seems like a bad idea - rework?
    -- mute for a second around role selection, to counter a dumb exploit
    -- related to team voice mics cutting off for a second when they're selected
    timer.Create("selectmute", duration - 1, 1, function()
        MuteForRestart(true)
    end)

    -- undo the roundrestart mute, though they will once again be muted for the
    -- selectmute timer
    timer.Create("restartmute", 1, 1, function()
        MuteForRestart(false)
    end)

    -- sets the player model
    -- supports map models or random player models
    if cvPreferMapModels:GetBool() and self.force_plymodel and self.force_plymodel ~= "" then
        self.playermodel = self.force_plymodel
    elseif cvSelectModelPerRound:GetBool() then
        if cvSelectUniqueModelPerPlayer:GetBool() then
            local plys = player.GetAll()
            for i = 1, #plys do
                plys[i].defaultModel = playermodels.GetRandomPlayerModel()
            end
        else
            local plys = player.GetAll()
            for i = 1, #plys do
                plys[i].defaultModel = nil
            end

            self.playermodel = playermodels.GetRandomPlayerModel()
        end
    end

    ---
    -- @realm server
    self.playercolor = hook.Run("TTTPlayerColor", self.playermodel)
end

---
-- Called before @{GM:TTTBeginRound} and is mostly intended for internal setups and round prepararation.
-- @param number duration The duration of this phase
-- @hook
-- @realm server
function GM:TTT2PreBeginRound(duration)
    -- remove decals
    util.ClearDecals()

    timer.Create("selectmute", 1, 1, function()
        MuteForRestart(false)
    end)

    ResetDamageLog()

    events.Trigger(EVENT_SELECTED)

    self:UpdatePlayerLoadouts() -- needs to happen when round_active

    ARMOR:InitPlayerArmor()

    local plys = player.GetAll()

    for i = 1, #plys do
        local ply = plys[i]

        ply:ResetRoundDeathCounter()

        -- a player should be considered "was active in round" if they received a role
        ply:SetActiveInRound(ply:Alive() and ply:IsTerror())
    end

    credits.ResetTeamStates()

    timer.Simple(1.5, TellTraitorsAboutTraitors)
    timer.Simple(2.5, ShowRoundStartPopup)
end

---
-- Called before @{GM:TTTEndRound} and is mostly intended for internal setups and round prepararation.
-- @param string|number result The wininng team or the result
-- @param number duration The duration of this phase
-- @hook
-- @realm server
function GM:TTT2PreEndRound(result, duration)
    events.Trigger(EVENT_FINISH, result)

    LANG.Msg("win_showreport", { num = duration })

    events.UpdateScoreboard()

    -- send the clients the round log, players will be shown the report
    events.StreamToClients()
end

---
-- Called right after all doors are initialized on the map.
-- @param table doorsTable A table with the newly registered door entities
-- @hook
-- @realm server
function GM:TTT2PostDoorSetup(doorsTable) end
