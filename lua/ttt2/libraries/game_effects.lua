---
-- A library to consolidate some common effects code.
-- @author EntranceJew
-- @module gameEffects
if SERVER then
	AddCSLuaFile()
end

gameEffects = {}
gameEffects.extinguishables = {"ttt_flame", "vfire", "vfire_cluster", "vfire_ball", "entityflame", "env_fire"}

---
-- @param Entity ent The entity whomst's anti-flammability is under question.
-- @realm shared
function gameEffects.IsExtinguishableEntity(ent)
	return (ent.GetClass and table.HasValue(gameEffects.extinguishables, ent:GetClass()))
		or ent:IsOnFire()
end

---
-- A hook provided by Rubat's Fire Extinguisher, which many other addons implement or hook into.
-- @param Entity ent The entity to attempt extinguishing.
-- @return boolean|nil Return true to prevent extinguishing.
-- @ref https://steamcommunity.com/sharedfiles/filedetails/?id=104607228
-- @realm shared
function GM:ExtinguisherDoExtinguish(ent)

end

---
-- Take an entity that is on fire, and make it not on fire.
-- @param Entity ent The entity to remove flames from.
-- @return boolean If the entity was extinguished.
-- @realm shared
function gameEffects.Extinguish(ent)
	local class = ent:GetClass()

	---
	-- @realm shared
	if hook.Run("ExtinguisherDoExtinguish", ent) == true then return false end

	local didExtinguish = false
	if SERVER then
		if ent:IsOnFire() or ent:IsFlagSet( FL_ONFIRE ) then
			ent:Extinguish()
			ent:RemoveFlags( FL_ONFIRE )
			didExtinguish = true
		end

		if string.find(class, "env_fire") then
			ent:Fire("Extinguish")
			didExtinguish = true
		elseif string.find(class, "ent_minecraft_torch") and ent:GetWorking() then
			ent:SetWorking(false)
			didExtinguish = true
		end
	end

	if SERVER and gameEffects.IsExtinguishableEntity(ent) then
		ent:Remove()
		didExtinguish = true
	end

	if didExtinguish then
		sound.Play(Sound("ttt2/sfx/extinguish_fizzle.wav"), ent:GetPos(), 65, 144, 1)
	end

	return didExtinguish
end

---
-- @param number pos The location to attempt extinguishing around.
-- @param number radius The radius to extinguish all entities found within.
-- @realm shared
function gameEffects.ExtinguishInRadius(pos, radius)
	local foundEnts = ents.FindInSphere(pos, radius)
	for i = 1, #foundEnts do
		gameEffects.Extinguish(foundEnts[i])
	end
end

---
-- @param Vector pos The point in question.
-- @return boolean Whether the provided point was inside the radius of an active smoke.
-- @realm shared
function gameEffects.IsPointInSmoke(pos)
	local smokes = ents.FindByClass("ttt_smoke")
	for i = 1, #smokes do
		local smoke = smokes[i]
		if smoke:GetAlive() and pos:DistToSqr(smoke:GetPos()) < (smoke:GetRadius() ^ 2) then
			return true
		end
	end
	return false
end

---
-- @param table data
-- @note Structure of data = {
-- 	position --[[Vector]],
-- 	shared_seed --[[string]],
-- 	life_time --[[number]],
-- 	fade_time --[[number]],
-- 	random_color --[[boolean]],
-- 	extinguishes_fires --[[boolean]],
-- 	density --[[number]],
-- 	radius --[[number]],
-- 	color_base --[[number]],
-- 	color_variance --[[number]],
-- 	start_size_base --[[number]],
-- 	start_size_variance --[[number]],
-- 	end_size_base --[[number]],
-- 	end_size_variance --[[number]],
--  set_color --[[nil|Color]], -- if set, overrides final color, if omitted, smoke generation is ran and passed in
-- }
-- @realm server
function gameEffects.SpawnSmoke(data)
	local smoke = ents.Create("ttt_smoke")
	smoke:Setup()
	if SERVER then
		smoke:SetPos(data.position)
		smoke:SetSharedSeed(data.shared_seed)

		smoke:SetLifeTime(data.life_time)
		smoke:SetFadeTime(data.fade_time)

		smoke:SetRandomColor(data.random_color or false)
		smoke:SetExtinguishesFires(data.extinguishes_fires or false)

		smoke:SetDensity(data.density)
		smoke:SetRadius(data.radius)

		smoke:SetColorBase(data.color_base)
		smoke:SetColorVariance(data.color_variance)
		smoke:SetStartSizeBase(data.start_size_base)
		smoke:SetStartSizeVariance(data.start_size_variance)
		smoke:SetEndSizeBase(data.end_size_base)
		smoke:SetEndSizeVariance(data.end_size_variance)

		-- override with definitive argument
		local clr
		if data.set_color then
			clr = data.set_color
		else
			clr = smoke:GenerateSmokeColor()
		end
		smoke:SetSmokeColor(Color(clr.r, clr.g, clr.b):ToVector())
	end

	smoke:Spawn()
	smoke:Activate()
end

---
-- Create a bundle of fires all from a central location.
-- This is used for incendiary grenades or C4 detonation.
-- @param Vector pos The position the fires should originate from.
-- @param TraceResult tr A trace to orient the creation of the fires around.
-- @param number num The number of individual balls of fire that should be created.
-- @param number size The physical scale of the fires.
-- @param number lifetime The base lifetime of all fires in the bundle.
-- @param number lifetime_variance The amount each lifetime for each fire can vary.
-- @param boolean explode Should the fires explode when they reach the end of their lives?
-- @param nil|Player dmgowner The player to attribute the fire damage to.
-- @param number spread_force The force that each fire will be flung with.
-- @param boolean immobile If true, fires will become stationary once they begin burning.
-- @return table A table full of the fire entities.
-- @realm shared
function gameEffects.StartFires(pos, tr, num, size, lifetime, lifetime_variance, explode, dmgowner, spread_force, immobile)
	local flames = {}
	for i = 1, num do
		local ang = Angle(-math.Rand(0, 180), math.Rand(0, 360), math.Rand(0, 360))
		local vstart = pos + tr.HitNormal * 64
		local ttl = lifetime + math.Rand(-lifetime_variance, lifetime_variance)
		if CreateVFireBall then
			flames[#flames + 1] = CreateVFireBall(ttl, size, vstart, ang:Forward() * spread_force, dmgowner)
			continue
		end

		local flame = ents.Create("ttt_flame")
		flame:SetPos(vstart)
		flame:SetFlameSize(size)
		flame:SetLifeSpan(ttl)
		flame:SetImmobile(immobile)
		if IsValid(dmgowner) and dmgowner:IsPlayer() then
			flame:SetDamageParent(dmgowner)
			flame:SetOwner(dmgowner)
		end

		flame:SetDieTime(CurTime() + ttl)
		flame:SetExplodeOnDeath(explode)
		flame:Spawn()
		flame:PhysWake()
		local phys = flame:GetPhysicsObject()
		if IsValid(phys) then
			-- the balance between mass and force is subtle, be careful adjusting
			phys:SetMass(2)
			phys:ApplyForceCenter(ang:Forward() * spread_force)
			phys:AddAngleVelocity(Vector(ang.p, ang.r, ang.y))
		end
		flames[#flames + 1] = flame
	end
	return flames
end

---
-- Creates a single point of fire, with optional vfire support.
-- @param Vector pos The position to create the fire at.
-- @param number scale Controls the height of the flame more than its radius. Informs the size.
-- @param number ignite_delay The time before the fire becomes a full flame.
-- @param number life_span How long a fire will burn for.
-- @param nil|Entity owner The creator of the fire.
-- @param nil|Entity parent The thing to attach the fire to.
-- @return nil|Entity The fire it created, or nil if it was merged / couldn't be created.
-- @realm server
function gameEffects.SpawnFire(pos, scale, ignite_delay, life_span, owner, parent)
	if CreateVFire then
		return CreateVFire(nil, pos, vector_up, life_span, owner)
	end

	local fire = ents.Create("env_fire")
	if not IsValid(fire) then return end

	fire:SetParent(parent)
	fire:SetOwner(owner)
	fire:SetPos(pos)
	--no glow + delete when out + start on + last forever
	fire:SetKeyValue("spawnflags", tostring(128 + 32 + 4 + 2 + 1))
	fire:SetKeyValue("firesize", tostring(scale)) -- hardly controls size, hitbox is goofy, impossible to work with
	fire:SetKeyValue("fireattack", tostring(ignite_delay))
	fire:SetKeyValue("health", tostring(life_span))
	fire:SetKeyValue("ignitionpoint", "64")
	fire:SetKeyValue("damagescale", "0")
	fire:Spawn()
	fire:Activate()

	return fire
end

---
-- greatly simplified version of SDK's game_shard/gamerules.cpp:RadiusDamage
-- does no block checking, radius should be very small
-- @note only hits players!
-- @param DamageInfo dmginfo
-- @param Vector pos
-- @param number radius
-- @param Entity inflictor
-- @todo C4 uses a completely different method for this, so do all grenades, maybe fix that?
-- @todo This seems to do similar checking as util.BlastDamageInfo might, consider comparing them
-- @realm shared
function gameEffects.RadiusDamage(dmginfo, pos, radius, inflictor)
	for k, vic in ipairs(ents.FindInSphere(pos, radius)) do
		if IsValid(vic) and inflictor:Visible(vic) and vic:IsPlayer() and vic:Alive() and vic:IsTerror() then
			vic:TakeDamageInfo(dmginfo)
		end
	end
end

---
-- just makes an effect for the discombob, no real motion
-- @param Vector pos
-- @param Vector effectNormal
-- @realm shared
function gameEffects.DiscombobEffect(pos, effectNormal)
	local effect = EffectData()
	effect:SetStart(pos)
	effect:SetOrigin(pos)

	if effectNormal ~= nil then
		effect:SetNormal(effectNormal)
	end

	ParticleEffect("electric_explosion", pos, angle_zero, nil)
	util.Effect("Explosion", effect, true, true)

	sound.Play(Sound("npc/assassin/ball_zap1.wav"), pos, 100, 100)
end

---
-- @param Vector pos
-- @param number radius
-- @param nil|Entity pusher
-- @param number player_push_force
-- @param number prop_push_force
-- @param boolean do_vertical
-- @param nil|Entity|string inflictor
-- @realm server
function gameEffects.PushPullRadius(pos, radius, pusher, player_push_force, prop_push_force, do_vertical, inflictor)
	local entsInSphere = ents.FindInSphere(pos, radius)

	-- pull physics objects and push players
	for i = 1, #entsInSphere do
		local target = entsInSphere[i]

		if not IsValid(target) then continue end

		local tpos = target:LocalToWorld(target:OBBCenter())
		local dir = (tpos - pos):GetNormal()
		local phys = target:GetPhysicsObject()

		if target:IsPlayer() and not target:IsFrozen() and (not target.was_pushed or target.was_pushed.t ~= CurTime()) then
			-- always need an upwards push to prevent the ground's friction from
			-- stopping nearly all movement
			dir.z = math.abs(dir.z) + 1

			local push = dir * player_push_force

			-- try to prevent excessive upwards force
			local vel = target:GetVelocity() + push
			vel.z = math.min(vel.z, player_push_force)

			-- mess with discomb jumps
			if pusher == target and not do_vertical then
				vel = VectorRand() * vel:Length()
				vel.z = math.abs(vel.z)
			end

			target:SetVelocity(vel)

			target.was_pushed = {
				att = pusher,
				t = CurTime(),
				wep = inflictor,
			}
		elseif IsValid(phys) then
			phys:ApplyForceCenter(dir * -1 * prop_push_force)
		end
	end

	local phexp = ents.Create("env_physexplosion")

	if IsValid(phexp) then
		phexp:SetPos(pos)
		phexp:SetKeyValue("magnitude", 100) --max
		phexp:SetKeyValue("radius", radius)
		-- 1 = no dmg, 2 = push ply, 4 = push radial, 8 = los, 16 = viewpunch
		phexp:SetKeyValue("spawnflags", 1 + 2 + 16)
		phexp:Spawn()
		phexp:Fire("Explode", "", 0.2)
	end
end
