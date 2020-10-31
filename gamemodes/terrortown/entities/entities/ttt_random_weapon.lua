---
-- @class ENT
-- @desc Dummy ent that just spawns a random TTT weapon and kills itself
-- @section ttt_random_weapon

local IsValid = IsValid
local math = math
local ents = ents

ENT.Type = "point"
ENT.Base = "base_point"

ENT.AutoAmmo = 0

---
-- @param string key
-- @param string|number value
-- @realm shared
function ENT:KeyValue(key, value)
	if key == "auto_ammo" then
		self.AutoAmmo = tonumber(value)
	end
end

---
-- @realm shared
function ENT:Initialize()
	local weps = ents.TTT.GetSpawnableSWEPs()
	if weps then
		local w = weps[math.random(#weps)]
		local ent = ents.Create(WEPS.GetClass(w))

		if IsValid(ent) then
			local pos = self:GetPos()

			ent:SetPos(pos)
			ent:SetAngles(self:GetAngles())
			ent:Spawn()
			ent:PhysWake()

			if ent.AmmoEnt and self.AutoAmmo > 0 then
				for i = 1, self.AutoAmmo do
					local ammo = ents.Create(ent.AmmoEnt)
					if not IsValid(ammo) then continue end

					pos.z = pos.z + 3 -- shift every box up a bit

					ammo:SetPos(pos)
					ammo:SetAngles(VectorRand():Angle())
					ammo:Spawn()
					ammo:PhysWake()
				end
			end
		end

		self:Remove()
	end
end
