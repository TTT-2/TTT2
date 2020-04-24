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

---
-- Returns the available amount of this role based on the given amount of available players
-- @param number ply_count amount of available players
-- @return number selectable amount of this role
-- @realm server
function ROLE:GetRoleCount(ply_count)
	if ply_count < GetConVar("ttt_" .. self.name .. "_min_players"):GetInt() then
		return 0
	end

	local maxCVar = GetConVar("ttt_" .. self.name .. "_max")
	local maxm = maxCVar and maxCVar:GetInt() or 1

	local role_count = 1 -- there need to be max and min 1 player of this role

	if maxm > 1 then

		-- get number of role members: pct of players rounded down
		role_count = math.floor(ply_count * GetConVar("ttt_" .. self.name .. "_pct"):GetFloat())

		-- make sure there is at least 1 of the role
		role_count = math.Clamp(role_count, 1, maxm)
	end

	return role_count
end
