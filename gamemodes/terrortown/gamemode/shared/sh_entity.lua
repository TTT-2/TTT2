---
-- @ref https://wiki.facepunch.com/gmod/Entity
-- @class Entity

local entmeta = FindMetaTable("Entity")
if not entmeta then
    return
end

---
-- Checks if the entity is a ragdoll. It also makes sure it is a true ragdoll
-- by checking if it has a player nick name because ragdolls can also be used
-- for props (e.g. a mattress).
-- @return boolean Returns true if it is a true ragdoll
-- @realm shared
function entmeta:IsPlayerRagdoll()
    return self:IsRagdoll() and CORPSE.GetPlayerNick(self, nil) ~= nil
end
