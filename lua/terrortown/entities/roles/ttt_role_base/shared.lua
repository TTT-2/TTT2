---
-- @module ROLE
-- @author Alf21

---
-- This function is called before initializing a @{ROLE}
-- @hook
-- @realm shared
function ROLE:PreInitialize()

end

---
-- Returns the starting credits of a @{ROLE} based on ConVar settings or default traitor settings
-- @return[default=0] number
-- @realm shared
function ROLE:GetStartingCredits()
	if self.abbr == TRAITOR.abbr then
		return GetConVar("ttt_credits_starting"):GetInt()
	end

	return ConVarExists("ttt_" .. self.abbr .. "_credits_starting") and GetConVar("ttt_" .. self.abbr .. "_credits_starting"):GetInt() or 0
end

---
-- Returns whether a @{ROLE} is able to access the shop based on ConVar settings
-- @return[default=false] boolean
-- @realm shared
function ROLE:IsShoppingRole()
	if self.subrole == ROLE_INNOCENT then
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
-- @usage -- inside of e.g. this hook:
-- @usage hook.Add("TTT2BaseRoleInit", "TTT2ConnectBaseRole" .. baserole .. "With_" .. roleData.name, ...)
-- @realm shared
function ROLE:SetBaseRole(baserole)
	if self.baserole then
		error("[TTT2][ROLE-SYSTEM][ERROR] BaseRole of " .. self.name .. " already set (" .. self.baserole .. ")!")
	else
		local br = roles.GetByIndex(baserole)

		if br.baserole then
			error("[TTT2][ROLE-SYSTEM][ERROR] Your requested BaseRole can't be any BaseRole of another SubRole because it's a SubRole as well.")

			return
		end

		self.baserole = baserole
		self.defaultTeam = br.defaultTeam

		print("[TTT2][ROLE-SYSTEM] Connected '" .. self.name .. "' subrole with baserole '" .. br.name .. "'")
	end
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

	for _, v in ipairs(roles.GetList()) do
		if v.baserole and v.baserole == br or v.index == br then
			table.insert(tmp, v)
		end
	end

	return tmp
end

if SERVER then
	---
	-- Function that is overwritten by the role and is called on rolechange and respawn.
	-- It is used to give the rolespecific loadout.
	-- @param PLAYER ply
	-- @param boolean isRoleChange This is true for a rolechange, but not for a respawn
	-- @realm server
	function ROLE:GiveRoleLoadout(ply, isRoleChange)

	end

	---
	-- Function that is overwritten by the role and is called on rolechange and death.
	-- It is used to remove the rolespecific loadout.
	-- @param PLAYER ply
	-- @param boolean isRoleChange This is true for a rolechange, but not for death
	-- @realm server
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)

	end
end
