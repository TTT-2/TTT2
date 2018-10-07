---- Customized scoring

local math = math
local string = string
local table = table
local pairs = pairs
local ipairs = ipairs

SCORE = SCORE or {}
SCORE.Events = SCORE.Events or {}

-- One might wonder why all the key names in the event tables are so annoyingly
-- short. Well, the serialisation module in gmod (glon) does not do any
-- compression. At all. This means the difference between all events having a
-- "time_added" key versus a "t" key is very significant for the amount of data
-- we need to send. It's a pain, but I'm not going to code my own compression,
-- so doing it manually is the only way.

-- One decent way to reduce data sent turned out to be rounding the time floats.
-- We don't actually need to know about 10000ths of seconds after all.

function SCORE:AddEvent(entry, t_override)
	entry["t"] = math.Round(t_override or CurTime(), 2)

	table.insert(self.Events, entry)
end

local function CopyDmg(dmg)
	local wep = util.WeaponFromDamage(dmg)

	-- t = type, a = amount, g = gun, h = headshot
	local d = {}

	-- util.TableToJSON doesn't handle large integers properly
	d.t = tostring(dmg:GetDamageType())
	d.a = dmg:GetDamage()
	d.h = false

	if wep then
		local id = WepToEnum(wep)
		if id then
			d.g = id
		else
			-- we can convert each standard TTT weapon name to a preset ID, but
			-- that's not workable with custom SWEPs from people, so we'll just
			-- have to pay the byte tax there
			d.g = wep:GetClass()
		end
	else
		local infl = dmg:GetInflictor()

		if IsValid(infl) and infl.ScoreName then
			d.n = infl.ScoreName
		end
	end

	return d
end

function SCORE:HandleKill(victim, attacker, dmginfo)
	if not IsValid(victim) or not victim:IsPlayer() then return end

	local e = {
		id = EVENT_KILL,
		att = {ni = "", sid = -1, r = -1, t = ""},
		vic = {
			ni = victim:Nick(),
			sid = victim:SteamID(),
			r = victim:GetSubRole(),
			t = victim:GetTeam()
		},
		dmg = CopyDmg(dmginfo)
	}

	e.dmg.h = victim.was_headshot

	if IsValid(attacker) and attacker:IsPlayer() then
		e.att.ni = attacker:Nick()
		e.att.sid = attacker:SteamID()
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

function SCORE:HandleSpawn(ply)
	if ply:Team() == TEAM_TERROR then
		self:AddEvent({id = EVENT_SPAWN, ni = ply:Nick(), sid = ply:SteamID()})
	end
end

function SCORE:HandleSelection()
	local tmp = {}
	local teams = {}
	local subrole, team

	for _, ply in ipairs(player.GetAll()) do
		subrole = ply:GetSubRole()
		team = ply:GetTeam()

		if subrole ~= ROLE_INNOCENT then -- no innos
			tmp[subrole] = tmp[subrole] or {}
			teams[team] = teams[team] or {}

			table.insert(tmp[subrole], ply:SteamID())
			table.insert(teams[team], ply:SteamID())
		end
	end

	self:AddEvent({id = EVENT_SELECTED, rt = tmp, tms = teams})
end

function SCORE:HandleBodyFound(finder, found)
	self:AddEvent({id = EVENT_BODYFOUND, ni = finder:Nick(), sid = finder:SteamID(), r = finder:GetBaseRole(), t = finder:GetTeam(), b = found:Nick()})
end

function SCORE:HandleC4Explosion(planter, arm_time, exp_time)
	local nick = "Someone"

	if IsValid(planter) and planter:IsPlayer() then
		nick = planter:Nick()
	end

	self:AddEvent({id = EVENT_C4PLANT, ni = nick}, arm_time)
	self:AddEvent({id = EVENT_C4EXPLODE, ni = nick}, exp_time)
end

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

function SCORE:HandleCreditFound(finder, found_nick, credits)
	self:AddEvent({id = EVENT_CREDITFOUND, ni = finder:Nick(), sid = finder:SteamID(), b = found_nick, cr = credits})
end

function SCORE:ApplyEventLogScores(wintype)
	local scores = {}

	for _, ply in ipairs(player.GetAll()) do
		scores[ply:SteamID()] = {}
	end

	-- individual scores, and count those left alive
	local scored_log = ScoreEventLog(self.Events, scores)
	local bonus = ScoreTeamBonus(scored_log, wintype)
	local ply

	for sid, s in pairs(scored_log) do
		ply = player.GetBySteamID(sid)

		if ply and ply:ShouldScore() then
			ply:AddFrags(KillsToPoints(s))
			ply:AddFrags(bonus[sid])
			victim:AddDeaths(s.deaths)
		end
	end
end

function SCORE:RoundStateChange(newstate)
	self:AddEvent({id = EVENT_GAME, state = newstate})
end

function SCORE:RoundComplete(wintype)
	self:AddEvent({id = EVENT_FINISH, win = wintype})
end

function SCORE:Reset()
	self.Events = {}
end

local function _sortfunc(a, b)
	if not b or not a then
		return false
	end

	return a.t and b.t and a.t < b.t
end

local function SortEvents(events)
	-- sort events on time
	table.sort(events, _sortfunc)

	return events
end

local function EncodeForStream(events)
	events = SortEvents(events)

	-- may want to filter out data later
	-- just serialize for now

	local result = util.TableToJSON(events)
	if not result then
		ErrorNoHalt("Round report event encoding failed!\n")

		return false
	else
		return result
	end
end

function SCORE:StreamToClients()
	local s = EncodeForStream(self.Events)
	if not s then return end -- error occurred

	-- divide into happy lil bits.
	-- this was necessary with user messages, now it's
	-- a just-in-case thing if a round somehow manages to be > 64K
	local cut = {}
	local max = 65500

	while #s ~= 0 do
		local bit = string.sub(s, 1, max - 1)

		table.insert(cut, bit)

		s = string.sub(s, max, -1)
	end

	local parts = #cut

	for k, bit in ipairs(cut) do
		net.Start("TTT_ReportStream")
		net.WriteBit(k ~= parts) -- continuation bit, 1 if there's more coming
		net.WriteString(bit)
		net.Broadcast()
	end
end
