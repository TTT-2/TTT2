if SERVER then
	AddCSLuaFile()
end

SWEP.HoldType = "shotgun"

if CLIENT then
	SWEP.PrintName = "shotgun_name"
	SWEP.Slot = 2

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 54

	SWEP.Icon = "vgui/ttt/icon_shotgun"
	SWEP.IconLetter = "B"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_SHOTGUN
SWEP.StockEquipment = true
SWEP.spawnType = WEAPON_TYPE_SHOTGUN

SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.Damage = 11
SWEP.Primary.Cone = 0.082
SWEP.Primary.Delay = 0.8
SWEP.Primary.ClipSize = 8
SWEP.Primary.ClipMax = 24
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 8
SWEP.Primary.Sound = Sound("Weapon_XM1014.Single")
SWEP.Primary.Recoil = 7

SWEP.AutoSpawnable = true
SWEP.Spawnable = true
SWEP.AmmoEnt = "item_box_buckshot_ttt"

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"

SWEP.IronSightsPos = Vector(-6.881, -9.214, 2.66)
SWEP.IronSightsAng = Vector(-0.101, -0.7, -0.201)

---
-- @ignore
function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Reloading")
	self:NetworkVar("Float", 0, "ReloadTimer")

	return self.BaseClass.SetupDataTables(self)
end

---
-- @ignore
function SWEP:Reload()
	if self:GetReloading() or self:Clip1() > self.Primary.ClipSize
		or self:GetOwner():GetAmmoCount(self.Primary.Ammo) < 0
	then return end

	self:StartReload()
end

---
-- @ignore
function SWEP:StartReload()
	if self:GetReloading() then
		return false
	end

	self:SetIronsights(false)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local owner = self:GetOwner()

	if not owner or owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
		return false
	end

	if self:Clip1() >= self.Primary.ClipSize then
		return false
	end

	self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
	self:SetReloadTimer(CurTime() + self:SequenceDuration())
	self:SetReloading(true)

	return true
end

---
-- @ignore
function SWEP:PerformReload()
	local owner = self:GetOwner()

	-- prevent normal shooting in between reloads
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if not owner or owner:GetAmmoCount(self.Primary.Ammo) <= 0
		or self:Clip1() >= self.Primary.ClipSize
	then return end

	owner:RemoveAmmo(1, self.Primary.Ammo, false)

	self:SetClip1(self:Clip1() + 1)
	self:SendWeaponAnim(ACT_VM_RELOAD)
	self:SetReloadTimer(CurTime() + self:SequenceDuration())
end

---
-- @ignore
function SWEP:FinishReload()
	self:SetReloading(false)
	self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)

	self:SetReloadTimer(CurTime() + self:SequenceDuration())
end

---
-- @ignore
function SWEP:CanPrimaryAttack()
	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

		return false
	end

	return true
end

---
-- @ignore
function SWEP:Think()
	self.BaseClass.Think(self)

	if not self:GetReloading() then return end

	local owner = self:GetOwner()

	if owner:KeyDown(IN_ATTACK) then
		self:FinishReload()
	elseif self:GetReloadTimer() <= CurTime() then
		if owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
			self:FinishReload()
		elseif self:Clip1() < self.Primary.ClipSize then
			self:PerformReload()
		else
			self:FinishReload()
		end
	end
end

---
-- @ignore
function SWEP:Deploy()
	self:SetReloading(false)
	self:SetReloadTimer(0)

	return self.BaseClass.Deploy(self)
end

---
-- The shotgun's headshot damage multiplier is based on distance. The closer it
-- is, the more damage it does. This reinforces the shotgun's role as short
-- range weapon by reducing effectiveness at mid-range, where one could score
-- lucky headshots relatively easily due to the spread.
-- @ignore
function SWEP:GetHeadshotMultiplier(victim, dmginfo)
	local att = dmginfo:GetAttacker()

	if not IsValid(att) then
		return 3
	end

	local dist = victim:GetPos():Distance(att:GetPos())
	local d = math.max(0, dist - 140)

	-- Decay from 2 to 1 slowly as distance increases. Note that this used to be
	-- 3+, but at that time shotgun bullets were treated like in HL2 where half
	-- of them were hull traces that could not headshot.
	return 1 + math.max(0, 1.0 - 0.002 * (d ^ 1.25))
end

---
-- @ignore
function SWEP:SecondaryAttack()
	if self.NoSights or (not self.IronSightsPos) or self:GetReloading() then return end

	self:SetIronsights(not self:GetIronsights())
	self:SetNextSecondaryFire(CurTime() + 0.3)
end
