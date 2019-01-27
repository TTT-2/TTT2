-- Define GM12 fonts for compatibility

local math = math
local net = net
local player = player
local pairs = pairs
local ipairs = ipairs
local timer = timer
local util = util
local IsValid = IsValid
local surface = surface
local CreateConVar = CreateConVar
local hook = hook

surface.CreateFont("DefaultBold", {font = "Tahoma", size = 13, weight = 1000})
surface.CreateFont("TabLarge", {font = "Tahoma", size = 13, weight = 700, shadow = true, antialias = false})
surface.CreateFont("Trebuchet22", {font = "Trebuchet MS", size = 22, weight = 900})

ttt_include("shared")

include("sh_item_module.lua")

ttt_include("sh_init")
ttt_include("sh_shopeditor")
ttt_include("scoring_shd")
ttt_include("corpse_shd")
ttt_include("player_ext_shd")
ttt_include("weaponry_shd")

ttt_include("vgui__coloredbox")
ttt_include("vgui__droleimage")
ttt_include("vgui__simpleicon")
ttt_include("vgui__simpleclickicon")
ttt_include("vgui__progressbar")
ttt_include("vgui__scrolllabel")

ttt_include("cl_radio")
ttt_include("cl_transfer")
ttt_include("cl_targetid")
ttt_include("cl_search")
ttt_include("cl_tbuttons")
ttt_include("cl_scoreboard")
ttt_include("cl_tips")
ttt_include("cl_help")
ttt_include("cl_hud")
ttt_include("cl_msgstack")
ttt_include("cl_hudpickup")
ttt_include("cl_keys")
ttt_include("cl_wepswitch")
ttt_include("cl_scoring")
ttt_include("cl_scoring_events")
ttt_include("cl_popups")
ttt_include("cl_equip")
ttt_include("cl_shopeditor")
ttt_include("cl_chat")
ttt_include("cl_voice")
ttt_include("cl_changes")
ttt_include("cl_credits")

function GM:Initialize()
	MsgN("TTT2 Client initializing...")

	hook.Run("TTT2Initialize")

	GAMEMODE.round_state = ROUND_WAIT

	LANG.Init()

	self.BaseClass:Initialize()

	hook.Run("TTT2FinishedLoading")

	hook.Run("PostInitialize")
end

function GM:InitPostEntity()
	MsgN("TTT Client post-init...")

	hook.Run("TTTInitPostEntity")

	InitDefaultEquipment()

	local itms = items.GetList()

	-- initialize the default data
	for _, eq in ipairs(itms) do
		ShopEditor.InitDefaultData(eq)
	end

	-- init items
	for _, eq in ipairs(itms) do
		CreateEquipment(eq)
	end

	-- reset normal items equipment
	for _, eq in ipairs(itms) do
		eq.CanBuy = {}
	end

	local sweps = weapons.GetList()

	-- init normal weapons equipment
	for _, wep in ipairs(sweps) do
		ShopEditor.InitDefaultData(wep)
	end

	-- init weapons
	for _, wep in ipairs(sweps) do
		CreateEquipment(wep)
	end

	-- reset normal weapons equipment
	for _, wep in ipairs(sweps) do
		wep.CanBuy = {}
	end

	-- reset normal equipment tables
	for _, role in pairs(GetRoles()) do
		if Equipment then
			Equipment[role.index] = {}
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
		GAMEMODE:ClearClientState()
	end

	timer.Create("cache_ents", 1, 0, GAMEMODE.DoCacheEnts)

	RunConsoleCommand("_ttt_request_serverlang")
	RunConsoleCommand("_ttt_request_rolelist")
end

function GM:DoCacheEnts()
	RADAR:CacheEnts()
	TBHUD:CacheEnts()
end

function GM:HUDClear()
	RADAR:Clear()
	TBHUD:Clear()
end

KARMA = {}

function KARMA.IsEnabled()
	return GetGlobalBool("ttt_karma", false)
end

function GetRoundState()
	return GAMEMODE.round_state
end

local function RoundStateChange(o, n)
	if n == ROUND_PREP then
		-- prep starts
		GAMEMODE:ClearClientState()
		GAMEMODE:CleanUpMap()

		-- show warning to spec mode players
		if GetConVar("ttt_spectator_mode"):GetBool() and IsValid(LocalPlayer()) then
			LANG.Msg("spec_mode_warning")
		end

		-- reset cached server language in case it has changed
		RunConsoleCommand("_ttt_request_serverlang")
	elseif n == ROUND_ACTIVE then
		-- round starts
		VOICE.CycleMuteState(MUTE_NONE)

		CLSCORE:ClearPanel()

		-- people may have died and been searched during prep
		for _, p in ipairs(player.GetAll()) do
			p.search_result = nil
		end

		-- clear blood decals produced during prep
		RunConsoleCommand("r_cleardecals")

		GAMEMODE.StartingPlayers = #util.GetAlivePlayers()
	elseif n == ROUND_POST then
		RunConsoleCommand("ttt_cl_traitorpopup_close")
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
	for _, v in ipairs(player.GetAll()) do
		for _, team in ipairs(GetWinTeams()) do
			v[team .. "_gvoice"] = false
		end
	end
end

local function ttt_print_playercount()
	print(GAMEMODE.StartingPlayers)
end
concommand.Add("ttt_print_playercount", ttt_print_playercount)

--- optional sound cues on round start and end
CreateConVar("ttt_cl_soundcues", "0", FCVAR_ARCHIVE)

local cues = {
	Sound("ttt/thump01e.mp3"),
	Sound("ttt/thump02e.mp3")
}

local function PlaySoundCue()
	if GetConVar("ttt_cl_soundcues"):GetBool() then
		surface.PlaySound(cues[math.random(1, #cues)])
	end
end

GM.TTTBeginRound = PlaySoundCue
GM.TTTEndRound = PlaySoundCue

--- usermessages

local function ReceiveRole()
	local client = LocalPlayer()
	local subrole = net.ReadUInt(ROLE_BITS)
	local team = net.ReadString()

	-- after a mapswitch, server might have sent us this before we are even done
	-- loading our code
	if not client.SetRole then return end

	client:SetRole(subrole, team)

	Msg("You are: ")
	MsgN(string.upper(GetRoleByIndex(subrole).name))
end
net.Receive("TTT_Role", ReceiveRole)

local function ReceiveRoleReset()
	for _, ply in ipairs(player.GetAll()) do
		ply:SetRole(ROLE_INNOCENT, TEAM_INNOCENT)
	end
end
net.Receive("TTT_RoleReset", ReceiveRoleReset)

--- role test
local function TTT2TestRole()
	local client = LocalPlayer()

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

-- Cleanup at start of new round
function GM:ClearClientState()
	GAMEMODE:HUDClear()

	local client = LocalPlayer()
	if not client.SetRole then return end -- code not loaded yet

	client:SetRole(ROLE_INNOCENT)

	client.equipmentItems = {}
	client.equipment_credits = 0
	client.bought = {}
	client.last_id = nil
	client.radio = nil
	client.called_corpses = {}

	VOICE.InitBattery()

	for _, p in ipairs(player.GetAll()) do
		if IsValid(p) then
			p.sb_tag = nil

			p:SetRole(ROLE_INNOCENT)

			p.search_result = nil
		end
	end

	VOICE.CycleMuteState(MUTE_NONE)

	RunConsoleCommand("ttt_mute_team_check", "0")

	if GAMEMODE.ForcedMouse then
		gui.EnableScreenClicker(false)
	end
end
net.Receive("TTT_ClearClientState", GM.ClearClientState)

function GM:CleanUpMap()
	-- Ragdolls sometimes stay around on clients. Deleting them can create issues
	-- so all we can do is try to hide them.
	for _, ent in ipairs(ents.FindByClass("prop_ragdoll")) do
		if IsValid(ent) and CORPSE.GetPlayerNick(ent, "") ~= "" then
			ent:SetNoDraw(true)
			ent:SetSolid(SOLID_NONE)
			ent:SetColor(Color(0, 0, 0, 0))

			-- Horrible hack to make targetid ignore this ent, because we can't
			-- modify the collision group clientside.
			ent.NoTarget = true
		end
	end

	-- This cleans up decals since GMod v100
	game.CleanUpMap()
end

net.Receive("TTT2SyncDBItems", function()
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
	TIPS.Show()
end
net.Receive("TTT_PlayerDied", PlayerDeath)

function GM:ShouldDrawLocalPlayer(ply)
	return false
end

local view = {origin = vector_origin, angles = angle_zero, fov = 0}

function GM:CalcView(ply, origin, angles, fov)
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

function GM:AddDeathNotice()

end

function GM:DrawDeathNotice()

end

function GM:Tick()
	local client = LocalPlayer()

	if IsValid(client) then
		if client:Alive() and client:Team() ~= TEAM_SPEC then
			WSWITCH:Think()
			RADIO:StoreTarget()
		end

		VOICE.Tick()
	end
end

-- Simple client-based idle checking
local idle = {ang = nil, pos = nil, mx = 0, my = 0, t = 0}

function CheckIdle()
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
			RunConsoleCommand("say", "(AUTOMATED MESSAGE) I have been moved to the Spectator team because I was idle/AFK.")

			timer.Simple(0.3, function()
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
