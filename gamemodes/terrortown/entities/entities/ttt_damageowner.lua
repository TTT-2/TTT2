---
-- @class ENT
-- @desc Map event damage owner
-- @section DamageOwner

ENT.Type = "point"
ENT.Base = "base_point"

ENT.Damager = nil
ENT.KillName = nil

---
-- Sets Hammer key values on an entity.
-- @param string key The internal key name
-- @param string value The value to set
-- @realm server
function ENT:KeyValue(key, value)
    if key == "damager" then
        self.Damager = tostring(value)
    elseif key == "killname" then
        self.KillName = tostring(value)
    end
end

---
-- Called when another entity fires an event to this entity.
-- @param string name The name of the input that was triggered
-- @param Entity activator The initial cause for the input getting triggered; e.g. the player who pushed a button
-- @param Entity caller The entity that directly triggered the input; e.g. the button that was pushed
-- @param string data The data passed
-- @realm server
function ENT:AcceptInput(name, activator, caller, data)
    if name == "SetActivatorAsDamageOwner" then
        if not self.Damager then
            return
        end

        if IsValid(activator) and activator:IsPlayer() then
            local damagerEnts = ents.FindByName(self.Damager)

            for i = 1, #damagerEnts do
                local ent = damagerEnts[i]

                if not IsValid(ent) or not ent.SetDamageOwner then
                    continue
                end

                ent:SetDamageOwner(activator)
                ent.ScoreName = self.KillName

                Dev(2, "Setting damageowner on", ent, ent:GetName())
            end
        end

        return true
    elseif name == "ClearDamageOwner" then
        if not self.Damager then
            return
        end

        local damagerEnts = ents.FindByName(self.Damager)

        for i = 1, #damagerEnts do
            local ent = damagerEnts[i]

            if not IsValid(ent) or not ent.SetDamageOwner then
                continue
            end

            ent:SetDamageOwner(nil)

            Dev(2, "Clearing damageowner on", ent, ent:GetName())
        end

        return true
    end
end
