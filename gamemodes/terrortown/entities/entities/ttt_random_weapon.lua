---
-- @class ENT
-- @desc Dummy ent that just spawns a random TTT weapon and kills itself
-- @section ttt_random_weapon

ENT.Type = "point"
ENT.Base = "base_point"

ENT.autoAmmoAmount = 0

---
-- @param string key
-- @param string|number value
-- @realm shared
function ENT:KeyValue(key, value)
    if key == "auto_ammo" then
        self.autoAmmoAmount = tonumber(value)
    end
end

---
-- @note Only used to forceSpawn weapons after map cleanup
-- otherwise these entities are only used to mark the spots for random weapon spawns
-- @realm shared
function ENT:Initialize()
    if entspawn.IsForcedRandomSpawnEnabled() then
        entspawn.SpawnRandomWeapon(self)
    end
end
