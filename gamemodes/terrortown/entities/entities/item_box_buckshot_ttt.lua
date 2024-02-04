if SERVER then
    AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "base_ammo_ttt"
ENT.AmmoType = "Buckshot"
ENT.AmmoAmount = 8
ENT.AmmoMax = 24
ENT.Model = "models/items/boxbuckshot.mdl"
ENT.AutoSpawnable = true
ENT.spawnType = AMMO_TYPE_SHOTGUN
