if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_selected"
end

function EVENT:Trigger()
	local event = {}
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		event[#event + 1] = {
			nick = ply:Nick(),
			sid64 = ply:SteamID64(),
			role = ply:GetSubRole(),
			team = ply:GetTeam()
		}
	end

	return event
end

function EVENT:Score(event)

end

function EVENT:Serialize()

end
