---
-- Award/highlight generator functions take the events and the scores as
-- produced by SCORING/CLSCORING and return a table if successful, or nil if
-- not and another one should be tried.
-- @module AWARDS

-- some globals we'll use a lot
local table = table
local pairs = pairs
local math = math
local util = util

-- so much text here I'm using shorter names than usual
local T = LANG.GetTranslation
local PT = LANG.GetParamTranslation

-- New award functions must be added to this to be used by CLSCORE.
-- Note that AWARDS is global. You can just go: table.insert(AWARDS, myawardfn) in your SWEPs.
AWARDS = {}

local function is_dmg(dmg_t, bit)
    -- deal with large-number workaround for TableToJSON by
    -- parsing back to number here
    return util.BitSet(tonumber(dmg_t), bit)
end

-- a common pattern
local function FindHighest(tbl)
    local m_num = 0
    local m_id

    for id, num in pairs(tbl) do
        if num > m_num then
            m_id = id
            m_num = num
        end
    end

    return m_id, m_num
end

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.FirstSuicide(events, scores, players, traitors)
    local fs
    local fnum = 0

    for _, e in pairs(events) do
        if e.id == EVENT_KILL and e.att.sid64 == e.vic.sid64 then
            fnum = fnum + 1

            if not fs then
                fs = e
            end
        end
    end

    if fs then
        local award = { nick = fs.att.ni }

        if not award.nick then
            return
        end

        if fnum > 1 then
            award.title = T("aw_sui1_title")
            award.text = T("aw_sui1_text")
        else
            award.title = T("aw_sui2_title")
            award.text = T("aw_sui2_text")
        end

        -- only high interest if many people died this way
        award.priority = fnum

        return award
    end
end
FirstSuicide = AWARDS.FirstSuicide -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.ExplosiveGrant(events, scores, players, traitors)
    local bombers = {}

    for _, e in pairs(events) do
        if e.id == EVENT_KILL and is_dmg(e.dmg.t, DMG_BLAST) then
            bombers[e.att.sid64] = (bombers[e.att.sid64] or 0) + 1
        end
    end

    local award = { title = T("aw_exp1_title") }

    if not table.IsEmpty(bombers) then
        for sid64, num in pairs(bombers) do
            -- award goes to whoever reaches this first I guess
            if num > 2 then
                award.nick = players[sid64]

                if not award.nick then
                    return
                end -- if player disconnected or something

                award.text = PT("aw_exp1_text", { num = num })

                -- rare award, high interest
                award.priority = 10 + num

                return award
            end
        end
    end
end
ExplosiveGrant = AWARDS.ExplosiveGrant -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.ExplodedSelf(events, scores, players, traitors)
    for _, e in pairs(events) do
        if e.id == EVENT_KILL and is_dmg(e.dmg.t, DMG_BLAST) and e.att.sid64 == e.vic.sid64 then
            return {
                title = T("aw_exp2_title"),
                text = T("aw_exp2_text"),
                nick = e.vic.ni,
                priority = math.random(4),
            }
        end
    end
end
ExplodedSelf = AWARDS.ExplodedSelf -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.FirstBlood(events, scores, players, traitors)
    for _, e in pairs(events) do
        if e.id == EVENT_KILL and e.att.sid64 ~= e.vic.sid64 and e.att.sid64 ~= -1 then
            local award = { nick = e.att.ni }

            if not award.nick or award.nick == "" then
                return
            end

            local vtr = e.vic.t
            local atr = e.att.t

            if atr == TEAM_TRAITOR then
                if atr ~= vtr then -- traitor legit k
                    award.title = T("aw_fst1_title")
                    award.text = T("aw_fst1_text")
                else -- traitor tk
                    award.title = T("aw_fst2_title")
                    award.text = T("aw_fst2_text")
                end
            elseif atr then
                if atr == vtr then -- inno tk
                    award.title = T("aw_fst3_title")
                    award.text = T("aw_fst3_text")
                else -- inno legit k
                    award.title = T("aw_fst4_title")
                    award.text = T("aw_fst4_text")
                end
            end

            -- more interesting if there were many players and therefore many kills
            award.priority = math.random(-3, math.Round(table.Count(players) * 0.25))

            return award
        end
    end
end
FirstBlood = AWARDS.FirstBlood -- just for compatibility

---
-- See if there is one killer responsible for all kills of either team
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.AllKills(events, scores, players, traitors)
    local killedTraitors, killedNoTraitors

    for id, s in pairs(scores) do
        for i = 1, #s.ev do
            if s.ev[i].v == TEAM_TRAITOR then
                if not killedTraitors then
                    killedTraitors = id
                elseif killedTraitors ~= id then
                    killedTraitors = nil

                    break
                end
            else
                if not killedNoTraitors then
                    killedNoTraitors = id
                elseif killedNoTraitors ~= id then
                    killedNoTraitors = nil

                    break
                end
            end
        end
    end

    if killedTraitors and not table.HasValue(traitors, killedTraitors) then
        local killer = players[killedTraitors]

        if killer then
            return {
                nick = killer,
                title = T("aw_all1_title"),
                text = T("aw_all1_text"),
                priority = math.random(table.Count(players)),
            }
        end
    end

    if killedNoTraitors and table.HasValue(traitors, killedNoTraitors) then
        local killer = players[killedNoTraitors]

        if killer then
            return {
                nick = killer,
                title = T("aw_all2_title"),
                text = T("aw_all2_text"),
                priority = math.random(table.Count(players)),
            }
        end
    end
end
AllKills = AWARDS.AllKills -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.FallDeath(events, scores, players, traitors)
    for _, e in pairs(events) do
        if e.id == EVENT_KILL and is_dmg(e.dmg.t, DMG_FALL) then
            if e.att.ni ~= "" then
                return {
                    title = T("aw_fal1_title"),
                    nick = e.att.ni,
                    text = T("aw_fal1_text"),
                    priority = math.random(7, 15),
                }
            else
                return {
                    title = T("aw_fal2_title"),
                    nick = e.vic.ni,
                    text = T("aw_fal2_text"),
                    priority = math.random(5),
                }
            end
        end
    end
end
FallDeath = AWARDS.FallDeath -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.FallKill(events, scores, players, traitors)
    for _, e in pairs(events) do
        if
            e.id == EVENT_KILL
            and is_dmg(e.dmg.t, DMG_CRUSH)
            and is_dmg(e.dmg.t, DMG_PHYSGUN)
            and e.att.ni ~= ""
        then
            return {
                title = T("aw_fal3_title"),
                nick = e.att.ni,
                text = T("aw_fal3_text"),
                priority = math.random(10, 15),
            }
        end
    end
end
FallKill = AWARDS.FallKill -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.Headshots(events, scores, players, traitors)
    local hs = {}

    for _, e in pairs(events) do
        if e.id == EVENT_KILL and e.dmg.h and is_dmg(e.dmg.t, DMG_BULLET) then
            hs[e.att.sid64] = (hs[e.att.sid64] or 0) + 1
        end
    end

    if table.IsEmpty(hs) then
        return
    end

    -- find the one with the most shots
    local m_id, m_num = FindHighest(hs)
    if not m_id then
        return
    end

    local nick = players[m_id]
    if not nick then
        return
    end

    local award = {
        nick = nick,
        priority = m_num * 0.5,
    }

    if m_num > 1 and m_num < 4 then
        award.title = T("aw_hed1_title")
        award.text = PT("aw_hed1_text", { num = m_num })
    elseif m_num >= 4 and m_num < 6 then
        award.title = T("aw_hed2_title")
        award.text = PT("aw_hed2_text", { num = m_num })
    elseif m_num >= 6 then
        award.title = T("aw_hed3_title")
        award.text = PT("aw_hed3_text", { num = m_num })
        award.priority = m_num + 5
    else
        return
    end

    return award
end
Headshots = AWARDS.Headshots -- just for compatibility

---
-- @param table events
-- @param number ammotype
-- @return table
-- @realm client
function AWARDS.UsedAmmoMost(events, ammotype)
    local user = {}

    for _, e in pairs(events) do
        if e.id == EVENT_KILL and e.dmg.g == ammotype then
            user[e.att.sid64] = (user[e.att.sid64] or 0) + 1
        end
    end

    if table.IsEmpty(user) then
        return
    end

    local m_id, m_num = FindHighest(user)

    if not m_id then
        return
    end

    return {
        sid64 = m_id,
        kills = m_num,
    }
end
UsedAmmoMost = AWARDS.UsedAmmoMost -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.CrowbarUser(events, scores, players, traitors)
    local most = UsedAmmoMost(events, AMMO_CROWBAR)

    if not most then
        return
    end

    local nick = players[most.sid64]

    if not nick then
        return
    end

    local award = {
        nick = nick,
        priority = most.kills + math.random(0, 4),
    }

    local kills = most.kills

    if kills > 1 and kills < 3 then
        award.title = T("aw_cbr1_title")
        award.text = PT("aw_cbr1_text", { num = kills })
    elseif kills >= 3 then
        award.title = T("aw_cbr2_title")
        award.text = PT("aw_cbr2_text", { num = kills })
        award.priority = kills + math.random(5, 10)
    else
        return
    end

    return award
end
CrowbarUser = AWARDS.CrowbarUser -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.PistolUser(events, scores, players, traitors)
    local most = UsedAmmoMost(events, AMMO_PISTOL)

    if not most then
        return
    end

    local nick = players[most.sid64]

    if not nick then
        return
    end

    local award = {
        nick = nick,
        priority = most.kills,
    }

    local kills = most.kills

    if kills > 1 and kills < 4 then
        award.title = T("aw_pst1_title")
        award.text = PT("aw_pst1_text", { num = kills })
    elseif kills >= 4 then
        award.title = T("aw_pst2_title")
        award.text = PT("aw_pst2_text", { num = kills })
        award.priority = award.priority + math.random(0, 5)
    else
        return
    end

    return award
end
PistolUser = AWARDS.PistolUser -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.ShotgunUser(events, scores, players, traitors)
    local most = UsedAmmoMost(events, AMMO_SHOTGUN)

    if not most then
        return
    end

    local nick = players[most.sid64]

    if not nick then
        return
    end

    local award = {
        nick = nick,
        priority = most.kills,
    }

    local kills = most.kills

    if kills > 1 and kills < 4 then
        award.title = T("aw_sgn1_title")
        award.text = PT("aw_sgn1_text", { num = kills })
        award.priority = math.Round(kills * 0.5)
    elseif kills >= 4 then
        award.title = T("aw_sgn2_title")
        award.text = PT("aw_sgn2_text", { num = kills })
    else
        return
    end

    return award
end
ShotgunUser = AWARDS.ShotgunUser -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.RifleUser(events, scores, players, traitors)
    local most = UsedAmmoMost(events, AMMO_RIFLE)

    if not most then
        return
    end

    local nick = players[most.sid64]

    if not nick then
        return
    end

    local award = {
        nick = nick,
        priority = most.kills,
    }

    local kills = most.kills

    if kills > 1 and kills < 4 then
        award.title = T("aw_rfl1_title")
        award.text = PT("aw_rfl1_text", { num = kills })
        award.priority = math.Round(kills * 0.5)
    elseif kills >= 4 then
        award.title = T("aw_rfl2_title")
        award.text = PT("aw_rfl2_text", { num = kills })
    else
        return
    end

    return award
end
RifleUser = AWARDS.RifleUser -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.RDeagleUser(events, scores, players, traitors)
    local most = UsedAmmoMost(events, AMMO_DEAGLE)

    if not most then
        return
    end

    local nick = players[most.sid64]

    if not nick then
        return
    end

    local award = {
        nick = nick,
        priority = most.kills,
    }

    local kills = most.kills

    if kills > 1 and kills < 4 then
        award.title = T("aw_dgl1_title")
        award.text = PT("aw_dgl1_text", { num = kills })
        award.priority = math.Round(kills * 0.5)
    elseif kills >= 4 then
        award.title = T("aw_dgl2_title")
        award.text = PT("aw_dgl2_text", { num = kills })
        award.priority = kills + math.random(2, 6)
    else
        return
    end

    return award
end
DeagleUser = AWARDS.DeagleUser -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.MAC10User(events, scores, players, traitors)
    local most = UsedAmmoMost(events, AMMO_MAC10)

    if not most then
        return
    end

    local nick = players[most.sid64]

    if not nick then
        return
    end

    local award = {
        nick = nick,
        priority = most.kills,
    }

    local kills = most.kills

    if kills > 1 and kills < 4 then
        award.title = T("aw_mac1_title")
        award.text = PT("aw_mac1_text", { num = kills })
        award.priority = math.Round(kills * 0.5)
    elseif kills >= 4 then
        award.title = T("aw_mac2_title")
        award.text = PT("aw_mac2_text", { num = kills })
    else
        return
    end

    return award
end
MAC10User = AWARDS.MAC10User -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.SilencedPistolUser(events, scores, players, traitors)
    local most = UsedAmmoMost(events, AMMO_SIPISTOL)

    if not most then
        return
    end

    local nick = players[most.sid64]

    if not nick then
        return
    end

    local award = {
        nick = nick,
        priority = most.kills,
    }

    local kills = most.kills

    if kills > 1 and kills < 3 then
        award.title = T("aw_sip1_title")
        award.text = PT("aw_sip1_text", { num = kills })
    elseif kills >= 3 then
        award.title = T("aw_sip2_title")
        award.text = PT("aw_sip2_text", { num = kills })
    else
        return
    end

    return award
end
SilencedPistolUser = AWARDS.SilencedPistolUser -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.KnifeUser(events, scores, players, traitors)
    local most = UsedAmmoMost(events, AMMO_KNIFE)

    if not most then
        return
    end

    local nick = players[most.sid64]

    if not nick then
        return
    end

    local award = {
        nick = nick,
        priority = most.kills,
    }

    local kills = most.kills

    if kills == 1 then
        if table.HasValue(traitors, most.sid64) then
            award.title = T("aw_knf1_title")
            award.text = PT("aw_knf1_text", { num = kills })
            award.priority = 0
        else
            award.title = T("aw_knf2_title")
            award.text = PT("aw_knf2_text", { num = kills })
            award.priority = 5
        end
    elseif kills > 1 and kills < 4 then
        award.title = T("aw_knf3_title")
        award.text = PT("aw_knf3_text", { num = kills })
    elseif kills >= 4 then
        award.title = T("aw_knf4_title")
        award.text = PT("aw_knf4_text", { num = kills })
    else
        return
    end

    return award
end
KnifeUser = AWARDS.KnifeUser -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.FlareUser(events, scores, players, traitors)
    local most = UsedAmmoMost(events, AMMO_FLARE)

    if not most then
        return
    end

    local nick = players[most.sid64]

    if not nick then
        return
    end

    local award = {
        nick = nick,
        priority = most.kills,
    }

    local kills = most.kills

    if kills > 1 and kills < 3 then
        award.title = T("aw_flg1_title")
        award.text = PT("aw_flg1_text", { num = kills })
    elseif kills >= 3 then
        award.title = T("aw_flg2_title")
        award.text = PT("aw_flg2_text", { num = kills })
    else
        return
    end

    return award
end
FlareUser = AWARDS.FlareUser -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.M249User(events, scores, players, traitors)
    local most = UsedAmmoMost(events, AMMO_M249)

    if not most then
        return
    end

    local nick = players[most.sid64]

    if not nick then
        return
    end

    local award = {
        nick = nick,
        priority = most.kills,
    }

    local kills = most.kills

    if kills > 1 and kills < 4 then
        award.title = T("aw_hug1_title")
        award.text = PT("aw_hug1_text", { num = kills })
    elseif kills >= 4 then
        award.title = T("aw_hug2_title")
        award.text = PT("aw_hug2_text", { num = kills })
    else
        return
    end

    return award
end
M249User = AWARDS.M249User -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.M16User(events, scores, players, traitors)
    local most = UsedAmmoMost(events, AMMO_M16)

    if not most then
        return
    end

    local nick = players[most.sid64]

    if not nick then
        return
    end

    local award = {
        nick = nick,
        priority = most.kills,
    }

    local kills = most.kills

    if kills > 1 and kills < 4 then
        award.title = T("aw_msx1_title")
        award.text = PT("aw_msx1_text", { num = kills })
    elseif kills >= 4 then
        award.title = T("aw_msx2_title")
        award.text = PT("aw_msx2_text", { num = kills })
    else
        return
    end

    return award
end
M16User = AWARDS.M16User -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.TeamKiller(events, scores, players, traitors)
    local tker
    local tktbl = {}
    local pct, tka = 0, 0

    -- find biggest tker
    for id, s in pairs(scores) do
        for i = 1, #s.ev do
            local ev = s.ev[i]

            tktbl[id] = tktbl[id] or {}

            if ev.t == TEAM_NONE or ev.t ~= ev.v or TEAMS[ev.t].alone then
                tktbl[id].k = (tktbl[id].k or 0) + 1
            else
                tktbl[id].tk = (tktbl[id].tk or 0) + 1
            end
        end
    end

    for tk, tbl in pairs(tktbl) do
        if tbl.tk and tbl.k then
            local tmp = tbl.tk / tbl.k

            if tmp > pct then
                tker = tk
                tka = tbl.tk
                pct = tmp
            end
        end
    end

    -- no tks
    if pct == 0 or not tker then
        return
    end

    local nick = players[tker]

    if not nick then
        return
    end

    local was_traitor = table.HasValue(traitors, tker)
    local award = {
        nick = nick,
        priority = tka,
    }

    if tka == 1 then
        award.title = T("aw_tkl1_title")
        award.text = T("aw_tkl1_text")
        award.priority = 0
    elseif tka == 2 then
        award.title = T("aw_tkl2_title")
        award.text = T("aw_tkl2_text")
    elseif tka == 3 then
        award.title = T("aw_tkl3_title")
        award.text = T("aw_tkl3_text")
    elseif pct >= 1.0 then
        award.title = T("aw_tkl4_title")
        award.text = T("aw_tkl4_text")
        award.priority = tka + math.random(3, 6)
    elseif pct >= 0.75 and not was_traitor then
        award.title = T("aw_tkl5_title")
        award.text = T("aw_tkl5_text")
        award.priority = tka + 10
    elseif pct > 0.5 then
        award.title = T("aw_tkl6_title")
        award.text = T("aw_tkl6_text")
        award.priority = tka + math.random(2, 7)
    elseif pct >= 0.25 then
        award.title = T("aw_tkl7_title")
        award.text = T("aw_tkl7_text")
    else
        return
    end

    return award
end
TeamKiller = AWARDS.TeamKiller -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.Burner(events, scores, players, traitors)
    local brn = {}

    for _, e in pairs(events) do
        if e.id == EVENT_KILL and is_dmg(e.dmg.t, DMG_BURN) then
            brn[e.att.sid64] = (brn[e.att.sid64] or 0) + 1
        end
    end

    if table.IsEmpty(brn) then
        return
    end

    -- find the one with the most burnings
    local m_id, m_num = FindHighest(brn)
    if not m_id then
        return
    end

    local nick = players[m_id]
    if not nick then
        return
    end

    local award = {
        nick = nick,
        priority = m_num * 2,
    }

    if m_num > 1 and m_num < 4 then
        award.title = T("aw_brn1_title")
        award.text = T("aw_brn1_text")
    elseif m_num >= 4 and m_num < 7 then
        award.title = T("aw_brn2_title")
        award.text = T("aw_brn2_text")
    elseif m_num >= 7 then
        award.title = T("aw_brn3_title")
        award.text = T("aw_brn3_text")
        award.priority = m_num + math.random(0, 4)
    else
        return
    end

    return award
end
Burner = AWARDS.Burner -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.Coroner(events, scores, players, traitors)
    local finders = {}

    for _, e in pairs(events) do
        if e.id == EVENT_BODYFOUND then
            finders[e.sid64] = (finders[e.sid64] or 0) + 1
        end
    end

    if table.IsEmpty(finders) then
        return
    end

    local m_id, m_num = FindHighest(finders)
    if not m_id then
        return
    end

    local nick = players[m_id]
    if not nick then
        return
    end

    local award = {
        nick = nick,
        priority = m_num,
    }

    if m_num > 2 and m_num < 6 then
        award.title = T("aw_fnd1_title")
        award.text = PT("aw_fnd1_text", { num = m_num })
    elseif m_num >= 6 and m_num < 10 then
        award.title = T("aw_fnd2_title")
        award.text = PT("aw_fnd2_text", { num = m_num })
    elseif m_num >= 10 then
        award.title = T("aw_fnd3_title")
        award.text = PT("aw_fnd3_text", { num = m_num })
        award.priority = m_num + math.random(0, 4)
    else
        return
    end

    return award
end
Coroner = AWARDS.Coroner -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.CreditFound(events, scores, players, traitors)
    local finders = {}

    for _, e in pairs(events) do
        if e.id == EVENT_CREDITFOUND then
            finders[e.sid64] = (finders[e.sid64] or 0) + e.cr
        end
    end

    if table.IsEmpty(finders) then
        return
    end

    local m_id, m_num = FindHighest(finders)
    if not m_id then
        return
    end

    local nick = players[m_id]
    if not nick then
        return
    end

    local award = { nick = nick }

    if m_num > 2 then
        award.title = T("aw_crd1_title")
        award.text = PT("aw_crd1_text", { num = m_num })
        award.priority = m_num + math.random(0, m_num)
    else
        return
    end

    return award
end
CreditFound = AWARDS.CreditFound -- just for compatibility

---
-- @param table events
-- @param table scores
-- @param table players list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @param table traitors list of @{Player}s with key = steamid64 and value = nickname of the @{Player}
-- @realm client
function AWARDS.TimeOfDeath(events, scores, players, traitors)
    local near = 10
    local time_near_start = CLSCORE.StartTime + near

    local time_near_end, traitor_win, e

    for i = #events, 1, -1 do
        e = events[i]

        if e.id == EVENT_FINISH then
            time_near_end = e.t - near
            traitor_win = e.win == WIN_TRAITOR or e.win == TEAM_TRAITOR
        elseif e.id == EVENT_KILL and e.vic then
            if
                time_near_end
                and e.t > time_near_end
                and (e.vic.t == TEAM_TRAITOR) == traitor_win
            then
                return {
                    nick = e.vic.ni,
                    title = T("aw_tod1_title"),
                    text = T("aw_tod1_text"),
                    priority = (e.t - time_near_end) * 2,
                }
            elseif e.t < time_near_start then
                return {
                    nick = e.vic.ni,
                    title = T("aw_tod2_title"),
                    text = T("aw_tod2_text"),
                    priority = (time_near_start - e.t) * 2,
                }
            end
        end
    end
end
TimeOfDeath = AWARDS.TimeOfDeath -- just for compatibility
