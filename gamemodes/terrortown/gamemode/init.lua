---- Trouble in Terrorist Town

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_msgstack.lua")
AddCSLuaFile("cl_hudpickup.lua")
AddCSLuaFile("cl_keys.lua")
AddCSLuaFile("cl_wepswitch.lua")
AddCSLuaFile("cl_awards.lua")
AddCSLuaFile("cl_scoring_events.lua")
AddCSLuaFile("cl_scoring.lua")
AddCSLuaFile("cl_popups.lua")
AddCSLuaFile("cl_equip.lua")
AddCSLuaFile("cl_equip_main.lua")
AddCSLuaFile("cl_weaponshop.lua")
AddCSLuaFile("equip_items_shd.lua")
AddCSLuaFile("cl_help.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_tips.lua")
AddCSLuaFile("cl_voice.lua")
AddCSLuaFile("scoring_shd.lua")
AddCSLuaFile("util.lua")
AddCSLuaFile("lang_shd.lua")
AddCSLuaFile("corpse_shd.lua")
AddCSLuaFile("player_ext_shd.lua")
AddCSLuaFile("weaponry_shd.lua")
AddCSLuaFile("cl_radio.lua")
AddCSLuaFile("cl_radar.lua")
AddCSLuaFile("cl_tbuttons.lua")
AddCSLuaFile("cl_disguise.lua")
AddCSLuaFile("cl_transfer.lua")
AddCSLuaFile("cl_search.lua")
AddCSLuaFile("cl_targetid.lua")
AddCSLuaFile("vgui/coloredbox.lua")
AddCSLuaFile("vgui/simpleicon.lua")
AddCSLuaFile("vgui/simpleclickicon.lua")
AddCSLuaFile("vgui/progressbar.lua")
AddCSLuaFile("vgui/scrolllabel.lua")
AddCSLuaFile("vgui/sb_main.lua")
AddCSLuaFile("vgui/sb_row.lua")
AddCSLuaFile("vgui/sb_team.lua")
AddCSLuaFile("vgui/sb_info.lua")

include("shared.lua")

include("karma.lua")
include("entity.lua")
include("scoring_shd.lua")
include("radar.lua")
include("admin.lua")
include("traitor_state.lua")
include("propspec.lua")
include("weaponry.lua")
include("gamemsg.lua")
include("ent_replace.lua")
include("scoring.lua")
include("corpse.lua")
include("player_ext_shd.lua")
include("player_ext.lua")
include("player.lua")
include("weaponshop.lua")

local flag_all = {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
local flag_save = {FCVAR_NOTIFY, FCVAR_ARCHIVE}

CreateConVar("ttt_roundtime_minutes", "10", flag_save)
CreateConVar("ttt_preptime_seconds", "30", flag_save)
CreateConVar("ttt_posttime_seconds", "30", flag_save)
CreateConVar("ttt_firstpreptime", "60", flag_save)

local ttt_haste = CreateConVar("ttt_haste", "1", flag_save)
CreateConVar("ttt_haste_starting_minutes", "5", flag_save)
CreateConVar("ttt_haste_minutes_per_death", "0.5", flag_save)

CreateConVar("ttt_spawn_wave_interval", "0")

CreateConVar("ttt_traitor_pct", "0.4", flag_save)
CreateConVar("ttt_traitor_max", "32", flag_save)
CreateConVar("ttt_traitor_min_players", "1", flag_save)

CreateConVar("ttt_detective_pct", "0.13", flag_save)
CreateConVar("ttt_detective_max", "32", flag_save)
CreateConVar("ttt_detective_min_players", "8", flag_save)
CreateConVar("ttt_detective_karma_min", "600", flag_save)

-- Traitor credits
CreateConVar("ttt_credits_starting", "2", flag_save)
CreateConVar("ttt_credits_award_pct", "0.35", flag_save)
CreateConVar("ttt_credits_award_size", "1", flag_save)
CreateConVar("ttt_credits_award_repeat", "1", flag_save)
CreateConVar("ttt_credits_detectivekill", "1", flag_save)

CreateConVar("ttt_credits_alonebonus", "1", flag_save)

-- Detective credits
CreateConVar("ttt_det_credits_starting", "1", flag_save)
CreateConVar("ttt_det_credits_traitorkill", "0", flag_save)
CreateConVar("ttt_det_credits_traitordead", "1", flag_save)

CreateConVar("ttt_use_weapon_spawn_scripts", "1", flag_save)
CreateConVar("ttt_weapon_spawn_count", "0", flag_save)

CreateConVar("ttt_round_limit", "6", flag_all)
CreateConVar("ttt_time_limit_minutes", "75", flag_all)

CreateConVar("ttt_idle_limit", "180", flag_save)

CreateConVar("ttt_voice_drain", "0", flag_save)
CreateConVar("ttt_voice_drain_normal", "0.2", flag_save)
CreateConVar("ttt_voice_drain_admin", "0.05", flag_save)
CreateConVar("ttt_voice_drain_recharge", "0.05", flag_save)

CreateConVar("ttt_namechange_kick", "1", flag_save)
CreateConVar("ttt_namechange_bantime", "10")

local ttt_detective = CreateConVar("ttt_sherlock_mode", "1", flag_save)
local ttt_minply = CreateConVar("ttt_minimum_players", "2", flag_save)

-- respawn if dead in preparing time
CreateConVar("ttt2_prep_respawn", "0", flag_all)

-- debuggery
local ttt_dbgwin = CreateConVar("ttt_debug_preventwin", "0", flag_save)

-- Localize stuff we use often. It's like Lua go-faster stripes.
local math = math
local table = table
local net = net
local player = player
local timer = timer
local util = util

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
util.AddNetworkString("TTT_ConfirmUseTButton")
util.AddNetworkString("TTT_C4Config")
util.AddNetworkString("TTT_C4DisarmResult")
util.AddNetworkString("TTT_C4Warn")
util.AddNetworkString("TTT_ShowPrints")
util.AddNetworkString("TTT_ScanResult")
util.AddNetworkString("TTT_FlareScorch")
util.AddNetworkString("TTT_Radar")
util.AddNetworkString("TTT_Spectate")

util.AddNetworkString("TTT2_Test_role")

util.AddNetworkString("TTT2_SyncRolesList")
util.AddNetworkString("TTT2_SyncSingleRole")
util.AddNetworkString("TTT2_RolesListSynced")
util.AddNetworkString("TTT2_SyncShopsWithServer")

---- Round mechanics
function GM:Initialize()
	print("\n[TTT2][ROLE] Server is ready to receive new roles...\n")
	
	hook.Run("TTT2_PreRoleInit")
	
	hook.Run("TTT2_RoleInit")
	
	hook.Run("TTT2_PostRoleInit")
	
	SetupRoleGlobals()
	
	print()
	MsgN("Trouble In Terrorist Town gamemode initializing...")
	ShowVersion() 

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

	WaitForPlayers()

	if cvars.Number("sv_alltalk", 0) > 0 then
		ErrorNoHalt("TTT WARNING: sv_alltalk is enabled. Dead players will be able to talk to living players. TTT will now attempt to set sv_alltalk 0.\n")
		
		RunConsoleCommand("sv_alltalk", "0")
	end

	if not IsMounted("cstrike") then
		ErrorNoHalt("TTT WARNING: CS:S does not appear to be mounted by GMod. Things may break in strange ways. Server admin? Check the TTT readme for help.\n")
	end
	
	-- setup weapon ConVars and similar things
	for _, wep in ipairs(weapons.GetList()) do
		if not wep.Doublicated then
			RegisterNormalWeapon(wep)
		end
	end
	
	hook.Run("PostInitialize")
end

-- Used to do this in Initialize, but server cfg has not always run yet by that
-- point.
function GM:InitCvars()
	MsgN("TTT initializing convar settings...")

	-- Initialize game state that is synced with client
	SetGlobalInt("ttt_rounds_left", GetConVar("ttt_round_limit"):GetInt())
	
	GAMEMODE:SyncGlobals()
	
	KARMA.InitState()

	self.cvar_init = true
end

function GM:InitPostEntity()
	MsgN("TTT Client post-init...")
	
	InitDefaultEquipment()
	
	-- initialize all items
	InitAllItems()

	-- reset normal equipment tables
	for _, role in pairs(ROLES) do
		EquipmentItems[role.index] = {}
	end

	-- reset normal weapons equipment
	for _, wep in ipairs(weapons.GetList()) do
		local wepTbl = weapons.GetStored(wep.ClassName)
		if wepTbl then
			wepTbl.CanBuy = {}
		end
	end
	
	-- initialize fallback shops
	InitFallbackShops()
	
	-- initialize the equipment
	LoadShopsEquipment()
	
	WEPS.ForcePrecache()
	
	hook.Run("PostInitPostEntity")
	
	hook.Run("InitFallbackShops")
end

-- ConVar replication is broken in GMod, so we do this.
-- I don't like it any more than you do, dear reader.
function GM:SyncGlobals()
	SetGlobalBool("ttt_detective", ttt_detective:GetBool())
	SetGlobalBool("ttt_haste", ttt_haste:GetBool())
	SetGlobalInt("ttt_time_limit_minutes", GetConVar("ttt_time_limit_minutes"):GetInt())
	SetGlobalBool("ttt_highlight_admins", GetConVar("ttt_highlight_admins"):GetBool())
	SetGlobalBool("ttt_locational_voice", GetConVar("ttt_locational_voice"):GetBool())
	SetGlobalInt("ttt_idle_limit", GetConVar("ttt_idle_limit"):GetInt())

	SetGlobalBool("ttt_voice_drain", GetConVar("ttt_voice_drain"):GetBool())
	SetGlobalFloat("ttt_voice_drain_normal", GetConVar("ttt_voice_drain_normal"):GetFloat())
	SetGlobalFloat("ttt_voice_drain_admin", GetConVar("ttt_voice_drain_admin"):GetFloat())
	SetGlobalFloat("ttt_voice_drain_recharge", GetConVar("ttt_voice_drain_recharge"):GetFloat())
end

function LoadShopsEquipment()
	-- initialize shop equipment
	for _, roleData in pairs(ROLES) do
		local shopFallback = GetConVar("ttt_" .. roleData.abbr .. "_shop_fallback"):GetString()
		if shopFallback ~= SHOP_DISABLED then
			LoadSingleShopEquipment(roleData)
		end
	end
end

-- sync ROLES list
local function EncodeForStream(tbl)
	-- may want to filter out data later
	-- just serialize for now

	local result = util.TableToJSON(tbl)
	if not result then
		ErrorNoHalt("Round report event encoding failed!\n")
		
		return false
	else
		return result
	end
end

function UpdateRoleData(ply, first)
	print("[TTT2][ROLE] Sending new ROLES list to " .. ply:Nick() .. "...")
	
	local s = EncodeForStream(ROLES)
	if not s then return end

	-- divide into happy lil bits.
	-- this was necessary with user messages, now it's
	-- a just-in-case thing if a round somehow manages to be > 64K
	local cut = {}
	local max = 65499
	
	while #s ~= 0 do
		local bit = string.sub(s, 1, max - 1)
		
		table.insert(cut, bit)

		s = string.sub(s, max, -1)
	end

	local parts = #cut
	
	for k, bit in ipairs(cut) do
		net.Start("TTT2_SyncRolesList")
		net.WriteBool(first)
		net.WriteBit((k ~= parts)) -- continuation bit, 1 if there's more coming
		net.WriteString(bit)

		if ply then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
end

function UpdateSingleRoleData(roleData, ply)
	print("[TTT2][ROLE] Sending updated role '" .. roleData.name .. "' to " .. ply:Nick() .. "...")
	
	local s = EncodeForStream(roleData)
	if not s then return end

	-- divide into happy lil bits.
	-- this was necessary with user messages, now it's
	-- a just-in-case thing if a round somehow manages to be > 64K
	local cut = {}
	local max = 65500
	
	while #s ~= 0 do
		local bit = string.sub(s, 1, max - 1)
		
		table.insert(cut, bit)

		s = string.sub(s, max, -1)
	end

	local parts = #cut
	
	for k, bit in ipairs(cut) do
		net.Start("TTT2_SyncSingleRole")
		net.WriteBit((k ~= parts)) -- continuation bit, 1 if there's more coming
		net.WriteString(bit)

		if ply then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
end

-- TODO just run on server once! not for every client
net.Receive("TTT2_RolesListSynced", function(len, ply)
	local first = net.ReadBool()
	
	-- run serverside
	hook.Run("TTT2_PreFinishedSync", ply, first)
	
	hook.Run("TTT2_FinishedSync", ply, first)
	
	hook.Run("TTT2_PostFinishedSync", ply, first)
end)

function GM:PlayerAuthed(ply, steamid, uniqueid)
	UpdateRoleData(ply, true)
end

net.Receive("TTT2_SyncShopsWithServer", function(len, ply)
	SyncEquipment(ply)
end)

function SendRoundState(state, ply)
	net.Start("TTT_RoundState")
	net.WriteUInt(state, 3)
	
	return ply and net.Send(ply) or net.Broadcast()
end

-- Round state is encapsulated by set/get so that it can easily be changed to
-- eg. a networked var if this proves more convenient
function SetRoundState(state)
	GAMEMODE.round_state = state

	SCORE:RoundStateChange(state)

	SendRoundState(state)
end

function GetRoundState()
	return GAMEMODE.round_state
end

local function EnoughPlayers()
	local ready = 0
	
	-- only count truly available players, i.e. no forced specs
	for _, ply in ipairs(player.GetAll()) do
		if IsValid(ply) and ply:ShouldSpawn() then
			ready = ready + 1
		end
	end
	
	return ready >= ttt_minply:GetInt()
end

-- Used to be in Think/Tick, now in a timer
function WaitingForPlayersChecker()
	if GetRoundState() == ROUND_WAIT then
		if EnoughPlayers() then
			timer.Create("wait2prep", 1, 1, PrepareRound)

			timer.Stop("waitingforply")
		end
	end
end

-- Start waiting for players
function WaitForPlayers()
	SetRoundState(ROUND_WAIT)

	if not timer.Start("waitingforply") then
		timer.Create("waitingforply", 2, 0, WaitingForPlayersChecker)
	end
end

-- When a player initially spawns after mapload, everything is a bit strange
-- just making him spectator for some reason does not work right. Therefore,
-- we regularly check for these broken spectators while we wait for players
-- and immediately fix them.
function FixSpectators()
	for _, ply in ipairs(player.GetAll()) do
		if ply:IsSpec() and not ply:GetRagdollSpec() and ply:GetMoveType() < MOVETYPE_NOCLIP then
			ply:Spectate(OBS_MODE_ROAMING)
		end
	end
end

-- Used to be in think, now a timer
local function WinChecker()
	if GetRoundState() == ROUND_ACTIVE then
		if CurTime() > GetGlobalFloat("ttt_round_end", 0) then
			EndRound(WIN_TIMELIMIT)
		elseif not ttt_dbgwin:GetBool() then
			win = hook.Run("TTT2_PreWinChecker")
			
			if win and win ~= WIN_NONE then
				EndRound(win)
			end
			
			win = hook.Call("TTTCheckForWin", GAMEMODE)
			
			if win ~= WIN_NONE then
				EndRound(win)
			end
		end
	end
end

local function NameChangeKick()
	if not GetConVar("ttt_namechange_kick"):GetBool() then
		timer.Remove("namecheck")
		
		return
	end

	if GetRoundState() == ROUND_ACTIVE then
		for _, ply in ipairs(player.GetHumans()) do
			if ply.spawn_nick then
				if ply.has_spawned and ply.spawn_nick ~= ply:Nick() and not hook.Call("TTTNameChangeKick", GAMEMODE, ply) then
					local t = GetConVar("ttt_namechange_bantime"):GetInt()
					local msg = "Changed name during a round"
					
					if t > 0 then
						ply:KickBan(t, msg)
					else
						ply:Kick(msg)
					end
				end
			else
				ply.spawn_nick = ply:Nick()
			end
		end
	end
end

function StartNameChangeChecks()
	if not GetConVar("ttt_namechange_kick"):GetBool() then return end

	-- bring nicks up to date, may have been changed during prep/post
	for _, ply in ipairs(player.GetAll()) do
		ply.spawn_nick = ply:Nick()
	end

	if not timer.Exists("namecheck") then
		timer.Create("namecheck", 3, 0, NameChangeKick)
	end
end

function StartWinChecks()
	if not timer.Start("winchecker") then
		timer.Create("winchecker", 1, 0, WinChecker)
	end
end

function StopWinChecks()
	timer.Stop("winchecker")
end

local function CleanUp()
	local et = ents.TTT
	
	-- if we are going to import entities, it's no use replacing HL2DM ones as
	-- soon as they spawn, because they'll be removed anyway
	et.SetReplaceChecking(not et.CanImportEntities(game.GetMap()))
	et.FixParentedPreCleanup()

	game.CleanUpMap()

	et.FixParentedPostCleanup()

	-- Strip players now, so that their weapons are not seen by ReplaceEntities
	for _, v in ipairs(player.GetAll()) do
		if IsValid(v) then
			v:StripWeapons()
			v:SetRole(ROLES.INNOCENT.index)
		end
	end

	-- a different kind of cleanup
	util.SafeRemoveHook("PlayerSay", "ULXMeCheck")
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

function GM:TTTDelayRoundStartForVote()
	-- Can be used for custom voting systems
	--return true, 30
	return false
end

function PrepareRound()
	for _, v in ipairs(player.GetAll()) do
		v:Give("weapon_zm_improvised")
		v:Give("weapon_zm_carry")
		v:Give("weapon_ttt_unarmed")
	end

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
	local ptime = GetConVar("ttt_preptime_seconds"):GetInt()
	
	if GAMEMODE.FirstRound then
		ptime = GetConVar("ttt_firstpreptime"):GetInt()
		
		GAMEMODE.FirstRound = false
	end

	-- Piggyback on "round end" time global var to show end of phase timer
	SetRoundEnd(CurTime() + ptime)

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

	-- Tell hooks and map we started prep
	hook.Call("TTTPrepareRound", GAMEMODE)

	ents.TTT.TriggerRoundStateOutputs(ROUND_PREP)
end

function SetRoundEnd(endtime)
	SetGlobalFloat("ttt_round_end", endtime)
end

function IncRoundEnd(incr)
	SetRoundEnd(GetGlobalFloat("ttt_round_end", 0) + incr)
end

function TellTraitorsAboutTraitors()
	local traitornicks = {}
	
	hook.Run("TTT2_TellTraitors")
	
	for _, v in ipairs(player.GetAll()) do
		if v:HasTeamRole(TEAM_TRAITOR) then
			table.insert(traitornicks, v:Nick())
		end
	end

	-- This is ugly as hell, but it's kinda nice to filter out the names of the
	-- traitors themselves in the messages to them
	local traitornicks_min = #traitornicks < 2
	
	for _, v in ipairs(player.GetAll()) do
		if v:HasTeamRole(TEAM_TRAITOR) then
			if traitornicks_min then
				LANG.Msg(v, "round_traitors_one")
				
				return
			else
				local names = ""
				
				for _, name in ipairs(traitornicks) do
					if name ~= v:Nick() then
						names = names .. name .. ", "
					end
				end
				
				names = string.sub(names, 1, -3)
				
				LANG.Msg(v, "round_traitors_more", {names = names})
			end
		end
	end
end

function SpawnWillingPlayers(dead_only)
	local plys = player.GetAll()
	local wave_delay = GetConVar("ttt_spawn_wave_interval"):GetFloat()

	-- simple method, should make this a case of the other method once that has
	-- been tested.
	if wave_delay <= 0 or dead_only then
		for _, ply in ipairs(player.GetAll()) do
			if IsValid(ply) then
				ply:SpawnForRound(dead_only)
			end
		end
	else
		-- wave method
		local num_spawns = #GetSpawnEnts()

		local to_spawn = {}
		
		for _, ply in RandomPairs(plys) do
			if IsValid(ply) and ply:ShouldSpawn() then
				table.insert(to_spawn, ply)
				
				GAMEMODE:PlayerSpawnAsSpectator(ply)
			end
		end

		local sfn = function()
			local c = 0
			-- fill the available spawnpoints with players that need
			-- spawning
			while c < num_spawns and #to_spawn > 0 do
				for k, ply in ipairs(to_spawn) do
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
					if c >= num_spawns then
						break
					end
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
	local endtime = CurTime() + (GetConVar("ttt_roundtime_minutes"):GetInt() * 60)
	
	if HasteMode() then
		endtime = CurTime() + (GetConVar("ttt_haste_starting_minutes"):GetInt() * 60)
		-- this is a "fake" time shown to innocents, showing the end time if no
		-- one would have been killed, it has no gameplay effect
		SetGlobalFloat("ttt_haste_end", endtime)
	end

	SetRoundEnd(endtime)
end

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
	SelectRoles()
	LANG.Msg("round_selected")
	SendFullStateUpdate()

	-- Edge case where a player joins just as the round starts and is picked as
	-- traitor, but for whatever reason does not get the traitor state msg. So
	-- re-send after a second just to make sure everyone is getting it.
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

	hook.Call("TTTBeginRound", GAMEMODE)

	ents.TTT.TriggerRoundStateOutputs(ROUND_BEGIN)
end

function PrintResultMessage(type)
	ServerLog("Round ended.\n")
	
	if type == WIN_TIMELIMIT then
		LANG.Msg("win_time")
		ServerLog("Result: timelimit reached, traitors lose.\n")
	elseif type == WIN_NONE then
		LANG.Msg("win_bees")
		ServerLog("Result: The Bees win (Its a Draw).\n")
	elseif type > WIN_NONE then
		local roleData = GetRoleByIndex(type)

		LANG.Msg("win_" .. roleData.team)
		ServerLog("Result: " .. roleData.name .. "s win.\n")
	else
		ServerLog("Result: unknown victory condition!\n")
	end
end

function CheckForMapSwitch()
	-- Check for mapswitch
	local rounds_left = math.max(0, GetGlobalInt("ttt_rounds_left", 6) - 1)

	SetGlobalInt("ttt_rounds_left", rounds_left)
	
	local time_left = math.max(0, (GetConVar("ttt_time_limit_minutes"):GetInt() * 60) - CurTime())
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

function EndRound(type)
	PrintResultMessage(type)

	-- first handle round end
	SetRoundState(ROUND_POST)

	local ptime = math.max(5, GetConVar("ttt_posttime_seconds"):GetInt())
	
	LANG.Msg("win_showreport", {num = ptime})
	timer.Create("end2prep", ptime, 1, PrepareRound)

	-- Piggyback on "round end" time global var to show end of phase timer
	SetRoundEnd(CurTime() + ptime)

	timer.Create("restartmute", ptime - 1, 1, function() 
		MuteForRestart(true) 
	end)

	-- Stop checking for wins
	StopWinChecks()
	
	-- send each client the role setup
	for _, v in pairs(ROLES) do
		SendRoleList(v.index, player.GetAll())
	end

	-- We may need to start a timer for a mapswitch, or start a vote
	CheckForMapSwitch()

	KARMA.RoundEnd()

	-- now handle potentially error prone scoring stuff

	-- register an end of round event
	SCORE:RoundComplete(type)

	-- update player scores
	SCORE:ApplyEventLogScores(type)

	-- send the clients the round log, players will be shown the report
	SCORE:StreamToClients()

	-- server plugins might want to start a map vote here or something
	-- these hooks are not used by TTT internally
	-- possible incompatibility for other addons
	hook.Call("TTTEndRound", GAMEMODE, type)

	ents.TTT.TriggerRoundStateOutputs(ROUND_POST, type)
end

function GM:MapTriggeredEnd(wintype)
	if wintype > WIN_NONE then
		self.MapWin = wintype
	else
		-- print alert and hint for contact
		print("\n\nCalled hook 'GM:MapTriggeredEnd' with incorrect wintype\n\n")
	end
end

-- The most basic win check is whether both sides have one dude alive
function GM:TTTCheckForWin()
	ttt_dbgwin = ttt_dbgwin or CreateConVar("ttt_debug_preventwin", "0", flag_save)

	if ttt_dbgwin:GetBool() then 
		return WIN_NONE
	end

	if GAMEMODE.MapWin > WIN_NONE then -- a role wins
		local mw = GAMEMODE.MapWin
		
		GAMEMODE.MapWin = WIN_NONE
		
		return mw
	end
	
	local alive = {}
	local team = {}
	
	-- initialize this is not necessary TODO
	for _, v in pairs(ROLES) do
		if not table.HasValue(team, v.team) then
			if v.team then
				table.insert(team, v.team)
			end
			
			alive[v.index] = false
		end
	end
	
	local b = 0
	local checkedTeams = {}
	--local innoTeam = GetWinningRole(TEAM_INNO).index
	
	for _, v in ipairs(player.GetAll()) do
		if v:IsTerror() then
			local roleData = GetRoleByIndex(v:GetRole())
			local i = roleData.index
			
			if roleData.team then
				i = GetWinningRole(roleData.team).index
			end
			
			alive[i] = true
		end
	end
	
	hook.Run("TTT2_ModifyWinningAlives", alive)

	for _, v in pairs(GetWinRoles()) do
		local i = v.index
	
		if not table.HasValue(checkedTeams, i) and alive[i] then
			-- if innos not alive but traitor, they will win
			-- BUT there are too many traitors and in worst case there wont be an inno because of custom roles of other teams
			--[[
			if v.team == TEAM_TRAITOR and not alive[innoTeam] then
				return i -- aim of the game is that traitors kill all innos
			end
			]]--
			
			-- prevent win of custom role -> maybe own win conditions
			if not v.preventWin then
				b = b + 1
				
				-- irrelevant whether function inserts value properly...
				table.insert(checkedTeams, i)
			end
		end
		
		-- if 2 teams alive
		if b == 2 then
			break
		end
	end
	
	-- if 2 teams alive: no one wins
	if b > 1 then
		return WIN_NONE -- early out
	end
	
	if b == 0 then
		--return WIN_NONE
		return WIN_TRAITOR
	elseif b == 1 then
		return checkedTeams[1]
	end
end

local function GetEachRoleCount(ply_count, role_type)
	if role_type == ROLES.INNOCENT.name then 
		return 0 
	end

	if ply_count < GetConVar("ttt_" .. role_type .. "_min_players"):GetInt() then 
		return 0 
	end

	-- get number of role members: pct of players rounded down
	local role_count = math.floor(ply_count * GetConVar("ttt_" .. role_type .. "_pct"):GetFloat())
	
	local maxm = 1
	
	if ConVarExists("ttt_" .. role_type .. "_max") then
		maxm = GetConVar("ttt_" .. role_type .. "_max"):GetInt()
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
 
function SelectRoles()
	local choices = {}
	local prev_roles = {}

	for _, v in pairs(ROLES) do
		if not v.notSelectable then
			prev_roles[v.index] = {}
		end
	end

	if not GAMEMODE.LastRole then GAMEMODE.LastRole = {} end

	for _, v in ipairs(player.GetAll()) do
		-- everyone on the spec team is in specmode
		if IsValid(v) and not v:IsSpec() then
			-- save previous role and sign up as possible traitor/detective
			local r = GAMEMODE.LastRole[v:SteamID()] or v:GetRole() or ROLES.INNOCENT.index

			table.insert(prev_roles[r], v)
			table.insert(choices, v)
		end

		v:SetRole(ROLES.INNOCENT.index)
	end

	-- determine how many of each role we want
	local choice_count = #choices
	local traitor_count = GetEachRoleCount(choice_count, ROLES.TRAITOR.name)

	if choice_count == 0 then return end
	
	local choices_copy = table.Copy(choices)
	local prev_roles_copy = table.Copy(prev_roles)
	
	hook.Call("TTTSelectRoles", GAMEMODE, choices_copy, prev_roles_copy)
	
	local traitorList = {}
	
	-- first select traitors
	local ts = 0
	while ts < traitor_count do
		-- select random index in choices table
		local pick = math.random(1, #choices)

		-- the player we consider
		local pply = choices[pick]

		-- make this guy traitor if he was not a traitor last time, or if he makes
		-- a roll
		-- TODO why 30 percent chance to get traitor ? add traitor_pct CONVAR ! maybe not fair split !
		if IsValid(pply) and (not table.HasValue(prev_roles[ROLES.TRAITOR.index], pply) or math.random(1, 3) == 2) then
			pply:SetRole(ROLES.TRAITOR.index)

			table.remove(choices, pick)
			table.insert(traitorList, pply)
			
			ts = ts + 1
		end
	end
	
	if GetConVar("ttt_newroles_enabled"):GetBool() then
	
		-- now upgrade traitors if there are other traitor roles
		local roleCount = {}
		local availableRoles = {}
		
		for _, v in pairs(ROLES) do
			if not v.notSelectable and v.team == TEAM_TRAITOR and v ~= ROLES.TRAITOR and GetConVar("ttt_" .. v.name .. "_enabled"):GetBool() then
				local b = true
				local r = (ConVarExists("ttt_" .. v.name .. "_random") and GetConVar("ttt_" .. v.name .. "_random"):GetInt() or 0)
				
				if r > 0 and r < 100 then
					b = math.random(1, 100) <= r
				end
				
				if b then
					local tmp = GetEachRoleCount(choice_count, v.name)
					
					if tmp > 0 then
						roleCount[v.index] = tmp
						
						table.insert(availableRoles, v)
					end
				end
			end
		end
		
		SetRoleTypes(traitorList, prev_roles, roleCount, availableRoles)
	end

	-- now select detectives, explicitly choosing from players who did not get
	-- traitor, so becoming detective does not mean you lost a chance to be
	-- traitor
	local roleCount = {}
	local availableRoles = {}
	local newRolesEnabled = GetConVar("ttt_newroles_enabled"):GetBool()
	
	for _, v in pairs(ROLES) do
		if not v.notSelectable and (v == ROLES.DETECTIVE or newRolesEnabled) then
			if v ~= ROLES.INNOCENT and v.team ~= TEAM_TRAITOR and GetConVar("ttt_" .. v.name .. "_enabled"):GetBool() then
				local b = true
				local r = (ConVarExists("ttt_" .. v.name .. "_random") and GetConVar("ttt_" .. v.name .. "_random"):GetInt() or 0)
				
				if r > 0 and r < 100 then
					b = math.random(1, 100) <= r
				end
				
				if b then
					local tmp = GetEachRoleCount(choice_count, v.name)
					
					if tmp > 0 then
						roleCount[v.index] = tmp
						
						table.insert(availableRoles, v)
					end
				end
			end
		end
	end
	
	SetRoleTypes(choices, prev_roles, roleCount, availableRoles)

	GAMEMODE.LastRole = {}

	for _, ply in ipairs(player.GetAll()) do
		-- initialize credit count for everyone based on their role
		ply:SetDefaultCredits()

		-- store a steamid -> role map
		GAMEMODE.LastRole[ply:SteamID()] = ply:GetRole()
		
		ply:UpdateRole(ply:GetRole()) -- just for some hooks and other special things
		
		SendFullStateUpdate() -- theoretically not needed
	end
end

function SetRoleTypes(choices, prev_roles, roleCount, availableRoles)
	local choices_i = #choices
	
	while choices_i > 0 and #availableRoles > 0 do
		local vpick = math.random(1, #availableRoles)
		local v = availableRoles[vpick]
		
		local type_count = roleCount[v.index]
		
		local pick = math.random(1, choices_i)
		local pply = choices[pick]
		
		local min_karmas = 0
		
		if ConVarExists("ttt_" .. v.name .. "_karma_min") then
			min_karmas = GetConVar("ttt_" .. v.name .. "_karma_min"):GetInt() or 0
		end
		
		-- if player was last round innocent, he will be another role (if he has enough karma)
		if IsValid(pply) and (
			choices_i <= type_count
			or pply:GetBaseKarma() > min_karmas and table.HasValue(prev_roles[ROLES.INNOCENT.index], pply)
			or math.random(1, 3) == 2
		) then
		
			-- if a player has specified he does not want to be detective, we skip
			-- him here (he might still get it if we don't have enough
			-- alternatives
			-- TODO improve that first the player get checked whether he could get ANOTHER special role (not disabled) instead just deleting him from list
			if choices_i <= type_count or not pply:GetAvoidRole(v.index) then
				pply:SetRole(v.index)
				
				table.remove(choices, pick)
				
				choices_i = choices_i - 1
				roleCount[v.index] = (type_count - 1)
			
				if roleCount[v.index] <= 0 then
					table.remove(availableRoles, vpick)
				end
			end
		end
	end
end

local function ForceRoundRestart(ply, command, args)
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
concommand.Add("ttt_roundrestart", ForceRoundRestart)

-- Version announce also used in Initialize
function ShowVersion(ply)
	local text = Format("This is [TTT2] Trouble in Terrorist Town 2 (Advanced Update) - by Alf21 (v%s)\n", GAMEMODE.Version)
	
	if IsValid(ply) then
		ply:PrintMessage(HUD_PRINTNOTIFY, text)
	else
		Msg(text)
	end
end
concommand.Add("ttt_version", ShowVersion)

function ToggleNewRoles(ply)
	if ply:IsAdmin() then
		local b = not GetConVar("ttt_newroles_enabled"):GetBool()
		
		RunConsoleCommand("ttt_newroles_enabled", b and "1" or "0")
		
		local word = "enabled"
		
		if not b then
			word = "disabled"
		end
		
		ply:PrintMessage(HUD_PRINTNOTIFY, "You " .. word .. " the new roles for TTT!")
	end
end
concommand.Add("ttt_toggle_newroles", ToggleNewRoles)
