---
-- Functions that handle the distribution of credits for certain events.
-- @author Mineotopia
-- @module credits

if CLIENT then
    return
end -- this is a serverside-only module

credits = credits or {}

---
-- This function handles the whole credit awarding for a kill. There are two modes: first the player
-- being awarded for the specific kill and second the player being awarded for a certain percentage
-- of players from other teams being dead.
-- @param Player victim The player that died
-- @param Player attacker The player that killed
-- @realm server
function credits.HandleKillCreditsAward(victim, attacker)
    if
        gameloop.GetRoundState() ~= ROUND_ACTIVE
        or not IsValid(victim)
        or not IsValid(attacker)
        or not attacker:IsPlayer()
        or not attacker:IsActive()
    then
        return
    end

    ---
    -- @realm server
    if hook.Run("TTT2CheckCreditAward", victim, attacker) == false then
        return
    end

    local roleDataAttacker = attacker:GetSubRoleData()
    local roleDataVictim = victim:GetSubRoleData()

    -- HANDLE CREDITS FOR KILL
    if
        roleDataVictim.isPublicRole
        and not victim:IsInTeam(attacker)
        and roleDataAttacker:IsAwardedCreditsForKill()
    then
        -- A high profile role, such as a policing role, is a dangerous target to kill.
        -- If a player from a different team is able to kill them, they should be awarded
        -- with a bonus to stock up their equipment.

        local creditsAmount = GetConVar("ttt_credits_award_kill"):GetInt()

        attacker:AddCredits(creditsAmount)

        ---
        -- @realm server
        hook.Run("TTT2OnReceiveKillCredits", victim, attacker, creditsAmount)

        LANG.Msg(
            attacker,
            "credit_kill",
            { num = creditsAmount, role = LANG.NameParam(victim:GetRoleString()) },
            MSG_MSTACK_ROLE
        )
    end

    -- HANDLE CREDITS FOR CERTAIN AMOUNT OF PLAYERS DEAD

    -- This is a special case scenario where for every kill it is checked for every player,
    -- how many players are dead from different teams than their own team.
    local plys = player.GetAll()
    local plysAmount = #plys
    local plysByTeams = {}

    -- At first a table with players sorted by teams is created, because those rewards are teambased.
    for i = 1, plysAmount do
        local ply = plys[i]

        -- ignore forced spectator players
        if ply:IsSpec() and ply:GetForceSpec() then
            continue
        end

        local team = ply:GetTeam()

        plysByTeams[team] = plysByTeams[team] or {}
        plysByTeams[team][#plysByTeams[team] + 1] = ply
    end

    -- Now iterate over the team table and grant credits if limits are reached
    for team, plysByTeam in pairs(plysByTeams) do
        local teamTable = TEAMS[team]

        -- make sure that the team wasn't already awarded and their award is limited to once
        if
            teamTable.wasAwardedCreditsDead and not GetConVar("ttt_credits_award_repeat"):GetBool()
        then
            continue
        end

        -- check if a reward should be issued
        local plysEnemyAlive = 0
        local plysEnemyDead = 0

        for i = 1, plysAmount do
            -- now iterate over all players to count them

            local plyToCheck = plys[i]

            if plyToCheck:GetTeam() ~= team then
                if plyToCheck == victim or not plyToCheck:IsTerror() then
                    -- Note: The player that just died is still counted as alive, so check them specially.
                    plysEnemyDead = plysEnemyDead + 1
                elseif not plyToCheck:GetForceSpec() then
                    -- if a player is not in the terror team, they could also be a forced spectator
                    plysEnemyAlive = plysEnemyAlive + 1
                end
            end
        end

        -- only repeat-award if we have reached the pct again since last time
        local plysEnemyDeadModified = plysEnemyDead - (teamTable.deadPlayersOnAward or 0)

        -- now calculate the percentage of dead players from the other teams
        local pctDead = plysEnemyDeadModified / (plysEnemyDead + plysEnemyAlive)

        -- only reward the player if the percentage of dead players is bigger than the threshold
        if pctDead < GetConVar("ttt_credits_award_pct"):GetFloat() then
            continue
        end

        -- now the team table is update since a new award was given
        teamTable.wasAwardedCreditsDead = true
        teamTable.deadPlayersOnAward = plysEnemyDead

        local creditsAmount = GetConVar("ttt_credits_award_size"):GetInt()

        -- now give the award to the players
        for i = 1, #plysByTeam do
            local plyToAward = plysByTeam[i]

            -- first check that the player is actually alive
            if not plyToAward:IsTerror() then
                continue
            end

            -- second make sure that the player's role can receive credits for dead players
            if not plyToAward:GetSubRoleData():IsAwardedCreditsForPlayerDead() then
                continue
            end

            -- now reward their player for their good game
            plyToAward:AddCredits(creditsAmount)

            ---
            -- @realm server
            hook.Run("TTT2OnReceiveTeamAwardCredits", plyToAward, creditsAmount)

            LANG.Msg(plyToAward, "credit_all", { num = creditsAmount }, MSG_MSTACK_ROLE)
        end
    end
end

---
-- Resets the team states that get set for the credits distributions.
-- @realm server
function credits.ResetTeamStates()
    for _, teamTable in pairs(TEAMS) do
        teamTable.wasAwardedCreditsDead = nil
        teamTable.deadPlayersOnAward = nil
    end
end
