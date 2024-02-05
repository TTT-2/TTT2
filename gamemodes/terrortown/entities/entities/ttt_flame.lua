---
-- fire handler that does owned damage
-- @class ENT
-- @section ttt_flame

AddCSLuaFile()

ENT.Type = "anim"
ENT.Model = Model("models/weapons/w_eq_flashbang_thrown.mdl")

---
-- @accessor Player
-- @realm shared
AccessorFunc(ENT, "dmgparent", "DamageParent")

ENT.firechild = nil

ENT.real_scale = nil
ENT.fire_scale_base = 0.9
ENT.fire_scale_variance = 0.2

ENT.next_hurt = 0
ENT.hurt_interval = 1

ENT.low_detail_fps = 12
ENT.low_detail_size = 10

ENT.hurt_radius = nil
ENT.hurt_base = 5
ENT.hurt_variance = 1
ENT.hurt_radius_scale_factor = 0.4

ENT.trail = nil
ENT.trail_color = Color(255, 56, 56, 255)
ENT.trail_width = 32
ENT.trail_end_width = 0
ENT.trail_lifetime = 0.25
ENT.trail_res = 16
ENT.trail_texture = "trails/physbeam"

ENT.debug_viz = false

---
-- @realm shared
function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Burning")
    self:NetworkVar("Bool", 1, "Immobile")
    self:NetworkVar("Bool", 2, "ExplodeOnDeath")
    self:NetworkVar("Float", 0, "FlameSize")
    self:NetworkVar("Float", 1, "LifeSpan")
    self:NetworkVar("Float", 2, "DieTime")
end

---
-- @realm shared
function ENT:Initialize()
    self:SetModel(self.Model)
    self:DrawShadow(false)
    self:SetNoDraw(false)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    self:SetHealth(99999)

    if SERVER then
        self.trail = util.SpriteTrail(
            self,
            0,
            self.trail_color,
            true,
            self.trail_width,
            self.trail_end_width,
            self.trail_lifetime,
            self.trail_lifetime,
            self.trail_texture
        )
        self:DeleteOnRemove(self.trail)
    end

    self.real_scale = self:GetFlameSize()
        * (self.fire_scale_base + math.Rand(-self.fire_scale_variance, self.fire_scale_variance))
    self.hurt_radius = self.real_scale * self.hurt_radius_scale_factor

    self.next_hurt = CurTime() + self.hurt_interval + math.Rand(0, 3)

    self:SetBurning(false)

    if self:GetDieTime() == 0 then
        self:SetDieTime(CurTime() + self:GetLifeSpan())
    end
end

---
-- @realm shared
function ENT:Explode()
    local pos = self:GetPos()

    local effect = EffectData()
    effect:SetStart(pos)
    effect:SetOrigin(pos)
    effect:SetScale(256)
    effect:SetRadius(256)
    effect:SetMagnitude(50)

    util.Effect("Explosion", effect, true, true)

    local dmgowner = self:GetDamageParent()
    if not IsValid(dmgowner) then
        dmgowner = self
    end
    util.BlastDamage(self, dmgowner, pos, 300, 40)
end

if SERVER then
    ---
    -- @realm server
    function ENT:Think()
        if self:GetDieTime() < CurTime() then
            if self:GetExplodeOnDeath() then
                local success, err = pcall(self.Explode, self)

                if not success then
                    ErrorNoHaltWithStack("ERROR CAUGHT: ttt_flame: " .. err .. "\n")
                end
            end

            self:Remove()

            return
        end

        if self:WaterLevel() > 0 then
            self:SetDieTime(0)

            return
        end

        if IsValid(self.firechild) then
            if self.next_hurt < CurTime() then
                -- deal damage
                local dmg = DamageInfo()
                dmg:SetDamageType(DMG_BURN)
                dmg:SetDamage(self.hurt_base + math.random(-self.hurt_variance, self.hurt_variance))
                if IsValid(self:GetDamageParent()) then
                    dmg:SetAttacker(self:GetDamageParent())
                else
                    dmg:SetAttacker(self)
                end
                dmg:SetInflictor(self.firechild)

                gameEffects.RadiusDamage(dmg, self:GetPos(), self.hurt_radius, self)

                self.next_hurt = CurTime() + self.hurt_interval
            end

            return
        else
            if self:GetBurning() then
                -- we already were lit once, but now our child is missing
                -- we should just die, instead
                self:SetDieTime(0)
            else
                -- wait until we're still before creating a fire
                if self:GetVelocity() == Vector(0, 0, 0) then
                    self:StartFire()
                end
            end
        end
    end
end

---
-- Begins the burning effect and activates flames.
-- @realm shared
function ENT:StartFire()
    util.PaintDown(self:GetPos(), "Scorch", self)

    self.firechild = gameEffects.SpawnFire(
        self:GetPos(),
        self.real_scale,
        self:GetLifeSpan(),
        self:GetDamageParent(),
        self
    )
    self:DeleteOnRemove(self.firechild)

    self:SetBurning(true)

    if self:GetImmobile() then
        self:SetMoveType(MOVETYPE_NONE)
        local physobj = self:GetPhysicsObject()
        physobj:EnableMotion(false)
    end
end

if CLIENT then
    local flamesprites = {
        Material("particles/flamelet1"),
        Material("particles/flamelet2"),
        Material("particles/flamelet3"),
        Material("particles/flamelet4"),
        Material("particles/flamelet5"),
    }

    ---
    -- @realm client
    function ENT:Draw()
        if self:GetBurning() and self.debug_viz then
            render.DrawWireframeSphere(self:GetPos(), self.hurt_radius, 16, 9, COLOR_RED)
        elseif not self:GetBurning() then
            local frame = math.floor(
                ((SysTime() * self.low_detail_fps) + self:EntIndex()) % (#flamesprites - 1)
            ) + 1
            cam.Start3D()
            render.SetMaterial(flamesprites[frame])
            render.DrawSprite(
                self:GetPos(),
                self.low_detail_size,
                self.low_detail_size,
                color_white
            )
            cam.End3D()
        end
    end
end
