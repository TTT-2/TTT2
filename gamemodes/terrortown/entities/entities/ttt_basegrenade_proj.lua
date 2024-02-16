---
-- common grenade projectile code
-- @class ENT
-- @section ttt_basegrenade_proj

if SERVER then
    AddCSLuaFile()
end

ENT.Type = "anim"

ENT.Model = "models/weapons/w_eq_flashbang_thrown.mdl"

AccessorFunc(ENT, "thrower", "Thrower")

---
-- @ignore
function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "ExplodeTime")
end

---
-- @ignore
function ENT:Initialize()
    self:SetModel(self.Model)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

    if SERVER then
        self:SetExplodeTime(0)
    end
end

---
-- @ignore
function ENT:SetDetonateTimer(length)
    self:SetDetonateExact(CurTime() + length)
end

---
-- @ignore
function ENT:SetDetonateExact(t)
    self:SetExplodeTime(t or CurTime())
end

---
-- override to describe what happens when the nade explodes
-- @ignore
function ENT:Explode(tr)
    ErrorNoHaltWithStack("ERROR: BaseGrenadeProjectile explosion code not overridden!\n")
end

---
-- @ignore
function ENT:Think()
    local etime = self:GetExplodeTime() or 0
    if etime ~= 0 and etime < CurTime() then
        -- if thrower disconnects before grenade explodes, just don't explode
        if SERVER and (not IsValid(self:GetThrower())) then
            self:Remove()
            etime = 0
            return
        end

        -- find the ground if it's near and pass it to the explosion
        local spos = self:GetPos()
        local tr = util.TraceLine({
            start = spos,
            endpos = spos + Vector(0, 0, -32),
            mask = MASK_SHOT_HULL,
            filter = self.thrower,
        })

        local success, err = pcall(self.Explode, self, tr)
        if not success then
            -- prevent effect spam on Lua error
            self:Remove()
            ErrorNoHaltWithStack("ERROR CAUGHT: ttt_basegrenade_proj: " .. err .. "\n")
        end
    end
end
