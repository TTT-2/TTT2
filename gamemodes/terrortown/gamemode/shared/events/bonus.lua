if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_finished"
end

if SERVER then
	function EVENT:Trigger(ply, alive, dead)
		self.cachedAlive = alive or {}
		self.cachedDead = dead or {}

		self:AddAffectedPlayers(ply:SteamID64())

		return self:Add({
			nick = ply:Nick(),
			sid64 = ply:SteamID64(),
			team = ply:GetTeam(),
			role = ply:GetSubRole(),
			alive = ply:Alive() and ply:IsTerror()
		})
	end

	function EVENT:Score(event)
		local alive = self.cachedAlive
		local dead = self.cachedDead

		-- In a second pass, calculate the score based on the players that
		-- are still alive. The more of their team have survived, the greater
		-- their bonus. Additionally many dead players from a different team
		-- can grant extra points.
		local team = event.team
		local roleData = roles.GetByIndex(event.role)
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

		self:SetScore(event.sid64, {
			scoreAliveTeamMates = alive[team] or 0,
			scoreDeadEnemies = math.ceil(otherDeadPlayers * roleData.scoreSurviveBonusMultiplier),
			scoreTimelimit = event.wintype == WIN_TIMELIMIT and math.ceil(otherAlivePlayers * roleData.scoreTimelimitMultiplier) or 0
		})
	end
end

function EVENT:Serialize()

end
