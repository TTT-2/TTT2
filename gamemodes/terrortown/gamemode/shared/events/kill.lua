if CLIENT then
	EVENT.icon = Material("")
	EVENT.description = "desc_event_kill"
end

function EVENT:Trigger(victim, attacker, dmgInfo)
	if not IsValid(victim) or not victim:IsPlayer() then return end

	local event = {
		victim = {
			nick = victim:Nick(),
			sid64 = victim:SteamID64(),
			role = victim:GetSubRole(),
			team = victim:GetTeam()
		},
		dmg = {
			headshot = victim.was_headshot,
			type = dmgInfo:GetDamageType(),
			damage = dmgInfo:GetDamage()
		}
	}

	if IsValid(attacker) and attacker:IsPlayer() then
		event.attacker = {
			nick = attacker:Nick(),
			health = attacker:Health(),
			armor = attacker:GetArmor(),
			sid64 = attacker:SteamID64(),
			role = attacker:GetSubRole(),
			team = attacker:GetTeam()
		}
	end

	local wep = util.WeaponFromDamage(dmgInfo)

	if wep then
		local id = WepToEnum(wep)

		if id then
			event.dmg.weapon = id
		else
			event.dmg.weapon = wep:GetClass()
		end
	else
		-- handle the name of the inflictor if it was caused by a trap
		local inflictor = dmgInfo:GetInflictor()

		if IsValid(inflictor) and inflictor.ScoreName then
			event.dmg.name = inflictor.ScoreName
		end
	end

	self:Add(event)
end

function EVENT:Score()

end

function EVENT:Serialize()

end
