---
-- @class ENT
-- @section ttt_logic_role

ENT.Type = "point"
ENT.Base = "base_point"

ROLE_NONE = ROLE_NONE or 3

ENT.Role = ROLE_NONE

if CLIENT then return end

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

		self.Role = tonumber(value)

		if not self.Role then
			ErrorNoHalt("ttt_logic_role: bad value for Role key, not a number\n")

			self.Role = ROLE_NONE
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
	local cv_evil_roles = GetConVar("ttt2_rolecheck_all_evil_roles")

	if name == "TestActivator" then
		if not IsValid(activator) or not activator:IsPlayer() then return end

		local activator_role = (GetRoundState() == ROUND_PREP) and ROLE_INNOCENT
			---
			-- @realm server
			or roles.GetByIndex(hook.Run("TTT2ModifyLogicCheckRole", ply, self, activator, caller, data) or ply:GetSubRole()):GetBaseRole()

		if self.Role == ROLE_TRAITOR
			and (cv_evil_roles:GetBool() and (activator_role ~= ROLE_INNOCENT or activator_role ~= ROLE_DETECTIVE)
				or not cv_evil_roles:GetBool() and (activator_role == ROLE_TRAITOR))
			or self.Role == ROLE_NONE or self.Role == activator_role
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
