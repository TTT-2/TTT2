---
-- This is the <code>hudelements</code> module
-- @author Alf21
-- @author saibotk
module("hudelements", package.seeall)

local baseclass = baseclass
local list = list
local pairs = pairs

if SERVER then
	AddCSLuaFile()
end

local HUDElementList = HUDElementList or {}

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
-- Used to register your hud element with the engine.<br />
-- <b>This is done automatically for all the files in the <code>gamemodes/terrortown/gamemode/shared/hudelements</code> folder</b>
-- @tab t hud element table
-- @str name hud element name
function Register(t, name)
	name = string.lower(name)

	local old = HUDElementList[name]

	t.ClassName = name
	t.id = name

	HUDElementList[name] = t

	list.Set("HUDElement", name, {
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
	for k in pairs(HUDElementList) do
		local newTable = Get(k)
		HUDElementList[k] = newTable

		baseclass.Set(k, newTable)
	end

	if CLIENT then
		-- Call PreInitialize on all hudelements
		for _, v in pairs(HUDElementList) do
			v:PreInitialize()
		end
	end
end

---
-- Get an hud element by name (a copy)
-- @str name hud element name
-- @tparam[opt] ?table retTbl this table will be modified and returned. If nil, a new table will be created.
-- @treturn table returns the modified retTbl or the new hud element table
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

---
-- Gets the real hud element table (not a copy)
-- @str name hud element name
-- @treturn table returns the real hud element table
function GetStored(name)
	return HUDElementList[name]
end

---
-- Get a list (copy) of all registered hud elements
-- @treturn table registered hud elements
function GetList()
	local result = {}

	for _, v in pairs(HUDElementList) do
		result[#result + 1] = v
	end

	return result
end

---
-- Get a list of all the registered hud element types
-- @treturn table returns a list of all the registered hud element types
function GetElementTypes()
	local typetbl = {}

	for _, v in pairs(HUDElementList) do
		if v.type and not table.HasValue(typetbl, v.type) then
			table.insert(typetbl, v.type)
		end
	end

	return typetbl
end

---
-- Gets the first element matching the type of all the registered hud elements
-- @str type the hud element's type name
-- @treturn nil|table returns the first element matching the type of all the registered hud elements
-----------------------------------------------------------]]
function GetTypeElement(type)
	for _, v in pairs(HUDElementList) do
		if v.type and v.type == type then
			return v
		end
	end
end

---
-- Gets all hud elements matching the type of all the registered hud elements
-- @str type the hud element's type name
-- @treturn table returns all hud elements matching the type of all the registered hud elements
function GetAllTypeElements(type)
	local retTbl = {}

	for _, v in pairs(HUDElementList) do
		if v.type and v.type == type then
			table.insert(retTbl, v)
		end
	end

	return retTbl
end

---
-- <p>Sets the child relation on all objects that have to be informed / are involved.</p>
-- <p>This can either be a single parent <-> child relation or a parents <-> child relation,
-- if the parent is a type. This function then will register the childid as a child to all elements with that type.</p>
-- <p>A parent element is responsible for calling PerformLayout on its child elements!</p>
-- <p><b>!! This should be called in the <code>PreInitialize</code> method !!</b></p>
--
-- @int childid child hud element name
-- @int parentid parent hud element name
-- @bool parent_is_type whether the parent is a type
-- @todo example / usage
function RegisterChildRelation(childid, parentid, parent_is_type)
	local child = GetStored(childid)
	if not child then
		MsgN("Error: Cannot add child " .. childid .. " to " .. parentid .. ". child element instance was not found or registered yet!")

		return
	end

	if not parent_is_type then
		local parent = GetStored(parentid)
		if not parent then
			MsgN("Error: Cannot add child " .. childid .. " to " .. parentid .. ". parent element was not found or registered yet!")

			return
		end

		parent:AddChild(childid)
	else
		local elems = GetAllTypeElements(parentid)

		for elem in ipairs(elems) do
			elem:AddChild(childid)
		end
	end

	child:SetParentRelation(parentid, parent_is_type)
end
