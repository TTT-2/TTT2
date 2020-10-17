EVENT.type = "base_event"
EVENT.event = {}
EVENT.score = {}
EVENT.players = {}

---
-- Sets the event data table to the event.
-- @param table event The event data table that is about to be added
-- @internal
-- @realm shared
function EVENT:SetEventTable(event)
	self.event = event
end

function EVENT:SetScoreTable(score)
	self.score = score
end

function EVENT:SetPlayersTable(players)
	self.players = players
end

---
-- Sets the score data table to the event.
-- @param string ply64 The steamID64 of the affected player
-- @param table score The score data table that is about to be added
-- @internal
-- @realm shared
function EVENT:SetScore(ply64, score)
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

function EVENT:HasPlayerScore(ply64)
	return self.score[ply64] ~= nil
end

function EVENT:HasScore()
	return self.score ~= {}
end

function EVENT:GetScoredPlayers()
	return table.GetKeys(self.score)
end

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

function EVENT:GetAffectedPlayer()
	return self.players
end

function EVENT:HasAffectedPlayer(ply64)
	return table.HasValue(self.players, ply64)
end

if SERVER then
	---
	-- Adds players that are affected by this event.
	-- @param string vararg A variable amount of player steamID64
	-- @realm server
	function EVENT:AddAffectedPlayers(...)
		table.Add(self.players, {...})
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
	-- @return table The event data that should be added to the event manager
	-- @internal
	-- @realm server
	function EVENT:Trigger(...)

	end

	---
	-- This function calculates the score gained for this event. It should be
	-- overwritte if the event should yield a score.
	-- This function should be overwritten but not not called.
	-- @param table event The event data previously added
	-- @return string, table The steamID64 of the affected player, The score table
	-- @internal
	-- @realm server
	function EVENT:Score(event)

	end
end