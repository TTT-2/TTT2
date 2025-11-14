---
-- @class ENT
-- @section ttt_filter_role

ENT.Type = "filter"
ENT.Base = "base_filter"

ROLE_NONE = ROLE_NONE or 3

ENT.checkingRole = ROLE_NONE

if CLIENT then
    return
end

---
-- @param string key
-- @param string|number value
-- @realm server
function ENT:KeyValue(key, value)
    if key == "Role" then
        if isstring(value) then
            value = _G[value] or value
        end

        self.checkingRole = tonumber(value)

        if not self.checkingRole then
            ErrorNoHalt("ttt_filter_role: bad value for Role key, not a number\n")

            self.checkingRole = ROLE_NONE
        end
    end
end

---
-- @param Entity caller
-- @param Entity activator
-- @realm server
function ENT:PassesFilter(caller, activator)
    if not IsValid(activator) or not activator:IsPlayer() then
        return
    end

    ---
    -- @realm server
    local activatorRole = activator:GetSubRole()

    if self.checkingRole == activatorRole then
        Dev(2, activator, "passed filter_role test of", self:GetName())
        return true
    end

    Dev(2, activator, "failed filter_role test of", self:GetName())

    return false
end
