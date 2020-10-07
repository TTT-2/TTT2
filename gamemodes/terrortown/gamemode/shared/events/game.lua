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

function EVENT:Serialize()

end
