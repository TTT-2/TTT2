---
-- burning nade projectile
-- @class ENT
-- @section ttt_firegrenade_proj

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("ttt_basegrenade_proj")

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_flashbang_thrown.mdl")

AccessorFunc(ENT, "radius", "Radius", FORCE_NUMBER)
AccessorFunc(ENT, "dmg", "Dmg", FORCE_NUMBER)

---
-- @ignore
function ENT:Initialize()
    if not self:GetRadius() then
        self:SetRadius(256)
    end
    if not self:GetDmg() then
        self:SetDmg(25)
    end

    return BaseClass.Initialize(self)
end

---
-- @ignore
function ENT:Explode(tr)
    self:SetDetonateExact(0)

    if CLIENT then
        return
    end

    self:SetNoDraw(true)
    self:SetSolid(SOLID_NONE)

    -- pull out of the surface
    if tr.Fraction ~= 1.0 then
        self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
    end

    local pos = self:GetPos()

    if util.PointContents(pos) == CONTENTS_WATER then
        self:Remove()

        return
    end

    local effect = EffectData()
    effect:SetStart(pos)
    effect:SetOrigin(pos)
    effect:SetScale(self:GetRadius() * 0.3)
    effect:SetRadius(self:GetRadius())
    effect:SetMagnitude(self.dmg)

    if tr.Fraction ~= 1.0 then
        effect:SetNormal(tr.HitNormal)
    end

    util.PaintDown(pos, "Scorch", self)
    util.Effect("Explosion", effect, true, true)
    util.BlastDamage(self, self:GetThrower(), pos, self:GetRadius(), self:GetDmg())

    gameEffects.StartFires(pos, tr, 10, 20, false, self:GetThrower(), 500, false, 128, 2)

    self:Remove()
end
