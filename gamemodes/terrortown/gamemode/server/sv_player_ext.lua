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
-- @param string id
-- @realm server
-- @internal
function plymeta:AddEquipmentItem(id)
	local item = items.GetStored(id)

	if not item or item.limited and self:HasEquipmentItem(id) then return end

	self.equipmentItems = self.equipmentItems or {}
	self.equipmentItems[#self.equipmentItems + 1] = id

	item:Equip(self)

	self:SendEquipment()
end

---
-- Removes a specific @{ITEM}
-- @param string id
-- @realm server
function plymeta:RemoveEquipmentItem(id)
	if not self:HasEquipmentItem(id) then return end

	local item = items.GetStored(id)

	if item and isfunction(item.Reset) then
		item:Reset(self)
	end

	local equipItems = self:GetEquipmentItems()

	for k = 1, #equipItems do
		if equipItems[k] == id then
			table.remove(self.equipmentItems, k)

			break
		end
	end

	self:SendEquipment()
end

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
-- @param string id
-- @realm server
-- @see plymeta:RemoveBought
function plymeta:AddBought(id)
	self.bought = self.bought or {}
	self.bought[#self.bought + 1] = tostring(id)

	BUYTABLE[id] = true

	net.Start("TTT2ReceiveGBEq")
	net.WriteString(id)
	net.Broadcast()

	local team = self:GetTeam()

	if team and team ~= TEAM_NONE and not TEAMS[team].alone then
		TEAMBUYTABLE[team] = TEAMBUYTABLE[team] or {}
		TEAMBUYTABLE[team][id] = true

		if SERVER then
			net.Start("TTT2ReceiveTBEq")
			net.WriteString(id)
			net.Send(GetTeamFilter(team))
		end
	end

	self:SendBought()
end

---
-- Removes an @{ITEM} or a @{Weapon} from the bought list of a @{Player}
-- @note This will enable another purchase of the same equipment
-- if this equipment is limited
-- @param string id
-- @realm server
-- @see plymeta:AddBought
function plymeta:RemoveBought(id)
	local key

	self.bought = self.bought or {}

	for k = 1, #self.bought do
		if self.bought[k] ~= tostring(id) then continue end

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

	-- corpse
	self:SetNWBool("body_found", false) -- TODO just for compatibility

	-- networking
	-- TODO reset bodyFound, lastFound etc. manually to save networking capacity (seperately)
	self:SetNWLibBool("bodyFound", false)
	self:SetNWLibBool("roleFound", false)
	self:SetNWLibUInt("firstFound", 0)
	self:SetNWLibUInt("lastFound", 0)

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
-- @realm server
function plymeta:GiveEquipmentWeapon(cls)
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

				slf:GiveEquipmentWeapon(cls)
			end)
		end

		-- we will be retrying
	else
		-- can stop retrying, if we were
		timer.Remove(tmr)

		if w.WasBought then
			-- some weapons give extra ammo after being bought, etc
			w:WasBought(self)
		end
	end
end

---
-- Gives an @{ITEM} to a @{Player} and returns whether it was successful
-- @param string id
-- @return boolean success?
-- @realm server
function plymeta:GiveEquipmentItem(id)
	if not id then return end

	local item = items.GetStored(id)

	if not item or item.limited and self:HasEquipmentItem(id) then
		return false
	end

	self:AddEquipmentItem(id)

	return true
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
-- @param string id
-- @realm server
function plymeta:GiveItem(id)
	if GetRoundState() == ROUND_PREP then
		pendingItems[self] = pendingItems[self] or {}
		pendingItems[self][#pendingItems[self] + 1] = id

		return
	end

	self:GiveEquipmentItem(id)
	self:AddBought(id)

	local item = items.GetStored(id)
	if item and isfunction(item.Bought) then
		item:Bought(self)
	end

	local ply = self

	timer.Simple(0.5, function()
		if not IsValid(ply) then return end

		net.Start("TTT_BoughtItem")
		net.WriteString(id)
		net.Send(ply)
	end)

	hook.Run("TTTOrderedEquipment", self, id, items.IsItem(id) and id or false)
end

---
-- Removes an @{ITEM} from a @{Player}
-- @param string id
-- @realm server
function plymeta:RemoveItem(id)
	self:RemoveEquipmentItem(id)
	self:RemoveBought(id)
end

-- TODO REMOVE THIS

hook.Add("TTTBeginRound", "TTT2GivePendingItems", function()
	for ply, tbl in pairs(pendingItems) do
		if not IsValid(ply) then continue end

		local plyGiveItem = ply.GiveItem

		for i = 1, #tbl do
			plyGiveItem(tbl[i])
		end
	end

	pendingItems = {}
end)
