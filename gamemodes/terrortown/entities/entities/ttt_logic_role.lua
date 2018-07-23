ENT.Type = "point"
ENT.Base = "base_point"

local ROLE_ANY = -1

ENT.Role = ROLE_ANY

function ENT:KeyValue(key, value)
	if key == "OnPass" or key == "OnFail" then
		-- this is our output, so handle it as such
		self:StoreOutput(key, value)
	elseif key == "Role" then
		self.Role = tonumber(value)
		
		ErrorNoHalt("ttt_logic_role: the value is: " .. (value or "nil"))

		if not self.Role then
			ErrorNoHalt("ttt_logic_role: bad value for Role key, not a number\n")
			
			self.Role = ROLE_NONE
		--elseif self.Role == 3 then -- old ROLE_ANY fix
		--	self.Role = ROLE_ANY
		-- TODO check test
		elseif self.Role >= 3 then
			local rd = GetRoleByIndex(self.Role)
			
			if rd and rd.team == TEAM_TRAITOR then
				self.Role = ROLE_TRAITOR
			else
				self.Role = ROLE_INNOCENT
			end
		end
	end
end

function ENT:AcceptInput(name, activator)
	if name == "TestActivator" then
		if IsValid(activator) and activator:IsPlayer() then
			local activator_role = (GetRoundState() == ROUND_PREP) and ROLE_INNOCENT or activator:GetRole()

			if self.Role == ROLE_ANY or self.Role == activator_role then
				Dev(2, activator, "passed logic_role test of", self:GetName())
				
				self:TriggerOutput("OnPass", activator)
			else
				Dev(2, activator, "failed logic_role test of", self:GetName())
				
				self:TriggerOutput("OnFail", activator)
			end
		end

		return true
	end
end
