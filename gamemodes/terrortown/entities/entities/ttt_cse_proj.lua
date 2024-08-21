---
-- @class ENT
-- @desc Visualizer projective thrown in the world
-- @section CSEProj

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("ttt_base_placeable")

ENT.Base = "ttt_base_placeable"

ENT.Model = "models/Items/battery.mdl"

ENT.Range = 128
ENT.MaxScenesPerPulse = 3
ENT.SceneDuration = 10
ENT.PulseDelay = 10

ENT.pickupWeaponClass = "weapon_ttt_cse"

---
-- @realm shared
function ENT:Initialize()
    self:SetModel(self.Model)

    BaseClass.Initialize(self)

    self:SetSolid(SOLID_VPHYSICS)

    if SERVER then
        self:SetMaxHealth(50)
        self:NextThink(CurTime() + 1)
    end

    self:SetHealth(50)
end

---
-- @param Player activator
-- @realm shared
function ENT:PlayerCanPickupWeapon(activator)
    return self:GetOriginator() == activator
end

---
-- @realm shared
function ENT:GetNearbyCorpses()
    local pos = self:GetPos()

    local near = ents.FindInSphere(pos, self.Range)
    if not near then
        return
    end

    local near_corpses = {}

    for i = 1, #near do
        local ent = near[i]
        if IsValid(ent) and ent.player_ragdoll and ent.scene then
            table.insert(near_corpses, { ent = ent, dist = pos:LengthSqr() })
        end
    end

    return near_corpses
end

local scanloop = Sound("weapons/gauss/chargeloop.wav")
local dummy_keys = { "victim", "killer" }

---
-- @param Entity corpse
-- @realm shared
function ENT:ShowSceneForCorpse(corpse)
    local scene = corpse.scene
    local hit = scene.hit_trace
    local dur = self.SceneDuration

    if hit then
        -- line showing bullet trajectory
        local e = EffectData()
        e:SetEntity(corpse)
        e:SetStart(hit.StartPos)
        e:SetOrigin(hit.HitPos)
        e:SetMagnitude(hit.HitBox)
        e:SetScale(dur)

        util.Effect("crimescene_shot", e)
    end

    if not scene then
        return
    end

    for i = 1, #dummy_keys do
        local dummy_key = dummy_keys[i]
        local dummy = scene[dummy_key]

        if not dummy then
            continue
        end

        -- Horrible sins committed here to get all the data we need over the
        -- wire, the pose parameters are going to be truncated etc. but
        -- everything sort of works out. If you know a better way to get this
        -- much data to an effect, let me know.
        local e = EffectData()
        e:SetEntity(corpse)
        e:SetOrigin(dummy.pos)
        e:SetAngles(dummy.ang)
        e:SetColor(dummy.sequence)
        e:SetScale(dummy.cycle)
        e:SetStart(Vector(dummy.aim_yaw, dummy.aim_pitch, dummy.move_yaw))
        e:SetRadius(dur)

        util.Effect("crimescene_dummy", e)
    end
end

---
-- @realm shared
function ENT:StartScanSound()
    if not self.ScanSound then
        self.ScanSound = CreateSound(self, scanloop)
    end

    if not self.ScanSound:IsPlaying() then
        self.ScanSound:PlayEx(0.5, 100)
    end
end

---
-- @param number force
-- @realm shared
function ENT:StopScanSound(force)
    if self.ScanSound and self.ScanSound:IsPlaying() then
        self.ScanSound:FadeOut(0.5)
    end

    if self.ScanSound and force then
        self.ScanSound:Stop()
    end
end

---
-- @realm shared
function ENT:OnRemove()
    self:StopScanSound(true)
end

if SERVER then
    ---
    -- @realm server
    function ENT:Think()
        -- prevent starting effects when round is about to restart
        if gameloop.GetRoundState() == ROUND_POST then
            return
        end

        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

        local corpses = self:GetNearbyCorpses()
        if #corpses > self.MaxScenesPerPulse then
            table.SortByMember(corpses, "dist", true)
        end

        local e = EffectData()
        e:SetOrigin(self:GetPos())
        e:SetRadius(128)
        e:SetMagnitude(0.5)
        e:SetScale(4)
        util.Effect("pulse_sphere", e)

        -- show scenes for nearest corpses
        for i = 1, self.MaxScenesPerPulse do
            local corpse = corpses[i]

            if corpse and IsValid(corpse.ent) then
                self:ShowSceneForCorpse(corpse.ent)
            end
        end

        if #corpses > 0 then
            self:StartScanSound()
        else
            self:StopScanSound()
        end

        -- "schedule" next show pulse, return true to enable NextThink
        self:NextThink(CurTime() + self.PulseDelay)

        return true
    end
end

if CLIENT then
    local TryT = LANG.TryTranslation
    local ParT = LANG.GetParamTranslation

    local glow = Material("sprites/blueglow2")

    ---
    -- @realm client
    function ENT:DrawTranslucent()
        render.SetMaterial(glow)

        render.DrawSprite(self:LocalToWorld(self:OBBCenter()), 32, 32, COLOR_WHITE)
    end

    hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDVisualizer", function(tData)
        local client = LocalPlayer()
        local ent = tData:GetEntity()

        if
            not IsValid(client)
            or not client:IsTerror()
            or not client:Alive()
            or tData:GetEntityDistance() > 100
            or ent:GetClass() ~= "ttt_cse_proj"
        then
            return
        end

        -- enable targetID rendering
        tData:EnableText()
        tData:EnableOutline()
        tData:SetOutlineColor(client:GetRoleColor())

        tData:SetTitle(TryT("vis_name"))

        if ent:PlayerCanPickupWeapon(client) then
            tData:SetKeyBinding("+use")
            tData:SetSubtitle(ParT("target_pickup", { usekey = Key("+use", "USE") }))
        else
            tData:SetSubtitle(TryT("entity_pickup_owner_only"))
        end

        tData:AddDescriptionLine(TryT("vis_short_desc"))
    end)
end
