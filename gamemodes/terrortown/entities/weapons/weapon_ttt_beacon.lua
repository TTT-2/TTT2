---
-- @class SWEP
-- @section weapon_ttt_beacon

if SERVER then
	AddCSLuaFile()
end

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
		local beacon = ents.Create("ttt_beacon")

		if beacon:ThrowEntity(self:GetOwner(), Angle(90, 0, 0)) then
			self:PlacedBeacon()
		end
	end
end

---
-- @realm shared
function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

	if SERVER and self:CanPrimaryAttack() then
		local beacon = ents.Create("ttt_beacon")

		if beacon:StickEntity(self:GetOwner()) then
			self:PlacedBeacon()
		end
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

---
-- @realm shared
function SWEP:OnRemove()
	if CLIENT and IsValid(self:GetOwner()) and self:GetOwner() == LocalPlayer() and self:GetOwner():IsTerror() then
		RunConsoleCommand("lastinv")
	end
end

if CLIENT then
	---
	-- @realm client
	function SWEP:Initialize()
		self:AddTTT2HUDHelp("beacon_help_pri", "beacon_help_sec")

		return self.BaseClass.Initialize(self)
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

