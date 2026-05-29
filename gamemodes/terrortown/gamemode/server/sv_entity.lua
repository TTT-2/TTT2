---
-- @ref https://wiki.facepunch.com/gmod/Entity
-- @class Entity

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
