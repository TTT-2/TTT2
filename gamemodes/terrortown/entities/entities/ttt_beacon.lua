---
-- @class ENT
-- @section ttt_beacon

if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	ENT.Icon = "vgui/ttt/icon_beacon"
	ENT.PrintName = "Beacon"
end

ENT.Type = "anim"
ENT.Model = Model("models/props_lab/reciever01b.mdl")
ENT.CanHavePrints = true
ENT.CanUseKey = true

local beaconDetectionRange = 135

local soundZap = Sound("npc/assassin/ball_zap1.wav")
local soundBeep = Sound("weapons/c4/cc4_beep1.wav")

---
-- @realm shared
function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
	end

	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	if SERVER then
		self:SetMaxHealth(100)
	end
	self:SetHealth(100)

	if SERVER then
		self:SetUseType(SIMPLE_USE)
		self:NextThink(CurTime() + 1)
	end
end

---
-- @param Entity activator
-- @realm shared
function ENT:UseOverride(activator)
	if not IsValid(activator) or self:GetOwner() ~= activator then return end

	local wep = activator:GetWeapon("weapon_ttt_beacon")

	if IsValid(wep) then
		local pickup = wep:PickupBeacon()

		if not pickup then return end
	else
		wep = activator:GiveEquipmentWeapon("weapon_ttt_beacon")
	end

	self:Remove()
end

---
-- @param CTakeDamageInfo dmginfo
-- @realm shared
function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
	self:SetHealth(self:Health() - dmginfo:GetDamage())

	if self:Health() <= 0 then
		self:Remove()

		local effect = EffectData()
		effect:SetOrigin(self:GetPos())

		util.Effect("cball_explode", effect)

		sound.Play(soundZap, self:GetPos())

		if IsValid(self:GetOwner()) then
			LANG.Msg(self:GetOwner(), "msg_beacon_destroyed", nil, MSG_MSTACK_WARN)
		end
	end
end

---
-- @realm shared
function ENT:Think()
	if SERVER then
		sound.Play(soundBeep, self:GetPos(), 100, 80)
	else
		local entsFound = ents.FindInSphere(self:GetPos(), beaconDetectionRange)
		local plysFound = {}

		for i = 1, #entsFound do
			local ent = entsFound[i]

			if not IsValid(ent) or not ent:IsPlayer() then continue end

			---
			-- Hook that is called when a player is about to be found by a beacon.
			-- With this hook the player can be ignored.
			-- @param Player ply The player that the beacon has found
			-- @param Entity ent The beacon entity that found the player
			-- @return boolean Return false to cancel the player being detected
			-- @hook
			-- @realm server
			if hook.run("TTT2BeaconDetectPlayer", self, ent) == false then continue end

			plysFound[#plysFound + 1] = ent
		end

		marks.Remove(self.lastPlysFound or {})
		marks.Add(plysFound, roles.DETECTIVE.color)

		self.lastPlysFound = plysFound
	end

	-- only sets the next think on the server
	self:NextThink(CurTime() + 5)

	return true
end

if SERVER then
	---
	-- @realm server
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end

	hook.Add("PlayerDeath", "BeaconTrackPlayerDeath", function(victim)
		local entsFound = ents.FindInSphere(victim:GetPos(), beaconDetectionRange)
		local beaconsFound = {}
		local playersNotified = {}

		for i = 1, #entsFound do
			local ent = entsFound[i]

			if not IsValid(ent) or ent:GetClass() ~= "ttt_beacon" then continue end

			beaconsFound[#beaconsFound + 1] = ent
		end

		for i = 1, #beaconsFound do
			local beacon = beaconsFound[i]
			local beaconOwner = beacon:GetOwner()

			if not IsValid(beaconOwner) or table.HasValue(playersNotified, beaconOwner) then continue end

			---
			-- Hook that is called when a beacon is about to report a death.
			-- With this hook the death can be ignored.
			-- @param Player victim The player that died
			-- @param Entity beacon The beacon entity that the player died near
			-- @return boolean Return false to cancel the death being reported
			-- @hook
			-- @realm server
			if hook.run("TTT2BeaconDeathNotify", victim, beacon) == false then continue end

			LANG.Msg(beaconOwner, "msg_beacon_death", nil, MSG_MSTACK_WARN)

			-- make sure a player is only notified once, even if multiple beacons are triggered
			playersNotified[#playersNotified + 1] = beaconOwner
		end
	end)
end

if CLIENT then
	local TryT = LANG.TryTranslation
	local ParT = LANG.GetParamTranslation

	local baseOpacity = 35
	local factorRenderDistance = 3

	---
	-- @realm client
	function ENT:OnRemove()
		marks.Remove(self.lastPlysFound or {})
	end

	-- handle looking at Beacon
	hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDBeacon", function(tData)
		local client = LocalPlayer()
		local ent = tData:GetEntity()

		if not IsValid(client) or not client:IsTerror() or not client:Alive()
			or not IsValid(ent) or tData:GetEntityDistance() > 100 or ent:GetClass() ~= "ttt_beacon"
		then return end

		-- enable targetID rendering
		tData:EnableText()
		tData:EnableOutline()
		tData:SetOutlineColor(client:GetRoleColor())

		tData:SetTitle(TryT(ent.PrintName))

		if ent:GetOwner() == client then
			tData:SetKeyBinding("+use")
			tData:SetSubtitle(ParT("target_pickup", {usekey = Key("+use", "USE")}))
		else
			tData:AddIcon(roles.DETECTIVE.iconMaterial)
			tData:SetSubtitle(TryT("beacon_pickup_disabled"))
		end

		tData:AddDescriptionLine(TryT("beacon_short_desc"))
	end)

	hook.Add("PostDrawTranslucentRenderables", "BeaconRenderRadius", function(_, bSkybox)
		if bSkybox then return end

		local client = LocalPlayer()

		if not client:GetSubRoleData().isPolicingRole then return end

		local maxRenderDistance = beaconDetectionRange * factorRenderDistance
		local entities = ents.FindInSphere(client:GetPos(), maxRenderDistance)

		local colorSphere = util.ColorLighten(roles.DETECTIVE.color, 120)

		for i = 1, #entities do
			local ent = entities[i]

			if ent:GetClass() ~= "ttt_beacon" or ent:GetOwner() ~= client then continue end

			local distance = math.max(beaconDetectionRange, client:GetPos():Distance(ent:GetPos()))
			colorSphere.a = baseOpacity * math.max(maxRenderDistance - distance, 0) / maxRenderDistance

			render.SetColorMaterial()

			render.DrawSphere(ent:GetPos(), beaconDetectionRange, 30, 30, colorSphere)
			render.CullMode(MATERIAL_CULLMODE_CW)

			render.DrawSphere(ent:GetPos(), beaconDetectionRange, 30, 30, colorSphere)
			render.CullMode(MATERIAL_CULLMODE_CCW)
		end
	end)
end
