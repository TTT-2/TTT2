---
-- @module Entity
-- @ref https://wiki.garrysmod.com/page/Category:Entity

local meta = FindMetaTable("Entity")
if not meta then return end

---
-- Sets the @{Entity}'s damage owner and the current time
-- @param Player ply
-- @realm server
function meta:SetDamageOwner(ply)
	self.dmg_owner = {ply = ply, t = CurTime()}
end

---
-- Returns the @{Entity}'s damge owner
-- @return Player
-- @return number the time the damage owner was set
-- @realm server
function meta:GetDamageOwner()
	if self.dmg_owner == nil then return end

	return self.dmg_owner.ply, self.dmg_owner.t
end

---
-- Returns whether an @{Entity} is explosive
-- @return boolean
-- @realm server
function meta:IsExplosive()
	local kv = self:GetKeyValues()["ExplodeDamage"]

	return self:Health() > 0 and kv and kv > 0
end
