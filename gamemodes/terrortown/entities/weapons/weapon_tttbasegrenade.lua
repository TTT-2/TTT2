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
SWEP.detonate_timer = 5
SWEP.DeploySpeed = 1.5

---
-- @accessor number
-- @realm shared
AccessorFunc(SWEP, "det_time", "DetTime")

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
end

---
-- @ignore
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if GetRoundState() == ROUND_PREP and not GetConVar("ttt_nade_throw_during_prep"):GetBool() then
		return
	end

	self:PullPin()
end

---
-- @ignore
function SWEP:SecondaryAttack()

end

---
-- @ignore
function SWEP:PullPin()
	if self:GetPin() then return end

	local ply = self:GetOwner()
	if not IsValid(ply) then return end

	self:SendWeaponAnim(ACT_VM_PULLPIN)

	if self.SetHoldType then
		self:SetHoldType(self.HoldReady)
	end

	self:SetPin(true)
	self:SetPullTime(CurTime())

	self:SetDetTime(CurTime() + self.detonate_timer)
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
		if not ply:KeyDown(IN_ATTACK) then
			self:StartThrow()

			self:SetPin(false)
			self:SendWeaponAnim(ACT_VM_THROW)

			if SERVER then
				self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
			end
		else
			-- still cooking it, see if our time is up
			if SERVER and self:GetDetTime() < CurTime() then
				self:BlowInFace()
			end
		end
	elseif self:GetThrowTime() > 0 and self:GetThrowTime() < CurTime() then
		self:Throw()
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

	self:CreateGrenade(src, Angle(0,0,0), Vector(0,0,1), Vector(0,0,1), ply)

	self:SetThrowTime(0)
	self:Remove()
end

---
-- @ignore
function SWEP:StartThrow()
	self:SetThrowTime(CurTime() + 0.1)
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

		local ang = ply:EyeAngles()
		local src = ply:GetPos() + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset()) + ang:Forward() * 8 + ang:Right() * 10
		local target = ply:GetEyeTraceNoCursor().HitPos
		local tang = (target-src):Angle() -- A target angle to actually throw the grenade to the crosshair instead of fowards

		-- Makes the grenade go upgwards
		if tang.p < 90 then
			tang.p = -10 + tang.p * ((90 + 10) / 90)
		else
			tang.p = 360 - tang.p
			tang.p = -10 + tang.p * -((90 + 10) / 90)
		end

		tang.p = math.Clamp(tang.p,-90,90) -- Makes the grenade not go backwards :/

		local vel = math.min(800, (90 - tang.p) * 6)
		local thr = tang:Forward() * vel + ply:GetVelocity()
		self:CreateGrenade(src, Angle(0,0,0), thr, Vector(600, math.random(-1200, 1200), 0), ply)

		self:SetThrowTime(0)
		self:Remove()
	end
end

---
-- Subclasses must override with their own grenade ent.
-- @realm shared
function SWEP:GetGrenadeName()
	ErrorNoHalt("SWEP BASEGRENADE ERROR: GetGrenadeName not overridden! This is probably wrong!\n")

	return "ttt_firegrenade_proj"
end

---
-- @ignore
function SWEP:CreateGrenade(src, ang, vel, angimp, ply)
	local gren = ents.Create(self:GetGrenadeName())

	if not IsValid(gren) then return end

	gren:SetPos(src)
	gren:SetAngles(ang)
	gren:SetOwner(ply)
	gren:SetThrower(ply)
	gren:SetGravity(0.4)
	gren:SetFriction(0.2)
	gren:SetElasticity(0.45)
	gren:Spawn()
	gren:PhysWake()

	local phys = gren:GetPhysicsObject()

	if IsValid(phys) then
		phys:SetVelocity(vel)
		phys:AddAngleVelocity(angimp)
	end

	-- This has to happen AFTER Spawn() calls gren's Initialize()
	gren:SetDetonateExact(self:GetDetTime())

	return gren
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
	if self:GetPin() then
		return false -- no switching after pulling pin
	end

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

	self.was_thrown = false
end

---
-- @ignore
function SWEP:OnRemove()
	local owner = self:GetOwner()

	if CLIENT and IsValid(owner) and owner == LocalPlayer() and owner:Alive() then
		RunConsoleCommand("use", "weapon_ttt_unarmed")
	end
end

if CLIENT then
	local draw = draw
	local TryT = LANG.TryTranslation
	local hudTextColor = Color(255, 255, 255, 180)

	---
	-- @ignore
	function SWEP:DrawHUD()
		if self.HUDHelp then
			self:DrawHelp()
		end

		if self:GetPin() and self:GetPullTime() > 0 then
			local client = LocalPlayer()

			local x = ScrW() * 0.5
			local y = ScrH() * 0.5
			y = y + (y / 3)

			local pct = 1 - math.Clamp((CurTime() - self:GetPullTime()) / (self:GetDetTime() - self:GetPullTime()), 0, 1)

			local scale = appearance.GetGlobalScale()
			local w, h = 100 * scale, 20 * scale
			local drawColor = appearance.SelectFocusColor(client:GetRoleColor())

			draw.AdvancedText(
				TryT("grenade_fuse"),
				"PureSkinBar",
				x - w / 2,
				y - h,
				hudTextColor,
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_BOTTOM,
				true,
				scale
			)
			draw.Box(x - w / 2 + scale, y - h + scale, w * pct, h, COLOR_BLACK)
			draw.OutlinedShadowedBox(x - w / 2, y - h, w, h, scale, drawColor)
			draw.Box(x - w / 2, y - h, w * pct, h, drawColor)
		end
	end
end
