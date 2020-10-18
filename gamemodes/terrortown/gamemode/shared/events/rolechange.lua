--- @ignore

if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_rolechange"
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

function EVENT:Serialize()

end
