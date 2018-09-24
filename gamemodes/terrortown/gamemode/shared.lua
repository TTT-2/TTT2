GM.Name = "[TTT2] Trouble in Terrorist Town 2 (Advanced Update) - by Alf21"
GM.Author = "Bad King Urgrain && Alf21"
GM.Email = "4lf-mueller@gmx.de"
GM.Website = "ttt.badking.net, ttt2.informaskill.de"
-- Date of latest changes (YYYY-MM-DD)
GM.Version = "0.2.6.2b"

GM.Customized = true

-- Round status consts
ROUND_WAIT = 1
ROUND_PREP = 2
ROUND_ACTIVE = 3
ROUND_POST = 4

-- equipment setups
INNO_EQUIPMENT = {
	"weapon_ttt_confgrenade",
	"weapon_ttt_m16",
	"weapon_ttt_smokegrenade",
	"weapon_ttt_unarmed",
	"weapon_ttt_wtester",
	"weapon_tttbase",
	"weapon_tttbasegrenade",
	"weapon_zm_carry",
	"weapon_zm_improvised",
	"weapon_zm_mac10",
	"weapon_zm_molotov",
	"weapon_zm_pistol",
	"weapon_zm_revolver",
	"weapon_zm_rifle",
	"weapon_zm_shotgun",
	"weapon_zm_sledge",
	"weapon_ttt_glock"
}

SPECIAL_EQUIPMENT = {
	"weapon_ttt_unarmed",
	"weapon_zm_carry",
	"weapon_zm_improvised",
	"weapon_ttt_binoculars",
	"weapon_ttt_defuser",
	"weapon_ttt_health_station",
	"weapon_ttt_stungun",
	"weapon_ttt_cse",
	"weapon_ttt_teleport",
	EQUIP_ARMOR,
	EQUIP_RADAR
}

TRAITOR_EQUIPMENT = {
	"weapon_ttt_unarmed",
	"weapon_zm_carry",
	"weapon_zm_improvised",
	"weapon_ttt_c4",
	"weapon_ttt_flaregun",
	"weapon_ttt_knife",
	"weapon_ttt_phammer",
	"weapon_ttt_push",
	"weapon_ttt_radio",
	"weapon_ttt_sipistol",
	"weapon_ttt_teleport",
	"weapon_ttt_decoy",
	EQUIP_ARMOR,
	EQUIP_RADAR,
	EQUIP_DISGUISE
}

-- role teams to have an indentifier
TEAM_INNO = "innocents"
TEAM_TRAITOR = "traitors"

-- max network bits to send roles numbers
ROLE_BITS = 5

-- ROLE_ARRAY
-- need to have a team to be able to win as well as to receive karma
-- IMPORTANT: If adding traitor roles: enable 'shop' !
-- just the following roles should be 'buildin' = true
ROLES = {}

ROLES.INNOCENT = {
	index = 0,
	color = Color(55, 170, 50, 255),
	dkcolor = Color(60, 160, 50, 155),
	bgcolor = Color(0, 50, 0, 200),
	name = "innocent",
	abbr = "inno",
	team = TEAM_INNO,
	defaultEquipment = INNO_EQUIPMENT,
	buildin = true,
	scoreKillsMultiplier = 1,
	scoreTeamKillsMultiplier = -8
}

ROLES.TRAITOR = {
	index = 1,
	color = Color(180, 50, 40, 255),
	dkcolor = Color(160, 50, 60, 155),
	bgcolor = Color(150, 0, 0, 200),
	name = "traitor",
	abbr = "traitor",
	team = TEAM_TRAITOR,
	defaultEquipment = TRAITOR_EQUIPMENT,
	visibleForTraitors = true, -- just for a better performance
	buildin = true,
	surviveBonus = 0.5,
	scoreKillsMultiplier = 5,
	scoreTeamKillsMultiplier = -16,
	fallbackTable = {}
}

ROLES.DETECTIVE = {
	index = 2,
	color = Color(50, 60, 180, 255),
	dkcolor = Color(50, 60, 160, 155),
	bgcolor = Color(0, 0, 150, 200),
	name = "detective",
	abbr = "det",
	team = TEAM_INNO,
	defaultEquipment = SPECIAL_EQUIPMENT,
	buildin = true,
	scoreKillsMultiplier = ROLES.INNOCENT.scoreKillsMultiplier,
	scoreTeamKillsMultiplier = ROLES.INNOCENT.scoreTeamKillsMultiplier,
	fallbackTable = {}
}

local flag_all = {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}

-- TODO: export into another file !
CreateConVar("ttt_detective_enabled", "1", flag_all)
CreateConVar("ttt_newroles_enabled", "1", flag_all)

SHOP_DISABLED = "DISABLED"
SHOP_UNSET = "UNSET"

-- shop fallbacks
CreateConVar("ttt_" .. ROLES.INNOCENT.abbr .. "_shop_fallback", SHOP_DISABLED, flag_all)
CreateConVar("ttt_" .. ROLES.TRAITOR.abbr .. "_shop_fallback", SHOP_UNSET, flag_all)
CreateConVar("ttt_" .. ROLES.DETECTIVE.abbr .. "_shop_fallback", SHOP_UNSET, flag_all)

-- you should only use this function to add roles to TTT2
function AddCustomRole(name, roleData, conVarData)
	conVarData = conVarData or {}

	if not ROLES[name] then
		-- shared
		if not roleData.notSelectable then
			if conVarData.togglable then
				CreateClientConVar("ttt_avoid_" .. roleData.name, "0", true, true)
			end

			CreateConVar("ttt_" .. roleData.name .. "_pct", tostring(conVarData.pct), flag_all)
			CreateConVar("ttt_" .. roleData.name .. "_max", tostring(conVarData.maximum), flag_all)
			CreateConVar("ttt_" .. roleData.name .. "_min_players", tostring(conVarData.minPlayers), flag_all)

			if conVarData.random then
				CreateConVar("ttt_" .. roleData.name .. "_random", tostring(conVarData.random), flag_all)
			else
				CreateConVar("ttt_" .. roleData.name .. "_random", "100", flag_all)
			end

			CreateConVar("ttt_" .. roleData.name .. "_enabled", "1", flag_all)
		end

		conVarData.credits = conVarData.credits or 0
		conVarData.creditsTraitorKill = conVarData.creditsTraitorKill or 0
		conVarData.creditsTraitorDead = conVarData.creditsTraitorDead or 0

		CreateConVar("ttt_" .. roleData.abbr .. "_credits_starting", tostring(conVarData.credits), flag_all)
		CreateConVar("ttt_" .. roleData.abbr .. "_credits_traitorkill", tostring(conVarData.creditsTraitorKill), flag_all)
		CreateConVar("ttt_" .. roleData.abbr .. "_credits_traitordead", tostring(conVarData.creditsTraitorDead), flag_all)

		local shopFallbackValue

		if not conVarData.shopFallback and roleData.fallbackTable then
			shopFallbackValue = SHOP_UNSET
		else
			shopFallbackValue = conVarData.shopFallback and tostring(conVarData.shopFallback) or SHOP_DISABLED
		end

		CreateConVar("ttt_" .. roleData.abbr .. "_shop_fallback", shopFallbackValue, flag_all)

		if conVarData.traitorKill then
			CreateConVar("ttt_credits_" .. roleData.name .. "kill", tostring(conVarData.traitorKill), flag_all)
		end

		-- client
		---- empty

		-- server
		if SERVER then
			-- necessary to init roles in this way, because we need to wait until the ROLES array is initialized
			-- and every important function works properly
			hook.Add("TTT2_RoleInit", "Add_" .. roleData.abbr .. "_Role", function() -- unique hook identifier please
				if not ROLES[name] then -- count ROLES
				local i = 1 -- start with "1" to prevent incompatibilities with ROLE_ANY

				for _, v in pairs(ROLES) do
					i = i + 1
				end

				roleData.index = i
				ROLES[name] = roleData

				-- update DefaultEquipment
				DefaultEquipment = GetDefaultEquipment()

				-- spend an answer
				print("[TTT2][ROLE] Added '" .. name .. "' Role (index: " .. i .. ")")
			end
		end)
	end
end
end

function UpdateCustomRole(name, roleData)
if SERVER and ROLES[name] then
	-- necessary for networking!
	roleData.name = ROLES[name].name

	table.Merge(ROLES[name], roleData)

	for _, v in ipairs(player.GetAll()) do
		UpdateSingleRoleData(roleData, v)
	end
end
end

function SetupRoleGlobals()
for _, v in pairs(ROLES) do
	_G["ROLE_" .. string.upper(v.name)] = v.index
	_G["WIN_" .. string.upper(v.name)] = v.index
end
end

-- if you add roles that can shop, modify DefaultEquipment at the end of this file
-- TODO combine DefaultEquipment[x] and ROLES[x] !

-- override default settings of ttt to make it compatible with other addons
-- Player roles
ROLE_INNOCENT = ROLES.INNOCENT.index
ROLE_TRAITOR = ROLES.TRAITOR.index
ROLE_DETECTIVE = ROLES.DETECTIVE.index
ROLE_NONE = ROLE_INNOCENT

SHOP_FALLBACK_TRAITOR = ROLES.TRAITOR.name
SHOP_FALLBACK_DETECTIVE = ROLES.DETECTIVE.name

function SortRolesTable(tbl)
table.sort(tbl, function(a, b)
	return a.index < b.index
end)
end

function GetRoleByIndex(index)
for _, v in pairs(ROLES) do
	if v.index == index then
		return v
	end
end

return ROLES.INNOCENT
end

function GetRoleByName(name)
for _, v in pairs(ROLES) do
	if v.name == name then
		return v
	end
end

return ROLES.INNOCENT
end

function GetRoleByAbbr(abbr)
for _, v in pairs(ROLES) do
	if v.abbr == abbr then
		return v
	end
end

return ROLES.INNOCENT
end

function GetStartingCredits(abbr)
if abbr == ROLES.TRAITOR.abbr then
	return GetConVar("ttt_credits_starting"):GetInt()
end

return ConVarExists("ttt_" .. abbr .. "_credits_starting") and GetConVar("ttt_" .. abbr .. "_credits_starting"):GetInt() or 0
end

function GetShopRoles()
local shopRoles = {}

local i = 0

for _, v in pairs(ROLES) do
	if v ~= ROLES.INNOCENT then
		local shopFallback = GetConVar("ttt_" .. v.abbr .. "_shop_fallback"):GetString()
		if shopFallback ~= SHOP_DISABLED then
			i = i + 1
			shopRoles[i] = v
		end
	end
end

SortRolesTable(shopRoles)

return shopRoles
end

function GetWinRoles()
local tmp = {}

for _, v in pairs(ROLES) do
	local winRole = GetTeamRoles(v.team)[1]

	if not table.HasValue(tmp, winRole) then
		table.insert(tmp, winRole)
	end
end

return tmp
end

function GetWinningRole(team)
for _, v in pairs(GetWinRoles()) do
	if v.team == team then
		return v
	end
end

return ROLES.INNOCENT
end

function GetTeamRoles(team)
local teamRoles = {}

local i = 0

for _, v in pairs(ROLES) do
	if v.team and v.team == team then
		i = i + 1
		teamRoles[i] = v
	end
end

SortRolesTable(teamRoles)

return teamRoles
end

function GetSortedRoles()
local roles = {}

local i = 0

for _, v in pairs(ROLES) do
	i = i + 1
	roles[i] = v
end

SortRolesTable(roles)

return roles
end

function GetWeaponNameByFileName(name)
for _, v in ipairs(weapons.GetList()) do
	if string.lower(v.ClassName) == name then
		return v.ClassName
	end
end
end

function table.Randomize(t)
local out = {}

while #t > 0 do
	table.insert(out, table.remove(t, math.random(#t)))
end

t = out
end

if CLIENT then
local SafeTranslate

function GetEquipmentTranslation(name, printName)
	SafeTranslate = SafeTranslate or LANG.TryTranslation

	local val = printName
	local str = SafeTranslate(val)
	if str == val and name then
		val = name
		str = SafeTranslate(val)
	end

	if str == val and printName then
		str = printName
	end

	return str
end

function SortEquipmentTable(tbl)
	--[[
		table.sort(tbl, function(a, b)
			return GetEquipmentTranslation(a.name, a.PrintName) < GetEquipmentTranslation(b.name, b.PrintName)
		end)
		]]--
	table.sort(tbl, function(adata, bdata)
		a = adata.id
		b = bdata.id

		if tonumber(a) and not tonumber(b) then
			return true
		elseif tonumber(b) and not tonumber(a) then
			return false
		else
			return a < b
		end
	end)
end
end

-- Game event log defs
EVENT_KILL = 1
EVENT_SPAWN = 2
EVENT_GAME = 3
EVENT_FINISH = 4
EVENT_SELECTED = 5
EVENT_BODYFOUND = 6
EVENT_C4PLANT = 7
EVENT_C4EXPLODE = 8
EVENT_CREDITFOUND = 9
EVENT_C4DISARM = 10

WIN_NONE = -1
WIN_TIMELIMIT = -2
WIN_INNOCENT = ROLE_INNOCENT
WIN_TRAITOR = ROLE_TRAITOR
WIN_DETECTIVE = ROLE_DETECTIVE

-- Weapon categories, you can only carry one of each
WEAPON_NONE = 0
WEAPON_MELEE = 1
WEAPON_PISTOL = 2
WEAPON_HEAVY = 3
WEAPON_NADE = 4
WEAPON_CARRY = 5
WEAPON_EQUIP1 = 6
WEAPON_EQUIP2 = 7
WEAPON_ROLE = 8

WEAPON_EQUIP = WEAPON_EQUIP1
WEAPON_UNARMED = -1

-- Kill types discerned by last words
KILL_NORMAL = 0
KILL_SUICIDE = 1
KILL_FALL = 2
KILL_BURN = 3

-- Entity types a crowbar might open
OPEN_NO = 0
OPEN_DOOR = 1
OPEN_ROT = 2
OPEN_BUT = 3
OPEN_NOTOGGLE = 4 -- movelinear

-- Mute types
MUTE_NONE = 0
MUTE_TERROR = 1
MUTE_ALL = 2
MUTE_SPEC = 1002

COLOR_WHITE = Color(255, 255, 255, 255)
COLOR_BLACK = Color(0, 0, 0, 255)
COLOR_GREEN = Color(0, 255, 0, 255)
COLOR_DGREEN = Color(0, 100, 0, 255)
COLOR_RED = Color(255, 0, 0, 255)
COLOR_YELLOW = Color(200, 200, 0, 255)
COLOR_LGRAY = Color(200, 200, 200, 255)
COLOR_BLUE = Color(0, 0, 255, 255)
COLOR_NAVY = Color(0, 0, 100, 255)
COLOR_PINK = Color(255, 0, 255, 255)
COLOR_ORANGE = Color(250, 100, 0, 255)
COLOR_OLIVE = Color(100, 100, 0, 255)

include("util.lua")
include("lang_shd.lua") -- uses some of util
include("equip_items_shd.lua")

function DetectiveMode()
return GetGlobalBool("ttt_detective", false)
end

function HasteMode()
return GetGlobalBool("ttt_haste", false)
end

-- Create teams
TEAM_TERROR = 1
TEAM_SPEC = TEAM_SPECTATOR

function GM:CreateTeams()
team.SetUp(TEAM_TERROR, "Terrorists", Color(0, 200, 0, 255), false)
team.SetUp(TEAM_SPEC, "Spectators", Color(200, 200, 0, 255), true)

-- Not that we use this, but feels good
team.SetSpawnPoint(TEAM_TERROR, "info_player_deathmatch")
team.SetSpawnPoint(TEAM_SPEC, "info_player_deathmatch")
end

-- Everyone's model
local ttt_playermodels = {
Model("models/player/phoenix.mdl"),
Model("models/player/arctic.mdl"),
Model("models/player/guerilla.mdl"),
Model("models/player/leet.mdl")
}
local ttt_playermodels_count = #ttt_playermodels

function GetRandomPlayerModel()
return ttt_playermodels[math.random(1, ttt_playermodels_count)]
end

local ttt_playercolors = {
all = {
	COLOR_WHITE,
	COLOR_BLACK,
	COLOR_GREEN,
	COLOR_DGREEN,
	COLOR_RED,
	COLOR_YELLOW,
	COLOR_LGRAY,
	COLOR_BLUE,
	COLOR_NAVY,
	COLOR_PINK,
	COLOR_OLIVE,
	COLOR_ORANGE
},

serious = {
	COLOR_WHITE,
	COLOR_BLACK,
	COLOR_NAVY,
	COLOR_LGRAY,
	COLOR_DGREEN,
	COLOR_OLIVE
}
}
local ttt_playercolors_all_count = #ttt_playercolors.all
local ttt_playercolors_serious_count = #ttt_playercolors.serious

CreateConVar("ttt_playercolor_mode", "1")
function GM:TTTPlayerColor(model)
local mode = (ConVarExists("ttt_playercolor_mode") and GetConVar("ttt_playercolor_mode"):GetInt() or 0)

if mode == 1 then
	return ttt_playercolors.serious[math.random(1, ttt_playercolors_serious_count)]
elseif mode == 2 then
	return ttt_playercolors.all[math.random(1, ttt_playercolors_all_count)]
elseif mode == 3 then
	-- Full randomness
	return Color(math.random(0, 255), math.random(0, 255), math.random(0, 255))
end

-- No coloring
return COLOR_WHITE
end

-- Kill footsteps on player and client
function GM:PlayerFootstep(ply, pos, foot, sound, volume, rf)
if IsValid(ply) and (ply:Crouching() or ply:GetMaxSpeed() < 150 or ply:IsSpec()) then
	-- do not play anything, just prevent normal sounds from playing
	return true
end
end

-- Predicted move speed changes
function GM:Move(ply, mv)
if ply:IsTerror() then
	local basemul = 1
	local slowed = false

	-- Slow down ironsighters
	local wep = ply:GetActiveWeapon()

	if IsValid(wep) and wep.GetIronsights and wep:GetIronsights() then
		basemul = 120 / 220
		slowed = true
	end

	local mul = hook.Call("TTTPlayerSpeedModifier", GAMEMODE, ply, slowed, mv) or 1
	mul = basemul * mul

	mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * mul)
	mv:SetMaxSpeed(mv:GetMaxSpeed() * mul)
end
end

-- Weapons and items that come with TTT. Weapons that are not in this list will
-- get a little marker on their icon if they're buyable, showing they are custom
-- and unique to the server.
function GetDefaultEquipment()
local defaultEquipment = {}

for _, v in pairs(ROLES) do
	if v.defaultEquipment then
		defaultEquipment[v.index] = v.defaultEquipment
	end
end

return defaultEquipment
end

DefaultEquipment = GetDefaultEquipment()

-- should be exported !
hook.Add("TTT2_FinishedSync", "updateDefEquRol", function(ply, first)
if first then
DefaultEquipment = GetDefaultEquipment()
end
end)

TTTWEAPON_CVARS = {}

function SWEPAddConVar(swep, tbl)
local cls = swep.ClassName

TTTWEAPON_CVARS[cls] = TTTWEAPON_CVARS[cls] or {}

table.insert(TTTWEAPON_CVARS[cls], tbl)

CreateConVar(tbl.cvar, tbl.value, tbl.flags)
end

function SWEPIsBuyable(wepCls)
if not wepCls then
return true
end

local name = "t32_" .. wepCls .. "_imp"

if ConVarExists(name) then
local i = GetConVar(name):GetInt() or 0

if i == 0 then
	return false
end

local choices = {}

for _, v in ipairs(player.GetAll()) do
	-- everyone on the spec team is in specmode
	if IsValid(v) and not v:IsSpec() then
		table.insert(choices, v)
	end
end

if #choices < i then
	return false
end
end

return true
end

function RegisterNormalWeapon(wep)
if wep.MinPlayers then
local tbl = {}
tbl.cvar = "t32_" .. wep.ClassName .. "_imp"
tbl.value = tostring(wep.MinPlayers)
tbl.flags = {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}
tbl.slider = true
tbl.desc = "MinPlayers"
tbl.max = 100

SWEPAddConVar(wep, tbl)
end
end
