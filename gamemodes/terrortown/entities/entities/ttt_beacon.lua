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

ENT.timeLastBeep = CurTime()
ENT.lastPlysFound = {}

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

		radarVision.RegisterEntity(self, self:GetOwner(), VISIBLE_FOR_PLAYER)
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

if SERVER then
	---
	-- @realm shared
	function ENT:Think()
		if self.timeLastBeep + 5 >= CurTime() then
			sound.Play(soundBeep, self:GetPos(), 100, 80)

			self.timeLastBeep = CurTime()
		end

		local entsFound = ents.FindInSphere(self:GetPos(), beaconDetectionRange)
		local plysFound = {}
		local affectedPlayers = {}

		for i = 1, #entsFound do
			local ent = entsFound[i]

			if not IsValid(ent) or not ent:IsPlayer() then continue end

			plysFound[ent] = true
			affectedPlayers[ent] = true
		end

		table.Merge(affectedPlayers, self.lastPlysFound)

		for ply in pairs(affectedPlayers) do
			if plysFound[ply] and not self.lastPlysFound[ply] then
				-- newly added player in range
				radarVision.RegisterEntity(ply, self:GetOwner(), VISIBLE_FOR_ALL, roles.DETECTIVE.color)
			elseif not plysFound[ply] and self.lastPlysFound[ply] then
				-- player lost in range
				radarVision.RemoveEntity(ply)
			end
		end

		self.lastPlysFound = plysFound

		self:NextThink(CurTime() + 0.25)

		return true
	end

	function ENT:OnRemove()
		for ply in pairs(self.lastPlysFound) do
			radarVision.RemoveEntity(ply)
		end
	end

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

	local materialBeacon = Material("vgui/ttt/radar/beacon")
	local materialPlayer = Material("vgui/ttt/tid/tid_big_role_not_known")

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

	hook.Add("TTT2RenderRadarInfo", "HUDDrawRadarBeacon", function(rData)
		local client = LocalPlayer()
		local ent = rData:GetEntity()

		if not client:IsTerror() or not IsValid(ent) or ent:GetClass() ~= "ttt_beacon" then return end

		local owner = ent:GetOwner()
		local nick = IsValid(owner) and owner:Nick() or "---"

		local distance = math.Round(util.HammerUnitsToMeters(rData:GetEntityDistance()), 1)

		rData:EnableText()

		rData:AddIcon(materialBeacon)
		rData:SetTitle(TryT(ent.PrintName))

		rData:AddDescriptionLine(ParT("bombvision_owner", {owner = nick}))
		rData:AddDescriptionLine(ParT("bombvision_distance", {distance = distance}))

		rData:AddDescriptionLine(TryT("bombvision_visible_for_" .. radarVision.GetVisibleFor(ent)), COLOR_SLATEGRAY)
	end)

	hook.Add("TTT2RenderRadarInfo", "HUDDrawRadarBeaconPlys", function(rData)
		local client = LocalPlayer()
		local ent = rData:GetEntity()

		if not client:IsTerror() or not IsValid(ent) or not ent:IsPlayer() or ent == client then return end

		rData:EnableText()

		rData:AddIcon(materialPlayer)
		rData:SetTitle(TryT("beacon_bombvision_player"))

		rData:AddDescriptionLine(TryT("beacon_bombvision_player_tracked"))

		rData:AddDescriptionLine(TryT("bombvision_visible_for_" .. radarVision.GetVisibleFor(ent)), COLOR_SLATEGRAY)
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
