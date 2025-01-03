---
-- @class ENT
-- @section ttt_logic_role

ENT.Type = "point"
ENT.Base = "base_point"

ROLE_NONE = ROLE_NONE or 3

ENT.checkingRole = ROLE_NONE

if CLIENT then
    return
end

local IsValid = IsValid

---
-- @param string key
-- @param string|number value
-- @realm server
function ENT:KeyValue(key, value)
    if key == "OnPass" or key == "OnFail" then
        -- this is our output, so handle it as such
        self:StoreOutput(key, value)
    elseif key == "Role" then
        if isstring(value) then
            value = _G[value] or value
        end

        self.checkingRole = tonumber(value)

        if not self.checkingRole then
            ErrorNoHalt("ttt_logic_role: bad value for Role key, not a number\n")

            self.checkingRole = ROLE_NONE
        end
    end
end

---
-- Called when another entity fires an event to this entity.
-- @param string name The name of the input that was triggered
-- @param Entity|Player activator The initial cause for the input getting triggered (e.g. the player who pushed a button)
-- @param Entity caller The entity that directly triggered the input (e.g. the button that was pushed)
-- @param string data The data passed
-- @return[default=true] boolean Return true if the default action should be supressed
-- @realm server
function ENT:AcceptInput(name, activator, caller, data)
    if name == "TestActivator" then
        if not IsValid(activator) or not activator:IsPlayer() then
            return
        end

        ---
        -- @realm server
        local role, team =
            hook.Run("TTT2ModifyLogicRoleCheck", activator, self, activator, caller, data)
        local activatorRole = roles.GetByIndex(role, roles.INNOCENT):GetBaseRole()
        local activatorTeam = (gameloop.GetRoundState() == ROUND_PREP) and TEAM_INNOCENT or team

        if
            self.checkingRole == ROLE_TRAITOR and util.IsEvilTeam(activatorTeam)
            or self.checkingRole == ROLE_INNOCENT and not util.IsEvilTeam(activatorTeam)
            or self.checkingRole == activatorRole and not (self.checkingRole == ROLE_TRAITOR or self.checkingRole == ROLE_INNOCENT)
            or self.checkingRole == ROLE_NONE
        then
            Dev(2, activator, "passed logic_role test of", self:GetName())

            self:TriggerOutput("OnPass", activator)
        else
            Dev(2, activator, "failed logic_role test of", self:GetName())

            self:TriggerOutput("OnFail", activator)
        end

        return true
    end
end
