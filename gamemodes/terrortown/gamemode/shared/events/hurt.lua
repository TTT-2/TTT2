--- @ignore

if CLIENT then
	EVENT.icon = nil
	EVENT.description = "desc_event_hurt"
end

if SERVER then
	function EVENT:Trigger(victim, attacker, dmgInfo)
		if not IsValid(victim) or not victim:IsPlayer() then return end

		self:AddAffectedPlayers({victim:SteamID64()})

		local event = {
			victim = {
				nick = victim:Nick(),
				sid64 = victim:SteamID64(),
				role = victim:GetSubRole(),
				team = victim:GetTeam()
			},
			dmg = {
				dmgInfo = dmgInfo,
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

			self:AddAffectedPlayers({attacker:SteamID64()})

			-- set death type
			if event.attacker.sid64 == event.victim.sid64 then
				event.type = HURT_SUICIDE
			else
				if event.attacker.team ~= TEAM_NONE and event.attacker.team == event.victim.team and not TEAMS[event.attacker.team].alone then
					event.type = HURT_TEAM
				else
					event.type = HURT_NORMAL
				end
			end
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

		return self:Add(event)
	end

	function EVENT:CalculateKarma()
		local event = self.event

		-- the event is only counted if it happened while the round was active
		if event.roundState ~= ROUND_ACTIVE then return end

		local victim = event.victim
		local attacker = event.attacker
		local dmginfo = event.dmg.dmgInfo

		if IsValid(attacker) and attacker:IsPlayer() and victim ~= attacker and GetRoundState() == ROUND_ACTIVE and math.floor(event.dmg.damage) > 0 then
			KARMA.Hurt(attacker, victim, dmginfo)
		end



		--[[ TODO Move Karma Change here?
		-- if there is no killer, it wasn't a suicide or a kill, therefore
		-- no points should be granted to anyone
		if not attacker then return end

		-- the karma is dependent of the teams/roles
		local roleData = roles.GetByIndex(attacker.role)


		if deathType == KILL_SUICIDE then
			self:SetPlayerKarma(victim.sid64, {
				karma = roleData.karma.suicideMultiplier
			})
		elseif deathType == KILL_TEAM then
			self:SetPlayerKarma(attacker.sid64, {
				karma = roleData.karma.teamKillsMultiplier
			})
		else
			self:SetPlayerKarma(attacker.sid64, {
				karma = roleData.karma.killsMultiplier
			})
		end
		--]]
	end
end
