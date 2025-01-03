---
-- @class ENT
-- @desc A base that handles everything around placeable and destroyable entities
-- @section ttt_base_placeable

if SERVER then
    AddCSLuaFile()
end

ENT.Type = "anim"

-- if set to false, the entity can not be destroyed by damage
ENT.isDestructible = true

ENT.pickupWeaponClass = nil

ENT.CanUseKey = true

local soundDeny = Sound("HL2Player.UseDeny")

---
-- @realm shared
function ENT:Initialize()
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)

    if SERVER then
        self:PrecacheGibs()
    end

    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        phys:SetMass(40)
    end

    self:SetHealth(100)
end

---
-- @realm shared
function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "Originator")
end

---
-- Run if a valid player tries to pick up this entity to check if this pickup is accepted.
-- @param Player activator The player that used their use key
-- @return[default=true] boolean Return true to allow pickup
-- @hook
-- @realm shared
function ENT:PlayerCanPickupWeapon(activator)
    return true
end

if CLIENT then
    ---
    -- Hook that is called if a player uses their use key while focusing on the entity.
    -- Implement this to predict early if entity can be picked up
    -- @return bool True to prevent pickup
    -- @realm client
    function ENT:ClientUse()
        local client = LocalPlayer()

        if not IsValid(client) or not client:IsTerror() or not self.pickupWeaponClass then
            return true
        end

        if not self:PlayerCanPickupWeapon(client) then
            LANG.Msg("pickup_fail", nil, MSG_MSTACK_WARN)

            self:EmitSound(soundDeny)

            return true
        end
    end
end -- CLIENT

if SERVER then
    local soundRumble = {
        Sound("physics/concrete/concrete_break2.wav"),
        Sound("physics/concrete/concrete_break3.wav"),
    }

    local soundBreak = {
        Sound("physics/metal/metal_box_break1.wav"),
        Sound("physics/metal/metal_box_break2.wav"),
    }

    local soundGlass = {
        Sound("physics/glass/glass_bottle_break1.wav"),
        Sound("physics/glass/glass_bottle_break2.wav"),
        Sound("physics/glass/glass_cup_break1.wav"),
        Sound("physics/glass/glass_cup_break2.wav"),
        Sound("physics/glass/glass_pottery_break1.wav"),
        Sound("physics/glass/glass_pottery_break2.wav"),
        Sound("physics/glass/glass_pottery_break3.wav"),
        Sound("physics/glass/glass_pottery_break4.wav"),
    }

    local soundWeld = Sound("weapons/c4/c4_plant.wav")

    local soundThrow = Sound("Weapon_SLAM.SatchelThrow")

    local soundWeaponPickup = Sound("items/ammo_pickup.wav")

    AccessorFunc(ENT, "hitNormal", "HitNormal", FORCE_VECTOR)
    AccessorFunc(ENT, "stickRotation", "StickRotation", FORCE_ANGLE)

    ---
    -- @param CTakeDamageInfo dmgInfo
    -- @realm server
    function ENT:OnTakeDamage(dmgInfo)
        -- we add a flag here because stuff can happen in the WasDestroyed
        -- hook that could create an infinite loop that crashes the game
        if self.isDestroyed then
            return
        end

        if not self:IsWeldedToSurface() then
            self:TakePhysicsDamage(dmgInfo)
        end

        if not self.isDestructible then
            return
        end

        local pos = self:GetPos()
        local amountDamage = dmgInfo:GetDamage()
        local attacker = dmgInfo:GetAttacker()
        local originator = self:GetOriginator()

        self:SetHealth(self:Health() - amountDamage)

        if IsValid(attacker) and attacker:IsPlayer() then
            DamageLog(
                Format(
                    "DMG: \t %s [%s] damaged '%s' [owner: %s] for %d dmg",
                    attacker:Nick(),
                    attacker:GetRoleString(),
                    self:GetClass(),
                    (IsValid(originator) and originator:IsPlayer()) and originator:Nick()
                        or "<disconnected>",
                    amountDamage
                )
            )
        end

        if self:Health() <= 0 then
            self:SetSolid(SOLID_NONE)

            self:GibBreakClient(Vector(0, 0, 100))

            local effect = EffectData()
            effect:SetOrigin(pos)

            util.Effect("cball_explode", effect)

            sound.Play(table.Random(soundRumble), pos, 75)
            sound.Play(table.Random(soundBreak), pos, 50)
            sound.Play(table.Random(soundGlass), pos, 65)

            self.isDestroyed = true

            local decal = self:WasDestroyed(pos, dmgInfo) or "FadingScorch"

            local vecHitNormal = self:GetHitNormal()

            if vecHitNormal then
                local tr = util.TraceLine({
                    start = pos,
                    endpos = pos - vecHitNormal * 256,
                    filter = { self },
                    mask = MASK_SOLID,
                })

                util.Decal(decal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, self)
            else
                util.PaintDown(pos, decal, self)
            end

            self:Remove()
        else
            local effect = EffectData()
            effect:SetOrigin(pos)

            util.Effect("ThumperDust", effect)
        end
    end

    ---
    -- Called when the entity was destroyed and is not yet removed. Can be used to trigger special things.
    -- @param Vector pos The position of the entitiy
    -- @param CTakeDamageInfo dmgInfo The damage info object that killed the entity
    -- @return nil|string The decal name that should be painted on destruction
    -- @hook
    -- @realm server
    function ENT:WasDestroyed(pos, dmgInfo) end

    ---
    -- Welds the entity to the nearest surface.
    -- @param boolean stateWelding The welding state; true to weld, false to unweld
    -- @realm server
    function ENT:WeldToSurface(stateWelding)
        self.stateWelding = stateWelding

        if stateWelding then
            local vecHitNormal = self:GetHitNormal()

            if vecHitNormal then
                self:SetAngles(vecHitNormal:Angle() + (self:GetStickRotation() or Angle(0, 0, 0)))
            end

            local pos = self:GetPos()
            local ignore = player.GetAll()

            ignore[#ignore + 1] = self

            local tr = util.TraceEntity({
                start = pos,
                endpos = pos - Vector(0, 0, 16),
                filter = ignore,
                mask = MASK_SOLID,
            }, self)

            sound.Play(soundWeld, pos, 75)

            if tr.Hit and (IsValid(tr.Entity) or tr.HitWorld) then
                local phys = self:GetPhysicsObject()

                if IsValid(phys) then
                    if tr.HitWorld then
                        phys:EnableMotion(false)
                    else
                        self.originalMass = phys:GetMass()
                        phys:SetMass(150)
                    end
                end

                -- only weld to objects we cannot pick up
                local entphys = tr.Entity:GetPhysicsObject()
                if IsValid(entphys) and entphys:GetMass() > CARRY_WEIGHT_LIMIT then
                    constraint.Weld(self, tr.Entity, 0, 0, 0, true)
                end
            end
        else
            constraint.RemoveConstraints(self, "Weld")

            local phys = self:GetPhysicsObject()

            if IsValid(phys) then
                phys:EnableMotion(true)
                phys:SetMass(self.originalMass or 10)
            end
        end
    end

    ---
    -- Checks if the entity is welded to a surface.
    -- @return boolean Returns true if the entity is welded to a surface
    -- @realm server
    function ENT:IsWeldedToSurface()
        return self.stateWelding or false
    end

    ---
    -- Hook that is called if a player uses their use key while focusing on the entity.
    -- @note When overwriting this function BaseClass.Use has to be called if
    -- the entity pickup system should be used.
    -- @param Player activator The player that used their use key
    -- @realm server
    function ENT:Use(activator)
        if not IsValid(activator) or not activator:IsTerror() or not self.pickupWeaponClass then
            return
        end

        if not self:PlayerCanPickupWeapon(activator) then
            LANG.Msg(activator, "pickup_fail", nil, MSG_MSTACK_WARN)

            self:EmitSound(soundDeny)

            return
        end

        local wep = activator:GetWeapon(self.pickupWeaponClass)

        if IsValid(wep) and wep:Clip1() < wep.Primary.ClipSize then
            wep:SetClip1(wep:Clip1() + 1)

            activator:EmitSound(soundWeaponPickup)

            activator:SelectWeapon(self.pickupWeaponClass)
        else
            -- picks up weapon and drops blocking weapon if slot is already in use
            wep = activator:SafePickupWeaponClass(self.pickupWeaponClass, true)

            -- if pickup has failed, the in-world entity should not be removed
            if not IsValid(wep) then
                LANG.Msg(activator, "pickup_no_room", nil, MSG_MSTACK_WARN)

                self:EmitSound(soundDeny)

                return
            end
        end

        if self:IsWeldedToSurface() then
            sound.Play(soundWeld, self:GetPos(), 75)
        end

        self:OnPickup(activator, wep)

        self:Remove()
    end

    ---
    -- Called when this entity is picked up and about to be removed.
    -- @param Player activator The player that used their use key
    -- @param Weapon wep The weapon that is added to their inventory
    -- @hook
    -- @realm server
    function ENT:OnPickup(activator, wep) end

    ---
    -- Helper function for a weapon that wants to throw the entity. Already handles everything.
    -- @param Player ply The player that throws the entity, the owner
    -- @param[opt] Angle rotationalOffset The model's rotational offset that should be applied
    -- @return boolean Returns true on success
    -- @realm server
    function ENT:ThrowEntity(ply, rotationalOffset)
        local posThrow = ply:GetShootPos() - Vector(0, 0, 15)
        local vecAim = ply:GetAimVector()

        if not ply:HasDropSpace(posThrow, vecAim) then
            LANG.Msg(ply, "throw_no_room", nil, MSG_MSTACK_WARN)

            return false
        end

        ply:SetAnimation(PLAYER_ATTACK1)

        rotationalOffset = rotationalOffset or Angle(0, 0, 0)

        local velocity = ply:GetVelocity()
        local velocityThrow = velocity + vecAim * 250

        self:SetPos(posThrow + vecAim * 10)
        self:SetOriginator(ply)
        self:Spawn()
        self:PointAtEntity(ply)

        local ang = self:GetAngles()
        ang:RotateAroundAxis(ang:Right(), rotationalOffset.pitch)
        ang:RotateAroundAxis(ang:Up(), rotationalOffset.yaw)
        ang:RotateAroundAxis(ang:Forward(), rotationalOffset.roll)

        self:SetAngles(ang)
        self:PhysWake()

        local phys = self:GetPhysicsObject()

        if IsValid(phys) then
            phys:SetVelocity(velocityThrow)
        end

        self:EmitSound(soundThrow)

        return true
    end

    ---
    -- Helper function for a weapon that wants to stick the entity to a surface. Already handles everything.
    -- @param Player ply The player that sticks the entity, the owner
    -- @param[opt] Angle rotationalOffset The model's rotational offset that should be applied
    -- @param[opt] number angleCondition The angle condition that has to be met to apply the rotational offset
    -- @note On the rotations: A model ca be rotated in three axis. This can be set in `rotationalOffset`. It is
    -- also possible to tie this to an `angleCondition` that has to be met so that this offset is applied. Such
    -- an angle condition is any possible angle: if the angle of the hit normal is greater then the provided
    -- condition, the offset is applied.
    -- @return boolean Returns true on success
    -- @realm server
    function ENT:StickEntity(ply, rotationalOffset, angleCondition)
        ply:SetAnimation(PLAYER_ATTACK1)

        rotationalOffset = rotationalOffset or Angle(0, 0, 0)

        local pos = ply:GetShootPos()

        local tr = util.TraceLine({
            start = pos,
            endpos = pos + ply:GetAimVector() * 100,
            mask = MASK_NPCWORLDSTATIC,
            filter = { self, ply },
        })

        if not tr.Hit then
            return false
        end

        self:SetPos(tr.HitPos)
        self:SetOriginator(ply)
        self:Spawn()
        self:SetHitNormal(tr.HitNormal)

        if tr.HitNormal.x == 0 and tr.HitNormal.y == 0 and tr.HitNormal.z == 1 then
            rotationalOffset.yaw = rotationalOffset.yaw + ply:GetAngles().yaw + 180
        end

        if not angleCondition or math.abs(tr.HitNormal:Angle().pitch) >= angleCondition then
            self:SetStickRotation(rotationalOffset)
        end

        self:WeldToSurface(true)

        return true
    end
end -- SERVER
