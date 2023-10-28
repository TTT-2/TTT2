---
-- common grenade projectile code
-- @class ENT
-- @section ttt_basegrenade_proj

AddCSLuaFile()

ENT.Type = "anim"
ENT.Model = Model("models/weapons/w_eq_flashbang_thrown.mdl")
ENT.playerDropWeaponOnContact = false
ENT.sphericalPhysicsRadius = 0
ENT.damageTriggerProjectileExplosion = true
ENT.preventDamageChainReaction = true
ENT.bounceFactor = 0
ENT.bounceMomentumLoss = 0
ENT.impactSoundSpeed = 50
ENT.throwSound = Sound("entities/entities/ttt_basegrenade_proj/toss.wav")
ENT.impactSound = Sound("entities/entities/ttt_basegrenade_proj/impact.wav")
ENT.pinSound = Sound("Default.PullPin_Grenade")

---
-- @realm shared
function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "ExplodeTime")
	self:NetworkVar("Bool", 0, "ShotToActivate")
	self:NetworkVar("Bool", 1, "FailedToActivate")
	self:NetworkVar("Bool", 2, "Exploded")
	self:NetworkVar("String", 0, "LaunchWeaponClass")
	self:NetworkVar("Entity", 0, "Thrower")

	if SERVER then
		self:SetExplodeTime(0)
		self:SetFailedToActivate(false)
		self:SetExploded(false)
		self:SetShotToActivate(false)
	end
end

---
-- @realm shared
function ENT:Initialize()
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
	self:SetModel(self.Model)

	if self.sphericalPhysicsRadius > 0 then
		self:PhysicsInitSphere(self.sphericalPhysicsRadius, "metal")
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid(SOLID_VPHYSICS)
	else
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_BBOX)
	end
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
end

---
-- Everything that needs cleaning up prior to removal, but OnRemove is too late for.
-- @realm shared
function ENT:Destroy()
	if CLIENT then return end
	self:SetExploded(true)
	self:SetDetonateExact(0)
	self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
	self:AddEFlags(EFL_DORMANT)
	self:Remove()
end

---
-- @param number length How far away _from now_ to detonate.
-- @realm shared
function ENT:SetDetonateTimer(length)
	self:SetDetonateExact( CurTime() + length )
end

---
-- @param nil|number t The time we should explode, or <code>CurTime()</code> if falsy.
-- @realm shared
function ENT:SetDetonateExact(t)
	if CLIENT then return end
	self:SetExplodeTime(t or CurTime())
end

---
-- override to describe what happens when the nade explodes
-- @param TraceResult tr
-- @realm shared
function ENT:Explode(tr)
	ErrorNoHalt("ERROR: BaseGrenadeProjectile explosion code not overridden!\n")
end

---
-- Attempt to detonate the projectile immediately.
-- This was externalized to permit detonation outside of the throw / release logic. (Mid-Air, other phenomenon)
-- @realm shared
function ENT:TryExplode()
	-- find the ground if it's near and pass it to the explosion
	local spos = self:GetPos()
	local tr = util.TraceLine({
		start = spos,
		endpos = spos + Vector(0,0,-32),
		mask = MASK_SHOT_HULL,
		filter = {self, self.thrower},
	})

	local success, did_explode = xpcall(self.Explode, function(err)
		-- prevent effect spam on Lua error
		if SERVER then self:Remove() end
		ErrorNoHalt("ERROR CAUGHT: ttt_basegrenade_proj: " .. err .. "\n")
	end, self, tr)
	if SERVER and (success or did_explode ~= false) then
		self:Destroy()
	end
end

---
-- @realm shared
function ENT:Think()
	local etime = self:GetExplodeTime() or 0

	if not self:GetExploded() and etime ~= 0 and etime < CurTime() then
		self:TryExplode()
		return
	end
end

if SERVER then
	---
	-- @realm server
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end

	---
	-- Called when a grenade projectile impacts the player.
	-- @param Player ply
	-- @realm server
	function ENT:ImpactPlayer(ply)
		if self.playerDropWeaponOnContact and ply:SafeDropWeapon(ply:GetActiveWeapon(), false) then
			ply:SetFOV(0, 0.2)
		end
	end

	---
	-- Called to resolve a bounce if this projectile is bouncy.
	-- @param CollisionData colData
	-- @param PhysObj collider
	-- @realm server
	function ENT:Bounce(colData, collider)
		local impulse = -colData.Speed * colData.HitNormal * self.bounceFactor + (colData.OurOldVelocity * -self.bounceMomentumLoss)
		collider:ApplyForceCenter(impulse)
	end

	---
	-- @param CollisionData colData
	-- @param PhysObj collider
	-- @realm server
	function ENT:PhysicsCollide(colData, collider)
		local ply = colData.HitEntity
		if IsValid(ply) and ply:IsPlayer() and ply:IsTerror() and (not ply:IsSpec()) and ply:Alive() then
			self:ImpactPlayer(ply)
		end

		if colData.Speed > self.impactSoundSpeed then
			self:EmitSound(self.impactSound)
		end

		if self.bounceFactor > 0 or self.bounceMomentumLoss ~= 0 then
			self:Bounce(colData, collider)
		end
	end
end
