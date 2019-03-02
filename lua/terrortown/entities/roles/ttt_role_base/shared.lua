function ROLE:PreInitialize()

end

function ROLE:GetStartingCredits()
	if self.abbr == TRAITOR.abbr then
		return GetConVar("ttt_credits_starting"):GetInt()
	end

	return ConVarExists("ttt_" .. self.abbr .. "_credits_starting") and GetConVar("ttt_" .. self.abbr .. "_credits_starting"):GetInt() or 0
end

function ROLE:IsShoppingRole()
	if self.subrole == ROLE_INNOCENT then
		return false
	end

	local shopFallback = GetGlobalString("ttt_" .. self.abbr .. "_shop_fallback")

	return shopFallback ~= SHOP_DISABLED
end

function ROLE:IsBaseRole(roleData)
	return not roleData.baserole
end

-- usage: inside of e.g. this hook: hook.Add("TTT2BaseRoleInit", "TTT2ConnectBaseRole" .. baserole .. "With_" .. roleData.name, ...)
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
