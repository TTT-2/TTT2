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
-- Print messages with added quotation marks to strings
-- @param any message The message to display
-- @note The message can be a variable or a table and even nil. In case of a table it automatically concatenates all entries and checks every object if it is a string
-- @realm shared
function debug.print(message)
	local printMessage = ""

	if istable(message) and table.IsSequential(message) then
		for i = 1, #message do
			printMessage = printMessage .. ConvertToString(message[i]) .. " "
		end
	else
		printMessage = ConvertToString(message)
	end

	print(printMessage)
end
