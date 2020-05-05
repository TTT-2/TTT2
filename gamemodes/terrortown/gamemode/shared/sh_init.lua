---
-- This file contains all shared vars, tables and functions

GM.Name = "TTT2 (Advanced Update)"
GM.Author = "Bad King Urgrain, Alf21, tkindanight, Mineotopia, LeBroomer"
GM.Email = "ttt2@neoxult.de"
GM.Website = "ttt.badking.net, ttt2.informaskill.de"
GM.Version = "0.6.4b"
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
	"item_ttt_radar",
	"item_ttt_nodrowningdmg",
	"item_ttt_noenergydmg",
	"item_ttt_noexplosiondmg",
	"item_ttt_nofalldmg",
	"item_ttt_nofiredmg",
	"item_ttt_nohazarddmg",
	"item_ttt_nopropdmg",
	"item_ttt_speedrun"
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
ROLE_BITS = 8

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
		iconMaterial = Material("vgui/ttt/dynamic/roles/icon_inno"),
		color = Color(80, 173, 59, 255)
	},
	[TEAM_TRAITOR] = {
		icon = "vgui/ttt/dynamic/roles/icon_traitor",
		iconMaterial = Material("vgui/ttt/dynamic/roles/icon_traitor"),
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

---
-- Returns a list of all the registered roles
-- @return table all registered roles
-- @see roles.GetList
-- @realm shared
-- @deprecated
function GetRoles()
	return roles.GetList()
end

---
-- Sorts a
-- @return table
-- @see roles.GetList
-- @realm shared
-- @deprecated
function SortRolesTable(tbl)
	roles.SortTable(tbl)
end

---
-- Get the role table by the role id
-- @param number index subrole id
-- @return table returns the role table. This will return the <code>INNOCENT</code> role table as fallback.
-- @see roles.GetByIndex
-- @realm shared
-- @deprecated
function GetRoleByIndex(index)
	return roles.GetByIndex(index)
end

---
-- Get the role table by the role name
-- @param string name role name
-- @return table returns the role table. This will return the <code>INNOCENT</code> role table as fallback.
-- @see roles.GetByName
-- @realm shared
-- @deprecated
function GetRoleByName(name)
	return roles.GetByName(name)
end

---
-- Get the role table by the role abbreviation
-- @param string abbr role abbreviation
-- @return table returns the role table. This will return the <code>INNOCENT</code> role table as fallback.
-- @see roles.GetByAbbr
-- @realm shared
-- @deprecated
function GetRoleByAbbr(abbr)
	return roles.GetByAbbr(abbr)
end

---
-- Returns the starting credits of a @{ROLE} based on ConVar settings or default traitor settings
-- @param string abbr abbreviation of a @{ROLE}
-- @return[default=0] number
-- @realm shared
-- @see ROLE:GetStartingCredits
-- @deprecated
function GetStartingCredits(abbr)
	local roleData = roles.GetByAbbr(abbr)

	return roleData:GetStartingCredits()
end

---
-- Returns whether a @{ROLE} is able to access the shop based on ConVar settings
-- @param number subrole subrole id of a @{ROLE}
-- @return[default=false] boolean
-- @realm shared
-- @see ROLE:IsShoppingRole
-- @deprecated
function IsShoppingRole(subrole)
	local roleData = roles.GetByIndex(subrole)

	return roleData:IsShoppingRole()
end

---
-- Get a sorted list of roles that have access to a shop
-- @return table list of roles that have access to a shop
-- @realm shared
-- @see roles.GetShopRoles
-- @deprecated
function GetShopRoles()
	return roles.GetShopRoles()
end

---
-- Returns whether a @{ROLE} is a BaseRole
-- @param ROLE roleData
-- @return boolean
-- @realm shared
-- @see ROLE:IsBaseRole
-- @deprecated
function IsBaseRole(roleData)
	return roleData:IsBaseRole()
end

---
-- Returns the baserole of a specific @{ROLE}
-- @param number subrole subrole id of a @{ROLE}
-- @return number subrole id of the BaseRole (@{ROLE})
-- @realm shared
-- @see ROLE:GetBaseRole
-- @deprecated
function GetBaseRole(subrole)
	return roles.GetByIndex(subrole):GetBaseRole()
end

if SERVER then

	---
	-- Checks whether a role is able to get selected (and maybe assigned to a @{Player}) if the round starts
	-- @param boolean avoidHook should the @{hook.TTT2RoleNotSelectable} hook be ignored?
	-- @return boolean
	-- @realm server
	-- @see ROLE:IsSelectable
	-- @deprecated
	function IsRoleSelectable(roleData, avoidHook)
		return roleData:IsSelectable(avoidHook)
	end
end

---
-- Returns a list of subroles of this BaseRole (this subrole's BaseRole)
-- @param number subrole subrole id of a @{ROLE}
-- @return table list of @{ROLE}
-- @realm shared
-- @see ROLE:GetSubRoles
-- @deprecated
function GetSubRoles(subrole)
	local roleData = roles.GetByIndex(subrole)

	return roleData:GetSubRoles()
end

---
-- Get the default role table of a specific role team
-- @param string team role team name
-- @return table returns the role table. This will return the <code>INNOCENT</code> role table as fallback.
-- @realm shared
-- @see roles.GetDefaultTeamRole
-- @deprecated
function GetDefaultTeamRole(team)
	return roles.GetDefaultTeamRole(team)
end

---
-- Get the default role tables of a specific role team
-- @param string team role team name
-- @return table returns the role tables. This will return the <code>INNOCENT</code> role table as well as its subrole tables as fallback.
-- @realm shared
-- @see roles.GetDefaultTeamRoles
-- @deprecated
function GetDefaultTeamRoles(team)
	return roles.GetDefaultTeamRoles(team)
end

---
-- Get a list of team members
-- @param string team role team name
-- @return table returns the member table of a role team.
-- @realm shared
-- @see roles.GetTeamMembers
-- @deprecated
function GetTeamMembers(team)
	return roles.GetTeamMembers(team)
end

---
-- Get a list of all teams that are able to win
-- @return table returns a list of all teams that are able to win
-- @realm shared
-- @see roles.GetWinTeams
-- @deprecated
function GetWinTeams()
	return roles.GetWinTeams()
end

---
-- Get a list of all available teams
-- @return table returns a list of all available teams
-- @realm shared
-- @see roles.GetAvailableTeams
-- @deprecated
function GetAvailableTeams()
	return roles.GetAvailableTeams()
end

---
-- Get a sorted list of all roles
-- @return table returns a list of all roles
-- @realm shared
-- @see roles.GetSortedRoles
-- @deprecated
function GetSortedRoles()
	return roles.GetSortedRoles()
end

---
-- Returns a table of all active @{ROLE}
-- @return table
-- @realm shared
function GetActiveRoles()
	return ACTIVEROLES
end

---
-- Returns the amount of assignments of a specific @{ROLE}
-- @param ROLE rd
-- @return number
-- @realm shared
function GetActiveRolesCount(rd)
	return ACTIVEROLES[rd] or 0
end

---
-- Sets the amount of assignments of a specific @{ROLE}
-- @param ROLE rd
-- @param number count
-- @realm shared
function SetActiveRolesCount(rd, count)
	ACTIVEROLES[rd] = count == 0 and nil or count
end

---
-- Returns a list of all available traitors
-- @note default TTT fn
-- @return table list of @{Player}
-- @realm shared
-- @deprecated
function GetTraitors()
	local trs = {}
	local plys = player.GetAll()

	for i = 1, #plys do
		if not plys[i]:IsTraitor() then continue end

		trs[#trs + 1] = plys[i]
	end

	return trs
end

---
-- Returns the amount of traitors in this round
-- @note default TTT fn
-- @return number
-- @realm shared
-- @deprecated
function CountTraitors()
	return #GetTraitors()
end

---
-- Randomizes a @{table}
-- @realm shared
function table.Randomize(t)
	local out = {}

	while #t > 0 do
		out[#out + 1] = table.remove(t, math.random(#t))
	end

	t = out
end

-- TODO move to client file
if CLIENT then
	local SafeTranslate

	---
	-- Returns an equipment's translation based on the user's language
	-- @param string name
	-- @param string printName
	-- @return string the translated text
	-- @realm client
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

	---
	-- Sorts an equipment table
	-- @param table tbl the equipment table
	-- @realm client
	function SortEquipmentTable(tbl)
		if not tbl or #tbl < 2 then return end

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
WEAPON_CLASS = 9

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
COLOR_LLGRAY = Color(210, 210, 210, 255)
COLOR_SLATEGRAY = Color(110, 120, 125, 255)
COLOR_BLUE = Color(0, 0, 255, 255)
COLOR_NAVY = Color(0, 0, 100, 255)
COLOR_PINK = Color(255, 0, 255, 255)
COLOR_ORANGE = Color(250, 100, 0, 255)
COLOR_OLIVE = Color(100, 100, 0, 255)

-- load non-wrapped modules directly
require("marks")

-- TODO load modules that are currently not included in gmod but waiting for merge
require("outline")

include("includes/modules/pon.lua")
include("ttt2/extensions/net.lua")
include("ttt2/extensions/string.lua")
include("ttt2/extensions/table.lua")

-- include ttt required files
ttt_include("sh_util")
ttt_include("sh_decal")
ttt_include("sh_lang")
ttt_include("sh_sql")
ttt_include("sh_hud_module")
ttt_include("sh_hudelement_module")
ttt_include("sh_equip_items")
ttt_include("sh_role_module")
ttt_include("sh_item_module")

---
-- Returns the equipment's file name
-- @param string name
-- @return string
-- @realm shared
function GetEquipmentFileName(name)
	return string.gsub(string.lower(name), "[%W%s]", "_") -- clean string
end

---
-- Returns the equipment based on the given name
-- @param string name
-- @return ITEM|Weapon item OR weapon
-- @return string name
-- @realm shared
function GetEquipmentByName(name)
	name = GetEquipmentFileName(name)

	return not items.IsItem(name) and weapons.GetStored(name) or items.GetStored(name), name
end

---
-- Returns whether the detective mode is enabled
-- @return boolean
-- @realm shared
function DetectiveMode()
	return GetGlobalBool("ttt_detective", false)
end

---
-- Returns whether the haste mode is enabled
-- @return boolean
-- @realm shared
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

---
-- Returns a random player model
-- @return Model model
-- @realm shared
function GetRandomPlayerModel()
	if not ttt2_custom_models:GetBool() then
		return ttt_playermodels[math.random(ttt_playermodels_count)]
	else
		return ttt_playermodels[1]
	end
end

---
-- Returns the default equipment
-- @note Weapons and items that come with TTT. Weapons that are not in this list will
-- get a little marker on their icon if they're buyable, showing they are custom
-- and unique to the server.
-- @return table list of default equipment
-- @realm shared
function GetDefaultEquipment()
	local defaultEquipment = {}
	local rlsList = roles.GetList()

	for i = 1, #rlsList do
		local v = rlsList[i]

		if not v.defaultEquipment then continue end

		defaultEquipment[v.index] = v.defaultEquipment
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

---
-- Checks whether an equipment is buyable
-- @param table tbl equipment table
-- @param @{Player} player
-- @return boolean
-- @return string text as an icon
-- @return string result or error
-- @realm shared
function EquipmentIsBuyable(tbl, ply)
	local valPly = IsValid(ply) and ply:IsPlayer()
	if not tbl or not valPly then
		return false, "X", "error"
	end

	local team = ply:GetTeam()

	if not tbl.id then
		ErrorNoHalt("[TTT2][ERROR] Missing id in table:", tbl)
		PrintTable(tbl)

		return false, "X", "ID error"
	end

	if tbl.notBuyable then
		return false, "X", "This equipment cannot be bought."
	end

	if tbl.minPlayers and tbl.minPlayers > 1 then
		local choices = {}
		local plys = player.GetAll()

		for i = 1, #plys do
			local v = plys[i]

			-- everyone on the forcespec team is in specmode
			if not IsValid(v) or v:GetForceSpec() then continue end

			choices[#choices + 1] = v
		end

		if #choices < tbl.minPlayers then
			return false, " " .. #choices .. " / " .. tbl.minPlayers, "Minimum amount of active players needed."
		end
	end

	if tbl.globalLimited and BUYTABLE[tbl.id] or team and tbl.teamLimited and TEAMS[team] and not TEAMS[team].alone and TEAMBUYTABLE[team] and TEAMBUYTABLE[team][tbl.id] or tbl.limited and ply:HasBought(tbl.ClassName) then
		return false, "X", "This equipment is limited and is already bought."
	end

	-- weapon whitelist check
	if not tbl.CanBuy[GetShopFallback(ply:GetSubRole())] then
		return false, "X", "Your role can't buy this equipment."
	end

	return true, "✔", "ok"
end
