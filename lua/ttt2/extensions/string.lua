---
-- string extensions
-- @author saibotk
-- @module string

if SERVER then
    AddCSLuaFile()
end

local stringGSub = string.gsub
local stringUpper = string.upper
local stringSub = string.sub

---
-- Split a string into smaller strings.
-- This will split a given string in parts, with a maximum size of the given splitSize.
--
-- @param string str The string to operate on.
-- @param number splitSize This is the size, after which the string is split.
-- @return table The table that contains the strings.
-- @realm shared
function string.SplitAtSize(str, splitSize)
    local result = {}
    local size = #str

    -- If the string is already small enough, just return it.
    if size <= splitSize then
        return { str }
    end

    local integralPart, fractionalPart = math.modf(size / splitSize)
    -- If the number can not be perfectly divided into the given size, we have to add another for the last part
    local splitCount = (fractionalPart == 0) and integralPart or (integralPart + 1)

    for i = 1, splitCount do
        -- first need to subtract one of the iterator, because we want to calculate the end position of the previous split.
        -- And add one to the result because lua starts with 1 instead of 0.
        local offset = ((i - 1) * splitSize) + 1
        -- Calculate the endPos with the current offset (next start position) plus the splitSize, minus 1 because the first symbol at the offset is already included
        local endPos = offset + splitSize - 1
        -- If the calculated endPos is higher than the size, just set it to nil, to select the string until the end
        endPos = endPos < size and endPos or nil
        result[i] = string.sub(str, offset, endPos)
    end

    return result
end

---
-- Uppercases the first character only
-- @param string str
-- @return string
-- @realm shared
function string.Capitalize(str)
    return stringUpper(stringSub(str, 1, 1)) .. stringSub(str, 2)
end

---
-- Simple string interpolation:
-- string.Interp("{killer} killed {victim}", {killer = "Bob", victim = "Joe"})
-- returns "Bob killed Joe"
-- No spaces or special chars in parameter name, just alphanumerics.
-- @param string str
-- @param table tbl
-- @return string
-- @realm shared
function string.Interp(str, tbl)
    return stringGSub(str, "{(%w+)}", tbl)
end
