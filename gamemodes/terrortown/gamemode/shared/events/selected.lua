if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_selected"
end

if SERVER then
	function EVENT:Trigger()
		local event = {
			plys = {}
		}
		local eventPlys = event.plys
		local plys = player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			eventPlys[i] = {
				nick = ply:Nick(),
				sid64 = ply:SteamID64(),
				role = ply:GetSubRole(),
				team = ply:GetTeam()
			}

			self:AddAffectedPlayers(ply:SteamID64())
		end

		return self:Add(event)
	end
end

function EVENT:GetDeprecatedFormat(event)
	if self.event.roundState ~= ROUND_ACTIVE then return end

	local roles, teams = {}, {}

	for i = 1, #event.plys do
		local ply = event.plys[i]

		subrole = ply.role
		team = ply.team

		roles[subrole] = roles[subrole] or {}
		roles[subrole][#roles[subrole] + 1] = ply.sid64

		if team ~= TEAM_NONE then
			teams[team] = teams[team] or {}
			teams[team][#teams[team] + 1] = ply.sid64
		end
	end

	return {
		id = self.type,
		t = event.time / 1000,
		rt = roles,
		tms = teams
	}
end

function EVENT:Serialize()

end
