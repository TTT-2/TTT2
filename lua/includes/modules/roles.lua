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

--[[---------------------------------------------------------
	Name: Register( table, string )
	Desc: Used to register your role with the engine
-----------------------------------------------------------]]
function Register(t, name)
	name = string.lower(name)

	local old = RoleList[name]

	t.ClassName = name
	t.id = name

	RoleList[name] = t

	list.Set("Roles", name, {
			ClassName = name,
			id = name
	})

	--
	-- If we're reloading this entity class
	-- then refresh all the existing entities.
	--
	if old ~= nil then

		--
		-- For each entity using this class
		--
		for _, entity in ipairs(ents.FindByClass(name)) do

			--
			-- Replace the contents with this entity table
			--
			table.Merge(entity, t)

			--
			-- Call OnReloaded hook (if it has one)
			--
			if isfunction(entity.OnReloaded) then
				entity:OnReloaded()
			end
		end

		-- Update roles table of entities that are based on this role
		for _, e in ipairs(ents.GetAll()) do
			if IsBasedOn(e:GetClass(), name) then
				table.Merge(e, Get(e:GetClass()))

				if isfunction(e.OnReloaded) then
					e:OnReloaded()
				end
			end
		end
	end
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
	for k in pairs(RoleList) do
		local newTable = Get(k)
		RoleList[k] = newTable

		baseclass.Set(k, newTable)
	end

	if CLIENT then
		-- Call PreInitialize on all roles
		for _, v in pairs(RoleList) do
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

	for k, v in pairs(Stored) do
		if istable(v) then
			retval[k] = table.Copy(v)
		else
			retval[k] = v
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
		result[#result + 1] = v
	end

	return result
end

function GetRoleByIndex(index)
	for _, v in pairs(RoleList) do
		if v.index == index then
			return v
		end
	end

	return INNOCENT
end

function GetRoleByName(name)
	for _, v in pairs(RoleList) do
		if v.name == name then
			return v
		end
	end

	return INNOCENT
end

function GetRoleByAbbr(abbr)
	for _, v in pairs(RoleList) do
		if v.abbr == abbr then
			return v
		end
	end

	return INNOCENT
end
