function ROLE:IsSelectable(avoidHook)
	return self == INNOCENT or self == TRAITOR
	or (GetConVar("ttt_newroles_enabled"):GetBool() or self == DETECTIVE)
	and not self.notSelectable
	and GetConVar("ttt_" .. self.name .. "_enabled"):GetBool()
	and (avoidHook or not hook.Run("TTT2RoleNotSelectable", self))
end
