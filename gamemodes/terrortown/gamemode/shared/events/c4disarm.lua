--- @ignore

if CLIENT then
	--EVENT.icon = nil
	EVENT.title = "title_event_c4_disarm"

	function EVENT:GetText()
		if self.event.successful then
			return {
				{
					string = "desc_event_c4_disarm_success",
					params = {
						owner = self.event.owner.nick,
						disarmer = self.event.disarmer.nick,
						orole = roles.GetByIndex(self.event.owner.role).name,
						oteam = self.event.owner.team,
						drole = roles.GetByIndex(self.event.disarmer.role).name,
						dteam = self.event.disarmer.team
					},
					translateParams = true
				}
			}
		else
			return {
				{
					string = "desc_event_c4_disarm_failed",
					params = {
						owner = self.event.owner.nick,
						disarmer = self.event.disarmer.nick,
						orole = roles.GetByIndex(self.event.owner.role),
						oteam = self.event.owner.team,
						drole = roles.GetByIndex(self.event.disarmer.role),
						dteam = self.event.disarmer.team
					},
					translateParams = true
				}
			}
		end
	end
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
