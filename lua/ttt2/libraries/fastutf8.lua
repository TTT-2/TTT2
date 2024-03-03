---
-- A faster utf8 alternative to the default gmod utf8 library.
-- This code is taken from https://github.com/blitmap/lua-utf8-simple
-- LICENSED under the MIT License
-- Copyright (c) 2015 blitmap <coroutines@gmail.com>
--
-- @note There is no guarantee that this library behaves exactly like the default one or is even correct in every case.
-- @module fastutf8

if SERVER then
    AddCSLuaFile()
end

fastutf8 = {}

-- ABNF from RFC 3629
--
-- UTF8-octets = *( UTF8-char )
-- UTF8-char = UTF8-1 / UTF8-2 / UTF8-3 / UTF8-4
-- UTF8-1 = %x00-7F
-- UTF8-2 = %xC2-DF UTF8-tail
-- UTF8-3 = %xE0 %xA0-BF UTF8-tail / %xE1-EC 2( UTF8-tail ) /
-- %xED %x80-9F UTF8-tail / %xEE-EF 2( UTF8-tail )
-- UTF8-4 = %xF0 %x90-BF 2( UTF8-tail ) / %xF1-F3 3( UTF8-tail ) /
-- %xF4 %x80-8F 2( UTF8-tail )
-- UTF8-tail = %x80-BF

-- 0xxxxxxx                            | 007F   (127)
-- 110xxxxx	10xxxxxx                   | 07FF   (2047)
-- 1110xxxx	10xxxxxx 10xxxxxx          | FFFF   (65535)
-- 11110xxx	10xxxxxx 10xxxxxx 10xxxxxx | 10FFFF (1114111)
local pattern = "[%z\1-\127\194-\244][\128-\191]*"

-- helper function
local posrelat = function(pos, len)
    if pos < 0 then
        pos = len + pos + 1
    end

    return pos
end

-- THE MEAT

-- maps f over s's utf8 characters f can accept args: (visual_index, utf8_character, byte_index)
-- @param string s The string to map over
-- @param func f The function to map over the string
-- @param[opt] boolean no_subs If true, the function will not yield the utf8 characters
-- @realm shared
fastutf8.map = function(s, f, no_subs)
    local i = 0

    if no_subs then
        for b, e in s:gmatch("()" .. pattern .. "()") do
            i = i + 1
            local c = e - b
            f(i, c, b)
        end
    else
        for b, c in s:gmatch("()(" .. pattern .. ")") do
            i = i + 1
            f(i, c, b)
        end
    end
end

-- THE REST

---
-- generator function -- to iterate over all utf8 chars
-- @param string s The string to iterate over
-- @param[opt] boolean no_subs If true, the generator will not yield the utf8 characters
-- @return func Returns a generator function
-- @realm shared
fastutf8.chars = function(s, no_subs)
    return coroutine.wrap(function()
        return fastutf8.map(s, coroutine.yield, no_subs)
    end)
end

---
-- returns the number of characters in a UTF-8 string
-- @param string s The string to get the length of
-- @return number Returns the amount of characters of the string
-- @realm shared
fastutf8.len = function(s)
    -- count the number of non-continuing bytes
    return select(2, s:gsub("[^\128-\193]", ""))
end

---
-- replace all utf8 chars with mapping
-- @param string s The string to replace the characters in
-- @param string|table|func map The replacement for the characters
-- @return string,number Returns the string with the replaced characters & the replaced count
-- @realm shared
fastutf8.replace = function(s, map)
    return s:gsub(pattern, map)
end

---
-- reverse a utf8 string
-- @param string s The string to reverse
-- @return string Returns the reversed string
-- @realm shared
fastutf8.reverse = function(s)
    -- reverse the individual greater-than-single-byte characters
    s = s:gsub(pattern, function(c)
        return #c > 1 and c:reverse()
    end)

    return s:reverse()
end

---
-- strip non-ascii characters from a utf8 string
-- @param string s The string to strip
-- @return string,number Returns the stripped string & the stripped count
-- @realm shared
fastutf8.strip = function(s)
    return s:gsub(pattern, function(c)
        return #c > 1 and ""
    end)
end

---
-- like string.sub() but i, j are utf8 strings
-- a utf8-safe string.sub()
-- @param string s The string to get the substring from
-- @param number i The start index
-- @param[opt] number j The end index
-- @return string Returns the substring
-- @realm shared
fastutf8.sub = function(s, i, j)
    local l = fastutf8.len(s)

    i = posrelat(i, l)
    j = j and posrelat(j, l) or l

    if i < 1 then
        i = 1
    end
    if j > l then
        j = l
    end

    if i > j then
        return ""
    end

    local diff = j - i
    local iter = fastutf8.chars(s, true)

    -- advance up to i
    for _ = 1, i - 1 do
        iter()
    end

    local c, b = select(2, iter())

    -- i and j are the same, single-charaacter sub
    if diff == 0 then
        return string.sub(s, b, b + c - 1)
    end

    i = b

    -- advance up to j
    for _ = 1, diff - 1 do
        iter()
    end

    c, b = select(2, iter())

    return string.sub(s, i, b + c - 1)
end

---
-- Get the character at index i in the string s
-- @param string s The string to get the character from
-- @param number i The index of the character
-- @return string Returns the character
-- @realm shared
fastutf8.GetChar = function(s, i)
    return fastutf8.sub(s, i, i)
end
