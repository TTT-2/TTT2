if SERVER then
    AddCSLuaFile()
end

DEFINE_BASECLASS("base_ammo_ttt")

ENT.Type = "anim"
ENT.Base = "base_ammo_ttt"
ENT.AmmoType = "AlyxGun"
ENT.AmmoAmount = 12
ENT.AmmoMax = 36
ENT.Model = "models/items/357ammo.mdl"
ENT.AutoSpawnable = true
ENT.spawnType = AMMO_TYPE_DEAGLE

---
-- @ignore
function ENT:Initialize()
    -- Differentiate from rifle ammo
    self:SetColor(Color(255, 100, 100, 255))

    return BaseClass.Initialize(self)
end
