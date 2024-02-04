---
-- @class SWEP
-- @section weapon_ttt_beacon

if SERVER then
	AddCSLuaFile()
end

DEFINE_BASECLASS "weapon_tttbase"

SWEP.HoldType = "normal"

if CLIENT then
	SWEP.PrintName = "beacon_name"
	SWEP.Slot = 6

	SWEP.ShowDefaultViewModel = false

	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "beacon_desc"
	}

	SWEP.Icon = "vgui/ttt/icon_beacon"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/props_lab/reciever01b.mdl"

SWEP.Primary.ClipSize = 3
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "slam"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.0

SWEP.Kind = WEAPON_EQUIP

SWEP.CanBuy = {ROLE_DETECTIVE}
SWEP.LimitedStock = true -- only buyable once
SWEP.WeaponID = AMMO_BEACON
SWEP.builtin = true

SWEP.Spawnable = true
SWEP.AllowDrop = false
SWEP.NoSights = true

SWEP.builtin = true

---
-- @realm shared
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if SERVER and self:CanPrimaryAttack() then
		self:BeaconDrop()
	end
end

---
-- @realm shared
function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

	if SERVER and self:CanPrimaryAttack() then
		self:BeaconStick()
	end
end

---
-- @realm shared
function SWEP:PlacedBeacon()
	self:TakePrimaryAmmo(1)

	if not self:CanPrimaryAttack() then
		self:Remove()
	end
end

---
-- @realm shared
function SWEP:PickupBeacon()
	if self:Clip1() >= self.Primary.ClipSize then
		return false
	else
		self:SetClip1(self:Clip1() + 1)
		return true
	end
end

---
-- @param Player buyer
-- @realm shared
function SWEP:WasBought(buyer)
	self:SetClip1(self:Clip1() + 2)
end

---
-- @realm shared
function SWEP:Reload()
	return false
end

if SERVER then
	local throwsound = Sound("Weapon_SLAM.SatchelThrow")

	---
	-- @realm server
	function SWEP:BeaconDrop()
		local ply = self:GetOwner()

		if not IsValid(ply) then return end

		local vsrc = ply:GetShootPos()
		local vang = ply:GetAimVector()
		local vvel = ply:GetVelocity()
		local vthrow = vvel + vang * 200
		local beacon = ents.Create("ttt_beacon")

		if IsValid(beacon) then
			beacon:SetPos(vsrc + vang * 10)
			beacon:SetOwner(ply)
			beacon:Spawn()

			beacon:PointAtEntity(ply)

			local ang = beacon:GetAngles()
			ang:RotateAroundAxis(ang:Right(), 90)
			beacon:SetAngles(ang)

			beacon:PhysWake()
			local phys = beacon:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocity(vthrow)
			end

			self:PlacedBeacon()
		end

		self:EmitSound(throwsound)
	end

	---
	-- @realm server
	function SWEP:BeaconStick()
		local ply = self:GetOwner()

		if not IsValid(ply) then return end

		local ignore = {ply, self}
		local spos = ply:GetShootPos()
		local epos = spos + ply:GetAimVector() * 80
		local tr = util.TraceLine({
			start = spos,
			endpos = epos,
			filter = ignore,
			mask = MASK_SOLID
		})

		if not tr.HitWorld then return end

		local beacon = ents.Create("ttt_beacon")

		if not IsValid(beacon) then return end

		beacon:PointAtEntity(ply)

		local tr_ent = util.TraceEntity({
			start = spos,
			endpos = epos,
			filter = ignore,
			mask = MASK_SOLID
		}, beacon)

		if not tr_ent.HitWorld then return end

		local ang = tr_ent.HitNormal:Angle()

		beacon:SetPos(tr_ent.HitPos + ang:Forward() * 2.5)
		beacon:SetAngles(ang)
		beacon:SetOwner(ply)
		beacon:Spawn()

		local phys = beacon:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
		end

		beacon.IsOnWall = true

		self:PlacedBeacon()
	end
end

if CLIENT then
	---
	-- @realm client
	function SWEP:Initialize()
		self:AddTTT2HUDHelp("beacon_help_pri", "beacon_help_sec")

		return BaseClass.Initialize(self)
	end

	---
	-- @realm client
	function SWEP:OnRemove()
		BaseClass.OnRemove(self)

		local owner = self:GetOwner()

		if IsValid(owner) and owner == LocalPlayer() and owner:IsTerror() then
			RunConsoleCommand("lastinv")
		end
	end

	---
	-- @realm client
	function SWEP:DrawWorldModel()
		if IsValid(self:GetOwner()) then return end

		self:DrawModel()
	end

	---
	-- @realm client
	function SWEP:DrawWorldModelTranslucent()

	end
end

