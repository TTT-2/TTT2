---
-- player extension
-- @author Mineotopia

function player.ResetSpawnPosition()
	local plys = player.GetAll()

	for i = 1, #plys do
		plys[i]:SetSpawnPosition(Vector(0, 0, 0))
	end
end

function player.ResetDeathPosition()
	local plys = player.GetAll()

	for i = 1, #plys do
		plys[i]:SetDeathPosition(Vector(0, 0, 0))
	end
end

function player.ResetDiedInRound()
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		ply:SetDiedInRound(false)
	end
end

function player.ResetActiveInRound()
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		ply:SetActiveInRound(false)
	end
end

function player.InitActiveInRound()
	local plys = player.GetAll()

	for i = 1, #plys do
		local ply = plys[i]

		ply:SetActiveInRound(ply:Alive() and ply:IsTerror())
	end
end