--- @ignore

if CLIENT then
	EVENT.icon = nil
	EVENT.description = "desc_event_bodyfound"
end

if SERVER then
	function EVENT:Trigger(finder, rag)
		self:AddAffectedPlayers({finder:SteamID64(), CORPSE.GetPlayerSID64(rag)})

		return self:Add({
			finder = {
				nick = finder:Nick(),
				sid64 = finder:SteamID64(),
				role = finder:GetSubRole(),
				team = finder:GetTeam()
			},
			found = {
				nick = CORPSE.GetPlayerNick(rag, "A Terrorist"),
				sid64 = CORPSE.GetPlayerSID64(rag),
				role = CORPSE.GetPlayerRole(rag),
				team = CORPSE.GetPlayerTeam(rag),
				credits = CORPSE.GetCredits(rag, 0),
				headshot = CORPSE.WasHeadshot(rag) or false,
				time = math.Round((CORPSE.GetPlayerDeathTime(rag) - GAMEMODE.RoundStartTime) * 1000, 0)
			}
		})
	end

	function EVENT:CalculateScore()
		local event = self.event
		local finder = event.finder

		self:SetPlayerScore(finder.sid64, {
			score = roles.GetByIndex(finder.role).score.bodyFoundMuliplier
		})
	end
end

function EVENT:GetDeprecatedFormat()
	local event = self.event

	if event.roundState ~= ROUND_ACTIVE then return end

	local finder = event.finder
	local found = event.found

	return {
		id = self.type,
		t = event.time / 1000,
		ni = finder.nick,
		sid64 = finder.sid64,
		r = finder.role,
		tm = finder.team,
		b = found.nick
	}
end
