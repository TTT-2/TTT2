---
-- burning nade projectile
-- @class ENT
-- @section ttt_firegrenade_proj

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_flashbang_thrown.mdl")
-- The baseline size of each fire.
ENT.fireSize = 128
-- How much each individual fire can vary in their lifespan.
ENT.lifetimeVariance = 2
-- How far embers will be flung, increasing the area denial.
ENT.spreadForce = 500
-- Prevent lit fires from being flung by discombobulators.
ENT.fireImmobile = false
-- Should the grenade still make a damaging explosion if it is nullified by water or smoke?
ENT.explodeWhenSubmerged = true

---
-- @accessor number
-- @realm shared
AccessorFunc(ENT, "radius", "Radius", FORCE_NUMBER)

---
-- @accessor number
-- @realm shared
AccessorFunc(ENT, "dmg", "Dmg", FORCE_NUMBER)

---
-- @realm shared
function ENT:Initialize()
	if not self:GetRadius() then
		self:SetRadius(GetConVar("ttt2_firegrenade_proj_explosion_radius"):GetFloat())
	end
	if not self:GetDmg() then
		self:SetDmg(GetConVar("ttt2_firegrenade_proj_explosion_damage"):GetFloat())
	end

	self.BaseClass.Initialize(self)
end

---
-- @param TraceResult tr
-- @realm server
function ENT:Explode(tr)
	local pos = self:GetPos()

	-- pull out of the surface
	if tr.Hit then
		pos = tr.HitPos + tr.HitNormal * 0.6
	end
	self:SetPos(pos)

	self:SetFailedToActivate(bit.band( util.PointContents( pos ), CONTENTS_WATER ) == CONTENTS_WATER
		or gameEffects.IsPointInSmoke( pos ))

	if self:GetFailedToActivate() then
		if SERVER then
			self:AddFlags( FL_ONFIRE )
		end
		gameEffects.Extinguish(self)
	end

	if SERVER then
		self:SetNoDraw(true)
		self:SetSolid(SOLID_NONE)

		if self:GetFailedToActivate() and not self.explodeWhenSubmerged then
			self:Destroy()
			return true
		end
		local effect = EffectData()
		effect:SetStart(pos)
		effect:SetOrigin(pos)
		effect:SetScale(self:GetRadius() * 0.3)
		effect:SetRadius(self:GetRadius())
		effect:SetMagnitude(self.dmg)

		if tr.Hit then
			effect:SetNormal(tr.HitNormal)
		end

		util.Effect("Explosion", effect, true, true)
		util.BlastDamage(self, self:GetThrower(), pos, self:GetRadius(), self:GetDmg())

		if self:GetFailedToActivate() then
			self:Destroy()
			return true
		end

		gameEffects.StartFires(
			pos,
			tr,
			GetConVar("ttt2_firegrenade_proj_fire_num"):GetInt(),
			self.fireSize,
			GetConVar("ttt2_firegrenade_proj_fire_lifetime"):GetFloat(),
			self.lifetimeVariance,
			false,
			self:GetThrower(),
			self.spreadForce,
			self.fireImmobile
		)
		util.PaintDown(self:GetPos(), "Scorch", self)
	end
	return true
end
