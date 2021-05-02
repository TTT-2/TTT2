---
-- This file contains all shared networking functions, to sync and manage the information between server and clients
-- @author saibotk
-- @module ttt2net

ttt2net = {}

-- Network message name constants
ttt2net.NETMSG_META_UPDATE = "TTT2_NET_META_UPDATE"
ttt2net.NETMSG_DATA_UPDATE = "TTT2_NET_DATA_UPDATE"
ttt2net.NETMSG_REQUEST_FULL_STATE_UPDATE = "TTT2_NET_REQUEST_FULL_STATE_UPDATE"

-- Network stream message name constants
ttt2net.NET_STREAM_FULL_STATE_UPDATE = "TTT2_NET_STREAM_FULL_STATE_UPDATE"

---
-- @class Player

---
-- Player extensions
-- Some simple functions on the player class, to simplify the use of this system.
local plymeta = assert(FindMetaTable("Player"), "[TTT2NET] FAILED TO FIND PLAYER TABLE")

---
-- Returns the current bool value for a given path on the player.
--
-- @param any path The path to return the value for
-- @param[opt] boolean fallback The fallback value to return instead of nil
-- @param[opt] Entity client The client/entity to get the value for
-- @return boolean The value at the path or fallback if the value is nil
-- @realm shared
function plymeta:TTT2NETGetBool(path, fallback, client)
	return tobool(ttt2net.GetOnPlayer(path, self, SERVER and client or nil) == true or fallback)
end

---
-- Returns the current number value for a given path on the player.
--
-- @param any path The path to return the value for
-- @param number fallback The fallback value to return instead of nil
-- @param[opt] Entity client The client/entity to get the value for
-- @return number The value at the path or fallback if the value is nil
-- @realm shared
function plymeta:TTT2NETGetInt(path, fallback, client)
	return tonumber(ttt2net.GetOnPlayer(path, self, SERVER and client or nil) or fallback)
end

---
-- Returns the current unsigned number value for a given path on the player.
--
-- @param any path The path to return the value for
-- @param number fallback The fallback value to return instead of nil
-- @param[opt] Entity client The client/entity to get the value for
-- @return number The value at the path or fallback if the value is nil
-- @realm shared
function plymeta:TTT2NETGetUInt(path, fallback, client)
	return tonumber(ttt2net.GetOnPlayer(path, self, SERVER and client or nil) or fallback)
end

---
-- Returns the current float value for a given path on the player.
--
-- @param any path The path to return the value for
-- @param number fallback The fallback value to return instead of nil
-- @param[opt] Entity client The client/entity to get the value for
-- @return number The value at the path or fallback if the value is nil
-- @realm shared
function plymeta:TTT2NETGetFloat(path, fallback, client)
	return tonumber(ttt2net.GetOnPlayer(path, self, SERVER and client or nil) or fallback)
end

---
-- Returns the current string value for a given path on the player.
--
-- @param any path The path to return the value for
-- @param string fallback The fallback value to return instead of nil
-- @param[opt] Entity client The client/entity to get the value for
-- @return string The value at the path or fallback if the value is nil
-- @realm shared
function plymeta:TTT2NETGetString(path, fallback, client)
	return tostring(ttt2net.GetOnPlayer(path, self, SERVER and client or nil) or fallback)
end
