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
