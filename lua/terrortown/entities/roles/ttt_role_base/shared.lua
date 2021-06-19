---
-- @author Alf21
-- @author saibotk
-- @author Mineotopia
-- @module ROLE

ROLE.isAbstract = true

ROLE.score = {
	-- The multiplier that is used to calculate the score penalty
	-- that is added if this role kills a team member.
	teamKillsMultiplier = 0,

	-- The multiplier that is used to calculate the gained score
	-- by killing someone from a different team.
	killsMultiplier = 0,

	-- The amount of score points gained by confirming a body.
	bodyFoundMuliplier = 1,

	-- The amount of score points gained by surviving a round,
	-- based on the amount of dead enemy players.
	surviveBonusMultiplier = 0,

	-- The amount of score points granted due to a survival of the
	-- round for every teammate alive.
	aliveTeammatesBonusMultiplier = 1,

	-- Multiplier for a score for every player alive at the end of
	-- the round. Can be negative for roles that should kill everyone.
	allSurviveBonusMultiplier = 0,

	-- The amount of score points gained by being alive if the
	-- round ended with nobody winning, usually a negative number.
	timelimitMultiplier = 0,

	-- the amount of points gained by killing yourself. Should be a
	-- negative number for most roles.
	suicideMultiplier = -1
}

---
-- This function is called before initializing a @{ROLE}, but after all
-- global variables like "ROLE_TRAITOR" have been initialized.
-- Use this function to define role attributes, which is dependant on other
-- global variables (eg. from other roles).
-- This is mostly used to register the defaultTeam, shopFallback, etc...
-- @hook
-- @realm shared
function ROLE:PreInitialize()

end

---
-- This function is called after all roles have been loaded with their
-- ConVars, that are created for each role automatically, and their global
-- variables.
-- Please use this function to register your SubRole with the BaseRole, by
-- calling @{roles.SetBaseRole} and initialize any other needed data
-- (eg. @{LANG} function calls).
-- @hook
-- @realm shared
function ROLE:Initialize()

end

---
-- Returns the starting credits of a @{ROLE} based on ConVar settings or default traitor settings
-- @return[default=0] number
-- @realm shared
function ROLE:GetStartingCredits()
	if self.abbr == roles.TRAITOR.abbr then
		return GetConVar("ttt_credits_starting"):GetInt()
	end

	local cv = GetConVar("ttt_" .. self.abbr .. "_credits_starting")

	return cv and cv:GetInt() or 0
end

---
-- Returns whether a @{ROLE} is able to access the shop based on ConVar settings
-- @return[default=false] boolean
-- @realm shared
function ROLE:IsShoppingRole()
	if self.subrole == ROLE_NONE then
		return false
	end

	local shopFallback = GetGlobalString("ttt_" .. self.abbr .. "_shop_fallback")

	return shopFallback ~= SHOP_DISABLED
end

---
-- Returns whether a @{ROLE} is a BaseRole
-- @return boolean
-- @realm shared
function ROLE:IsBaseRole()
	return self.baserole == nil
end

---
-- Connects a SubRole with its BaseRole
-- @param ROLE baserole the BaseRole
-- @deprecated
-- @realm shared
function ROLE:SetBaseRole(baserole)
	print("[TTT2][DEPRECATION] ROLE:SetBaseRole will be removed in the near future! You should call roles.SetBaseRole(self, ROLENAME) in the ROLE:Initialize() function!")

	roles.SetBaseRole(self, baserole)
end

---
-- Returns the baserole of a specific @{ROLE}
-- @return number subrole id of the BaseRole (@{ROLE})
-- @realm shared
function ROLE:GetBaseRole()
	return self.baserole or self.index
end

---
-- Returns a list of subroles of this BaseRole (this subrole's BaseRole)
-- @return table list of @{ROLE}
-- @realm shared
function ROLE:GetSubRoles()
	local br = self:GetBaseRole()
	local tmp = {}
	local rlsList = roles.GetList()

	for k = 1, #rlsList do
		local v = rlsList[k]

		if v.baserole and v.baserole == br or v.index == br then
			tmp[#tmp + 1] = v
		end
	end

	return tmp
end

---
-- Returns whether a @{ROLE} can use traitor buttons
-- @return boolean
-- @realm shared
function ROLE:CanUseTraitorButton()
	local cv = GetConVar("ttt_" .. self.name .. "_traitor_button")

	return cv and cv:GetBool()
end
