-- This file contains all shared vars, tables and functions

GM.Name = "TTT2 (Advanced Update)"
GM.Author = "Bad King Urgrain, Alf21, tkindanight, Mineotopia, LeBroomer"
GM.Email = "4lf-mueller@gmx.de"
GM.Website = "ttt.badking.net, ttt2.informaskill.de"
GM.Version = "0.5.1b"
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
	"item_ttt_armor",
	"item_ttt_radar"
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
	"item_ttt_armor",
	"item_ttt_radar",
	"item_ttt_disguiser"
}

-- role teams to have an identifier
TEAM_NONE = "noteam"
TEAM_INNOCENT = "innocents"
TEAM_TRAITOR = "traitors"

-- never use this as a team, its just a const to check something
TEAM_NOCHANGE = "nochange"

-- max networking bits to send roles numbers
ROLE_BITS = 5

-- override default settings of ttt to make it compatible with other addons
-- Player roles
ROLE_INNOCENT = 0
ROLE_TRAITOR = 1
ROLE_DETECTIVE = 2
ROLE_NONE = ROLE_INNOCENT

-- TEAM_ARRAY
TEAMS = TEAMS or {
	[TEAM_INNOCENT] = {
		icon = "vgui/ttt/dynamic/roles/icon_inno",
		color = Color(80, 173, 59, 255)
	},
	[TEAM_TRAITOR] = {
		icon = "vgui/ttt/dynamic/roles/icon_traitor",
		color = Color(209, 43, 39, 255)
	}
}

ACTIVEROLES = ACTIVEROLES or {}

CreateConVar("ttt_detective_enabled", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_newroles_enabled", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

local ttt2_custom_models = CreateConVar("ttt2_custom_models", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

SHOP_DISABLED = "DISABLED"
SHOP_UNSET = "UNSET"

-- if you add roles that can shop, modify DefaultEquipment at the end of this file
-- TODO combine DefaultEquipment[x] and GetRoles()[x] !

-- just compatibality functions
function GetRoles()
	return roles.GetList()
end

function SortRolesTable(tbl)
	roles.SortTable(tbl)
end

function GetRoleByIndex(index)
	return roles.GetByIndex(index)
end

function GetRoleByName(name)
	return roles.GetByName(name)
end

function GetRoleByAbbr(abbr)
	return roles.GetByAbbr(abbr)
end

function GetStartingCredits(abbr)
	local roleData = roles.GetByAbbr(abbr)

	return roleData:GetStartingCredits()
end

function IsShoppingRole(subrole)
	local roleData = roles.GetByIndex(subrole)

	return roleData:IsShoppingRole()
end

function GetShopRoles()
	return roles.GetShopRoles()
end

function IsBaseRole(roleData)
	return roleData:IsBaseRole()
end

function GetBaseRole(subrole)
	return roles.GetByIndex(subrole).baserole or subrole
end

if SERVER then
	function IsRoleSelectable(roleData, avoidHook)
		return roleData:IsSelectable(avoidHook)
	end
end

-- includes baserole as well
function GetSubRoles(subrole)
	local roleData = roles.GetByIndex(subrole)

	return roleData:GetSubRoles()
end

function GetDefaultTeamRole(team)
	return roles.GetDefaultTeamRole(team)
end

function GetDefaultTeamRoles(team)
	return roles.GetDefaultTeamRoles(team)
end

function GetTeamMembers(team)
	return roles.GetTeamMembers(team)
end

function GetWinTeams()
	return roles.GetWinTeams()
end

function GetAvailableTeams()
	return roles.GetAvailableTeams()
end

function GetSortedRoles()
	return roles.GetSortedRoles()
end

function GetActiveRoles()
	return ACTIVEROLES
end

function GetActiveRolesCount(rd)
	return ACTIVEROLES[rd] or 0
end

function SetActiveRolesCount(rd, count)
	ACTIVEROLES[rd] = count == 0 and nil or count
end

-- default TTT fn
function GetTraitors()
	local trs = {}

	for _, v in ipairs(player.GetAll()) do
		if v:IsTraitor() then
			trs[#trs + 1] = v
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
WEAPON_MELEE = 1
WEAPON_PISTOL = 2
WEAPON_HEAVY = 3
WEAPON_NADE = 4
WEAPON_CARRY = 5
WEAPON_UNARMED = 6
WEAPON_SPECIAL = 7
WEAPON_EXTRA = 8

--keep the old categories for compatibality
WEAPON_EQUIP1 = WEAPON_SPECIAL
WEAPON_EQUIP2 = WEAPON_SPECIAL
WEAPON_ROLE = WEAPON_EXTRA
WEAPON_NONE = WEAPON_EXTRA
WEAPON_EQUIP = WEAPON_SPECIAL

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

ttt_include("sh_util")
ttt_include("sh_lang")
ttt_include("sh_sql")
ttt_include("sh_hud_manager")
ttt_include("sh_equip_items")

function GetEquipmentFileName(name)
	return string.gsub(string.lower(name), "[%W%s]", "_") -- clean string
end

function GetEquipmentByName(name)
	name = GetEquipmentFileName(name)

	return not items.IsItem(name) and weapons.GetStored(name) or items.GetStored(name), name
end

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
	if not ttt2_custom_models:GetBool() then
		return ttt_playermodels[math.random(1, ttt_playermodels_count)]
	else
		return ttt_playermodels[1]
	end
end

-- Weapons and items that come with TTT. Weapons that are not in this list will
-- get a little marker on their icon if they're buyable, showing they are custom
-- and unique to the server.
function GetDefaultEquipment()
	local defaultEquipment = {}

	for _, v in ipairs(roles.GetList()) do
		if v.defaultEquipment then
			defaultEquipment[v.index] = v.defaultEquipment
		end
	end

	return defaultEquipment
end

DefaultEquipment = {
	[0] = {},
	[1] = {},
	[2] = {}
}

BUYTABLE = BUYTABLE or {}
TEAMBUYTABLE = TEAMBUYTABLE or {}

hook.Add("TTTPrepareRound", "TTT2SharedPrepareRound", function()
	BUYTABLE = {}
	TEAMBUYTABLE = {}

	math.randomseed(os.time())
	math.random(); math.random(); math.random() -- warming up
end)

function EquipmentIsBuyable(tbl, team)
	if not tbl then
		return false, "X", "error"
	end

	if tbl.minPlayers and tbl.minPlayers > 1 then
		local choices = {}

		for _, v in ipairs(player.GetAll()) do
			-- everyone on the forcespec team is in specmode
			if IsValid(v) and not v:GetForceSpec() then
				table.insert(choices, v)
			end
		end

		if #choices < tbl.minPlayers then
			return false, " " .. #choices .. " / " .. tbl.minPlayers, "Minimum amount of active players needed."
		end
	end

	if tbl.globalLimited and BUYTABLE[tbl.id] or team and tbl.teamLimited and not TEAMS[team].alone and TEAMBUYTABLE[team] and TEAMBUYTABLE[team][tbl.id] then
		return false, "X", "This equipment is limited and is already bought."
	end

	return true, "✔", "ok"
end
