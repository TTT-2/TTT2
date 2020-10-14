if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_finished"
end

function EVENT:Trigger(wintype)
	local event = {
		wintype = wintype,
		plys = {}
	}

	local eventPlys = event.plys
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		eventPlys[#eventPlys + 1] = {
			nick = ply:Nick(),
			sid64 = ply:SteamID64(),
			team = ply:GetTeam(),
			role = ply:GetSubRole(),
			alive = ply:Alive() and ply:IsTerror()
		}
	end

	return event
end

function EVENT:Score(event)
	local eventPlys = event.plys

	-- Check who is alive and who is dead on a teambased approach
	local alive = {}
	local dead = {}

	for i = 1, #eventPlys do
		local ply = eventPlys[i]
		local state = ply.alive and alive or dead
		local team = ply.team

		if team ~= TEAM_NONE then
			state[team] = (state[team] or 0) + 1
		end
	end

	-- In a second pass, calculate the score based on the players that
	-- are still alive. The more of their team have survived, the greater
	-- their bonus. Additionally many dead players from a different team
	-- can grant extra points.
	for i = 1, #eventPlys do
		local ply = eventPlys[i]
		local team = ply.team
		local roleData = roles.GetByIndex(ply.role)
		local otherDeadPlayers = 0
		local otherAlivePlayers = 0

		-- Count dead players that are in a different team
		for otherTeam, amount in pairs(dead) do
			if team ~= TEAM_NONE and team == otherTeam and not TEAMS[team].alone then continue end

			otherDeadPlayers = otherDeadPlayers + amount
		end

		-- Count alive players that are in a different team
		for otherTeam, amount in pairs(alive) do
			if team ~= TEAM_NONE and team == otherTeam and not TEAMS[team].alone then continue end

			otherAlivePlayers = otherAlivePlayers + amount
		end

		ply.scoreAliveTeamMates = (alive[team] or 0)
		ply.scoreDeadEnemies = math.ceil(otherDeadPlayers * roleData.scoreSurviveBonusMultiplier)
		ply.scoreTimelimit = event.wintype == WIN_TIMELIMIT and math.ceil(otherAlivePlayers * roleData.scoreTimelimitMultiplier) or 0
	end
end

function EVENT:GetDeprecatedFormat(event)
	if self.event.roundState ~= ROUND_ACTIVE then return end

	return {
		id = self.type,
		t = event.time,
		win = event.wintype
	}
end

function EVENT:Serialize()

end
