---
-- @module SCORE
-- @desc Customized scoring

local table = table
local pairs = pairs
local IsValid = IsValid
local hook = hook

SCORE = SCORE or {}
SCORE.Events = SCORE.Events or {}

---
-- Adds an event to the synced event table
-- @param table entry
-- @param boolean t_override the time override
-- @realm server
function SCORE:AddEvent(entry, t_override)
	entry.t = t_override or CurTime()

	self.Events[#self.Events + 1] = entry
end

local function CopyDmg(dmg)
	local wep = util.WeaponFromDamage(dmg)
	local g, n

	if wep then
		local id = WepToEnum(wep)
		if id then
			g = id
		else
			-- we can convert each standard TTT weapon name to a preset ID, but
			-- that's not workable with custom SWEPs from people, so we'll just
			-- have to pay the byte tax there
			g = wep:GetClass()
		end
	else
		local infl = dmg:GetInflictor()

		if IsValid(infl) and infl.ScoreName then
			n = infl.ScoreName
		end
	end

	-- t = type, a = amount, g = gun, h = headshot, n = name
	return {
		t = dmg:GetDamageType(),
		a = dmg:GetDamage(),
		h = false,
		g = g,
		n = n
	}
end

---
-- Handles a kill
-- @param Player victim
-- @param Player|Entity attacker
-- @param CTakeDamageInfo dmginfo
-- @realm server
-- @internal
function SCORE:HandleKill(victim, attacker, dmginfo)
	if not IsValid(victim) or not victim:IsPlayer() then return end

	local e = {
		id = EVENT_KILL,
		att = {ni = "", sid = -1, sid64 = -1, r = -1, t = ""},
		vic = {
			ni = victim:Nick(),
			sid = victim:SteamID(),
			sid64 = victim:SteamID64(),
			r = victim:GetSubRole(),
			t = victim:GetTeam()
		},
		dmg = CopyDmg(dmginfo)
	}

	e.dmg.h = victim.was_headshot

	if IsValid(attacker) and attacker:IsPlayer() then
		e.att.ni = attacker:Nick()
		e.att.sid = attacker:SteamID()
		e.att.sid64 = attacker:SteamID64()
		e.att.r = attacker:GetSubRole()
		e.att.t = attacker:GetTeam()
	end

	hook.Run("TTT2ModifyScoringEvent", e, {
			victim = victim,
			attacker = attacker,
			dmginfo = dmginfo
	})

	if IsValid(attacker)
	and attacker:IsPlayer()
	and dmginfo:IsExplosionDamage()
	and e.att.t == TEAM_TRAITOR
	and victim:IsInTeam(attacker)
	then
		-- If a traitor gets himself killed by another traitor's C4, it's his own
		-- damn fault for ignoring the indicator.
		local infl = dmginfo:GetInflictor()

		if IsValid(infl) and infl:GetClass() == "ttt_c4" then
			e.att = table.Copy(e.vic)
		end
	end

	self:AddEvent(e)
end

---
-- Adds a spawn event to the events list
-- @param Player ply
-- @realm server
function SCORE:HandleSpawn(ply)
	if ply:Team() == TEAM_TERROR then
		self:AddEvent({
			id = EVENT_SPAWN,
			ni = ply:Nick(),
			sid = ply:SteamID(),
			sid64 = ply:SteamID64()
		})
	end
end

---
-- Handles the @{ROLE} and team selection for every @{Player}
-- @realm server
function SCORE:HandleSelection()
	local tmp = {}
	local teams = {}
	local subrole, team

	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		subrole = ply:GetSubRole()
		team = ply:GetTeam()
		tmp[subrole] = tmp[subrole] or {}

		if ply:SteamID64() == nil then
			print("[TTT2] ERROR: Player has no steamID64")

			break
		end

		tmp[subrole][#tmp[subrole] + 1] = ply:SteamID64()

		if team ~= TEAM_NONE then
			teams[team] = teams[team] or {}
			teams[team][#teams[team] + 1] = ply:SteamID64()
		end
	end

	self:AddEvent({
		id = EVENT_SELECTED,
		rt = tmp,
		tms = teams
	})
end

---
-- Handles the body-found event
-- @param Player finder
-- @param Player found
-- @realm server
function SCORE:HandleBodyFound(finder, found)
	self:AddEvent({
		id = EVENT_BODYFOUND,
		ni = finder:Nick(),
		sid = finder:SteamID(),
		sid64 = finder:SteamID64(),
		r = finder:GetBaseRole(),
		t = finder:GetTeam(),
		b = found:Nick()
	})
end

---
-- Handles a C4-explosion
-- @param Player planter
-- @param number arm_time
-- @param number exp_time
-- @realm server
function SCORE:HandleC4Explosion(planter, arm_time, exp_time)
	local nick = "Someone"

	if IsValid(planter) and planter:IsPlayer() then
		nick = planter:Nick()
	end

	self:AddEvent({
		id = EVENT_C4PLANT,
		ni = nick
	}, arm_time)

	self:AddEvent({
		id = EVENT_C4EXPLODE,
		ni = nick
	}, exp_time)
end

---
-- Handles a C4-disarm event
-- @param Player disarmer
-- @param Player owner
-- @param boolean success
-- @realm server
function SCORE:HandleC4Disarm(disarmer, owner, success)
	if disarmer == owner or not IsValid(disarmer) then return end

	local ev = {
		id = EVENT_C4DISARM,
		ni = disarmer:Nick(),
		s = success
	}

	if IsValid(owner) then
		ev.own = owner:Nick()
	end

	self:AddEvent(ev)
end

---
-- Handles the credit-found event
-- @param Player finder
-- @param string found_nick
-- @param number credits
-- @realm server
function SCORE:HandleCreditFound(finder, found_nick, credits)
	self:AddEvent({
		id = EVENT_CREDITFOUND,
		ni = finder:Nick(),
		sid = finder:SteamID(),
		sid64 = finder:SteamID64(),
		b = found_nick,
		cr = credits
	})
end

---
-- Calculates the points based on the stored events
-- @param string wintype
-- @realm server
function SCORE:ApplyEventLogScores(wintype)
	local scores = {}
	local plys = player.GetAll()
	local ply

	for i = 1, #plys do
		ply = plys[i]

		if ply:SteamID64() == nil then
			print("[TTT2] ERROR: Player has no SteamID64")
		else
			scores[ply:SteamID64()] = {}
		end
	end

	-- individual scores, and count those left alive
	local scored_log = ScoreEventLog(self.Events, scores)
	local bonus = ScoreTeamBonus(scored_log, wintype)

	for sid64, s in pairs(scored_log) do
		ply = player.GetBySteamID64(sid64)

		if IsValid(ply) and ply:ShouldScore() then
			ply:AddFrags(KillsToPoints(s))
			ply:AddFrags(bonus[sid64])
		end
	end

	-- count deaths
	local events = self.Events

	for i = 1, #events do
		local e = events[i]

		if e.id == EVENT_KILL then
			local victim = player.GetBySteamID64(e.vic.sid64)

			if IsValid(victim) and victim:ShouldScore() then
				victim:AddDeaths(1)
			end
		end
	end
end

---
-- Handles the round-state-change event
-- @param number newstate the new round state
-- @realm server
function SCORE:RoundStateChange(newstate)
	self:AddEvent({
		id = EVENT_GAME,
		state = newstate
	})
end

---
-- Handles the round-complete event
-- @param string wintype
-- @realm server
function SCORE:RoundComplete(wintype)
	self:AddEvent({
		id = EVENT_FINISH,
		win = wintype
	})
end

---
-- Resets all stored events (the events list)
-- @realm server
function SCORE:Reset()
	self.Events = {}
end

---
-- Streams the events list to all available @{Player}s
-- @realm server
function SCORE:StreamToClients()
	net.SendStream("TTT2_EventReport", self.Events)
end
