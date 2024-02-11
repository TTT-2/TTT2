---
-- @class ENT
-- @desc Dummy ent that just spawns a random TTT ammo item and kills itself
-- @section ttt_random_ammo

ENT.Type = "point"
ENT.Base = "base_point"

---
-- @note Only used to forceSpawn ammo after map cleanup
-- otherwise these entities are only used to mark the spots for random ammo spawns
-- @realm shared
function ENT:Initialize()
    if entspawn.IsForcedRandomSpawnEnabled() then
        entspawn.SpawnRandomAmmo(self)
    end
end
