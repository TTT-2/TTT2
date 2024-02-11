---
-- @class EFFECT
-- @section teleport_beamup

local mat_rising = Material("models/props_combine/stasisshield_sheet")
local top = 80
local final_height = top
local vector_up = Vector(0, 0, 1)
local loopsound = Sound("ambient/levels/labs/teleport_mechanism_windup1.wav")

---
--@ignore
-- @realm client
function EFFECT:Init(data)
    self.EffectOwner = data:GetEntity()

    self:SetPos(data:GetOrigin())
    self:SetAngles(data:GetAngles())

    self.BasePos = self:GetPos()
    self.BeamDownPos = self.BasePos + Vector(0, 0, final_height)

    self.BeamDownTime = CurTime() + data:GetMagnitude()
    self.EndTime = self.BeamDownTime + data:GetRadius()
    self.DrawTop = true
    self.BeamDown = false

    if IsValid(self.EffectOwner) then
        self.Dummy = ClientsideModel(self.EffectOwner:GetModel(), RENDERGROUP_OPAQUE)
        self.Dummy:SetPos(self.BasePos)
        self.Dummy:SetAngles(self:GetAngles())
        self.Dummy:AddEffects(EF_NODRAW)

        local s = self.Dummy:LookupSequence("idle_all")
        self.Dummy:SetSequence(s)
    else
        self.Dummy = nil
    end

    sound.Play(loopsound, self:GetPos(), 50, 100)
end

---
--@ignore
-- @realm client
function EFFECT:Think()
    if self.EndTime < CurTime() then
        SafeRemoveEntity(self.Dummy)
        return
    end

    if not (IsValid(self.EffectOwner) and IsValid(self.Dummy)) then
        return false
    end

    if self.BeamDownTime >= CurTime() then
        local pos = self:GetPos()
        if pos.z - self.BasePos.z < final_height then
            pos.z = pos.z + (90 * FrameTime())
            self:SetPos(pos)
        end
    else
        -- then move to beamdown effects
        local pos = self:GetPos()
        if pos.z > self.BeamDownPos.z - final_height then
            pos.z = pos.z - (90 * FrameTime())
            self:SetPos(pos)
        else
            self.DrawTop = false
        end

        self.BeamDown = true
    end

    return true
end

---
--@ignore
-- @realm client
function EFFECT:Render()
    -- clipping positioning
    local norm = vector_up * -1
    local pos = self:GetPos()
    local dist = norm:Dot(pos)

    -- do rendering
    render.MaterialOverride(mat_rising)

    render.EnableClipping(true)
    render.PushCustomClipPlane(norm, dist)
    if not self.BeamDown then
        self.EffectOwner:DrawModel()
    else
        self.Dummy:DrawModel()
    end
    render.PopCustomClipPlane()
    render.EnableClipping(false)

    render.MaterialOverride()

    if self.DrawTop then
        render.SetMaterial(mat_rising)
        render.DrawQuadEasy(pos, vector_up, 30, 30, COLOR_RED, 0)
    end
end
