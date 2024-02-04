if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("weapon_tttbase")

SWEP.HoldType = "ar2"

if CLIENT then
    SWEP.PrintName = "rifle_name"
    SWEP.Slot = 2

    SWEP.ViewModelFlip = false
    SWEP.ViewModelFOV = 54

    SWEP.Icon = "vgui/ttt/icon_scout"
    SWEP.IconLetter = "n"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_RIFLE
SWEP.builtin = true
SWEP.spawnType = WEAPON_TYPE_SNIPER

SWEP.Primary.Delay = 1.5
SWEP.Primary.Recoil = 7
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
SWEP.Primary.Damage = 50
SWEP.Primary.Cone = 0.005
SWEP.Primary.ClipSize = 10
SWEP.Primary.ClipMax = 20 -- keep mirrored to ammo
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Sound = Sound("Weapon_Scout.Single")

SWEP.Secondary.Sound = Sound("Default.Zoom")

SWEP.HeadshotMultiplier = 4

SWEP.AutoSpawnable = true
SWEP.Spawnable = true
SWEP.AmmoEnt = "item_ammo_357_ttt"

SWEP.UseHands = true
SWEP.ViewModel = Model("models/weapons/cstrike/c_snip_scout.mdl")
SWEP.WorldModel = Model("models/weapons/w_snip_scout.mdl")
SWEP.idleResetFix = true

SWEP.IronSightsPos = Vector(5, -15, -2)
SWEP.IronSightsAng = Vector(2.6, 1.37, 3.5)

---
-- @ignore
function SWEP:SetZoom(state)
    local owner = self:GetOwner()

    if not IsValid(owner) or not owner:IsPlayer() then
        return
    end

    if state then
        owner:SetFOV(20, 0.3)
    else
        owner:SetFOV(0, 0.2)
    end
end

---
-- @ignore
function SWEP:PrimaryAttack(worldsnd)
    BaseClass.PrimaryAttack(self, worldsnd)

    self:SetNextSecondaryFire(CurTime() + 0.1)
end

---
-- Add some zoom to ironsights for this gun
-- @ignore
function SWEP:SecondaryAttack()
    if not self.IronSightsPos or self:GetNextSecondaryFire() > CurTime() then
        return
    end

    local bIronsights = not self:GetIronsights()

    self:SetIronsights(bIronsights)
    self:SetZoom(bIronsights)

    if CLIENT then
        self:EmitSound(self.Secondary.Sound)
    end

    self:SetNextSecondaryFire(CurTime() + 0.3)
end

---
-- @ignore
function SWEP:PreDrop()
    self:SetIronsights(false)
    self:SetZoom(false)

    return BaseClass.PreDrop(self)
end

---
-- @ignore
function SWEP:Reload()
    if
        self:Clip1() == self.Primary.ClipSize
        or self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0
    then
        return
    end

    self:DefaultReload(ACT_VM_RELOAD)

    self:SetIronsights(false)
    self:SetZoom(false)
end

---
-- @ignore
function SWEP:Holster()
    self:SetIronsights(false)
    self:SetZoom(false)

    return true
end

if CLIENT then
    local scope = surface.GetTextureID("sprites/scope")

    ---
    -- @ignore
    function SWEP:DrawHUD()
        if self:GetIronsights() then
            surface.SetDrawColor(0, 0, 0, 255)

            local scrW = ScrW()
            local scrH = ScrH()

            local x = 0.5 * scrW
            local y = 0.5 * scrH
            local scope_size = scrH

            -- crosshair
            local gap = 80
            local length = scope_size

            surface.DrawLine(x - length, y, x - gap, y)
            surface.DrawLine(x + length, y, x + gap, y)
            surface.DrawLine(x, y - length, x, y - gap)
            surface.DrawLine(x, y + length, x, y + gap)

            gap = 0
            length = 50

            surface.DrawLine(x - length, y, x - gap, y)
            surface.DrawLine(x + length, y, x + gap, y)
            surface.DrawLine(x, y - length, x, y - gap)
            surface.DrawLine(x, y + length, x, y + gap)

            -- cover edges
            local sh = 0.5 * scope_size
            local w = x - sh + 2

            surface.DrawRect(0, 0, w, scope_size)
            surface.DrawRect(x + sh - 2, 0, w, scope_size)

            -- cover gaps on top and bottom of screen
            surface.DrawLine(0, 0, scrW, 0)
            surface.DrawLine(0, scrH - 1, scrW, scrH - 1)

            surface.SetDrawColor(255, 0, 0, 255)
            surface.DrawLine(x, y, x + 1, y + 1)

            -- scope
            surface.SetTexture(scope)
            surface.SetDrawColor(255, 255, 255, 255)

            surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)
        else
            return BaseClass.DrawHUD(self)
        end
    end

    ---
    -- @ignore
    function SWEP:AdjustMouseSensitivity()
        return self:GetIronsights() and 0.2 or nil
    end
end
