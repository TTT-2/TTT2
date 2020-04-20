-- Localize stuff we use often. It's like Lua go-faster stripes.
local math = math
local table = table
local player = player
local pairs = pairs
local IsValid = IsValid
local ConVarExists = ConVarExists
local CreateConVar = CreateConVar
local hook = hook

local strTmp = ""

PLYFORCEDROLES = {}
PLYFINALROLES = {}
SELECTABLEROLES = nil

-- innos min pct
local cv_ttt_min_inno_pct = CreateConVar("ttt_min_inno_pct", "0.47", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Minimum multiplicator for each player to calculate the minimum amount of innocents")
local cv_ttt_max_roles = CreateConVar("ttt_max_roles", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different roles")
local cv_ttt_max_roles_pct =  CreateConVar("ttt_max_roles_pct", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different roles based on player amount. ttt_max_roles needs to be 0")
local cv_ttt_max_baseroles = CreateConVar("ttt_max_baseroles", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different baseroles")
local cv_ttt_max_baseroles_pct = CreateConVar("ttt_max_baseroles_pct", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different baseroles based on player amount. ttt_max_baseroles needs to be 0")

local function GetEachRoleCount(ply_count, role_type)
	if role_type == INNOCENT.name then
		return math.floor(ply_count * cv_ttt_min_inno_pct:GetFloat()) or 0
	end

	if ply_count < GetConVar("ttt_" .. role_type .. "_min_players"):GetInt() then
		return 0
	end

	-- get number of role members: pct of players rounded down
	local role_count = math.floor(ply_count * GetConVar("ttt_" .. role_type .. "_pct"):GetFloat())
	local maxm = 1

	strTmp = "ttt_" .. role_type .. "_max"

	if ConVarExists(strTmp) then
		maxm = GetConVar(strTmp):GetInt()
	end

	if maxm > 1 then
		-- make sure there is at least 1 of the role
		role_count = math.Clamp(role_count, 1, maxm)
	else
		-- there need to be max and min 1 player of this role
		--role_count = math.Clamp(role_count, 1, 1)
		role_count = 1
	end

	return role_count
end

---
-- Returns the amount of pre selected @{ROLE}s
-- @param number subrole subrole id of a @{ROLE}'s index
-- @return number amount
-- @realm server
function GetPreSelectedRole(subrole)
	local tmp = 0

	if GetRoundState() == ROUND_ACTIVE then
		local plys = player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			if not IsValid(ply) or ply:GetForceSpec() or ply:GetSubRole() ~= subrole then continue end

			tmp = tmp + 1
		end
	elseif PLYFINALROLES then
		for ply, sr in pairs(PLYFINALROLES) do
			if sr == subrole then
				tmp = tmp + 1
			end
		end
	end

	return tmp
end

local function AddAvailableRoles(roleData, tbl, iTbl, forced, max_plys)
	local b = true

	if not forced then
		strTmp = "ttt_" .. roleData.name .. "_random"

		local r = ConVarExists(strTmp) and GetConVar(strTmp):GetInt() or 0

		if r <= 0 then
			b = false
		elseif r < 100 then
			b = math.random(100) <= r
		end
	end

	if b then
		local tmp2 = GetEachRoleCount(max_plys, roleData.name) - GetPreSelectedRole(roleData.index)
		if tmp2 > 0 then
			tbl[roleData] = tmp2
			iTbl[#iTbl + 1] = roleData
		end
	end
end

---
-- Returns all selectable @{ROLE}s based on the amount of @{Player}s
-- @note This @{function} automatically saves the selectable @{ROLE}s for the current round
-- @param table plys list of @{Player}s
-- @param number max_plys amount of maximum @{Player}s
-- @return table a list of all selectable @{ROLE}s
-- @realm server
function GetSelectableRoles(plys, max_plys)
	if not plys then
		local tmp = {}
		local allPlys = player.GetAll()

		for i = 1, #allPlys do
			local v = allPlys[i]

			-- everyone on the spec team is in specmode
			if IsValid(v) and not v:GetForceSpec() and (not plys or table.HasValue(plys, v)) and not hook.Run("TTT2DisableRoleSelection", v) then
				tmp[#tmp + 1] = v
			end
		end

		plys = tmp
	end

	max_plys = max_plys or #plys

	if max_plys < 2 then return end

	if SELECTABLEROLES then
		return SELECTABLEROLES
	end

	local selectableRoles = {
		[INNOCENT] = GetEachRoleCount(max_plys, INNOCENT.name) - GetPreSelectedRole(ROLE_INNOCENT),
		[TRAITOR] = GetEachRoleCount(max_plys, TRAITOR.name) - GetPreSelectedRole(ROLE_TRAITOR)
	}

	local newRolesEnabled = GetConVar("ttt_newroles_enabled"):GetBool()
	local forcedRolesTbl = {}

	for id, subrole in pairs(PLYFORCEDROLES) do
		forcedRolesTbl[subrole] = true
	end

	local tmpTbl = {}
	local iTmpTbl = {}
	local checked = {}
	local rlsList = roles.GetList()

	for i = 1, #rlsList do
		local v = rlsList[i]

		if checked[v.index] then continue end

		checked[v.index] = true

		if v ~= INNOCENT and v ~= TRAITOR and (newRolesEnabled or v == DETECTIVE) and v:IsSelectable() then

			-- at first, check for baserole availibility
			if v.baserole and v.baserole ~= ROLE_INNOCENT and v.baserole ~= ROLE_TRAITOR then
				local rd = roles.GetByIndex(v.baserole)

				if not checked[v.baserole] then
					checked[v.baserole] = true

					AddAvailableRoles(v, tmpTbl, iTmpTbl, forcedRolesTbl[v.baserole], max_plys)
				end

				-- continue if baserole is not available
				local base_count = tmpTbl[rd]
				if not base_count or base_count < 1 then
					continue
				end
			end

			-- now check for subrole availability
			AddAvailableRoles(v, tmpTbl, iTmpTbl, forcedRolesTbl[v.index], max_plys)
		end
	end

	local roles_count = 2
	local baseroles_count = 2

	-- yea it begins
	local max_roles = cv_ttt_max_roles:GetInt()
	if max_roles == 0 then
		max_roles = math.floor(cv_ttt_max_roles_pct:GetFloat() * max_plys)
		if max_roles == 0 then
			max_roles = nil
		end
	end

	-- damn, not again
	local max_baseroles = cv_ttt_max_baseroles:GetInt()
	if max_baseroles == 0 then
		max_baseroles = math.floor(cv_ttt_max_baseroles_pct:GetFloat() * max_plys)
		if max_baseroles == 0 then
			max_baseroles = nil
		end
	end

	for i = 1, #iTmpTbl do
		if max_roles and roles_count >= max_roles then break end

		local rnd = math.random(#iTmpTbl)
		local v = iTmpTbl[rnd]

		table.remove(iTmpTbl, rnd)

		if v.baserole then
			local br = roles.GetByIndex(v.baserole)

			if not selectableRoles[br] then
				if max_baseroles and baseroles_count >= max_baseroles then continue end

				selectableRoles[br] = tmpTbl[br]
				roles_count = roles_count + 1
				baseroles_count = baseroles_count + 1

				if max_roles and roles_count >= max_roles then break end
			end
		end

		if not selectableRoles[v] then
			selectableRoles[v] = tmpTbl[v]
			roles_count = roles_count + 1

			if not v.baserole then
				baseroles_count = baseroles_count + 1
			end
		end
	end

	SELECTABLEROLES = selectableRoles

	return selectableRoles
end

local function SetRoleTypes(choices, prev_roles, roleCount, availableRoles, defaultRole)
	local choices_i = #choices
	local availableRoles_i = #availableRoles

	while choices_i > 0 and availableRoles_i > 0 do
		local pick = math.random(choices_i)
		local pply = choices[pick]

		if IsValid(pply) then
			local vpick = math.random(availableRoles_i)
			local v = availableRoles[vpick]
			local type_count = roleCount[v.index]

			strTmp = "ttt_" .. v.name .. "_karma_min"

			local min_karmas = ConVarExists(strTmp) and GetConVar(strTmp):GetInt() or 0

			-- if player was last round innocent, he will be another role (if he has enough karma)
			if choices_i <= type_count or (
				pply:GetBaseKarma() > min_karmas
				and table.HasValue(prev_roles[ROLE_INNOCENT], pply)
				and not pply:GetAvoidRole(v.index)
				or math.random(3) == 2
			) then
				PLYFINALROLES[pply] = PLYFINALROLES[pply] or v.index

				table.remove(choices, pick)

				choices_i = choices_i - 1
				type_count = type_count - 1
				roleCount[v.index] = type_count

				if type_count <= 0 then
					table.remove(availableRoles, vpick)

					availableRoles_i = availableRoles_i - 1
				end
			end
		end
	end

	if defaultRole then
		for i = 1, #choices do
			local ply = choices[i]

			PLYFINALROLES[ply] = PLYFINALROLES[ply] or defaultRole
		end
	end
end

local function SelectForcedRoles(max_plys, roleCount, allSelectableRoles, choices)
	local transformed = {}

	for id, subrole in pairs(PLYFORCEDROLES) do
		local ply = player.GetByUniqueID(id)

		if not IsValid(ply) then
			PLYFORCEDROLES[id] = nil
		else
			transformed[subrole] = transformed[subrole] or {}
			transformed[subrole][#transformed[subrole] + 1] = ply
		end
	end

	for subrole, ps in pairs(transformed) do
		local rd = roles.GetByIndex(subrole)

		if table.HasValue(allSelectableRoles, rd) then
			local role_count = roleCount[subrole]
			local c = 0
			local a = #ps

			for i = 1, a do
				local pick = math.random(#ps)
				local ply = ps[pick]

				if c >= role_count then break end

				table.remove(transformed[subrole], pick)

				PLYFORCEDROLES[ply:UniqueID()] = nil
				PLYFINALROLES[ply] = PLYFINALROLES[ply] or subrole
				c = c + 1

				for k = 1, #choices do
					if choices[k] ~= ply then continue end

					table.remove(choices, k)
				end

				hook.Run("TTT2ReceivedForcedRole", ply, rd, true)
			end
		end
	end

	for id, subrole in pairs(PLYFORCEDROLES) do
		local ply = player.GetByUniqueID(id)
		local rd = roles.GetByIndex(subrole)

		hook.Run("TTT2ReceivedForcedRole", ply, rd, false)
	end

	PLYFORCEDROLES = {}
end

local function UpgradeRoles(plys, prev_roles, roleCount, selectableRoles, roleData)
	if roleData == INNOCENT or roleData == TRAITOR or roleData == DETECTIVE or GetConVar("ttt_newroles_enabled"):GetBool() then
		local availableRoles = {}

		-- now upgrade this role if there are other subroles
		for v in pairs(selectableRoles) do
			if v.baserole == roleData.index then
				availableRoles[#availableRoles + 1] = v
			end
		end

		SetRoleTypes(plys, prev_roles, roleCount, availableRoles, roleData.index)
	end
end

local function SelectBaseRole(choices, prev_roles, roleCount, roleData)
	local rs = 0
	local ls = {}

	while rs < roleCount[roleData.index] and #choices > 0 do
		-- select random index in choices table
		local pick = math.random(#choices)

		-- the player we consider
		local pply = choices[pick]

		strTmp = "ttt_" .. roleData.name .. "_karma_min"

		local min_karmas = ConVarExists(strTmp) and GetConVar(strTmp):GetInt() or 0

		-- give this guy the role if he was not this role last time, or if he makes
		-- a roll
		if IsValid(pply) and (
			roleData == INNOCENT or (
				#choices <= roleCount[roleData.index] or (
					pply:GetBaseKarma() > min_karmas
					and table.HasValue(prev_roles[ROLE_INNOCENT], pply)
					and not pply:GetAvoidRole(roleData.index)
					or math.random(3) == 2
				)
			)
		) then
			table.remove(choices, pick)

			ls[#ls + 1] = pply
			rs = rs + 1
		end
	end

	return ls
end

---
-- Select selectable @{ROLE}s for a given list of @{Player}s
-- @note This automatically synces with every connected @{Player}
-- @param table plys list of @{Player}s
-- @param number max_plys amount of maximum @{Player}s
-- @realm server
function SelectRoles(plys, max_plys)
	local choices = {}
	local prev_roles = {}
	local tmp = {}

	GAMEMODE.LastRole = GAMEMODE.LastRole or {}

	local allPlys = player.GetAll()

	for i = 1, #allPlys do
		local v = allPlys[i]

		-- everyone on the spec team is in specmode
		if not v:GetForceSpec() and (not plys or table.HasValue(plys, v)) and not hook.Run("TTT2DisableRoleSelection", v) then
			if not plys then
				tmp[#tmp + 1] = v
			end

			-- save previous role and sign up as possible traitor/detective
			local r = GAMEMODE.LastRole[v:SteamID64()] or v:GetSubRole() or ROLE_INNOCENT

			prev_roles[r] = prev_roles[r] or {}
			prev_roles[r][#prev_roles[r] + 1] = v
			choices[#choices + 1] = v
		end
	end

	plys = plys or tmp
	max_plys = max_plys or #plys

	if max_plys < 2 then return end

	local roleCount = {}
	local selectableRoles = GetSelectableRoles(plys, max_plys) -- update SELECTABLEROLES table

	hook.Run("TTT2ModifySelectableRoles", selectableRoles)

	local rlsList = roles.GetList()

	for i = 1, #rlsList do
		local v = rlsList[i]

		roleCount[v.index] = selectableRoles[v] or 0
	end

	SelectForcedRoles(max_plys, roleCount, selectableRoles, choices)

	-- first select traitors, then innos, then the other roles
	local list = {
		[1] = TRAITOR,
		[2] = INNOCENT
	}

	local tmpTbl = {}

	-- get selectable baseroles (except traitor and innocent)
	for i = 1, #rlsList do
		local v = rlsList[i]

		if v == TRAITOR or v == INNOCENT or table.HasValue(tmpTbl, v) or not selectableRoles[v] or v.baserole then continue end

		tmpTbl[#tmpTbl + 1] = v
	end

	-- randomize order of custom roles, but keep traitor as first and innocent as second
	for i = 1, #tmpTbl do
		local rnd = math.random(#tmpTbl)

		list[#list + 1] = tmpTbl[rnd]

		table.remove(tmpTbl, rnd)
	end

	for i = 1, #list do
		local roleData = list[i]

		if #choices == 0 then break end

		-- if roleData == INNOCENT then just remove the random ply from choices
		local ls = SelectBaseRole(choices, prev_roles, roleCount, roleData)

		-- upgrade innos and players without any role later
		if roleData ~= INNOCENT then
			UpgradeRoles(ls, prev_roles, roleCount, selectableRoles, roleData)
		end
	end

	-- last but not least, upgrade the innos and players without any role to special/normal innos
	local innos = {}

	for i = 1, #plys do
		local ply = plys[i]

		PLYFINALROLES[ply] = PLYFINALROLES[ply] or ROLE_INNOCENT

		if PLYFINALROLES[ply] ~= ROLE_INNOCENT then continue end

		innos[#innos + 1] = ply
		PLYFINALROLES[ply] = nil -- reset it to update it in UpgradeRoles
	end

	UpgradeRoles(innos, prev_roles, roleCount, selectableRoles, INNOCENT)

	GAMEMODE.LastRole = {}

	for i = 1, #plys do
		local ply = plys[i]
		local subrole = PLYFINALROLES[ply] or ROLE_INNOCENT

		ply:SetRole(subrole, nil, true)

		-- store a steamid -> role map
		GAMEMODE.LastRole[ply:SteamID64()] = subrole
	end

	-- just set the credits after all roles were selected (to fix alone traitor bug)
	for i = 1, #plys do
		plys[i]:SetDefaultCredits()
	end

	PLYFINALROLES = {}

	SendFullStateUpdate()
end
