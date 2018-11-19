-- serverside extensions to player table

local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

function plymeta:SetRagdollSpec(s)
	if s then
		self.spec_ragdoll_start = CurTime()
	end

	self.spec_ragdoll = s
end

function plymeta:GetRagdollSpec()
	return self.spec_ragdoll
end

function plymeta:SetForceSpec(state)
	self.force_spec = state -- compatibility with other addons

	self:SetNWBool("force_spec", state)
end

--- Karma

-- The base/start karma is determined once per round and determines the player's
-- damage penalty. It is networked and shown on clients.
function plymeta:SetBaseKarma(k)
	self:SetNWFloat("karma", k)
end

-- The live karma starts equal to the base karma, but is updated "live" as the
-- player damages/kills others. When another player damages/kills this one, the
-- live karma is used to determine his karma penalty.
AccessorFunc(plymeta, "live_karma", "LiveKarma", FORCE_NUMBER)

-- The damage factor scales how much damage the player deals, so if it is .9
-- then the player only deals 90% of his original damage.
AccessorFunc(plymeta, "dmg_factor", "DamageFactor", FORCE_NUMBER)

-- If a player does not damage team members in a round, he has a "clean" round
-- and gets a bonus for it.
AccessorFunc(plymeta, "clean_round", "CleanRound", FORCE_BOOL)

function plymeta:InitKarma()
	KARMA.InitPlayer(self)
end

--- Equipment credits
function plymeta:SetCredits(amt)
	self.equipment_credits = amt

	self:SendCredits()
end

function plymeta:AddCredits(amt)
	self:SetCredits(self:GetCredits() + amt)
end

function plymeta:SubtractCredits(amt)
	self:AddCredits(-amt)
end

function plymeta:SetDefaultCredits()
	if hook.Run("TTT2SetDefaultCredits", self) then return end

	if self:IsShopper() then
		local rd = self:GetSubRoleData()
		local name = rd.index == ROLE_TRAITOR and "ttt_credits_starting" or "ttt_" .. rd.abbr .. "_credits_starting"

		if self:HasTeam(TEAM_TRAITOR) then
			local c = (ConVarExists(name) and GetConVar(name):GetInt()) or 0

			if not rd.preventTraitorAloneCredits and #GetTeamMembers(TEAM_TRAITOR) == 1 then
				c = c + (ConVarExists("ttt_credits_alonebonus") and GetConVar("ttt_credits_alonebonus"):GetInt()) or 0
			end

			self:SetCredits(math.ceil(c))
		else
			self:SetCredits(math.ceil(ConVarExists(name) and GetConVar(name):GetInt() or 0))
		end
	else
		self:SetCredits(0)
	end
end

function plymeta:SendCredits()
	net.Start("TTT_Credits")
	net.WriteUInt(self:GetCredits(), 8)
	net.Send(self)
end

--- Equipment items
function plymeta:AddEquipmentItem(id)
	id = tonumber(id)

	if id then
		self.equipment_items = bit.bor(self.equipment_items, id)

		self:SendEquipment()
	end
end

-- We do this instead of an NW var in order to limit the info to just this ply
function plymeta:SendEquipment()
	net.Start("TTT_Equipment")
	net.WriteUInt(self.equipment_items, 16)
	net.Send(self)
end

function plymeta:ResetEquipment()
	self.equipment_items = EQUIP_NONE

	self:SendEquipment()
end

function plymeta:SendBought()
	-- Send all as string, even though equipment are numbers, for simplicity
	net.Start("TTT_Bought")
	net.WriteUInt(#self.bought, 8)

	for _, v in ipairs(self.bought) do
		net.WriteString(v)
	end

	net.Send(self)
end

local function ttt_resend_bought(ply)
	if IsValid(ply) then
		ply:SendBought()
	end
end
concommand.Add("ttt_resend_bought", ttt_resend_bought)

function plymeta:ResetBought()
	self.bought = {}

	self:SendBought()
end

function plymeta:AddBought(id)
	self.bought = self.bought or {}

	table.insert(self.bought, tostring(id))

	self:SendBought()
end


-- Strips player of all equipment
function plymeta:StripAll()
	-- standard stuff
	self:StripAmmo()
	self:StripWeapons()

	-- our stuff
	self:ResetEquipment()
	self:SetCredits(0)
end

-- Sets all flags (force_spec, etc) to their default
function plymeta:ResetStatus()
	self:SetRole(ROLE_INNOCENT) -- this will update the team automatically
	self:SetRagdollSpec(false)
	self:SetForceSpec(false)
	self:ResetRoundFlags()
end

-- Sets round-based misc flags to default position. Called at PlayerSpawn.
function plymeta:ResetRoundFlags()
	self:ResetEquipment()
	self:SetCredits(0)
	self:ResetBought()

	-- equipment stuff
	self.bomb_wire = nil
	self.radar_charge = 0
	self.decoy = nil

	-- corpse
	self:SetNWBool("body_found", false)

	self.kills = {}
	self.dying_wep = nil
	self.was_headshot = false

	-- communication
	self.mute_team = -1

	for _, team in ipairs(GetWinTeams()) do
		self[team .. "_gvoice"] = false
	end

	self:SetNWBool("disguised", false)

	-- karma
	self:SetCleanRound(true)
	self:Freeze(false)
end

function plymeta:GiveEquipmentItem(id)
	if self:HasEquipmentItem(id) then
		return false
	elseif id and id > EQUIP_NONE then
		self:AddEquipmentItem(id)

		return true
	end
end

-- Forced specs and latejoin specs should not get points
function plymeta:ShouldScore()
	if self:GetForceSpec() then
		return false
	elseif self:IsSpec() and self:Alive() then
		return false
	else
		return true
	end
end

function plymeta:RecordKill(victim)
	if not IsValid(victim) then return end

	self.kills = self.kills or {}

	table.insert(self.kills, victim:SteamID64())
end

function plymeta:SetSpeed(slowed)
	error "Player:SetSpeed(slowed) is deprecated - please remove this call and use the TTTPlayerSpeedModifier hook in both CLIENT and SERVER states"
end

function plymeta:ResetLastWords()
	if not IsValid(self) then return end -- timers are dangerous things

	self.last_words_id = nil
end

function plymeta:SendLastWords(dmginfo)
	-- Use a pseudo unique id to prevent people from abusing the concmd
	self.last_words_id = math.floor(CurTime() + math.random(500))

	-- See if the damage was interesting
	local dtype = KILL_NORMAL

	if dmginfo:GetAttacker() == self or dmginfo:GetInflictor() == self then
		dtype = KILL_SUICIDE
	elseif dmginfo:IsDamageType(DMG_BURN) then
		dtype = KILL_BURN
	elseif dmginfo:IsFallDamage() then
		dtype = KILL_FALL
	end

	self.death_type = dtype

	net.Start("TTT_InterruptChat")
	net.WriteUInt(self.last_words_id, 32)
	net.Send(self)

	-- any longer than this and you're out of luck
	local ply = self

	timer.Simple(2, function()
		ply:ResetLastWords()
	end)
end

function plymeta:ResetViewRoll()
	local ang = self:EyeAngles()

	if ang.r ~= 0 then
		ang.r = 0

		self:SetEyeAngles(ang)
	end
end

function plymeta:ShouldSpawn()
	-- do not spawn players who have not been through initspawn
	if not self:IsSpec() and not self:IsTerror() then
		return false
	end

	-- do not spawn forced specs
	if self:IsSpec() and self:GetForceSpec() then
		return false
	end

	return true
end

-- Preps a player for a new round, spawning them if they should. If dead_only is
-- true, only spawns if player is dead, else just makes sure he is healed.
function plymeta:SpawnForRound(dead_only)
	hook.Call("PlayerSetModel", GAMEMODE, self)
	hook.Call("TTTPlayerSetColor", GAMEMODE, self)

	-- wrong alive status and not a willing spec who unforced after prep started
	-- (and will therefore be "alive")
	if dead_only and self:Alive() and not self:IsSpec() then
		-- if the player does not need respawn, make sure he has full health
		self:SetHealth(self:GetMaxHealth())

		return false
	end

	if not self:ShouldSpawn() then
		return false
	end

	-- reset propspec state that they may have gotten during prep
	PROPSPEC.Clear(self)

	-- respawn anyone else
	if self:Team() == TEAM_SPEC then
		self:UnSpectate()
	end

	self:StripAll()
	self:SetTeam(TEAM_TERROR)
	self:Spawn()

	-- tell caller that we spawned
	return true
end

function plymeta:InitialSpawn()
	self.has_spawned = false

	-- The team the player spawns on depends on the round state
	self:SetTeam(GetRoundState() == ROUND_PREP and TEAM_TERROR or TEAM_SPEC)

	-- Change some gmod defaults
	self:SetCanZoom(false)
	self:SetJumpPower(160)
	self:SetCrouchedWalkSpeed(0.3)
	self:SetRunSpeed(220)
	self:SetWalkSpeed(220)
	self:SetMaxSpeed(220)

	-- Always spawn innocent initially, traitor will be selected later
	self:ResetStatus()

	-- Start off with clean, full karma (unless it can and should be loaded)
	self:InitKarma()

	-- We never have weapons here, but this inits our equipment state
	self:StripAll()
end

function plymeta:KickBan(length, reason)
	-- see admin.lua
	PerformKickBan(self, length, reason)
end

local oldSpectate = plymeta.Spectate

function plymeta:Spectate(type)
	oldSpectate(self, type)

	-- NPCs should never see spectators. A workaround for the fact that gmod NPCs
	-- do not ignore them by default.
	self:SetNoTarget(true)

	if type == OBS_MODE_ROAMING then
		self:SetMoveType(MOVETYPE_NOCLIP)
	end
end

local oldSpectateEntity = plymeta.SpectateEntity

function plymeta:SpectateEntity(ent)
	oldSpectateEntity(self, ent)

	if IsValid(ent) and ent:IsPlayer() then
		self:SetupHands(ent)
	end
end

local oldUnSpectate = plymeta.UnSpectate

function plymeta:UnSpectate()
	oldUnSpectate(self)

	self:SetNoTarget(false)
end

function plymeta:GetAvoidRole(role)
	return self:GetInfoNum("ttt_avoid_" .. GetRoleByIndex(role).name, 0) > 0
end

function plymeta:CanSelectRole(roleData, choice_count, role_count)
	local min_karmas = (ConVarExists("ttt_" .. roleData.name .. "_karma_min") and GetConVar("ttt_" .. roleData.name .. "_karma_min"):GetInt()) or 0

	return (
		choice_count <= role_count
		or self:GetBaseKarma() > min_karmas and GAMEMODE.LastRole[self:SteamID64()] == ROLE_INNOCENT
		or math.random(1, 3) == 2
	) and (choice_count <= role_count or not self:GetAvoidRole(roleData.index))
end

--------------------------------------------------
--			   MODIFIED EXTERN CODE
--------------------------------------------------
-- Code is basically from GameFreak's SecondChance

local function FindCorpse(ply)
	for _, ent in ipairs(ents.FindByClass("prop_ragdoll")) do
		if ent.uqid == ply:UniqueID() and IsValid(ent) then
			return ent or false
		end
	end
end

local Positions = {}

-- Populate Around Player
for i = 0, 360, 22.5 do
	table.insert(Positions, Vector(math.cos(i), math.sin(i), 0))
end

table.insert(Positions, Vector(0, 0, 1)) -- Populate Above Player

local function FindCorpsePosition(corpse)
	local size = Vector(32, 32, 72)
	local startPos = corpse:GetPos() + Vector(0, 0, size.z * 0.5)
	local len = #Positions

	for i = 1, len do
		local v = Positions[i]
		local pos = startPos + v * size * 1.5

		local tr = {}
		tr.start = pos
		tr.endpos = pos
		tr.mins = size * -0.5
		tr.maxs = size * 0.5

		local trace = util.TraceHull(tr)

		if not trace.Hit then
			return pos - Vector(0, 0, size.z * 0.5)
		end
	end

	return false
end

function plymeta:Revive(delay, fn, check, needcorpse)
	local ply = self
	local name = "TTT2RevivePlayer" .. ply:EntIndex()

	if timer.Exists(name) then return end

	timer.Create(name, delay, 1, function()
		if not check or check(ply) then
			local corpse = FindCorpse(ply)

			if needcorpse and (not IsValid(corpse) or corpse:IsOnFire()) then
				timer.Remove(name) -- TODO needed?

				return
			end

			if corpse then
				local spawnPos = FindCorpsePosition(corpse)

				if not spawnPos then return end

				ply:SpawnForRound(true)
				ply:SetPos(spawnPos)
				ply:SetEyeAngles(Angle(0, corpse:GetAngles().y, 0))
			else
				ply:SpawnForRound(true)
			end

			ply:SetMaxHealth(100)

			local credits = CORPSE.GetCredits(corpse, 0)

			ply:SetCredits(credits)
			corpse:Remove()

			DamageLog("TTT2Revive: " .. ply:Nick() .. " has been respawned.")

			if fn then
				fn(ply)
			end
		end
	end)
end

function plymeta:GiveItem(id)
	self:GiveEquipmentItem(id)
	self:AddBought(id)

	local ply = self

	timer.Simple(0.5, function()
		if not IsValid(ply) then return end

		net.Start("TTT_BoughtItem")
		net.WriteBit(true)
		net.WriteUInt(id, 16)
		net.Send(ply)
	end)

	hook.Run("TTTOrderedEquipment", self, id, id) -- hook.Run("TTTOrderedEquipment", self, id, true) -- i know, looks stupid but thats the way TTT does
end
