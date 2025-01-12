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
function ROLE:GiveRoleLoadout(ply, isRoleChange) end

---
-- Function that is overwritten by the role and is called on rolechange and death.
-- It is used to remove the rolespecific loadout.
-- @param Player ply
-- @param boolean isRoleChange This is true for a rolechange, but not for death
-- @realm server
function ROLE:RemoveRoleLoadout(ply, isRoleChange) end

---
-- Checks whether a role is able to get selected (and maybe assigned to a @{Player}) if the round starts
-- @param boolean avoidHook should the @{hook.TTT2RoleNotSelectable} hook be ignored?
-- @return boolean
-- @return ROLEINSPECT_REASON
-- @realm server
function ROLE:IsSelectable(avoidHook)
    if self == roles.INNOCENT or self == roles.TRAITOR then
        return true, ROLEINSPECT_REASON_PASSED
    end

    if self ~= roles.DETECTIVE and not GetConVar("ttt_newroles_enabled"):GetBool() then
        return false, ROLEINSPECT_REASON_NOT_ENABLED
    end

    if self.notSelectable then
        return false, ROLEINSPECT_REASON_NOT_SELECTABLE
    end

    if not GetConVar("ttt_" .. self.name .. "_enabled"):GetBool() then
        return false, ROLEINSPECT_REASON_NOT_ENABLED
    end

    ---
    -- @realm server
    if not avoidHook and hook.Run("TTT2RoleNotSelectable", self) then
        return false, ROLEINSPECT_REASON_NOT_SELECTABLE
    end

    return true, ROLEINSPECT_REASON_PASSED
end

---
-- Returns the available amount of this role based on the given amount of available players
-- @param number ply_count amount of available players
-- @return number,ROLEINSPECT_REASON selectable amount of this role, the ROLEINSPECT_REASON the decision was made, if any
-- @realm server
function ROLE:GetAvailableRoleCount(ply_count)
    if ply_count < GetConVar("ttt_" .. self.name .. "_min_players"):GetInt() then
        return 0, ROLEINSPECT_REASON_NO_PLAYERS
    end

    local maxCVar = GetConVar("ttt_" .. self.name .. "_max")
    local maxAmount = maxCVar and maxCVar:GetInt() or 1

    if maxAmount <= 1 then
        return 1
    end

    -- get number of role members: pct of players rounded down
    local role_count = math.floor(ply_count * GetConVar("ttt_" .. self.name .. "_pct"):GetFloat())

    -- make sure there is at least 1 of the role
    return math.Clamp(role_count, 1, maxAmount), ROLEINSPECT_REASON_LOW_PROPORTION
end

-- Returns if the role can be awarded credits for a kill. Is is intended to award credits
-- for the kill of a policing role such as the detective. This function only returns the
-- state of the convar and does not check if the kill is a valid kill that would award credits.
-- @return boolean Returns true if the player can be awarded with credits
-- @realm server
function ROLE:IsAwardedCreditsForKill()
    local cv = GetConVar("ttt_" .. self.abbr .. "_credits_award_kill_enb")

    return cv and cv:GetBool() or false
end

---
-- Checks if the role can be awarded for a certain amount of players from a different team
-- being dead. This is designed to be used to award certain roles with credits if enough
-- of their enemies were killed. This function only returns the state of the convar and does
-- not check if the amount of dead players is enough such that it would award credits.
-- @return boolean Returns true if the player can be awarded with credits
-- @realm server
function ROLE:IsAwardedCreditsForPlayerDead()
    local cv = GetConVar("ttt_" .. self.abbr .. "_credits_award_dead_enb")

    return cv and cv:GetBool() or false
end

---
-- Use this hook to make a role nonselectable.
-- @param ROLE roleData The role data of the role that is considered for selection
-- @return nil|boolean Return true to cancel selection
-- @hook
-- @realm server
function GM:TTT2RoleNotSelectable(roleData) end
