-- @class EVENT

local tableCount = table.Count
local tableGetKeys = table.GetKeys
local tableHasValue = table.HasValue
local tableAdd = table.Add

EVENT.type = "base_event"
EVENT.event = {}
EVENT.score = {}
EVENT.players = {}

---
-- Sets the event data table to the event.
-- @param table event The event data table that should be added
-- @internal
-- @realm shared
function EVENT:SetEventTable(event)
	self.event = event
end

---
-- Sets the score data table to the event.
-- @param table event The score data table that should be added
-- @internal
-- @realm shared
function EVENT:SetScoreTable(score)
	self.score = score
end

---
-- Sets the affected players data table to the event.
-- @param table event The affected players data table that should be added
-- @internal
-- @realm shared
function EVENT:SetPlayersTable(players)
	self.players = players
end

---
-- Sets the score data table to the event.
-- @param string ply64 The steamID64 of the affected player
-- @param table score The score data table that should be added
-- @realm shared
function EVENT:SetPlayerScore(ply64, score)
	if not ply64 or not score then return end

	self.score[ply64] = score
end

---
-- Returns the event data in the deprecated format. Shouldn't be used, is used
-- internally.
-- @param table event The event data table that should be transformed
-- @return table The event table in the deprecated format
-- @internal
-- @realm shared
function EVENT:GetDeprecatedFormat(event)

end

---
-- Checks whether the given player has scored in this event or not.
-- @param string ply64 The steamID64 of the player that should be checked
-- @return boolean Returns true if the player has a score table, they could still have received 0 points
-- @realm shared
function EVENT:HasPlayerScore(ply64)
	return self.score[ply64] ~= nil
end

---
-- Checks if this event has score at all.
-- @return boolean Returns true if there is score added in this event
-- @realm server
function EVENT:HasScore()
	return tableCount(self.score)
end

---
-- Returns a list of all player steamID64s whom have received score in this event.
-- @return table A table of all the steamID64s
-- @realm shared
function EVENT:GetScoredPlayers()
	return tableGetKeys(self.score)
end

---
-- Returns the complete score for the given player in this event. This takes care of
-- events that give score for different things.
-- @param string ply64 The steamID64 of the player that should be checked
-- @return number The amount of score gained by this player in this event
-- @realm shared
function EVENT:GetSummedPlayerScore(ply64)
	if not self:HasPlayerScore(ply64) then
		return 0
	end

	local scoreSum = 0

	for _, score in pairs(self.score[ply64]) do
		scoreSum = scoreSum + score
	end

	return scoreSum
end

---
-- Returns a list of all player steamID64s who were affected by this event.
-- @return table A table of steamID64s
-- @realm shared
function EVENT:GetAffectedPlayer()
	return self.players
end

---
-- Checks if a given player was was affected by this event.
-- @param string ply64 The steamID64 of the player that should be checked
-- @return boolean Returns true if the player was affected by this event.
-- @realm shared
function EVENT:HasAffectedPlayer(ply64)
	return tableHasValue(self.players, ply64)
end

if SERVER then
	---
	-- Adds players that are affected by this event.
	-- @param string vararg A variable amount of player steamID64
	-- @realm server
	function EVENT:AddAffectedPlayers(...)
		tableAdd(self.players, {...})
	end

	---
	-- Adds the event data table to an event. Also adds some generic data as well.
	-- Inside this function the hook @{GM:TTT2OnTriggeredEvent} is called to make
	-- sure this event should really be added.
	-- @param table event The event data table that is about to be added
	-- @return boolean Return true if addition was successful, false if not
	-- @internal
	-- @realm server
	function EVENT:Add(event)
		-- store the event time in relation to the round start time in milliseconds
		event.time = math.Round((CurTime() - GAMEMODE.RoundStartTime) * 1000, 0)
		event.roundState = GetRoundState()

		-- call hook that a new event is about to be added, can be canceled or
		-- modified from that hook
		if hook.Run("TTT2OnTriggeredEvent", self.type, event) == false then
			return false
		end

		self:SetEventTable(event)

		-- after the event is added, it should be passed on to the
		-- scoring function to directly calculate the score
		self:Score(self.event)

		return true
	end

	---
	-- This function generates a table with all the data that should be networked.
	-- You probably don't want to overwrite it.
	-- @return table A table of the data that is networked
	-- @internal
	-- @realm server
	function EVENT:GetNetworkedData()
		return {
			type = self.type,
			event = self.event,
			score = self.score,
			players = self.players
		}
	end

	---
	-- The main function of an event. It contains all the event handling.
	-- This function should be overwritten but not not called.
	-- @param vararg A variable amount of arguments passed to this event
	-- @internal
	-- @realm server
	function EVENT:Trigger(...)

	end

	---
	-- This function calculates the score gained for this event. It should be
	-- overwritte if the event should yield a score.
	-- This function should be overwritten but not not called.
	-- @param table event The event data previously added
	-- @internal
	-- @realm server
	function EVENT:Score(event)

	end
end
