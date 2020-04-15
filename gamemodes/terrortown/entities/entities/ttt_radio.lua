---- Radio equipment playing distraction sounds

if SERVER then
	AddCSLuaFile()
else
	-- this entity can be DNA-sampled so we need some display info
	ENT.Icon = "vgui/ttt/icon_radio"
	ENT.PrintName = "radio_name"
end

ENT.Type = "anim"
ENT.Model = Model("models/props/cs_office/radio.mdl")

ENT.CanUseKey = true
ENT.CanHavePrints = false
ENT.SoundLimit = 5
ENT.SoundDelay = 0.5

function ENT:Initialize()
	self:SetModel(self.Model)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)

	if SERVER then
		self:SetMaxHealth(40)
	end

	self:SetHealth(40)

	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end

	-- Register with owner
	if CLIENT then
		local client = LocalPlayer()

		if client == self:GetOwner() then
			client.radio = self
		end
	end

	self.SoundQueue = {}
	self.Playing = false
	self.fingerprints = {}
end

function ENT:UseOverride(activator)
	if IsValid(activator) and activator:IsPlayer() and activator:GetTeam() == self:GetOwner():GetTeam() then
		local prints = self.fingerprints or {}

		-- picks up weapon, switches if possible and needed, returns weapon if successful
		local wep = activator:PickupWeaponClass("weapon_ttt_radio", true)

		if not IsValid(wep) then return end

		self:Remove()

		wep.fingerprints = wep.fingerprints or {}

		table.Add(wep.fingerprints, prints)
	else
		LANG.Msg(activator, "radio_pickup_wrong_team")
	end
end

local zapsound = Sound("npc/assassin/ball_zap1.wav")

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
		LANG.Msg(self:GetOwner(), "radio_broken")
	end
end

if CLIENT then
	function ENT:OnRemove()
		local client = LocalPlayer()

		if client ~= self:GetOwner() then return end

		client.radio = nil
	end
end

function ENT:AddSound(snd)
	if #self.SoundQueue < self.SoundLimit then
		self.SoundQueue[#self.SoundQueue + 1] = snd
	end
end

local simplesounds = {
	scream = {
		Sound("vo/npc/male01/pain07.wav"),
		Sound("vo/npc/male01/pain08.wav"),
		Sound("vo/npc/male01/pain09.wav"),
		Sound("vo/npc/male01/no02.wav")
	},
	explosion = {
		Sound("BaseExplosionEffect.Sound")
	}
}

local serialsounds = {
	footsteps = {
		sound = {
			{
				Sound("player/footsteps/concrete1.wav"),
				Sound("player/footsteps/concrete2.wav")
			},
			{
				Sound("player/footsteps/concrete3.wav"),
				Sound("player/footsteps/concrete4.wav")
			}
		},
		times = {8, 16},
		delay = 0.35,
		ampl = 80
	},
	burning = {
		sound = {
			Sound("General.BurningObject"),
			Sound("General.StopBurning")
		},
		times = {2, 2},
		delay = 4,
	},
	beeps = {
		sound = {
			Sound("weapons/c4/c4_beep1.wav")
		},
		delay = 0.75,
		times = {8, 12},
		ampl = 70
	}
}

local gunsounds = {
	shotgun = {
		sound = Sound("Weapon_XM1014.Single"),
		delay = 0.8,
		times = {1, 3},
		burst = false
	},
	pistol = {
		sound = Sound("Weapon_FiveSeven.Single"),
		delay = 0.4,
		times = {2, 4},
		burst = false
	},
	mac10 = {
		sound = Sound("Weapon_mac10.Single"),
		delay = 0.065,
		times = {5, 10},
		burst = true
	},
	deagle = {
		sound = Sound("Weapon_Deagle.Single"),
		delay = 0.6,
		times = {1, 3},
		burst = false
	},
	m16 = {
		sound = Sound("Weapon_M4A1.Single"),
		delay = 0.2,
		times = {1, 5},
		burst = true
	},
	rifle = {
		sound = Sound("weapons/scout/scout_fire-1.wav"),
		delay = 1.5,
		times = {1, 1},
		burst = false,
		ampl = 80
	},
	huge = {
		sound = Sound("Weapon_m249.Single"),
		delay = 0.055,
		times = {6, 12},
		burst = true
	}
}

function ENT:PlayDelayedSound(snd, ampl, last)
	-- maybe we can get destroyed while a timer is still up
	if not IsValid(self) then return end

	if istable(snd) then
		snd = table.Random(snd)
	end

	sound.Play(snd, self:GetPos(), ampl)

	self.Playing = not last
end

function ENT:PlaySound(snd)
	local pos = self:GetPos()
	local slf = self

	if simplesounds[snd] then
		sound.Play(table.Random(simplesounds[snd]), pos)
	elseif gunsounds[snd] then
		local gunsound = gunsounds[snd]
		local times = math.random(gunsound.times[1], gunsound.times[2])
		local t = 0

		for i = 1, times do
			timer.Simple(t, function()
				if not IsValid(slf) then return end

				slf:PlayDelayedSound(gunsound.sound, gunsound.ampl or 90, i == times)
			end)

			if gunsound.burst then
				t = t + gunsound.delay
			else
				t = t + math.Rand(gunsound.delay, gunsound.delay * 2)
			end
		end
	elseif serialsounds[snd] then
		local serialsound = serialsounds[snd]
		local num = #serialsound.sound
		local times = math.random(serialsound.times[1], serialsound.times[2])
		local t = 0
		local idx = 1

		for i = 1, times do
			timer.Simple(t, function()
				if not IsValid(slf) then return end

				slf:PlayDelayedSound(serialsound.sound[idx], serialsound.ampl or 75, i == times)
			end)

			t = t + serialsound.delay
			idx = idx + 1

			if idx > num then
				idx = 1
			end
		end
	end
end

local nextplay = 0

function ENT:Think()
	if CurTime() <= nextplay or #self.SoundQueue <= 0 then return end

	if not self.Playing then
		self:PlaySound(table.remove(self.SoundQueue, 1))
	end

	-- always do slf, makes timing work out a little better
	nextplay = CurTime() + self.SoundDelay
end

if CLIENT then
	local TryT = LANG.TryTranslation
	local ParT = LANG.GetParamTranslation

	-- handle looking at radio
	hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDRadio", function(tData)
		local client = LocalPlayer()
		local ent = tData:GetEntity()

		if not IsValid(client) or not client:IsTerror() or not client:Alive()
		or tData:GetEntityDistance() > 100 or ent:GetClass() ~= "ttt_radio" then
			return
		end

		-- enable targetID rendering
		tData:EnableText()
		tData:EnableOutline()
		tData:SetOutlineColor(client:GetRoleColor())

		tData:SetTitle(TryT(ent.PrintName))
		tData:SetSubtitle(ParT("target_pickup", {usekey = Key("+use", "USE")}))
		tData:SetKeyBinding("+use")
		tData:AddDescriptionLine(TryT("radio_short_desc"))
	end)
end

if SERVER then
	local soundtypes = {
		"scream",
		"shotgun",
		"explosion",
		"pistol",
		"mac10",
		"deagle",
		"m16",
		"rifle",
		"huge",
		"burning",
		"beeps",
		"footsteps",
	}

	local function RadioCmd(ply, cmd, args)
		if not IsValid(ply) or not ply:IsActive() or not #args == 2 then return end

		local eidx = tonumber(args[1])
		local snd = tostring(args[2])

		if not eidx or not snd then return end

		local radio = Entity(eidx)

		if ply:GetTeam() ~= radio:GetOwner():GetTeam() then return end

		if not IsValid(radio) or radio:GetOwner() ~= ply or radio:GetClass() ~= "ttt_radio" then return end

		if not table.HasValue(soundtypes, snd) then
			print("Received radio sound not in table from", ply)

			return
		end

		radio:AddSound(snd)
	end
	concommand.Add("ttt_radio_play", RadioCmd)
end
