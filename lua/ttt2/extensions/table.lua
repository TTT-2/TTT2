---
-- table exentsions
-- @author saibotk
-- @module table

if SERVER then
    AddCSLuaFile()
end

local table = table
local pairs = pairs
local ipairs = ipairs
local rand = math.random
local tremove = table.remove
local isfunction = isfunction

---
-- Randomizes a @{table}
-- @param table t
-- @realm shared
function table.Randomize(t)
    local out = {}

    while #t > 0 do
        out[#out + 1] = table.remove(t, math.random(#t))
    end

    t = out
end

---
-- Get the value from a table with a path that is given as a table of indexes.
-- The method will try to traverse the dataTable and return the value or
-- it will return nil, if a key (even a subpath) is not defined.
--
-- @param table dataTable the table to traverse and search the path in.
-- @param any path the table with keys that will be used to traverse the tree (in order).
-- @return any the value at the given path or nil if it does not exist
-- @realm shared
function table.GetWithPath(dataTable, path)
    assert(path, "table.GetWithPath(..) missing path parameter.")

    -- Convert single key to table
    if not istable(path) then
        path = { path }
    end

    local currentDataTable = dataTable

    for i = 1, #path do
        if currentDataTable == nil then
            return
        end

        currentDataTable = currentDataTable[path[i]]
    end

    return currentDataTable
end

---
-- Set the value on a table with a path that is given as a table of indexes.
-- This method will traverse the given dataTable and create tables along the path if
-- necessary. It will then set the value in the traversed table.
--
-- @param table dataTable the table to traverse and set the value in.
-- @param any path the table with keys that will be used to traverse the tree (in order).
-- @param any value
-- @realm shared
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
-- @note Override of the original <a href="https://wiki.facepunch.com/gmod/table.HasValue">table.HasValue</a> check with nil check
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
    if not tbl then
        return
    end

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
    if not tbl then
        return
    end

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
    if not (tbl and keys) then
        return
    end

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
-- @param[opt] boolean iterable
-- @realm shared
function table.AddMissing(target, source, iterable)
    if #source == 0 then
        return
    end

    local fn = not iterable and pairs or ipairs
    local index = #target + 1

    for _, v in fn(source) do
        if table.HasValue(target, v) then
            continue
        end

        target[index] = v
        index = index + 1
    end
end

---
-- Removes all empty table entries, making the table sequential again.
-- Use this function to more efficiently removing multiple indices from a sequential table by combining it
-- with a function setting all entries to be removed to nil. Do NOT use table.Remove() or table.RemoveByValue()
--
-- @param table dataTable the table to traverse and set the value in.
-- @param number tableSize the number of entries in dataTable
-- @realm shared
function table.RemoveEmptyEntries(dataTable, tableSize)
    local j = 1

    for i = 1, tableSize do
        if not dataTable[i] then
            continue
        end

        if i ~= j then
            -- Keep i's value, move it to j's pos.
            dataTable[j] = dataTable[i]
            dataTable[i] = nil
        end

        j = j + 1
    end
end

---
-- Nice Fisher-Yates implementation, from Wikipedia
-- Shuffles a @{table}
-- @param table t
-- @return table the given t, but sorted
-- @realm shared
function table.Shuffle(t)
    local n = #t

    while n > 2 do
        -- n is now the last pertinent index
        local k = rand(n) -- 1 <= k <= n

        -- Quick swap
        t[n], t[k] = t[k], t[n]
        n = n - 1
    end

    return t
end

---
-- Returns a random entry of the given @{table}
-- @param table tbl the @{table} that contains the data
-- @param nil|function filterFn the @{function} that has to return true on the given entry
-- @return any the entry that returned true on the given @{function}
-- @note The given @{table} has to be iterable.
-- @warning The returned entry will get removed from the given @{table}. If you wanna keep the original table untouched, create a copy for this function.
-- @realm shared
function table.ExtractRandomEntry(tbl, filterFn)
    local cTbl = #tbl

    -- if no filterFn is defined, get a any random entry of the given @{table}
    if not isfunction(filterFn) then
        local index = rand(cTbl)
        local entry = tbl[index]

        tremove(tbl, index)

        return entry
    end

    local tmpTbl = {}

    -- create a temporary table used for easy and fast access after shuffling
    for i = 1, cTbl do
        tmpTbl[i] = i
    end

    table.Shuffle(tmpTbl)

    for i = 1, cTbl do
        local index = tmpTbl[i]

        if filterFn(tbl[index]) then
            local entry = tbl[index]

            tremove(tbl, index)

            return entry
        end
    end
end

---
-- Scans the given table for the subtable with the most entries. This then
-- is returned and deleted from the source table. If there are multiple subtables with
-- the same size, the first found will be returned.
-- @note This function does not work recursivly. Therefore the size of the sub-subtables
-- has no effect on the size of the subtables.
-- @warning For number indexed tables the table has to be iterable.
-- @param table The table whose biggest subtable should be found.
-- @return[default={}] table The biggest subtable
-- @return[default=0] number|string The index where the biggest subtable was found
-- @realm shared
function table.GetAndRemoveBiggestSubTable(tbl)
    local subTbl = {}
    local subIdx = 0

    for i, t in pairs(tbl) do
        if #t < #subTbl then
            continue
        end

        subTbl = t
        subIdx = i
    end

    if isnumber(subIdx) then
        table.remove(tbl, subIdx)
    else
        tbl[subIdx] = nil
    end

    return subTbl, subIdx
end

-- Returns an indexed table of indexes that exist in both tables.
-- @note This function is most suitable for string indexed tables.
-- @param table tbl The table to iterate over
-- @param table reference The reference table to compare against
-- @return table A table with the keys that exist in both tables
-- @realm shared
function table.GetEqualEntryKeys(tbl, reference)
    -- return an empty table if tbl is nil
    if not tbl then
        return {}
    end

    local equalTbl = {}

    for index in pairs(tbl) do
        if not reference[index] then
            continue
        end

        equalTbl[#equalTbl + 1] = index
    end

    return equalTbl
end

---
-- Returns the amount of table entries that exist in both tables.
-- @note This function is most suitable for string indexed tables.
-- @param table tbl The table to iterate over
-- @param table reference The reference table to compare against
-- @return number The amount of indexes that exist in both tables
-- @realm shared
function table.GetEqualEntriesAmount(tbl, reference)
    return #table.GetEqualEntryKeys(tbl, reference)
end

-- Copies any missing data from base table to the target table.
-- @note This function will not create a new table. It modifies the existing table.
-- @param table t The target table that will be modified
-- @param table base The (fallback) base table
-- @return table The modified target table
-- @realm shared
function table.DeepInherit(t, base)
    if not base then
        return t
    end

    for k, v in pairs(base) do
        if t[k] == nil then
            t[k] = v
        elseif k ~= "BaseClass" and istable(t[k]) then
            table.DeepInherit(t[k], v)
        end
    end

    return t
end

-- Fully copies the table, meaning all tables inside this table are copied too.
-- Normal table.Copy copies only their reference.
-- @note Does not copy entities as well, only copies their reference.
-- @warning Do not use on tables that contain themselves somewhere down the line or
-- you'll get an infinite loop
-- @param table tbl The table that should be copied
-- @return table The copied table
-- @realm shared
function table.FullCopy(tbl)
    local result = {}

    for key, value in pairs(tbl) do
        if type(value) == "table" then
            result[key] = table.FullCopy(value)
        elseif type(value) == "Vector" then
            result[key] = Vector(value.x, value.y, value.z)
        elseif type(value) == "Angle" then
            result[key] = Angle(value.p, value.y, value.r)
        else
            result[key] = value
        end
    end

    return result
end
