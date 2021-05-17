ENT.Type = "brush"
ENT.Base = "base_brush"

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

function ENT:AcceptInput(name, activator, caller)
	if name == "CheckForTraitor" then
		local traitorCount = self:CountTraitors()

		self:TriggerOutput("TraitorsFound", activator, traitorCount)

		return true
	end
end
