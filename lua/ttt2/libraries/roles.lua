---
-- This is the <code>roles</code> module.
-- @author Alf21
-- @author saibotk
-- @module roles

local baseclass = baseclass
local pairs = pairs
local CreateConVar = CreateConVar

if SERVER then
    AddCSLuaFile()
end

roles = {}
roles.roleList = {}

---
-- Copies any missing data from base table to the target table
-- @param table t target table
-- @param table base base (fallback) table
-- @return table t target table
-- @realm shared
local function TableInherit(t, base)
    for k, v in pairs(base) do
        if t[k] == nil then
            t[k] = v
        elseif k ~= "BaseClass" and istable(t[k]) and istable(v[k]) then
            TableInherit(t[k], v)
        end
    end

    return t
end

---
-- Checks if name is based on base
-- @param table name table to check
-- @param table base base (fallback) table
-- @return boolean returns whether name is based on base
-- @realm shared
function roles.IsBasedOn(name, base)
    local t = roles.GetStored(name)

    if not t then
        return false
    end

    if t.Base == name then
        return false
    end

    if t.Base == base then
        return true
    end

    return roles.IsBasedOn(t.Base, base)
end

---
-- Automatically generates global vars based on the role data
-- @param table roleData role table
-- @todo global vars list
-- @realm shared
local function SetupGlobals(roleData)
    Dev(1, "[TTT2][ROLE] Setting up '" .. roleData.name .. "' role...")

    local upStr = string.upper(roleData.name)

    if _G[upStr] then
        Dev(1, "[TTT2][ROLE] Overwriting already existing global '" .. upStr .. "' ...")
    end

    _G["ROLE_" .. upStr] = roleData.index
    _G[upStr] = roleData
    _G["SHOP_FALLBACK_" .. upStr] = roleData.name
end

---
-- Automatically generates ConVars based on the role data
-- @param table roleData role table
-- @todo ConVar list
-- @realm shared
local function SetupData(roleData)
    Dev(1, "[TTT2][ROLE] Adding '" .. roleData.name .. "' role...")

    local conVarData = roleData.conVarData or {}

    -- shared
    if not roleData.notSelectable and SERVER then
        ---
        -- @realm server
        CreateConVar(
            "ttt_" .. roleData.name .. "_pct",
            tostring(conVarData.pct or 1),
            { FCVAR_NOTIFY, FCVAR_ARCHIVE }
        )

        ---
        -- @realm server
        CreateConVar(
            "ttt_" .. roleData.name .. "_max",
            tostring(conVarData.maximum or 1),
            { FCVAR_NOTIFY, FCVAR_ARCHIVE }
        )

        ---
        -- @realm server
        CreateConVar(
            "ttt_" .. roleData.name .. "_min_players",
            tostring(conVarData.minPlayers or 1),
            { FCVAR_NOTIFY, FCVAR_ARCHIVE }
        )

        -- if we don't compare detective here, roles will never get assigned
        if not roleData.builtin or roleData.index == ROLE_DETECTIVE then
            ---
            -- @realm server
            CreateConVar(
                "ttt_" .. roleData.name .. "_karma_min",
                tostring(conVarData.minKarma or 0),
                { FCVAR_NOTIFY, FCVAR_ARCHIVE }
            )

            ---
            -- @realm server
            CreateConVar(
                "ttt_" .. roleData.name .. "_random",
                tostring(conVarData.random or 100),
                { FCVAR_NOTIFY, FCVAR_ARCHIVE }
            )

            ---
            -- @realm server
            CreateConVar(
                "ttt_" .. roleData.name .. "_enabled",
                "1",
                { FCVAR_NOTIFY, FCVAR_ARCHIVE }
            )
        end
    end

    ---
    -- @realm shared
    CreateConVar(
        "ttt_" .. roleData.name .. "_traitor_button",
        tostring(conVarData.traitorButton or 0),
        SERVER and { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED } or FCVAR_REPLICATED
    )

    ---
    -- @realm shared
    CreateConVar(
        "ttt2_ragdoll_pinning_" .. roleData.name,
        tostring(conVarData.ragdollPinning or 0),
        SERVER and { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED } or FCVAR_REPLICATED
    )

    if SERVER then
        ---
        -- @realm server
        CreateConVar(
            "ttt_" .. roleData.abbr .. "_credits_starting",
            tostring(conVarData.credits or 0),
            { FCVAR_NOTIFY, FCVAR_ARCHIVE }
        )

        ---
        -- @realm server
        CreateConVar(
            "ttt_" .. roleData.abbr .. "_credits_award_dead_enb",
            tostring(conVarData.creditsAwardDeadEnable or 0),
            { FCVAR_NOTIFY, FCVAR_ARCHIVE }
        )

        ---
        -- @realm server
        CreateConVar(
            "ttt_" .. roleData.abbr .. "_credits_award_kill_enb",
            tostring(conVarData.creditsAwardKillEnable or 0),
            { FCVAR_NOTIFY, FCVAR_ARCHIVE }
        )

        local shopFallbackValue

        if not conVarData.shopFallback and roleData.fallbackTable then
            shopFallbackValue = SHOP_UNSET
        else
            shopFallbackValue = conVarData.shopFallback and tostring(conVarData.shopFallback)
                or SHOP_DISABLED
        end

        ---
        -- @realm server
        SetGlobalString(
            "ttt_" .. roleData.abbr .. "_shop_fallback",
            CreateConVar(
                "ttt_" .. roleData.abbr .. "_shop_fallback",
                shopFallbackValue,
                { FCVAR_NOTIFY, FCVAR_ARCHIVE }
            ):GetString()
        )

        if conVarData.traitorKill then
            ---
            -- @realm server
            CreateConVar(
                "ttt_credits_" .. roleData.name .. "kill",
                tostring(conVarData.traitorKill),
                { FCVAR_NOTIFY, FCVAR_ARCHIVE }
            )
        end
    else -- CLIENT
        roleData.icon = roleData.icon or ("vgui/ttt/dynamic/roles/icon_" .. roleData.abbr)

        -- set a roledata icon material to prevent creating new materials each frame
        roleData.iconMaterial = Material(roleData.icon)

        -- set default colors
        roleData.dkcolor = util.ColorDarken(roleData.color, 30)
        roleData.ltcolor = util.ColorLighten(roleData.color, 30)
        roleData.bgcolor = util.ColorComplementary(roleData.color)
    end

    -- set fallback data if not already exists
    roleData.defaultTeam = roleData.defaultTeam or TEAM_NONE -- fix defaultTeam

    Dev(1, "[TTT2][ROLE] Added '" .. roleData.name .. "' role (index: " .. roleData.index .. ")")
end

---
-- Used to register your role with the engine.<br />
-- <b>This is done automatically for all the files in the <code>lua/terrortown/entities/roles</code> folder</b>
-- @param table t role table
-- @param string name role name
-- @realm shared
function roles.Register(t, name)
    name = string.lower(name)

    local old = roles.roleList[name]
    if old then
        return
    end

    t.ClassName = name
    t.name = name
    t.isAbstract = t.isAbstract or false

    if not t.isAbstract then
        -- set id
        t.index = t.index or roles.GenerateNewRoleID()

        SetupGlobals(t)

        t.id = t.index
    end

    roles.roleList[name] = t

    local upStr = string.upper(name)

    if roles[upStr] then
        ErrorNoHaltWithStack(
            "[TTT2][ROLE] Role '"
                .. name
                .. "' interferes with the 'roles' table (function or role with same name is already registered)!"
        )
    end

    roles[upStr] = t
end

---
-- All scripts have been loaded...
-- @local
-- @realm shared
function roles.OnLoaded()
    --
    -- Once all the scripts are loaded we can set up the baseclass
    -- - we have to wait until they're all setup because load order
    -- could cause some entities to load before their bases!
    --
    for k, v in pairs(roles.roleList) do
        roles.Get(k, v)

        baseclass.Set(k, v)

        if not v.isAbstract then
            v:PreInitialize()
        end
    end

    -- Setup data (eg. convars for all roles)
    for _, v in pairs(roles.roleList) do
        if not v.isAbstract then
            SetupData(v)
        end
    end

    -- Call Initialize() on all roles
    for _, v in pairs(roles.roleList) do
        if not v.isAbstract then
            v:Initialize()
        end
    end
end

---
-- Get a role by name (a copy)
-- @param string name role name
-- @param[opt] table retTbl this table will be modified and returned. If nil, a new table will be created.
-- @return table returns the modified retTbl or the new role table
-- @realm shared
function roles.Get(name, retTbl)
    local stored = roles.GetStored(name)
    if not stored then
        return
    end

    -- Create/copy a new table
    local retval = retTbl or {}

    if retval ~= stored then
        for k, v in pairs(stored) do
            retval[k] = istable(v) and table.Copy(v) or v
        end
    end

    retval.Base = retval.Base or "ttt_role_base"

    -- If we're not derived from ourselves (a base role)
    -- then derive from our 'Base' role.
    if retval.Base ~= name then
        local base = roles.Get(retval.Base)

        if not base then
            ErrorNoHaltWithStack(
                "ERROR: Trying to derive role "
                    .. tostring(name)
                    .. " from non existant role "
                    .. tostring(retval.Base)
                    .. "!\n"
            )
        else
            retval = TableInherit(retval, base)
        end
    end

    return retval
end

---
-- Gets the real role table (not a copy)
-- @param string name role name
-- @return table returns the real role table
-- @realm shared
function roles.GetStored(name)
    return roles.roleList[name]
end

---
-- Returns a list of all the registered roles
-- @return table all registered roles
-- @realm shared
function roles.GetList()
    local result = {}

    local i = 0

    for _, v in pairs(roles.roleList) do
        if not v.isAbstract then
            i = i + 1
            result[i] = v
        end
    end

    return result
end

---
-- Generates a new subrole id.
-- New roles will start at the id: <code>7</code>
-- <ul>
-- <li><code>0</code> = <code>ROLE_INNOCENT</code></li>
-- <li><code>1</code> = <code>ROLE_TRAITOR</code></li>
-- <li><code>2</code> = <code>ROLE_DETECTIVE</code></li>
-- <li><code>3</code> = <code>ROLE_NONE</code></li>
-- <li><code>4</code>, <code>5</code>, <code>6</code> = <code>nop</code></li>
-- </ul>
-- @return number new generated subrole id
-- @realm shared
function roles.GenerateNewRoleID()
    local id = 3 -- 3 nops (4, 5, 6)
    local reservedList = { "INNOCENT", "TRAITOR", "DETECTIVE", "NONE" }

    for i = 1, #reservedList do
        if not roles[reservedList[i]] then
            id = id + 1
        end
    end

    return #roles.GetList() + id
end

---
-- Get the role table by the role id
-- @param number index subrole id
-- @param[default=roles.NONE] table A fallback table that is used if the role is not found
-- @return table returns the role table. This will return the <code>NONE</code> role table as fallback.
-- @realm shared
function roles.GetByIndex(index, fallback)
    for _, v in pairs(roles.roleList) do
        if not v.isAbstract and v.index == index then
            return v
        end
    end

    return fallback or roles.NONE
end

---
-- Get the role table by the role name
-- @param string name role name
-- @return table returns the role table. This will return the <code>NONE</code> role table as fallback.
-- @realm shared
function roles.GetByName(name)
    return roles.GetStored(name) or roles.NONE
end

---
-- Get the role table by the role abbreviation
-- @param string abbr role abbreviation
-- @return table returns the role table. This will return the <code>NONE</code> role table as fallback.
-- @realm shared
function roles.GetByAbbr(abbr)
    for _, v in pairs(roles.roleList) do
        if not v.isAbstract and v.abbr == abbr then
            return v
        end
    end

    return roles.NONE
end

---
-- Automatically initializes a new role team. This will generate the global var <code>TEAM_[NAME]</code>
-- @param string name role team name
-- @param table data role team data
-- @todo data table structure
-- @realm shared
function roles.InitCustomTeam(name, data) -- creates global var "TEAM_[name]" and other required things
    name = string.Trim(name)

    local teamname = string.lower(name) .. "s"

    _G["TEAM_" .. string.upper(name)] = teamname

    data.iconMaterial = Material(data.icon)

    TEAMS[teamname] = data
end

---
-- Sorts a role table
-- @param table tbl table to sort
-- @realm shared
function roles.SortTable(tbl)
    local _func = function(a, b)
        return a.index < b.index
    end

    table.sort(tbl, _func)
end

---
-- Get a sorted list of roles that have access to a shop
-- @return table list of roles that have access to a shop
-- @realm shared
function roles.GetShopRoles()
    local shopRoles = {}

    local i = 0

    for _, v in pairs(roles.roleList) do
        if v.isAbstract or v == roles.NONE then
            continue
        end

        local shopFallback = GetGlobalString("ttt_" .. v.abbr .. "_shop_fallback")
        if shopFallback ~= SHOP_DISABLED then
            i = i + 1
            shopRoles[i] = v
        end
    end

    roles.SortTable(shopRoles)

    return shopRoles
end

---
-- Get the default role table of a specific role team
-- @param string team role team name
-- @return table returns the role table. This will return the <code>NONE</code> role table as fallback.
-- @realm shared
function roles.GetDefaultTeamRole(team)
    if team == TEAM_NONE then
        return roles.NONE
    end

    for _, v in pairs(roles.roleList) do
        if not v.isAbstract and v:IsBaseRole() and v.defaultTeam == team then
            return v
        end
    end

    return roles.NONE
end

---
-- Get the default role tables of a specific role team
-- @param string team role team name
-- @return table returns the role tables. This will return the <code>NONE</code> role table as well as its subrole tables as fallback.
-- @realm shared
function roles.GetDefaultTeamRoles(team)
    return roles.GetDefaultTeamRole(team):GetSubRoles()
end

---
-- Get a list of team members
-- @param string team role team name
-- @return table returns the member table of a role team.
-- @realm shared
function roles.GetTeamMembers(team)
    if team == TEAM_NONE or TEAMS[team].alone then
        return
    end

    local tmp = {}

    local count = 0

    local plys = player.GetAll()
    for i = 1, #plys do
        local ply = plys[i]
        if ply:GetTeam() == team then
            count = count + 1
            tmp[count] = ply
        end
    end

    return tmp
end

---
-- Get a list of all teams that are able to win
-- @return table returns a list of all teams that are able to win
-- @realm shared
function roles.GetWinTeams()
    local winTeams = {}

    local i = 0

    for _, v in pairs(roles.roleList) do
        if
            not v.isAbstract
            and v.defaultTeam ~= TEAM_NONE
            and not table.HasValue(winTeams, v.defaultTeam)
            and not v.preventWin
        then
            i = i + 1
            winTeams[i] = v.defaultTeam
        end
    end

    return winTeams
end

---
-- Get a list of all available teams
-- @return table returns a list of all available teams
-- @realm shared
function roles.GetAvailableTeams()
    local availableTeams = {}

    local i = 0

    for _, v in pairs(roles.roleList) do
        if
            not v.isAbstract
            and v.defaultTeam ~= TEAM_NONE
            and not table.HasValue(availableTeams, v.defaultTeam)
        then
            i = i + 1
            availableTeams[i] = v.defaultTeam
        end
    end

    return availableTeams
end

---
-- Get a sorted list of all roles
-- @return table returns a list of all roles
-- @realm shared
function roles.GetSortedRoles()
    local rls = {}

    local i = 0

    for _, v in pairs(roles.roleList) do
        if not v.isAbstract then
            i = i + 1
            rls[i] = v
        end
    end

    roles.SortTable(rls)

    return rls
end

---
-- Connects a SubRole with its BaseRole.
-- @note This will also set the defaultTeam variable to the BaseRole's team.
-- @param ROLE roleTable the role table (of the SubRole)
-- @param ROLE baserole the BaseRole
-- @realm shared
function roles.SetBaseRole(roleTable, baserole)
    if roleTable.baserole then
        error(
            "[TTT2][ROLE-SYSTEM][ERROR] BaseRole of "
                .. roleTable.name
                .. " already set ("
                .. roleTable.baserole
                .. ")!"
        )
    elseif roleTable.index == baserole then
        error(
            "[TTT2][ROLE-SYSTEM][ERROR] BaseRole "
                .. roleTable.name
                .. " can't be a baserole of itself!"
        )
    else
        local br = roles.GetByIndex(baserole)

        if br.baserole then
            error(
                "[TTT2][ROLE-SYSTEM][ERROR] Your requested BaseRole can't be any BaseRole of another SubRole because it's a SubRole as well."
            )

            return
        end

        roleTable.baserole = baserole
        roleTable.defaultTeam = br.defaultTeam

        Dev(
            1,
            "[TTT2][ROLE-SYSTEM] Connected '"
                .. roleTable.name
                .. "' subrole with baserole '"
                .. br.name
                .. "'"
        )
    end
end
