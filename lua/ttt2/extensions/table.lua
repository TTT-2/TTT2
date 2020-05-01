---
-- table exentsions
-- @author saibotk

AddCSLuaFile()

local pairs = pairs
local ipairs = ipairs

---
-- Get the value from a table with a path that is given as a table of indexes.
-- The method will try to traverse the dataTable and return the value or
-- it will return nil, if a key (even a subpath) is not defined.
--
-- @param dataTable table the table to traverse and search the path in.
-- @param path table the table with keys that will be used to traverse the tree (in order).
-- @return any the value at the given path or nil if it does not exist
function table.GetWithPath(dataTable, path)
	assert(path, "table.GetWithPath(..) missing path parameter.")

	-- Convert single key to table
	if not istable(path) then
		path = { path }
	end

	local currentDataTable = dataTable

	for i = 1, #path do
		if currentDataTable == nil then return end

		currentDataTable = currentDataTable[path[i]]
	end

	return currentDataTable
end

---
-- Set the value on a table with a path that is given as a table of indexes.
-- This method will traverse the given dataTable and create tables along the path if
-- necessary. It will then set the value in the traversed table.
--
-- @param dataTable table the table to traverse and set the value in.
-- @param path table the table with keys that will be used to traverse the tree (in order).
function table.SetWithPath(dataTable, path, value)
	assert(path, "table.SetWithPath(..) missing path parameter.")

	-- Convert single key to table
	if not istable(path) then
		path = { path }
	end

	local currentDataTable = dataTable or {}

	-- Create new table entries along the path if they do not exist
	-- This will be done until the second last table is reached.
	for i = 1, (#path - 1) do
		currentDataTable[path[i]] = currentDataTable[path[i]] or {}
		currentDataTable = currentDataTable[path[i]]
	end

	-- Set the value on the table (the last table on the path)
	currentDataTable[path[#path]] = value
end

---
-- Checks if a table has a value.
-- @note For optimization, functions that look for a value by sorting the table should never be needed if you work on a table that you built yourself.
-- @note Override of the original <a href="https://wiki.garrysmod.com/page/table/HasValue">table.HasValue</a> check with nil check
-- @warning This function is very inefficient for large tables (O(n)) and should probably not be called in things that run each frame. Instead, consider a table structure such as example 2 below.
-- @param table tbl Table to check
-- @param any val Value to search for
-- @return boolean Returns true if the table has that value, false otherwise
-- @usage local mytable = { "123", "test" }
-- print( table.HasValue( mytable, "apple" ), table.HasValue( mytable, "test" ) )
-- > false true
-- @usage local mytable = { ["123"] = true, test = true }
-- print( mytable["apple"], mytable["test"] )
-- > nil true
-- @realm shared
function table.HasValue(tbl, val)
	if not tbl then return end

	for _, v in pairs(tbl) do
		if v == val then
			return true
		end
	end

	return false
end

---
-- Value equality for tables
-- @param table a
-- @param table b
-- @return boolean
-- @realm shared
function table.EqualValues(a, b)
	if a == b then
		return true
	end

	for k, v in pairs(a) do
		if v ~= b[k] then
			return false
		end
	end

	return true
end

---
-- Basic table.HasValue pointer checks are insufficient when checking a table of
-- tables, so this uses table.EqualValues instead.
-- @param table tbl
-- @param table needle
-- @return boolean
-- @realm shared
function table.HasTable(tbl, needle)
	if not tbl then return end

	for _, v in pairs(tbl) do
		if v == needle then
			return true
		elseif table.EqualValues(v, needle) then
			return true
		end
	end

	return false
end

---
-- Returns copy of table with only specific keys copied
-- @param table tbl
-- @param table keys
-- @return table
-- @realm shared
function table.CopyKeys(tbl, keys)
	if not (tbl and keys) then return end

	local out = {}
	local val

	for _, k in pairs(keys) do
		val = tbl[k]

		if istable(val) then
			out[k] = table.Copy(val)
		else
			out[k] = val
		end
	end

	return out
end

---
-- This @{function} adds missing values into a table
-- @param table target
-- @param table source
-- @param boolean iterable
-- @realm shared
function table.AddMissing(target, source, iterable)
	if #source == 0 then return end

	local fn = not iterable and pairs or ipairs
	local index = #target + 1

	for _, v in fn(source) do
		if not table.HasValue(target, v) then
			target[index] = v
			index = index + 1
		end
	end
end
