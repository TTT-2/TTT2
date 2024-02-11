---
-- @class ENT
-- @desc This entity sits at the worldspawn and contains the data of the hovered spawn
-- @section ttt_spawninfo_ent

if SERVER then
    AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "base_anim"

-- @realm server
function ENT:UpdateTransmitState()
    return TRANSMIT_ALWAYS
end
