if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_respawn"
end

if SERVER then
	function EVENT:Trigger(ply)
		local event = {
			nick = ply:Nick(),
			sid64 = ply:SteamID64()
		}

		return event
	end
end

function EVENT:Serialize()

end
