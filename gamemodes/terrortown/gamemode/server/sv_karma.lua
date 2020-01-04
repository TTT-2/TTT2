---
-- @module KARMA
-- @desc Karma system stuff

KARMA = {}

-- ply steamid -> karma table for disconnected players who might reconnect
KARMA.RememberedPlayers = {}

-- Convars, more convenient access than GetConVar
KARMA.cv = {}
KARMA.cv.enabled = CreateConVar("ttt_karma", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
KARMA.cv.strict = CreateConVar("ttt_karma_strict", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
KARMA.cv.starting = CreateConVar("ttt_karma_starting", "1000", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
KARMA.cv.max = CreateConVar("ttt_karma_max", "1000", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
KARMA.cv.ratio = CreateConVar("ttt_karma_ratio", "0.001", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
KARMA.cv.killpenalty = CreateConVar("ttt_karma_kill_penalty", "15", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
KARMA.cv.roundheal = CreateConVar("ttt_karma_round_increment", "5", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
KARMA.cv.clean = CreateConVar("ttt_karma_clean_bonus", "30", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
KARMA.cv.tbonus = CreateConVar("ttt_karma_traitorkill_bonus", "40", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
KARMA.cv.tratio = CreateConVar("ttt_karma_traitordmg_ratio", "0.0003", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
KARMA.cv.debug = CreateConVar("ttt_karma_debugspam", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

KARMA.cv.persist = CreateConVar("ttt_karma_persist", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
KARMA.cv.falloff = CreateConVar("ttt_karma_clean_half", "0.25", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

KARMA.cv.autokick = CreateConVar("ttt_karma_low_autokick", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
KARMA.cv.kicklevel = CreateConVar("ttt_karma_low_amount", "450", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
KARMA.cv.autoban = CreateConVar("ttt_karma_low_ban", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
KARMA.cv.bantime = CreateConVar("ttt_karma_low_ban_minutes", "60", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

local config = KARMA.cv

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
-- @realm server
function KARMA.GivePenalty(ply, penalty, victim)
	if not hook.Call("TTTKarmaGivePenalty", nil, ply, penalty, victim) then
		ply:SetLiveKarma(math.max(ply:GetLiveKarma() - penalty, 0))
	end
end

---
-- Gives a @{Player} a KARMA reward
-- @param Player ply
-- @param number reward
-- @return number reward modified / reward
-- @realm server
function KARMA.GiveReward(ply, reward)
	reward = KARMA.DecayedMultiplier(ply) * reward

	ply:SetLiveKarma(math.min(ply:GetLiveKarma() + reward, config.max:GetFloat()))

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
-- @param CTakeDamageInfo dmginfo
-- @realm server
function KARMA.Hurt(attacker, victim, dmginfo)
	if attacker == victim or not IsValid(attacker) or not IsValid(victim) or not attacker:IsPlayer() or not victim:IsPlayer() or dmginfo:GetDamage() <= 0 then return end

	-- Ignore excess damage
	local hurt_amount = math.min(victim:Health(), dmginfo:GetDamage())

	-- team kills another team
	if not attacker:IsInTeam(victim) then
		if attacker:GetSubRoleData().unknownTeam then
			local reward = KARMA.GetHurtReward(hurt_amount)

			reward = KARMA.GiveReward(attacker, reward)

			print(Format("%s (%f) hurt %s (%f) and gets REWARDED %f", attacker:Nick(), attacker:GetLiveKarma(), victim:Nick(), victim:GetLiveKarma(), reward))
		end
	else -- team kills own team
		if not victim:GetCleanRound() then return end

		local multiplicator = WasAvoidable(attacker, victim, dmginfo)
		local penalty = KARMA.GetHurtPenalty(victim:GetLiveKarma(), hurt_amount) * multiplicator

		KARMA.GivePenalty(attacker, penalty, victim)

		attacker:SetCleanRound(false)

		print(Format("%s (%f) hurt %s (%f) and gets penalised for %f", attacker:Nick(), attacker:GetLiveKarma(), victim:Nick(), victim:GetLiveKarma(), penalty))
	end
end

---
-- Handle karma change due to one player killing another.
-- @param Player attacker
-- @param Player victim
-- @param CTakeDamageInfo dmginfo
-- @realm server
function KARMA.Killed(attacker, victim, dmginfo)
	if attacker == victim or not IsValid(attacker) or not IsValid(victim) or not victim:IsPlayer() or not attacker:IsPlayer() then return end

	if not attacker:IsInTeam(victim) then -- team kills another team
		if attacker:GetSubRoleData().unknownTeam then
			local reward = KARMA.GetKillReward()

			reward = KARMA.GiveReward(attacker, reward)

			print(Format("%s (%f) killed %s (%f) and gets REWARDED %f", attacker:Nick(), attacker:GetLiveKarma(), victim:Nick(), victim:GetLiveKarma(), reward))
		end
	else -- team kills own team
		if not victim:GetCleanRound() then return end

		local multiplicator = WasAvoidable(attacker, victim, dmginfo)
		local penalty = KARMA.GetKillPenalty(victim:GetLiveKarma()) * multiplicator

		KARMA.GivePenalty(attacker, penalty, victim)

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
			local bonus = healbonus + (ply:GetCleanRound() and cleanbonus or 0)

			KARMA.GiveReward(ply, bonus)

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
	KARMA.RememberedPlayers[ply:SteamID64()] = ply:GetLiveKarma()
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

	return KARMA.RememberedPlayers[ply:SteamID64()]
end

---
-- Sets the amount of stored KARMA of a given @{Player}
-- @param Player ply
-- @realm server
function KARMA.LateRecallAndSet(ply)
	local k = tonumber(ply:GetPData("karma_stored", KARMA.RememberedPlayers[ply:SteamID64()]))
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
	if ply:GetBaseKarma() > config.kicklevel:GetInt() or hook.Call("TTTKarmaLow", GAMEMODE, ply) == false then return end

	ServerLog(ply:Nick() .. " autokicked/banned for low karma.\n")

	-- flag player as autokicked so we don't perform the normal player
	-- disconnect logic
	ply.karma_kicked = true

	if config.persist:GetBool() then
		local k = math.Clamp(config.starting:GetFloat() * 0.8, config.kicklevel:GetFloat() * 1.1, config.max:GetFloat())

		ply:SetPData("karma_stored", k)

		KARMA.RememberedPlayers[ply:SteamID64()] = k
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
