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
    return self:IsRagdoll() and CORPSE.GetPlayerNick(self, false) ~= false
end

---
-- Returns true if this entity is a default button.
-- @return boolean Returns true if default button
-- @realm shared
function entmeta:IsDefaultButton()
    return button.IsClass(self, "func_button")
end

---
-- Returns true if this entity is a rotating button (lever).
-- @return boolean Returns true if rotating button
-- @realm shared
function entmeta:IsRotatingButton()
    return button.IsClass(self, "func_rot_button")
end

---
-- Returns true if the entity is any type of button.
-- @return boolean Returns true if button
-- @realm shared
function entmeta:IsButton()
    return self:IsDefaultButton() or self:IsRotatingButton()
end

---
-- @return boolean
-- @realm server
function entmeta:IsSpecialUsableEntity()
    return self:IsWeapon()
        or self.player_ragdoll
        or self:IsPlayerRagdoll()
        or self.CanUseKey
        or self.RemoteUse
end
