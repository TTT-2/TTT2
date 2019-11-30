---
-- Trouble in Terrorist Town 2

ttt_include("sh_init")

ttt_include("sh_main")
ttt_include("sh_shopeditor")

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

ttt_include("sv_armor")
ttt_include("sh_armor")

ttt_include("sh_nwlib")
ttt_include("sv_nwlib")
ttt_include("sh_player_ext")

ttt_include("sv_player_ext")
ttt_include("sv_player")

ttt_include("sh_sprint")
ttt_include("sv_weapon_pickup")

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

local round_limit = CreateConVar("ttt_round_limit", "6", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
local time_limit = CreateConVar("ttt_time_limit_minutes", "75", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})

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

-- toggle whether ragdolls should be confirmed in DetectiveMode() without clicking on "confirm" espacially
CreateConVar("ttt_identify_body_woconfirm", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Toggles whether ragdolls should be confirmed in DetectiveMode() without clicking on confirm espacially")

-- show team of confirmed player
local confirm_team = CreateConVar("ttt2_confirm_team", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

-- confirm players in kill list
CreateConVar("ttt2_confirm_killlist", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

-- innos min pct
CreateConVar("ttt_min_inno_pct", "0.47", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Minimum multiplicator for each player to calculate the minimum amount of innocents")
CreateConVar("ttt_max_roles", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different roles")
CreateConVar("ttt_max_roles_pct", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different roles based on player amount. ttt_max_roles needs to be 0")
CreateConVar("ttt_max_baseroles", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different baseroles")
CreateConVar("ttt_max_baseroles_pct", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different baseroles based on player amount. ttt_max_baseroles needs to be 0")

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
util.AddNetworkString("TTT_ShowPrints")
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

local buggyAddons = { -- addons that do not work (well) with TTT2
	["656662924"] = "1367128301", -- Killer Notifier by nerzlakai96
	["167547072"] = "1367128301", -- Killer Notifier by StarFox

	["649273679"] = "1367128301", -- Role Counter by Zaratusa

	["1531794562"] = "1367128301", -- Killer Info by wurffl
	["257624318"] = "1367128301", -- Killer info by DerRene

	["308966836"] = "1473581448", -- Death Faker by Exho
	["922007616"] = "1473581448", -- Death Faker by BocciardoLight
	["785423990"] = "1473581448", -- Death Faker by markusmarkusz
	["236217898"] = "1473581448", -- Death Faker by jayjayjay1
	["912181642"] = "1473581448", -- Death Faker by w4rum

	["127865722"] = "1362430347", -- TTT ULX by Bender180

	["305101059"] = "", -- ID Bomb by MolagA

	["663328966"] = "", -- damagelogs by Hundreth

	["404599106"] = "", -- SpectatorDeathmatch by P4sca1 [EGM]

	["253737047"] = "1398388611", -- Golden Deagle by Zaratusa
	["637848943"] = "1398388611", -- Golden Deagle by Zaratusa
	["1376434172"] = "1398388611", -- Golden Deagle by DaniX_Chile
	["1434026961"] = "1398388611", -- Golden Deagle by Mangonaut
	["303535203"] = "1398388611", -- Golden Deagle by Navusaur
	["1325415810"] = "1398388611", -- Golden Deagle by Faedon | Max
	["648505481"] = "1398388611", -- Golden Deagle by TypicalRookie
	["659643589"] = "1398388611", -- Golden Deagle by 中國是同性戀

	["828347015"] = "1566390281", -- TTT Totem

	["644532564"] = "", -- TTT Totem content

	["1092556189"] = "", -- Town of Terror by Jenssons

	["1215502383"] = "" -- Custom Roles by Noxx
}

local outdatedAddons = { -- addons that have newer versions in the WS
	["940215686"] = "1637001449", -- Clairvoyancy by Doctor Jew
	["654341247"] = "1637001449", -- Clairvoyancy by Liberty

	["130051756"] = "1584675927", -- Spartan Kick by uacnix
	["122277196"] = "1584675927", -- Spartan Kick by Chowder908
	["922510848"] = "1584675927", -- Spartan Kick by BocciardoLight
	["282584080"] = "1584675927", -- Spartan Kick by Porter
	["1092632443"] = "1584675927", -- Spartan Kick by Jenssons

	["1523332573"] = "1584780982", -- Thomas by Tubner
	["962093923"] = "1584780982", -- Thomas by ThunfischArnold
	["1479128258"] = "1584780982", -- Thomas by JollyJelly1001
	["1390915062"] = "1584780982", -- Thomas by Doc Snyder
	["1171584841"] = "1584780982", -- Thomas by Maxdome
	["811718553"] = "1584780982", -- Thomas by Mr C Funk

	["922355426"] = "1629914760", -- Melon Mine by Phoenixf129
	["960077088"] = "1629914760", -- Melon Mine by TheSoulrester

	["309299668"] = "1630269736", -- Martyrdom by Exho
	["1324649928"] = "1630269736", -- Martyrdom by Doctor Jew
	["899206223"] = "1630269736", -- Martyrdom by Koksgesicht

	["652046425"] = "1640512667", -- Juggernaut Suit by Zaratusa

	["652046425"] = "1470823315", -- Beartrap by Milkwater
	["652046425"] = "407751746", -- Beartrap by Nerdhive

	["273623128"] = "842302491", -- Juggernaut by Hoff
	["1387914296"] = "842302491", -- Juggernaut by Schmitler
	["1371596971"] = "842302491", -- Juggernaut by Amenius
	["860794236"] = "842302491", -- Juggernaut by Menzek
	["1198504029"] = "842302491", -- Juggernaut by RedocPlays
	["911658617"] = "842302491", -- Juggernaut by Luchix
	["869353740"] = "842302491", -- Juggernaut by Railroad Engineer 111

	["310403937"] = "1662844145", -- Prop Disguiser by Exho
	["843092697"] = "1662844145", -- Prop Disguiser by Soren
	["937535488"] = "1662844145", -- Prop Disguiser by St Addi
	["1168304202"] = "1662844145", -- Prop Disguiser by Izellix
	["1361103159"] = "1662844145", -- Prop Disguiser by Derp altamas
	["1301826793"] = "1662844145", -- Prop Disguiser by Akechi

	["254779132"] = "810154456", -- Dead Ringer by Porter
	["1315377462"] = "810154456", -- Dead Ringer by MuratYilderimTM
	["240281783"] = "810154456", -- Dead Ringer by Niandra

	["863963592"] = "1815518231" -- Super Soda by ---
}

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

	ShopEditor.SetupShopEditorCVars()
	ShopEditor.CreateShopDBs()

	-- Force friendly fire to be enabled. If it is off, we do not get lag compensation.
	RunConsoleCommand("mp_friendlyfire", "1")

	-- Default crowbar unlocking settings, may be overridden by config entity
	GAMEMODE.crowbar_unlocks = {
		[OPEN_DOOR] = true,
		[OPEN_ROT] = true,
		[OPEN_BUT] = true,
		[OPEN_NOTOGGLE] = true
	}

	-- More map config ent defaults
	GAMEMODE.force_plymodel = ""
	GAMEMODE.propspec_allow_named = true

	GAMEMODE.MapWin = WIN_NONE
	GAMEMODE.AwardedCredits = false
	GAMEMODE.AwardedCreditsDead = 0

	GAMEMODE.round_state = ROUND_WAIT
	GAMEMODE.FirstRound = true
	GAMEMODE.RoundStartTime = 0

	GAMEMODE.DamageLog = {}
	GAMEMODE.LastRole = {}
	GAMEMODE.playermodel = GetRandomPlayerModel()
	GAMEMODE.playercolor = COLOR_WHITE

	-- Delay reading of cvars until config has definitely loaded
	GAMEMODE.cvar_init = false

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

	GAMEMODE:SyncGlobals()

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
	GAMEMODE:InitCvars()

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
		hook.Run("TTT2ModifyIncompatibleAddons", buggyAddons)
		hook.Run("TTT2ModifyOutdatedAddons", outdatedAddons)

		local c = 0
		local addns = engine.GetAddons()

		for i = 1, #addns do
			local addon = addns[i]
			local key = tostring(addon.wsid)

			local buggy_addon = buggyAddons[key]
			if buggy_addon then
				c = c + 1
				buggyAddons[key] = nil

				if buggy_addon ~= "" then
					buggy_addon = "\nThere is a compatible Add-On available at: https://steamcommunity.com/sharedfiles/filedetails/?id=" .. buggy_addon
				end

				ErrorNoHalt((c == 1 and "\n\n" or "") .. "[TTT2][ERROR]Incompatible Add-On detected: " .. addon.title .. " (WS-ID: '" .. addon.wsid .. "')." .. buggy_addon .. "\n\n")
			end

			local outdated_addon = outdatedAddons[key]
			if outdated_addon then
				c = c + 1
				buggyAddons[key] = nil

				if outdated_addon ~= "" then
					outdated_addon = "\nThere is an updated Add-On available at: https://steamcommunity.com/sharedfiles/filedetails/?id=" .. outdated_addon
				end

				ErrorNoHalt((c == 1 and "\n\n" or "") .. "[TTT2][ERROR]Outdated Add-On detected: " .. addon.title .. " (WS-ID: '" .. addon.wsid .. "').\nYour version does work with TTT2, but there's an addon which uses some of the new features of TTT2." .. outdated_addon .. "\n\n")
			end
		end

		buggyAddons = nil -- delete
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
	SetGlobalBool("ttt_haste", ttt_haste:GetBool())
	SetGlobalInt("ttt_time_limit_minutes", time_limit:GetInt())
	SetGlobalBool("ttt_highlight_admins", GetConVar("ttt_highlight_admins"):GetBool())
	SetGlobalBool("ttt_highlight_dev", GetConVar("ttt_highlight_dev"):GetBool())
	SetGlobalBool("ttt_highlight_vip", GetConVar("ttt_highlight_vip"):GetBool())
	SetGlobalBool("ttt_highlight_addondev", GetConVar("ttt_highlight_addondev"):GetBool())
	SetGlobalBool("ttt_highlight_supporter", GetConVar("ttt_highlight_supporter"):GetBool())
	SetGlobalBool("ttt_armor_classic", GetConVar("ttt_armor_classic"):GetBool())
	SetGlobalBool("ttt_armor_enable_reinforced", GetConVar("ttt_armor_enable_reinforced"):GetBool())
	SetGlobalInt("ttt_armor_threshold_for_reinforced", GetConVar("ttt_armor_threshold_for_reinforced"):GetInt())
	SetGlobalBool("ttt_locational_voice", GetConVar("ttt_locational_voice"):GetBool())
	SetGlobalInt("ttt_idle_limit", idle_time:GetInt())
	SetGlobalBool("ttt_idle", idle_enabled:GetBool())

	SetGlobalBool("ttt_voice_drain", voice_drain:GetBool())
	SetGlobalFloat("ttt_voice_drain_normal", voice_drain_normal:GetFloat())
	SetGlobalFloat("ttt_voice_drain_admin", voice_drain_admin:GetFloat())
	SetGlobalFloat("ttt_voice_drain_recharge", voice_drain_recharge:GetFloat())

	local rlsList = roles.GetList()

	for i = 1, #rlsList do
		local abbr = rlsList[i].abbr

		SetGlobalString("ttt_" .. abbr .. "_shop_fallback", GetConVar("ttt_" .. abbr .. "_shop_fallback"):GetString())
	end

	SetGlobalBool("ttt2_confirm_team", confirm_team:GetBool())

	hook.Run("TTT2SyncGlobals")
end

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
			LANG.Msg(v, "round_traitors_one")

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

		LANG.Msg(v, "round_traitors_more", {names = names})
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

			local spawnCount = #to_spawn

			while c < num_spawns and spawnCount > 0 do
				for k = 1, spawnCount do
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

	if CheckForAbort() then return end

	-- Select traitors & co. This is where things really start so we can't abort
	-- anymore.
	SELECTABLEROLES = nil

	SelectRoles()

	LANG.Msg("round_selected")

	-- Edge case where a player joins just as the round starts and is picked as
	-- traitor, but for whatever reason does not get the traitor state msg. So
	-- re-send after a second just to make sure everyone is getting it.
	-- TODO test
	-- TODO SendFullStateUpdate should use the networking queuing system to keep consistent data
	SendFullStateUpdate()
	--timer.Simple(1, SendFullStateUpdate)
	--timer.Simple(10, SendFullStateUpdate)

	SCORE:HandleSelection() -- log traitors and detectives

	-- TODO fix with one single netmsg
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
	local switchmap = false
	local nextmap = string.upper(game.GetMapNext())

	if rounds_left <= 0 then
		LANG.Msg("limit_round", {mapname = nextmap})

		switchmap = true
	elseif time_left <= 0 then
		LANG.Msg("limit_time", {mapname = nextmap})

		switchmap = true
	end

	if switchmap then
		timer.Stop("end2prep")
		timer.Simple(15, game.LoadNextMap)
	else
		LANG.Msg("limit_left", {num = rounds_left, time = math.ceil(time_left / 60), mapname = nextmap})
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

	if GAMEMODE.MapWin ~= WIN_NONE then -- a role wins
		local mw = GAMEMODE.MapWin

		GAMEMODE.MapWin = WIN_NONE

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
		local min_innos = GetConVar("ttt_min_inno_pct")

		return min_innos and math.floor(ply_count * min_innos:GetFloat()) or 0
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
	local max_roles = GetConVar("ttt_max_roles")
	if max_roles then
		max_roles = max_roles:GetInt()
		if max_roles == 0 then
			max_roles = GetConVar("ttt_max_roles_pct")
			if max_roles then
				max_roles = math.floor(max_roles:GetFloat() * max_plys)
				if max_roles == 0 then
					max_roles = nil
				end
			end
		end
	end

	-- damn, not again
	local max_baseroles = GetConVar("ttt_max_baseroles")
	if max_baseroles then
		max_baseroles = max_baseroles:GetInt()
		if max_baseroles == 0 then
			max_baseroles = GetConVar("ttt_max_baseroles_pct")
			if max_baseroles then
				max_baseroles = math.floor(max_baseroles:GetFloat() * max_plys)
				if max_baseroles == 0 then
					max_baseroles = nil
				end
			end
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
