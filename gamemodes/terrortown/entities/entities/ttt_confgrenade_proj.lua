---
-- @class ENT
-- @section ttt_confgrenade_proj

---
-- @realm server
local ttt_allow_jump = CreateConVar("ttt_allow_discomb_jump", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY})

if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	game.AddParticles("particles/entities/entities/ttt_confgrenade_proj/electric_explosion.pcf")
	PrecacheParticleSystem("electric_explosion")
end

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_fraggrenade_thrown.mdl")
ENT.impactSound = Sound("entities/entities/ttt_confgrenade_proj/cartoon_impact.wav")
-- The range in which things will be affected by the push impulse upon the projectile exploding.
ENT.pushRadius = 400
-- The force that will be applied to players upon the projectile exploding.
ENT.playerPushForce = 256
-- The force that will be applied to non-players upon the projectile exploding.
ENT.propPushForce = 1500
-- The range in which players will be damaged instantly upon the projectile exploding.
ENT.explosionRadius = 0
-- The amount of damage to apply to players within range instantly upon the projectile exploding.
ENT.explosionDamage = 0
-- The bounciness of the projectile, bigger number is bouncier.
ENT.bounceFactor = 0.4
-- How much of the momentum to maintain after each collision. 0 = None, 1 = All of it.
ENT.bounceMomentumLoss = 0.6

---
-- @accessor number
-- @realm shared
AccessorFunc(ENT, "dmg", "Dmg", FORCE_NUMBER)

if SERVER then
	---
	-- Called whenever a ConfGrenade (discombob) detonates.
	-- @param Entity grenade The grenade that caused the explosion.
	-- @param Player ply The player that was responsible for the grenade detonating.
	-- @param Vector pos The location the grenade was when it detonated.
	-- @param number radius The area of effect that the grenade will use to simulate pushing.
	-- @param number force The strength the grenade will use to push things by.
	-- @realm server
	function GAMEMODE:TTT2ConfGrenadeExplode(grenade, ply, pos, radius, force)

	end
end

---
-- @param TraceResult tr
-- @realm server
function ENT:Explode(tr)
	---
	-- @realm shared
	hook.Run("TTT2ConfGrenadeExplode",
		self:GetPos(),
		self.pushRadius,
		self.propPushForce
	)

	local pos = self:GetPos()
	-- pull out of the surface
	if tr.Hit then
		pos = tr.HitPos + tr.HitNormal * 0.6
	end
	local normal = nil
	if tr.Hit then
		normal = tr.HitNormal
	end

	if SERVER then
		self:SetPos(pos)
		self:SetNoDraw(true)
		self:SetSolid(SOLID_NONE)

		gameEffects.DiscombobEffect(pos, normal)

		local radius = self.pushRadius
		local player_push_force = self.playerPushForce
		local prop_push_force = self.propPushForce
		gameEffects.PushPullRadius(pos, radius, self:GetThrower(), player_push_force, prop_push_force, ttt_allow_jump:GetBool(), self:GetLaunchWeaponClass())

		local dmg_range = self.explosionRadius
		local dmg_amt = self:GetDmg()
		if dmg_range > 0 and dmg_amt > 0 then
			util.BlastDamage(self, self:GetThrower(), pos, dmg_range, dmg_amt)
		end
		util.PaintDown(self:GetPos(), "SmallScorch", self)
	end
end
