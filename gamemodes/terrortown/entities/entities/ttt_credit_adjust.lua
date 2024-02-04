---
-- @class ENT
-- @desc Handles player credit interactions with the map
-- @section CreditAdjust

ENT.Type = "point"
ENT.Base = "base_point"

ENT.Credits = 0

---
-- Sets Hammer key values on an entity.
-- @param string key The internal key name
-- @param string value The value to set
-- @realm server
function ENT:KeyValue(key, value)
    if key == "OnSuccess" or key == "OnFail" then
        self:StoreOutput(key, value)
    elseif key == "credits" then
        self.Credits = tonumber(value) or 0

        if not tonumber(value) then
            ErrorNoHalt(tostring(self) .. " has bad 'credits' setting.\n")
        end
    end
end

---
-- Called when another entity fires an event to this entity.
-- @param string name The name of the input that was triggered
-- @param Entity activator The initial cause for the input getting triggered; e.g. the player who pushed a button
-- @realm server
function ENT:AcceptInput(name, activator)
    if name ~= "TakeCredits" then
        return
    end

    if IsValid(activator) and activator:IsPlayer() then
        if activator:GetCredits() >= self.Credits then
            activator:SubtractCredits(self.Credits)

            self:TriggerOutput("OnSuccess", activator)
        else
            self:TriggerOutput("OnFail", activator)
        end
    end

    return true
end
