ENT.Type = "brush"
ENT.Base = "base_brush"

---
-- Called when the engine sets a value for this scripted entity.
-- @param string key The key that was affected
-- @param string value The new value
-- @realm server
function ENT:KeyValue(key, value)
	if key == "TraitorsFound" then
		-- this is our output, so handle it as such
		self:StoreOutput(key, value)
	end
end

local function VectorInside(vec, mins, maxs)
	return vec.x > mins.x and vec.x < maxs.x
		and vec.y > mins.y and vec.y < maxs.y
		and vec.z > mins.z and vec.z < maxs.z
end

---
-- Counts the amount of traitors inside the entity
-- @realm server
function ENT:CountTraitors()
	local mins = self:LocalToWorld(self:OBBMins())
	local maxs = self:LocalToWorld(self:OBBMaxs())

	local plys = player.GetAll()
	local count = 0

	for i = 1, #plys do
		local ply = plys[i]

		if not IsValid(ply) or not ply:IsActiveTraitor() or not ply:Alive()
			or not VectorInside(ply:GetPos(), mins, maxs)
		then continue end

		count = count + 1
	end

	return count
end

---
-- Called when another entity fires an event to this entity.
-- @param string name The name of the input that was triggered
-- @param Entity activator The initial cause for the input getting triggered (e.g. the player who pushed a button)
-- @param Entity caller The entity that directly triggered the input (e.g. the button that was pushed)
-- @param string data The data passed
-- @realm server
function ENT:AcceptInput(name, activator, caller, data)
	if name == "CheckForTraitor" then
		local traitorCount = self:CountTraitors()

		self:TriggerOutput("TraitorsFound", activator, traitorCount)

		return true
	end
end
