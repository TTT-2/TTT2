---
-- @author Alf21
-- @author saibotk
-- @author Minetopia
-- @class ROLE

---
-- Function that is overwritten by the role and is called on rolechange and respawn.
-- It is used to give the rolespecific loadout.
-- @param Player ply
-- @param boolean isRoleChange This is true for a rolechange, but not for a respawn
-- @realm server
function ROLE:GiveRoleLoadout(ply, isRoleChange)

end

---
-- Function that is overwritten by the role and is called on rolechange and death.
-- It is used to remove the rolespecific loadout.
-- @param Player ply
-- @param boolean isRoleChange This is true for a rolechange, but not for death
-- @realm server
function ROLE:RemoveRoleLoadout(ply, isRoleChange)

end

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
		---
		-- @realm server
		and (avoidHook or not hook.Run("TTT2RoleNotSelectable", self))
end

---
-- Returns the available amount of this role based on the given amount of available players
-- @param number ply_count amount of available players
-- @return number selectable amount of this role
-- @realm server
function ROLE:GetAvailableRoleCount(ply_count)
	if ply_count < GetConVar("ttt_" .. self.name .. "_min_players"):GetInt() then
		return 0
	end

	local maxCVar = GetConVar("ttt_" .. self.name .. "_max")
	local maxAmount = maxCVar and maxCVar:GetInt() or 1

	if maxAmount <= 1 then return 1 end

	-- get number of role members: pct of players rounded down
	local role_count = math.floor(ply_count * GetConVar("ttt_" .. self.name .. "_pct"):GetFloat())

	-- make sure there is at least 1 of the role
	return math.Clamp(role_count, 1, maxAmount)
end
