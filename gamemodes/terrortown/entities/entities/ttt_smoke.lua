---
-- smoke handler that does psychic damage
-- @class ENT
-- @section ttt_smoke

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = Model("models/weapons/w_eq_smokegrenade_thrown.mdl")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.SmokeEmissionSound = Sound("npc/env_headcrabcanister/hiss.wav")
ENT.LoopSound = nil --[[@as CSoundPatch]]
ENT.Emitter = nil --[[@as CLuaEmitter]]
ENT.SmokeParticles = {
	Model("particle/particle_smokegrenade"),
	Model("particle/particle_noisesphere")
}
ENT.SmokeColors = {
	black       = Color(  0,   0,   0, 255),
	blue        = Color(  0,   0, 255, 255),
	cyan        = Color( 14, 236, 232, 255),
	darkblue    = Color(  0,   0, 100, 255),
	darkgreen   = Color(  0, 100,   0, 255),
	darkpurple  = Color( 51,  16,  75, 255),
	green       = Color(  0, 255,   0, 255),
	lightgray   = Color(200, 200, 200, 255),
	lightpurple = Color(140,  23, 217, 255),
	lime        = Color(175, 237,  18, 255),
	olive       = Color(100, 100,   0, 255),
	orange      = Color(250, 100,   0, 255),
	pink        = Color(255,   0, 255, 255),
	purple      = Color(100,  18, 155, 255),
	red         = Color(255,   0,   0, 255),
	white       = Color(255, 255, 255, 255),
	yellow      = Color(200, 200,   0, 255),
}
ENT.driftVelocity = 1.5
ENT.dispersalVelocity = 5
ENT.rollVariance = 180
ENT.rollDeltaVariance = 0.1
ENT.airResistance = 600
ENT.disperseAirResistMultiplier = 0.5
ENT.disperseGravityMultiplier = 0.25
ENT.bounce = 0.4
ENT.particles = {}
ENT.particleData = {}
ENT.debugViz = false
ENT.debugRange = false

---
-- @realm shared
function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "SharedSeed")

	self:NetworkVar("Float", 0, "LifeTime")
	self:NetworkVar("Float", 1, "FadeTime")

	self:NetworkVar("Bool", 0, "RandomColor")
	self:NetworkVar("Bool", 1, "ExtinguishesFires")

	self:NetworkVar("Int", 0, "Density")
	self:NetworkVar("Int", 1, "Radius")

	self:NetworkVar("Int", 2, "ColorBase")
	self:NetworkVar("Int", 3, "ColorVariance")
	self:NetworkVar("Int", 4, "StartSizeBase")
	self:NetworkVar("Int", 5, "StartSizeVariance")
	self:NetworkVar("Int", 6, "EndSizeBase")
	self:NetworkVar("Int", 7, "EndSizeVariance")

	-- extra, non-smoke-data-reflecting
	self:NetworkVar("Vector", 0, "SmokeColor")
	self:NetworkVar("Float", 2, "CreatedAt")
	self:NetworkVar("Bool", 2, "Alive")
	self:NetworkVar("Float", 3, "DeactivateTime")
end

---
-- @realm shared
function ENT:Initialize()
	if self.debugViz then
		self:SetMaterial("models/shiny.vtf")
		self:SetColor( Color(255, 200, 0, 128) )
	else
		self.RenderGroup = RENDERGROUP_TRANSLUCENT
		self:DrawShadow(false)
		self:SetNoDraw(false)
	end
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )

	if SERVER then
		local rf = RecipientFilter()
		rf:AddAllPlayers()
		self.LoopSound = CreateSound( self or game.GetWorld(), self.SmokeEmissionSound, rf ) --[[@as CSoundPatch]]
		self.LoopSound:PlayEx(0.125, 32)
		self:SetCreatedAt(CurTime())
		self:SetAlive(true)
	else
		self:Setup()

		if self.debugViz then return end

		self:ClientEffect()
	end

	if self.debugRange then
		debugoverlay.Sphere(self:GetPos(), self:GetRadius(), self:GetLifeTime() + self:GetFadeTime(), Color(0, 0, 16, 32))
		debugoverlay.Sphere(self:GetPos(), 10, self:GetLifeTime() + self:GetFadeTime(), Color(0, 0, 16, 32))
	end
end

---
-- We use this as a way to setup the RandomWrap function inside of a predicted hook. (Initialize)
-- This ensures that CurTime() is the same for server/client, and therefore util.SharedRandom will be identical.
-- @realm client
function ENT:Setup()
	local call = 0

	local seed = tostring(CurTime())
	self.RandomWrap = function(min_value, max_value)
		local value = util.SharedRandom(seed, min_value, max_value, call)
		call = call + 1

		return value
	end
end

---
-- @realm shared
function ENT:Think()
	if self:GetExtinguishesFires() then
		gameEffects.ExtinguishInRadius(self:GetPos(), self:GetRadius())
	end

	if self:GetAlive() and CurTime() > (self:GetCreatedAt() + self:GetLifeTime()) then
		self:Dissipate()
	end
	if SERVER and not self:GetAlive() and CurTime() > (self:GetDeactivateTime() + self:GetFadeTime()) then
		self:Remove()
	end
end

---
-- Gets a point within a sphere that is suitably random, and uses our PRNG (SharedRandom).
-- @todo move to a library or util, idk
-- @realm shared
function ENT:PointInSphere()
	local RandomWrap = self.RandomWrap

	local u = RandomWrap(0, 1)
	local v = RandomWrap(0, 1)
	local theta = u * 2.0 * math.pi
	local phi = math.acos(2.0 * v - 1.0)
	local r = math.pow(RandomWrap(0, 1), 1 / 2)
	local sinTheta = math.sin(theta)
	local cosTheta = math.cos(theta)
	local sinPhi = math.sin(phi)
	local cosPhi = math.cos(phi)
	local x = r * sinPhi * cosTheta
	local y = r * sinPhi * sinTheta
	local z = r * cosPhi
	return Vector(x, y, z)
end

---
-- Initiates the smoke effect and spawns all the particles, by reading all the data on this entity.
-- @realm client
function ENT:ClientEffect()
	local RandomWrap = self.RandomWrap
	self.Emitter = ParticleEmitter(self:GetPos(), false)
	self.Emitter:SetPos(self:GetPos())
	local c = self:GetSmokeColor():ToColor()
	local diameter = self:GetRadius() * 2

	for i = 1, self:GetDensity() do
		local start_size = math.Clamp(RandomWrap(
			self:GetStartSizeBase() - self:GetStartSizeVariance(),
			self:GetStartSizeBase() + self:GetStartSizeVariance()
		), 1, diameter)
		local max_range = diameter - (start_size / 2)
		local offset_ratio = (max_range / diameter)
		local offset_dimension = self:GetRadius() * offset_ratio
		local rel_pos = self:PointInSphere() * offset_dimension
		local sprite_dex = math.max(1,math.ceil(RandomWrap(0, #self.SmokeParticles)))
		local p = self.Emitter:Add(self.SmokeParticles[sprite_dex], self:GetPos() + rel_pos)

		self.particles[ #self.particles + 1 ] = p

		if p then
			p:SetColor(c.r, c.g, c.b)
			p:SetStartAlpha(255)
			p:SetEndAlpha(255)

			p:SetVelocity((p:GetPos() - self:GetPos()):GetNormal() * self.driftVelocity)

			p:SetLifeTime(0)
			p:SetDieTime(self:GetLifeTime())

			p:SetStartSize(start_size)
			p:SetEndSize(start_size)

			p:SetRoll(RandomWrap(-self.rollVariance, self.rollVariance))
			p:SetRollDelta(RandomWrap(-self.rollDeltaVariance, self.rollDeltaVariance))

			p:SetCollide(false)
			p:SetLighting(false)
			p:SetBounce(0)

			-- bloom the particles out for their last X seconds of life
			if self:GetFadeTime() > 0 then
				self.particleData[ #self.particleData + 1 ] = {
					end_size = math.max(RandomWrap(
						self:GetEndSizeBase() - self:GetEndSizeVariance(),
						self:GetEndSizeBase() + self:GetEndSizeVariance()
					), 0),
					future_die_time = RandomWrap(
						0,
						self:GetFadeTime()
					)
				}
			end
		end
	end

	self.Emitter:Finish()
end

---
-- Takes a point in space and blows all our particles away from it, disabling the smoke effect.
-- Moves particles on client, disales on server.
-- @param Vector pos The point of origin for the effect that will disperse this smoke.
-- @param number radius The radius of effect for the thing that is dispersing this smoke.
-- @param number force How strong the effect of the thing that is dispersing this smoke is.
-- @realm shared
function ENT:DisperseFromPoint(pos, radius, force)
	self:Dissipate()

	if not CLIENT then return end

	local distSqr = radius * radius

	for i = 1, self:GetDensity() do
		local particle = self.particles[i]
		local dist = particle:GetPos():DistToSqr(pos)

		if dist > distSqr then continue end

		local scale = 1 - (dist / distSqr)
		local dir = (particle:GetPos() - pos):GetNormal()
		local pushAngle = dir * force * scale

		particle:SetAirResistance(self.airResistance * self.disperseAirResistMultiplier)
		particle:SetGravity(-physenv.GetGravity() * self.disperseGravityMultiplier)
		particle:SetVelocity(particle:GetVelocity() + pushAngle)
	end
end

---
-- Allows all smoke particles to die, and disables the active extinguishing effect.
-- @realm shared
function ENT:Dissipate()
	self:Deactivate()
	if not CLIENT or self.debugViz then return end

	for i = 1, self:GetDensity() do
		local particle = self.particles[i]
		local particleData = self.particleData[i]

		particle:SetLifeTime(0)
		particle:SetDieTime(particleData.future_die_time)

		particle:SetAirResistance(self.airResistance)
		particle:SetBounce(self.bounce)
		particle:SetCollide(true)
		particle:SetGravity(-physenv.GetGravity())
		particle:SetVelocity((self:GetPos() - particle:GetPos()):GetNormal() * self.dispersalVelocity)

		particle:SetEndAlpha(0)
		particle:SetEndSize(particleData.end_size)
	end
end


hook.Add("TTT2ConfGrenadeExplode", "TTT2SmokeEntityConfGrenadeExplode", function(pos, radius, push_force)
	local found = ents.FindInSphere(pos, radius)
	for _, ent in ipairs(found) do
		if ent:GetClass() == "ttt_smoke" then
			ent:DisperseFromPoint(pos, radius, push_force)
		end
	end
end)

---
-- Begins killing the smoke effect, fades out the looping sound, sets a deactivate time so it can prepare to remove itself.
-- Only has an effect on the SERVER.
-- @realm shared
function ENT:Deactivate()
	if CLIENT then return end
	local fade_time = self:GetFadeTime()
	self.LoopSound:FadeOut(fade_time)
	timer.Create("smoke_deactivate_" .. self:EntIndex(), fade_time, 0, function()
		if self.LoopSound then self.LoopSound:Stop() end
	end)
	self:SetAlive(false)
	self:SetDeactivateTime(CurTime())
end

---
-- Kills the particles, cleans up timers and sounds for real.
-- @realm shared
function ENT:OnRemove()
	if CLIENT then
		if self.debugViz then return nil end
		for i = 1, self:GetDensity() do
			local particle = self.particles[i]
			particle:SetDieTime(0)
			particle:SetLifeTime(0)
		end
	else
		timer.Remove("smoke_deactivate_" .. self:EntIndex())
		if self.LoopSound then self.LoopSound:Stop() end
	end
end

if CLIENT then
	---
	-- Debug function to vizualize the points on the occlusion raycast.
	-- @realm client
	function ENT:RenderPoints()
		local physObj = self:GetPhysicsObject()

		if not IsValid(physObj) or type(physObj) ~= "PhysObj" then return end

		local physMesh = physObj:GetMeshConvexes()

		if not istable(physMesh) or #physMesh < 1 then return end

		for convexKey, convex in pairs(physMesh) do
			for posKey, posTab in pairs(convex) do
				debugoverlay.Cross( self:LocalToWorld(posTab.pos), 0.3, RealFrameTime())
			end
		end
	end

	---
	-- Debug function to vizualize the AOE of the smoke, occlusion model, and PhysObj.
	-- @param number flags Flags that exist on @{STUDIO} enum.
	-- @realm client
	function ENT:DrawTranslucent(flags)
		if not self.debugViz and IsValid(self.Emitter) then
			self.Emitter:Draw()
		end
		if self.debugViz then self:Draw(flags) end
		if self.debugRange then
			local color = COLOR_GREEN
			if not self:GetAlive() then
				color = COLOR_RED
			end
			render.DrawWireframeSphere(self:GetPos(), self:GetRadius(), 16, 9, color)
		end
		if self.debugViz then self:RenderPoints() end
	end
end

if SERVER then
	---
	-- Create a color from the smoke grenade.
	-- @realm server
	function ENT:GenerateSmokeColor()
		local RandomWrap = self.RandomWrap
		local color_override = nil

		if self:GetRandomColor() then
			local colors_available = table.GetKeys(self.SmokeColors)
			local color_dex = math.max(1, math.ceil(RandomWrap(0, #colors_available)))
			local color_name = colors_available[color_dex]
			color_override = self.SmokeColors[ color_name ]
		end

		local mix = math.Clamp(RandomWrap(
			(self:GetColorBase() - self:GetColorVariance()) / 255,
			(self:GetColorBase() + self:GetColorVariance()) / 255
		), 0, 1)

		if color_override ~= nil then
			local h, s = ColorToHSV( color_override )
			color_override = HSVToColor(h, s, mix)
		else
			color_override = HSVToColor(0, 0, mix)
		end

		return color_override
	end
end
