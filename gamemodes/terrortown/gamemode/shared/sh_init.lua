---
-- This file contains all shared vars, tables and functions

GM.Name = "TTT2"
GM.Author = "Bad King Urgrain, Alf21, saibotk, Mineotopia, LeBroomer, Histalek, ZenBre4ker"
GM.Email = "ttt2@neoxult.de"
GM.Website = "ttt.badking.net, docs.ttt2.neoxult.de"
GM.Version = "0.14.3b"
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
    "weapon_ttt_glock",
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
    "item_ttt_speedrun",
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
    "item_ttt_disguiser",
}

-- role teams to have an identifier
TEAM_INNOCENT = "innocents"
TEAM_TRAITOR = "traitors"
TEAM_NONE = "nones"

-- never use this as a team, its just a const to check something
TEAM_NOCHANGE = "nochange"

-- max networking bits to send roles numbers
ROLE_BITS = 8

-- override default settings of ttt to make it compatible with other addons
-- Player roles
ROLE_INNOCENT = 0
ROLE_TRAITOR = 1
ROLE_DETECTIVE = 2
ROLE_NONE = 3

-- TEAM_ARRAY
TEAMS = TEAMS
    or {
        [TEAM_INNOCENT] = {
            icon = "vgui/ttt/dynamic/roles/icon_inno",
            iconMaterial = Material("vgui/ttt/dynamic/roles/icon_inno"),
            color = Color(80, 173, 59, 255),
        },
        [TEAM_TRAITOR] = {
            icon = "vgui/ttt/dynamic/roles/icon_traitor",
            iconMaterial = Material("vgui/ttt/dynamic/roles/icon_traitor"),
            color = Color(209, 43, 39, 255),
        },
        [TEAM_NONE] = {
            icon = "vgui/ttt/dynamic/roles/icon_no_team",
            iconMaterial = Material("vgui/ttt/dynamic/roles/icon_no_team"),
            color = Color(91, 94, 99, 255),
        },
    }

ACTIVEROLES = ACTIVEROLES or {}

SHOP_DISABLED = "DISABLED"
SHOP_UNSET = "UNSET"

-- don't block the winning condition during the revival process
REVIVAL_BLOCK_NONE = 0
-- only block the winning condition, if the player being alive would change the outcome
REVIVAL_BLOCK_AS_ALIVE = 1
-- block the winning condition until the revival process is ended
REVIVAL_BLOCK_ALL = 2

REVIVAL_BITS = 2

-- if you add roles that can shop, modify DefaultEquipment at the end of this file

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
-- @param table tbl
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
-- @return table returns the role table. This will return the <code>NONE</code> role table as fallback.
-- @see roles.GetByIndex
-- @realm shared
-- @deprecated
function GetRoleByIndex(index)
    return roles.GetByIndex(index)
end

---
-- Get the role table by the role name
-- @param string name role name
-- @return table returns the role table. This will return the <code>NONE</code> role table as fallback.
-- @see roles.GetByName
-- @realm shared
-- @deprecated
function GetRoleByName(name)
    return roles.GetByName(name)
end

---
-- Get the role table by the role abbreviation
-- @param string abbr role abbreviation
-- @return table returns the role table. This will return the <code>NONE</code> role table as fallback.
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
    -- @param ROLE roleData
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
-- @return table returns the role table. This will return the <code>NONE</code> role table as fallback.
-- @realm shared
-- @see roles.GetDefaultTeamRole
-- @deprecated
function GetDefaultTeamRole(team)
    return roles.GetDefaultTeamRole(team)
end

---
-- Get the default role tables of a specific role team
-- @param string team role team name
-- @return table returns the role tables. This will return the <code>NONE</code> role table as well as its subrole tables as fallback.
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
        if not plys[i]:IsTraitor() then
            continue
        end

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
        if not tbl or #tbl < 2 then
            return
        end

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

-- weapon spawn type
WEAPON_TYPE_RANDOM = 1
WEAPON_TYPE_MELEE = 2
WEAPON_TYPE_NADE = 3
WEAPON_TYPE_SHOTGUN = 4
WEAPON_TYPE_HEAVY = 5
WEAPON_TYPE_SNIPER = 6
WEAPON_TYPE_PISTOL = 7
WEAPON_TYPE_SPECIAL = 8

-- ammo spawn type
AMMO_TYPE_RANDOM = 1
AMMO_TYPE_DEAGLE = 2
AMMO_TYPE_PISTOL = 3
AMMO_TYPE_MAC10 = 4
AMMO_TYPE_RIFLE = 5
AMMO_TYPE_SHOTGUN = 6

-- player spawn types
PLAYER_TYPE_RANDOM = 1

-- spawn types
SPAWN_TYPE_WEAPON = 1
SPAWN_TYPE_AMMO = 2
SPAWN_TYPE_PLAYER = 3

-- Kill types discerned by last words
KILL_NORMAL = 0
KILL_SUICIDE = 1
KILL_FALL = 2
KILL_BURN = 3
KILL_TEAM = 4

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

-- Drop On Death override types
DROP_ON_DEATH_TYPE_DEFAULT = 0
DROP_ON_DEATH_TYPE_FORCE = 1
DROP_ON_DEATH_TYPE_DENY = 2

COLOR_SPEC = Color(155, 155, 15)

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
COLOR_BROWN = Color(70, 45, 10)
COLOR_LBROWN = Color(135, 105, 70)
COLOR_WARMGRAY = Color(91, 94, 99, 255)
COLOR_GOLD = Color(255, 215, 30)

-- include independent extensions
include("ttt2/extensions/debug.lua")

-- include independent libraries (other extensions might require them)
include("ttt2/libraries/pon.lua")

-- include extensions
include("ttt2/extensions/math.lua")
include("ttt2/extensions/player.lua")
include("ttt2/extensions/net.lua")
include("ttt2/extensions/sql.lua")
include("ttt2/extensions/string.lua")
include("ttt2/extensions/table.lua")
include("ttt2/extensions/util.lua")
include("ttt2/extensions/surface.lua")
include("ttt2/extensions/draw.lua")
include("ttt2/extensions/input.lua")
include("ttt2/extensions/cvars.lua")
include("ttt2/extensions/render.lua")
include("ttt2/extensions/chat.lua")
include("ttt2/extensions/sound.lua")

-- include libraries
include("ttt2/libraries/admin.lua")
include("ttt2/libraries/map.lua")
include("ttt2/libraries/none.lua")
include("ttt2/libraries/fastutf8.lua")
include("ttt2/libraries/huds.lua")
include("ttt2/libraries/hudelements.lua")
include("ttt2/libraries/items.lua")
include("ttt2/libraries/bind.lua")
include("ttt2/libraries/fileloader.lua")
include("ttt2/libraries/classbuilder.lua")
include("ttt2/libraries/fonts.lua")
include("ttt2/libraries/appearance.lua")
include("ttt2/libraries/drawsc.lua")
include("ttt2/libraries/vguihandler.lua")
include("ttt2/libraries/tips.lua")
include("ttt2/libraries/vskin.lua")
include("ttt2/libraries/door.lua")
include("ttt2/libraries/buttons.lua")
include("ttt2/libraries/orm.lua")
include("ttt2/libraries/database.lua")
include("ttt2/libraries/marks.lua")
include("ttt2/libraries/outline.lua")
include("ttt2/libraries/thermalvision.lua")
include("ttt2/libraries/roles.lua")
include("ttt2/libraries/gameloop.lua")
include("ttt2/libraries/events.lua")
include("ttt2/libraries/eventdata.lua")
include("ttt2/libraries/targetid.lua")
include("ttt2/libraries/playermodels.lua")
include("ttt2/libraries/entspawnscript.lua")
include("ttt2/libraries/bodysearch.lua")
include("ttt2/libraries/keyhelp.lua")
include("ttt2/libraries/loadingscreen.lua")
include("ttt2/libraries/marker_vision.lua")
include("ttt2/libraries/weaponrenderer.lua")
include("ttt2/libraries/game_effects.lua")
include("ttt2/libraries/voicebattery.lua")
include("ttt2/libraries/roleinspect.lua")

-- include ttt required files
ttt_include("sh_decal")
ttt_include("sh_lang")
ttt_include("sh_sql")
ttt_include("sh_hud_module")
ttt_include("sh_hudelement_module")
ttt_include("sh_equip_items")
ttt_include("sh_role_module")
ttt_include("sh_item_module")
ttt_include("sh_playerclass")

-- include files that need all the above
include("ttt2/libraries/migrations.lua")

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

-- Create teams
TEAM_TERROR = 1
TEAM_SPEC = TEAM_SPECTATOR

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

        if not v.defaultEquipment then
            continue
        end

        defaultEquipment[v.index] = v.defaultEquipment
    end

    return defaultEquipment
end

DefaultEquipment = {
    [0] = {},
    [1] = {},
    [2] = {},
}
