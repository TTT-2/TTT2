---
-- @ref https://wiki.facepunch.com/gmod/Entity
-- @class Entity

-- Caps taken from here: https://github.com/ValveSoftware/source-sdk-2013/blob/55ed12f8d1eb6887d348be03aee5573d44177ffb/mp/src/game/shared/baseentity_shared.h#L21-L38
FCAP_IMPULSE_USE = 16
FCAP_CONTINUOUS_USE = 32
FCAP_ONOFF_USE = 64
FCAP_DIRECTIONAL_USE = 128

local safeCollisionGroups = {
    [COLLISION_GROUP_WEAPON] = true,
}

local entmeta = FindMetaTable("Entity")
if not entmeta then
    return
end

---
-- Sets the @{Entity}'s damage owner and the current time
-- @param Player ply
-- @realm server
function entmeta:SetDamageOwner(ply)
    self.dmg_owner = { ply = ply, t = CurTime() }
end

---
-- Returns the @{Entity}'s damge owner
-- @return Player
-- @return number the time the damage owner was set
-- @realm server
function entmeta:GetDamageOwner()
    if self.dmg_owner == nil then
        return
    end

    return self.dmg_owner.ply, self.dmg_owner.t
end

---
-- Returns whether an @{Entity} is explosive
-- @return boolean
-- @realm server
function entmeta:IsExplosive()
    local kv = self:GetKeyValues()["ExplodeDamage"]

    return self:Health() > 0 and kv and kv > 0
end

---
-- Checks if the given entity can be passed by players.
-- @return boolean Returns if the entity is passable
-- @realm server
function entmeta:HasPassableCollisionGrup()
    return safeCollisionGroups[self:GetCollisionGroup()]
end

local oldSpawn = entmeta.Spawn

---
-- Initializes the entity and starts its networking. If called on a player, it will respawn them.
-- @note This extends the GMod Spawn function and spawns the player at a spawn point. Use @{Player:Respawn}
-- or @{Player:SpawnForRound} if you want to (re-)spawn the player.
-- @realm server
function entmeta:Spawn()
    if self:IsPlayer() then
        local spawnPoint = plyspawn.GetRandomSafePlayerSpawnPoint(self)

        if spawnPoint then
            self:SetPos(spawnPoint.pos)
            self:SetAngles(spawnPoint.ang)
        end
    end

    oldSpawn(self)
end

---
-- Checks if the entity has any use functionality attached.
-- @param[default=0] number requiredCaps Use caps that are required for this entity
-- @return boolean Returns true if the entity is usable by the player
-- @ref https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/game/server/player.cpp#L2766C71-L2781
-- @realm server
function entmeta:IsUsableEntity(requiredCaps)
    requiredCaps = requiredCaps or 0

    local caps = self:ObjectCaps()

    if
        bit.band(
                caps,
                bit.bor(FCAP_IMPULSE_USE, FCAP_CONTINUOUS_USE, FCAP_ONOFF_USE, FCAP_DIRECTIONAL_USE)
            )
            > 0
        and bit.band(caps, requiredCaps) == requiredCaps
    then
        return true
    end

    return false
end
