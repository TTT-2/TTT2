---
-- debug extension
-- @author ZenBre4ker
-- @module debug

local debug = debug

if SERVER then
    AddCSLuaFile()
end

---
-- Adds quotation marks to strings otherwise just converts them to strings
-- @param any object The object to convert
-- @realm shared
-- @internal
local function ConvertToString(object)
    if isstring(object) then
        return "\"" .. object .. "\""
    else
        return tostring(object)
    end
end

---
-- Converts nil entries in an otherwise sequential table
-- Also directly converts all entries to strings
-- @param table tbl The table to convert
-- @return boolean If the table could be fully converted to a sequential table?
-- @realm shared
-- @internal
local function TryConvertToSequentialTable(tbl)
    if not istable(tbl) then
        return false
    end

    -- Check that all keys are numbers
    local largestIndex = 1
    for key, tableContent in pairs(tbl) do
        if not isnumber(key) then
            return false
        end
        if largestIndex < key then
            largestIndex = key
        end
    end

    for i = 1, largestIndex do
        tbl[i] = ConvertToString(tbl[i])
    end

    return true
end

---
-- Print messages with added quotation marks to strings
-- @param any message The message to display
-- @note The message can be a variable or a table and even nil. In case of a table it automatically concatenates all entries and checks every object if it is a string
-- @realm shared
function debug.print(message)
    local printMessage = ""

    if TryConvertToSequentialTable(message) then
        for i = 1, #message do
            printMessage = printMessage .. message[i] .. " "
        end
    else
        printMessage = ConvertToString(message)
    end

    Dev(2, printMessage)
end
