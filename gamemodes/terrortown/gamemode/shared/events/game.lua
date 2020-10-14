if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_game_state"
end

function EVENT:Trigger(roundstate)
	local event = {
		newstate = roundstate
	}

	return event
end

function EVENT:Score(event)

end

function EVENT:GetDeprecatedFormat(event)
	if self.event.roundState ~= ROUND_ACTIVE then return end

	return {
		id = self.type,
		t = event.time / 1000,
		state = event.newstate
	}
end

function EVENT:Serialize()

end
