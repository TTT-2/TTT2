if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_bodyfound"
end

function EVENT:Trigger(finder, rag)
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
			credits = CORPSE.GetCredits(rag, 0),
			headshot = CORPSE.WasHeadshot(rag) or false,
			time = math.Round((CORPSE.GetDeathTime(rag) - GAMEMODE.RoundStartTime) * 1000, 0)
		}
	}

	return event
end

function EVENT:Score(event)
	local finder = event.finder

	finder.score = roles.GetByIndex(finder.role).scoreBodyFoundMuliplier
end

function EVENT:Serialize()

end
