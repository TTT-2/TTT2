---
-- @class ENT
-- @desc Map event damage owner
-- @section DamageOwner


ENT.Type = "point"
ENT.Base = "base_point"

ENT.Damager = nil
ENT.KillName = nil

function ENT:KeyValue(key, value)
	if key == "damager" then
		self.Damager = tostring(value)
	elseif key == "killname" then
		self.KillName = tostring(value)
	end
end

function ENT:AcceptInput(name, activator, caller, data)
	if name == "SetActivatorAsDamageOwner" then
		if not self.Damager then return end

		if IsValid(activator) and activator:IsPlayer() then
			local damagerEnts = ents.FindByName(self.Damager)

			for i = 1, #damagerEnts do
				local ent = damagerEnts[i]

				if not IsValid(ent) or not ent.SetDamageOwner then continue end

				ent:SetDamageOwner(activator)
				ent.ScoreName = self.KillName

				Dev(2, "Setting damageowner on", ent, ent:GetName())
			end
		end

		return true
	elseif name == "ClearDamageOwner" then
		if not self.Damager then return end

		local damagerEnts = ents.FindByName(self.Damager)

		for i = 1, #damagerEnts do
			local ent = damagerEnts[i]

			if not IsValid(ent) or not ent.SetDamageOwner then continue end

			ent:SetDamageOwner(nil)

			Dev(2, "Clearing damageowner on", ent, ent:GetName())
		end

		return true
	end
end
