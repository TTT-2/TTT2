--- @ignore

if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_game_state"
end

if SERVER then
	function EVENT:Trigger(roundstate)
		return self:Add({
			newstate = roundstate
		})
	end
end

function EVENT:GetDeprecatedFormat(event)
	if event.roundState ~= ROUND_ACTIVE then return end

	return {
		id = self.type,
		t = event.time / 1000,
		state = event.newstate
	}
end

function EVENT:Serialize()

end
