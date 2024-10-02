---
-- @class SWEP
-- @desc Common code for all types of grenade
-- @section weapon_tttbasegrenade

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldReady = "grenade"
SWEP.HoldNormal = "slam"

if CLIENT then
    SWEP.PrintName = "Incendiary grenade"
    SWEP.Instructions = "Burn."
    SWEP.Slot = 3

    SWEP.ViewModelFlip = true

    SWEP.Icon = "vgui/ttt/icon_nades"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel = "models/weapons/w_eq_flashbang.mdl"

SWEP.Weight = 5
SWEP.AutoSwitchFrom = true
SWEP.NoSights = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Kind = WEAPON_NADE
SWEP.IsGrenade = true

SWEP.was_thrown = false
SWEP.detonate_timer = 5
SWEP.DeploySpeed = 1.5
SWEP.throwForce = 1

---
-- @accessor number
-- @realm shared
AccessorFunc(SWEP, "det_time", "DetTime")

---
-- @accessor number
-- @realm shared
AccessorFunc(SWEP, "pull_time", "PullTime", FORCE_NUMBER)

---
-- @realm server
local cvNadeThrowDuringPrep =
    CreateConVar("ttt_nade_throw_during_prep", "0", { FCVAR_ARCHIVE, FCVAR_NOTIFY })

---
-- @ignore
function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "Pin")
    self:NetworkVar("Int", 0, "ThrowTime")
end

---
-- @ignore
function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    if gameloop.GetRoundState() == ROUND_PREP and not cvNadeThrowDuringPrep:GetBool() then
        return
    end

    self:PullPin()
end

---
-- @ignore
function SWEP:SecondaryAttack() end

---
-- @param Vector currentIterationPosition The initial position for this iteration cycle.
-- @param number launchVelocity The launch velocity for this iteration cycle.
-- @param number stepDistance The step size for the current iteration cycle.
-- @return Vector The next location to iterate from.
local function PositionFromPhysicsParams(currentIterationPosition, launchVelocity, stepDistance)
    local activeGravity = physenv.GetGravity()

    return currentIterationPosition
        + (launchVelocity * stepDistance + 0.5 * activeGravity * stepDistance ^ 2)
end

if CLIENT then
    ---
    -- @realm client
    local cvEnableTrajectoryUI = CreateConVar("ttt2_grenade_trajectory_ui", 0, FCVAR_ARCHIVE)

    local cvCrosshairOpacity = GetConVar("ttt_crosshair_opacity")

    local function AlphaLerp(from, frac, max)
        local fr = frac ^ 0.5
        return ColorAlpha(from, Lerp(fr, 0, math.min(max, 255)))
    end

    ---
    -- @param Player ply
    -- @realm client
    function SWEP:DrawDefaultThrowPath(ply)
        local stepSize = 0.005

        local owner = self:GetOwner()

        local currentIterationPosition, _ =
            self:GetViewModelPosition(owner:EyePos(), owner:EyeAngles())
        local launchPosition, launchVelocity = self:GetThrowVelocity()
        currentIterationPosition = currentIterationPosition - ply:EyePos() + launchPosition
        local previousIterationPosition =
            PositionFromPhysicsParams(currentIterationPosition, launchVelocity, stepSize)

        local fractionalFrameTime = (SysTime() % 1) * 2
        local i = fractionalFrameTime > 1 and 1 or 0
        fractionalFrameTime = fractionalFrameTime - math.floor(fractionalFrameTime)

        local arcColor = appearance.ShouldUseGlobalFocusColor() and appearance.GetFocusColor()
            or self:GetOwner():GetRoleColor()
        local arcAlpha = math.Round(cvCrosshairOpacity:GetFloat() * 255)
        local arcWidth = 0.6
        local arcWidthDiminishOverDistanceFactor = 0.25
        local arcSegmentLengthFactor = 0.5
        local arcImpactCrossLength = 1

        render.SetColorMaterial()
        cam.Start3D(EyePos(), EyeAngles())

        for stepDistance = stepSize * 2, 1, stepSize do
            local drawColor = AlphaLerp(arcColor, stepDistance, arcAlpha)

            local pos =
                PositionFromPhysicsParams(currentIterationPosition, launchVelocity, stepDistance)
            local t = util.TraceLine({
                start = previousIterationPosition,
                endpos = pos,
                filter = { ply, self },
            })

            local from = previousIterationPosition
            local to = t.Hit and t.HitPos or pos
            local norm = to - from
            norm:Normalize()

            local denom = (stepDistance / stepSize) ^ arcWidthDiminishOverDistanceFactor
            local arcSegmentLength = from:DistToSqr(to) ^ arcSegmentLengthFactor

            i = (i + 1) % 2

            if i == 0 then
                render.DrawBeam(
                    from,
                    from + norm * (fractionalFrameTime * arcSegmentLength),
                    arcWidth * denom,
                    0,
                    1,
                    drawColor
                )
            else
                render.DrawBeam(
                    to - norm * ((1 - fractionalFrameTime) * arcSegmentLength),
                    to,
                    arcWidth * denom,
                    0,
                    1,
                    drawColor
                )
            end

            if t.Hit then
                local hitPosition = t.HitPos + t.HitNormal * (t.FractionLeftSolid * denom)
                local impactCrossSegmentLength = arcImpactCrossLength * denom
                local impactCrossVector = Vector(0, 0, impactCrossSegmentLength)

                local angleLeft = Angle(t.HitNormal:Angle())
                angleLeft:RotateAroundAxis(t.HitNormal, -45)

                local left = Vector(impactCrossVector)
                left:Rotate(angleLeft)

                render.DrawBeam(
                    hitPosition - (left * impactCrossSegmentLength),
                    hitPosition + left * impactCrossSegmentLength,
                    arcWidth * denom,
                    0,
                    1,
                    drawColor
                )

                local angleUp = Angle(t.HitNormal:Angle())
                angleUp:RotateAroundAxis(t.HitNormal, 45)

                local up = Vector(impactCrossVector)
                up:Rotate(angleUp)

                render.DrawBeam(
                    hitPosition - (up * impactCrossSegmentLength),
                    hitPosition + up * impactCrossSegmentLength,
                    arcWidth * denom,
                    0,
                    1,
                    drawColor
                )

                break
            end

            previousIterationPosition = pos
        end

        cam.End3D()
    end

    ---
    -- @param Entity vm
    -- @param Weapon weapon
    -- @param Player ply
    -- @realm client
    function SWEP:PostDrawViewModel(vm, weapon, ply)
        if cvEnableTrajectoryUI:GetBool() then
            self:DrawDefaultThrowPath(ply)
        end
    end
end

---
-- @ignore
function SWEP:PullPin()
    if self:GetPin() then
        return
    end

    local ply = self:GetOwner()
    if not IsValid(ply) then
        return
    end

    self:SendWeaponAnim(ACT_VM_PULLPIN)

    if self.SetHoldType then
        self:SetHoldType(self.HoldReady)
    end

    self:SetPin(true)
    self:SetPullTime(CurTime())

    self:SetDetTime(CurTime() + self.detonate_timer)
end

---
-- @ignore
function SWEP:Think()
    BaseClass.Think(self)

    local ply = self:GetOwner()

    if not IsValid(ply) then
        return
    end

    -- pin pulled and attack loose = throw
    if self:GetPin() then
        -- we will throw now
        if not ply:KeyDown(IN_ATTACK) then
            self:StartThrow()

            self:SetPin(false)
            self:SendWeaponAnim(ACT_VM_THROW)

            if SERVER then
                ply:SetAnimation(PLAYER_ATTACK1)
            end
        else
            -- still cooking it, see if our time is up
            if SERVER and self:GetDetTime() < CurTime() then
                self:BlowInFace()
            end
        end
    elseif self:GetThrowTime() > 0 and self:GetThrowTime() < CurTime() then
        self:Throw()
    end
end

---
-- @ignore
function SWEP:BlowInFace()
    local ply = self:GetOwner()

    if not IsValid(ply) then
        return
    end

    if self.was_thrown then
        return
    end

    self.was_thrown = true

    -- drop the grenade so it can immediately explode

    local ang = ply:GetAngles()
    local src = ply:GetPos()
        + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset())
    src = src + (ang:Right() * 10)

    self:CreateGrenade(src, Angle(0, 0, 0), Vector(0, 0, 1), Vector(0, 0, 1), ply)

    self:SetThrowTime(0)
    self:Remove()
end

---
-- @ignore
function SWEP:StartThrow()
    self:SetThrowTime(CurTime() + 0.1)
end

---
-- @return Vector, Vector The point of origin for the thrown projectile, and its force.
-- @realm shared
function SWEP:GetThrowVelocity()
    local ply = self:GetOwner()
    local ang = ply:EyeAngles()
    local src = ply:GetPos()
        + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset())
        + (ang:Forward() * 8)
        + (ang:Right() * 10)

    local target = ply:GetEyeTraceNoCursor().HitPos

    -- A target angle to actually throw the grenade to the crosshair instead of forwards
    local tang = (target - src):Angle()

    -- Makes the grenade go upwards
    if tang.p < 90 then
        tang.p = -10 + tang.p * ((90 + 10) / 90)
    else
        tang.p = 360 - tang.p
        tang.p = -10 + tang.p * -((90 + 10) / 90)
    end

    -- Makes the grenade not go backwards :/
    tang.p = math.Clamp(tang.p, -90, 90)

    local vel = math.min(800, (90 - tang.p) * 6)
    local force = tang:Forward() * vel * self.throwForce + ply:GetVelocity()

    return src, force
end

---
-- @ignore
function SWEP:Throw()
    if CLIENT then
        self:SetThrowTime(0)
    elseif SERVER then
        local ply = self:GetOwner()

        if not IsValid(ply) then
            return
        end

        if self.was_thrown then
            return
        end

        self.was_thrown = true

        local src, force = self:GetThrowVelocity()
        self:CreateGrenade(
            src,
            Angle(0, 0, 0),
            force,
            Vector(600, math.random(-1200, 1200), 0),
            ply
        )

        self:SetThrowTime(0)
        self:Remove()
    end
end

---
-- Subclasses must override with their own grenade ent.
-- @realm shared
function SWEP:GetGrenadeName()
    ErrorNoHaltWithStack(
        "SWEP BASEGRENADE ERROR: GetGrenadeName not overridden! This is probably wrong!\n"
    )

    return "ttt_firegrenade_proj"
end

---
-- @ignore
function SWEP:CreateGrenade(src, ang, vel, angimp, ply)
    local gren = ents.Create(self:GetGrenadeName())

    if not IsValid(gren) then
        return
    end

    gren:SetPos(src)
    gren:SetAngles(ang)
    gren:SetOwner(ply)
    gren:SetThrower(ply)
    gren:SetElasticity(0.45)
    gren:Spawn()

    local phys = gren:GetPhysicsObject()

    if IsValid(phys) then
        phys:Wake()
        phys:SetVelocity(vel)
        phys:AddAngleVelocity(angimp)
    end

    -- This has to happen AFTER Spawn() calls gren's Initialize()
    gren:SetDetonateExact(self:GetDetTime())

    return gren
end

---
-- @ignore
function SWEP:PreDrop()
    -- If owner dies or drops us while the pin has been pulled, create the armed
    -- grenade anyway
    if self:GetPin() then
        self:BlowInFace()
    end
end

---
-- @ignore
function SWEP:Deploy()
    if self.SetHoldType then
        self:SetHoldType(self.HoldNormal)
    end

    self:SetThrowTime(0)
    self:SetPin(false)

    return true
end

---
-- @ignore
function SWEP:Holster()
    if self:GetPin() then
        return false -- no switching after pulling pin
    end

    self:SetThrowTime(0)
    self:SetPin(false)

    return true
end

---
-- @ignore
function SWEP:Reload()
    return false
end

---
-- @ignore
function SWEP:Initialize()
    if self.SetHoldType then
        self:SetHoldType(self.HoldNormal)
    end

    self:SetDeploySpeed(self.DeploySpeed)
    self:SetDetTime(0)
    self:SetPullTime(0)
    self:SetThrowTime(0)
    self:SetPin(false)

    self.was_thrown = false
end

if CLIENT then
    local draw = draw
    local TryT = LANG.TryTranslation
    local hudTextColor = Color(255, 255, 255, 180)

    ---
    -- @ignore
    function SWEP:DrawHUD()
        if self.HUDHelp then
            self:DrawHelp()
        end

        local x = ScrW() * 0.5
        local y = ScrH() * 0.5

        local pulltime = self:GetPullTime()

        if self:GetPin() and pulltime and pulltime > 0 then
            local client = LocalPlayer()

            y = y + (y / 3)

            local pct = 1
                - math.Clamp((CurTime() - pulltime) / (self:GetDetTime() - pulltime), 0, 1)

            local scale = appearance.GetGlobalScale()
            local w, h = 100 * scale, 20 * scale
            local drawColor = appearance.SelectFocusColor(client:GetRoleColor())

            draw.AdvancedText(
                TryT("grenade_fuse"),
                "PureSkinBar",
                x - 0.5 * w,
                y - h,
                hudTextColor,
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_BOTTOM,
                true,
                scale
            )
            draw.Box(x - w / 2 + scale, y - h + scale, w * pct, h, COLOR_BLACK)
            draw.OutlinedShadowedBox(x - w / 2, y - h, w, h, scale, drawColor)
            draw.Box(x - w / 2, y - h, w * pct, h, drawColor)
        else
            self:DoDrawCrosshair(x, y, true)
        end
    end
end
