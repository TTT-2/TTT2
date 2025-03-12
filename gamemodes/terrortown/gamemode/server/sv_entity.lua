---
-- @ref https://wiki.facepunch.com/gmod/Entity
-- @class Entity

-- Caps taken from here: https://github.com/ValveSoftware/source-sdk-2013/blob/55ed12f8d1eb6887d348be03aee5573d44177ffb/mp/src/game/shared/baseentity_shared.h#L21-L38
FCAP_IMPULSE_USE = 16
FCAP_CONTINUOUS_USE = 32
FCAP_ONOFF_USE = 64
FCAP_DIRECTIONAL_USE = 128
FCAP_USE_ONGROUND = 256
FCAP_USE_IN_RADIUS = 512

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
-- Checks if the entity has any use functionality attached. This can be attached in the engine/via hammer or by
-- setting `.CanUseKey` to true. Player ragdolls and weapons always have use functionality attached.
-- @param[default=0] number requiredCaps Use caps that are required for this entity
-- @return boolean Returns true if the entity is usable by the player
-- @ref https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/game/server/player.cpp#L2766C71-L2781
-- @realm server
function entmeta:IsUsableEntity(requiredCaps)
    requiredCaps = requiredCaps or 0

    -- special case: TTT specific lua based use interactions
    -- when we're looking for specifically the lua use
    if self:IsSpecialUsableEntity() then
        return true
    end

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

---
-- Some sounds are important enough that they shouldn't be affected by CPASAttenuationFilter
-- @param string snd The name of the sound to be played
-- @param[default=75] number lvl A modifier for the distance this sound will reach, see SNDLVL enum
-- @param[default=100] number pitch The pitch applied to the sound, from 0 to 255
-- @param[default=1] number vol The volume, from 0 to 1
-- @param[default=CHAN_AUTO] number channel The sound channel, see CHAN enum
-- @param[default=0] number flags The flags of the sound, see SND enum
-- @param[default=0] number dsp The DSP preset for this sound
-- @ref https://wiki.facepunch.com/gmod/Entity:EmitSound
-- @realm server
function entmeta:BroadcastSound(snd, lvl, pitch, vol, channel, flags, dsp)
    lvl = lvl or 75

    local rf = RecipientFilter()

    if lvl == 0 then
        rf:AddAllPlayers()
    else
        -- Overriding the PAS filter means this will no longer check if players
        -- are within audible range before sending them the sound message.
        -- Instead, we reimplement this check in lua.
        local pos = self:GetPos()

        local attenuation = lvl > 50 and 20.0 / (lvl - 50) or 4.0
        local maxAudible = math.min(2500, 2000 / attenuation)

        for _, ply in player.Iterator() do
            if (ply:EyePos() - pos):Length() > maxAudible then
                continue
            end

            rf:AddPlayer(ply)
        end
    end

    self:EmitSound(snd, lvl, pitch, vol, channel, flags, dsp, rf)
end
