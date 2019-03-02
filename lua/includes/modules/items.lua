local baseclass = baseclass
local list = list
local pairs = pairs

module("items", package.seeall)

if SERVER then
	AddCSLuaFile()
end

local ItemList = ItemList or {}

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
	Name: Register( table, string, bool )
	Desc: Used to register your ITEM with the engine
-----------------------------------------------------------]]
function Register(t, name)
	name = string.lower(name)

	local old = ItemList[name]

	t.ClassName = name
	t.id = name

	ItemList[name] = t

	list.Set("Item", name, {
			ClassName = name,
			id = name,
			PrintName = t.PrintName or t.ClassName,
			Category = t.Category or "Other",
			Spawnable = t.Spawnable,
			AdminOnly = t.AdminOnly,
			ScriptedEntityType = t.ScriptedEntityType
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

		-- Update ITEM table of entities that are based on this ITEM
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
	for k in pairs(ItemList) do
		local newTable = Get(k)
		ItemList[k] = newTable

		baseclass.Set(k, newTable)
	end
end

--[[---------------------------------------------------------
	Name: Get( string )
	Desc: Get a item by name.
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

	retval.Base = retval.Base or "item_base"

	-- If we're not derived from ourselves (a base item)
	-- then derive from our 'Base' item.
	if retval.Base ~= name then
		local base = Get(retval.Base)

		if not base then
			Msg("ERROR: Trying to derive item " .. tostring(name) .. " from non existant ITEM " .. tostring(retval.Base) .. "!\n")
		else
			retval = TableInherit(retval, base)
		end
	end

	return retval
end

--[[---------------------------------------------------------
	Name: GetStored( string )
	Desc: Gets the REAL item table, not a copy
-----------------------------------------------------------]]
function GetStored(name)
	return ItemList[name]
end

--[[---------------------------------------------------------
	Name: GetList( string )
	Desc: Get a list of all the registered ITEMs
-----------------------------------------------------------]]
function GetList()
	local result = {}

	for _, v in pairs(ItemList) do
		result[#result + 1] = v
	end

	return result
end

--[[---------------------------------------------------------
	Name: IsItem( val )
	Desc: checks whether the input is an ITEM
-----------------------------------------------------------]]
function IsItem(val)
	if not val then
		return false
	end

	local tmp = val

	if tonumber(val) then
		for _, item in pairs(ItemList) do
			if item.oldId and item.oldId == val then
				return true
			end
		end
	elseif not isstring(val) and (IsValid(val) or istable(val)) then
		tmp = WEPS.GetClass(val)
	end

	return items.GetStored(tmp) ~= nil
end

--[[---------------------------------------------------------
	Name: TableHasItem( val )
	Desc: checks whether the input table has a specific ITEM
-----------------------------------------------------------]]
function TableHasItem(tbl, val)
	if not tbl or not val then
		return false
	end

	local tmp = val

	if not isstring(val) then
		if tonumber(val) then -- still support the old item system
			for _, item in pairs(ItemList) do
				if item.oldId and item.oldId == val then
					tmp = item.id

					break
				end
			end
		elseif IsValid(val) or istable(val) then
			tmp = WEPS.GetClass(val)
		end
	end

	return table.HasValue(tbl, tmp)
end

--[[---------------------------------------------------------
	Name: GetRoleItems( subrole )
	Desc: get all items for this role
-----------------------------------------------------------]]
function GetRoleItems(subrole)
	local itms = GetList()
	local tbl = {}

	for _, item in ipairs(itms) do
		if item and item.CanBuy and table.HasValue(item.CanBuy, subrole) then
			tbl[#tbl + 1] = item
		end
	end

	return tbl
end

--[[---------------------------------------------------------
	Name: GetRoleItem( subrole, id )
	Desc: get a role item if it's available for this role
-----------------------------------------------------------]]
function GetRoleItem(subrole, id)
	if tonumber(id) then
		for _, item in pairs(ItemList) do
			if item.oldId and item.oldId == id then
				id = item.id

				break
			end
		end

		if tonumber(id) then return end
	end

	local item = GetStored(id)

	if item and item.CanBuy and table.HasValue(item.CanBuy, subrole) then
		return item
	end
end
