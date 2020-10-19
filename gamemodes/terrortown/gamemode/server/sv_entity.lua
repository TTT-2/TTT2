---
-- @ref https://wiki.garrysmod.com/page/Category:Entity
-- @class Entity

local safeCollisionGroups = {
	[COLLISION_GROUP_WEAPON] = true
}

local entmeta = FindMetaTable("Entity")
if not entmeta then return end

---
-- Sets the @{Entity}'s damage owner and the current time
-- @param Player ply
-- @realm server
function entmeta:SetDamageOwner(ply)
	self.dmg_owner = {ply = ply, t = CurTime()}
end

---
-- Returns the @{Entity}'s damge owner
-- @return Player
-- @return number the time the damage owner was set
-- @realm server
function entmeta:GetDamageOwner()
	if self.dmg_owner == nil then return end

	return self.dmg_owner.ply, self.dmg_owner.t
end

---
-- Returns whether an @{Entity} is explosive
-- @return boolean
-- @realm server
function entmeta:IsExplosive()
	local kv = self:GetKeyValues()["ExplodeDamage"]

	return self:Health() > 0 and kv and kv > 0
end

---
-- Checks if the given entity can be passed by players.
-- @return boolean Returns if the entity is passable
-- @realm server
function entmeta:HasPassableCollisionGrup()
	return safeCollisionGroups[self:GetCollisionGroup()]
end
