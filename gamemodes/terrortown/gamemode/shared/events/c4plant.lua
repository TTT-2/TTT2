if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_c4_plant"
end

function EVENT:Trigger(planter)
	local event = {
		nick = planter:Nick(),
		sid64 = planter:SteamID64(),
		role = planter:GetSubRole(),
		team = planter:GetTeam()
	}

	return event
end

function EVENT:Score(event)

end

function EVENT:GetDeprecatedFormat(event)
	if self.roundState ~= ROUND_ACTIVE then return end

	return {
		id = self.type,
		t = event.time / 1000,
		ni = event.nick,
	}
end

function EVENT:Serialize()

end
