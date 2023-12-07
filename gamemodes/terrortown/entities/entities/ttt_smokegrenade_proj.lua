---
-- those particles that get in your way
-- @class ENT
-- @section ttt_smokegrenade_proj

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_smokegrenade_thrown.mdl")
ENT.ExplodeSound = Sound("entities/entities/ttt_smokegrenade_proj/airy_boom.wav")
-- The duration that the sound effect and smoke particles will clear over. This is after the lifetime. Set to 0 to end abruptly.
ENT.smokeFadeFactor = 1 / 6
-- Allow smokes to use a random color instead of variants of gray.
ENT.randomColor = false
-- Allow smokes to extinguish fires during their effect period within their radius.
ENT.extinguishesFires = true
-- The number of particles smokes will be comprised of.
ENT.density = 20
-- The radius that a smoke will occupy, visually and physically for extinguishing.
ENT.radius = 150
-- The baseline 'Value' component of the color of the smoke.
-- This controls the baseline 'Brightness' of each particle.
ENT.colorBase = 138
-- How much to trend away from the Color Value Base.
-- This value will be +/- that value, essentially controlling the range of brightness a smoke particle can generate with.
ENT.colorBaseVariance = 62
-- How large a smoke particle can generate, in proportion to its radius.
ENT.startSizeBaseScale = 1
-- How much to trend away from the Starting Size Base Scale.
-- This value will be +/- that value, essentially controlling how much each particle can differ in size by.
-- 0 = Every particle will be the same size.
ENT.startSizeBaseScaleVariance = 0.25
-- The size a particle should target as it fades out, in proportion to its radius.
ENT.endSizeBaseScale = 0.25
-- How much to trend away from Ending Size Base Scale.
-- This value will be +/- that value, essentially controlling how much each particle can differ in size by.
ENT.endSizeBaseScaleVariance = 0.05

---
-- @param TraceResult tr
-- @realm shared
function ENT:Explode(tr)
	if CLIENT then return true end
	self:SetNoDraw(true)
	self:SetSolid(SOLID_NONE)

	self:EmitSound(self.ExplodeSound, 120, 100, 1)

	local life_time = GetConVar("ttt2_smokegrenade_proj_smoke_life_time"):GetFloat()
	local data = {
		position = self:GetPos(),
		shared_seed = tostring(CurTime()),
		life_time = life_time,
		fade_time = math.max(0, life_time * self.smokeFadeFactor),

		random_color = self.randomColor,
		extinguishes_fires = self.extinguishesFires,

		density = self.density,
		radius = self.radius,

		color_base = self.colorBase,
		color_variance = self.colorBaseVariance,
	}
	data.start_size_base = math.Round(data.radius * self.endSizeBaseScale)
	data.start_size_variance = math.Round(data.radius * self.startSizeBaseScaleVariance)
	data.end_size_base = math.Round(data.radius * self.endSizeBaseScale)
	data.end_size_variance = math.Round(data.radius * self.endSizeBaseScaleVariance)

	gameEffects.SpawnSmoke(data)
	util.PaintDown(self:GetPos(), "SmallScorch", self)

	return true
end
