-- This file contains all shared vars, tables and functions

GM.Name = "[TTT2] Trouble in Terrorist Town 2 (Advanced Update) - by Alf21"
GM.Author = "Bad King Urgrain && Alf21"
GM.Email = "4lf-mueller@gmx.de"
GM.Website = "ttt.badking.net, ttt2.informaskill.de"
-- Date of latest changes (YYYY-MM-DD)
GM.Version = "0.3.5b"

GM.Customized = true

TTT2 = true -- identifier for TTT2. Just use "if TTT2 then ... end"

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

-- role teams to have an identifier
TEAM_NONE = "noteam"
TEAM_INNOCENT = "innocents"
TEAM_TRAITOR = "traitors"

-- never use this as a team, its just a const to check something
TEAM_NOCHANGE = "nochange"

-- max network bits to send roles numbers
ROLE_BITS = 5

-- override default settings of ttt to make it compatible with other addons
-- Player roles
ROLE_INNOCENT = 0
ROLE_TRAITOR = 1
ROLE_DETECTIVE = 2
ROLE_NONE = ROLE_INNOCENT

-- TEAM_ARRAY
TEAMS = {
	[TEAM_INNOCENT] = {
		icon = "vgui/ttt/sprite_inno",
		color = Color(55, 170, 50, 255)
	},
	[TEAM_TRAITOR] = {
		icon = "vgui/ttt/sprite_traitor",
		color = Color(180, 50, 40, 255)
	}
}

-- ROLE_ARRAY
-- need to have a team to be able to win as well as to receive karma
-- just the following roles should be 'buildin' = true
ROLES = {}

ROLES.INNOCENT = {
	index = ROLE_INNOCENT,
	color = Color(55, 170, 50, 255),
	dkcolor = Color(60, 160, 50, 155),
	bgcolor = Color(0, 50, 0, 200),
	name = "innocent",
	abbr = "inno",
	defaultTeam = TEAM_INNOCENT,
	defaultEquipment = INNO_EQUIPMENT,
	buildin = true,
	scoreKillsMultiplier = 1,
	scoreTeamKillsMultiplier = -8,
	unknownTeam = true
}
INNOCENT = ROLES.INNOCENT

ROLES.TRAITOR = {
	index = ROLE_TRAITOR,
	color = Color(180, 50, 40, 255),
	dkcolor = Color(160, 50, 60, 155),
	bgcolor = Color(150, 0, 0, 200),
	name = "traitor",
	abbr = "traitor",
	defaultTeam = TEAM_TRAITOR,
	defaultEquipment = TRAITOR_EQUIPMENT,
	visibleForTraitors = true, -- just for a better performance
	buildin = true,
	surviveBonus = 0.5,
	scoreKillsMultiplier = 5,
	scoreTeamKillsMultiplier = -16,
	fallbackTable = {}
}
TRAITOR = ROLES.TRAITOR

ROLES.DETECTIVE = {
	index = ROLE_DETECTIVE,
	color = Color(50, 60, 180, 255),
	dkcolor = Color(50, 60, 160, 155),
	bgcolor = Color(0, 0, 150, 200),
	name = "detective",
	abbr = "det",
	defaultTeam = TEAM_INNOCENT,
	defaultEquipment = SPECIAL_EQUIPMENT,
	buildin = true,
	scoreKillsMultiplier = INNOCENT.scoreKillsMultiplier,
	scoreTeamKillsMultiplier = INNOCENT.scoreTeamKillsMultiplier,
	fallbackTable = {},
	unknownTeam = true
}
DETECTIVE = ROLES.DETECTIVE

CreateConVar("ttt_detective_enabled", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})
CreateConVar("ttt_newroles_enabled", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})

SHOP_DISABLED = "DISABLED"
SHOP_UNSET = "UNSET"

-- shop fallbacks
CreateConVar("ttt_" .. INNOCENT.abbr .. "_shop_fallback", SHOP_DISABLED, {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})
CreateConVar("ttt_" .. TRAITOR.abbr .. "_shop_fallback", SHOP_UNSET, {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})
CreateConVar("ttt_" .. DETECTIVE.abbr .. "_shop_fallback", SHOP_UNSET, {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})

function InitCustomTeam(name, data) -- creates global var "TEAM_[name]" and other required things
	local teamname = string.lower(name) .. "s"

	_G["TEAM_" .. name] = teamname

	TEAMS[teamname] = data
end

function GetRoles()
	return ROLES
end

function GenerateNewRoleID()
	local i = 1 -- start with "1" to prevent incompatibilities with ROLE_ANY => new roles will start @ id: i(1)+3=4

	for _, v in pairs(GetRoles()) do
		i = i + 1
	end

	return i
end

-- you should only use this function to add roles to TTT2
function InitCustomRole(name, roleData, conVarData)
	conVarData = conVarData or {}

	if not ROLES[name] then
		-- shared
		if not roleData.notSelectable then
			if conVarData.togglable then
				CreateClientConVar("ttt_avoid_" .. roleData.name, "0", true, true)
			end

			CreateConVar("ttt_" .. roleData.name .. "_pct", tostring(conVarData.pct or 1), {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})
			CreateConVar("ttt_" .. roleData.name .. "_max", tostring(conVarData.maximum or 1), {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})
			CreateConVar("ttt_" .. roleData.name .. "_min_players", tostring(conVarData.minPlayers or 1), {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})

			if conVarData.random then
				CreateConVar("ttt_" .. roleData.name .. "_random", tostring(conVarData.random or 100), {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})
			else
				CreateConVar("ttt_" .. roleData.name .. "_random", "100", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})
			end

			CreateConVar("ttt_" .. roleData.name .. "_enabled", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})
		end

		conVarData.credits = conVarData.credits or 0
		conVarData.creditsTraitorKill = conVarData.creditsTraitorKill or 0
		conVarData.creditsTraitorDead = conVarData.creditsTraitorDead or 0

		CreateConVar("ttt_" .. roleData.abbr .. "_credits_starting", tostring(conVarData.credits), {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})
		CreateConVar("ttt_" .. roleData.abbr .. "_credits_traitorkill", tostring(conVarData.creditsTraitorKill), {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})
		CreateConVar("ttt_" .. roleData.abbr .. "_credits_traitordead", tostring(conVarData.creditsTraitorDead), {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})

		local shopFallbackValue

		if not conVarData.shopFallback and roleData.fallbackTable then
			shopFallbackValue = SHOP_UNSET
		else
			shopFallbackValue = conVarData.shopFallback and tostring(conVarData.shopFallback) or SHOP_DISABLED
		end

		CreateConVar("ttt_" .. roleData.abbr .. "_shop_fallback", shopFallbackValue, {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})

		if conVarData.traitorKill then
			CreateConVar("ttt_credits_" .. roleData.name .. "kill", tostring(conVarData.traitorKill), {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})
		end

		-- set id
		roleData.index = GenerateNewRoleID()

		-- fix defaultTeam
		roleData.defaultTeam = roleData.defaultTeam or TEAM_NONE

		-- set data
		ROLES[name] = roleData

		_G["ROLE_" .. string.upper(roleData.name)] = roleData.index
		_G[string.upper(roleData.name)] = roleData

		local plymeta = FindMetaTable("Player")
		if plymeta then
			-- e.g. IsJackal() will match each subrole of the jackal as well as the jackal as the baserole
			plymeta["Is" .. roleData.name:gsub("^%l", string.upper)] = function(self)
				local br = self:GetBaseRole()
				local sr = self:GetSubRole()

				return roleData.baserole and sr == roleData.index or not roleData.baserole and br == roleData.index
			end
		end

		print("[TTT2][ROLE] Added '" .. name .. "' role (index: " .. roleData.index .. ")")
	end
end

-- usage: inside of e.g. this hook: hook.Add("TTT2BaseRoleInit", "TTT2ConnectBaseRole" .. baserole .. "With_" .. roleData.name, ...)
function SetBaseRole(roleData, baserole)
	if roleData.baserole then
		error("[TTT2][ROLE-SYSTEM][ERROR] BaseRole of " .. roleData.name .. " already set (" .. roleData.baserole .. ")!")
	else
		local br = GetRoleByIndex(baserole)

		if br.baserole then
			error("[TTT2][ROLE-SYSTEM][ERROR] Your requested BaseRole can't be any BaseRole of another SubRole because it's a SubRole as well.")

			return
		end

		roleData.baserole = baserole
		roleData.defaultTeam = br.defaultTeam

		print("[TTT2][ROLE-SYSTEM] Connected '" .. roleData.name .. "' subrole with baserole '" .. br.name .. "')")
	end
end

-- if you add roles that can shop, modify DefaultEquipment at the end of this file
-- TODO combine DefaultEquipment[x] and GetRoles()[x] !

SHOP_FALLBACK_TRAITOR = TRAITOR.name
SHOP_FALLBACK_DETECTIVE = DETECTIVE.name

function SortRolesTable(tbl)
	local _func = function(a, b)
		return a.index < b.index
	end

	table.sort(tbl, _func)
end

function GetRoleByIndex(index)
	for _, v in pairs(GetRoles()) do
		if v.index == index then
			return v
		end
	end

	return INNOCENT
end

function GetRoleByName(name)
	for _, v in pairs(GetRoles()) do
		if v.name == name then
			return v
		end
	end

	return INNOCENT
end

function GetRoleByAbbr(abbr)
	for _, v in pairs(GetRoles()) do
		if v.abbr == abbr then
			return v
		end
	end

	return INNOCENT
end

function GetStartingCredits(abbr)
	if abbr == TRAITOR.abbr then
		return GetConVar("ttt_credits_starting"):GetInt()
	end

	return ConVarExists("ttt_" .. abbr .. "_credits_starting") and GetConVar("ttt_" .. abbr .. "_credits_starting"):GetInt() or 0
end

function IsShoppingRole(subrole)
	if subrole == ROLE_INNOCENT then
		return false
	end

	local roleData = GetRoleByIndex(subrole)
	local shopFallback = GetConVar("ttt_" .. roleData.abbr .. "_shop_fallback"):GetString()

	return shopFallback ~= SHOP_DISABLED
end

function GetShopRoles()
	local shopRoles = {}

	local i = 0

	for _, v in pairs(GetRoles()) do
		if v ~= INNOCENT then
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

function IsBaseRole(roleData)
	return not roleData.baserole
end

function GetBaseRole(subrole)
	return GetRoleByIndex(subrole).baserole or subrole
end

-- includes baserole as well
function GetSubRoles(subrole)
	local br = GetBaseRole(subrole)
	local tmp = {}

	for _, v in pairs(GetRoles()) do
		if v.baserole and v.baserole == br or v.index == br then
			table.insert(tmp, v)
		end
	end

	return tmp
end

function GetDefaultTeamRole(team)
	if team == TEAM_NONE then return end

	for _, v in pairs(GetRoles()) do
		if not v.baserole and v.defaultTeam ~= TEAM_NONE and v.defaultTeam == team then
			return v
		end
	end

	return INNOCENT
end

function GetDefaultTeamRoles(team)
	if team == TEAM_NONE then return end

	return GetSubRoles(GetDefaultTeamRole(team).index)
end

function GetTeamMembers(team)
	if team == TEAM_NONE then return end

	local tmp = {}

	for _, v in ipairs(player.GetAll()) do
		if v:HasTeam(team) then
			table.insert(tmp, v)
		end
	end

	return tmp
end

function GetWinTeams()
	local winTeams = {}

	for _, v in pairs(GetRoles()) do
		if v.defaultTeam ~= TEAM_NONE and not table.HasValue(winTeams, v.defaultTeam) and not v.preventWin then
			table.insert(winTeams, v.defaultTeam)
		end
	end

	return winTeams
end

function GetAvailableTeams()
	local availableTeams = {}

	for _, v in pairs(GetRoles()) do
		if v.defaultTeam ~= TEAM_NONE and not table.HasValue(availableTeams, v.defaultTeam) then
			availableTeams[#availableTeams + 1] = v.defaultTeam
		end
	end

	return availableTeams
end

function GetSortedRoles()
	local roles = {}

	local i = 0

	for _, v in pairs(GetRoles()) do
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

-- default TTT fn
function GetTraitors()
	local trs = {}

	for _, v in ipairs(player.GetAll()) do
		if v:IsTraitor() then
			table.insert(trs, v)
		end
	end

	return trs
end

-- default TTT fn
function CountTraitors()
	return #GetTraitors()
end

function table.Randomize(t)
	local out = {}

	while #t > 0 do
		table.insert(out, table.remove(t, math.random(#t)))
	end

	t = out
end

-- TODO move to client file
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
		local _func = function(adata, bdata)
			a = adata.id
			b = bdata.id

			if tonumber(a) and not tonumber(b) then
				return true
			elseif tonumber(b) and not tonumber(a) then
				return false
			else
				return a < b
			end
		end

		table.sort(tbl, _func)
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

WIN_NONE = WIN_NONE or 1
WIN_TRAITOR = WIN_TRAITOR or 2
WIN_INNOCENT = WIN_INNOCENT or 3
WIN_TIMELIMIT = WIN_TIMELIMIT or 4

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
MUTE_SPEC = 1002 -- TODO why not 3?

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

ttt_include("util")
ttt_include("lang_shd")
ttt_include("equip_items_shd")

function DetectiveMode()
	return GetGlobalBool("ttt_detective", false)
end

function HasteMode()
	return GetGlobalBool("ttt_haste", false)
end

-- Create teams
TEAM_TERROR = 1
TEAM_SPEC = TEAM_SPECTATOR

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

-- Weapons and items that come with TTT. Weapons that are not in this list will
-- get a little marker on their icon if they're buyable, showing they are custom
-- and unique to the server.
function GetDefaultEquipment()
	local defaultEquipment = {}

	for _, v in pairs(GetRoles()) do
		if v.defaultEquipment then
			defaultEquipment[v.index] = v.defaultEquipment
		end
	end

	return defaultEquipment
end

DefaultEquipment = GetDefaultEquipment()

TTTWEAPON_CVARS = {}

function SWEPAddConVar(swep, tbl)
	local cls = swep.ClassName

	TTTWEAPON_CVARS[cls] = TTTWEAPON_CVARS[cls] or {}

	table.insert(TTTWEAPON_CVARS[cls], tbl)

	CreateConVar(tbl.cvar, tbl.value, tbl.flags)
end

function SWEPIsBuyable(wepCls)
	if not wepCls then
		return false
	end

	local name = "t32_" .. wepCls .. "_imp"

	if ConVarExists(name) then
		local i = GetConVar(name):GetInt() or 0

		if i < 2 then
			return true
		end

		local choices = {}

		for _, v in ipairs(player.GetAll()) do
			-- everyone on the forcespec team is in specmode
			if IsValid(v) and not v:GetForceSpec() then
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
		tbl.desc = "Available if there are more than ... players"
		tbl.max = 128

		SWEPAddConVar(wep, tbl)
	end
end
