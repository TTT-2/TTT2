--- @ignore

if CLIENT then
	EVENT.icon = nil
	EVENT.description = "desc_event_rolechange"
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
