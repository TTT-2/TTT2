---
-- Trouble in Terrorist Town 2

ttt_include("sh_init")

ttt_include("sh_sprint")
ttt_include("sh_main")
ttt_include("sh_shopeditor")
ttt_include("sh_network_sync")
ttt_include("sh_door")
ttt_include("sh_voice")

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
ttt_include("sv_loadingscreen")

ttt_include("sv_armor")
ttt_include("sh_armor")

ttt_include("sh_player_ext")

ttt_include("sv_player_ext")
ttt_include("sv_player")

ttt_include("sv_weapon_pickup")
ttt_include("sv_addonchecker")

-- Localize stuff we use often. It's like Lua go-faster stripes.
local math = math
local table = table
local net = net
local player = player
local pairs = pairs
local timer = timer
local util = util
local IsValid = IsValid
local ConVarExists = ConVarExists
local CreateConVar = CreateConVar
local hook = hook

local strTmp = ""

local roundtime = CreateConVar("ttt_roundtime_minutes", "10", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local preptime = CreateConVar("ttt_preptime_seconds", "30", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local posttime = CreateConVar("ttt_posttime_seconds", "30", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local firstpreptime = CreateConVar("ttt_firstpreptime", "60", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

local ttt_haste = CreateConVar("ttt_haste", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local haste_starting = CreateConVar("ttt_haste_starting_minutes", "5", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

CreateConVar("ttt_haste_minutes_per_death", "0.5", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

local spawnwaveint = CreateConVar("ttt_spawn_wave_interval", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

-- Traitor credits
CreateConVar("ttt_credits_starting", "2", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_credits_award_pct", "0.35", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_credits_award_size", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_credits_award_repeat", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_credits_detectivekill", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

CreateConVar("ttt_credits_alonebonus", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

CreateConVar("ttt_use_weapon_spawn_scripts", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_weapon_spawn_count", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

local round_limit = CreateConVar("ttt_round_limit", "6", SERVER and {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED)
local time_limit = CreateConVar("ttt_time_limit_minutes", "75", SERVER and {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_REPLICATED)

local idle_enabled = CreateConVar("ttt_idle", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local idle_time = CreateConVar("ttt_idle_limit", "180", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

local voice_drain = CreateConVar("ttt_voice_drain", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local voice_drain_normal = CreateConVar("ttt_voice_drain_normal", "0.2", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local voice_drain_admin = CreateConVar("ttt_voice_drain_admin", "0.05", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local voice_drain_recharge = CreateConVar("ttt_voice_drain_recharge", "0.05", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

local namechangekick = CreateConVar("ttt_namechange_kick", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local namechangebtime = CreateConVar("ttt_namechange_bantime", "10", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

local ttt_detective = CreateConVar("ttt_sherlock_mode", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
local ttt_minply = CreateConVar("ttt_minimum_players", "2", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

-- respawn if dead in preparing time
CreateConVar("ttt2_prep_respawn", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

local map_switch_delay = CreateConVar("ttt2_map_switch_delay", "15", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Time that passes before the map is changed after the last round ends or the timer runs out", 0)

-- toggle whether ragdolls should be confirmed in DetectiveMode() without clicking on "confirm" espacially
CreateConVar("ttt_identify_body_woconfirm", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Toggles whether ragdolls should be confirmed in DetectiveMode() without clicking on confirm espacially")

-- show team of confirmed player
local confirm_team = CreateConVar("ttt2_confirm_team", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

-- confirm players in kill list
CreateConVar("ttt2_confirm_killlist", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

-- innos min pct
local cv_ttt_min_inno_pct = CreateConVar("ttt_min_inno_pct", "0.47", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Minimum multiplicator for each player to calculate the minimum amount of innocents")
local cv_ttt_max_roles = CreateConVar("ttt_max_roles", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different roles")
local cv_ttt_max_roles_pct =  CreateConVar("ttt_max_roles_pct", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different roles based on player amount. ttt_max_roles needs to be 0")
local cv_ttt_max_baseroles = CreateConVar("ttt_max_baseroles", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different baseroles")
local cv_ttt_max_baseroles_pct = CreateConVar("ttt_max_baseroles_pct", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different baseroles based on player amount. ttt_max_baseroles needs to be 0")
CreateConVar("ttt_enforce_playermodel", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Whether or not to enforce terrorist playermodels. Set to 0 for compatibility with Enhanced Playermodel Selector")

-- debuggery
local ttt_dbgwin = CreateConVar("ttt_debug_preventwin", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

PLYFORCEDROLES = {}
PLYFINALROLES = {}
SELECTABLEROLES = nil

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

CHANGED_EQUIPMENT = {}

---
-- Called after the gamemode loads and starts.
-- @hook
-- @realm server
-- @ref https://wiki.garrysmod.com/page/GM/Initialize
-- @local
function GM:Initialize()
	MsgN("Trouble In Terrorist Town 2 gamemode initializing...")
	ShowVersion()

	hook.Run("TTT2Initialize")

	hook.Run("TTT2FinishedLoading")

	-- check for language files to mark them as downloadable for clients
	LANG.SetupFiles("lang/", true)

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
	self.playermodel = GetRandomPlayerModel()
	self.playercolor = COLOR_WHITE

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
-- @ref https://wiki.garrysmod.com/page/GM/GetGameDescription
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
-- @ref https://wiki.garrysmod.com/page/GM/InitPostEntity
-- @local
function GM:InitPostEntity()
	self:InitCvars()

	MsgN("[TTT2][INFO] Client post-init...")

	hook.Run("TTTInitPostEntity")

	InitDefaultEquipment()

	local itms = items.GetList()
	local sweps = weapons.GetList()

	-- load and initialize all SWEPs and all ITEMs from database
	if SQL.CreateSqlTable("ttt2_items", ShopEditor.savingKeys) then
		for i = 1, #itms do
			local eq = itms[i]

			ShopEditor.InitDefaultData(eq)

			local name = GetEquipmentFileName(WEPS.GetClass(eq))
			local loaded, changed = SQL.Load("ttt2_items", name, eq, ShopEditor.savingKeys)

			if not loaded then
				SQL.Init("ttt2_items", name, eq, ShopEditor.savingKeys)
			elseif changed then
				CHANGED_EQUIPMENT[#CHANGED_EQUIPMENT + 1] = {name, eq}
			end
		end

		for i = 1, #sweps do
			local wep = sweps[i]

			ShopEditor.InitDefaultData(wep)

			local name = GetEquipmentFileName(WEPS.GetClass(wep))
			local loaded, changed = SQL.Load("ttt2_items", name, wep, ShopEditor.savingKeys)

			if not loaded then
				SQL.Init("ttt2_items", name, wep, ShopEditor.savingKeys)
			elseif changed then
				CHANGED_EQUIPMENT[#CHANGED_EQUIPMENT + 1] = {name, wep}
			end
		end
	end

	for i = 1, #itms do
		local itm = itms[i]

		CreateEquipment(itm) -- init items

		itm.CanBuy = {} -- reset normal items equipment
	end

	for i = 1, #sweps do
		local wep = sweps[i]

		CreateEquipment(wep) -- init weapons

		wep.CanBuy = {}	-- reset normal weapons equipment
	end

	-- init hudelements fns
	local hudElems = hudelements.GetList()

	for i = 1, #hudElems do
		local hudelem = hudElems[i]

		if not hudelem.togglable then continue end

		local nm = "ttt2_elem_toggled_" .. hudelem.id
		local ret = CreateConVar(nm, "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

		SetGlobalBool(nm, ret:GetBool())

		cvars.AddChangeCallback(nm, function(cvarName, old, new)
			SetGlobalBool(cvarName, tobool(new))
		end, "CVAR_" .. nm)
	end

	-- initialize fallback shops
	InitFallbackShops()

	hook.Run("PostInitPostEntity")

	hook.Run("InitFallbackShops")

	hook.Run("LoadedFallbackShops")

	-- initialize the equipment
	LoadShopsEquipment()

	MsgN("[TTT2][INFO] Shops initialized...")

	WEPS.ForcePrecache()

	timer.Simple(0, function()
		Addonchecker:Check()
	end)
end

---
-- Called after the gamemode has loaded
-- @hook
-- @realm server
-- @ref https://wiki.garrysmod.com/page/GM/PostGamemodeLoaded
-- @local
function GM:PostGamemodeLoaded()

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

	hook.Run("TTT2SyncGlobals")
end

cvars.AddChangeCallback(ttt_detective:GetName(), function(cv, old, new)
	SetGlobalBool("ttt_detective", tobool(tonumber(new)))
end)

cvars.AddChangeCallback(ttt_haste:GetName(), function(cv, old, new)
	SetGlobalBool(ttt_haste:GetName(), tobool(tonumber(new)))
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

	SCORE:RoundStateChange(state)

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
		win = hook.Run("TTT2PreWinChecker") or hook.Call("TTTCheckForWin", GAMEMODE)

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

		if not ply.has_spawned or ply.spawn_nick == ply:Nick() or hook.Call("TTTNameChangeKick", GAMEMODE, ply) then continue end

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
-- @ref https://wiki.garrysmod.com/page/GM/PreCleanupMap
-- @local
function GM:PreCleanupMap()
	ents.TTT.FixParentedPreCleanup()
end

---
-- Called right after the map has cleaned up (usually because game.CleanUpMap was called)
-- @hook
-- @realm server
-- @ref https://wiki.garrysmod.com/page/GM/PostCleanupMap
-- @local
function GM:PostCleanupMap()
	ents.TTT.FixParentedPostCleanup()

	-- init door entities
	door.SetUp()
end

---
-- Called if CheckForMapSwitch has determined that a map change should happen
-- @note Can be used for custom map voting system. Just hook this and return true to override.
-- @param string nextmap next map that would be loaded according to the file that is set by the mapcyclefile convar
-- @param number rounds_left number of rounds left before the next map switch
-- @param number time_left time left before the next map switch in seconds
-- @hook
-- @realm server
function GM:TTT2LoadNextMap(nextmap, rounds_left, time_left)
	if rounds_left <= 0 then
		LANG.Msg("limit_round", {mapname = nextmap})
	elseif time_left <= 0 then
		LANG.Msg("limit_time", {mapname = nextmap})
	end

	timer.Simple(map_switch_delay:GetFloat(), game.LoadNextMap)
end

local function CleanUp()
	game.CleanUpMap()

	-- Strip players now, so that their weapons are not seen by ReplaceEntities
	local plys = player.GetAll()

	for i = 1, #plys do
		local v = plys[i]

		v:StripWeapons()
		v:SetRole(ROLE_INNOCENT) -- will reset team automatically
	end

	-- a different kind of cleanup
	hook.Remove("PlayerSay", "ULXMeCheck")
end

local function SpawnEntities()
	local et = ents.TTT

	-- Spawn weapons from script if there is one
	local import = et.CanImportEntities(game.GetMap())
	if import then
		et.ProcessImportScript(game.GetMap())
	else
		-- Replace HL2DM/ZM ammo/weps with our own
		et.ReplaceEntities()

		-- Populate CS:S/TF2 maps with extra guns
		et.PlaceExtraWeapons()
	end

	-- Finally, get players in there
	SpawnWillingPlayers()
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
-- Adds a delay before the round begings. This is called before @{hooks/GLOBAL/TTTPrepareRound}
-- @note Can be used for custom voting systems
-- @return boolean whether there should be a delay
-- @return number delay in seconds
-- @hook
-- @realm server
function GM:TTTDelayRoundStartForVote()
	--return true, 30
	return false
end

---
-- This @{function} calls @{GM:TTTPrepareRound} and is used to prepare the round
-- @realm server
-- @internal
function PrepareRound()
	-- Check playercount
	if CheckForAbort() then return end

	local delay_round, delay_length = hook.Call("TTTDelayRoundStartForVote", GAMEMODE)

	if delay_round then
		delay_length = delay_length or 30

		LANG.Msg("round_voting", {num = delay_length})

		timer.Create("delayedprep", delay_length, 1, PrepareRound)

		return
	end

	-- Cleanup
	if GAMEMODE.FirstRound then
		-- if we are going to import entities, it's no use replacing HL2DM ones as
		-- soon as they spawn, because they'll be removed anyway
		ents.TTT.SetReplaceChecking(not ents.TTT.CanImportEntities(game.GetMap()))
	end

	CleanUp()

	GAMEMODE.roundCount = GAMEMODE.roundCount + 1

	GAMEMODE.MapWin = WIN_NONE
	GAMEMODE.AwardedCredits = false
	GAMEMODE.AwardedCreditsDead = 0

	SCORE:Reset()

	-- Update damage scaling
	KARMA.RoundBegin()

	-- New look. Random if no forced model set.
	GAMEMODE.playermodel = GAMEMODE.force_plymodel == "" and GetRandomPlayerModel() or GAMEMODE.force_plymodel
	GAMEMODE.playercolor = hook.Call("TTTPlayerColor", GAMEMODE, GAMEMODE.playermodel)

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

	-- Delay spawning until next frame to avoid ent overload
	timer.Simple(0.01, SpawnEntities)

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
		plys[i]:SetTargetPlayer(nil)
	end

	-- Tell hooks and map we started prep
	hook.Call("TTTPrepareRound", GAMEMODE)

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

		if not v:HasTeam(TEAM_TRAITOR) then continue end

		traitornicks[#traitornicks + 1] = v:Nick()
	end

	for i = 1, #plys do
		local v = plys[i]

		if not v:HasTeam(TEAM_TRAITOR) then continue end

		local tmp = table.Copy(traitornicks)

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

---
-- Spawns all @{Player}s
-- @param boolean dead_only
-- @realm server
function SpawnWillingPlayers(dead_only)
	local plys = player.GetAll()
	local wave_delay = spawnwaveint:GetFloat()

	-- simple method, should make this a case of the other method once that has
	-- been tested.
	if wave_delay <= 0 or dead_only then
		for i = 1, #plys do
			plys[i]:SpawnForRound(dead_only)
		end
	else
		-- wave method
		local num_spawns = #GetSpawnEnts()
		local to_spawn = {}

		for _, ply in RandomPairs(plys) do
			if ply:ShouldSpawn() then
				to_spawn[#to_spawn + 1] = ply

				GAMEMODE:PlayerSpawnAsSpectator(ply)
			end
		end

		local sfn = function()
			local c = 0
			-- fill the available spawnpoints with players that need
			-- spawning

			while c < num_spawns and #to_spawn > 0 do
				for k = 1, #to_spawn do
					local ply = to_spawn[k]

					if IsValid(ply) and ply:SpawnForRound() then
						-- a spawn ent is now occupied
						c = c + 1
					end
					-- Few possible cases:
					-- 1) player has now been spawned
					-- 2) player should remain spectator after all
					-- 3) player has disconnected
					-- In all cases we don't need to spawn them again.
					table.remove(to_spawn, k)

					-- all spawn ents are occupied, so the rest will have
					-- to wait for next wave
					if c >= num_spawns then break end
				end
			end

			MsgN("Spawned " .. c .. " players in spawn wave.")

			if #to_spawn == 0 then
				timer.Remove("spawnwave")

				MsgN("Spawn waves ending, all players spawned.")
			end
		end

		MsgN("Spawn waves starting.")

		timer.Create("spawnwave", wave_delay, 0, sfn)

		-- already run one wave, which may stop the timer if everyone is spawned
		-- in one go
		sfn()
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
	SpawnWillingPlayers(true)

	-- Remove their ragdolls
	ents.TTT.RemoveRagdolls(true)

	-- remove decals
	util.ClearDecals()

	if CheckForAbort() then return end

	-- Select traitors & co. This is where things really start so we can't abort
	-- anymore.
	SELECTABLEROLES = nil

	SelectRoles()

	LANG.Msg("round_selected")

	-- Edge case where a player joins just as the round starts and is picked as
	-- traitor, but for whatever reason does not get the traitor state msg. So
	-- re-send after a second just to make sure everyone is getting it.
	-- TODO improve
	timer.Simple(1, SendFullStateUpdate)
	timer.Simple(10, SendFullStateUpdate)

	SCORE:HandleSelection() -- log traitors and detectives

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

	GAMEMODE:UpdatePlayerLoadouts() -- needs to happen when round_active

	ARMOR:InitPlayerArmor()

	hook.Call("TTTBeginRound", GAMEMODE)

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
	elseif result == WIN_NONE then
		LANG.Msg("win_bees")
		ServerLog("Result: The Bees win (Its a Draw).\n")

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
		ServerLog("Result: " .. result .. " win.\n") -- TODO translation

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
	local rounds_left = math.max(0, GetGlobalInt("ttt_rounds_left", 6) - 1)

	SetGlobalInt("ttt_rounds_left", rounds_left)

	local time_left = math.max(0, time_limit:GetInt() * 60 - CurTime())
	local nextmap = string.upper(game.GetMapNext())

	if rounds_left <= 0 or time_left <= 0 then
		timer.Stop("end2prep")

		hook.Run("TTT2LoadNextMap", nextmap, rounds_left, time_left)
	else
		LANG.Msg("limit_left", {num = rounds_left, time = math.ceil(time_left / 60)})
	end
end

---
-- This @{function} calls @{GM:TTTEndRound} and is used to end the round
-- @realm server
-- @internal
function EndRound(result)
	PrintResultMessage(result)

	-- first handle round end
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
	CheckForMapSwitch()

	KARMA.RoundEnd()

	-- now handle potentially error prone scoring stuff

	-- register an end of round event
	SCORE:RoundComplete(result)

	-- update player scores
	SCORE:ApplyEventLogScores(result)

	-- send the clients the round log, players will be shown the report
	SCORE:StreamToClients()

	-- server plugins might want to start a map vote here or something
	-- these hooks are not used by TTT internally
	-- possible incompatibility for other addons
	hook.Call("TTTEndRound", GAMEMODE, result)

	ents.TTT.TriggerRoundStateOutputs(ROUND_POST, result)
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

---
-- Win checker hook to add your own win conditions
-- @note The most basic win check is whether both sides have one dude alive
-- @hook
-- @realm server
function GM:TTTCheckForWin()
	ttt_dbgwin = ttt_dbgwin or CreateConVar("ttt_debug_preventwin", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

	if ttt_dbgwin:GetBool() then
		return WIN_NONE
	end

	if self.MapWin ~= WIN_NONE then -- a role wins
		local mw = self.MapWin

		self.MapWin = WIN_NONE

		return mw
	end

	local alive = {}
	local plys = player.GetAll()

	for i = 1, #plys do
		local v = plys[i]
		local tm = v:GetTeam()

		if (v:IsTerror() or v.forceRevive) and not v:GetSubRoleData().preventWin and tm ~= TEAM_NONE then
			alive[#alive + 1] = tm
		end
	end

	hook.Run("TTT2ModifyWinningAlives", alive)

	local checkedTeams = {}
	local b = 0

	for i = 1, #alive do
		local team = alive[i]

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
		return alive[1]
	else -- rare case: nobody is alive, e.g. because of an explosion
		--return WIN_NONE -- bees_win
		return WIN_TRAITOR
	end
end

local function GetEachRoleCount(ply_count, role_type)
	if role_type == INNOCENT.name then
		return math.floor(ply_count * cv_ttt_min_inno_pct:GetFloat()) or 0
	end

	if ply_count < GetConVar("ttt_" .. role_type .. "_min_players"):GetInt() then
		return 0
	end

	-- get number of role members: pct of players rounded down
	local role_count = math.floor(ply_count * GetConVar("ttt_" .. role_type .. "_pct"):GetFloat())
	local maxm = 1

	strTmp = "ttt_" .. role_type .. "_max"

	if ConVarExists(strTmp) then
		maxm = GetConVar(strTmp):GetInt()
	end

	if maxm > 1 then
		-- make sure there is at least 1 of the role
		role_count = math.Clamp(role_count, 1, maxm)
	else
		-- there need to be max and min 1 player of this role
		--role_count = math.Clamp(role_count, 1, 1)
		role_count = 1
	end

	return role_count
end

---
-- Returns the amount of pre selected @{ROLE}s
-- @param number subrole subrole id of a @{ROLE}'s index
-- @return number amount
-- @realm server
function GetPreSelectedRole(subrole)
	local tmp = 0

	if GetRoundState() == ROUND_ACTIVE then
		local plys = player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			if not IsValid(ply) or ply:GetForceSpec() or ply:GetSubRole() ~= subrole then continue end

			tmp = tmp + 1
		end
	elseif PLYFINALROLES then
		for ply, sr in pairs(PLYFINALROLES) do
			if sr == subrole then
				tmp = tmp + 1
			end
		end
	end

	return tmp
end

local function AddAvailableRoles(roleData, tbl, iTbl, forced, max_plys)
	local b = true

	if not forced then
		strTmp = "ttt_" .. roleData.name .. "_random"

		local r = ConVarExists(strTmp) and GetConVar(strTmp):GetInt() or 0

		if r <= 0 then
			b = false
		elseif r < 100 then
			b = math.random(100) <= r
		end
	end

	if b then
		local tmp2 = GetEachRoleCount(max_plys, roleData.name) - GetPreSelectedRole(roleData.index)
		if tmp2 > 0 then
			tbl[roleData] = tmp2
			iTbl[#iTbl + 1] = roleData
		end
	end
end

---
-- Returns all selectable @{ROLE}s based on the amount of @{Player}s
-- @note This @{function} automatically saves the selectable @{ROLE}s for the current round
-- @param table plys list of @{Player}s
-- @param number max_plys amount of maximum @{Player}s
-- @return table a list of all selectable @{ROLE}s
-- @realm server
function GetSelectableRoles(plys, max_plys)
	if not plys then
		local tmp = {}
		local allPlys = player.GetAll()

		for i = 1, #allPlys do
			local v = allPlys[i]

			-- everyone on the spec team is in specmode
			if IsValid(v) and not v:GetForceSpec() and (not plys or table.HasValue(plys, v)) and not hook.Run("TTT2DisableRoleSelection", v) then
				tmp[#tmp + 1] = v
			end
		end

		plys = tmp
	end

	max_plys = max_plys or #plys

	if max_plys < 2 then return end

	if SELECTABLEROLES then
		return SELECTABLEROLES
	end

	local selectableRoles = {
		[INNOCENT] = GetEachRoleCount(max_plys, INNOCENT.name) - GetPreSelectedRole(ROLE_INNOCENT),
		[TRAITOR] = GetEachRoleCount(max_plys, TRAITOR.name) - GetPreSelectedRole(ROLE_TRAITOR)
	}

	local newRolesEnabled = GetConVar("ttt_newroles_enabled"):GetBool()
	local forcedRolesTbl = {}

	for id, subrole in pairs(PLYFORCEDROLES) do
		forcedRolesTbl[subrole] = true
	end

	local tmpTbl = {}
	local iTmpTbl = {}
	local checked = {}
	local rlsList = roles.GetList()

	for i = 1, #rlsList do
		local v = rlsList[i]

		if checked[v.index] then continue end

		checked[v.index] = true

		if v ~= INNOCENT and v ~= TRAITOR and (newRolesEnabled or v == DETECTIVE) and v:IsSelectable() then

			-- at first, check for baserole availibility
			if v.baserole and v.baserole ~= ROLE_INNOCENT and v.baserole ~= ROLE_TRAITOR then
				local rd = roles.GetByIndex(v.baserole)

				if not checked[v.baserole] then
					checked[v.baserole] = true

					AddAvailableRoles(v, tmpTbl, iTmpTbl, forcedRolesTbl[v.baserole], max_plys)
				end

				-- continue if baserole is not available
				local base_count = tmpTbl[rd]
				if not base_count or base_count < 1 then
					continue
				end
			end

			-- now check for subrole availability
			AddAvailableRoles(v, tmpTbl, iTmpTbl, forcedRolesTbl[v.index], max_plys)
		end
	end

	local roles_count = 2
	local baseroles_count = 2

	-- yea it begins
	local max_roles = cv_ttt_max_roles:GetInt()
	if max_roles == 0 then
		max_roles = math.floor(cv_ttt_max_roles_pct:GetFloat() * max_plys)
		if max_roles == 0 then
			max_roles = nil
		end
	end

	-- damn, not again
	local max_baseroles = cv_ttt_max_baseroles:GetInt()
	if max_baseroles == 0 then
		max_baseroles = math.floor(cv_ttt_max_baseroles_pct:GetFloat() * max_plys)
		if max_baseroles == 0 then
			max_baseroles = nil
		end
	end

	for i = 1, #iTmpTbl do
		if max_roles and roles_count >= max_roles then break end

		local rnd = math.random(#iTmpTbl)
		local v = iTmpTbl[rnd]

		table.remove(iTmpTbl, rnd)

		if v.baserole then
			local br = roles.GetByIndex(v.baserole)

			if not selectableRoles[br] then
				if max_baseroles and baseroles_count >= max_baseroles then continue end

				selectableRoles[br] = tmpTbl[br]
				roles_count = roles_count + 1
				baseroles_count = baseroles_count + 1

				if max_roles and roles_count >= max_roles then break end
			end
		end

		if not selectableRoles[v] then
			selectableRoles[v] = tmpTbl[v]
			roles_count = roles_count + 1

			if not v.baserole then
				baseroles_count = baseroles_count + 1
			end
		end
	end

	SELECTABLEROLES = selectableRoles

	return selectableRoles
end

local function SetRoleTypes(choices, prev_roles, roleCount, availableRoles, defaultRole)
	local choices_i = #choices
	local availableRoles_i = #availableRoles

	while choices_i > 0 and availableRoles_i > 0 do
		local pick = math.random(choices_i)
		local pply = choices[pick]

		if IsValid(pply) then
			local vpick = math.random(availableRoles_i)
			local v = availableRoles[vpick]
			local type_count = roleCount[v.index]

			strTmp = "ttt_" .. v.name .. "_karma_min"

			local min_karmas = ConVarExists(strTmp) and GetConVar(strTmp):GetInt() or 0

			-- if player was last round innocent, he will be another role (if he has enough karma)
			if choices_i <= type_count or (
				pply:GetBaseKarma() > min_karmas
				and table.HasValue(prev_roles[ROLE_INNOCENT], pply)
				and not pply:GetAvoidRole(v.index)
				or math.random(3) == 2
			) then
				PLYFINALROLES[pply] = PLYFINALROLES[pply] or v.index

				table.remove(choices, pick)

				choices_i = choices_i - 1
				type_count = type_count - 1
				roleCount[v.index] = type_count

				if type_count <= 0 then
					table.remove(availableRoles, vpick)

					availableRoles_i = availableRoles_i - 1
				end
			end
		end
	end

	if defaultRole then
		for i = 1, #choices do
			local ply = choices[i]

			PLYFINALROLES[ply] = PLYFINALROLES[ply] or defaultRole
		end
	end
end

local function SelectForcedRoles(max_plys, roleCount, allSelectableRoles, choices)
	local transformed = {}

	for id, subrole in pairs(PLYFORCEDROLES) do
		local ply = player.GetByUniqueID(id)

		if not IsValid(ply) then
			PLYFORCEDROLES[id] = nil
		else
			transformed[subrole] = transformed[subrole] or {}
			transformed[subrole][#transformed[subrole] + 1] = ply
		end
	end

	for subrole, ps in pairs(transformed) do
		local rd = roles.GetByIndex(subrole)

		if table.HasValue(allSelectableRoles, rd) then
			local role_count = roleCount[subrole]
			local c = 0
			local a = #ps

			for i = 1, a do
				local pick = math.random(#ps)
				local ply = ps[pick]

				if c >= role_count then break end

				table.remove(transformed[subrole], pick)

				PLYFORCEDROLES[ply:UniqueID()] = nil
				PLYFINALROLES[ply] = PLYFINALROLES[ply] or subrole
				c = c + 1

				for k = 1, #choices do
					if choices[k] ~= ply then continue end

					table.remove(choices, k)
				end

				hook.Run("TTT2ReceivedForcedRole", ply, rd, true)
			end
		end
	end

	for id, subrole in pairs(PLYFORCEDROLES) do
		local ply = player.GetByUniqueID(id)
		local rd = roles.GetByIndex(subrole)

		hook.Run("TTT2ReceivedForcedRole", ply, rd, false)
	end

	PLYFORCEDROLES = {}
end

local function UpgradeRoles(plys, prev_roles, roleCount, selectableRoles, roleData)
	if roleData == INNOCENT or roleData == TRAITOR or roleData == DETECTIVE or GetConVar("ttt_newroles_enabled"):GetBool() then
		local availableRoles = {}

		-- now upgrade this role if there are other subroles
		for v in pairs(selectableRoles) do
			if v.baserole == roleData.index then
				availableRoles[#availableRoles + 1] = v
			end
		end

		SetRoleTypes(plys, prev_roles, roleCount, availableRoles, roleData.index)
	end
end

local function SelectBaseRole(choices, prev_roles, roleCount, roleData)
	local rs = 0
	local ls = {}

	while rs < roleCount[roleData.index] and #choices > 0 do
		-- select random index in choices table
		local pick = math.random(#choices)

		-- the player we consider
		local pply = choices[pick]

		strTmp = "ttt_" .. roleData.name .. "_karma_min"

		local min_karmas = ConVarExists(strTmp) and GetConVar(strTmp):GetInt() or 0

		-- give this guy the role if he was not this role last time, or if he makes
		-- a roll
		if IsValid(pply) and (
			roleData == INNOCENT or (
				#choices <= roleCount[roleData.index] or (
					pply:GetBaseKarma() > min_karmas
					and table.HasValue(prev_roles[ROLE_INNOCENT], pply)
					and not pply:GetAvoidRole(roleData.index)
					or math.random(3) == 2
				)
			)
		) then
			table.remove(choices, pick)

			ls[#ls + 1] = pply
			rs = rs + 1
		end
	end

	return ls
end

---
-- Select selectable @{ROLE}s for a given list of @{Player}s
-- @note This automatically synces with every connected @{Player}
-- @param table plys list of @{Player}s
-- @param number max_plys amount of maximum @{Player}s
-- @realm server
function SelectRoles(plys, max_plys)
	local choices = {}
	local prev_roles = {}
	local tmp = {}

	GAMEMODE.LastRole = GAMEMODE.LastRole or {}

	local allPlys = player.GetAll()

	for i = 1, #allPlys do
		local v = allPlys[i]

		-- everyone on the spec team is in specmode
		if not v:GetForceSpec() and (not plys or table.HasValue(plys, v)) and not hook.Run("TTT2DisableRoleSelection", v) then
			if not plys then
				tmp[#tmp + 1] = v
			end

			-- save previous role and sign up as possible traitor/detective
			local r = GAMEMODE.LastRole[v:SteamID64()] or v:GetSubRole() or ROLE_INNOCENT

			prev_roles[r] = prev_roles[r] or {}
			prev_roles[r][#prev_roles[r] + 1] = v
			choices[#choices + 1] = v
		end
	end

	plys = plys or tmp
	max_plys = max_plys or #plys

	if max_plys < 2 then return end

	local roleCount = {}
	local selectableRoles = GetSelectableRoles(plys, max_plys) -- update SELECTABLEROLES table

	hook.Run("TTT2ModifySelectableRoles", selectableRoles)

	local rlsList = roles.GetList()

	for i = 1, #rlsList do
		local v = rlsList[i]

		roleCount[v.index] = selectableRoles[v] or 0
	end

	SelectForcedRoles(max_plys, roleCount, selectableRoles, choices)

	-- first select traitors, then innos, then the other roles
	local list = {
		[1] = TRAITOR,
		[2] = INNOCENT
	}

	local tmpTbl = {}

	-- get selectable baseroles (except traitor and innocent)
	for i = 1, #rlsList do
		local v = rlsList[i]

		if v == TRAITOR or v == INNOCENT or table.HasValue(tmpTbl, v) or not selectableRoles[v] or v.baserole then continue end

		tmpTbl[#tmpTbl + 1] = v
	end

	-- randomize order of custom roles, but keep traitor as first and innocent as second
	for i = 1, #tmpTbl do
		local rnd = math.random(#tmpTbl)

		list[#list + 1] = tmpTbl[rnd]

		table.remove(tmpTbl, rnd)
	end

	for i = 1, #list do
		local roleData = list[i]

		if #choices == 0 then break end

		-- if roleData == INNOCENT then just remove the random ply from choices
		local ls = SelectBaseRole(choices, prev_roles, roleCount, roleData)

		-- upgrade innos and players without any role later
		if roleData ~= INNOCENT then
			UpgradeRoles(ls, prev_roles, roleCount, selectableRoles, roleData)
		end
	end

	-- last but not least, upgrade the innos and players without any role to special/normal innos
	local innos = {}

	for i = 1, #plys do
		local ply = plys[i]

		PLYFINALROLES[ply] = PLYFINALROLES[ply] or ROLE_INNOCENT

		if PLYFINALROLES[ply] ~= ROLE_INNOCENT then continue end

		innos[#innos + 1] = ply
		PLYFINALROLES[ply] = nil -- reset it to update it in UpgradeRoles
	end

	UpgradeRoles(innos, prev_roles, roleCount, selectableRoles, INNOCENT)

	GAMEMODE.LastRole = {}

	for i = 1, #plys do
		local ply = plys[i]
		local subrole = PLYFINALROLES[ply] or ROLE_INNOCENT

		ply:SetRole(subrole, nil, true)

		-- store a steamid -> role map
		GAMEMODE.LastRole[ply:SteamID64()] = subrole
	end

	-- just set the credits after all roles were selected (to fix alone traitor bug)
	for i = 1, #plys do
		plys[i]:SetDefaultCredits()
	end

	PLYFINALROLES = {}

	SendFullStateUpdate()
end

hook.Add("PlayerAuthed", "TTT2PlayerAuthedSharedHook", function(ply, steamid, uniqueid)
	net.Start("TTT2PlayerAuthedShared")
	net.WriteString(util.SteamIDTo64(steamid))
	net.WriteString((ply and ply:Nick()) or "UNKNOWN")
	net.Broadcast()
end)

local function ttt_roundrestart(ply, command, args)
	-- ply is nil on dedicated server console
	if not IsValid(ply) or ply:IsAdmin() or ply:IsSuperAdmin() or cvars.Bool("sv_cheats", 0) then
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
	local text = Format("This is [TTT2] Trouble in Terrorist Town 2 (Advanced Update) - by Alf21 (v%s)\n", GAMEMODE.Version)

	if IsValid(ply) then
		ply:PrintMessage(HUD_PRINTNOTIFY, text)
	else
		Msg(text)
	end
end
concommand.Add("ttt_version", ShowVersion)

local function ttt_toggle_newroles(ply)
	if not ply:IsAdmin() then return end

	local b = not GetConVar("ttt_newroles_enabled"):GetBool()

	RunConsoleCommand("ttt_newroles_enabled", b and "1" or "0")

	local word = "enabled"

	if not b then
		word = "disabled"
	end

	ply:PrintMessage(HUD_PRINTNOTIFY, "You " .. word .. " the new roles for TTT!")
end
concommand.Add("ttt_toggle_newroles", ttt_toggle_newroles)
