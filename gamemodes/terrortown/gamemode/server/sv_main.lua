---
-- Trouble in Terrorist Town 2

ttt_include("sh_init")

ttt_include("sh_cvar_handler")

ttt_include("sh_sprint")
ttt_include("sh_main")
ttt_include("sh_shopeditor")
ttt_include("sh_network_sync")
ttt_include("sh_door")
ttt_include("sh_voice")
ttt_include("sh_printmessage_override")
ttt_include("sh_speed")

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

ttt_include("sv_weapon_pickup")
ttt_include("sv_addonchecker")
ttt_include("sv_roleselection")
ttt_include("sh_rolelayering")

include("ttt2/libraries/map.lua")
include("ttt2/libraries/entspawn.lua")
include("ttt2/libraries/plyspawn.lua")
include("ttt2/libraries/entity_outputs.lua")
include("ttt2/libraries/credits.lua")

-- Localize stuff we use often. It's like Lua go-faster stripes.
local math = math
local table = table
local net = net
local player = player
local pairs = pairs
local timer = timer
local util = util
local IsValid = IsValid
local hook = hook

---
-- @realm server
local roundtime = CreateConVar("ttt_roundtime_minutes", "10", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local preptime = CreateConVar("ttt_preptime_seconds", "30", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local posttime = CreateConVar("ttt_posttime_seconds", "30", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local firstpreptime = CreateConVar("ttt_firstpreptime", "60", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local ttt_haste = CreateConVar("ttt_haste", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local haste_starting = CreateConVar("ttt_haste_starting_minutes", "5", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
CreateConVar("ttt_haste_minutes_per_death", "0.5", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

-- Credits

---
-- @realm server
CreateConVar("ttt_credits_award_pct", "0.35", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
CreateConVar("ttt_credits_award_size", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
CreateConVar("ttt_credits_award_repeat", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
CreateConVar("ttt_credits_award_kill", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local ttt_session_limits_enabled = CreateConVar("ttt_session_limits_enabled", "1", SERVER and {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED)

---
-- @realm server
local round_limit = CreateConVar("ttt_round_limit", "6", SERVER and {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED)

---
-- @realm server
local time_limit = CreateConVar("ttt_time_limit_minutes", "75", SERVER and {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED)

---
-- @realm server
local idle_enabled = CreateConVar("ttt_idle", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local idle_time = CreateConVar("ttt_idle_limit", "180", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local voice_drain = CreateConVar("ttt_voice_drain", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local voice_drain_normal = CreateConVar("ttt_voice_drain_normal", "0.2", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local voice_drain_admin = CreateConVar("ttt_voice_drain_admin", "0.05", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local voice_drain_recharge = CreateConVar("ttt_voice_drain_recharge", "0.05", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local namechangekick = CreateConVar("ttt_namechange_kick", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local namechangebtime = CreateConVar("ttt_namechange_bantime", "10", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local ttt_detective = CreateConVar("ttt_sherlock_mode", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local ttt_minply = CreateConVar("ttt_minimum_players", "2", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local cvPreferMapModels = CreateConVar("ttt2_prefer_map_models", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local cvSelectModelPerRound = CreateConVar("ttt2_select_model_per_round", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
CreateConVar("ttt2_prep_respawn", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Respawn if dead in preparing time")

---
-- @realm server
local map_switch_delay = CreateConVar("ttt2_map_switch_delay", "15", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Time that passes before the map is changed after the last round ends or the timer runs out", 0)

---
-- @realm server
CreateConVar("ttt_identify_body_woconfirm", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Toggles whether ragdolls should be confirmed in DetectiveMode() without clicking on confirm espacially")

---
-- @realm server
local confirm_team = CreateConVar("ttt2_confirm_team", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Show team of confirmed player")

---
-- @realm server
CreateConVar("ttt2_confirm_killlist", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Confirm players in kill list")

---
-- @realm server
CreateConVar("ttt_enforce_playermodel", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Whether or not to enforce terrorist playermodels. Set to 0 for compatibility with Enhanced Playermodel Selector")

---
-- @realm server
local ttt_dbgwin = CreateConVar("ttt_debug_preventwin", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @realm server
local ttt_newroles_enabled = CreateConVar("ttt_newroles_enabled", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

-- Pool some network names.
util.AddNetworkString("TTT_RoundState")
util.AddNetworkString("TTT_RagdollSearch")
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
util.AddNetworkString("TTT_ClearClientState")
util.AddNetworkString("TTT_PerformGesture")
util.AddNetworkString("TTT_Role")
util.AddNetworkString("TTT_RoleList")
util.AddNetworkString("TTT_RoleReset")
util.AddNetworkString("TTT_ConfirmUseTButton")
util.AddNetworkString("TTT_C4Config")
util.AddNetworkString("TTT_C4DisarmResult")
util.AddNetworkString("TTT_C4Warn")
util.AddNetworkString("TTT_ScanResult")
util.AddNetworkString("TTT_FlareScorch")
util.AddNetworkString("TTT_Radar")
util.AddNetworkString("TTT_Spectate")

util.AddNetworkString("TTT2TestRole")
util.AddNetworkString("TTT2SyncShopsWithServer")
util.AddNetworkString("TTT2DevChanges")
util.AddNetworkString("TTT2SyncDBItems")
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

-- provide menu files by loading them from here:
fileloader.LoadFolder("terrortown/menus/score/", false, CLIENT_FILE)
fileloader.LoadFolder("terrortown/menus/gamemode/", false, CLIENT_FILE)
fileloader.LoadFolder("terrortown/menus/gamemode/", true, CLIENT_FILE)

-- provide and add autorun files
fileloader.LoadFolder("terrortown/autorun/client/", false, CLIENT_FILE, function(path)
	MsgN("Marked TTT2 client autorun file for distribution: ", path)
end)

fileloader.LoadFolder("terrortown/autorun/shared/", false, SHARED_FILE, function(path)
	MsgN("Marked and added TTT2 shared autorun file for distribution: ", path)
end)

fileloader.LoadFolder("terrortown/autorun/server/", false, SERVER_FILE, function(path)
	MsgN("Added TTT2 server autorun file: ", path)
end)

CHANGED_EQUIPMENT = CHANGED_EQUIPMENT or {}

---
-- Called after the gamemode loads and starts.
-- @hook
-- @realm server
-- @ref https://wiki.facepunch.com/gmod/GM:Initialize
-- @local
function GM:Initialize()
	MsgN("Trouble In Terrorist Town 2 gamemode initializing...")
	ShowVersion()

	---
	-- @realm shared
	hook.Run("TTT2Initialize")

	---
	-- @realm shared
	hook.Run("TTT2FinishedLoading")

	-- load default TTT2 language files or mark them as downloadable on the server
	-- load addon language files in a second pass, the core language files are loaded earlier
	fileloader.LoadFolder("terrortown/lang/", true, CLIENT_FILE, function(path)
		MsgN("Added TTT2 language file: ", path)
	end)

	fileloader.LoadFolder("lang/", true, CLIENT_FILE, function(path)
		MsgN("[DEPRECATION WARNING]: Loaded language file from 'lang/', this folder is deprecated. Please switch to 'terrortown/lang/'")
		MsgN("Added TTT2 language file: ", path)
	end)

	-- load vskin files
	fileloader.LoadFolder("terrortown/vskin/", false, CLIENT_FILE, function(path)
		MsgN("Added TTT2 vskin file: ", path)
	end)

	roleselection.LoadLayers()

	ShopEditor.SetupShopEditorCVars()
	ShopEditor.CreateShopDBs()

	-- Force friendly fire to be enabled. If it is off, we do not get lag compensation.
	RunConsoleCommand("mp_friendlyfire", "1")

	-- Default crowbar unlocking settings, may be overridden by config entity
	self.crowbar_unlocks = {
		[OPEN_DOOR] = true,
		[OPEN_ROT] = true,
		[OPEN_BUT] = true,
		[OPEN_NOTOGGLE] = true
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
	math.random(); math.random(); math.random() -- warming up

	WaitForPlayers()

	if cvars.Number("sv_alltalk", 0) > 0 then
		ErrorNoHalt("TTT2 WARNING: sv_alltalk is enabled. Dead players will be able to talk to living players. TTT2 will now attempt to set sv_alltalk 0.\n")

		RunConsoleCommand("sv_alltalk", "0")
	end

	if not IsMounted("cstrike") then
		ErrorNoHalt("TTT2 WARNING: CS:S does not appear to be mounted by GMod. Things may break in strange ways. Server admin? Check the TTT readme for help.\n")
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
	MsgN("TTT2 initializing ConVar settings...")

	-- Initialize game state that is synced with client
	SetGlobalInt("ttt_rounds_left", round_limit:GetInt())

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

	MsgN("[TTT2][INFO] Client post-init...")

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
		if not hook.Run("TTT2RegisterWeaponID", eq) then continue end

		-- Insert data into role fallback tables
		InitDefaultEquipment(eq)

		eq.CanBuy = {} -- reset normal weapons equipment
	end

	-- init hudelements fns
	local hudElems = hudelements.GetList()

	for i = 1, #hudElems do
		local hudelem = hudElems[i]

		if not hudelem.togglable then continue end

		local nm = "ttt2_elem_toggled_" .. hudelem.id

		---
		-- @name ttt2_elem_toggled_[HUDELEMENT_NAME]
		-- @realm server
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
	hook.Run("PostInitPostEntity")

	---
	-- @realm server
	hook.Run("InitFallbackShops")

	---
	-- @realm server
	hook.Run("LoadedFallbackShops")

	-- initialize the equipment
	LoadShopsEquipment()

	MsgN("[TTT2][INFO] Shops initialized...")
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
	SetGlobalInt(time_limit:GetName(), time_limit:GetInt())
	SetGlobalInt(idle_time:GetName(), idle_time:GetInt())
	SetGlobalBool(idle_enabled:GetName(), idle_enabled:GetBool())

	SetGlobalBool(voice_drain:GetName(), voice_drain:GetBool())
	SetGlobalFloat(voice_drain_normal:GetName(), voice_drain_normal:GetFloat())
	SetGlobalFloat(voice_drain_admin:GetName(), voice_drain_admin:GetFloat())
	SetGlobalFloat(voice_drain_recharge:GetName(), voice_drain_recharge:GetFloat())

	local rlsList = roles.GetList()

	for i = 1, #rlsList do
		local abbr = rlsList[i].abbr

		SetGlobalString("ttt_" .. abbr .. "_shop_fallback", GetConVar("ttt_" .. abbr .. "_shop_fallback"):GetString())
	end

	SetGlobalBool("ttt2_confirm_team", confirm_team:GetBool())

	---
	-- @realm server
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

cvars.AddChangeCallback(time_limit:GetName(), function(cv, old, new)
	SetGlobalInt(time_limit:GetName(), tonumber(new))
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
		if shopFallback ~= roleData.name then continue end

		LoadSingleShopEquipment(roleData)
	end
end

local function TTT2SyncShopsWithServer(len, ply)
	-- at first, sync items
	for i = 1, #CHANGED_EQUIPMENT do
		local tbl = CHANGED_EQUIPMENT[i]

		ShopEditor.WriteItemData("TTT2SyncDBItems", tbl[1], tbl[2])
	end

	-- reset and set if it's a fallback
	net.Start("shopFallbackReset")
	net.Send(ply)

	SyncEquipment(ply)

	-- sync bought sweps
	if BUYTABLE then
		for id in pairs(BUYTABLE) do
			net.Start("TTT2ReceiveGBEq")
			net.WriteString(id)
			net.Send(ply)
		end
	end

	if TEAMBUYTABLE then
		local team = ply:GetTeam()

		if team and team ~= TEAM_NONE and not TEAMS[team].alone and TEAMBUYTABLE[team] then
			local filter = GetTeamFilter(team)

			for id in pairs(TEAMBUYTABLE[team]) do
				net.Start("TTT2ReceiveTBEq")
				net.WriteString(id)
				net.Send(filter)
			end
		end
	end
end
net.Receive("TTT2SyncShopsWithServer", TTT2SyncShopsWithServer)

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

local function EnoughPlayers()
	local ready = 0

	-- only count truly available players, i.e. no forced specs
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		if not IsValid(ply) or not ply:ShouldSpawn() then continue end

		ready = ready + 1
	end

	return ready >= ttt_minply:GetInt()
end

---
-- This @{function} is used to create the timers that checks
-- whether is the round is able to start (enough players?)
-- @note Used to be in Think/Tick, now in a timer
-- @note this stops @{WaitForPlayers}
-- @realm server
-- @see WaitForPlayers
-- @internal
function WaitingForPlayersChecker()
	if GetRoundState() ~= ROUND_WAIT or not EnoughPlayers() then return end

	timer.Create("wait2prep", 1, 1, PrepareRound)
	timer.Stop("waitingforply")
end

---
-- Start waiting for players
-- @realm server
-- @see WaitingForPlayersChecker
-- @internal
function WaitForPlayers()
	SetRoundState(ROUND_WAIT)

	if timer.Start("waitingforply") then return end

	timer.Create("waitingforply", 2, 0, WaitingForPlayersChecker)
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
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		if not ply:IsSpec() or ply:GetRagdollSpec() or ply:GetMoveType() >= MOVETYPE_NOCLIP then continue end

		ply:Spectate(OBS_MODE_ROAMING)
	end
end

---
-- This is the win condition checker
-- @note Used to be in think, now a timer
-- @realm server
-- @internal
local function WinChecker()
	if GetRoundState() ~= ROUND_ACTIVE then return end

	if CurTime() > GetGlobalFloat("ttt_round_end", 0) then
		EndRound(WIN_TIMELIMIT)
	elseif not ttt_dbgwin:GetBool() then
		---
		-- @realm server
		win = hook.Run("TTT2PreWinChecker")

		---
		-- @realm server
		win = win or hook.Run("TTTCheckForWin")

		if win == WIN_NONE then return end

		EndRound(win)
	end
end

local function NameChangeKick()
	if not namechangekick:GetBool() then
		timer.Remove("namecheck")

		return
	end

	if GetRoundState() ~= ROUND_ACTIVE then return end

	local hmns = player.GetHumans()

	for i = 1, #hmns do
		local ply = hmns[i]

		if not ply.spawn_nick then
			ply.spawn_nick = ply:Nick()

			continue
		end

		---
		-- @realm server
		if not ply.has_spawned or ply.spawn_nick == ply:Nick() or hook.Run("TTTNameChangeKick", ply) then continue end

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
	if not namechangekick:GetBool() then return end

	-- bring nicks up to date, may have been changed during prep/post
	local plys = player.GetAll()

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
	ents.TTT.FixParentedPostCleanup()

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
end

local function CleanUp()
	game.CleanUpMap()

	-- Strip players now, so that their weapons are not seen by ReplaceEntities
	local plys = player.GetAll()

	for i = 1, #plys do
		local v = plys[i]

		v:StripWeapons()
		v:SetRole(ROLE_NONE) -- will reset team automatically
	end

	-- a different kind of cleanup
	hook.Remove("PlayerSay", "ULXMeCheck")
end

local function StopRoundTimers()
	-- remove all timers
	timer.Stop("wait2prep")
	timer.Stop("prep2begin")
	timer.Stop("end2prep")
	timer.Stop("winchecker")
end

-- Make sure we have the players to do a round, people can leave during our
-- preparations so we'll call this numerous times
local function CheckForAbort()
	if not EnoughPlayers() then
		LANG.Msg("round_minplayers")

		StopRoundTimers()
		WaitForPlayers()

		return true
	end

	return false
end

---
-- Sets the global round end time var
-- @param number endtime time
-- @realm server
-- @internal
function SetRoundEnd(endtime)
	SetGlobalFloat("ttt_round_end", endtime)
end

---
-- Increases the global round end time var
-- @param number endtime time (addition)
-- @realm server
-- @internal
function IncRoundEnd(incr)
	SetRoundEnd(GetGlobalFloat("ttt_round_end", 0) + incr)
end

---
-- This @{function} calls @{GM:TTTPrepareRound} and is used to prepare the round
-- @realm server
-- @internal
function PrepareRound()
	-- Check playercount
	if CheckForAbort() then return end

	---
	-- @realm server
	local delay_round, delay_length = hook.Run("TTTDelayRoundStartForVote")

	if delay_round then
		delay_length = delay_length or 30

		LANG.Msg("round_voting", {num = delay_length})

		timer.Create("delayedprep", delay_length, 1, PrepareRound)

		return
	end

	CleanUp()

	GAMEMODE.roundCount = GAMEMODE.roundCount + 1

	GAMEMODE.MapWin = WIN_NONE
	GAMEMODE.AwardedCredits = false
	GAMEMODE.AwardedCreditsDead = 0

	events.Reset()

	-- Update damage scaling
	KARMA.RoundPrepare()

	-- New look. Random if no forced model set
	if cvPreferMapModels:GetBool() and GAMEMODE.force_plymodel and GAMEMODE.force_plymodel ~= "" then
		GAMEMODE.playermodel = GAMEMODE.force_plymodel
	elseif cvSelectModelPerRound:GetBool() then
		GAMEMODE.playermodel = playermodels.GetRandomPlayerModel()
	end

	---
	-- @realm server
	GAMEMODE.playercolor = hook.Run("TTTPlayerColor", GAMEMODE.playermodel)

	if CheckForAbort() then return end

	-- Schedule round start
	local ptime = preptime:GetInt()

	if GAMEMODE.FirstRound then
		ptime = firstpreptime:GetInt()

		GAMEMODE.FirstRound = false
	end

	-- remove decals
	util.ClearDecals()

	-- Piggyback on "round end" time global var to show end of phase timer
	SetRoundEnd(CurTime() + ptime)

	timer.Simple(1, function()
		SetRoundEnd(CurTime() + ptime - 1)
	end)

	timer.Create("prep2begin", ptime, 1, BeginRound)

	-- Mute for a second around traitor selection, to counter a dumb exploit
	-- related to traitor's mics cutting off for a second when they're selected.
	timer.Create("selectmute", ptime - 1, 1, function()
		MuteForRestart(true)
	end)

	LANG.Msg("round_begintime", {num = ptime})

	SetRoundState(ROUND_PREP)

	-- Undo the roundrestart mute, though they will once again be muted for the
	-- selectmute timer.
	timer.Create("restartmute", 1, 1, function()
		MuteForRestart(false)
	end)

	net.Start("TTT_ClearClientState")
	net.Broadcast()

	-- In case client's cleanup fails, make client set all players to innocent role
	timer.Simple(1, SendRoleReset)

	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		ply:SetTargetPlayer(nil)
		ply:ResetRoundDeathCounter()
		ply:SetActiveInRound(false)

		ply:CancelRevival(nil, true)
		ply:SendRevivalReason(nil)
	end

	---
	-- Tell hooks and map we started prep
	-- @realm server
	hook.Run("TTTPrepareRound")

	ents.TTT.TriggerRoundStateOutputs(ROUND_PREP)
end

local function TraitorSorting(a, b)
	return a and b and a:upper() < b:upper()
end

---
-- Tells the Traitors about their team mates
-- @realm server
function TellTraitorsAboutTraitors()
	local traitornicks = {}
	local plys = player.GetAll()

	for i = 1, #plys do
		local v = plys[i]

		if v:GetTeam() ~= TEAM_TRAITOR then continue end

		traitornicks[#traitornicks + 1] = v:Nick()
	end

	for i = 1, #plys do
		local v = plys[i]

		if v:GetTeam() ~= TEAM_TRAITOR then continue end

		local tmp = table.Copy(traitornicks)

		---
		-- @realm server
		local shouldShow = hook.Run("TTT2TellTraitors", tmp, v)

		if shouldShow == false or tmp == nil or #tmp == 0 then continue end

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
			if name == v:Nick() then continue end

			names = names .. name .. ", "
		end

		names = string.sub(names, 1, -3)

		LANG.Msg(v, "round_traitors_more", {names = names}, MSG_MSTACK_ROLE)
	end
end

local function InitRoundEndTime()
	-- Init round values
	local endtime = CurTime() + roundtime:GetInt() * 60

	if HasteMode() then
		endtime = CurTime() + haste_starting:GetInt() * 60

		-- this is a "fake" time shown to innocents, showing the end time if no
		-- one would have been killed, it has no gameplay effect
		SetGlobalFloat("ttt_haste_end", endtime)
	end

	SetRoundEnd(endtime)
end

---
-- This @{function} calls @{GM:TTTBeginRound} and is used to start the round
-- @realm server
-- @internal
function BeginRound()
	GAMEMODE:SyncGlobals()

	if CheckForAbort() then return end

	InitRoundEndTime()

	if CheckForAbort() then return end

	-- Respawn dumb people who died during prep
	entspawn.SpawnPlayers(true)

	-- Remove their ragdolls
	ents.TTT.RemoveRagdolls(true)

	-- remove decals
	util.ClearDecals()

	-- Check for low-karma players that weren't banned on round end
	KARMA.RoundBegin()

	if CheckForAbort() then return end

	-- Select traitors & co. This is where things really start so we can't abort
	-- anymore.
	roleselection.SelectRoles()

	LANG.Msg("round_selected")

	-- Edge case where a player joins just as the round starts and is picked as
	-- traitor, but for whatever reason does not get the traitor state msg. So
	-- re-send after a second just to make sure everyone is getting it.
	-- TODO improve
	timer.Simple(1, SendFullStateUpdate)
	timer.Simple(10, SendFullStateUpdate)

	-- Give the StateUpdate messages ample time to arrive
	timer.Simple(1.5, TellTraitorsAboutTraitors)
	timer.Simple(2.5, ShowRoundStartPopup)

	-- Start the win condition check timer
	StartWinChecks()
	StartNameChangeChecks()

	timer.Create("selectmute", 1, 1, function()
		MuteForRestart(false)
	end)

	GAMEMODE.DamageLog = {}
	GAMEMODE.RoundStartTime = CurTime()

	-- Sound start alarm
	SetRoundState(ROUND_ACTIVE)
	LANG.Msg("round_started")
	ServerLog("Round proper has begun...\n")

	events.Trigger(EVENT_SELECTED)

	GAMEMODE:UpdatePlayerLoadouts() -- needs to happen when round_active

	ARMOR:InitPlayerArmor()

	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		ply:ResetRoundDeathCounter()

		-- a player should be considered "was active in round" if they received a role
		ply:SetActiveInRound(ply:Alive() and ply:IsTerror())
	end

	credits.ResetTeamStates()

	---
	-- @realm server
	hook.Run("TTTBeginRound")

	ents.TTT.TriggerRoundStateOutputs(ROUND_BEGIN)
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

	ServerLog("Result: unknown victory condition!\n")
end

---
-- Checks whether the map is able to switch based on round limits and time limits
-- @realm server
-- @internal
function CheckForMapSwitch()
	-- Check for mapswitch
	local roundsLeft = math.max(0, GetGlobalInt("ttt_rounds_left", 6) - 1)

	SetGlobalInt("ttt_rounds_left", roundsLeft)

	local timeLeft = math.max(0, time_limit:GetInt() * 60 - CurTime())
	local nextmap = string.upper(game.GetMapNext())

	if roundsLeft <= 0 or timeLeft <= 0 then
		timer.Stop("end2prep")
		SetRoundEnd(CurTime())

		---
		-- @realm server
		hook.Run("TTT2LoadNextMap", nextmap, roundsLeft, timeLeft)
	else
		LANG.Msg("limit_left", {num = roundsLeft, time = math.ceil(timeLeft / 60)})
	end
end

---
-- This @{function} calls @{GM:TTTEndRound} and is used to end the round
-- @param string result The winning team / result / condition
-- @realm server
-- @internal
function EndRound(result)
	PrintResultMessage(result)

	KARMA.RoundEnd()

	events.Trigger(EVENT_FINISH, result)

	SetRoundState(ROUND_POST)

	local ptime = math.max(5, posttime:GetInt())

	LANG.Msg("win_showreport", {num = ptime})
	timer.Create("end2prep", ptime, 1, PrepareRound)

	-- Piggyback on "round end" time global var to show end of phase timer
	SetRoundEnd(CurTime() + ptime)

	timer.Create("restartmute", ptime - 1, 1, function()
		MuteForRestart(true)
	end)

	-- Stop checking for wins
	StopWinChecks()

	-- send each client the role setup, reveal every player
	local rlsList = roles.GetList()

	for i = 1, #rlsList do
		SendSubRoleList(rlsList[i].index)
	end

	-- We may need to start a timer for a mapswitch, or start a vote
	if GetGlobalBool("ttt_session_limits_enabled") then
		CheckForMapSwitch()
	end

	events.UpdateScoreboard()

	-- send the clients the round log, players will be shown the report
	events.StreamToClients()

	---
	-- server plugins might want to start a map vote here or something
	-- these hooks are not used by TTT internally
	-- possible incompatibility for other addons
	-- @realm server
	hook.Run("TTTEndRound", result)

	ents.TTT.TriggerRoundStateOutputs(ROUND_POST, result)
end

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
	playermodels.StreamModelStateToSelectedClients()

	-- set the default random playermodel
	self.playermodel = playermodels.GetRandomPlayerModel()
	self.playercolor = COLOR_WHITE

	---
	-- @realm shared
	hook.Run("TTT2RolesLoaded")

	---
	-- @realm shared
	hook.Run("TTT2BaseRoleInit")
end

---
-- Called if the map triggers the end based on some defined win or end conditions
-- @param string wintype
-- @hook
-- @realm server
function GM:MapTriggeredEnd(wintype)
	if wintype ~= WIN_NONE then
		self.MapWin = wintype
	else
		-- print alert and hint for contact
		print("\n\nCalled hook 'GM:MapTriggeredEnd' with incorrect wintype\n\n")
	end
end

hook.Add("PlayerAuthed", "TTT2PlayerAuthedSharedHook", function(ply, steamid, uniqueid)
	net.Start("TTT2PlayerAuthedShared")
	net.WriteString(not ply:IsBot() and util.SteamIDTo64(steamid) or "")
	net.WriteString((ply and ply:Nick()) or "UNKNOWN")
	net.Broadcast()
end)

local function ttt_roundrestart(ply, command, args)
	---
	-- ply is nil on dedicated server console
	-- @realm server
	if not IsValid(ply) or ply:IsAdmin() or hook.Run("TTT2AdminCheck", ply) or cvars.Bool("sv_cheats", 0) then
		LANG.Msg("round_restart")

		StopRoundTimers()

		-- do prep
		PrepareRound()
	else
		ply:PrintMessage(HUD_PRINTCONSOLE, "You must be a GMod Admin or SuperAdmin on the server to use this command, or sv_cheats must be enabled.")
	end
end
concommand.Add("ttt_roundrestart", ttt_roundrestart)

---
-- Version announce also used in Initialize
-- @param Player ply
-- @realm server
function ShowVersion(ply)
	local text = Format("This is [TTT2] Trouble in Terrorist Town 2 (Advanced Update) - by the TTT2 Dev Team (v%s)\n", GAMEMODE.Version)

	if IsValid(ply) then
		ply:PrintMessage(HUD_PRINTNOTIFY, text)
	else
		Msg(text)
	end
end
concommand.Add("ttt_version", ShowVersion)

local function ttt_toggle_newroles(ply)
	if not ply:IsAdmin() then return end

	local b = not ttt_newroles_enabled:GetBool()

	ttt_newroles_enabled:SetBool(b)

	local word = b and "enabled" or "disabled"

	ply:PrintMessage(HUD_PRINTNOTIFY, "You " .. word .. " the new roles for TTT!")
end
concommand.Add("ttt_toggle_newroles", ttt_toggle_newroles)

---
-- This hook is used to sync the global networked vars. It is run in @{GM:SyncGlobals} after the
-- TTT2 globals are synced.
-- @hook
-- @realm server
function GM:TTT2SyncGlobals()

end

---
-- This hook is run before @{GM:TTTCheckForWin} and should be used for custom winconditions in
-- roles. Because this hook will prevent the default hook from being run if a result is returned.
-- @return nil|string The team identifier of the winning team
-- @hook
-- @realm server
function GM:TTT2PreWinChecker()

end

---
-- Called after a player changed their nickname.
-- @param Player ply The player who changed their name
-- @return nil|boolean Return true to prevent the kick of the player
-- @hook
-- @realm server
function GM:TTTNameChangeKick(ply)

end

---
-- A hook to prevent a traitor from receiving the list of their mates.
-- @param table traitorNicks A table of all traitor nicknames
-- @param Player ply The player who should be informed
-- @return nil|boolean Return false to prevent the player from receiving the
-- name of their mates
-- @hook
-- @realm server
function GM:TTT2TellTraitors(traitorNicks, ply)

end

---
-- Can be used to modify the table of teams with alive players. This hook is
-- used in the default win condition.
-- @note A dead player that is revived is counted as alive as well if the revival mode
-- ist set to blocking mode.
-- @param table alives The table of teams which have at least one player still alive
-- @hook
-- @realm server
function GM:TTT2ModifyWinningAlives(alives)

end

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
		LANG.Msg("limit_round", {mapname = nextmap})
	elseif timeLeft <= 0 then
		LANG.Msg("limit_time", {mapname = nextmap})
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

	if self.MapWin ~= WIN_NONE then -- a role wins
		local mapWin = self.MapWin

		self.MapWin = WIN_NONE

		return mapWin
	end

	local aliveTeams = {}
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]
		local team = ply:GetTeam()

		if (ply:IsTerror() or ply:IsBlockingRevival()) and not ply:GetSubRoleData().preventWin and team ~= TEAM_NONE then
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

		if team == TEAM_NONE then continue end

		if not checkedTeams[team] or TEAMS[team].alone then
			-- prevent win of custom role -> maybe own win conditions
			b = b + 1

			-- check
			checkedTeams[team] = true
		end

		-- if 2 teams alive
		if b == 2 then break end
	end

	if b > 1 then -- if >= 2 teams alive: no one wins
		return WIN_NONE -- early out
	elseif b == 1 then -- just 1 team is alive
		return aliveTeams[1]
	else -- rare case: nobody is alive, e.g. because of an explosion
		return TEAM_NONE -- none_win
	end
end
