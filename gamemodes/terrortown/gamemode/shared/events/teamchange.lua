-- @ignore

if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_teamchange"
end

if SERVER then
	function EVENT:Trigger(ply, oldTeam, newTeam)
		self:AddAffectedPlayers(ply:SteamID64())

		return self:Add({
			nick = ply:Nick(),
			sid64 = ply:SteamID64(),
			oldTeam = oldTeam,
			newTeam = newTeam
		})
	end
end

function EVENT:Serialize()

end
