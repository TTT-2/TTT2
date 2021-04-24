---
-- Karma system stuff
-- @module KARMA

KARMA = {
	rememberedPlayers = {}, -- ply steamid -> karma table for disconnected players who might reconnect
	karmaChanges = {}, -- ply steamid -> karma table for karma changes that will get applied at roundend
	karmaChangesOld = {} -- ply steamid -> karma table for old karma changes after roundend 
}

-- Convars, more convenient access than GetConVar
KARMA.cv = {
	---
	-- @realm server
	enabled = CreateConVar("ttt_karma", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	strict = CreateConVar("ttt_karma_strict", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	starting = CreateConVar("ttt_karma_starting", "1000", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	max = CreateConVar("ttt_karma_max", "1000", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	ratio = CreateConVar("ttt_karma_ratio", "0.001", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	killpenalty = CreateConVar("ttt_karma_kill_penalty", "15", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	roundheal = CreateConVar("ttt_karma_round_increment", "5", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	clean = CreateConVar("ttt_karma_clean_bonus", "30", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	tbonus = CreateConVar("ttt_karma_traitorkill_bonus", "40", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	tratio = CreateConVar("ttt_karma_traitordmg_ratio", "0.0003", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	debug = CreateConVar("ttt_karma_debugspam", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	persist = CreateConVar("ttt_karma_persist", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	falloff = CreateConVar("ttt_karma_clean_half", "0.25", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	autokick = CreateConVar("ttt_karma_low_autokick", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	kicklevel = CreateConVar("ttt_karma_low_amount", "450", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	autoban = CreateConVar("ttt_karma_low_ban", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}),

	---
	-- @realm server
	bantime = CreateConVar("ttt_karma_low_ban_minutes", "60", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
}

local config = KARMA.cv

local KARMA_TEAMKILL = 1
local KARMA_TEAMHURT = 2
local KARMA_ENEMYKILL = 3
local KARMA_ENEMYHURT = 4
local KARMA_CLEAN = 5
local KARMA_ROUND = 6
local KARMA_UNKNOWN = 7

KARMA.reason = {
	[KARMA_TEAMKILL] = "karma_teamkill_tooltip",
	[KARMA_TEAMHURT] = "karma_teamhurt_tooltip",
	[KARMA_ENEMYKILL] = "karma_enemykill_tooltip",
	[KARMA_ENEMYHURT] = "karma_enemyhurt_tooltip",
	[KARMA_CLEAN] = "karma_cleanround_tooltip",
	[KARMA_ROUND] = "karma_roundheal_tooltip",
	[KARMA_UNKNOWN] = "karma_unknown_tooltip"
}

local IsValid = IsValid
local hook = hook

local function IsDebug()
	return config.debug:GetBool()
end

local math = math

local function ttt_karma_max(cvar, old, new)
	SetGlobalInt("ttt_karma_max", new)
end
cvars.AddChangeCallback("ttt_karma_max", ttt_karma_max)

local function ttt_karma(cvar, old, new)
	SetGlobalBool("ttt_karma", tobool(new))
end
cvars.AddChangeCallback("ttt_karma", ttt_karma)

---
-- Initializes the KARMA System
-- @realm server
-- @internal
function KARMA.InitState()
	SetGlobalBool("ttt_karma", config.enabled:GetBool())
	SetGlobalInt("ttt_karma_max", config.max:GetFloat())
end

---
-- Returns whether the KARMA System is Initialized
-- @return boolean
-- @realm server
function KARMA.IsEnabled()
	return GetGlobalBool("ttt_karma", false)
end

---
-- Allows to change the live KARMA from anywhere
-- Use this function only if you want to influence KARMA per event or similar
-- @note Reason is a string and will be displayed in the roundendscreen as tooltip, so use language localization or describe it properly
-- @param Player ply
-- @param number amount
-- @param string reason 
-- @realm server
function KARMA.DoKarmaChange(ply, amount, reason)
	ply:SetLiveKarma(math.max(math.min(ply:GetLiveKarma() + amount, config.max:GetFloat()), 0))
	KARMA.SaveKarmaChange(ply, amount, isstring(reason) and reason or KARMA.reason[KARMA_UNKNOWN])
end

---
-- Saves changes to the live KARMA
-- @param Player ply
-- @param number amount
-- @param string reason 
-- @realm server
-- @internal
function KARMA.SaveKarmaChange(ply, amount, reason)
	amount = math.Round(amount, 1)
	if amount == 0 then return end

	local sid64 = ply:SteamID64()
	KARMA.karmaChanges[sid64] = KARMA.karmaChanges[sid64] or {}
	KARMA.karmaChanges[sid64][reason] = (KARMA.karmaChanges[sid64][reason] or 0) + amount
end

---
-- Reset the changes and backups table content
-- @realm server
-- @internal
function KARMA.ResetRoundChanges()
	KARMA.karmaChangesOld = table.Copy(KARMA.karmaChanges)
	KARMA.karmaChanges = {}

	if IsDebug() then
		for sid64, reasonList in pairs(KARMA.karmaChangesOld) do
			local ply = player.GetBySteamID64(sid64)
			if IsValid(ply) then
				print("\nFor Player " .. ply:GetName())
				for reason, karma in pairs(reasonList) do
					print("An amount of " .. karma .. " was changed for the reason of " .. reason)
				end
			end
		end
	end
end

---
-- Returns table which contains all current karmachanges until next roundbegin for the given playerID
-- @param SteamID64 sid64
-- @return table containing karmachange per reason
-- @realm server
function KARMA.GetKarmaChangesBySteamID64(sid64)
	return KARMA.karmaChanges[sid64]
end

---
-- Returns table which contains all karmachanges of last round after roundbegin for the given playerID
-- @param SteamID64 sid64
-- @return table containing karmachange per reason
-- @realm server
function KARMA.GetOldKarmaChangesBySteamID64(sid64)
	return KARMA.karmaChangesOld[sid64]
end

---
-- Returns the total change in Karma of current round per player
-- @param SteamID64 sid64
-- @return number containing absolute karmachange per player
-- @realm server
function KARMA.GetAbsoluteKarmaChangeBySteamID64(sid64)
	local amount = 0
	local reasonList = KARMA.karmaChanges[sid64]
	if not reasonList then return end

	for reason, karma in pairs(reasonList) do
		amount = amount + karma
	end

	return amount
end

---
-- Returns the total change in Karma of last round per player
-- @param SteamID64 sid64
-- @return number containing absolute karmachange per player
-- @realm server
function KARMA.GetAbsoluteOldKarmaChangeBySteamID64(sid64)
	local amount = 0
	local reasonList = KARMA.karmaChangesOld[sid64]
	if not reasonList then return end

	for reason, karma in pairs(reasonList) do
		amount = amount + karma
	end

	return amount
end

---
-- Compute penalty for hurting someone a certain amount
-- @param number victim_karma
-- @param number dmg
-- @return number the amount of KARMA penalty
-- @realm server
function KARMA.GetHurtPenalty(victim_karma, dmg)
	return victim_karma * math.Clamp(dmg * config.ratio:GetFloat(), 0, 1)
end

---
-- Compute penalty for killing someone
-- @param number victim_karma
-- @return number the amount of KARMA penalty
-- @realm server
function KARMA.GetKillPenalty(victim_karma)
	-- the kill penalty handled like dealing a bit of damage
	return KARMA.GetHurtPenalty(victim_karma, config.killpenalty:GetFloat())
end

---
-- Compute reward for hurting a traitor (when innocent yourself)
-- @param number dmg
-- @return number the amount of KARMA reward
-- @realm server
function KARMA.GetHurtReward(dmg)
	return config.max:GetFloat() * math.Clamp(dmg * config.tratio:GetFloat(), 0, 1)
end

---
-- Compute reward for killing traitor
-- @return number the amount of KARMA kill reward
-- @realm server
function KARMA.GetKillReward()
	return KARMA.GetHurtReward(config.tbonus:GetFloat())
end

---
-- Gives a @{Player} a KARMA penalty
-- @param Player ply
-- @param number penalty
-- @param Player victim
-- @param string reason
-- @realm server
function KARMA.GivePenalty(ply, penalty, victim, reason)
	---
	-- @realm server
	if not hook.Run("TTTKarmaGivePenalty", ply, penalty, victim) then
		KARMA.DoKarmaChange(ply, -penalty, reason)
	end
end

---
-- Gives a @{Player} a KARMA reward
-- @param Player ply
-- @param number reward
-- @param string reason
-- @return number reward modified / reward
-- @realm server
function KARMA.GiveReward(ply, reward, reason)
	reward = KARMA.DecayedMultiplier(ply) * reward

	KARMA.DoKarmaChange(ply, reward, reason)

	return reward
end

---
-- Calculates the damage factor (a @{Player} will do in the next round) based on the KARMA
-- @param Player ply
-- @realm server
function KARMA.ApplyKarma(ply)
	local df = 1

	-- any karma at 1000 or over guarantees a df of 1, only when it's lower do we
	-- need the penalty curve
	if ply:GetBaseKarma() < 1000 then
		local k = ply:GetBaseKarma() - 1000

		if config.strict:GetBool() then
			-- this penalty curve sinks more quickly, less parabolic
			df = 1 + 0.0007 * k + -0.000002 * (k ^ 2)
		else
			df = 1 + -0.0000025 * (k ^ 2)
		end
	end

	ply:SetDamageFactor(math.Clamp(df, 0.1, 1.0))

	if IsDebug() then
		print(Format("%s has karma %f and gets df %f", ply:Nick(), ply:GetBaseKarma(), df))
	end
end

-- Return true if a traitor could have easily avoided the damage/death
local function WasAvoidable(attacker, victim, dmginfo)
	local infl = dmginfo:GetInflictor()

	if attacker:IsInTeam(victim) and IsValid(infl) and infl.Avoidable ~= false then
		---
		-- @realm server
		local ret = hook.Run("TTT2KarmaPenaltyMultiplier", attacker, victim, dmginfo)
		if ret then
			return ret
		elseif victim:GetBaseRole() == ROLE_DETECTIVE then
			return 2
		elseif not attacker:GetSubRoleData().unknownTeam then
			return 1
		else
			return 0.5
		end
	end

	return 0
end

---
-- Handle karma change due to one player damaging another. Damage must not have
-- been applied to the victim yet, but must have been scaled according to the
-- damage factor of the attacker.
-- @param Player attacker
-- @param Player victim
-- @param DamageInfo dmginfo
-- @realm server
function KARMA.Hurt(attacker, victim, dmginfo)
	if attacker == victim or not IsValid(attacker) or not IsValid(victim) or not attacker:IsPlayer() or not victim:IsPlayer() or dmginfo:GetDamage() <= 0 then return end

	-- Ignore excess damage
	local hurt_amount = math.min(victim:Health(), dmginfo:GetDamage())

	-- team kills another team
	if not attacker:IsInTeam(victim) then
		if attacker:GetSubRoleData().unknownTeam then
			local reward = KARMA.GetHurtReward(hurt_amount)

			reward = KARMA.GiveReward(attacker, reward, KARMA.reason[KARMA_ENEMYHURT])

			print(Format("%s (%f) hurt %s (%f) and gets REWARDED %f", attacker:Nick(), attacker:GetLiveKarma(), victim:Nick(), victim:GetLiveKarma(), reward))
		end
	else -- team kills own team
		if not victim:GetCleanRound() then return end

		local multiplicator = WasAvoidable(attacker, victim, dmginfo)
		local penalty = KARMA.GetHurtPenalty(victim:GetLiveKarma(), hurt_amount) * multiplicator

		KARMA.GivePenalty(attacker, penalty, victim, KARMA.reason[KARMA_TEAMHURT])

		attacker:SetCleanRound(false)

		print(Format("%s (%f) hurt %s (%f) and gets penalised for %f", attacker:Nick(), attacker:GetLiveKarma(), victim:Nick(), victim:GetLiveKarma(), penalty))
	end
end

---
-- Handle karma change due to one player killing another.
-- @param Player attacker
-- @param Player victim
-- @param DamageInfo dmginfo
-- @realm server
function KARMA.Killed(attacker, victim, dmginfo)
	if attacker == victim or not IsValid(attacker) or not IsValid(victim) or not victim:IsPlayer() or not attacker:IsPlayer() then return end

	if not attacker:IsInTeam(victim) then -- team kills another team
		if attacker:GetSubRoleData().unknownTeam then
			local reward = KARMA.GetKillReward()

			reward = KARMA.GiveReward(attacker, reward, KARMA.reason[KARMA_ENEMYKILL])

			print(Format("%s (%f) killed %s (%f) and gets REWARDED %f", attacker:Nick(), attacker:GetLiveKarma(), victim:Nick(), victim:GetLiveKarma(), reward))
		end
	else -- team kills own team
		if not victim:GetCleanRound() then return end

		local multiplicator = WasAvoidable(attacker, victim, dmginfo)
		local penalty = KARMA.GetKillPenalty(victim:GetLiveKarma()) * multiplicator

		KARMA.GivePenalty(attacker, penalty, victim, KARMA.reason[KARMA_TEAMKILL])

		attacker:SetCleanRound(false)

		print(Format("%s (%f) killed %s (%f) and gets penalised for %f", attacker:Nick(), attacker:GetLiveKarma(), victim:Nick(), victim:GetLiveKarma(), penalty))
	end
end

local expdecay = math.ExponentialDecay

---
-- Returns a multiplicator for the KARMA calculations
-- @param Player ply
-- @return number
-- @realm server
function KARMA.DecayedMultiplier(ply)
	local max = config.max:GetFloat()
	local start = config.starting:GetFloat()
	local k = ply:GetLiveKarma()

	if config.falloff:GetFloat() <= 0 or k < start then
		return 1
	elseif k < max then
		-- if falloff is enabled, then if our karma is above the starting value,
		-- our round bonus is going to start decreasing as our karma increases
		local basediff = max - start
		local plydiff = k - start
		local half = math.Clamp(config.falloff:GetFloat(), 0.01, 0.99)

		-- exponentially decay the bonus such that when the player's excess karma
		-- is at (basediff * half) the bonus is half of the original value
		return expdecay(basediff * half, plydiff)
	end

	return 1
end

---
-- Handle karma regeneration upon the start of a new round
-- @realm server
function KARMA.RoundIncrement()
	local healbonus = config.roundheal:GetFloat()
	local cleanbonus = config.clean:GetFloat()

	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		if ply:IsDeadTerror() and ply.death_type ~= KILL_SUICIDE or not ply:IsSpec() then
			KARMA.GiveReward(ply, healbonus, KARMA.reason[KARMA_ROUND])

			if ply:GetCleanRound() then
				KARMA.GiveReward(ply, cleanbonus, KARMA.reason[KARMA_CLEAN])
			end

			if IsDebug() then
				print(ply, "gets roundincr ", incr)
			end
		end
	end

	-- player's CleanRound state will be reset by the ply class
end

---
-- When a new round starts, Live karma becomes Base karma
-- @realm server
function KARMA.Rebase()
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		if IsDebug() then
			print(ply, "rebased from ", ply:GetBaseKarma(), " to ", ply:GetLiveKarma())
		end

		ply:SetBaseKarma(ply:GetLiveKarma())
	end
end

---
-- Apply karma to damage factor for all players
-- @realm server
function KARMA.ApplyKarmaAll()
	local plys = player.GetAll()

	for i = 1, #plys do
		KARMA.ApplyKarma(plys[i])
	end
end

---
-- Sends a message to a given @{Player} about the current damage factor
-- @param Player ply
-- @realm server
function KARMA.NotifyPlayer(ply)
	local df = ply:GetDamageFactor() or 1
	local k = math.Round(ply:GetBaseKarma())

	if df > 0.99 then
		LANG.Msg(ply, "karma_dmg_full", {amount = k})
	else
		LANG.Msg(ply, "karma_dmg_other", {amount = k, num = math.ceil((1 - df) * 100)})
	end
end

---
-- These generic fns will be called at round end and start, so that stuff can
-- easily be moved to a different phase
-- @realm server
function KARMA.RoundEnd()
	if KARMA.IsEnabled() then
		KARMA.RoundIncrement()

		-- if karma trend needs to be shown in round report, may want to delay
		-- rebase until start of next round
		KARMA.Rebase()
		KARMA.RememberAll()

		if config.autokick:GetBool() then
			local plys = player.GetAll()

			for i = 1, #plys do
				KARMA.CheckAutoKick(plys[i])
			end
		end
	end
end

---
-- Update / Reset the KARMA System if the round begins
-- @realm server
function KARMA.RoundBegin()
	KARMA.InitState()
	KARMA.ResetRoundChanges()

	if KARMA.IsEnabled() then
		local plys = player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			KARMA.ApplyKarma(ply)
			KARMA.NotifyPlayer(ply)
		end
	end
end

---
-- Initializes a @{Player} for the KARMA System
-- @param Player ply
-- @realm server
function KARMA.InitPlayer(ply)
	local k = math.Clamp(KARMA.Recall(ply) or config.starting:GetFloat(), 0, config.max:GetFloat())

	ply:SetBaseKarma(k)
	ply:SetLiveKarma(k)
	ply:SetCleanRound(true)
	ply:SetDamageFactor(1.0)

	-- compute the damagefactor based on actual (possibly loaded) karma
	KARMA.ApplyKarma(ply)
end

---
-- Restores the KARMA of a @{Player} if possible
-- @param Player ply
-- @realm server
function KARMA.Remember(ply)
	if ply.karma_kicked or not ply:IsFullyAuthenticated() then return end

	-- use sql if persistence is on
	if config.persist:GetBool() then
		ply:SetPData("karma_stored", ply:GetLiveKarma())
	end

	if ply:SteamID64() == nil then
		print("[TTT2] ERROR: Player has no steamID64")

		return
	end

	-- if persist is on, this is purely a backup method
	KARMA.rememberedPlayers[ply:SteamID64()] = ply:GetLiveKarma()
end

---
-- Returns the amount of stored KARMA of a given @{Player}
-- @param Player ply
-- @return number
-- @realm server
function KARMA.Recall(ply)
	if config.persist:GetBool() then
		ply.delay_karma_recall = not ply:IsFullyAuthenticated()

		if ply:IsFullyAuthenticated() then
			local k = tonumber(ply:GetPData("karma_stored", nil))
			if k then
				return k
			end
		end
	end

	return KARMA.rememberedPlayers[ply:SteamID64()]
end

---
-- Sets the amount of stored KARMA of a given @{Player}
-- @param Player ply
-- @realm server
function KARMA.LateRecallAndSet(ply)
	local k = tonumber(ply:GetPData("karma_stored", KARMA.rememberedPlayers[ply:SteamID64()]))
	if k and k < ply:GetLiveKarma() then
		ply:SetBaseKarma(k)
		ply:SetLiveKarma(k)
	end
end

---
-- Calls @{KARMA.Remember} on every @{Player}
-- @realm server
-- @see KARMA.Remember
function KARMA.RememberAll()
	local plys = player.GetAll()

	for i = 1, #plys do
		KARMA.Remember(plys[i])
	end
end

local reason = "Karma too low"

---
-- Checks and (if enabled) performs an auto kick if the KARMA is too low
-- @param Player ply
-- @realm server
function KARMA.CheckAutoKick(ply)
	---
	-- @realm server
	if ply:GetBaseKarma() > config.kicklevel:GetInt() or hook.Run("TTTKarmaLow", ply) == false then return end

	ServerLog(ply:Nick() .. " autokicked/banned for low karma.\n")

	-- flag player as autokicked so we don't perform the normal player
	-- disconnect logic
	ply.karma_kicked = true

	if config.persist:GetBool() then
		local k = math.Clamp(config.starting:GetFloat() * 0.8, config.kicklevel:GetFloat() * 1.1, config.max:GetFloat())

		ply:SetPData("karma_stored", k)

		KARMA.rememberedPlayers[ply:SteamID64()] = k
	end

	if config.autoban:GetBool() then
		ply:KickBan(config.bantime:GetInt(), reason)
	else
		ply:Kick(reason)
	end
end

---
-- Debugs / Prints all the KARMA stats of each @{Player} of the last round
-- @param function printfn
-- @realm server
function KARMA.PrintAll(printfn)
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		printfn(Format("%s : Live = %f -- Base = %f -- Dmg = %f\n",
			ply:Nick(),
			ply:GetLiveKarma(),
			ply:GetBaseKarma(),
			ply:GetDamageFactor() * 100
		))
	end
end
