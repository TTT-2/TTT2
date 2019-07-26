---
-- @module ROLE
-- @author Alf21

---
-- Checks whether a role is able to get selected (and maybe assigned to a @{Player}) if the round starts
-- @param boolean avoidHook should the @{hook.TTT2RoleNotSelectable} hook be ignored?
-- @return boolean
-- @realm server
function ROLE:IsSelectable(avoidHook)
	return self == INNOCENT or self == TRAITOR
	or (GetConVar("ttt_newroles_enabled"):GetBool() or self == DETECTIVE)
	and not self.notSelectable
	and GetConVar("ttt_" .. self.name .. "_enabled"):GetBool()
	and (avoidHook or not hook.Run("TTT2RoleNotSelectable", self))
end
