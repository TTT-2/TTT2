---
-- This is the <code>items</code> module
-- @author Alf21
-- @author saibotk

module("items", package.seeall)

local baseclass = baseclass
local pairs = pairs

if SERVER then
	AddCSLuaFile()
end

local ItemList = ItemList or {}

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
		elseif k ~= "BaseClass" and istable(t[k]) then
			TableInherit(t[k], v)
		end
	end

	t.BaseClass = base

	return t
end

---
-- Checks if name is based on base
-- @param table name table to check
-- @param table base base (fallback) table
-- @return boolean returns whether name is based on base
-- @realm shared
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
-- Used to register your item with the engine.<br />
-- <b>This is done automatically for all the files in the <code>lua/terrortown/entities/items</code> folder</b>
-- @param table t item table
-- @param string name item name
-- @realm shared
function Register(t, name)
	name = string.lower(name)

	t.ClassName = name
	t.id = name

	ItemList[name] = t
end


---
-- All scripts have been loaded...
-- @local
-- @realm shared
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

---
-- Get an item by name (a copy)
-- @param string name item name
-- @param[opt] ?table retTbl this table will be modified and returned. If nil, a new table will be created.
-- @return table returns the modified retTbl or the new item table
-- @realm shared
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
			Msg("ERROR: Trying to derive item " .. tostring(name) .. " from non existant item " .. tostring(retval.Base) .. "!\n")
		else
			retval = TableInherit(retval, base)
		end
	end

	return retval
end

---
-- Gets the real item table (not a copy)
-- @param string name item name
-- @return table returns the real item table
-- @realm shared
function GetStored(name)
	return ItemList[name]
end


---
-- Get a list of all the registered items
-- @return table all registered items
-- @realm shared
function GetList()
	local result = {}

	for _, v in pairs(ItemList) do
		result[#result + 1] = v
	end

	return result
end

---
-- Checks whether the input is an item
-- @param string|table|number val item name / table / id
-- @return boolean returns true if the inserted table is an item
-- @realm shared
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

---
-- Checks whether the input table has a specific item.<br />
-- This is calling @{table.HasValue} internally,
-- but you don't have to tackle with the input value (<code>val</code>) type
-- @param table tbl target table
-- @param string|table|number val item name / table / id
-- @return boolean whether the input table has a specific item
-- @realm shared
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

---
-- Get all items for this role
-- @param number subrole subrole id
-- @return table role items table
-- @realm shared
function GetRoleItems(subrole)
	local itms = GetList()
	local tbl = {}

	for i = 1, #itms do
		local item = itms[i]

		if item and item.CanBuy and table.HasValue(item.CanBuy, subrole) then
			tbl[#tbl + 1] = item
		end
	end

	return tbl
end

---
-- Get a role item if it's available for this role
-- @param number subrole subrole id
-- @param string|number id item id / name
-- @realm shared
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

---
-- Initialize old items and converts them to the new item system.
-- @note This should be called after all entites have been loaded eg after InitPostEntity.
-- @realm shared
function MigrateLegacyItems()
	for subrole, tbl in pairs(EquipmentItems or {}) do
		for i = 1, #tbl do
			local v = tbl[i]

			if v.avoidTTT2 then continue end

			local name = v.ClassName or v.name or WEPS.GetClass(v)

			if not name then continue end

			local item = items.GetStored(GetEquipmentFileName(name))

			if not item then
				local ITEMDATA = table.Copy(v)
				ITEMDATA.oldId = v.id
				ITEMDATA.id = name
				ITEMDATA.EquipMenuData = v.EquipMenuData or {
					type = v.type,
					name = v.name,
					desc = v.desc
				}
				ITEMDATA.type = nil
				ITEMDATA.desc = nil
				ITEMDATA.name = name
				ITEMDATA.material = v.material
				ITEMDATA.CanBuy = { [subrole] = subrole }
				ITEMDATA.limited = v.limited or v.LimitedStock or true

				-- reset this old hud bool
				if ITEMDATA.hud == true then
					ITEMDATA.oldHud = true
					ITEMDATA.hud = nil
				end

				-- set the converted indicator
				ITEMDATA.converted = true

				-- don't add icon and desc to the search panel if it's not intended
				ITEMDATA.noCorpseSearch = ITEMDATA.noCorpseSearch or true

				items.Register(ITEMDATA, GetEquipmentFileName(name))

				print("[TTT2][INFO] Automatically converted legacy item: ", name, ITEMDATA.oldId)
			else
				item.CanBuy = item.CanBuy or {}
				item.CanBuy[subrole] = subrole
			end
		end
	end
end
