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

	return event
end

function EVENT:Score(event)
	-- the event is only counted if it happened while the round was active
	if event.roundState ~= ROUND_ACTIVE then return end

	local victim = event.victim
	local attacker = event.attacker

	-- if there is no killer, it wasn't a suicide or a kill, therefore
	-- no points should be granted to anyone
	if not attacker then return end

	if attacker.sid64 == victim.sid64 then
		-- suicide gives a penalty of one point
		victim.score = -1
	else
		-- the score is dependent of the teams/roles
		local roleData = roles.GetByIndex(attacker.role)

		if attacker.team ~= TEAM_NONE and attacker.team == victim.team and not TEAMS[attacker.team].alone then
			-- handle team kill
			attacker.score = roleData.scoreTeamKillsMultiplier or 0
		else
			-- handle legit kill
			attacker.score = roleData.scoreKillsMultiplier or 0
		end
	end
end

function EVENT:Serialize()

end
