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

---
-- @ignore
function SWEP:OnDrop()
	self:Remove()
end

---
-- @ignore
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:RadioDrop()
end

---
-- @ignore
function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	self:RadioStick()
end

local throwsound = Sound("Weapon_SLAM.SatchelThrow")

--- c4 plant but different
-- @ignore
function SWEP:RadioDrop()
	if SERVER then
		local ply = self:GetOwner()
		if not IsValid(ply) then return end

		if self.Planted then return end

		local vsrc = ply:GetShootPos()
		local vang = ply:GetAimVector()
		local vvel = ply:GetVelocity()

		local vthrow = vvel + vang * 200

		local radio = ents.Create("ttt_radio")
		if IsValid(radio) then
			radio:SetPos(vsrc + vang * 10)
			radio:SetOwner(ply)
			radio:Spawn()

			radio:PhysWake()
			local phys = radio:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocity(vthrow)
			end
			self:Remove()

			self.Planted = true
		end
	end

	self:EmitSound(throwsound)
end

--- hey look, more C4 code
-- @ignore
function SWEP:RadioStick()
	if SERVER then
		local ply = self:GetOwner()
		if not IsValid(ply) then return end

		if self.Planted then return end

		local ignore = {ply, self}
		local spos = ply:GetShootPos()
		local epos = spos + ply:GetAimVector() * 80
		local tr = util.TraceLine({start = spos, endpos = epos, filter = ignore, mask = MASK_SOLID})

		if tr.HitWorld then
			local radio = ents.Create("ttt_radio")
			if IsValid(radio) then
				radio:PointAtEntity(ply)

				local tr_ent =
					util.TraceEntity({start = spos, endpos = epos, filter = ignore, mask = MASK_SOLID}, radio)

				if tr_ent.HitWorld then
					local ang = tr_ent.HitNormal:Angle()
					ang:RotateAroundAxis(ang:Up(), -180)

					radio:SetPos(tr_ent.HitPos + ang:Forward() * -2.5)
					radio:SetAngles(ang)
					radio:SetOwner(ply)
					radio:Spawn()

					local phys = radio:GetPhysicsObject()
					if IsValid(phys) then
						phys:EnableMotion(false)
					end

					radio.IsOnWall = true

					self:Remove()

					self.Planted = true
				end
			end
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
end

--- Invisible, same hacks as holstered weapon
-- @ignore
function SWEP:Deploy()
	if SERVER and IsValid(self:GetOwner()) then
		self:GetOwner():DrawViewModel(false)
	end
	return true
end

---
-- @ignore
function SWEP:DrawWorldModel() end

---
-- @ignore
function SWEP:DrawWorldModelTranslucent() end

