if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_game_creditfound"
end

function EVENT:Trigger(ply, rag, credits)
	local found = CORPSE.GetPlayer(rag)

	local event = {
		finder = {
			nick = finder:Nick(),
			sid64 = finder:SteamID64(),
			role = finder:GetSubRole(),
			team = finder:GetTeam()
		},
		found = {
			nick = found:Nick(),
			sid64 = found:SteamID64(),
			role = found:GetSubRole(),
			team = found:GetTeam(),
			credits = credits
		}
	}

	return event
end

function EVENT:Score(event)

end

function EVENT:Serialize()

end
