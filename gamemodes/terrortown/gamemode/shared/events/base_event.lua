EVENT.type = "base_event"
EVENT.event = {}

function EVENT:Add(event)
	-- store the event time in relation to the round start time in milliseconds
	event.time = math.Round((CurTime() - GAMEMODE.RoundStartTime) * 1000, 0)
	event.roundState = GetRoundState()

	-- call hook that a new event is about to be added, can be canceled or
	-- modified from that hook
	if hook.Run("TTT2OnTriggeredEvent", self.type, event) == false then
		return false
	end

	self.event = event

	-- after the event is added, it should be passed on to the
	-- scoring function to directly calculate the score
	if isfunction(self.Score) then
		self:Score(self.event)
	end

	return true
end

function EVENT:GetNetworkedData()
	return {
		type = self.type,
		event = self.event
	}
end
