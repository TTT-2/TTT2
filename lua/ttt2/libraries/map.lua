---
-- This is the map module to have some short access functions
-- @author Mineotopia
-- @module map

if SERVER then
	AddCSLuaFile()
end

map = map or {}
map.type = nil

MAP_TYPE_TERRORTOWN = 1
MAP_TYPE_COUNTERSTRIKE = 2
MAP_TYPE_TEAMFORTRESS = 3

---
-- Returns the exptected type of the current map.
-- @note This function uses caching to improve performance and only reads the
-- map entities on the first call of the funciton.
-- @return[default=MAP_TYPE_TERRORTOWN] number Returns the map type of the currently active map
-- @realm shared
function map.GetMapGameType()
	-- return cached map type if already cached
	if map.type then
		return map.type
	end

	if #ents.FindByClass("info_player_deathmatch") ~= 0 then
		map.type = MAP_TYPE_TERRORTOWN

		return MAP_TYPE_TERRORTOWN
	end

	if #ents.FindByClass("info_player_counterterrorist") ~= 0 then
		map.type = MAP_TYPE_COUNTERSTRIKE

		return MAP_TYPE_COUNTERSTRIKE
	end

	if #ents.FindByClass("info_player_teamspawn") ~= 0 then
		map.type = MAP_TYPE_TEAMFORTRESS

		return MAP_TYPE_TEAMFORTRESS
	end

	-- as a fallback use the terrortown map type
	return MAP_TYPE_TERRORTOWN
end

---
-- Checks if the currently selected map is a terrortown map.
-- @note This function uses caching to improve performance and only reads the
-- map entities on the first call of the funciton.
-- @return boolean Returns true if it is a terrortown map
-- @realm shared
function map.IsTerrortownMap()
	return map.GetMapGameType() == MAP_TYPE_TERRORTOWN
end

---
-- Checks if the currently selected map is a counter strike source map.
-- @note This function uses caching to improve performance and only reads the
-- map entities on the first call of the funciton.
-- @return boolean Returns true if it is a counter strike source map
-- @realm shared
function map.IsCounterStrikeMap()
	return map.GetMapGameType() == MAP_TYPE_COUNTERSTRIKE
end

---
-- Checks if the currently selected map is a team fortress 2 map.
-- @note This function uses caching to improve performance and only reads the
-- map entities on the first call of the funciton.
-- @return boolean Returns true if it is a team fortress 2 map
-- @realm shared
function map.IsTeamFortressMap()
	return map.GetMapGameType() == MAP_TYPE_TEAMFORTRESS
end
