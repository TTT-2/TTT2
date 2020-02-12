--           -- COPYRIGHT HEADER --
-- spon2.lua 1.0.0 by thelastpenguin
-- Copyright 2016 Gareth George
--                aka thelastpenguin
--
-- GitHub release: https://github.com/thelastpenguin/spon
--
-- You may use this in any purpose / include it in any project so long as the
-- following conditions are met:
--    - You do not remove this copyright notice
--    - You don't claim this to be your own
--    - You properly credit the author (thelastpenguin aka gareth george) if you publish your work
--      based on (and/or using) this.
--
-- If you modify this code in any way this copyright still applies to the modifications or any
-- derived pieces of code
--
-- The author may not be held responsibile for any damages or losses directly or indirectly caused
-- by the use of spon
-- If you disagree with any of these limitations you're free not to use the code!
--
--
--
--           -- COMPATABILITY MODE --
-- compatability with alternative encoders:
--    - util.TableFromJSON
--    - von by Vericas https://github.com/vercas/vON/blob/master/von.lua
--    - pon1 by thelastpenguin https://github.com/thelastpenguin/gLUA-Library/blob/master/pON/pON-recommended.lua
--
--           -- DATA TYPES --
-- All of the following data types are supported as both keys and values
-- References are preserved i.e. if the same object appears twice it will be encoded as the same object
-- Cycles will not result in infinite recursion
--
-- Data Types:
--    - boolean
--    - numbers (integers, floats)
--    - strings
--    - table
--    - nil

if SERVER then AddCSLuaFile() end

-- localized variable optimization
local select = select
local format_string = string.format
local concat = table.concat
local len = string.len
local string_find = string.find
local string_sub = string.sub
local tonumber = tonumber
local tostring = tostring
local math_log = math.log
local math_ceil = math.ceil
local next = next
local ipairs = ipairs
local pairs = pairs
local Angle = Angle
local Vector = Vector

-- the global table for the encoder
local spon = {}
if _G then _G.spon = spon end

--
-- caches
--

local hex_cache = {} for i = 0, 15 do hex_cache[format_string('%x', i)] = i end

local cache = {}
local cache_size = 0
local output_buffer = setmetatable({}, {__mode = 'v'})

local function empty_cache(hashy, a)
	cache_size = 0
	for k,v in pairs(hashy) do hashy[k] = nil end
	return a
end

local function empty_output_buffer(buffer, a)
	for k,v in ipairs(buffer) do buffer[k] = nil end
	return a
end

--
-- COMPATABILITY MODES
--

local compatability = {}
if false then -- you can re-enable this in your version if you so desire.
	do
		local function safeload(lib) local _, a = pcall(require, lib) if not _ then return nil else return a end end

		-- von compatability
		_G.von = _G.von or safeload('von')
		if von and von.serialize then compatability.vonDeserialize = von.deserialize end

		-- pon compatability
		_G.pon = _G.pon or safeload('pon')
		if pon and pon.decode then compatability.ponDecode = pon.decode end

		-- json compatability
		if util and util.JSONToTable then compatability.JSONToTable = util.JSONToTable end
	end
end
--
-- ENCODER FUNCTIONS
--

local encoder = {}

local log16 = math_log(16)

local function encoder_write_pointer(index)
	return format_string('@%x%x', math_ceil(math_log(index + 1) / log16), index)
end

encoder['number'] = function(value, output, index)
	if value % 1 == 0 then
		if value == 0 then
			output[index] = 'I0'
		elseif value < 0 then
			output[index] = format_string('i%x%x', math_ceil(math_log(-value+1) / (log16)), -value)
		else
			output[index] = format_string('I%x%x', math_ceil(math_log(value+1) / (log16)), value)
		end
	else
		output[index] = tostring(value) -- use a base10 tostring representation if it has decimals
	end

	return index + 1
end
local encode_number = encoder['number']

encoder['string'] = function(value, output, index)
	if cache[value] then
		output[index] = encoder_write_pointer(cache[value])
	end
	cache_size = cache_size + 1
	cache[value] = cache_size

	local len = len(value)
	if len >= 16 * 16 then
		output[index] = format_string('T%06X%s', len, value)
	else
		output[index] = format_string('S%02X%s', len, value)
	end
	return index + 1
end

encoder['boolean'] = function(value, output, index)
	output[index] = value and 't' or 'f'
	return index + 1
end

encoder['table'] = function(value, output, index)
	if cache[value] then
		output[index] = encoder_write_pointer(cache[value])
		return index + 1
	end

	-- update the cache
	cache_size = cache_size + 1
	cache[value] = cache_size

	local table_size = #value
	local has_kv_component = next(value, table_size ~= 0 and table_size or nil)

	if table_size > 0 then
		if has_kv_component then
			output[index] = '('
		else
			output[index] = '<'
		end

		index = index + 1

		for k,v in ipairs(value) do
			index = encoder[type(v)](v, output, index)
		end

		if has_kv_component then
			output[index] = '~'
			index = index + 1
		else
			output[index] = '>'
			return index + 1
		end
	else
		output[index] = '['
		index = index + 1
	end

	for k,v in next, value, (table_size ~= 0 and table_size or nil) do
		index = encoder[type(k)](k, output, index)
		index = encoder[type(v)](v, output, index)
	end

	output[index] = ')'

	return index + 1 --fast_concat_stack(fast_concat_stack('{', encode_sequential(1, value, 0)))
end

encoder['nil'] = function(value, output, index)
	output[index] = '-'
	return index + 1
end

-- gmod specific
if IsValid and FindMetaTable then
	local IsValid = IsValid
	local FindMetaTable = FindMetaTable
	local EntIndex = FindMetaTable('Entity').EntIndex

	encoder['Vector'] = function(value, output, index)
		output[index] = 'V'
		index = encode_number(value.x, output, index + 1)
		index = encode_number(value.y, output, index)
		return encode_number(value.z, output, index)
	end

	encoder['Angle'] = function(value, output, index)
		output[index] = 'A'
		index = encode_number(value.p, output, index + 1)
		index = encode_number(value.y, output, index)
		return encode_number(value.r, output, index)
	end

	encoder['Entity'] = function(value, output, index)
		if IsValid(value) then
			output[index] = 'E'
			return encode_number(EntIndex(value), output, index + 1)
		else
			return '#'
		end
	end

	encoder['Player']  = encoder['Entity']
	encoder['Vehicle'] = encoder['Entity']
	encoder['Weapon']  = encoder['Entity']
	encoder['NPC']     = encoder['Entity']
	encoder['NextBot'] = encoder['Entity']

end

local decoder = {}
-- a short string with a 2-digit length component
decoder['S'] = function(str, index, cache)
	local strlen = tonumber(string_sub(str, index + 1, index + 2), 16)
	local str = string_sub(str, index + 3, index + (3 - 1) + strlen)
	cache_size = cache_size + 1
	cache[cache_size] = str
	return str, index + (3) + strlen
end
-- a long string with a 6-digit length component
decoder['T'] = function(str, index, cache)
	local strlen = tonumber(string_sub(str, index + 1, index + 6), 16)
	return string_sub(str, index + 7, index + (7 - 1) + strlen), index + (7) + strlen -- figure out if alignment is off i think its right
end
-- decoder for an integer value
decoder['I'] = function(str, index, cache)
	local digitCount = hex_cache[string_sub(str, index+1, index+1)]
	if digitCount == 0 then return 0, index + 2 end
	return tonumber(string_sub(str, index + 2, index + 1 + digitCount), 16), index + (2 + digitCount)
end
decoder['i'] = function(str, index, cache)
	local digitCount = hex_cache[string_sub(str, index+1, index+1)]
	if digitCount == 0 then return 0, index + 2 end
	return -tonumber(string_sub(str, index + 2, index + 1 + digitCount), 16), index + (2 + digitCount)
end
-- decoder for a boolean
decoder['t'] = function(str, index) return true, index + 1 end
decoder['f'] = function(str, index) return false, index + 1 end
decoder['@'] = function(str, index)
	local digitCount = hex_cache[string_sub(str, index+1, index+1)]
	return cache[tonumber(string_sub(str, index + 2, index + 1 + digitCount), 16)], index + (2 + digitCount)
end

decoder['A'] = function(str, index)
	local p, y, r, char

	-- Skip prefix 'A', go to first property
	char = string_sub(str, index + 1, index + 1)
	p, index = decoder[char](str, index + 1)

	char = string_sub(str, index, index)
	y, index = decoder[char](str, index)

	char = string_sub(str, index, index)
	r, index = decoder[char](str, index)

	return Angle(p, y, r), index
end

decoder['V'] = function(str, index)
	local x, y, z, char

	-- Skip prefix 'V', go to first property
	char = string_sub(str, index + 1, index + 1)
	x, index = decoder[char](str, index + 1)

	char = string_sub(str, index, index)
	y, index = decoder[char](str, index)

	char = string_sub(str, index, index)
	z, index = decoder[char](str, index)

	return Vector(x, y, z), index
end

decoder['E'] = function(str, index)
	local entid, char

	-- Skip prefix 'E', go to entity index
	char = string_sub(str, index + 1, index + 1)
	entid, index = decoder[char](str, index + 1)

	return Entity(entid), index
end

decoder['('] = function(str, index)
	local table = {}
	cache_size = cache_size + 1
	cache[cache_size] = table

	index = index + 1

	-- decode the array portion of the table
	local i = 1
	while true do
		local c = string_sub(str, index, index)
		if c == '~' or c == ')' or c == nil then break end
		table[i], index = decoder[c](str, index, cache)
		i = i + 1
	end

	if string_sub(str, index, index) == '~' then
		-- decode the key-value poriton of the table
		index = index + 1
		local k
		while true do
			local c = string_sub(str, index, index)
			if c == ')' or c == nil then break end
			k, index = decoder[c](str, index, cache)
			c = string_sub(str, index, index)
			table[k], index = decoder[c](str, index, cache)
		end
	end

	return table, index + 1
end

decoder['['] = function(str, index)
	local table = {}
	cache_size = cache_size + 1
	cache[cache_size] = table

	-- decode the key-value poriton of the table
	index = index + 1
	local k
	while true do
		local c = string_sub(str, index, index)
		if c == ')' or c == nil then break end
		k, index = decoder[c](str, index, cache)
		c = string_sub(str, index, index)
		table[k], index = decoder[c](str, index, cache)
	end

	return table, index + 1
end

decoder['<'] = function(str, index)
	local table = {}
	cache_size = cache_size + 1
	cache[cache_size] = table

	index = index + 1

	-- decode the array portion of the table
	local i = 1
	while true do
		local c = string_sub(str, index, index)
		if c == '>' or c == nil then break end
		table[i], index = decoder[c](str, index, cache)
		i = i + 1
	end

	return table, index + 1
end

decoder['-'] = function(str, index)
	return nil, index + 1
end


spon.encode = function(table)
	-- encoding its simple
	empty_output_buffer(output_buffer)
	empty_cache(cache)
	encoder.table(table, output_buffer, 1)
	return concat(output_buffer)
end

spon.decode = function(str)
	empty_cache(cache)

	local firstChar = string_sub(str, 1, 1)
	local decoderFunc = decoder[firstChar]

	if spon.noCompat then
		return  decoderFunc(str, 1)
	end

	if not decoderFunc then
		return spon._decodeInCompatabilityMode(str, 'did not find a decoder function to handle the string beginning with \''..tostring(firstChar)..'\'')
	end

	local succ, val = pcall(decoderFunc, str, 1)
	if succ then return val end

	return spon._decodeInCompatabilityMode(str, 'spon encountered error: ' .. tostring(val))
end

spon._decodeInCompatabilityMode = function(str, message)
	local firstChar = string_sub(str, 1, 1)
	if firstChar == '{' then
		message = message .. '\nthis looks like it may be a pon1 encoded object, please make sure you have pon1 installed for compatability mode to work with it'
	end
	for k, decoder in pairs(compatability) do
		local succ, val = pcall(decoder, str)
		if succ then return val end
		message = message .. '\ntrying decoder: ' .. k .. '\n\terror: ' .. tostring(val)
	end
	error('[spon] failed to decode string and was unable to resolve the problem in compatability mode!\n' .. message .. '\n\nthe encoded object: ' .. tostring(str:sub(1, 100)))
end

spon.printtable = function(tbl, indent, cache) -- debug utility
	if indent == nil then
		return spon.printtable(tbl, 0, {})
	end
	if cache[tbl] then return end
	cache[tbl] = true
	local lpad = string.format('%'..indent..'s', '')

	for k,v in pairs(tbl) do
		print(lpad .. '- ' .. string_sub(type(k), 1, 1) .. ':' .. tostring(k) .. ' = ' .. string_sub(type(v), 1, 1) .. ':' .. tostring(v))
		if type(v) == 'table' then
			spon.printtable(v, indent + 4, cache)
		end
	end
end

-- todo: finish writing entity, angle, vector decoders

return spon
