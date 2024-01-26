---
-- @class SWEP
-- @desc radio
-- @section weapon_ttt_radio

if SERVER then
	AddCSLuaFile()
end

SWEP.HoldType = "normal"

if CLIENT then
	SWEP.PrintName = "radio_name"
	SWEP.Slot = 7

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 10
	SWEP.DrawCrosshair = false

	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "radio_desc"
	}

	SWEP.Icon = "vgui/ttt/icon_radio"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/props/cs_office/radio.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.0

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.LimitedStock = true -- only buyable once
SWEP.WeaponID = AMMO_RADIO

SWEP.builtin = true

SWEP.AllowDrop = false
SWEP.NoSights = true
SWEP.InvisibleViewModel = true

---
-- @ignore
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if SERVER then
		local radio = ents.Create("ttt_radio")

		if radio:ThrowEntity(self:GetOwner(), Angle(120, 0, 0)) then
			self:Remove()
		end
	end
end

---
-- @ignore
function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

	if SERVER then
		local radio = ents.Create("ttt_radio")

		if radio:StickEntity(self:GetOwner(), Angle(90, 0, 0), 45) then
			self:Remove()
		end
	end
end

---
-- @ignore
function SWEP:Reload()
	return false
end

---
-- @ignore
function SWEP:OnRemove()
	if CLIENT and IsValid(self:GetOwner()) and self:GetOwner() == LocalPlayer() and self:GetOwner():Alive() then
		RunConsoleCommand("lastinv")
	end
end

if CLIENT then
	---
	-- @ignore
	function SWEP:Initialize()
		self:AddTTT2HUDHelp("radio_help_primary", "radio_help_secondary")

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

