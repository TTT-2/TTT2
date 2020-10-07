if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_respawn"
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

function EVENT:Serialize()

end
