---
-- @module Player
-- @desc serverside extensions to player table

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
-- @function plymeta:GetLiveKarma()
-- @desc The live karma starts equal to the base karma, but is updated "live" as the
-- player damages/kills others. When another player damages/kills this one, the
-- live karma is used to determine his karma penalty.
-- @return number
-- @realm server
-- @see plymeta:SetLiveKarma
---
-- @function plymeta:SetLiveKarma(live_karma)
-- @desc The live karma starts equal to the base karma, but is updated "live" as the
-- player damages/kills others. When another player damages/kills this one, the
-- live karma is used to determine his karma penalty.
-- @param number live_karma
-- @realm server
-- @see plymeta:GetLiveKarma
AccessorFunc(plymeta, "live_karma", "LiveKarma", FORCE_NUMBER)

---
-- @function plymeta:GetDamageFactor()
-- @desc The damage factor scales how much damage the player deals, so if it is .9
-- then the player only deals 90% of his original damage.
-- @return number
-- @realm server
-- @see plymeta:SetDamageFactor
---
-- @function plymeta:SetDamageFactor(dmg_factor)
-- @desc The damage factor scales how much damage the player deals, so if it is .9
-- then the player only deals 90% of his original damage.
-- @param number dmg_factor
-- @realm server
-- @see plymeta:GetDamageFactor
AccessorFunc(plymeta, "dmg_factor", "DamageFactor", FORCE_NUMBER)

---
-- @function plymeta:GetCleanRound()
-- @desc If a player does not damage team members in a round, he has a "clean" round
-- and gets a bonus for it.
-- @return boolean
-- @realm server
-- @see plymeta:SetCleanRound
---
-- @function plymeta:SetCleanRound(clean_round)
-- @desc If a player does not damage team members in a round, he has a "clean" round
-- and gets a bonus for it.
-- @param boolean clean_round
-- @realm server
-- @see plymeta:GetCleanRound
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
	if hook.Run("TTT2SetDefaultCredits", self) then return end

	if not self:IsShopper() then
		self:SetCredits(0)

		return
	end

	local rd = self:GetSubRoleData()
	local name = rd.index == ROLE_TRAITOR and "ttt_credits_starting" or "ttt_" .. rd.abbr .. "_credits_starting"

	if not self:HasTeam(TEAM_TRAITOR) then
		self:SetCredits(math.ceil(ConVarExists(name) and GetConVar(name):GetFloat() or 0))

		return
	end

	local c = ConVarExists(name) and GetConVar(name):GetFloat() or 0
	local member_one = #roles.GetTeamMembers(TEAM_TRAITOR) == 1

	if not rd.preventTraitorAloneCredits and member_one then
		c = c + (ConVarExists("ttt_credits_alonebonus") and GetConVar("ttt_credits_alonebonus"):GetFloat() or 0)
	end

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
-- @return @{ITEM} or nil
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
-- @see plymeta:RemoveBought
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
-- @see plymeta:AddBought
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
	self:SetRole(ROLE_INNOCENT) -- this will update the team automatically
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
	self:SetNWBool("body_found", false)

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
-- @return @{ITEM} or nil
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
-- @param CTakeDamageInfo dmginfo
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
-- realm shared
function plymeta:SpawnForRound(dead_only)
	hook.Call("PlayerSetModel", GAMEMODE, self)
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

	-- Always spawn innocent initially, traitor will be selected later
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

--
-- Function taken from Trouble in Terrorist Town Commands (https://github.com/bender180/Trouble-in-Terrorist-Town-ULX-Commands)
--
local function FindCorpse(ply)
	local ragdolls = ents.FindByClass("prop_ragdoll")

	for i = 1, #ragdolls do
		local ent = ragdolls[i]

		if ent.uqid == ply:UniqueID() and IsValid(ent) then
			return ent or false
		end
	end
end

local poss = {}

-- Populate Around Player
for i = 0, 360, 22.5 do
	poss[#poss + 1] = Vector(math.cos(i), math.sin(i), 0)
end

poss[#poss + 1] = Vector(0, 0, 1) -- Populate Above Player

local function FindCorpsePosition(corpse)
	local size = Vector(32, 32, 72)
	local startPos = corpse:GetPos() + Vector(0, 0, size.z * 0.5)
	local len = #poss

	for i = 1, len do
		local v = poss[i]
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

---
-- Revives a @{Player}
-- @param number delay the delay of the revive
-- @param function fn the @{function} that should be run if the @{Player} revives
-- @param function check an additional checking @{function}
-- @param boolean needcorpse whether the dead @{Player} CORPSE is needed
-- @param boolean force if the @{Player} revive is already forced. Useful if you have multiple reviving equipments
-- @param function onFail this @{function} is called if the revive fails
-- @realm server
function plymeta:Revive(delay, fn, check, needcorpse, force, onFail)
	local ply = self
	local name = "TTT2RevivePlayer" .. ply:EntIndex()

	if timer.Exists(name) or ply.reviving then return end

	if force then
		ply.forceRevive = true
	end

	ply.reviving = true

	timer.Create(name, delay, 1, function()
		if not IsValid(ply) then return end

		ply.forceRevive = nil
		ply.reviving = nil

		if not isfunction(check) or check(ply) then
			local corpse = FindCorpse(ply)

			if needcorpse and (not IsValid(corpse) or corpse:IsOnFire()) then
				ply:ChatPrint("You have not been revived because your body no longer exists.")

				timer.Remove(name) -- TODO needed?

				return
			end

			ply:SpawnForRound(true)

			if IsValid(corpse) then
				local spawnPos = FindCorpsePosition(corpse)
				if spawnPos then
					ply:SetPos(spawnPos)
					ply:SetEyeAngles(Angle(0, corpse:GetAngles().y, 0))
				end
			end

			hook.Call("PlayerLoadout", GAMEMODE, ply)

			ply:SetMaxHealth(100)

			local credits = CORPSE.GetCredits(corpse, 0)

			ply:SetCredits(credits)

			if IsValid(corpse) then
				corpse:Remove()
			end

			DamageLog("TTT2Revive: " .. ply:Nick() .. " has been respawned.")

			if isfunction(fn) then
				fn(ply)
			end
		elseif isfunction(onFail) then
			ply:ChatPrint("Revive failed...")

			onFail(ply)
		end
	end)
end

---
-- Selects a random available @{ROLE} for a @{Player}
-- @param table avoidRoles list of @{ROLE}s that should be avoided
-- @realm server
function plymeta:SelectRandomRole(avoidRoles)
	local selectableRoles = GetSelectableRoles()
	local availableRoles = {}
	local roleCount = {}
	local plys = player.GetAll()

	for i = 1, #plys do
		local rd = plys[i]:GetSubRoleData()

		roleCount[rd] = (roleCount[rd] or 0) + 1
	end

	for v, c in pairs(selectableRoles) do
		if (not avoidRoles or not avoidRoles[v]) and (not roleCount[v] or roleCount[v] > c) then
			availableRoles[#availableRoles + 1] = v.index
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
		self:SetNWFloat("t_first_found", CurTime())
	end

	self:SetNWFloat("t_last_found", CurTime())

	if announceRole then
		self:SetNWBool("role_found", true)
	end

	self:SetNWBool("body_found", true)
end

---
-- Resets the confirmation of a @{Player}
-- @realm server
function plymeta:ResetConfirmPlayer()
	-- body_found is reset on the player reset
	self:SetNWBool("role_found", false)

	self:SetNWFloat("t_first_found", -1)
	self:SetNWFloat("t_last_found", -1)
end

---
-- On the server, we just send the client a message that the player is
-- performing a gesture. This allows the client to decide whether it should
-- play, depending on eg. a cvar.
-- @param ACT[https://wiki.garrysmod.com/page/Enums/ACT] act The activity (ACT) or sequence that should be played
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

-- additionally reset confirm state on round end to prevent short blinking of confirmed roles on round start
hook.Add("TTTEndRound", "TTT2ResetRoleState_End", function()
	local plys = player.GetAll()

	for i = 1, #plys do
		plys[i]:ResetConfirmPlayer()
	end
end)

-- The give function is cached to extend it later on.
-- The extension is needed to set a flag prior to picking up weapons.
-- This flag is used to distinguish between weapons picked up by walking
-- over them and weapons picked up by ply:Give()
local plymeta_old_give = plymeta.Give
function plymeta:Give(weaponClassName, bNoAmmo)
	self.wp__GiveItemFunctionFlag = true

	local wep = plymeta_old_give(self, weaponClassName, bNoAmmo or false)

	-- the flag has to be reset on the outside of the hook since returning
	-- false somewhere prevents GM:PlayerCanPickupWeapon from being executed
	self.wp__GiveItemFunctionFlag = nil

	return wep
end

---
-- Called to drop a weapon in a safe manner (e.g. preparing and space-check)
-- @param Weapon wep
-- @realm server
function plymeta:SafeDropWeapon(wep, keep_selection)
	if not IsValid(wep) or not wep.AllowDrop then return end

	local tr = util.QuickTrace(self:GetShootPos(), self:GetAimVector() * 32, self)

	if tr.HitWorld then
		LANG.Msg(self, "drop_no_room", nil, MSG_CHAT_WARN)

		return
	end

	self:AnimPerformGesture(ACT_GMOD_GESTURE_ITEM_PLACE)

	WEPS.DropNotifiedWeapon(self, wep, false, keep_selection)
end

---
-- Returns whether or not a player can pick up a weapon
-- @param Weapon wep The weapon object
-- @returns boolean
-- @realm server
function plymeta:CanPickupWeapon(wep)
	self.wp__GiveItemFunctionFlag = true

	local can_pickup = hook.Run("PlayerCanPickupWeapon", self, wep)

	-- the flag has to be reset on the outside of the hook since returning
	-- false somewhere prevents GM:PlayerCanPickupWeapon from being executed
	self.wp__GiveItemFunctionFlag = nil

	return can_pickup
end

---
-- Returns whether or not a player can pick up a weapon
-- @param string wepCls The weapon object classname
-- @returns boolean
-- @realm server
function plymeta:CanPickupWeaponClass(wepCls)
	local wep = ents.Create(wepCls)

	return self:CanPickupWeapon(wep)
end

-- Since we all love GMOD we do some really funny things here. Sometimes the weapon is in
-- a position where a player is unable to pick it up, even if there is nothing that hinders
-- it from being picked up. Therefore we randomise the position a bit.
local function SetWeaponPos(ply, wep, kind)
	if not IsValid(ply) or not IsValid(wep) or not kind or not ply.wpickup_waitequip[kind] then return end

	-- if a pickup is possible, the weapon gets a flag set and is teleported to the feet
	-- of the player
	-- IMPORTANT: If the weapon gets teleported into other entities, it gets stuck. Therefore
	-- the weapon is teleported to half player height
	local pWepPos = ply:EyePos()
	pWepPos.z = pWepPos.z - 20 -- -20 to move it outside the viewing area

	-- randomise position
	pWepPos.x = pWepPos.x + math.random(-10, 10)
	pWepPos.y = pWepPos.y + math.random(-10, 10)
	pWepPos.z = pWepPos.z + math.random(-10, 10)

	wep:SetPos(pWepPos)
end

local function ActualWeaponPickup(ply, wep, kind, shouldAutoSelect)
	if not IsValid(ply) or not IsValid(wep) or not kind or not ply.wpickup_waitequip[kind] then return end

	-- this flag is set to the player to make sure he only picks up this weapon
	ply.wpickup_weapon = wep

	-- the flag is set to the weapon to stop other players from auto-picking up this weapon
	wep.wpickup_player = ply

	-- destroy physics to let weapon float in the air
	wep:PhysicsDestroy()

	-- set collision group to IN_VEHICLE to be nonexistent, bullets can pass through it
	wep:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

	-- make weapon invisible to prevent stuck weapon in player sight
	wep:SetNoDraw(true)

	-- set autoselect flag
	wep.wpickup_autoSelect = shouldAutoSelect

	-- initial teleport the weapon to the player pos
	SetWeaponPos(ply, wep, kind)

	wep.name_timer_pos = kind .. "_WeaponPickupRandomPos_" .. ply:SteamID64()
	wep.name_timer_cancel = kind .. "_WeaponPickupCancel_" .. ply:SteamID64()

	-- update the weapon pos
	timer.Create(wep.name_timer_pos, 0.2, 1, function()
		SetWeaponPos(ply, wep, kind)
	end)

	-- after 1.5 seconds, the pickup should be canceled
	timer.Create(wep.name_timer_cancel, 1.5, 1, function()
		ResetWeapon(wep)
	end)
end

---
-- This function simplifies the weapon pickup process for a player by
-- handling all the needed calls.
-- @param Weapon wep The weapon object
-- @param [default=false] boolean dropBlockingWeapon Should the currently selecten weapon be dropped
-- @param boolean shouldAutoSelect Should this weapon be autoselected after equip, if not set this value is set by player keypress
-- @returns Weapon if successful, nil if not
-- @realm server
function plymeta:PickupWeapon(wep, dropBlockingWeapon, shouldAutoSelect)
	local kind = wep.Kind
	self.wpickup_waitequip = self.wpickup_waitequip or {}

	-- If the player has picked up a weapon, but not yet received it, ignore this request
	-- to prevent GMod from making the weapon unusable and behaving weird
	if self.wpickup_waitequip[kind] then
		LANG.Msg(self, "pickup_pending")

		return
	end

	-- if the variable is not set, set it fitting to the keypress
	if shouldAutoSelect == nil then
		shouldAutoSelect = not self:KeyDown(IN_WALK) and not self:KeyDownLast(IN_WALK)
	end

	if not IsValid(wep) then
		ErrorNoHalt(tostring(self) .. " tried to pickup an invalid weapon " .. tostring(wep) .. "\n")
		LANG.Msg(self, "pickup_fail")

		return
	end

	-- if this weapon is already flagged by a different player, the pickup shouldn't happen
	if wep.wpickup_player then return end

	-- Now comes the tricky part: Since Gmod doesn't allow us to pick up weapons by
	-- calling a simple function while also keeping all the weapon specific params
	-- set in the runtime, we have to use the GM:PlayerCanPickupWeapon hook in a
	-- slightly hacky way

	-- first we have to check if the player can pick up the weapon at all by running the
	-- hook manually. This has to be done since the normal pickup is handled internally
	-- and is therefore not accessable for us
	wep.wp__WeaponSwitchFlag = dropBlockingWeapon

	local canPickupWeapon = self:CanPickupWeapon(wep)

	-- the flag has to be reset on the outside of the hook since returning
	-- false somewhere prevents GM:PlayerCanPickupWeapon from being executed
	wep.wp__WeaponSwitchFlag = nil

	if not canPickupWeapon then
		LANG.Msg(self, "pickup_no_room")

		return
	end

	-- if parameter is set the currently blocking weapon should be dropped
	if dropBlockingWeapon then
		local dropWeapon, isActiveWeapon, switchMode = GetBlockingWeapon(self, wep)

		if switchMode == SWITCHMODE_FULLINV then
			LANG.Msg(self, "pickup_no_room")

			return
		end

		-- Very very rarely happens but definitely breaks the weapon and should be avoided at all costs
		if dropWeapon == wep then return end

		self:SafeDropWeapon(dropWeapon, true)

		-- set flag to new weapon that is used to autoselect it later on
		shouldAutoSelect = shouldAutoSelect or isActiveWeapon

		-- set to holstered if current weapon is dropped to prevent short crowbar selection
		if isActiveWeapon then
			self:SelectWeapon("weapon_ttt_unarmed")
		end
	end

	-- prevent race conditions
	self.wpickup_waitequip[kind] = true

	timer.Create(kind .. "_WeaponPickup_" .. self:SteamID64(), 0, 1, function()
		ActualWeaponPickup(self, wep, kind, shouldAutoSelect)
	end)

	return wep
end

---
-- This function simplifies the weapon class giving process for a player by
-- handling all the needed calls.
-- @param string wepCls The weapon class
-- @param [default=false] boolean dropBlockingWeapon Should the currently selecten weapon be dropped
-- @param boolean shouldAutoSelect Should this weapon be autoselected after equip, if not set this value is set by player keypress
-- @returns Weapon if successful, nil if not
-- @realm server
function plymeta:PickupWeaponClass(wepCls, dropBlockingWeapon, shouldAutoSelect)
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

		-- set flag to new weapon that is used to autoselect it later on
		pWep.wpickup_autoSelect = shouldAutoSelect or isActiveWeapon
	end

	return pWep
end

-- receives the PlayerReady flag from the client and calls the serverwide hook
local function SetPlayerReady(_, ply)
	if not IsValid(ply) then return end

	ply.is_ready = true

	TTT2NET:SendFullStateUpdate(ply)

	hook.Run("TTT2PlayerReady", ply)
end
net.Receive("TTT2SetPlayerReady", SetPlayerReady)
