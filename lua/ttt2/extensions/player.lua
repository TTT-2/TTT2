---
-- player extension
-- @author Mineotopia

---
-- Resets the spawn position of all players.
-- @realm server
function player.ResetSpawnPosition()
	local plys = player.GetAll()

	for i = 1, #plys do
		plys[i]:SetSpawnPosition(Vector(0, 0, 0))
	end
end

---
-- Resets the death position of all players.
-- @realm server
function player.ResetDeathPosition()
	local plys = player.GetAll()

	for i = 1, #plys do
		plys[i]:SetDeathPosition(Vector(0, 0, 0))
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
