if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_bodyfound"
end

if SERVER then
	function EVENT:Trigger(finder, rag)
		local found = CORPSE.GetPlayer(rag)

		self:AddAffectedPlayers(finder:SteamID64(), found:SteamID64())

		return self:Add({
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
		})
	end

	function EVENT:Score(event)
		local finder = event.finder

		self:SetScore(finder:SteamID64(), {
			score = roles.GetByIndex(finder.role).scoreBodyFoundMuliplier
		})
	end
end

function EVENT:GetDeprecatedFormat(event)
	if self.event.roundState ~= ROUND_ACTIVE then return end

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

function EVENT:Serialize()

end
