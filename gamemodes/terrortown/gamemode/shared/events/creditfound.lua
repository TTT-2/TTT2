--- @ignore

if CLIENT then
	EVENT.icon = nil
	EVENT.description = "desc_event_game_creditfound"
end

if SERVER then
	function EVENT:Trigger(finder, rag, credits)
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
				credits = credits
			}
		})
	end
end

function EVENT:GetDeprecatedFormat()
	local event = self.event

	if event.roundState ~= ROUND_ACTIVE then return end

	return {
		id = self.type,
		t = event.time / 1000,
		ni = event.finder.nick,
		sid64 = event.finder.sid64,
		b = event.found.nick,
		cr = event.found.credits
	}
end
