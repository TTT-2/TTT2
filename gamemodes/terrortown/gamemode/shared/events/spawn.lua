if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_spawn"
end

function EVENT:Trigger(ply)
	local event = {
		nick = ply:Nick(),
		sid64 = ply:SteamID64()
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
		ni = event.nick,
		sid64 = event.sid64
	}
end

function EVENT:Serialize()

end
