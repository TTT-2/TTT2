---
-- A group of functions that uses the event data to generate
-- usable data for the usage in the game.
-- @author Mineotopia
-- @module eventdata

if SERVER then
	AddCSLuaFile()
end

eventdata = eventdata or {}

---
-- Returns a table with the player steamID64 as indexes and a number of deaths
-- for this specific player.
-- @note Players with zero deaths this round will not be included in this list.
-- @return table A table with the amounts of deaths per player
-- @realm shared
function eventdata.GetTotalPlayerDeaths()
	local eventList = events.list
	local deathList = {}

	for i = 1, #eventList do
		local event = eventList[i]

		if event.type ~= EVENT_KILL then continue end

		local victim64 = event.event.victim.sid64

		deathList[victim64] = (deathList[victim64] or 0) + 1
	end

	return deathList
end

function eventdata.GetPlayerBeginRoles()

end

function eventdata.GetPlayerEndRoles()

end
