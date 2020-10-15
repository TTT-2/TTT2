if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_game_creditfound"
end

if SERVER then
	function EVENT:Trigger(finder, rag, credits)
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
				credits = credits
			}
		})
	end
end

function EVENT:GetDeprecatedFormat(event)
	if self.event.roundState ~= ROUND_ACTIVE then return end

	return {
		id = self.type,
		t = event.time / 1000,
		ni = event.finder.nick,
		sid64 = event.finder.sid64,
		b = event.found.nick,
		cr = event.found.credits
	}
end

function EVENT:Serialize()

end
