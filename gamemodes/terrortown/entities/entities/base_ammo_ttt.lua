---
-- @class ENT
-- @desc Ammo override base
-- @section BaseAmmo

if SERVER then
	AddCSLuaFile()
end

local util = util
local hook = hook

ENT.Type = "anim"

-- Override these values
ENT.AmmoType = "Pistol"
ENT.AmmoAmount = 1
ENT.AmmoMax = 10
ENT.AmmoEntMax = 1
ENT.Model = Model("models/items/boxsrounds.mdl")

---
-- bw compat
-- @realm shared
function ENT:RealInit()

end

---
-- Some subclasses want to do stuff before/after initing (eg. setting color)
-- Using self.BaseClass gave weird problems, so stuff has been moved into a fn
-- Subclasses can easily call this whenever they want to
-- @realm shared
function ENT:Initialize()
	self:SetModel(self.Model)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)

	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	local b = 26

	self:SetCollisionBounds(Vector(-b, -b, -b), Vector(b, b, b))

	if SERVER then
		self:SetTrigger(true)
	end

	self.tickRemoval = false

	-- this made the ammo get physics'd too early, meaning it would fall
	-- through physics surfaces it was lying on on the client, leading to
	-- inconsistencies
	--	local phys = self:GetPhysicsObject()
	--	if (phys:IsValid()) then
	--		phys:Wake()
	--	end

	self.AmmoEntMax = self.AmmoAmount
end

---
-- Pseudo-clone of SDK's UTIL_ItemCanBeTouchedByPlayer
-- aims to prevent picking stuff up through fences and stuff
-- @param Player ply
-- @return boolean
-- @realm shared
function ENT:PlayerCanPickup(ply)
	if ply == self:GetOwner() then
		return false
	end

	---
	-- @realm shared
	local result = hook.Run("TTTCanPickupAmmo", ply, self)
	if result then
		return result
	end

	local ent = self
	local phys = ent:GetPhysicsObject()
	local spos = phys:IsValid() and phys:GetPos() or ent:OBBCenter()
	local epos = ply:GetShootPos() -- equiv to EyePos in SDK

	local tr = util.TraceLine({
		start = spos,
		endpos = epos,
		filter = {ply, ent},
		mask = MASK_SOLID
	})

	-- can pickup if trace was not stopped
	return tr.Fraction == 1.0
end

---
-- @param Player ply
-- @return boolean
-- @realm shared
function ENT:CheckForWeapon(ply)
	if not self.CachedWeapons then
		-- create a cache of what weapon classes use this ammo
		local tbl = {}
		local weps = weapons.GetList()
		local cls = self:GetClass()

		local WEPSGetClass = WEPS.GetClass

		for i = 1, #weps do
			local v = weps[i]

			if v.AmmoEnt == cls then
				tbl[#tbl + 1] = WEPSGetClass(v)
			end
		end

		self.CachedWeapons = tbl
	end

	local plyHasWeapon = ply.HasWeapon
	local cached = self.CachedWeapons

	-- Check if player has a weapon that we know needs us. This is called in
	-- Touch, which is called many a time, so we use the cache here to avoid
	-- looping through every weapon the player has to check their AmmoEnt.
	for i = 1, #cached do
		if plyHasWeapon(ply, cached[i]) then
			return true
		end
	end

	return false
end

---
-- @param Entity ent
-- @realm shared
function ENT:Touch(ent)
	if SERVER and not self.tickRemoval and ent:IsValid() and ent:IsPlayer() and self:CheckForWeapon(ent) and self:PlayerCanPickup(ent) then
		local ammo = ent:GetAmmoCount(self.AmmoType)

		-- need clipmax info and room for at least 1/4th
		if self.AmmoMax >= ammo + math.ceil(self.AmmoAmount * 0.25) then
			local given = math.min(self.AmmoAmount, self.AmmoMax - ammo)

			ent:GiveAmmo(given, self.AmmoType)

			self.AmmoAmount = self.AmmoAmount - given

			if self.AmmoAmount <= 0 or math.ceil(self.AmmoEntMax * 0.25) > self.AmmoAmount then
				self.tickRemoval = true

				self:Remove()
			end
		end
	end
end

-- Hack to force ammo to physwake
if SERVER then
	---
	-- @realm server
	function ENT:Think()
		if not self.first_think then
			self:PhysWake()

			self.first_think = true

			-- Immediately unhook the Think, save cycles. The first_think thing is
			-- just there in case it still Thinks somehow in the future.
			self.Think = nil
		end
	end
end
