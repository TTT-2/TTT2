---
-- This is the <code>huds</code> module
-- @author Alf21
-- @author saibotk
module("huds", package.seeall)

local baseclass = baseclass
local list = list
local pairs = pairs

if SERVER then
	AddCSLuaFile()
end

local HUDList = HUDList or {}

---
-- Copies any missing data from base table to the target table
-- @tab t target table
-- @tab base base (fallback) table
-- @treturn table t target table
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
-- @tab name table to check
-- @tab base base (fallback) table
-- @treturn boolean returns whether name is based on base
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

---
-- Used to register your hud with the engine
-- @tab t hud table
-- @str name hud name
function Register(t, name)
	name = string.lower(name)

	local old = HUDList[name]

	t.ClassName = name
	t.id = name
	t.isAbstract = t.isAbstract or false

	HUDList[name] = t

	list.Set("HUD", name, {
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

		-- Update HUD table of entities that are based on this HUD
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

---
-- All scripts have been loaded...
-- @local
function OnLoaded()

	--
	-- Once all the scripts are loaded we can set up the baseclass
	-- - we have to wait until they're all setup because load order
	-- could cause some entities to load before their bases!
	--
	for k in pairs(HUDList) do
		local newTable = Get(k)
		HUDList[k] = newTable

		baseclass.Set(k, newTable)
	end
end

---
-- Get an hud by name (a copy)
-- @str name hud name
-- @tparam[opt] ?table retTbl this table will be modified and returned. If nil, a new table will be created.
-- @treturn table returns the modified retTbl or the new hud table
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

	retval.Base = retval.Base or "hud_base"

	-- If we're not derived from ourselves (a base HUD element)
	-- then derive from our 'Base' HUD element.
	if retval.Base ~= name then
		local base = Get(retval.Base)

		if not base then
			Msg("ERROR: Trying to derive HUD " .. tostring(name) .. " from non existant HUD " .. tostring(retval.Base) .. "!\n")
		else
			retval = TableInherit(retval, base)
		end
	end

	return retval
end

---
-- Gets the real hud table (not a copy)
-- @str name hud name
-- @treturn table returns the real hud table
function GetStored(name)
	return HUDList[name]
end

---
-- Get a list (copy) of all registered huds, that can be displayed (no abstract HUDs).
-- @treturn table available huds
function GetList()
	local result = {}

	for _, v in pairs(HUDList) do
		if not v.isAbstract then
			result[#result + 1] = v
		end
	end

	return result
end

---
-- Get a list (copy) of all the registered HUDs including abstract HUDs.
-- @treturn table all registered huds
function GetRealList()
	local result = {}

	for _, v in pairs(HUDList) do
		result[#result + 1] = v
	end

	return result
end
