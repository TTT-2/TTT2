---
-- A library to consolidate some common effects code.
-- @author EntranceJew
-- @module gameEffects

if SERVER then
    AddCSLuaFile()
end

gameEffects = {}

---
-- Create a bundle of fires all from a central location.
-- This is used for incendiary grenades or C4 detonation.
-- @param Vector pos The position the fires should originate from
-- @param TraceResult tr A trace to orient the creation of the fires around
-- @param number amount The number of individual balls of fire that should be created
-- @param number lifetime The base lifetime of all fires in the bundle
-- @param boolean explode Should the fires explode when they reach the end of their lives
-- @param nil|Player dmgowner The player to attribute the fire damage to
-- @param number forceSpread The force that each fire will be flung with
-- @param boolean immobile If true, fires will become stationary once they begin burning
-- @param number size The physical scale of the fires
-- @param number lifetimeVariance The amount each lifetime for each fire can vary
-- @return table A table full of the fire entities
-- @realm shared
function gameEffects.StartFires(
    pos,
    tr,
    amount,
    lifetime,
    explode,
    dmgowner,
    forceSpread,
    immobile,
    size,
    lifetimeVariance
)
    local flames = {}

    for i = 1, amount do
        local ang = Angle(-math.Rand(0, 180), math.Rand(0, 360), math.Rand(0, 360))
        local vstart = pos + tr.HitNormal * 64
        local ttl = lifetime + math.Rand(-lifetimeVariance, lifetimeVariance)

        if vFireInstalled then
            flames[#flames + 1] = CreateVFireBall(
                ttl,
                0.5 * size,
                vstart,
                0.5 * ang:Forward() * forceSpread,
                dmgowner
            )

            continue
        end

        local flame = ents.Create("ttt_flame")
        flame:SetPos(vstart)
        flame:SetFlameSize(size)
        flame:SetLifeSpan(ttl)
        flame:SetImmobile(immobile)

        if IsValid(dmgowner) and dmgowner:IsPlayer() then
            flame:SetDamageParent(dmgowner)
            flame:SetOwner(dmgowner)
        end

        flame:SetDieTime(CurTime() + ttl)
        flame:SetExplodeOnDeath(explode)
        flame:Spawn()
        flame:PhysWake()

        local phys = flame:GetPhysicsObject()

        if IsValid(phys) then
            -- the balance between mass and force is subtle, be careful adjusting
            phys:SetMass(2)
            phys:ApplyForceCenter(ang:Forward() * forceSpread)
            phys:AddAngleVelocity(Vector(ang.p, ang.r, ang.y))
        end

        flames[#flames + 1] = flame
    end

    return flames
end

---
-- Creates a single point of fire.
-- @param Vector pos The position to create the fire at
-- @param number scale Controls the height of the flame more than its radius. Informs the size
-- @param number lifetime How long a fire will burn for
-- @param nil|Entity owner The creator of the fire
-- @param nil|Entity parent The thing to attach the fire to
-- @return nil|Entity The fire it created, or nil if it was merged / couldn't be created
-- @realm server
function gameEffects.SpawnFire(pos, scale, lifetime, owner, parent)
    local fire = ents.Create("env_fire")

    if not IsValid(fire) then
        return
    end

    fire:SetParent(parent)
    fire:SetOwner(owner)
    fire:SetPos(pos)

    --no glow + delete when out + start on + last forever
    fire:SetKeyValue("spawnflags", tostring(128 + 32 + 4 + 2 + 1))

    -- hardly controls size, hitbox is goofy, impossible to work with
    fire:SetKeyValue("firesize", tostring(scale))
    fire:SetKeyValue("health", tostring(lifetime))
    fire:SetKeyValue("ignitionpoint", "64")

    -- don't hurt the player because we're managing the hurtbox ourselves
    fire:SetKeyValue("damagescale", "0")
    fire:Spawn()
    fire:Activate()

    return fire
end

---
-- Greatly simplified version of SDK's game_shard/gamerules.cpp:RadiusDamage
-- does no block checking, radius should be very small.
-- @note only hits players!
-- @param DamageInfo dmginfo
-- @param Vector pos
-- @param number radius
-- @param Entity inflictor
-- @realm shared
function gameEffects.RadiusDamage(dmginfo, pos, radius, inflictor)
    local entsFound = ents.FindInSphere(pos, radius)
    for i = 1, #entsFound do
        local vic = entsFound[i]

        if
            IsValid(vic)
            and inflictor:Visible(vic)
            and vic:IsPlayer()
            and vic:Alive()
            and vic:IsTerror()
        then
            vic:TakeDamageInfo(dmginfo)
        end
    end
end

-- vFIRE INTEGRATION

if SERVER then
    -- This is a replacement hook for the explosion damage hook in vFire. The difference here is
    -- that it is only applied if the damage is for non-player entities.
    --
    -- original doc: Fix fire dependent entities' behaviors, for instance:
    -- Explosive barrels rely on being ignited to explode after damaged by an explosion themselves
    -- Because vFire removes default fires, we need to encourage more chain explosions
    local function vFireTakeDamageReplacement(ent, dmg)
        ---
        -- @realm server
        -- stylua: ignore
        if hook.Run("vFireSuppressExplosionBehavior") then
            return
        end

        if not IsValid(ent) or not ent:IsPlayer() or not dmg:IsExplosionDamage() then
            return
        end

        local hp = ent:Health()
        if hp < dmg:GetDamage() and hp > 0 and math.random(1, 3) == 1 then
            ent:SetHealth(0)
        end
    end

    hook.Add("TTT2FinishedLoading", "TTT2TweakvFire", function()
        if not vFireInstalled then
            return
        end

        -- increase the think rate of fires to increase the damage dealt by fire
        vFireBurnThinkTickRate = 0.75

        hook.Remove("EntityTakeDamage", "vFireFixExplosion")
        hook.Add("EntityTakeDamage", "vFireFixExplosionReplacement", vFireTakeDamageReplacement)
    end)
end
