---
-- @class ENT
-- @desc Dummy ent that just spawns a random TTT ammo item and kills itself
-- @section ttt_random_ammo

ENT.Type = "point"
ENT.Base = "base_point"

function ENT:Initialize()
	if entspawn.IsDirectRandomSpawnEnabled() then
		entspawn.SpawnRandomAmmo(self)
	end
end
