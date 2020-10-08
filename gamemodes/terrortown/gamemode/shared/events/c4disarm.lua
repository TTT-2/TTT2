if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_c4_disarm"
end

function EVENT:Trigger(owner, disarmer, successful)
	local event = {
		successful = successful,
		owner = {
			nick = owner:Nick(),
			sid64 = owner:SteamID64(),
			role = owner:GetSubRole(),
			team = owner:GetTeam()
		},
		disarmer = {
			nick = disarmer:Nick(),
			sid64 = disarmer:SteamID64(),
			role = disarmer:GetSubRole(),
			team = disarmer:GetTeam()
		}
	}

	return event
end

function EVENT:Score(event)

end

function EVENT:Serialize()

end
