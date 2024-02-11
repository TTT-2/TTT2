--- @ignore

local function is_dmg(dmg_t, bit)
    -- deal with large-number workaround for TableToJSON by
    -- parsing back to number here
    return util.BitSet(tonumber(dmg_t), bit)
end

---
-- Helper fn for kill events
local function GetWeaponName(gun)
    local wname

    -- Standard TTT weapons are sent as numeric IDs to save bandwidth
    if tonumber(gun) then
        wname = EnumToWep(gun)
    elseif isstring(gun) then
        -- Custom weapons or ones that are otherwise ID-less are sent as
        -- string
        local wep = util.WeaponForClass(gun)

        wname = wep and wep.PrintName
    end

    return wname
end

---
-- Generating the text for a kill event requires a lot of logic for special
-- cases, resulting in a long function, so defining it separately herevent.
local function KillText(event)
    local dmg = event.dmg
    local trap = dmg.name

    if trap == "" then
        trap = nil
    end

    local weapon = GetWeaponName(dmg.weapon)

    -- there is only ever one piece of equipment present in a language string,
    -- all the different names like "trap", "tool" and "weapon" are aliases.
    local equip = trap or weapon

    local params = {
        victim = event.victim.nick,
        vrole = roles.GetByIndex(event.victim.role).name,
        vteam = event.victim.team,
        trap = equip,
        tool = equip,
        weapon = equip,
    }

    if event.attacker then
        params.attacker = event.attacker.nick
        params.arole = roles.GetByIndex(event.attacker.role).name
        params.ateam = event.attacker.team
    end

    if event.attacker and event.attacker.sid64 == event.victim.sid64 then
        if is_dmg(dmg.type, DMG_BLAST) then
            return trap and "desc_event_kill_blowup_trap" or "desc_event_kill_blowup", params
        elseif is_dmg(dmg.type, DMG_SONIC) then
            return "desc_event_kill_tele_self", params
        else
            return trap and "desc_event_kill_sui_using" or "desc_event_kill_sui", params
        end
    end

    local txt

    -- we will want to know if the death was caused by a player or not
    -- (eg. push vs fall)
    local attackerWasPlayer = true

    -- if we are dealing with an accidental trap death for example, we want to
    -- use the trap name as "attacker"
    if not event.attacker then
        attackerWasPlayer = false

        params.attacker = trap or "trap_something"
    end

    -- typically the "_using" strings are only for traps
    local using = not weapon

    if is_dmg(dmg.type, DMG_FALL) then
        if attackerWasPlayer then
            txt = "desc_event_kill_fall_pushed"
        else
            txt = "desc_event_kill_fall"
        end
    elseif is_dmg(dmg.type, DMG_BULLET) then
        txt = "desc_event_kill_shot"

        using = true
    elseif is_dmg(dmg.type, DMG_DROWN) then
        txt = "desc_event_kill_drown"
    elseif is_dmg(dmg.type, DMG_BLAST) then
        txt = "desc_event_kill_boom"
    elseif is_dmg(dmg.type, DMG_BURN) or is_dmg(dmg.type, DMG_DIRECT) then
        txt = "desc_event_kill_burn"
    elseif is_dmg(dmg.type, DMG_CLUB) then
        txt = "desc_event_kill_club"
    elseif is_dmg(dmg.type, DMG_SLASH) then
        txt = "desc_event_kill_slash"
    elseif is_dmg(dmg.type, DMG_SONIC) then
        txt = "desc_event_kill_tele"
    elseif is_dmg(dmg.type, DMG_PHYSGUN) then
        txt = "desc_event_kill_goomba"

        using = false
    elseif is_dmg(dmg.type, DMG_CRUSH) then
        txt = "desc_event_kill_crush"
    else
        txt = "desc_event_kill_other"
    end

    if attackerWasPlayer and (trap or weapon) and using then
        txt = txt .. "_using"
    end

    return txt, params
end

if CLIENT then
    EVENT.icon = Material("vgui/ttt/vskin/events/kill")
    EVENT.title = "title_event_kill"

    function EVENT:GetText()
        local string, params = KillText(self.event)
        local text = {
            {
                string = string,
                params = params,
                translateParams = true,
            },
        }

        if self.event.type == KILL_SUICIDE then
            text[2] = {
                string = "desc_event_kill_suicide",
            }
        elseif self.event.type == KILL_TEAM then
            text[2] = {
                string = "desc_event_kill_team",
            }
        end

        return text
    end
end

if SERVER then
    function EVENT:Trigger(victim, attacker, dmgInfo)
        if not IsValid(victim) or not victim:IsPlayer() then
            return
        end

        self:AddAffectedPlayers({ victim:SteamID64() }, { victim:Nick() })

        local event = {
            victim = {
                nick = victim:Nick(),
                sid64 = victim:SteamID64(),
                role = victim:GetSubRole(),
                team = victim:GetTeam(),
            },
            dmg = {
                headshot = victim.was_headshot,
                type = dmgInfo:GetDamageType(),
                damage = dmgInfo:GetDamage(),
            },
        }

        if IsValid(attacker) and attacker:IsPlayer() then
            event.attacker = {
                nick = attacker:Nick(),
                health = attacker:Health(),
                armor = attacker:GetArmor(),
                sid64 = attacker:SteamID64(),
                role = attacker:GetSubRole(),
                team = attacker:GetTeam(),
            }

            self:AddAffectedPlayers({ attacker:SteamID64() }, { attacker:Nick() })

            -- set death type
            if event.attacker.sid64 == event.victim.sid64 then
                event.type = KILL_SUICIDE
            else
                if
                    event.attacker.team ~= TEAM_NONE
                    and event.attacker.team == event.victim.team
                    and not TEAMS[event.attacker.team].alone
                then
                    event.type = KILL_TEAM
                else
                    event.type = KILL_NORMAL
                end
            end
        end

        local wep = util.WeaponFromDamage(dmgInfo)

        if wep then
            local id = WepToEnum(wep)

            if id then
                event.dmg.weapon = id
            else
                event.dmg.weapon = wep:GetClass()
            end
        else
            -- handle the name of the inflictor if it was caused by a trap
            local inflictor = dmgInfo:GetInflictor()

            if IsValid(inflictor) and inflictor.ScoreName then
                event.dmg.name = inflictor.ScoreName
            end
        end

        return self:Add(event)
    end

    function EVENT:CalculateScore()
        local event = self.event

        -- the event is only counted if it happened while the round was active
        if event.roundState ~= ROUND_ACTIVE then
            return
        end

        local attacker = event.attacker
        local deathType = event.type

        -- if there is no killer, it wasn't a suicide or a kill, therefore
        -- no points should be granted to anyone
        if not attacker then
            return
        end

        -- the score is dependent of the teams/roles
        local roleData = roles.GetByIndex(attacker.role)

        if deathType == KILL_SUICIDE then
            self:SetPlayerScore(attacker.sid64, {
                score_suicide = roleData.score.suicideMultiplier,
            })
        elseif deathType == KILL_TEAM then
            self:SetPlayerScore(attacker.sid64, {
                score_team = roleData.score.teamKillsMultiplier,
            })
        else
            self:SetPlayerScore(attacker.sid64, {
                score = roleData.score.killsMultiplier,
            })
        end
    end
end

function EVENT:Serialize()
    return self.event.victim.nick .. " has died."
end

function EVENT:GetDeprecatedFormat()
    local event = self.event

    if event.roundState ~= ROUND_ACTIVE then
        return
    end

    local attacker = event.attacker
    local victim = event.victim
    local dmg = event.dmg

    return {
        id = self.type,
        t = event.time / 1000,
        att = {
            ni = attacker and attacker.nick or "",
            sid64 = attacker and attacker.sid64 or -1,
            r = attacker and attacker.role or -1,
            t = attacker and attacker.team or "",
        },
        vic = {
            ni = victim.nick,
            sid64 = victim.sid64,
            r = victim.role,
            t = victim.team,
        },
        dmg = {
            t = dmg.type,
            a = dmg.damage,
            h = dmg.headshot,
            g = dmg.weapon,
            n = dmg.name,
        },
    }
end
