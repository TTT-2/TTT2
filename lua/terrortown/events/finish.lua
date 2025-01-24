--- @ignore

if CLIENT then
    EVENT.icon = Material("vgui/ttt/vskin/events/finish")
    EVENT.title = "title_event_finish"

    function EVENT:GetText()
        local alive = 0

        for i = 1, #self.event.plys do
            if self.event.plys[i].alive then
                alive = alive + 1
            end
        end

        local time = self:GetTime()
        local minutes = math.floor(time / 60)
        local seconds = string.format("%02d", math.floor(time % 60))

        return {
            {
                string = "desc_event_finish",
                params = {
                    alive = alive,
                    minutes = minutes,
                    seconds = seconds,
                },
            },
        }
    end
end

if SERVER then
    function EVENT:Trigger(wintype)
        local plys = player.GetAll()
        local eventPlys = {}

        for i = 1, #plys do
            local ply = plys[i]

            eventPlys[#eventPlys + 1] = {
                nick = ply:Nick(),
                sid64 = ply:SteamID64(),
                team = ply:GetTeam(),
                role = ply:GetSubRole(),
                alive = ply:Alive() and ply:IsTerror(),
            }

            self:AddAffectedPlayers({ ply:SteamID64() }, { ply:Nick() })
        end

        return self:Add({
            wintype = wintype,
            plys = eventPlys,
        })
    end
end

function EVENT:CalculateScore()
    local event = self.event
    local plys = event.plys
    local wintype = event.wintype
    local alive = {}
    local dead = {}
    local aliveAll = 0

    -- Check who is alive and who is dead on a teambased approach
    for i = 1, #plys do
        local ply = plys[i]
        local state = ply.alive and alive or dead
        local team = ply.team

        if ply.alive then
            aliveAll = aliveAll + 1
        end

        if team ~= TEAM_NONE then
            state[team] = (state[team] or 0) + 1
        end
    end

    -- In a second pass, calculate the score based on the players that
    -- are still alive. The more of their team have survived, the greater
    -- their bonus. Additionally many dead players from a different team
    -- can grant extra points.
    for i = 1, #plys do
        local ply = plys[i]
        local team = ply.team
        local roleData = roles.GetByIndex(ply.role)
        local otherDeadPlayers = 0
        local otherAlivePlayers = 0

        -- Count dead players that are in a different team
        for otherTeam, amount in pairs(dead) do
            if team ~= TEAM_NONE and team == otherTeam and not TEAMS[team].alone then
                continue
            end

            otherDeadPlayers = otherDeadPlayers + amount
        end

        -- Count alive players that are in a different team
        for otherTeam, amount in pairs(alive) do
            if team ~= TEAM_NONE and team == otherTeam and not TEAMS[team].alone then
                continue
            end

            otherAlivePlayers = otherAlivePlayers + amount
        end

        self:SetPlayerScore(ply.sid64, {
            score_alive_teammates = wintype == team
                    and ((alive[team] or 0) * roleData.score.aliveTeammatesBonusMultiplier)
                or 0,
            score_alive_all = aliveAll * roleData.score.allSurviveBonusMultiplier,
            score_dead_enemies = wintype == team and math.ceil(
                otherDeadPlayers * roleData.score.surviveBonusMultiplier
            ) or 0,
            score_penalty_alive_teammates = (wintype ~= team and ply.alive)
                    and ((alive[team] or 0) * roleData.score.survivePenaltyMultiplier)
                or 0,
            score_timelimit = wintype == WIN_TIMELIMIT and math.ceil(
                otherAlivePlayers * roleData.score.timelimitMultiplier
            ) or 0,
            score_win = wintype == team and roleData.score.winMultiplier or 0,
        })
    end
end

function EVENT:ShouldKarmaChangeSynchronize()
    return true
end

function EVENT:Serialize()
    return "The round has ended."
end

function EVENT:GetDeprecatedFormat()
    local event = self.event

    if event.roundState ~= ROUND_ACTIVE then
        return
    end

    return {
        id = self.type,
        t = event.time / 1000,
        win = event.wintype,
    }
end
