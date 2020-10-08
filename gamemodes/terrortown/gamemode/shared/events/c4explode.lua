if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_c4_explode"
end

function EVENT:Trigger(owner)
	local event = {
		nick = owner:Nick(),
		sid64 = owner:SteamID64(),
		role = owner:GetSubRole(),
		team = owner:GetTeam()
	}

	return event
end

function EVENT:Score(event)

end

function EVENT:Serialize()

end
