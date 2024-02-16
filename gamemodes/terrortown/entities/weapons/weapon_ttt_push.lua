---
-- @class SWEP
-- @section weapon_ttt_push

if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "physgun"

if CLIENT then
    SWEP.PrintName = "newton_name"
    SWEP.Slot = 7

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.EquipMenuData = {
        type = "item_weapon",
        desc = "newton_desc",
    }

    SWEP.Icon = "vgui/ttt/icon_launch"
end

SWEP.Base = "weapon_tttbase"

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 3
SWEP.Primary.Cone = 0.005
SWEP.Primary.Sound = Sound("weapons/ar2/fire1.wav")
SWEP.Primary.SoundLevel = 54

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.5

SWEP.NoSights = true

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.WeaponID = AMMO_PUSH
SWEP.builtin = true

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_superphyscannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"

SWEP.IsCharging = false
SWEP.NextCharge = 0

local CHARGE_AMOUNT = 0.02
local CHARGE_DELAY = 0.025

local math = math

---
-- @realm shared
function SWEP:Initialize()
    if SERVER then
        self:SetSkin(1)
    end

    if CLIENT then
        self:AddTTT2HUDHelp("newton_help_primary", "newton_help_secondary")
    end

    self.IsCharging = false
    self:SetCharge(0)

    return BaseClass.Initialize(self)
end

---
-- @realm shared
function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "Charge")
end

---
-- @realm shared
function SWEP:PrimaryAttack()
    if self.IsCharging then
        return
    end

    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

    self:FirePulse(600, 300)
end

---
-- @realm shared
function SWEP:SecondaryAttack()
    if self.IsCharging then
        return
    end

    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

    self.IsCharging = true
end

---
-- @ignore
function SWEP:FirePulse(force_fwd, force_up)
    if not IsValid(self:GetOwner()) then
        return
    end

    self:GetOwner():SetAnimation(PLAYER_ATTACK1)

    sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)

    self:SendWeaponAnim(ACT_VM_IDLE)

    local cone = self.Primary.Cone or 0.1
    local num = 6

    local bullet = {}
    bullet.Num = num
    bullet.Src = self:GetOwner():GetShootPos()
    bullet.Dir = self:GetOwner():GetAimVector()
    bullet.Spread = Vector(cone, cone, 0)
    bullet.Tracer = 1
    bullet.Force = force_fwd / 10
    bullet.Damage = 1
    bullet.TracerName = "AirboatGunHeavyTracer"

    local owner = self:GetOwner()
    local fwd = force_fwd / num
    local up = force_up / num

    bullet.Callback = function(att, tr, dmginfo)
        local ply = tr.Entity
        if SERVER and IsValid(ply) and ply:IsPlayer() and (not ply:IsFrozen()) then
            local pushvel = tr.Normal * fwd

            pushvel.z = math.max(pushvel.z, up)

            ply:SetGroundEntity(nil)
            ply:SetLocalVelocity(ply:GetVelocity() + pushvel)

            ply.was_pushed = {
                att = owner,
                t = CurTime(),
                wep = self:GetClass(),
            }
        end
    end

    self:GetOwner():FireBullets(bullet)
end

local CHARGE_FORCE_FWD_MIN = 300
local CHARGE_FORCE_FWD_MAX = 700
local CHARGE_FORCE_UP_MIN = 100
local CHARGE_FORCE_UP_MAX = 350

---
-- @ignore
function SWEP:ChargedAttack()
    local charge = math.Clamp(self:GetCharge(), 0, 1)

    self.IsCharging = false
    self:SetCharge(0)

    if charge <= 0 then
        return
    end

    local max = CHARGE_FORCE_FWD_MAX
    local diff = max - CHARGE_FORCE_FWD_MIN

    local force_fwd = ((charge * diff) - diff) + max

    max = CHARGE_FORCE_UP_MAX
    diff = max - CHARGE_FORCE_UP_MIN

    local force_up = ((charge * diff) - diff) + max

    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
    self:FirePulse(force_fwd, force_up)
end

---
-- @ignore
function SWEP:PreDrop()
    self.IsCharging = false
    self:SetCharge(0)
end

---
-- @realm shared
function SWEP:OnRemove()
    BaseClass.OnRemove(self)

    self.IsCharging = false
    self:SetCharge(0)
end

---
-- @ignore
function SWEP:Deploy()
    self.IsCharging = false
    self:SetCharge(0)

    return true
end

---
-- @ignore
function SWEP:Holster()
    return not self.IsCharging
end

---
-- @ignore
function SWEP:Think()
    BaseClass.Think(self)

    if self.IsCharging and IsValid(self:GetOwner()) and self:GetOwner():IsTerror() then
        -- on client this is prediction
        if not self:GetOwner():KeyDown(IN_ATTACK2) then
            self:ChargedAttack()
            return true
        end

        if SERVER and self:GetCharge() < 1 and self.NextCharge < CurTime() then
            self:SetCharge(math.min(1, self:GetCharge() + CHARGE_AMOUNT))

            self.NextCharge = CurTime() + CHARGE_DELAY
        end
    end
end

if CLIENT then
    local surface = surface
    local TryT = LANG.TryTranslation

    ---
    -- @ignore
    function SWEP:DrawHUD()
        self:DrawHelp()

        local x = ScrW() / 2.0
        local y = ScrH() / 2.0

        local nxt = self:GetNextPrimaryFire()
        local charge = self:GetCharge()

        if LocalPlayer():IsTraitor() then
            surface.SetDrawColor(255, 0, 0, 255)
        else
            surface.SetDrawColor(0, 255, 0, 255)
        end

        if nxt < CurTime() or CurTime() % 0.5 < 0.2 or charge > 0 then
            local length = 10
            local gap = 5

            surface.DrawLine(x - length, y, x - gap, y)
            surface.DrawLine(x + length, y, x + gap, y)
            surface.DrawLine(x, y - length, x, y - gap)
            surface.DrawLine(x, y + length, x, y + gap)
        end

        if nxt > CurTime() and charge == 0 then
            local w = 40

            w = (w * (math.max(0, nxt - CurTime()) / self.Primary.Delay)) / 2

            local bx = x + 30
            surface.DrawLine(bx, y - w, bx, y + w)

            bx = x - 30
            surface.DrawLine(bx, y - w, bx, y + w)
        end

        if charge > 0 then
            y = y + (y / 3)

            local w, h = 100, 20

            surface.DrawOutlinedRect(x - w / 2, y - h, w, h, 1)

            if LocalPlayer():IsTraitor() then
                surface.SetDrawColor(255, 0, 0, 155)
            else
                surface.SetDrawColor(0, 255, 0, 155)
            end

            surface.DrawRect(x - w / 2, y - h, w * charge, h)

            surface.SetFont("TabLarge")
            surface.SetTextColor(255, 255, 255, 180)
            surface.SetTextPos((x - w / 2) + 3, y - h - 15)
            surface.DrawText(TryT("newton_force"))
        end
    end
end
