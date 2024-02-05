if SERVER then
    AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "base_ammo_ttt"
ENT.AmmoType = "SMG1"
ENT.AmmoAmount = 30
ENT.AmmoMax = 60
ENT.Model = Model("models/items/boxmrounds.mdl")
ENT.AutoSpawnable = true
ENT.spawnType = AMMO_TYPE_MAC10
