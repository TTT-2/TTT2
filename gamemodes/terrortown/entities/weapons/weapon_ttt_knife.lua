---
-- @class SWEP
-- @section weapon_ttt_knife

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "knife"

if CLIENT then
    SWEP.PrintName = "knife_name"
    SWEP.Slot = 6

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.EquipMenuData = {
        type = "item_weapon",
        desc = "knife_desc",
    }

    SWEP.Icon = "vgui/ttt/icon_knife"
    SWEP.IconLetter = "j"
end

SWEP.Base = "weapon_tttbase"

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.idleResetFix = true

SWEP.Primary.Damage = 50
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 1.1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.4

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = { ROLE_TRAITOR } -- only traitors can buy
SWEP.LimitedStock = true -- only buyable once
SWEP.WeaponID = AMMO_KNIFE
SWEP.builtin = true

SWEP.IsSilent = true

-- Pull out faster than standard guns
SWEP.DeploySpeed = 2

---
-- @ignore
function SWEP:PrimaryAttack()
    local owner = self:GetOwner()

    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

    if not IsValid(owner) then
        return
    end

    owner:LagCompensation(true)

    local spos = owner:GetShootPos()
    local aim = owner:GetAimVector()
    local sdest = spos + aim * 100

    local kmins = Vector(-10, -10, -10)
    local kmaxs = Vector(10, 10, 10)

    local tr = util.TraceHull({
        start = spos,
        endpos = sdest,
        filter = owner,
        mask = MASK_SHOT_HULL,
        mins = kmins,
        maxs = kmaxs,
    })

    -- Hull might hit environment stuff that line does not hit
    if not IsValid(tr.Entity) then
        tr = util.TraceLine({
            start = spos,
            endpos = sdest,
            filter = owner,
            mask = MASK_SHOT_HULL,
        })
    end

    local hitEnt = tr.Entity

    -- effects
    if IsValid(hitEnt) then
        self:SendWeaponAnim(ACT_VM_HITCENTER)

        local edata = EffectData()
        edata:SetStart(spos)
        edata:SetOrigin(tr.HitPos)
        edata:SetNormal(tr.Normal)
        edata:SetEntity(hitEnt)

        if hitEnt:IsPlayer() or hitEnt:IsPlayerRagdoll() then
            util.Effect("BloodImpact", edata)
        end
    else
        self:SendWeaponAnim(ACT_VM_MISSCENTER)
    end

    if SERVER then
        owner:SetAnimation(PLAYER_ATTACK1)
    end

    if SERVER and tr.Hit and tr.HitNonWorld and IsValid(hitEnt) and hitEnt:IsPlayer() then
        -- knife damage is never karma'd, so don't need to take that into
        -- account we do want to avoid rounding error strangeness caused by
        -- other damage scaling, causing a death when we don't expect one, so
        -- when the target's health is close to kill-point we just kill
        if hitEnt:Health() < (self.Primary.Damage + 10) then
            self:StabKill(tr, spos, sdest)
        else
            local dmg = DamageInfo()
            dmg:SetDamage(self.Primary.Damage)
            dmg:SetAttacker(owner)
            dmg:SetInflictor(self)
            dmg:SetDamageForce(aim * 5)
            dmg:SetDamagePosition(owner:GetPos())
            dmg:SetDamageType(DMG_SLASH)

            hitEnt:DispatchTraceAttack(dmg, spos + (aim * 3), sdest)
        end
    end

    owner:LagCompensation(false)
end

---
-- @param table tr Trace
-- @param Vector spod
-- @param Vector sdest
-- @realm shared
function SWEP:StabKill(tr, spos, sdest)
    local owner = self:GetOwner()
    local target = tr.Entity

    local dmg = DamageInfo()
    dmg:SetDamage(2000)
    dmg:SetAttacker(owner)
    dmg:SetInflictor(self)
    dmg:SetDamageForce(owner:GetAimVector())
    dmg:SetDamagePosition(owner:GetPos())
    dmg:SetDamageType(DMG_SLASH)

    -- now that we use a hull trace, our hitpos is guaranteed to be
    -- terrible, so try to make something of it with a separate trace and
    -- hope our effect_fn trace has more luck

    -- first a straight up line trace to see if we aimed nicely
    local retr = util.TraceLine({
        start = spos,
        endpos = sdest,
        filter = owner,
        mask = MASK_SHOT_HULL,
    })

    -- if that fails, just trace to worldcenter so we have SOMETHING
    if retr.Entity ~= target then
        local center = target:LocalToWorld(target:OBBCenter())

        retr = util.TraceLine({
            start = spos,
            endpos = center,
            filter = owner,
            mask = MASK_SHOT_HULL,
        })
    end

    -- create knife effect creation fn
    local bone = retr.PhysicsBone
    local pos = retr.HitPos
    local norm = tr.Normal
    local ang = Angle(-28, 0, 0) + norm:Angle()

    ang:RotateAroundAxis(ang:Right(), -90)

    pos = pos - (ang:Forward() * 7)

    target.effect_fn = function(rag)
        -- we might find a better location
        local rtr = util.TraceLine({
            start = pos,
            endpos = pos + norm * 40,
            filter = owner,
            mask = MASK_SHOT_HULL,
        })

        if IsValid(rtr.Entity) and rtr.Entity == rag then
            bone = rtr.PhysicsBone
            pos = rtr.HitPos

            ang = Angle(-28, 0, 0) + rtr.Normal:Angle()
            ang:RotateAroundAxis(ang:Right(), -90)

            pos = pos - (ang:Forward() * 10)
        end

        local knife = ents.Create("prop_physics")
        knife:SetModel("models/weapons/w_knife_t.mdl")
        knife:SetPos(pos)
        knife:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        knife:SetAngles(ang)

        knife.CanPickup = false

        knife:Spawn()

        local phys = knife:GetPhysicsObject()

        if IsValid(phys) then
            phys:EnableCollisions(false)
        end

        constraint.Weld(rag, knife, bone, 0, 0, true)

        -- need to close over knife in order to keep a valid ref to it
        rag:CallOnRemove("ttt_knife_cleanup", function()
            SafeRemoveEntity(knife)
        end)
    end

    -- seems the spos and sdest are purely for effects/forces?
    target:DispatchTraceAttack(dmg, spos + (owner:GetAimVector() * 3), sdest)

    -- target appears to die right there, so we could theoretically get to
    -- the ragdoll in here...
    self:Remove()
end

---
-- @ignore
function SWEP:SecondaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

    self:SendWeaponAnim(ACT_VM_MISSCENTER)

    if CLIENT then
        return
    end

    local ply = self:GetOwner()

    if not IsValid(ply) then
        return
    end

    ply:SetAnimation(PLAYER_ATTACK1)

    local ang = ply:EyeAngles()

    if ang.p < 90 then
        ang.p = -10 + ang.p * ((90 + 10) / 90)
    else
        ang.p = 360 - ang.p
        ang.p = -10 + ang.p * -((90 + 10) / 90)
    end

    local vel = math.Clamp((90 - ang.p) * 5.5, 550, 800)
    local vfw = ang:Forward()
    local vrt = ang:Right()

    local src = ply:GetPos()
        + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset())
    src = src + (vfw * 1) + (vrt * 3)

    local thr = vfw * vel + ply:GetVelocity()

    local knife_ang = Angle(-28, 0, 0) + ang
    knife_ang:RotateAroundAxis(knife_ang:Right(), -90)

    local knife = ents.Create("ttt_knife_proj")

    if not IsValid(knife) then
        return
    end

    knife:SetPos(src)
    knife:SetAngles(knife_ang)
    knife:Spawn()
    knife:SetOwner(ply)

    knife.Damage = self.Primary.Damage

    local phys = knife:GetPhysicsObject()

    if IsValid(phys) then
        phys:SetVelocity(thr)
        phys:AddAngleVelocity(Vector(0, 1500, 0))
        phys:Wake()
    end

    self:Remove()
end

if SERVER then
    ---
    -- @ignore
    function SWEP:Equip()
        self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * 1.5)
        self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay * 1.5)
    end

    ---
    -- @ignore
    function SWEP:PreDrop()
        -- for consistency, dropped knife should not have DNA/prints
        self.fingerprints = {}
    end
end

if CLIENT then
    local TryT = LANG.TryTranslation

    ---
    -- @ignore
    function SWEP:Initialize()
        self:AddTTT2HUDHelp("knife_help_primary", "knife_help_secondary")
        return BaseClass.Initialize(self)
    end

    hook.Add("TTTRenderEntityInfo", "HUDDrawTargetIDKnife", function(tData)
        local client = LocalPlayer()
        local ent = tData:GetEntity()

        if
            not IsValid(client)
            or not client:IsTerror()
            or not client:Alive()
            or tData:GetEntityDistance() > 100
            or not ent:IsPlayer()
        then
            return
        end

        local c_wep = client:GetActiveWeapon()
        local role_color = client:GetRoleColor()

        if
            not IsValid(c_wep)
            or c_wep:GetClass() ~= "weapon_ttt_knife"
            or c_wep.Primary.Damage + 10 < ent:Health()
        then
            return
        end

        -- enable targetID rendering
        tData:EnableOutline()
        tData:SetOutlineColor(client:GetRoleColor())

        tData:AddDescriptionLine(TryT("knife_instant"), role_color)

        -- draw instant-kill maker
        local x = ScrW() * 0.5
        local y = ScrH() * 0.5

        surface.SetDrawColor(clr(role_color))

        local outer = 20
        local inner = 10

        surface.DrawLine(x - outer, y - outer, x - inner, y - inner)
        surface.DrawLine(x + outer, y + outer, x + inner, y + inner)

        surface.DrawLine(x - outer, y + outer, x - inner, y + inner)
        surface.DrawLine(x + outer, y - outer, x + inner, y - inner)
    end)
end
