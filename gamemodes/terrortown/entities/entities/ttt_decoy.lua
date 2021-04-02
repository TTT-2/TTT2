---
-- @class ENT
-- @desc Decoy sending out a radar blip and redirecting DNA scans. Based on old beacon
-- code.
-- @section ttt_decoy

if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Model = Model("models/props_lab/reciever01b.mdl")
ENT.CanHavePrints = false
ENT.CanUseKey = true

---
-- @realm shared
function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
	end

	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)

	if SERVER then
		self:SetMaxHealth(100)
	end

	self:SetHealth(100)

	-- can pick this up if we own it
	if SERVER then
		self:SetUseType(SIMPLE_USE)

		local weptbl = util.WeaponForClass("weapon_ttt_decoy")

		if weptbl and weptbl.Kind then
			self.WeaponKind = weptbl.Kind
		else
			self.WeaponKind = WEAPON_EQUIP2
		end
	end
end

---
-- @param Player activator
-- @realm shared
function ENT:UseOverride(activator)
	if not IsValid(activator) or not activator:HasTeam() or self:GetNWString("decoy_owner_team", "none") ~= activator:GetTeam() then return end

	-- picks up weapon, switches if possible and needed, returns weapon if successful
	local wep = activator:SafePickupWeaponClass("weapon_ttt_decoy", true)

	if not IsValid(wep) then
		LANG.Msg(activator, "decoy_no_room")

		return
	end

	self:Remove()
end

local zapsound = Sound("npc/assassin/ball_zap1.wav")

---
-- @param DamageInfo dmginfo
-- @realm shared
function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
	self:SetHealth(self:Health() - dmginfo:GetDamage())

	if self:Health() > 0 then return end

	self:Remove()

	local effect = EffectData()
	effect:SetOrigin(self:GetPos())

	util.Effect("cball_explode", effect)
	sound.Play(zapsound, self:GetPos())

	if IsValid(self:GetOwner()) then
		LANG.Msg(self:GetOwner(), "decoy_broken")
	end
end

---
-- @realm shared
function ENT:OnRemove()
	if not IsValid(self:GetOwner()) then return end

	self:GetOwner().decoy = nil
end

if CLIENT then
	local TryT = LANG.TryTranslation
	local ParT = LANG.GetParamTranslation

	-- handle looking at decoy
	hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDDecoy", function(tData)
		local client = LocalPlayer()
		local ent = tData:GetEntity()

		if not IsValid(client) or not client:IsTerror() or not client:Alive()
		or not IsValid(ent) or tData:GetEntityDistance() > 100 or ent:GetClass() ~= "ttt_decoy" then
			return
		end

		-- enable targetID rendering
		tData:EnableText()
		tData:EnableOutline()
		tData:SetOutlineColor(client:GetRoleColor())

		tData:SetTitle(TryT("decoy_name"))
		tData:SetSubtitle(ParT("target_pickup", {usekey = Key("+use", "USE")}))
		tData:SetKeyBinding("+use")
		tData:AddDescriptionLine(TryT("decoy_short_desc"))

		if ent:GetNWString("decoy_owner_team", "none") == client:GetTeam() then return end

		tData:AddDescriptionLine(
			TryT("decoy_pickup_wrong_team"),
			COLOR_ORANGE
		)
	end)
end
