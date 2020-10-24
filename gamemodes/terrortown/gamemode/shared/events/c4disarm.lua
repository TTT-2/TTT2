--- @ignore

if CLIENT then
	EVENT.icon = nil
	EVENT.description = "desc_event_c4_disarm"
end

if SERVER then
	function EVENT:Trigger(owner, disarmer, successful)
		self:AddAffectedPlayers({owner:SteamID64(), disarmer:SteamID64()})

		return self:Add({
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
		})
	end
end

function EVENT:GetDeprecatedFormat()
	local event = self.event

	if event.roundState ~= ROUND_ACTIVE then return end

	return {
		id = self.type,
		t = event.time / 1000,
		ni = event.disarmer.nick,
		own = event.owner.nick,
		s = event.successful
	}
end
