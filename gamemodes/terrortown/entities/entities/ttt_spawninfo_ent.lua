---
-- @class ENT
-- @desc This entity sits at the worldspawn and contains the data of the hovered spawn
-- @section ttt_spawninfo_ent

if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "base_anim"

---
-- @realm shared
function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
end
