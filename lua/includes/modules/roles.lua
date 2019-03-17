local baseclass = baseclass
local list = list
local pairs = pairs
local ipairs = ipairs

module("roles", package.seeall)

if SERVER then
	AddCSLuaFile()
end

local BASE_ROLE_CLASS = "ttt_role_base"

local RoleList = RoleList or {}

--[[---------------------------------------------------------
	Name: TableInherit( t, base )
	Desc: Copies any missing data from base to t
-----------------------------------------------------------]]
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

--[[---------------------------------------------------------
	Name: IsBasedOn( name, base )
	Desc: Checks if name is based on base
-----------------------------------------------------------]]
function IsBasedOn(name, base)
	local t = GetStored(name)

	if not t then
		return false
	end

	if t.Base == name then
		return false
	end

	if t.Base == base then
		return true
	end

	return IsBasedOn(t.Base, base)
end

local function SetupGlobals(roleData)
	print("[TTT2][ROLE] Setting up '" .. roleData.name .. "' role...")
	local upStr = string.upper(roleData.name)

	_G["ROLE_" .. upStr] = roleData.index
	_G[upStr] = roleData
	_G["SHOP_FALLBACK_" .. upStr] = roleData.name

	local plymeta = FindMetaTable("Player")
	if plymeta then
		-- e.g. IsJackal() will match each subrole of the jackal as well as the jackal as the baserole
		plymeta["Is" .. roleData.name:gsub("^%l", string.upper)] = function(slf)
			local br = slf:GetBaseRole()
			local sr = slf:GetSubRole()

			return roleData.baserole and sr == roleData.index or not roleData.baserole and br == roleData.index
		end
	end
end

local function SetupData(roleData)
	print("[TTT2][ROLE] Adding '" .. roleData.name .. "' role...")

	local conVarData = roleData.conVarData or {}

	-- shared
	if not roleData.notSelectable then
		if conVarData.togglable then
			CreateClientConVar("ttt_avoid_" .. roleData.name, "0", true, true)
		end

		CreateConVar("ttt_" .. roleData.name .. "_pct", tostring(conVarData.pct or 1), {FCVAR_NOTIFY, FCVAR_ARCHIVE})
		CreateConVar("ttt_" .. roleData.name .. "_max", tostring(conVarData.maximum or 1), {FCVAR_NOTIFY, FCVAR_ARCHIVE})
		CreateConVar("ttt_" .. roleData.name .. "_min_players", tostring(conVarData.minPlayers or 1), {FCVAR_NOTIFY, FCVAR_ARCHIVE})

		if conVarData.minKarma then
			CreateConVar("ttt_" .. roleData.name .. "_karma_min", tostring(conVarData.minKarma), {FCVAR_NOTIFY, FCVAR_ARCHIVE})
		end

		if not roleData.buildin then
			CreateConVar("ttt_" .. roleData.name .. "_random", tostring(conVarData.random or 100), {FCVAR_NOTIFY, FCVAR_ARCHIVE})

			CreateConVar("ttt_" .. roleData.name .. "_enabled", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
		end
	end

	CreateConVar("ttt_" .. roleData.abbr .. "_credits_starting", tostring(conVarData.credits or 0), {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt_" .. roleData.abbr .. "_credits_traitorkill", tostring(conVarData.creditsTraitorKill or 0), {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	CreateConVar("ttt_" .. roleData.abbr .. "_credits_traitordead", tostring(conVarData.creditsTraitorDead or 0), {FCVAR_NOTIFY, FCVAR_ARCHIVE})

	local shopFallbackValue

	if not conVarData.shopFallback and roleData.fallbackTable then
		shopFallbackValue = SHOP_UNSET
	else
		shopFallbackValue = conVarData.shopFallback and tostring(conVarData.shopFallback) or SHOP_DISABLED
	end

	SetGlobalString("ttt_" .. roleData.abbr .. "_shop_fallback", CreateConVar("ttt_" .. roleData.abbr .. "_shop_fallback", shopFallbackValue, {FCVAR_NOTIFY, FCVAR_ARCHIVE}):GetString())

	if conVarData.traitorKill then
		CreateConVar("ttt_credits_" .. roleData.name .. "kill", tostring(conVarData.traitorKill), {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	end

	-- fix defaultTeam
	roleData.defaultTeam = roleData.defaultTeam or TEAM_NONE

	print("[TTT2][ROLE] Added '" .. roleData.name .. "' role (index: " .. roleData.index .. ")")
end

--[[---------------------------------------------------------
	Name: Register( table, string )
	Desc: Used to register your role with the engine
-----------------------------------------------------------]]
function Register(t, name)
	name = string.lower(name)

	local old = RoleList[name]
	if old then return end

	t.ClassName = name
	t.name = name

	if name ~= BASE_ROLE_CLASS then
		-- set id
		t.index = t.index or GenerateNewRoleID()

		SetupGlobals(t)

		t.id = t.index
	end

	RoleList[name] = t

	list.Set("Roles", name, {
			ClassName = name,
			name = name,
			id = t.index
	})
end

--
-- All scripts have been loaded...
--
function OnLoaded()

	--
	-- Once all the scripts are loaded we can set up the baseclass
	-- - we have to wait until they're all setup because load order
	-- could cause some entities to load before their bases!
	--
	for k, v in pairs(RoleList) do
		Get(k, v)

		baseclass.Set(k, v)

		if k ~= BASE_ROLE_CLASS then
			SetupData(v)
		end
	end

	-- Call PreInitialize on all roles
	for _, v in pairs(RoleList) do
		if v.name ~= BASE_ROLE_CLASS then
			v:PreInitialize()
		end
	end
end

--[[---------------------------------------------------------
	Name: Get( string, retTbl )
	Desc: Get a role by name.
-----------------------------------------------------------]]
function Get(name, retTbl)
	local Stored = GetStored(name)
	if not Stored then return end

	-- Create/copy a new table
	local retval = retTbl or {}

	if retval ~= Stored then
		for k, v in pairs(Stored) do
			if istable(v) then
				retval[k] = table.Copy(v)
			else
				retval[k] = v
			end
		end
	end

	retval.Base = retval.Base or BASE_ROLE_CLASS

	-- If we're not derived from ourselves (a base role)
	-- then derive from our 'Base' role.
	if retval.Base ~= name then
		local base = Get(retval.Base)

		if not base then
			Msg("ERROR: Trying to derive role " .. tostring(name) .. " from non existant role " .. tostring(retval.Base) .. "!\n")
		else
			retval = TableInherit(retval, base)
		end
	end

	return retval
end

--[[---------------------------------------------------------
	Name: GetStored( string )
	Desc: Gets the REAL HUD elements table, not a copy
-----------------------------------------------------------]]
function GetStored(name)
	return RoleList[name]
end

--[[---------------------------------------------------------
	Name: GetList( string )
	Desc: Get a list (copy) of all the registered roles
-----------------------------------------------------------]]
function GetList()
	local result = {}

	for _, v in pairs(RoleList) do
		if v.name ~= BASE_ROLE_CLASS then
			result[#result + 1] = v
		end
	end

	return result
end

function GenerateNewRoleID()
	-- start with "1" to prevent incompatibilities with ROLE_ANY => new roles will start @ id: i(1)+3=4
	-- edit: add 3 more nop (1+3=4) to use it later -> new roles will start @ id: i(4)+3=7
	return 4 + #GetList()
end

function GetByIndex(index)
	for _, v in pairs(RoleList) do
		if v.name ~= BASE_ROLE_CLASS and v.index == index then
			return v
		end
	end

	return INNOCENT
end

function GetByName(name)
	return GetStored(name) or INNOCENT
end

function GetByAbbr(abbr)
	for _, v in pairs(RoleList) do
		if v.name ~= BASE_ROLE_CLASS and v.abbr == abbr then
			return v
		end
	end

	return INNOCENT
end

function InitCustomTeam(name, data) -- creates global var "TEAM_[name]" and other required things
	local teamname = string.Trim(string.lower(name)) .. "s"

	_G["TEAM_" .. string.upper(name)] = teamname

	TEAMS[teamname] = data
end

function SortTable(tbl)
	local _func = function(a, b)
		return a.index < b.index
	end

	table.sort(tbl, _func)
end

function GetShopRoles()
	local shopRoles = {}

	local i = 0

	for _, v in pairs(RoleList) do
		if v.name ~= BASE_ROLE_CLASS and v ~= INNOCENT then
			local shopFallback = GetGlobalString("ttt_" .. v.abbr .. "_shop_fallback")
			if shopFallback ~= SHOP_DISABLED then
				i = i + 1
				shopRoles[i] = v
			end
		end
	end

	SortTable(shopRoles)

	return shopRoles
end

function GetDefaultTeamRole(team)
	if team == TEAM_NONE then return end

	for _, v in pairs(RoleList) do
		if v.name ~= BASE_ROLE_CLASS and not v.baserole and v.defaultTeam ~= TEAM_NONE and v.defaultTeam == team then
			return v
		end
	end

	return INNOCENT
end

function GetDefaultTeamRoles(team)
	if team == TEAM_NONE then return end

	return GetDefaultTeamRole(team):GetSubRoles()
end

function GetTeamMembers(team)
	if team == TEAM_NONE or TEAMS[team].alone then return end

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

	for _, v in pairs(RoleList) do
		if v.name ~= BASE_ROLE_CLASS and v.defaultTeam ~= TEAM_NONE and not table.HasValue(winTeams, v.defaultTeam) and not v.preventWin then
			table.insert(winTeams, v.defaultTeam)
		end
	end

	return winTeams
end

function GetAvailableTeams()
	local availableTeams = {}

	for _, v in pairs(RoleList) do
		if v.name ~= BASE_ROLE_CLASS and v.defaultTeam ~= TEAM_NONE and not table.HasValue(availableTeams, v.defaultTeam) then
			availableTeams[#availableTeams + 1] = v.defaultTeam
		end
	end

	return availableTeams
end

function GetSortedRoles()
	local rls = {}

	local i = 0

	for _, v in pairs(RoleList) do
		if v.name ~= BASE_ROLE_CLASS then
			i = i + 1
			rls[i] = v
		end
	end

	SortTable(rls)

	return rls
end
