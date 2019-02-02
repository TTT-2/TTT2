local baseclass = baseclass
local list = list
local duplicator = duplicator
local pairs = pairs

if SERVER then
	AddCSLuaFile()
end

module("hudelements", package.seeall)

local HUDElementList = HUDElementList or {}

--[[---------------------------------------------------------
	Name: TableInherit( t, base )
	Desc: Copies any missing data from base to t
-----------------------------------------------------------]]
local function TableInherit(t, base)
	for k, v in pairs(base) do
		if t[k] == nil then
			t[k] = v
		elseif k ~= "BaseClass" and istable(t[k]) then
			TableInherit(t[k], v)
		end
	end

	t.BaseClass = base

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
	Desc: Used to register your HUD Element with the engine
-----------------------------------------------------------]]
function Register(t, name)
	if not t.type then return end

	name = string.lower(name)

	local old = HUDElementList[name]

	t.ClassName = name
	t.id = name

	HUDElementList[name] = t

	list.Set("HUDElement", name, {
			ClassName = name,
			id = name
	})

	-- Allow all HUD Elements to be duplicated, unless specified
	if not t.DisableDuplicator then
		duplicator.Allow(name)
	end

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

--
-- All scripts have been loaded...
--
function OnLoaded()

	--
	-- Once all the scripts are loaded we can set up the baseclass
	-- - we have to wait until they're all setup because load order
	-- could cause some entities to load before their bases!
	--
	for k in pairs(HUDElementList) do
		local newTable = Get(k)
		HUDElementList[k] = newTable

		baseclass.Set(k, newTable)
	end
end

--[[---------------------------------------------------------
	Name: Get( string, retTbl )
	Desc: Get a HUD element by name.
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

	retval.Base = retval.Base or "hud_element_base"

	-- If we're not derived from ourselves (a base HUD element)
	-- then derive from our 'Base' HUD element.
	if retval.Base ~= name then
		local base = Get(retval.Base)

		if not base then
			Msg("ERROR: Trying to derive HUD Element " .. tostring(name) .. " from non existant HUD Element " .. tostring(retval.Base) .. "!\n")
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
	return HUDElementList[name]
end

--[[---------------------------------------------------------
	Name: GetList( string )
	Desc: Get a list (copy) of all the registered HUD elements
-----------------------------------------------------------]]
function GetList()
	local result = {}

	for _, v in pairs(HUDElementList) do
		result[#result + 1] = v
	end

	return result
end
