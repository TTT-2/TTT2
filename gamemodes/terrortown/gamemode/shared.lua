GM.Name = "[TTT2] Trouble in Terrorist Town 2 (Advanced Update) - by Alf21"
GM.Author = "Bad King Urgrain && Alf21"
GM.Email = "thegreenbunny@gmail.com, 4lf-mueller@gmx.de"
GM.Website = "ttt.badking.net, ttt2.informaskill.de"
-- Date of latest changes (YYYY-MM-DD)
GM.Version = "2018-03-27"

GM.Customized = true

-- Round status consts
ROUND_WAIT   = 1
ROUND_PREP   = 2
ROUND_ACTIVE = 3
ROUND_POST   = 4

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
  index = 1,
  color = Color(55, 170, 50, 255),
  dkcolor = Color(60, 160, 50, 155),
  bgcolor = Color(0, 50, 0, 200),
  name = "innocent",
  printName = "Innocent", -- theoretically not needed ! Translated through lang functions of TTT |- TODO remove
  abbr = "inno",
  shop = false,
  team = TEAM_INNO,
  defaultEquipment = INNO_EQUIPMENT,
  buildin = true,
  scoreKillsMultiplier = 1,
  scoreTeamKillsMultiplier = -8
}

ROLES.TRAITOR = {
  index = 2,
  color = Color(180, 50, 40, 255),
  dkcolor = Color(160, 50, 60, 155),
  bgcolor = Color(150, 0, 0, 200),
  name = "traitor",
  printName = "Traitor",
  abbr = "traitor",
  shop = true,
  team = TEAM_TRAITOR,
  defaultEquipment = TRAITOR_EQUIPMENT,
  visibleForTraitors = true, -- just for a better performance
  buildin = true,
  surviveBonus = 0.5,
  scoreKillsMultiplier = 5,
  scoreTeamKillsMultiplier = -16
}

ROLES.DETECTIVE = {
  index = 3,
  color = Color(50, 60, 180, 255),
  dkcolor = Color(50, 60, 160, 155),
  bgcolor = Color(0, 0, 150, 200),
  name = "detective",
  printName = "Detective",
  abbr = "det",
  shop = true,
  team = TEAM_INNO,
  defaultEquipment = SPECIAL_EQUIPMENT,
  buildin = true,
  scoreKillsMultiplier = ROLES.INNOCENT.scoreKillsMultiplier,
  scoreTeamKillsMultiplier = ROLES.INNOCENT.scoreTeamKillsMultiplier
}

-- TODO: export into another file !
CreateConVar("ttt_detective_enabled", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE)
CreateConVar("ttt_newroles_enabled", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE)

-- you should only use this function to add roles to TTT2
function AddCustomRole(name, roleData, conVarData)
    -- shared
    if not ROLES[name] and not roleData.notSelectable then
        if conVarData.togglable then
            CreateClientConVar("ttt_avoid_" .. roleData.name, "0", true, true)
        end
        
        CreateConVar("ttt_" .. roleData.name .. "_pct", tostring(conVarData.pct), FCVAR_NOTIFY + FCVAR_ARCHIVE + FCVAR_REPLICATED)
        CreateConVar("ttt_" .. roleData.name .. "_max", tostring(conVarData.maximum), FCVAR_ARCHIVE + FCVAR_REPLICATED)
        CreateConVar("ttt_" .. roleData.name .. "_min_players", tostring(conVarData.minPlayers), FCVAR_ARCHIVE + FCVAR_REPLICATED)
        
        if conVarData.random then
            CreateConVar("ttt_" .. roleData.name .. "_random", tostring(conVarData.random), FCVAR_ARCHIVE + FCVAR_REPLICATED)
        else
            CreateConVar("ttt_" .. roleData.name .. "_random", "100", FCVAR_ARCHIVE + FCVAR_REPLICATED)
        end
        
        CreateConVar("ttt_" .. roleData.name .. "_enabled", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE + FCVAR_REPLICATED)
        
        if conVarData.credits then
            CreateConVar("ttt_" .. roleData.abbr .. "_credits_starting", tostring(conVarData.credits), FCVAR_ARCHIVE + FCVAR_REPLICATED)
        end
        
        if conVarData.creditsTraitorKill then
            CreateConVar("ttt_" .. roleData.abbr .. "_credits_traitorkill", tostring(conVarData.creditsTraitorKill), FCVAR_ARCHIVE + FCVAR_REPLICATED)
        end
        
        if conVarData.creditsTraitorDead then
            CreateConVar("ttt_" .. roleData.abbr .. "_credits_traitordead", tostring(conVarData.creditsTraitorDead), FCVAR_ARCHIVE + FCVAR_REPLICATED)
        end
    end
    
    -- client
    ---- empty
    
    -- server
    if SERVER then
    
        -- necessary to init roles in this way, because we need to wait until the ROLES array is initialized 
	    -- and every important function works properly
	    hook.Add("TTT2_RoleInit", "Add_" .. roleData.abbr .. "_Role", function() -- unique hook identifier please
		    if not ROLES[name] then -- count ROLES
                local i = 1 -- start at 1 to directly get free slot
                
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

function UpdateCustomRole(name, roleData)
    if SERVER and ROLES[name] then
        -- necessary for networking!
        roleData.name = ROLES[name].name
        
        table.Merge(ROLES[name], roleData)
        
        for _, v in pairs(player.GetAll()) do
            UpdateSingleRoleData(roleData, v)
        end
    end
end

-- if you add roles that can shop, modify DefaultEquipment at the end of this file
-- TODO combine DefaultEquipment[x] and ROLES[x] !

-- override default settings of ttt to make it compatible with other addons
-- Player roles
ROLE_NONE       = 0
ROLE_INNOCENT  	= ROLES.INNOCENT.index
ROLE_TRAITOR   	= ROLES.TRAITOR.index
ROLE_DETECTIVE 	= ROLES.DETECTIVE.index

function SortRolesTable(tbl)
    table.sort(tbl, function(a, b)
       return (a.index < b.index)
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
        if v.shop then
            i = i + 1
            shopRoles[i] = v
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

function GetTeamRoles(team)
    local teamRoles = {}
    
    local i = 0
    
    for _, v in pairs(ROLES) do
        if v.team ~= nil and v.team == team then
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

function table.Randomize(t)
    local out = {}
	
	while #t > 0 do
        table.insert(out, table.remove(t, math.random(#t)))
	end
    
    t = out
end

-- Game event log defs
EVENT_KILL        = 1
EVENT_SPAWN       = 2
EVENT_GAME        = 3
EVENT_FINISH      = 4
EVENT_SELECTED    = 5
EVENT_BODYFOUND   = 6
EVENT_C4PLANT     = 7
EVENT_C4EXPLODE   = 8
EVENT_CREDITFOUND = 9
EVENT_C4DISARM    = 10

WIN_NONE          = 1
WIN_ROLE          = 2
WIN_TIMELIMIT     = 3
WIN_BEES          = 4

-- Weapon categories, you can only carry one of each
WEAPON_NONE   = 0
WEAPON_MELEE  = 1
WEAPON_PISTOL = 2
WEAPON_HEAVY  = 3
WEAPON_NADE   = 4
WEAPON_CARRY  = 5
WEAPON_EQUIP1 = 6
WEAPON_EQUIP2 = 7
WEAPON_ROLE   = 8

WEAPON_EQUIP = WEAPON_EQUIP1
WEAPON_UNARMED = -1

-- Kill types discerned by last words
KILL_NORMAL  = 0
KILL_SUICIDE = 1
KILL_FALL    = 2
KILL_BURN    = 3

-- Entity types a crowbar might open
OPEN_NO   = 0
OPEN_DOOR = 1
OPEN_ROT  = 2
OPEN_BUT  = 3
OPEN_NOTOGGLE = 4 --movelinear

-- Mute types
MUTE_NONE = 0
MUTE_TERROR = 1
MUTE_ALL = 2
MUTE_SPEC = 1002

COLOR_WHITE  = Color(255, 255, 255, 255)
COLOR_BLACK  = Color(0, 0, 0, 255)
COLOR_GREEN  = Color(0, 255, 0, 255)
COLOR_DGREEN = Color(0, 100, 0, 255)
COLOR_RED    = Color(255, 0, 0, 255)
COLOR_YELLOW = Color(200, 200, 0, 255)
COLOR_LGRAY  = Color(200, 200, 200, 255)
COLOR_BLUE   = Color(0, 0, 255, 255)
COLOR_NAVY   = Color(0, 0, 100, 255)
COLOR_PINK   = Color(255,0,255, 255)
COLOR_ORANGE = Color(250, 100, 0, 255)
COLOR_OLIVE  = Color(100, 100, 0, 255)

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

function GetRandomPlayerModel()
   return table.Random(ttt_playermodels)
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

CreateConVar("ttt_playercolor_mode", "1")
function GM:TTTPlayerColor(model)
   local mode = GetConVarNumber("ttt_playercolor_mode") or 0
   
   if mode == 1 then
      return table.Random(ttt_playercolors.serious)
   elseif mode == 2 then
      return table.Random(ttt_playercolors.all)
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

-- Weapons and items that come with TTT. Weapons that are not in this list will
-- get a little marker on their icon if they're buyable, showing they are custom
-- and unique to the server.
function GetDefaultEquipment()
   local defaultEquipment = {}

   for _, v in pairs(ROLES) do
      if v.defaultEquipment ~= nil then
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
