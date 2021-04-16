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
function eventdata.GetPlayerTotalDeaths()
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

---
-- Returns a table with all players that were present at the beginning of the
-- round while also providing their team and their role at this time.
-- @return table A table with the nick, sid64, role and team of each player
-- @realm shared
function eventdata.GetPlayerBeginRoles()
	local eventList = events.list

	for i = 1, #eventList do
		local event = eventList[i]

		if event.type ~= EVENT_SELECTED then continue end

		return event.event.plys
	end
end

---
-- Returns a table with all players that were present at the end of the
-- round while also providing their team and their role at this time.
-- @return table A table with the nick, sid64, alive, role and team of each player
-- @realm shared
function eventdata.GetPlayerEndRoles()
	local eventList = events.list

	for i = 1, #eventList do
		local event = eventList[i]

		if event.type ~= EVENT_FINISH then continue end

		return event.event.plys
	end
end

function eventdata.GetPlayerRoles()
	local eventList = events.list
	local plyRoles = {}

	-- we can use the fact that the eventlist is chronological
	for i = 1, #eventList do
		local event = eventList[i]

		if event.type == EVENT_SELECTED then
			local plys = event.event.plys

			for k = 1, #plys do
				local ply = plys[k]

				plyRoles[ply.sid64] = {{
					role = ply.role,
					team = ply.team
				}}
			end
		elseif event.type == EVENT_ROLECHANGE and event.event.roundState == ROUND_ACTIVE then
			local ply = event.event

			-- if a player connects after the round started, they don't have a starting role
			if not plyRoles[ply.sid64] then
				plyRoles[ply.sid64] = {}
			end

			plyRoles[ply.sid64][#plyRoles[ply.sid64] + 1] = {
				role = ply.newRole,
				team = ply.newTeam
			}
		end
	end

	return plyRoles
end
