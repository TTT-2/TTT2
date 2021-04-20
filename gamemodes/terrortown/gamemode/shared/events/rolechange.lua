--- @ignore

if CLIENT then
	--EVENT.icon = nil
	EVENT.title = "title_event_rolechange"

	function EVENT:GetText()
		return {
			{
				string = "desc_event_rolechange",
				params = {
					player = self.event.nick,
					orole = roles.GetByIndex(self.event.oldRole).name,
					oteam = self.event.oldTeam,
					nrole = roles.GetByIndex(self.event.newRole).name,
					nteam = self.event.newTeam
				},
				translateParams = true
			}
		}
	end
end

if SERVER then
	function EVENT:Trigger(ply, oldRole, newRole, oldTeam, newTeam)
		self:AddAffectedPlayers({ply:SteamID64()})

		return self:Add({
			nick = ply:Nick(),
			sid64 = ply:SteamID64(),
			oldRole = oldRole,
			newRole = newRole,
			oldTeam = oldTeam,
			newTeam = newTeam
		})
	end
end
