---
-- This file contains all shared networking functions, to sync and manage the information between server and clients
-- @author saibotk

TTT2NET = {}

-- Network message name constants
TTT2NET.NETMSG_META_UPDATE = "TTT2_NET_META_UPDATE"
TTT2NET.NETMSG_DATA_UPDATE = "TTT2_NET_DATA_UPDATE"
TTT2NET.NETMSG_REQUEST_FULL_STATE_UPDATE = "TTT2_NET_REQUEST_FULL_STATE_UPDATE"

-- Network stream message name constants
TTT2NET.NET_STREAM_FULL_STATE_UPDATE = "TTT2_NET_STREAM_FULL_STATE_UPDATE"

---
-- Player extensions
-- Some simple functions on the player class, to simplify the use of this system.
local plymeta = assert(FindMetaTable("Player"), "[TTT2NET] FAILED TO FIND PLAYER TABLE")

---
-- Returns the current bool value for a given path on the player.
--
-- @param any|table path The path to return the value for
-- @param any|nil fallback The fallback value to return instead of nil
-- @return bool|any|nil The value at the path or fallback if the value is nil
function plymeta:TTT2NETGetBool(path, fallback)
	return TTT2NET:GetOnPlayer(path, self) == true or fallback
end

---
-- Returns the current int value for a given path on the player.
--
-- @param any|table path The path to return the value for
-- @param number fallback The fallback value to return instead of nil
-- @return number The value at the path or fallback if the value is nil
function plymeta:TTT2NETGetInt(path, fallback)
	return tonumber(TTT2NET:GetOnPlayer(path, self) or fallback)
end

---
-- Returns the current unsigned int value for a given path on the player.
--
-- @param any|table path The path to return the value for
-- @param number fallback The fallback value to return instead of nil
-- @return number The value at the path or fallback if the value is nil
function plymeta:TTT2NETGetUInt(path, fallback)
	return tonumber(TTT2NET:GetOnPlayer(path, self) or fallback)
end

---
-- Returns the current float value for a given path on the player.
--
-- @param any|table path The path to return the value for
-- @param number fallback The fallback value to return instead of nil
-- @return number The value at the path or fallback if the value is nil
function plymeta:TTT2NETGetFloat(path, fallback)
	return tonumber(TTT2NET:GetOnPlayer(path, self) or fallback)
end

---
-- Returns the current string value for a given path on the player.
--
-- @param any|table path The path to return the value for
-- @param string fallback The fallback value to return instead of nil
-- @return string The value at the path or fallback if the value is nil
function plymeta:TTT2NETGetString(path, fallback)
	return tostring(TTT2NET:GetOnPlayer(path, self) or fallback)
end
