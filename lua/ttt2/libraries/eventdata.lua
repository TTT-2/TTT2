---
-- A group of functions that uses the event data to generate
-- usable data for the usage in the game.
-- @author Mineotopia
-- @module eventdata

if SERVER then
    AddCSLuaFile()
end

eventdata = eventdata or {}

---
-- Returns a table with the player steamID64 as indexes and a number of deaths
-- for this specific player.
-- @note Players with zero deaths this round will not be included in this list.
-- @return table A table with the amounts of deaths per player
-- @realm shared
function eventdata.GetPlayerTotalDeaths()
    local eventList = events.list
    local deathList = {}

    for i = 1, #eventList do
        local event = eventList[i]

        if event.type ~= EVENT_KILL then
            continue
        end

        local victim64 = event.event.victim.sid64

        deathList[victim64] = (deathList[victim64] or 0) + 1
    end

    return deathList
end

---
-- Returns a table with all players that were present at the beginning of the
-- round while also providing their team and their role at this time.
-- @return table A table with the nick, sid64, role and team of each player
-- @realm shared
function eventdata.GetPlayerBeginRoles()
    local eventList = events.list

    for i = 1, #eventList do
        local event = eventList[i]

        if event.type ~= EVENT_SELECTED then
            continue
        end

        return event.event.plys
    end
end

---
-- Returns a table with all players that were present at the end of the
-- round while also providing their team and their role at this time.
-- @return table A table with the nick, sid64, alive, role and team of each player
-- @realm shared
function eventdata.GetPlayerEndRoles()
    local eventList = events.list

    for i = 1, #eventList do
        local event = eventList[i]

        if event.type ~= EVENT_FINISH then
            continue
        end

        return event.event.plys
    end
end

---
-- Returns a table with the steamID64 of the player in the first layer that has
-- all role changes per player included
-- @return table A table with all rolechanges per player, each entry contains the new role and the new team
-- @realm shared
function eventdata.GetPlayerRoles()
    local eventList = events.list
    local plyRoles = {}

    -- we can use the fact that the eventlist is chronological
    for i = 1, #eventList do
        local event = eventList[i]

        if event.type == EVENT_SELECTED then
            local plys = event.event.plys

            for k = 1, #plys do
                local ply = plys[k]

                plyRoles[ply.sid64] = {
                    {
                        role = ply.role,
                        team = ply.team,
                    },
                }
            end
        elseif event.type == EVENT_ROLECHANGE and event.event.roundState == ROUND_ACTIVE then
            local ply = event.event

            -- if a player connects after the round started, they don't have a starting role
            if not plyRoles[ply.sid64] then
                plyRoles[ply.sid64] = {}
            end

            plyRoles[ply.sid64][#plyRoles[ply.sid64] + 1] = {
                role = ply.newRole,
                team = ply.newTeam,
            }
        end
    end

    return plyRoles
end

---
-- Lists all events that grant scores to players. Sorts them by steamID64s.
-- @return table Returns a table of all scored events per player
-- @realm shared
function eventdata.GetPlayerScores()
    local eventList = events.list
    local plyScores = {}

    for i = 1, #eventList do
        local event = eventList[i]

        if not event:HasScore() then
            continue
        end

        local plys64 = event:GetScoredPlayers()

        for k = 1, #plys64 do
            local ply64 = plys64[k]

            plyScores[ply64] = plyScores[ply64] or {}

            plyScores[ply64][#plyScores[ply64] + 1] = event
        end
    end

    return plyScores
end

---
-- Returns a table with the player steamID64 as indexes and the score
-- for this specific player.
-- @note Players with zero score this round will not be included in this list.
-- @return table A table with the score per player
-- @realm shared
function eventdata.GetPlayerTotalScores()
    local eventList = events.list
    local scoreList = {}

    for i = 1, #eventList do
        local event = eventList[i]

        if not event:HasScore() then
            continue
        end

        local plys64 = event:GetScoredPlayers()

        for k = 1, #plys64 do
            local ply64 = plys64[k]

            scoreList[ply64] = (scoreList[ply64] or 0) + event:GetSummedPlayerScore(ply64)
        end
    end

    return scoreList
end

---
-- Lists all events that grant karma to players. Sorts them by steamID64s.
-- @return table Returns a table of all karma events per player
-- @realm shared
function eventdata.GetPlayerKarma()
    local eventList = events.list
    local plysKarma = {}

    -- Go table from back to front as only the newest sync is relevant
    for i = #eventList, 1, -1 do
        local event = eventList[i]

        if not event:HasKarma() then
            continue
        end
        plysKarma = event:GetKarma()

        break
    end

    return plysKarma
end

---
-- Returns a table with the player steamID64 as indexes and the karma
-- for this specific player.
-- @note Players with zero karmachange this round will not be included in this list.
-- @return table A table with the karma per player
-- @realm shared
function eventdata.GetPlayerTotalKarma()
    local eventList = events.list
    local plysKarma = {}

    -- Go table from back to front as only the newest sync is relevant
    for i = #eventList, 1, -1 do
        local event = eventList[i]

        if not event:HasKarma() then
            continue
        end

        for sid64, reasonList in pairs(event:GetKarma()) do
            plysKarma[sid64] = 0

            for _, karma in pairs(reasonList) do
                plysKarma[sid64] = plysKarma[sid64] + karma
            end
        end

        break
    end

    return plysKarma
end
