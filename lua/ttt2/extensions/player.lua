---
-- player extension
-- @author Mineotopia

---
-- Resets the spawn position of all players.
-- @realm server
function player.ReSetLastSpawnPosition()
	local plys = player.GetAll()

	for i = 1, #plys do
		plys[i]:SetLastSpawnPosition(nil)
	end
end

---
-- Resets the death position of all players.
-- @realm server
function player.ReSetLastDeathPosition()
	local plys = player.GetAll()

	for i = 1, #plys do
		plys[i]:SetLastDeathPosition(nil)
	end
end

---
-- Resets the 'diedInRound' flag of all players.
-- @realm server
function player.ResetDiedInRound()
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		ply:SetDiedInRound(false)
	end
end

---
-- Resets the 'activeInRound' flag of all players.
-- @realm server
function player.ResetActiveInRound()
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		ply:SetActiveInRound(false)
	end
end

---
-- Initializes the 'activeInRound' flag of all players.
-- @realm server
function player.InitActiveInRound()
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		ply:SetActiveInRound(ply:Alive() and ply:IsTerror())
	end
end
