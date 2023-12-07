---
-- @class SWEP
-- @desc Common code for all types of grenade
-- @section weapon_tttbasegrenade
if SERVER then
	AddCSLuaFile()
end

DEFINE_BASECLASS "weapon_tttbase"
SWEP.HoldReady = "grenade"
SWEP.HoldNormal = "slam"
if CLIENT then
	SWEP.PrintName = "Incendiary grenade"
	SWEP.Instructions = "Burn."
	SWEP.Slot = 3
	SWEP.ViewModelFlip = true
	SWEP.DrawCrosshair = false
	SWEP.Icon = "vgui/ttt/icon_nades"
end

SWEP.Base = "weapon_tttbase"
SWEP.ViewModel = "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel = "models/weapons/w_eq_flashbang.mdl"
SWEP.Weight = 5
SWEP.AutoSwitchFrom = true
SWEP.NoSights = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1.0
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Kind = WEAPON_NADE
SWEP.IsGrenade = true
SWEP.was_thrown = false
SWEP.DeploySpeed = 1.5
-- How hard a grenade will be thrown, affects how quickly it will travel and how far it will go.
SWEP.throwForce = 1
-- The time between the pin being pulled and the grenade exploding.
SWEP.detonate_timer = 5
-- The radius of the physics sphere.
-- If 0, the projectile's physics will be based off its model rather than a sphere.
SWEP.sphericalPhysicsRadius = 0
-- If enabled, players hit by this grenade's projectile in-flight will drop their current weapon and unscope if possible.
SWEP.disarmHitPlayers = false
-- Controls how loose throwables react to being damaged.
--  - 0 = None: Grenades will not react in any special way.
--  - 1 = Prime: Grenades will act like their pin is pulled, and will detonate after being damaged.
--  - 2 = Instant Explosion: Grenades will create their thrown version, and explode immediately.
SWEP.damageTriggerBehavior = 0
-- If enabled, if this grenade will just explode after being struck.
SWEP.damageTriggerInstantExplosion = false
-- If enabled, if this grenade takes damage after being primed, it will detonate immediately.
SWEP.damageTriggerProjectileExplosion = false
-- If enabled, if a different grenade was activated by damage, it won't cause this grenade to prime or detonate.
SWEP.preventDamageChainReaction = true
-- If enabled, the grenade will not have its detonation timer begin until its pin pull animation is complete.
-- Will also prevent tossing the grenade until an appropriate point in the throw animation.
SWEP.useAnimationTimers = false
SWEP.animPinPullOffset = 0.36
SWEP.animThrowOffset = 0.36
SWEP.pinSound = Sound("Default.PullPin_Grenade")

---
-- @accessor number
-- @realm shared
AccessorFunc(SWEP, "det_time", "DetTime", FORCE_NUMBER)

---
-- @accessor number
-- @realm shared
AccessorFunc(SWEP, "pull_time", "PullTime", FORCE_NUMBER)

---
-- @realm server
CreateConVar("ttt_nade_throw_during_prep", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY})

---
-- @ignore
function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Pin")
	self:NetworkVar("Int", 0, "ThrowTime")
	self:NetworkVar("Bool", 1, "ShotToActivate")
	self:NetworkVar("Float", 0, "AnimTimer")
end

---
-- @ignore
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if GetRoundState() == ROUND_PREP and not GetConVar("ttt_nade_throw_during_prep"):GetBool() then return end
	self:PullPin()
end

---
-- @ignore
function SWEP:SecondaryAttack()
end

---
-- @param Vector P The initial position for this iteration cycle.
-- @param number V The launch velocity for this iteration cycle.
-- @param number G The gravity multiplier for this iteration cycle.
-- @param number T The step size for the current iteration cycle.
-- @return Vector The next location to iterate from.
local function PositionFromPhysicsParams(P, V, G, T)
	local A = G * physenv.GetGravity()

	return P + (V * T + 0.5 * A * T ^ 2)
end

if CLIENT then
	---
	-- @realm client
	local fuse_ui = CreateConVar("ttt2_grenade_fuse_meter_ui", 0, FCVAR_ARCHIVE)

	---
	-- @realm client
	local trajectory_ui = CreateConVar("ttt2_grenade_trajectory_ui", 0, FCVAR_ARCHIVE)

	local function AlphaLerp(from, frac)
		local fr = frac ^ 0.5
		return ColorAlpha(from, Lerp(fr, 0, 255))
	end

	---
	-- @param Player ply
	-- @realm client
	function SWEP:DrawDefaultThrowPath(ply)
		local owner = self:GetOwner()
		local pos, _ = self:GetViewModelPosition(owner:EyePos(), owner:EyeAngles())

		local src, thr = self:GetThrowVelocity()
		local P = pos - ply:EyePos() + src
		local V = thr
		local G = 1
		local step = 0.005
		local lastpos = PositionFromPhysicsParams(P, V, G, step)
		local frac = (SysTime() % 1) * 2
		local i = frac > 1 and 1 or 0
		frac = frac - math.floor(frac)

		render.SetColorMaterial()
		cam.Start3D(EyePos(), EyeAngles())

		for T = step * 2, 1, step do
			pos = PositionFromPhysicsParams(P, V, G, T)
			local t = util.TraceLine({
				start = lastpos,
				endpos = pos,
				filter = {ply, self}
			})

			local from, to = lastpos, t.Hit and t.HitPos or pos
			local norm = to - from
			norm:Normalize()
			local len = from:DistToSqr(to) ^ 0.5
			local color = AlphaLerp(self:GetOwner():GetRoleColor(), T)
			i = (i + 1) % 2
			local width = 0.6
			local denom = (T / step) ^ 0.25
			if i == 0 then
				render.DrawBeam(from, from + norm * (frac * len), width * denom, 0, 1,  color)
			else
				render.DrawBeam(to - norm * ((1 - frac) * len), to, width * denom, 0, 1, color)
			end

			if t.Hit then
				local hpos = t.HitPos + t.HitNormal * (t.FractionLeftSolid * denom)
				local elen = 1 * denom
				local crunk = Vector(0, 0, elen)

				local angle_left = Angle(t.HitNormal:Angle())
				angle_left:RotateAroundAxis(t.HitNormal, -45)
				local left = Vector(crunk)
				left:Rotate(angle_left)
				render.DrawBeam(hpos - (left * elen), hpos + left * elen, width * denom, 0, 1, color)

				local angle_up = Angle(t.HitNormal:Angle())
				angle_up:RotateAroundAxis(t.HitNormal, 45)
				local up = Vector(crunk)
				up:Rotate(angle_up)
				render.DrawBeam(hpos - (up * elen), hpos + up * elen, width * denom, 0, 1, color)
				break
			end
			lastpos = pos
		end

		cam.End3D()
	end

	---
	-- @param Entity vm
	-- @param Weapon weapon
	-- @param Player ply
	-- @realm client
	function SWEP:PostDrawViewModel(vm, weapon, ply)
		if not trajectory_ui:GetBool() then return end
		self:DrawDefaultThrowPath(ply)
	end

	---
	-- @realm client
	function SWEP:DrawHUDBackground()
		if not (self:GetPin() and fuse_ui:GetBool()) then return end
		local pct = math.Clamp((CurTime() - self:GetPullTime()) / (self:GetDetTime() - self:GetPullTime()), 0, 1)
		local drawColor = self:GetOwner():GetRoleColor()
		local w, h = 200, 20
		local x = ScrW() / 2.0
		local y = ScrH() / 2.0

		y = y + (y / 2)

		surface.SetDrawColor(drawColor)
		surface.DrawOutlinedRect(x - w / 2, y - h, w, h, 1)

		drawColor.a = 180

		surface.SetDrawColor(drawColor)
		surface.DrawRect(x - w / 2, y - h, w * (1 - pct), h)
	end
end

---
-- @ignore
function SWEP:PullPin()
	if self:GetPin() or (self.useAnimationTimers and self:GetAnimTimer() > 0) then return end
	local ply = self:GetOwner()
	if not IsValid(ply) then return end

	self:SendWeaponAnim(ACT_VM_PULLPIN)
	local anim_duration = ply:GetViewModel():SequenceDuration() * ply:GetPlaybackRate()
	self:SetAnimTimer((anim_duration - (anim_duration * self.animPinPullOffset)) + CurTime())
	if self.SetHoldType then
		self:SetHoldType(self.HoldReady)
	end

	self:SetPin(true)
end

---
-- @ignore
function SWEP:Think()
	BaseClass.Think(self)
	local ply = self:GetOwner()
	if not IsValid(ply) then return end
	-- pin pulled and attack loose = throw
	if self:GetPin() then
		-- we will throw now
		if not self.useAnimationTimers or (self.useAnimationTimers and self:GetAnimTimer() > 0 and self:GetAnimTimer() <= CurTime()) then
			-- the pin is out, begin counting
			if self:GetPullTime() <= 0 then
				self:SetPullTime(CurTime())
				self:SetDetTime(CurTime() + self.detonate_timer)

				if SERVER then
					-- play the pin noise for everyone but us, because viewmodel plays it
					local filter = RecipientFilter()
					filter:AddPAS(self:GetPos())
					filter:RemovePlayer(ply)
					local noise = CreateSound(self, self.pinSound, filter)
					noise:Play()
				end
			end
			if self:GetPullTime() > 0 and not ply:KeyDown(IN_ATTACK) then
				self:StartThrow()
				self:SetPin(false)
				if SERVER then
					self:SendWeaponAnim(ACT_VM_THROW)
					local anim_duration = self:GetOwner():GetViewModel():SequenceDuration() * self:GetOwner():GetPlaybackRate()
					self:SetAnimTimer((anim_duration - (anim_duration * self.animThrowOffset)) + CurTime())
					self:GetOwner():SetAnimation(PLAYER_ATTACK1)
				end
			else
				-- still cooking it, see if our time is up
				if SERVER and self:GetDetTime() < CurTime() then
					self:BlowInFace()
				end
			end
		end
	elseif self:GetThrowTime() > 0 and self:GetThrowTime() < CurTime() then
		if not self.useAnimationTimers or (self.useAnimationTimers and self:GetAnimTimer() > 0 and self:GetAnimTimer() <= CurTime()) then
			self:Throw()
		end
	end
end

---
-- @ignore
function SWEP:BlowInFace()
	local ply = self:GetOwner()
	if not IsValid(ply) then return end
	if self.was_thrown then return end
	self.was_thrown = true
	-- drop the grenade so it can immediately explode
	local ang = ply:GetAngles()
	local src = ply:GetPos() + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset())
	src = src + (ang:Right() * 10)
	self:CreateGrenade(src, angle_zero, vector_up, vector_up, ply)
	self:SetThrowTime(0)
	self:Remove()
end

---
-- @ignore
function SWEP:StartThrow()
	self:SetThrowTime(CurTime())
end

---
-- @return Vector, Vector The point of origin for the thrown projectile, and its force.
-- @realm shared
function SWEP:GetThrowVelocity()
	local ply = self:GetOwner()
	local ang = ply:EyeAngles()
	local src = ply:GetPos() + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset()) + (ang:Forward() * 8) + (ang:Right() * 10)
	local target = ply:GetEyeTraceNoCursor().HitPos
	-- A target angle to actually throw the grenade to the crosshair instead of fowards
	local tang = (target - src):Angle()
	-- Makes the grenade go upgwards
	if tang.p < 90 then
		tang.p = -10 + tang.p * ((90 + 10) / 90)
	else
		tang.p = 360 - tang.p
		tang.p = -10 + tang.p * -((90 + 10) / 90)
	end

	tang.p = math.Clamp(tang.p, -90, 90) -- Makes the grenade not go backwards :/
	local vel = math.min(800, (90 - tang.p) * 6)
	local thr = tang:Forward() * vel * self.throwForce + ply:GetVelocity()
	return src, thr
end

---
-- @ignore
function SWEP:Throw()
	if CLIENT then
		self:SetThrowTime(0)
	elseif SERVER then
		local ply = self:GetOwner()
		if not IsValid(ply) then return end
		if self.was_thrown then return end
		self.was_thrown = true

		local src, thr = self:GetThrowVelocity()
		self:CreateGrenade(src, angle_zero, thr, Vector(600, math.random(-1200, 1200), 0), ply)
		self:SetThrowTime(0)
		self:Remove()
	end
end

---
-- Subclasses must override with their own grenade ent.
-- @return string
-- @realm shared
function SWEP:GetGrenadeName()
	ErrorNoHalt("SWEP BASEGRENADE ERROR: GetGrenadeName not overridden! This is probably wrong!\n")

	return "ttt_firegrenade_proj"
end

---
-- @ignore
function SWEP:CreateGrenade(src, ang, vel, angimp, ply)
	if CLIENT then return end
	local grenade_name = self:GetGrenadeName()
	local grenade = ents.Create(grenade_name)

	if not IsValid(grenade) then return end

	grenade.playerDropWeaponOnContact = self.disarmHitPlayers or grenade.playerDropWeaponOnContact
	grenade.sphericalPhysicsRadius = self.sphericalPhysicsRadius or grenade.sphericalPhysicsRadius
	grenade.damageTriggerProjectileExplosion = self.damageTriggerProjectileExplosion or grenade.damageTriggerProjectileExplosion
	grenade.preventDamageChainReaction = self.preventDamageChainReaction or grenade.preventDamageChainReaction

	grenade:SetPos(src)
	grenade:SetAngles(ang)
	grenade:SetOwner(ply)
	grenade:SetThrower(ply)
	grenade:SetLaunchWeaponClass(self:GetClass())
	grenade:SetGravity(0.4)
	grenade:SetFriction(0.2)
	grenade:SetElasticity(0.45)
	grenade:Spawn()
	grenade:PhysWake()

	if grenade.throwSound then
		grenade:EmitSound(grenade.throwSound, 120, 100, 1)
	end

	grenade:SetCollisionGroup(COLLISION_GROUP_NONE)

	local phys = grenade:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocity(vel)
		phys:AddAngleVelocity(angimp)
		phys:SetContents(CONTENTS_SOLID)
	end

	-- This has to happen AFTER Spawn() calls grenade's Initialize()
	grenade:SetDetonateExact(self:GetDetTime())

	return grenade
end

---
-- @ignore
function SWEP:PreDrop()
	-- if owner dies or drops us while the pin has been pulled, create the armed
	-- grenade anyway
	if self:GetPin() then
		self:BlowInFace()
	end
end

---
-- @ignore
function SWEP:Deploy()
	if self.SetHoldType then
		self:SetHoldType(self.HoldNormal)
	end

	self:SetThrowTime(0)
	self:SetPin(false)

	return true
end

---
-- @ignore
function SWEP:Holster()
	if self:GetPin() then return false end -- no switching after pulling pin
	self:SetThrowTime(0)
	self:SetPin(false)

	return true
end

---
-- @ignore
function SWEP:Reload()
	return false
end

---
-- @ignore
function SWEP:Initialize()
	if self.SetHoldType then
		self:SetHoldType(self.HoldNormal)
	end

	self:SetDeploySpeed(self.DeploySpeed)
	self:SetDetTime(0)
	self:SetPullTime(0)
	self:SetThrowTime(0)
	self:SetPin(false)
	self:SetShotToActivate(false)
	self.was_thrown = false
	self:SetAnimTimer(0)
end

---
-- @ignore
function SWEP:OnRemove()
	local owner = self:GetOwner()
	if CLIENT and IsValid(owner) and owner == LocalPlayer() and owner:Alive() then
		RunConsoleCommand("use", "weapon_ttt_unarmed")
	end
end

---
-- Attempt to create the grenade projectile.
-- @param nil|Player owner
-- @realm server
function SWEP:TryCreate(owner)
	local grenade = self:CreateGrenade(self:GetPos(), angle_zero, vector_up, vector_up, owner)
	if IsValid(grenade) then
		grenade:SetDetonateTimer(self.detonate_timer)
		self:Remove()

		return grenade
	end
end

---
-- Attempt to create the grenade projectile and detonate it as soon as possible.
-- @param nil|Player owner
-- @realm server
function SWEP:TryExplode(owner)
	local grenade = self:TryCreate(owner)
	if IsValid(grenade) then
		grenade:SetShotToActivate(self:GetShotToActivate())
		grenade:TryExplode()
	end
end


if SERVER then
	local function IsGrenade(ent)
		return IsValid(ent) and weapons.IsBasedOn(ent:GetClass(), "weapon_tttbasegrenade")
	end

	local function IsGrenadeProjectile(ent)
		return IsValid(ent) and scripted_ents.IsBasedOn(ent:GetClass(), "ttt_basegrenade_proj")
	end

	hook.Add("EntityTakeDamage", "TTT2BaseGrenadeThrowableExplodey", function(target, dmginfo)
		local is_grenade = IsGrenade(target)
		local is_grenade_projectile = IsGrenadeProjectile(target)
		local inflictor = dmginfo:GetInflictor()
		local hit_by_grenade = IsGrenade(inflictor)
		local hit_by_grenade_projectile = IsGrenadeProjectile(inflictor)
		local grenadey = (is_grenade and target.damageTriggerBehavior > 0) or (is_grenade_projectile and target.damageTriggerProjectileExplosion)

		-- has nothing to do with us
		if not grenadey or target == inflictor
			-- ignore chain reactions
			or (target.preventDamageChainReaction
			and (hit_by_grenade or hit_by_grenade_projectile)
			and inflictor:GetShotToActivate())
		then
			return
		end


		if not target:GetShotToActivate() then
			target:SetShotToActivate(true)
			if is_grenade and target.damageTriggerBehavior == 1 then
				-- look for a spot above the ground
				local pos = target:GetPos()
				local tr = util.TraceLine({
					start = pos,
					endpos = pos + Vector(0,0,-32),
					mask = MASK_SHOT_HULL,
					filter = target,
				})
				-- pull out of the surface
				local size = math.abs(target:OBBMaxs().z) + math.abs(target:OBBMins().z)
				if tr.Hit then
					pos = tr.HitPos + tr.HitNormal * 0.6
					pos = pos + Vector(0, 0, size + 8)
				end

				-- make the grenade
				local grenade = target:TryCreate(dmginfo:GetAttacker())
				grenade:SetPos(pos)
				grenade:EmitSound( grenade.pinSound )

				-- try to inherit forces
				local phys = grenade:GetPhysicsObject()
				if IsValid(phys) then
					local desiredVelocity = dmginfo:GetDamageForce()
					local targetPhys = target:GetPhysicsObject()
					if IsValid(targetPhys) then
						desiredVelocity = desiredVelocity + targetPhys:GetVelocity()
					end
					phys:ApplyForceOffset( desiredVelocity, dmginfo:GetDamagePosition() )
				end
			elseif (is_grenade and target.damageTriggerBehavior == 2)
				or (is_grenade_projectile and target.damageTriggerProjectileExplosion)
			then
				if is_grenade then
					target:EmitSound( target.pinSound )
				end
				target:TryExplode(dmginfo:GetAttacker())
			end
		end
	end)
end

if SERVER then
	util.AddNetworkString("ttt2_quick_grenade")

	local last_weapon = nil
	net.Receive("ttt2_quick_grenade", function(_, ply)
		if not IsValid(ply) or not ply:IsTerror() or not ply:Alive() then return end

		local begin = net.ReadBool()

		if begin then
			local inventory = ply:GetInventory()
			last_weapon = ply:GetActiveWeapon()
			for _, iwep in pairs(inventory[WEAPON_NADE]) do
				if IsValid(iwep) then
					ply:SetActiveWeapon(iwep)
					ply:ConCommand("+attack")
					break
				end
			end
		else
			ply:ConCommand("-attack")
			if IsValid(last_weapon) then
				local vm = ply:GetViewModel()
				local seq_id = vm:GetSequence()
				local seq_info = vm:GetSequenceInfo(seq_id)
				local anim_duration = seq_info.fadeouttime * ply:GetPlaybackRate()
				timer.Simple(anim_duration, function()
					if IsValid(last_weapon) then
						ply:SelectWeapon(WEPS.GetClass(last_weapon))
					else
						ply:ConCommand("lastinv")
					end
				end)
			else
				ply:ConCommand("lastinv")
			end
		end
	end)
end

if CLIENT then
	local function QuickGrenade(begin)
		net.Start("ttt2_quick_grenade")
		net.WriteBool(begin)
		net.SendToServer()
	end

	concommand.Add("+ttt2_quick_grenade", function(ply)
		QuickGrenade(true)
	end)

	concommand.Add("-ttt2_quick_grenade", function(ply)
		QuickGrenade(false)
	end)

	hook.Add("TTT2FinishedLoading", "TTTQuickGrenadeInitStatus", function()
		bind.Register("ttt2_quick_grenade", function()
			QuickGrenade(true)
		end, function()
			QuickGrenade(false)
		end, "header_bindings_ttt2", "label_bind_quick_grenade", KEY_G)
		local materialQuickNade = Material("vgui/ttt/hudhelp/quicknade")

		keyhelp.RegisterKeyHelper("ttt2_quick_grenade", materialQuickNade, KEYHELP_EQUIPMENT, "label_keyhelper_quick_grenade", function(client)
			if client:IsSpec() then return end
			local inventory = client:GetInventory()
			local found_any = false
			for _, iwep in pairs(inventory[WEAPON_NADE]) do
				if IsValid(iwep) then
					found_any = true
					break
				end
			end
			if not found_any then return end

			return true
		end)
	end)
end
