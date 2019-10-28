---- Health dispenser

AddCSLuaFile()

if CLIENT then
	-- this entity can be DNA-sampled so we need some display info
	ENT.Icon = "vgui/ttt/icon_health"
	ENT.PrintName = "hstation_name"

	local TryT = LANG.TryTranslation
	local ParT = LANG.GetParamTranslation

	-- handle looking at healthstation
	function HUDDrawTargetIDGealthStation(data, params)
		local client = LocalPlayer()

		if not IsValid(client) or not client:IsTerror() or not client:Alive()
		or data.distance > 100 or data.ent:GetClass() ~= "ttt_health_station" then
			return
		end

		params.drawInfo = true
		params.displayInfo.key = input.GetKeyCode(input.LookupBinding("+use"))
		params.displayInfo.title.text = TryT(data.ent.PrintName)

		params.displayInfo.subtitle.text = TryT("hstation_subtitle")

		local hstation_charge = data.ent:GetStoredHealth() or 0

		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = TryT("hstation_short_desc"),
		}

		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = (hstation_charge > 0) and ParT('hstation_charge', {charge = hstation_charge}) or TryT("hstation_empty"),
			color = (hstation_charge > 0) and DETECTIVE.bgcolor or COLOR_ORANGE
		}

		if client:Health() == client:GetMaxHealth() then
			params.displayInfo.desc[#params.displayInfo.desc + 1] = {
				text = TryT('hstation_maxhealth'),
				color = COLOR_ORANGE
			}
		end

		params.drawOutline = true
		params.outlineColor = client:GetRoleColor()
	end
end

ENT.Type = "anim"
ENT.Model = Model("models/props/cs_office/microwave.mdl")

--ENT.CanUseKey = true
ENT.CanHavePrints = true
ENT.MaxHeal = 25
ENT.MaxStored = 200
ENT.RechargeRate = 1
ENT.RechargeFreq = 2 -- in seconds

ENT.NextHeal = 0
ENT.HealRate = 1
ENT.HealFreq = 0.2

AccessorFuncDT(ENT, "StoredHealth", "StoredHealth")
AccessorFunc(ENT, "Placer", "Placer")

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "StoredHealth")
end

function ENT:Initialize()
	self:SetModel(self.Model)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)

	local b = 32

	self:SetCollisionBounds(Vector(-b, -b, -b), Vector(b,b,b))
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	if SERVER then
		self:SetMaxHealth(200)

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(200)
		end

		self:SetUseType(CONTINUOUS_USE)
	end

	self:SetHealth(200)
	self:SetColor(Color(180, 180, 250, 255))
	self:SetStoredHealth(200)
	self:SetPlacer(nil)

	self.NextHeal = 0
	self.fingerprints = {}
end

function ENT:AddToStorage(amount)
	self:SetStoredHealth(math.min(self.MaxStored, self:GetStoredHealth() + amount))
end

function ENT:TakeFromStorage(amount)
	-- if we only have 5 healthpts in store, that is the amount we heal
	amount = math.min(amount, self:GetStoredHealth())
	self:SetStoredHealth(math.max(0, self:GetStoredHealth() - amount))

	return amount
end

local healsound = Sound("items/medshot4.wav")
local failsound = Sound("items/medshotno1.wav")
local last_sound_time = 0

function ENT:GiveHealth(ply, max_heal)
	if self:GetStoredHealth() > 0 then
		local dmg = ply:GetMaxHealth() - ply:Health()
		max_heal = max_heal or self.MaxHeal

		if dmg > 0 then
			-- constant clamping, no risks
			local healed = self:TakeFromStorage(math.min(max_heal, dmg))
			local new = math.min(ply:GetMaxHealth(), ply:Health() + healed)

			ply:SetHealth(new)
			hook.Run("TTTPlayerUsedHealthStation", ply, self, healed)

			if last_sound_time + 2 < CurTime() then
				self:EmitSound(healsound)
				last_sound_time = CurTime()
			end

			if not table.HasValue(self.fingerprints, ply) then
				table.insert(self.fingerprints, ply)
			end

			return true
		else
			self:EmitSound(failsound)
		end
	else
		self:EmitSound(failsound)
	end

	return false
end

function ENT:Use(ply)
	if IsValid(ply) and ply:IsPlayer() and ply:IsActive() then
		local t = CurTime()
		if t > self.NextHeal then
			local healed = self:GiveHealth(ply, self.HealRate)

			self.NextHeal = t + (self.HealFreq * (healed and 1 or 2))
		end
	end
end

if SERVER then
	-- recharge
	local nextcharge = 0

	function ENT:Think()
		if nextcharge >= CurTime() then return end

		self:AddToStorage(self.RechargeRate)
		nextcharge = CurTime() + self.RechargeFreq
	end

	local ttt_damage_own_healthstation = CreateConVar("ttt_damage_own_healthstation", "0") -- 0 as detective cannot damage their own health station

	-- traditional equipment destruction effects
	function ENT:OnTakeDamage(dmginfo)
		if dmginfo:GetAttacker() == self:GetPlacer() and not ttt_damage_own_healthstation:GetBool() then return end

		self:TakePhysicsDamage(dmginfo)

		self:SetHealth(self:Health() - dmginfo:GetDamage())

		local att = dmginfo:GetAttacker()
		local placer = self:GetPlacer()
		if IsPlayer(att) then
			DamageLog(Format("DMG: \t %s [%s] damaged health station [%s] for %d dmg", att:Nick(), att:GetRoleString(),  (IsPlayer(placer) and placer:Nick() or "<disconnected>"), dmginfo:GetDamage()))
		end

		if self:Health() < 0 then
			self:Remove()
			util.EquipmentDestroyed(self:GetPos())

			if IsValid(self:GetPlacer()) then
				LANG.Msg(self:GetPlacer(), "hstation_broken")
			end
		end
	end
end