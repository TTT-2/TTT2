if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_spawn"
end

if SERVER then
	function EVENT:Trigger(ply)
		self:AddAffectedPlayers(ply:SteamID64())

		return self:Add({
			nick = ply:Nick(),
			sid64 = ply:SteamID64()
		})
	end
end

function EVENT:GetDeprecatedFormat(event)
	--if event.roundState ~= ROUND_ACTIVE then return end

	return {
		id = self.type,
		t = event.time / 1000,
		ni = event.nick,
		sid64 = event.sid64
	}
end

function EVENT:Serialize()

end
