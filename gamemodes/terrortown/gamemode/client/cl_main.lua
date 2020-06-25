---
-- The main file. Some GAMEMODE hooks and internal @{function}s

local math = math
local net = net
local player = player
local timer = timer
local util = util
local IsValid = IsValid
local surface = surface
local CreateConVar = CreateConVar
local hook = hook

-- Define GM12 fonts for compatibility
surface.CreateFont("DefaultBold", {font = "Tahoma", size = 13, weight = 1000})
surface.CreateFont("TabLarge", {font = "Tahoma", size = 13, weight = 700, shadow = true, antialias = false})
surface.CreateFont("Trebuchet22", {font = "Trebuchet MS", size = 22, weight = 900})

ttt_include("cl_fonts")

ttt_include("sh_init")

ttt_include("sh_cvar_handler")

ttt_include("sh_network_sync")
ttt_include("sh_sprint")
ttt_include("sh_main")
ttt_include("sh_shopeditor")
ttt_include("sh_scoring")
ttt_include("sh_corpse")
ttt_include("sh_player_ext")
ttt_include("sh_weaponry")
ttt_include("sh_inventory")
ttt_include("sh_door")
ttt_include("sh_voice")
ttt_include("sh_printmessage_override")
ttt_include("sh_speed")

ttt_include("vgui__cl_coloredbox")
ttt_include("vgui__cl_droleimage")
ttt_include("vgui__cl_simpleroleicon")
ttt_include("vgui__cl_simpleicon")
ttt_include("vgui__cl_simpleclickicon")
ttt_include("vgui__cl_progressbar")
ttt_include("vgui__cl_scrolllabel")

ttt_include("cl_network_sync")
ttt_include("cl_hud_editor")
ttt_include("cl_hud_manager")
ttt_include("cl_karma")
ttt_include("cl_tradio")
ttt_include("cl_transfer")
ttt_include("cl_reroll")
ttt_include("cl_targetid")
ttt_include("cl_target_data")
ttt_include("cl_search")
ttt_include("cl_tbuttons")
ttt_include("cl_scoreboard")
ttt_include("cl_tips")
ttt_include("cl_help")
ttt_include("cl_msgstack")
ttt_include("cl_eventpopup")
ttt_include("cl_hudpickup")
ttt_include("cl_keys")
ttt_include("cl_wepswitch")
ttt_include("cl_scoring")
ttt_include("cl_scoring_events")
ttt_include("cl_popups")
ttt_include("cl_equip")
ttt_include("cl_shopeditor")
ttt_include("cl_chat")
ttt_include("cl_radio")
ttt_include("cl_voice")
ttt_include("cl_changes")
ttt_include("cl_inventory")
ttt_include("cl_status")
ttt_include("cl_player_ext")

ttt_include("cl_armor")
ttt_include("cl_damage_indicator")
ttt_include("sh_armor")
ttt_include("cl_weapon_pickup")

-- all files are loaded
local TryT = LANG.TryTranslation

-- optional sound cues on round start and end
local ttt_cl_soundcues = CreateConVar("ttt_cl_soundcues", "0", FCVAR_ARCHIVE)

local cues = {
	Sound("ttt/thump01e.mp3"),
	Sound("ttt/thump02e.mp3")
}

local function PlaySoundCue()
	if not ttt_cl_soundcues:GetBool() then return end

	surface.PlaySound(cues[math.random(#cues)])
end

---
-- Called after the gamemode loads and starts.
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:Initialize
-- @local
function GM:Initialize()
	MsgN("TTT2 Client initializing...")

	hook.Run("TTT2Initialize")

	self.round_state = ROUND_WAIT
	self.roundCount = 0

	-- load addon language files
	LANG.SetupFiles("lang/", true)

	LANG.Init()

	self.BaseClass:Initialize()

	ARMOR:Initialize()
	SPEED:Initialize()

	hook.Run("TTT2FinishedLoading")

	hook.Run("PostInitialize")
end

---
-- Called right after the map has cleaned up (usually because game.CleanUpMap was called)
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:PostCleanupMap
-- @local
function GM:PostCleanupMap()
	hook.Run("TTT2PostCleanupMap")
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
	MsgN("TTT Client post-init...")

	hook.Run("TTTInitPostEntity")

	items.MigrateLegacyItems()
	items.OnLoaded()

	HUDManager.LoadAllHUDS()
	HUDManager.SetHUD()

	InitDefaultEquipment()

	local itms = items.GetList()

	-- load items
	for i = 1, #itms do
		local itm = itms[i]

		ShopEditor.InitDefaultData(itm) -- initialize the default data
		CreateEquipment(itm) -- init items

		itm.CanBuy = {} -- reset normal items equipment

		itm:Initialize()
	end

	local sweps = weapons.GetList()

	-- load sweps
	for i = 1, #sweps do
		local wep = sweps[i]

		ShopEditor.InitDefaultData(wep) -- init normal weapons equipment
		CreateEquipment(wep) -- init weapons

		wep.CanBuy = {} -- reset normal weapons equipment
	end

	-- TODO why should Equipment be nil?
	if istable(Equipment) then
		local roleList = roles.GetList()

		-- reset normal equipment tables
		for i = 1, #roleList do
			Equipment[roleList[i].index] = {}
		end
	end

	-- initialize fallback shops
	InitFallbackShops()

	hook.Run("PostInitPostEntity")

	hook.Run("InitFallbackShops")

	hook.Run("LoadedFallbackShops")

	net.Start("TTT2SyncShopsWithServer")
	net.SendToServer()

	net.Start("TTT_Spectate")
	net.WriteBool(GetConVar("ttt_spectator_mode"):GetBool())
	net.SendToServer()

	if not game.SinglePlayer() then
		timer.Create("idlecheck", 5, 0, CheckIdle)
	end

	local client = LocalPlayer()

	-- make sure player class extensions are loaded up, and then do some
	-- initialization on them
	if IsValid(client) and client.GetTraitor then
		self:ClearClientState()
	end

	-- cache players avatar
	local plys = player.GetAll()

	for i = 1, #plys do
		draw.CacheAvatar(plys[i]:SteamID64(), "medium") -- caching
	end

	timer.Create("cache_ents", 1, 0, function()
		self:DoCacheEnts()
	end)

	RunConsoleCommand("_ttt_request_serverlang")
	RunConsoleCommand("_ttt_request_rolelist")
end

---
-- Caches the @{RADAR} and @{TBHUD} @{Entity}
-- @note Called every second by the "cache_ents" timer
-- @hook
-- @realm client
function GM:DoCacheEnts()
	RADAR:CacheEnts()
	TBHUD:CacheEnts()
end

---
-- Clears the @{RADAR} and @{TBHUD} @{Entity}
-- @note Called by the @{GM:ClearClientState} hook
-- @hook
-- @realm client
function GM:HUDClear()
	RADAR:Clear()
	TBHUD:Clear()
end

---
-- Returns the current round state
-- @return boolean
-- @realm client
function GetRoundState()
	return GAMEMODE.round_state
end

local function RoundStateChange(o, n)
	local plys = player.GetAll()

	if n == ROUND_PREP then
		-- prep starts
		GAMEMODE:ClearClientState()
		GAMEMODE:CleanUpMap()

		EPOP:Clear()

		-- show warning to spec mode players
		if GetConVar("ttt_spectator_mode"):GetBool() and IsValid(LocalPlayer()) then
			LANG.Msg("spec_mode_warning", nil, MSG_CHAT_WARN)
		end

		-- reset cached server language in case it has changed
		RunConsoleCommand("_ttt_request_serverlang")

		GAMEMODE.roundCount = GAMEMODE.roundCount + 1

		-- clear decals in cache from previous round
		util.ClearDecals()
	elseif n == ROUND_ACTIVE then
		-- round starts
		VOICE.CycleMuteState(MUTE_NONE)

		CLSCORE:ClearPanel()

		-- people may have died and been searched during prep
		for i = 1, #plys do
			plys[i].search_result = nil
		end

		-- clear blood decals produced during prep
		util.ClearDecals()

		GAMEMODE.StartingPlayers = #util.GetAlivePlayers()

		PlaySoundCue()
	elseif n == ROUND_POST then
		RunConsoleCommand("ttt_cl_traitorpopup_close")

		PlaySoundCue()
	end

	-- stricter checks when we're talking about hooks, because this function may
	-- be called with for example o = WAIT and n = POST, for newly connecting
	-- players, which hooking code may not expect
	if n == ROUND_PREP then
		-- can enter PREP from any phase due to ttt_roundrestart
		hook.Call("TTTPrepareRound", GAMEMODE)
	elseif o == ROUND_PREP and n == ROUND_ACTIVE then
		hook.Call("TTTBeginRound", GAMEMODE)
	elseif o == ROUND_ACTIVE and n == ROUND_POST then
		hook.Call("TTTEndRound", GAMEMODE)
	end

	-- whatever round state we get, clear out the voice flags
	local winTeams = roles.GetWinTeams()

	for i = 1, #plys do
		local pl = plys[i]

		for k = 1, #winTeams do
			pl[winTeams[k] .. "_gvoice"] = false
		end
	end
end

local function ttt_print_playercount()
	print(GAMEMODE.StartingPlayers)
end
concommand.Add("ttt_print_playercount", ttt_print_playercount)

-- usermessages

local function ReceiveRole()
	local client = LocalPlayer()
	if not IsValid(client) then return end

	local subrole = net.ReadUInt(ROLE_BITS)
	local team = net.ReadString()

	-- after a mapswitch, server might have sent us this before we are even done
	-- loading our code
	if not isfunction(client.SetRole) then return end

	client:SetRole(subrole, team)

	Msg("You are: ")
	MsgN(string.upper(roles.GetByIndex(subrole).name))
end
net.Receive("TTT_Role", ReceiveRole)

local function ReceiveRoleReset()
	local plys = player.GetAll()

	for i = 1, #plys do
		plys[i]:SetRole(ROLE_INNOCENT, TEAM_INNOCENT)
	end
end
net.Receive("TTT_RoleReset", ReceiveRoleReset)

-- role test
local function TTT2TestRole()
	local client = LocalPlayer()
	if not IsValid(client) then return end

	client:ChatPrint("Your current role is: '" .. client:GetSubRoleData().name .. "'")
end
net.Receive("TTT2TestRole", TTT2TestRole)

local function ReceiveRoleList()
	local subrole = net.ReadUInt(ROLE_BITS)
	local team = net.ReadString()
	local num_ids = net.ReadUInt(8)

	for i = 1, num_ids do
		local eidx = net.ReadUInt(7) + 1 -- we - 1 worldspawn=0
		local ply = player.GetByID(eidx)

		if IsValid(ply) and ply.SetRole then
			ply:SetRole(subrole, team)

			local plyrd = ply:GetSubRoleData()

			if team ~= TEAM_NONE and not plyrd.unknownTeam and not plyrd.disabledTeamVoice and not TEAMS[team].alone then
				ply[team .. "_gvoice"] = false -- assume role's chat by default
			end
		end
	end
end
net.Receive("TTT_RoleList", ReceiveRoleList)

-- Round state comm
local function ReceiveRoundState()
	local o = GetRoundState()

	GAMEMODE.round_state = net.ReadUInt(3)

	if o ~= GAMEMODE.round_state then
		RoundStateChange(o, GAMEMODE.round_state)
	end

	MsgN("Round state: " .. GAMEMODE.round_state)
end
net.Receive("TTT_RoundState", ReceiveRoundState)

---
-- Cleanup at start of new round
-- @note Called if a new round begins (round state changes to <code>ROUND_PREP</code>)
-- @hook
-- @realm client
function GM:ClearClientState()
	self:HUDClear()

	local client = LocalPlayer()
	if not client.SetRole then return end -- code not loaded yet

	client:SetRole(ROLE_INNOCENT)

	client.equipmentItems = {}
	client.equipment_credits = 0
	client.bought = {}
	client.last_id = nil
	client.radio = nil
	client.called_corpses = {}
	client.sprintProgress = 1

	client:SetTargetPlayer(nil)

	VOICE.InitBattery()

	local plys = player.GetAll()

	for i = 1, #plys do
		local pl = plys[i]
		if not IsValid(pl) then continue end

		pl.sb_tag = nil

		pl:SetRole(ROLE_INNOCENT)

		pl.search_result = nil
	end

	VOICE.CycleMuteState(MUTE_NONE)

	RunConsoleCommand("ttt_mute_team_check", "0")

	if not self.ForcedMouse then return end

	gui.EnableScreenClicker(false)
end
net.Receive("TTT_ClearClientState", function()
	GAMEMODE:ClearClientState()
end)

local color_trans = Color(0, 0, 0, 0)

---
-- Cleanup the map at start of new round
-- @note Called if a new round begins (round state changes to <code>ROUND_PREP</code>)
-- @hook
-- @realm client
function GM:CleanUpMap()
	--remove thermal vision
	thermalvision.Clear()

	-- Ragdolls sometimes stay around on clients. Deleting them can create issues
	-- so all we can do is try to hide them.
	local ragdolls = ents.FindByClass("prop_ragdoll")

	for i = 1, #ragdolls do
		local ent = ragdolls[i]

		if not IsValid(ent) or CORPSE.GetPlayerNick(ent, "") == "" then continue end

		ent:SetNoDraw(true)
		ent:SetSolid(SOLID_NONE)
		ent:SetColor(color_trans)

		-- Horrible hack to make targetid ignore this ent, because we can't
		-- modify the collision group clientside.
		ent.NoTarget = true
	end

	game.CleanUpMap()
end

net.Receive("TTT2SyncDBItems", function()
	if not ShopEditor then return end

	ShopEditor.ReadItemData()
end)

-- server tells us to call this when our LocalPlayer has spawned
local function PlayerSpawn()
	local as_spec = net.ReadBit() == 1
	if as_spec then
		TIPS.Show()
	else
		TIPS.Hide()
	end

	-- TTT Totem prevention
	if LocalPlayer().GetRoleTable then
		print("[TTT2][ERROR] You have TTT Totem activated! You really should disable it!\n-- Disable it by unsubscribe it! --\nI know, that's not nice, but there's no way. It's an internally problem of GMod...")
	end
end
net.Receive("TTT_PlayerSpawned", PlayerSpawn)

local function PlayerDeath()
	if not TIPS then return end

	TIPS.Show()
end
net.Receive("TTT_PlayerDied", PlayerDeath)

---
-- Called to determine if the LocalPlayer should be drawn.
-- @note If you're using this hook to draw a @{Player} for a @{GM:CalcView} hook,
-- then you may want to consider using the drawviewer variable you can use in your
-- <a href="https://wiki.garrysmod.com/page/Structures/CamData">CamData structure</a>
-- table instead.
-- @important You should visit the linked reference, there could be related issues
-- @param Player ply The @{Player}
-- @return[default=false] boolean True to draw the @{Player}, false to hide
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:ShouldDrawLocalPlayer
-- @local
function GM:ShouldDrawLocalPlayer(ply)
	return false
end

local view = {origin = vector_origin, angles = angle_zero, fov = 0}

---
-- Allows override of the default view.
-- @param Player ply The local @{Player}
-- @param Vector origin The @{Player}'s view position
-- @param Angle angles The @{Player}'s view angles
-- @param number fov Field of view
-- @param number znear Distance to near clipping plane
-- @param number zfar Distance to far clipping plane
-- @return table View data table. See
-- <a href="https://wiki.garrysmod.com/page/Structures/CamData">CamData structure</a>
-- structure
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:CalcView
-- @local
function GM:CalcView(ply, origin, angles, fov, znear, zfar)
	view.origin = origin
	view.angles = angles
	view.fov = fov

	-- first person ragdolling
	if ply:Team() == TEAM_SPEC and ply:GetObserverMode() == OBS_MODE_IN_EYE then
		local tgt = ply:GetObserverTarget()

		if IsValid(tgt) and not tgt:IsPlayer() then
			-- assume if we are in_eye and not speccing a player, we spec a ragdoll
			local eyes = tgt:LookupAttachment("eyes") or 0
			eyes = tgt:GetAttachment(eyes)

			if eyes then
				view.origin = eyes.Pos
				view.angles = eyes.Ang
			end
		end
	end

	local wep = ply:GetActiveWeapon()

	if IsValid(wep) then
		local func = wep.CalcView
		if func then
			view.origin, view.angles, view.fov = func(wep, ply, origin * 1, angles * 1, fov)
		end
	end

	return view
end

---
-- Adds a death notice entry.
-- @param string attacker The name of the attacker
-- @param number attackerTeam The team of the attacker
-- @param string inflictor Class name of the @{Entity} inflicting the damage
-- @param string victim Name of the victim
-- @param string victimTeam Team of the victim
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:AddDeathNotice
-- @local
function GM:AddDeathNotice(attacker, attackerTeam, inflictor, victim, victimTeam)

end

---
-- This hook is called every frame to draw all of the current death notices.
-- @param number x X position to draw death notices as a ratio
-- @param number y Y position to draw death notices as a ratio
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:DrawDeathNotice
-- @local
function GM:DrawDeathNotice(x, y)

end

-- Simple client-based idle checking
local idle = {
	ang = nil,
	pos = nil,
	mx = 0,
	my = 0,
	t = 0
}

---
-- Checks whether a the local @{Player} is idle and handles everything on it's own
-- @note This is doing every 5 seconds by the "idlecheck" timer
-- @realm client
-- @internal
function CheckIdle()
	if not GetGlobalBool("ttt_idle", false) then return end

	local client = LocalPlayer()
	if not IsValid(client) then return end

	if not idle.ang or not idle.pos then
		-- init things
		idle.ang = client:GetAngles()
		idle.pos = client:GetPos()
		idle.mx = gui.MouseX()
		idle.my = gui.MouseY()
		idle.t = CurTime()

		return
	end

	if GetRoundState() == ROUND_ACTIVE and client:IsTerror() and client:Alive() then
		local idle_limit = GetGlobalInt("ttt_idle_limit", 300) or 300

		if idle_limit <= 0 then -- networking sucks sometimes
			idle_limit = 300
		end

		if client:GetAngles() ~= idle.ang then
			-- Normal players will move their viewing angles all the time
			idle.ang = client:GetAngles()
			idle.t = CurTime()
		elseif gui.MouseX() ~= idle.mx or gui.MouseY() ~= idle.my then
			-- Players in eg. the Help will move their mouse occasionally
			idle.mx = gui.MouseX()
			idle.my = gui.MouseY()
			idle.t = CurTime()
		elseif client:GetPos():Distance(idle.pos) > 10 then
			-- Even if players don't move their mouse, they might still walk
			idle.pos = client:GetPos()
			idle.t = CurTime()
		elseif CurTime() > idle.t + idle_limit then
			RunConsoleCommand("say", TryT("automoved_to_spec"))

			timer.Simple(0, function() -- move client into the spectator team in the next frame
				RunConsoleCommand("ttt_spectator_mode", 1)

				net.Start("TTT_Spectate")
				net.WriteBool(true)
				net.SendToServer()

				RunConsoleCommand("ttt_cl_idlepopup")
			end)
		elseif CurTime() > idle.t + idle_limit * 0.5 then
			-- will repeat
			LANG.Msg("idle_warning")
		end
	end
end

---
-- Called when the entity is created.
-- @note Some entities on initial map spawn are passed through this hook, and then removed in the same frame.
-- This is used by the engine to precache things like models and sounds, so always check their validity with @{IsValid}.
-- @warning Removing the created entity during this event can lead to unexpected problems.
-- Use <code>@{timer.Simple}( 0, .... )</code> to safely remove the entity.
-- @param Entity ent The @{Entity}
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:OnEntityCreated
-- @local
function GM:OnEntityCreated(ent)
	-- Make ragdolls look like the player that has died
	if ent:IsRagdoll() then
		local ply = CORPSE.GetPlayer(ent)

		if IsValid(ply) then
			-- Only copy any decals if this ragdoll was recently created
			if ent:GetCreationTime() > CurTime() - 1 then
				ent:SnatchModelInstance(ply)
			end

			-- Copy the color for the PlayerColor matproxy
			local playerColor = ply:GetPlayerColor()

			ent.GetPlayerColor = function()
				return playerColor
			end
		end
	end

	return self.BaseClass.OnEntityCreated(self, ent)
end

net.Receive("TTT2PlayerAuthedShared", function(len)
	local steamid64 = net.ReadString()
	local name = net.ReadString()

	hook.Run("TTT2PlayerAuthed", steamid64, name)
end)

hook.Add("TTT2PlayerAuthed", "TTT2CacheAvatar", function(steamid64, name)
	local ply = player.GetBySteamID64(steamid64)

	if not IsValid(ply) or ply:IsBot() then
		steamid64 = nil
	end

	draw.CacheAvatar(steamid64, "medium") -- caching

	hook.Run("TTT2PlayerAuthedCacheReady", steamid64, name)
end)
