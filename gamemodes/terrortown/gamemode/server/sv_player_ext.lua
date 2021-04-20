---
-- @class Player

-- serverside extensions to player table

local net = net
local table = table
local pairs = pairs
local IsValid = IsValid
local hook = hook

local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

util.AddNetworkString("StartDrowning")
util.AddNetworkString("TTT2TargetPlayer")
util.AddNetworkString("TTT2SetPlayerReady")
util.AddNetworkString("TTT2SetRevivalReason")
util.AddNetworkString("TTT2RevivalStopped")
util.AddNetworkString("TTT2RevivalUpdate_IsReviving")
util.AddNetworkString("TTT2RevivalUpdate_IsBlockingRevival")
util.AddNetworkString("TTT2RevivalUpdate_RevivalStartTime")
util.AddNetworkString("TTT2RevivalUpdate_RevivalDuration")

---
-- Sets whether a @{Player} is spectating the own ragdoll
-- @param boolean s
-- @realm server
function plymeta:SetRagdollSpec(s)
	if s then
		self.spec_ragdoll_start = CurTime()
	end

	self.spec_ragdoll = s
end

---
-- Returns whether a @{Player} is spectating the own ragdoll
-- @return boolean
-- @realm server
function plymeta:GetRagdollSpec()
	return self.spec_ragdoll
end

---
-- Sets a @{Player} to be a forced spectator (not just a dead terrorist)
-- @param boolean state
-- @realm server
function plymeta:SetForceSpec(state)
	self.force_spec = state -- compatibility with other addons

	self:SetNWBool("force_spec", state)
end

-- Karma

---
-- The base/start karma is determined once per round and determines the @{Player}'s
-- damage penalty. It is networked and shown on clients.
-- @param number k
-- @realm server
function plymeta:SetBaseKarma(k)
	self:SetNWFloat("karma", k)
end

---
-- @accessor number The live karma starts equal to the base karma, but is updated "live" as the
-- player damages/kills others. When another player damages/kills this one, the
-- live karma is used to determine his karma penalty.
-- @realm server
AccessorFunc(plymeta, "live_karma", "LiveKarma", FORCE_NUMBER)

---
-- @accessor number The damage factor scales how much damage the player deals, so if it is .9
-- then the player only deals 90% of his original damage.
-- @realm server
AccessorFunc(plymeta, "dmg_factor", "DamageFactor", FORCE_NUMBER)

---
-- @accessor boolean If a player does not damage team members in a round, he has a "clean" round
-- and gets a bonus for it.
-- @realm server
AccessorFunc(plymeta, "clean_round", "CleanRound", FORCE_BOOL)

---
-- Initializes the KARMA for the given @{Player}
-- @realm server
function plymeta:InitKarma()
	KARMA.InitPlayer(self)
end

-- Equipment credits

---
-- Sets the amount of credits
-- @param number amt
-- @realm server
function plymeta:SetCredits(amt)
	self.equipment_credits = amt

	self:SendCredits()
end

---
-- Adds an amount of credits
-- @param number amt
-- @realm server
function plymeta:AddCredits(amt)
	self:SetCredits(self:GetCredits() + amt)
end

---
-- Removes an amount of credits
-- @param number amt
-- @realm server
function plymeta:SubtractCredits(amt)
	local tmp = self:GetCredits() - amt
	if tmp < 0 then
		tmp = 0
	end

	self:SetCredits(tmp)
end

---
-- Sets the default amount of credits
-- @realm server
function plymeta:SetDefaultCredits()
	---
	-- @realm server
	if hook.Run("TTT2SetDefaultCredits", self) then return end

	if not self:IsShopper() then
		self:SetCredits(0)

		return
	end

	local rd = self:GetSubRoleData()
	local name = rd.index == ROLE_TRAITOR and "ttt_credits_starting" or "ttt_" .. rd.abbr .. "_credits_starting"

	if self:GetTeam() ~= TEAM_TRAITOR then
		self:SetCredits(math.ceil(ConVarExists(name) and GetConVar(name):GetFloat() or 0))

		return
	end

	local c = ConVarExists(name) and GetConVar(name):GetFloat() or 0
	local member_one = #roles.GetTeamMembers(TEAM_TRAITOR) == 1

	if not rd.preventTraitorAloneCredits and member_one then
		c = c + (ConVarExists("ttt_credits_alonebonus") and GetConVar("ttt_credits_alonebonus"):GetFloat() or 0)
	end

	---
	-- @realm server
	self:SetCredits(math.ceil(hook.Run("TTT2ModifyDefaultTraitorCredits", self, c) or c))
end

---
-- Synces the amount of credits with the @{Player}
-- @realm server
function plymeta:SendCredits()
	net.Start("TTT_Credits")
	net.WriteUInt(self:GetCredits(), 8)
	net.Send(self)
end

-- Equipment items

---
-- Gives a specific @{ITEM} (if possible)
-- @param string cls
-- @return ITEM|nil
-- @realm server
-- @internal
function plymeta:AddEquipmentItem(cls)
	local item = items.GetStored(cls)

	if not item or item.limited and self:HasEquipmentItem(cls) then return end

	self.equipmentItems = self.equipmentItems or {}
	self.equipmentItems[#self.equipmentItems + 1] = cls

	item:Equip(self)

	self:SendEquipment()

	return item
end

---
-- Removes a specific @{ITEM}
-- @param string cls
-- @realm server
function plymeta:RemoveEquipmentItem(cls)
	if not self:HasEquipmentItem(cls) then return end

	local item = items.GetStored(cls)

	if item and isfunction(item.Reset) then
		item:Reset(self)
	end

	local equipItems = self:GetEquipmentItems()

	for k = 1, #equipItems do
		if equipItems[k] == cls then
			table.remove(self.equipmentItems, k)

			break
		end
	end

	self:SendEquipment()
end

---
-- Removes a specific @{Weapon}
-- @param string cls
-- @realm server
plymeta.RemoveEquipmentWeapon = plymeta.StripWeapon

---
-- Synces the server stored equipment with the @{Player}
-- @note We do this instead of an NW var in order to limit the info to just this ply
-- @realm server
function plymeta:SendEquipment()
	local arr = self:GetEquipmentItems()

	net.Start("TTT_Equipment")
	net.WriteUInt(#arr, 16)

	for i = 1, #arr do
		net.WriteString(arr[i])
	end

	net.Send(self)
end

---
-- Resets the equipment of a @{Player}
-- @realm server
function plymeta:ResetEquipment()
	local equipItems = self:GetEquipmentItems()

	for i = 1, #equipItems do
		local item = items.GetStored(equipItems[i])

		if item and isfunction(item.Reset) then
			item:Reset(self)
		end
	end

	self.equipmentItems = {}

	self:SendEquipment()
end

---
-- Sends the list of bought @{ITEM}s and @{Weapon}s to the @{Player}
-- @realm server
function plymeta:SendBought()
	local bought = self.bought

	-- Send all as string, even though equipment are numbers, for simplicity
	net.Start("TTT_Bought")
	net.WriteUInt(#bought, 8)

	for i = 1, #bought do
		net.WriteString(bought[i])
	end

	net.Send(self)
end

local function ttt_resend_bought(ply)
	if not IsValid(ply) then return end

	ply:SendBought()
end
concommand.Add("ttt_resend_bought", ttt_resend_bought)

---
-- Resets the bought list of a @{Player}
-- @realm server
function plymeta:ResetBought()
	self.bought = {}

	self:SendBought()
end

---
-- Adds an @{ITEM} or a @{Weapon} into the bought list of a @{Player}
-- @note This will disable another purchase of the same equipment
-- if this equipment is limited
-- @param string cls
-- @realm server
-- @see Player:RemoveBought
function plymeta:AddBought(cls)
	self.bought = self.bought or {}
	self.bought[#self.bought + 1] = tostring(cls)

	BUYTABLE[cls] = true

	net.Start("TTT2ReceiveGBEq")
	net.WriteString(cls)
	net.Broadcast()

	local team = self:GetTeam()

	if team and team ~= TEAM_NONE and not TEAMS[team].alone then
		TEAMBUYTABLE[team] = TEAMBUYTABLE[team] or {}
		TEAMBUYTABLE[team][cls] = true

		if SERVER then
			net.Start("TTT2ReceiveTBEq")
			net.WriteString(cls)
			net.Send(GetTeamFilter(team))
		end
	end

	self:SendBought()
end

---
-- Removes an @{ITEM} or a @{Weapon} from the bought list of a @{Player}
-- @note This will enable another purchase of the same equipment
-- if this equipment is limited
-- @param string cls
-- @realm server
-- @see Player:AddBought
function plymeta:RemoveBought(cls)
	local key

	self.bought = self.bought or {}

	for k = 1, #self.bought do
		if self.bought[k] ~= tostring(cls) then continue end

		key = k

		break
	end

	if key then
		table.remove(self.bought, key)

		self:SendBought()
	end
end

---
-- Strips player of all equipment
-- @realm server
function plymeta:StripAll()
	-- standard stuff
	self:StripAmmo()
	self:StripWeapons()

	-- our stuff
	self:ResetEquipment()
	self:SetCredits(0)
end

---
-- Sets all flags (force_spec, etc) to their default
-- @realm server
function plymeta:ResetStatus()
	self:SetRole(ROLE_NONE) -- this will update the team automatically
	self:SetRagdollSpec(false)
	self:SetForceSpec(false)
	self:ResetRoundFlags()
end

---
-- Sets round-based misc flags to default position. Called at PlayerSpawn.
-- @realm server
function plymeta:ResetRoundFlags()
	self:ResetEquipment()
	self:SetCredits(0)
	self:ResetBought()

	-- equipment stuff
	self.bomb_wire = nil
	self.radar_charge = 0
	self.decoy = nil

	timer.Remove("give_equipment" .. self:UniqueID())

	-- corpse
	self:TTT2NETSetBool("body_found", false)

	self.kills = {}
	self.dying_wep = nil
	self.was_headshot = false

	-- communication
	self.mute_team = -1

	local winTms = roles.GetWinTeams()

	for i = 1, #winTms do
		self[winTms[i] .. "_gvoice"] = false
	end

	self:SetNWBool("disguised", false)

	-- karma
	self:SetCleanRound(true)
	self:Freeze(false)

	-- armor
	self:ResetArmor()
end

---
-- Give a @{Weapon} to a @{Player}.
-- @note If the initial attempt fails due to heisenbugs in
-- the map, keep trying until the @{Player} has moved to a better spot where it
-- does work.
-- @param string cls @{Weapon}'s class
-- @param function callback Will be called if weapon was given successfully,
-- takes the @{Player}, cls and created @{Weapon} as parameters, can be nil
-- @realm server
function plymeta:GiveEquipmentWeapon(cls, callback)
	if not cls then return end

	if not self:CanCarryWeapon(weapons.GetStored(cls)) then return end

	-- Referring to players by SteamID64 because a player may disconnect while his
	-- unique timer still runs, in which case we want to be able to stop it. For
	-- that we need its name, and hence his SteamID64.
	local tmr = "give_equipment" .. self:UniqueID()

	if not IsValid(self) or not self:Alive() then
		timer.Remove(tmr)

		return
	end

	-- giving attempt, will fail if we're in a crazy spot in the map or perhaps
	-- other glitchy cases
	local w = self:Give(cls)

	if not IsValid(w) or not self:HasWeapon(cls) then
		if not timer.Exists(tmr) then
			local slf = self

			timer.Create(tmr, 1, 0, function()
				if not IsValid(slf) then return end

				slf:GiveEquipmentWeapon(cls, callback)
			end)
		end

		-- we will be retrying
	else
		-- can stop retrying, if we were
		timer.Remove(tmr)

		if isfunction(callback) then
			-- basically a delayed/asynchronous return, necessary due to the timers
			callback(self, cls, w)
		end
	end
end

---
-- Gives an @{ITEM} to a @{Player} and returns whether it was successful
-- @param string cls
-- @return ITEM|nil
-- @realm server
function plymeta:GiveEquipmentItem(cls)
	if not cls then return end

	local item = items.GetStored(cls)

	if not item or item.limited and self:HasEquipmentItem(cls) then
		return
	end

	return self:AddEquipmentItem(cls)
end

---
-- Forced specs and latejoin specs should not get points
-- @return boolean
-- @realm server
function plymeta:ShouldScore()
	if self:GetForceSpec() then
		return false
	elseif self:IsSpec() and self:Alive() then
		return false
	else
		return true
	end
end

---
-- Adds a kill into the kill list
-- @param Player victim
-- @realm server
function plymeta:RecordKill(victim)
	if not IsValid(victim) then return end

	self.kills = self.kills or {}
	self.kills[#self.kills + 1] = victim:SteamID64()
end

---
-- This is doing nothing, it's just a function to avoid incompatibility
-- @note Please remove this call and use the TTTPlayerSpeedModifier hook in both CLIENT and SERVER states
-- @param any slowed
-- @deprecated
-- @realm server
function plymeta:SetSpeed(slowed)
	error "Player:SetSpeed(slowed) is deprecated - please remove this call and use the TTTPlayerSpeedModifier hook in both CLIENT and SERVER states"
end

---
-- Resets the last words
-- @realm server
function plymeta:ResetLastWords()
	--if not IsValid(self) then return end -- timers are dangerous things

	self.last_words_id = nil
end

---
-- Sends the last words based on the DamageInfo
-- @param DamageInfo dmginfo
-- @realm server
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
		if not IsValid(ply) then return end

		ply:ResetLastWords()
	end)
end

---
-- Resets the view
-- @realm server
function plymeta:ResetViewRoll()
	local ang = self:EyeAngles()

	if ang.r == 0 then return end

	ang.r = 0

	self:SetEyeAngles(ang)
end

---
-- Checks whether a @{Player} is able to spawn
-- @return boolean
-- @realm server
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

---
-- Preps a player for a new round, spawning them if they should
-- @param boolean dead_only If dead_only is
-- true, only spawns if player is dead, else just makes sure he is healed.
-- @return boolean
-- @realm server
function plymeta:SpawnForRound(dead_only)
	---
	-- @realm server
	hook.Run("PlayerSetModel", self)

	---
	-- @realm server
	hook.Run("TTTPlayerSetColor", self)

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

---
-- This is called on the first spawn to set the default vars
-- @realm server
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

	self:ResetStatus()

	-- Always reset sprint
	self.sprintProgress = 1

	-- Start off with clean, full karma (unless it can and should be loaded)
	self:InitKarma()

	-- We never have weapons here, but this inits our equipment state
	self:StripAll()
end

---
-- Kicks and bans a player
-- @param number length time of the ban
-- @param string reason
-- @realm server
function plymeta:KickBan(length, reason)
	-- see admin.lua
	PerformKickBan(self, length, reason)
end

local oldSpectate = plymeta.Spectate

---
-- Forces a @{Player} to the spectation modus
-- @param number type
-- @realm server
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

---
-- Forces a @{Player} to spectate an @{Entity}
-- @param Entity ent
-- @realm server
function plymeta:SpectateEntity(ent)
	oldSpectateEntity(self, ent)

	if IsValid(ent) and ent:IsPlayer() then
		self:SetupHands(ent)
	end
end

local oldUnSpectate = plymeta.UnSpectate

---
-- Unspectates a @{Player}
-- @realm server
function plymeta:UnSpectate()
	oldUnSpectate(self)

	self:SetNoTarget(false)
end

---
-- Returns whether a @{Player} has disabled the selection of a given @{ROLE}
-- @param number role subrole id of a @{ROLE}
-- @return boolean
-- @realm server
function plymeta:GetAvoidRole(role)
	return self:GetInfoNum("ttt_avoid_" .. roles.GetByIndex(role).name, 0) > 0
end

---
-- Returns whether a @{Player} has disabled the selection of the detective role
-- @note This gives compatibility for some legacy ttt addons
-- @return boolean
-- @realm server
-- @deprecated
function plymeta:GetAvoidDetective()
	return self:GetAvoidRole(ROLE_DETECTIVE)
end

---
-- Returns whether a @{Player} is able to select a specific @{ROLE}
-- @param ROLE roleData
-- @param number choice_count
-- @param number role_count
-- @return boolean
-- @realm server
function plymeta:CanSelectRole(roleData, choice_count, role_count)
	local min_karmas = ConVarExists("ttt_" .. roleData.name .. "_karma_min") and GetConVar("ttt_" .. roleData.name .. "_karma_min"):GetInt() or 0

	return (
		choice_count <= role_count
		or self:GetBaseKarma() > min_karmas and GAMEMODE.LastRole[self:SteamID64()] == ROLE_INNOCENT
		or math.random(3) == 2
	) and (choice_count <= role_count or not self:GetAvoidRole(roleData.index))
end

---
-- Function taken from Trouble in Terrorist Town Commands (https://github.com/bender180/Trouble-in-Terrorist-Town-ULX-Commands)
-- @realm server
function plymeta:FindCorpse()
	local ragdolls = ents.FindByClass("prop_ragdoll")

	for i = 1, #ragdolls do
		local ent = ragdolls[i]

		if ent.uqid == self:UniqueID() and IsValid(ent) then
			return ent or false
		end
	end
end

-- Handles all stuff needed if the revival failed
local function OnReviveFailed(ply, failMessage)
	if isfunction(ply.OnReviveFailedCallback) then
		ply.OnReviveFailedCallback(ply, failMessage)

		ply.OnReviveFailedCallback = nil
	else
		LANG.Msg(ply, failMessage, nil, MSG_MSTACK_WARN)
	end

	net.Start("TTT2RevivalStopped")
	net.Send(ply)
end

---
-- Revives a @{Player}
-- @param[default=3] number delay The delay of the revive
-- @param[opt] function OnRevive The @{function} that should be run if the @{Player} revives
-- @param[opt] function DoCheck An additional checking @{function}
-- @param[default=false] boolean needsCorpse Whether the dead @{Player} @{CORPSE} is needed
-- @param[default=false] boolean blockRound Stops the round from ending if this is set to true until the player is alive again
-- @param[opt] function OnFail This @{function} is called if the revive fails
-- @param[opt] Vector spawnPos The position where the player should be spawned, accounts for minor obstacles
-- @param[opt] Angle spawnEyeAngle The eye angles of the revived players
-- @realm server
function plymeta:Revive(delay, OnRevive, DoCheck, needsCorpse, blockRound, OnFail, spawnPos, spawnEyeAngle)
	if self:IsReviving() then return end

	local name = "TTT2RevivePlayer" .. self:EntIndex()

	delay = delay or 3

	self:SetReviving(true)
	self:SetBlockingRevival(blockRound)
	self:SetRevivalStartTime(CurTime())
	self:SetRevivalDuration(delay)

	self.OnReviveFailedCallback = OnFail

	timer.Create(name, delay, 1, function()
		if not IsValid(self) then return end

		self:SetReviving(false)
		self:SetBlockingRevival(false)
		self:SendRevivalReason(nil)

		if not isfunction(DoCheck) or DoCheck(self) then
			local corpse = self:FindCorpse()

			if needsCorpse and (not IsValid(corpse) or corpse:IsOnFire()) then
				OnReviveFailed(self, "message_revival_failed_missing_body")

				return
			end

			self:SetMaxHealth(100)
			self:SetHealth(100)

			self:SpawnForRound(true)

			if not spawnPos and IsValid(corpse) then
				spawnPos = corpse:GetPos()
				spawnEyeAngle = Angle(0, corpse:GetAngles().y, 0)
			end

			spawnPos = spawnPos or self:GetDeathPosition()
			spawnPos = spawn.MakeSpawnPointSafe(self, spawnPos)

			if not spawnPos then
				local spawnEntity = spawn.GetRandomPlayerSpawnEntity(self)

				spawnPos = spawnEntity:GetPos()
				spawnEyeAngle = spawnEntity:EyeAngles()
			end

			self:SetPos(spawnPos)
			self:SetEyeAngles(spawnEyeAngle or Angle(0, 0, 0))

			---
			-- @realm server
			hook.Run("PlayerLoadout", self, true)

			self:SetCredits(CORPSE.GetCredits(corpse, 0))
			self:SelectWeapon("weapon_zm_improvised")

			if IsValid(corpse) then
				corpse:Remove()
			end

			DamageLog("TTT2Revive: " .. self:Nick() .. " has been respawned.")

			if isfunction(OnRevive) then
				OnRevive(self)
			end
		else
			OnReviveFailed(self, "message_revival_failed")
		end

		self.OnReviveFailedCallback = nil
	end)
end

---
-- Cancel the ongoing revival process.
-- @param[default="message_revival_canceled"] string failMessage The fail message that should be displayed for the client
-- @param[opt] boolean silent If silent is true, no sound and text will be displayed
-- @realm server
function plymeta:CancelRevival(failMessage, silent)
	if not self:IsReviving() then return end

	self:SetReviving(false)
	self:SetBlockingRevival(false)
	self:SendRevivalReason(nil)

	timer.Remove("TTT2RevivePlayer" .. self:EntIndex())

	if silent then return end

	OnReviveFailed(self, failMessage or "message_revival_canceled")
end


---
-- Sets the revival state.
-- @param[default=false] boolean isReviving The reviving state
-- @internal
-- @realm server
function plymeta:SetReviving(isReviving)
	isReviving = isReviving or false

	if self.isReviving == isReviving then return end

	self.isReviving = isReviving

	net.Start("TTT2RevivalUpdate_IsReviving")
	net.WriteBool(self.isReviving)
	net.Send(self)
end

---
-- Sets the blocking revival state.
-- @param[default=false] boolean isBlockingRevival The blocking revival state
-- @internal
-- @realm server
function plymeta:SetBlockingRevival(isBlockingRevival)
	isBlockingRevival = isBlockingRevival or false

	if self.isBlockingRevival == isBlockingRevival then return end

	self.isBlockingRevival = isBlockingRevival

	net.Start("TTT2RevivalUpdate_IsBlockingRevival")
	net.WriteBool(self.isBlockingRevival)
	net.Send(self)
end

---
-- Sets the revival start time.
-- @param[default=@{CurTime()}] number startTime The revival start time
-- @internal
-- @realm server
function plymeta:SetRevivalStartTime(startTime)
	startTime = startTime or CurTime()

	if self.revivalStartTime == startTime then return end

	self.revivalStartTime = startTime

	net.Start("TTT2RevivalUpdate_RevivalStartTime")
	net.WriteFloat(self.revivalStartTime)
	net.Send(self)
end

---
-- Sets the revival duration.
-- @param[default=0.0] number duration The revival time
-- @internal
-- @realm server
function plymeta:SetRevivalDuration(duration)
	duration = duration or 0.0

	if self.revivalDurarion == duration then return end

	self.revivalDurarion = duration

	net.Start("TTT2RevivalUpdate_RevivalDuration")
	net.WriteFloat(self.revivalDurarion)
	net.Send(self)
end

---
-- Sends a revival reason that is displayed in the clients revival HUD element.
-- It supports a language identifier for translated strings.
-- @param[default=nil] string name The text or the language identifer, nil to reset
-- @param[opt] table params The params table used for @{LANG.GetParamTranslation}
-- @realm server
function plymeta:SendRevivalReason(name, params)
	net.Start("TTT2SetRevivalReason")

	if name then
		net.WriteBool(false)
		net.WriteString(name)

		local paramsAmount = params and table.Count(params) or 0

		net.WriteUInt(paramsAmount, 8)

		if paramsAmount > 0 then
			for k, v in pairs(params) do
				net.WriteString(k)
				net.WriteString(tostring(v))
			end
		end
	else
		net.WriteBool(true)
	end

	net.Send(self)
end


---
-- Sets the last death position.
-- @param Vector pos The death position
-- @internal
-- @realm server
function plymeta:SetLastDeathPosition(pos)
	self.lastDeathPosition = pos
end

---
-- Sets the last spawn position.
-- @param Vector pos The spawn position
-- @internal
-- @realm server
function plymeta:SetLastSpawnPosition(pos)
	self.lastSpawnPosition = pos
end

---
-- Returns the last death position of the player.
-- @return Vector The last death position
-- @realm server
function plymeta:GetDeathPosition()
	return self.lastDeathPosition
end

---
-- Returns the last spawn position of the player.
-- @return Vector The last spawn position
-- @realm server
function plymeta:GetSpawnPosition()
	return self.lastSpawnPosition
end

---
-- Sets the if a player was active (TEAM_TERROR) in a round.
-- @param boolean state The state
-- @internal
-- @realm server
function plymeta:SetActiveInRound(state)
	self:TTT2NETSetBool("player_was_active_in_round", state or false)
end

---
-- Increases the player death counter.
-- @internal
-- @realm server
function plymeta:IncreaseRoundDeathCounter()
	self:TTT2NETSetUInt("player_round_deaths", self:GetDeathsInRound() + 1, 8)
end

---
-- Resets the player death counter.
-- @internal
-- @realm server
function plymeta:ResetRoundDeathCounter()
	self:TTT2NETSetUInt("player_round_deaths", 0, 8)
end

---
-- Selects a random available @{ROLE} for a @{Player}
-- @param table avoidRoles list of @{ROLE}s that should be avoided
-- @realm server
function plymeta:SelectRandomRole(avoidRoles)
	local availablePlayers = roleselection.GetSelectablePlayers(player.GetAll())
	local allAvailableRoles = roleselection.GetAllSelectableRolesList(#availablePlayers)
	local selectableRoles = roleselection.GetSelectableRoles(#availablePlayers, allAvailableRoles)

	local availableRoles = {}
	local roleCount = {}

	for i = 1, #availablePlayers do
		local rd = availablePlayers[i]:GetSubRoleData()

		roleCount[rd] = (roleCount[rd] or 0) + 1
	end

	for roleData, roleAmount in pairs(selectableRoles) do
		if (not avoidRoles or not avoidRoles[roleData]) and (not roleCount[roleData] or roleCount[roleData] < roleAmount) then
			availableRoles[#availableRoles + 1] = roleData.index
		end
	end

	if #availableRoles < 1 then return end

	self:SetRole(availableRoles[math.random(#availableRoles)])

	SendFullStateUpdate()
end

local pendingItems = {}

---
-- Gives an @{ITEM} to a @{Player}
-- @param string cls
-- @realm server
function plymeta:GiveItem(cls)
	if GetRoundState() == ROUND_PREP then
		pendingItems[self] = pendingItems[self] or {}
		pendingItems[self][#pendingItems[self] + 1] = cls

		return
	end

	self:GiveEquipmentItem(cls)
	self:AddBought(cls)

	local item = items.GetStored(cls)
	if item and isfunction(item.Bought) then
		item:Bought(self)
	end

	local ply = self

	timer.Simple(0.5, function()
		if not IsValid(ply) then return end

		net.Start("TTT_BoughtItem")
		net.WriteString(cls)
		net.Send(ply)
	end)
end

---
-- Removes an @{ITEM} from a @{Player}
-- @param string cls
-- @realm server
function plymeta:RemoveItem(cls)
	self:RemoveEquipmentItem(cls)
	self:RemoveBought(cls)
end

---
-- Removes a @{Weapon} from a @{Player}
-- @param string cls
-- @realm server
function plymeta:RemoveWeapon(cls)
	self:RemoveEquipmentWeapon(cls)
	self:RemoveBought(cls)
end

---
-- Update player corpse state
-- @param[opt] boolean announceRole
-- @realm server
function plymeta:ConfirmPlayer(announceRole)
	if self:GetNWFloat("t_first_found", -1) < 0 then
		self:TTT2NETSetFloat("t_first_found", CurTime())
	end

	self:TTT2NETSetFloat("t_last_found", CurTime())

	if announceRole then
		self:TTT2NETSetBool("role_found", true)
	end

	self:TTT2NETSetBool("body_found", true)
end

---
-- Resets the confirmation of a @{Player}
-- @realm server
function plymeta:ResetConfirmPlayer()
	-- body_found is reset on the player reset
	self:TTT2NETSetBool("role_found", false)
	self:TTT2NETSetFloat("t_first_found", -1)
	self:TTT2NETSetFloat("t_last_found", -1)
end

---
-- On the server, we just send the client a message that the player is
-- performing a gesture. This allows the client to decide whether it should
-- play, depending on eg. a cvar.
-- @param ACT act The @{ACT} or sequence that should be played
-- @realm server
function plymeta:AnimPerformGesture(act)
	if not act then return end

	net.Start("TTT_PerformGesture")
	net.WriteEntity(self)
	net.WriteUInt(act, 16)
	net.Broadcast()
end

-- TODO REMOVE THIS

hook.Add("TTTBeginRound", "TTT2GivePendingItems", function()
	for ply, tbl in pairs(pendingItems) do
		if not IsValid(ply) then continue end

		local plyGiveItem = ply.GiveItem

		for i = 1, #tbl do
			plyGiveItem(ply, tbl[i])
		end
	end

	pendingItems = {}
end)

-- reset confirm state only on round begin, not on revive
hook.Add("TTTBeginRound", "TTT2ResetRoleState_Begin", function()
	local plys = player.GetAll()

	for i = 1, #plys do
		plys[i]:ResetConfirmPlayer()
	end
end)

-- additionally reset confirm state on round prepare to prevent short blinking of confirmed roles on round start
hook.Add("TTTPrepareRound", "TTT2ResetRoleState_End", function()
	local plys = player.GetAll()

	for i = 1, #plys do
		plys[i]:ResetConfirmPlayer()
	end
end)

local plymeta_old_Give = plymeta.Give

-- The give function is cached to extend it later on.
-- The extension is needed to set a flag prior to picking up weapons.
-- This flag is used to distinguish between weapons picked up by walking
-- over them and weapons picked up by ply:Give()
-- @param string weaponClassName
-- @param boolean bNoAmmo
-- @return Weapon
-- @realm server
function plymeta:Give(weaponClassName, bNoAmmo)
	self.forcedPickup = true

	local wep = plymeta_old_Give(self, weaponClassName, bNoAmmo or false)

	self.forcedPickup = false

	return wep
end

---
-- Checks if the weapon can be dropped in a safely manner.
-- @param Weapon wep The weapon that should be dropped
-- @return boolean Returns if this weapon can be dropped
-- @realm server
function plymeta:CanSafeDropWeapon(wep)
	if not IsValid(wep) or not wep.AllowDrop then
		return false
	end

	local tr = util.QuickTrace(self:GetShootPos(), self:GetAimVector() * 32, self)

	if tr.Hit then
		LANG.Msg(self, "drop_no_room", nil, MSG_MSTACK_WARN)

		return false
	end

	return true
end

---
-- Called to drop a weapon in a safe manner (e.g. preparing and space-check).
-- @param Weapon wep The weapon that should be dropped
-- @param boolean keepSelection If set to true the current selection is kept if not dropped
-- @realm server
function plymeta:SafeDropWeapon(wep, keepSelection)
	if not self:CanSafeDropWeapon(wep) then return end

	self:AnimPerformGesture(ACT_GMOD_GESTURE_ITEM_PLACE)

	WEPS.DropNotifiedWeapon(self, wep, false, keepSelection)
end

---
-- Returns whether or not a player can pick up a weapon
-- @param Weapon wep The weapon object
-- @param nil|boolean forcePickup is there a forced pickup to ignore the cv_auto_pickup cvar?
-- @param nil|boolean dropBlockingWeapon should the weapon stored in the same slot be dropped
-- @return boolean return of the PlayerCanPickupWeapon hook
-- @return number errorCode that appeared. For the error, give a look into the specific hook
-- @realm server
function plymeta:CanPickupWeapon(wep, forcePickup, dropBlockingWeapon)
	self.forcedPickup = forcePickup

	---
	-- @realm server
	local ret, errCode = hook.Run("PlayerCanPickupWeapon", self, wep, dropBlockingWeapon)

	self.forcedPickup = false

	return ret, errCode
end

---
-- Returns whether or not a player can pick up a weapon
-- @param string wepCls The weapon object classname
-- @param nil|boolean forcePickup is there a forced pickup to ignore the cv_auto_pickup cvar?
-- @param nil|boolean dropBlockingWeapon should the weapon stored in the same slot be dropped
-- @return boolean
-- @realm server
function plymeta:CanPickupWeaponClass(wepCls, forcePickup, dropBlockingWeapon)
	local wep = ents.Create(wepCls)

	return self:CanPickupWeapon(wep, forcePickup, dropBlockingWeapon)
end

---
-- This function simplifies the weapon pickup process for a player by
-- handling all the needed calls.
-- @param Weapon wep The weapon object
-- @param nil|boolean ammoOnly If set to true, the player will only attempt to pick up the ammo from the weapon. The weapon will not be picked up even if the player doesn't have a weapon of this type, and the weapon will be removed if the player picks up any ammo from it
-- @param nil|boolean forcePickup Should the pickup been forced (ignores the cv_auto_pickup cvar)
-- @param[default=false] nil|boolean dropBlockingWeapon Should the currently selecten weapon be dropped
-- @param nil|boolean shouldAutoSelect Should this weapon be autoselected after equip, if not set this value is set by player keypress
-- @return Weapon if successful, nil if not
-- @realm server
function plymeta:SafePickupWeapon(wep, ammoOnly, forcePickup, dropBlockingWeapon, shouldAutoSelect)
	if not IsValid(wep) then
		ErrorNoHalt(tostring(self) .. " tried to pickup an invalid weapon " .. tostring(wep) .. "\n")

		LANG.Msg(self, "pickup_fail")

		return
	end

	-- block weapon switch if slot is occupied and there is no room to
	-- drop the weapon safely
	if not InventorySlotFree(self, wep.Kind) and not self:CanSafeDropWeapon(wep) then return end

	local ret, errCode = self:CanPickupWeapon(wep, forcePickup or true, dropBlockingWeapon)

	if not ret then
		if errCode == 1 then
			LANG.Msg(self, "pickup_error_spec")
		elseif errCode == 2 then
			LANG.Msg(self, "pickup_error_owns")
		elseif errCode == 3 then
			LANG.Msg(self, "pickup_error_noslot")
		end

		return
	end

	-- if the variable is not set, set it fitting to the keypress
	if shouldAutoSelect == nil then
		shouldAutoSelect = not self:KeyDown(IN_WALK) and not self:KeyDownLast(IN_WALK)
	end

	-- if parameter is set the currently blocking weapon should be dropped
	if dropBlockingWeapon ~= false then
		local dropWeapon, isActiveWeapon, switchMode = GetBlockingWeapon(self, wep)

		if switchMode == SWITCHMODE_FULLINV then
			LANG.Msg(self, "pickup_no_room")

			return
		end

		-- Very very rarely happens but definitely breaks the weapon and should be avoided at all costs
		if dropWeapon == wep then return end

		timer.Simple(0, function()
			if not IsValid(self) or not IsValid(dropWeapon) then return end

			self:SafeDropWeapon(dropWeapon, true)
		end)

		-- set flag to new weapon that is used to autoselect it later on
		shouldAutoSelect = shouldAutoSelect or isActiveWeapon

		-- set to holstered if current weapon is dropped to prevent short crowbar selection
		if isActiveWeapon then
			self:SelectWeapon("weapon_ttt_unarmed")
		end
	end

	if not self:PickupWeapon(wep, ammoOnly or false) then return end

	wep.wpickup_autoSelect = shouldAutoSelect

	return wep
end

---
-- This function simplifies the weapon class giving process for a player by
-- handling all the needed calls.
-- @param string wepCls The weapon class
-- @param[default=false] boolean dropBlockingWeapon Should the currently selecten weapon be dropped
-- @param boolean shouldAutoSelect Should this weapon be autoselected after equip, if not set this value is set by player keypress
-- @return Weapon if successful, nil if not
-- @realm server
function plymeta:SafePickupWeaponClass(wepCls, dropBlockingWeapon, shouldAutoSelect)
	-- if the variable is not set, set it fitting to the keypress
	if shouldAutoSelect == nil then
		shouldAutoSelect = not self:KeyDown(IN_WALK) and not self:KeyDownLast(IN_WALK)
	end

	local wep = weapons.GetStored(wepCls)
	local pWep

	-- if parameter is set the currently blocking weapon should be dropped
	if dropBlockingWeapon then
		local dropWeapon, isActiveWeapon, switchMode = GetBlockingWeapon(self, wep)

		if switchMode == SWITCHMODE_FULLINV or switchMode == SWITCHMODE_NOSPACE then return end

		self:SafeDropWeapon(dropWeapon, true)

		pWep = self:Give(wepCls)

		if IsValid(pWep) then
			-- set flag to new weapon that is used to autoselect it later on
			pWep.wpickup_autoSelect = shouldAutoSelect or isActiveWeapon
		end
	end

	return pWep
end

-- receives the PlayerReady flag from the client and calls the serverwide hook
local function SetPlayerReady(_, ply)
	if not IsValid(ply) then return end

	ply.isReady = true

	-- Send full state update to client
	ttt2net.SendFullStateUpdate(ply)

	---
	-- @realm server
	hook.Run("TTT2PlayerReady", ply)
end
net.Receive("TTT2SetPlayerReady", SetPlayerReady)
