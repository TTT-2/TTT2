---
-- fire handler that does owned damage
-- @class ENT
-- @section ttt_flame

AddCSLuaFile()

ENT.Type = "anim"
ENT.Model = Model("models/weapons/w_eq_flashbang_thrown.mdl")

---
-- @accessor Player
-- @realm shared
AccessorFunc(ENT, "dmgparent", "DamageParent")

---
-- @accessor boolean
-- @realm shared
AccessorFunc(ENT, "die_explode", "ExplodeOnDeath")

---
-- @accessor number
-- @realm shared
AccessorFunc(ENT, "dietime", "DieTime")

ENT.firechild = nil
ENT.fireparams = {
	size = 120,
	growth = 1
}

ENT.next_hurt = 0
ENT.hurt_interval = 1

---
-- @realm shared
function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Burning")
end

---
-- @realm shared
function ENT:Initialize()
	self:SetModel(self.Model)
	self:DrawShadow(false)
	self:SetNoDraw(true)

	if CLIENT and GetConVar("ttt_fire_fallback"):GetBool() then
		self.Draw = self.BackupDraw
		self:SetNoDraw(false)
	end

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetHealth(99999)

	self.next_hurt = CurTime() + self.hurt_interval + math.Rand(0, 3)

	self:SetBurning(false)

	if self:GetDieTime() == 0 then self:SetDieTime( CurTime() + 20 ) end
end

---
-- @realm shared
function ENT:Explode()
	local pos = self:GetPos()

	local effect = EffectData()
	effect:SetStart(pos)
	effect:SetOrigin(pos)
	effect:SetScale(256)
	effect:SetRadius(256)
	effect:SetMagnitude(50)

	util.Effect("Explosion", effect, true, true)

	local dmgowner = self:GetDamageParent()
	if not IsValid(dmgowner) then
		dmgowner = self
	end
	util.BlastDamage(self, dmgowner, pos, 300, 40)
end

if SERVER then
	---
	-- @realm server
	function ENT:OnTakeDamage()
	end

	---
	-- @param Vector pos The place a fire should originate from.
	-- @param TraceResult tr The trace to set a fire with.
	-- @param number num The number of fires to start.
	-- @param number lifetime The base lifespan of each flame.
	-- @param boolean explode Should the fire explode on death?
	-- @param nil|Player dmgowner The player that began the fire, if any.
	-- @realm server
	function StartFires(pos, tr, num, lifetime, explode, dmgowner)
		for i = 1, num do
			local ang = Angle(-math.Rand(0, 180), math.Rand(0, 360), math.Rand(0, 360))

			local vstart = pos + tr.HitNormal * 64

			local flame = ents.Create("ttt_flame")
			flame:SetPos(vstart)
			if IsValid(dmgowner) and dmgowner:IsPlayer() then
				flame:SetDamageParent(dmgowner)
				flame:SetOwner(dmgowner)
			end
			flame:SetDieTime(CurTime() + lifetime + math.Rand(-2, 2))
			flame:SetExplodeOnDeath(explode)

			flame:Spawn()
			flame:PhysWake()

			local phys = flame:GetPhysicsObject()
			if IsValid(phys) then
				-- the balance between mass and force is subtle, be careful adjusting
				phys:SetMass(2)
				phys:ApplyForceCenter(ang:Forward() * 500)
				phys:AddAngleVelocity(Vector(ang.p, ang.r, ang.y))
			end
		end
	end

	---
	-- @param Vector pos The place a fire should originate from.
	-- @param number size How large a fire should be.
	-- @param number attack How much damage a fire should inflict.
	-- @param number fuel The health / duration of a fire.
	-- @param nil|Player dmgowner The player that began the fire, if any.
	-- @param nil|Entity parent The entity that controls the created fire, usually a ttt_flame.
	-- @realm server
	function SpawnFire(pos, size, attack, fuel, owner, parent)
		local fire = ents.Create("env_fire")
		if not IsValid(fire) then return end

		fire:SetParent(parent)
		fire:SetOwner(owner)
		fire:SetPos(pos)
		--no glow + delete when out + start on + last forever
		fire:SetKeyValue("spawnflags", tostring(128 + 32 + 4 + 2 + 1))
		fire:SetKeyValue("firesize", size * math.Rand(0.7, 1.1))
		fire:SetKeyValue("fireattack", attack)
		fire:SetKeyValue("health", fuel)
		fire:SetKeyValue("damagescale", "-10") -- only neg. value prevents dmg

		fire:Spawn()
		fire:Activate()

		return fire
	end

	---
	-- greatly simplified version of SDK's game_shard/gamerules.cpp:RadiusDamage
	-- does no block checking, radius should be very small
	-- @param CTakeDamageInfo dmginfo The damage to inflict.
	-- @param Vector pos The origin of the damage radius.
	-- @param number radius The radius of the damage to inflict.
	-- @param nil|Player inflictor The player responsible for the damage.
	-- @realm server
	function RadiusDamage(dmginfo, pos, radius, inflictor)
		for k, vic in ipairs(ents.FindInSphere(pos, radius)) do
			if not IsValid(vic) or not inflictor:Visible(vic) or not vic:IsPlayer() or not vic:IsTerror() then continue end

			vic:TakeDamageInfo(dmginfo)
		end
	end
end

if SERVER then
	---
	-- @realm server
	function ENT:Think()
		if self:GetDieTime() < CurTime() then
			if self:GetExplodeOnDeath() then
				local success, err = pcall(self.Explode, self)

				if not success then
					ErrorNoHaltWithStack("ERROR CAUGHT: ttt_flame: " .. err .. "\n")
				end
			end

			self:Remove()

			return
		end

		if IsValid(self.firechild) then
			if self.next_hurt < CurTime() then
				if self:WaterLevel() > 0 then
					self:SetDieTime(0)
					return
				end

				-- deal damage
				local dmg = DamageInfo()
				dmg:SetDamageType(DMG_BURN)
				dmg:SetDamage(math.random(4,6))
				if IsValid(self:GetDamageParent()) then
					dmg:SetAttacker(self:GetDamageParent())
				else
					dmg:SetAttacker(self)
				end
				dmg:SetInflictor(self.firechild)

				RadiusDamage(dmg, self:GetPos(), 132, self)

				self.next_hurt = CurTime() + self.hurt_interval
			end

			return
		elseif self:GetVelocity() == Vector(0,0,0) then
			if self:WaterLevel() > 0 then
				self:SetDieTime(0)

				return
			end

			self.firechild = SpawnFire(self:GetPos(), self.fireparams.size, self.fireparams.growth, 999, self:GetDamageParent(), self)
			self:DeleteOnRemove(self.firechild)

			self:SetBurning(true)
		end
	end
end

if CLIENT then
	---
	-- @realm client
	CreateConVar("ttt_fire_fallback", "0", FCVAR_ARCHIVE)

	local fakefire = Material("cable/smoke")
	local side = Angle(-90, 0, 0)

	---
	-- @realm client
	function ENT:BackupDraw()
		if not self:GetBurning() then return end

		local vstart = self:GetPos()
		local vend = vstart + Vector(0, 0, 90)

		side.r = side.r + 0.1

		cam.Start3D2D(vstart, side, 1)
		draw.DrawText("FIRE! IT BURNS!", "Default", 0, 0, COLOR_RED, TEXT_ALIGN_CENTER)
		cam.End3D2D()

		render.SetMaterial(fakefire)
		render.DrawBeam(vstart, vend, 80, 0, 0, COLOR_RED)
	end

	---
	-- @realm client
	function ENT:Draw()
	end
end
