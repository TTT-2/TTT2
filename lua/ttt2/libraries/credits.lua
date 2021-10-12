---
-- Functions that handle the distribution of credits for certain events.
-- @author Mineotopia
-- @module entspawn

if CLIENT then return end -- this is a serverside-ony module

credits = credits or {}

---
-- This function handles the whole credit awarding for a kill. There are two modes: first the player
-- being awarded for the specific kill and second the player being awarded for a certain percentage
-- of players from other teams being dead.
-- @param Player victim The player that died
-- @param Player attacker The player that killed
-- @realm server
function credits.HandleKillCreditsAward(victim, attacker)
	if GetRoundState() ~= ROUND_ACTIVE or not IsValid(victim)
		or not IsValid(attacker) or not attacker:IsPlayer() or not attacker:IsActive()
	then return end

	---
	-- @realm server
	if hook.Run("TTT2CheckCreditAward", victim, attacker) == false then return end

	local roleDataAttacker = attacker:GetSubRoleData()
	local roleDataVictim = victim:GetSubRoleData()

	-- HANDLE CREDITS FOR KILL
	if roleDataVictim.isPublicRole and not victim:IsInTeam(attacker) and roleDataAttacker:IsAwardedCreditsForKill() then
		-- A high profile role, such as a policing role, is a dangerous target to kill.
		-- If a player from a different team is able to kill them, they should be awarded
		-- with a bonus to stock up their equipment.

		local creditsAmount = GetConVar("ttt_credits_award_kill"):GetInt()

		attacker:AddCredits(creditsAmount)
		LANG.Msg(attacker, "credit_kill", {num = creditsAmount, role = LANG.NameParam(victim:GetRoleString())}, MSG_MSTACK_ROLE)
	end

	-- HANDLE CREDITS FOR CERTAIN AMOUNT OF PLAYERS DEAD

	-- This is a special case scenario where for every kill it is checked for every player,
	-- how many players are dead from different teams than their own team.
	local plys = player.GetAll()
	local plysAmount = #plys

	for i = 1, plysAmount do
		-- iterate over every player and count the amount of dead players of their enemy team

		local plyToAward = plys[i]

		-- first check that the player is actually alive
		if not plyToAward:IsTerror() then continue end

		-- second make sure that the player's role can receive credits for dead players
		if not plyToAward:GetSubRoleData():IsAwardedCreditsForPlayerDead() then continue end

		-- then make sure that the team wasn't already rewarded and their reward is limited to once
		if plyToAward.wasAwardedCreditsDead and not GetConVar("ttt_credits_award_repeat"):GetBool() then continue end

		local plysEnemyAlive = 0
		local plysEnemyDead = 0

		for k = 1, plysAmount do
			-- now iterate over all players to count them

			local plyToCheck = plys[k]

			if not plyToCheck:IsInTeam(plyToAward) then
				-- Note: The player that just died is still counted as alive, so check them specially.
				if plyToCheck == victim or not plyToCheck:IsTerror() then
					plysEnemyDead = plysEnemyDead + 1
				else
					plysEnemyAlive = plysEnemyAlive + 1
				end
			end
		end

		-- only repeat-award if we have reached the pct again since last time
		local plysEnemyDeadModified = plysEnemyDead - (plyToAward.deadPlayersOnAward or 0)

		-- now calculate the percentage of dead players from the other teams
		local pctDead = plysEnemyDeadModified / (plysEnemyDead + plysEnemyAlive)

		-- only reward the player if the percentage of dead players is bigger than the threshold
		if pctDead < GetConVar("ttt_credits_award_pct"):GetFloat() then continue end

		local creditsAmount = GetConVar("ttt_credits_award_size"):GetInt()

		-- now reward their player for their good game
		plyToAward:AddCredits(creditsAmount)
		LANG.Msg(plyToAward, "credit_all", {num = creditsAmount}, MSG_MSTACK_ROLE)

		-- last but not least: update the data on the team
		plyToAward.wasAwardedCreditsDead = true
		plyToAward.deadPlayersOnAward = plysEnemyDead
	end
end

function credits.ResetPlayertates()
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		ply.wasAwardedCreditsDead = nil
		ply.deadPlayersOnAward = nil
	end
end
