-- TODO
-- What if every innocent is transformed into another role?

---
-- role selection module
-- @module roleselection
roleselection = {}

-- Localize stuff we use often. It's like Lua go-faster stripes.
local math = math
local table = table
local player = player
local pairs = pairs
local IsValid = IsValid
local CreateConVar = CreateConVar
local hook = hook

roleselection.forcedRoles = {}
roleselection.finalRoles = {}
roleselection.selectableRoles = nil

-- innos min pct
roleselection.cv = {}
roleselection.cv.ttt_max_roles = CreateConVar("ttt_max_roles", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different roles")
roleselection.cv.ttt_max_roles_pct =  CreateConVar("ttt_max_roles_pct", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different roles based on player amount. ttt_max_roles needs to be 0")
roleselection.cv.ttt_max_baseroles = CreateConVar("ttt_max_baseroles", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different baseroles")
roleselection.cv.ttt_max_baseroles_pct = CreateConVar("ttt_max_baseroles_pct", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different baseroles based on player amount. ttt_max_baseroles needs to be 0")

---
-- Returns the amount of pre selected @{ROLE}s
-- @param number subrole subrole id of a @{ROLE}'s index
-- @return number amount
-- @realm server
function roleselection.GetPreSelectedRole(subrole)
	local tmp = 0

	if GetRoundState() == ROUND_ACTIVE then
		local plys = player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			if not IsValid(ply) or ply:GetForceSpec() or ply:GetSubRole() ~= subrole then continue end

			tmp = tmp + 1
		end
	elseif roleselection.finalRoles then
		for ply, sr in pairs(roleselection.finalRoles) do
			if sr == subrole then
				tmp = tmp + 1
			end
		end
	end

	return tmp
end

local function GetAvailableRoleAmount(roleData, forced, maxPlys)
	local bool = true

	if not forced then
		local randomCVar = GetConVar("ttt_" .. roleData.name .. "_random")

		bool = math.random(100) <= (randomCVar and randomCVar:GetInt() or 100)
	end

	if bool then
		return roleData:GetRoleCount(maxPlys) - roleselection.GetPreSelectedRole(roleData.index)
	end

	return 0
end

---
-- Returns a list of all selectable players
-- @param table plys list of @{Player}s that should be filtered.
-- @return table list of filtered players
-- @realm server
function roleselection.GetSelectablePlayers(plys)
	local tmp = {}

	for i = 1, #plys do
		local ply = plys[i]

		-- everyone on the spec team is in specmode
		if not ply:GetForceSpec() and not hook.Run("TTT2DisableRoleSelection", ply) then
			tmp[#tmp + 1] = ply
		end
	end

	return tmp
end

---
-- Returns all selectable @{ROLE}s based on the amount of @{Player}s
-- @param number maxPlys amount of maximum @{Player}s (filtered!)
-- @return table a list of all selectable @{ROLE}s
-- @realm server
function roleselection.GetAllSelectableRolesList(maxPlys)
	if maxPlys < 2 then return end

	local forcedRolesTbl = {}

	for _, subrole in pairs(roleselection.forcedRoles) do
		forcedRolesTbl[subrole] = true
	end

	local rolesCountTbl = {
		[INNOCENT] = GetAvailableRoleAmount(INNOCENT, true, maxPlys),
		[TRAITOR] = GetAvailableRoleAmount(TRAITOR, true, maxPlys)
	}

	local checked = {}
	local rlsList = roles.GetList()

	-- add all roles if possible
	for i = 1, #rlsList do
		local roleData = rlsList[i]

		if checked[roleData.index] then continue end

		checked[roleData.index] = true

		-- INNOCENT and TRAITOR are all the time selectable
		if roleData == INNOCENT or roleData == TRAITOR or not roleData:IsSelectable() then continue end

		-- if this is a subrole (a role that have a baserole is a subrole), check if the base role is available first
		if roleData.baserole and roleData.baserole ~= ROLE_INNOCENT and roleData.baserole ~= ROLE_TRAITOR then
			local rd = roles.GetByIndex(roleData.baserole)

			if not checked[roleData.baserole] then
				checked[roleData.baserole] = true

				local rolesCount = GetAvailableRoleAmount(roleData, forcedRolesTbl[roleData.baserole], maxPlys)

				if rolesCount > 0 then
					rolesCountTbl[roleData] = rolesCount
				end
			end

			-- continue if baserole is not available
			if not rolesCountTbl[rd] then continue end
		end

		-- now check for subrole availability
		local rolesCount = GetAvailableRoleAmount(roleData, forcedRolesTbl[roleData.index], maxPlys)

		if rolesCount > 0 then
			rolesCountTbl[roleData] = rolesCount
		end
	end

	return rolesCountTbl
end

---
-- Returns a list of selectable @{ROLE}s (already filtered by amount of maximum available roles) based on the amount of @{Player}s
-- @note This @{function} automatically saves the selectable @{ROLE}s after processing. If `roleselection.selectableRoles` is NOT `nil`, it will be returned WITHOUT processing
-- @param number maxPlys amount of maximum @{Player}s (filtered!). Insert `nil` if it should get calculated
-- @param table rolesAmountList list of @{ROLE}s as key and selectable amount of these roles as value
-- @return table a list of filtered selectable @{ROLE}s
-- @realm server
function roleselection.GetSelectableRolesList(maxPlys, rolesAmountList)
	if roleselection.selectableRoles then
		return roleselection.selectableRoles
	end

	-- yea it begins
	local maxRoles = roleselection.cv.ttt_max_roles:GetInt()
	if maxRoles == 0 then
		maxRoles = math.floor(roleselection.cv.ttt_max_roles_pct:GetFloat() * maxPlys)
		if maxRoles == 0 then
			maxRoles = nil
		end
	end

	-- damn, not again
	local maxBaseroles = roleselection.cv.ttt_max_baseroles:GetInt()
	if maxBaseroles == 0 then
		maxBaseroles = math.floor(roleselection.cv.ttt_max_baseroles_pct:GetFloat() * maxPlys)
		if maxBaseroles == 0 then
			maxBaseroles = nil
		end
	end

	local curRoles = 2 -- amount of roles, start with 2 because INNOCENT and TRAITOR are all the time available
	local curBaseroles = 2 -- amount of base roles, ...

	-- we have to create a enumerable table to get random results easily
	local availableBaseRolesTbl = {}
	local availableSubRolesTbl = {}
	local availableBaseRolesAmount = 0
	local availableSubRolesAmount = 0

	for roleData in pairs(rolesAmountList) do
		if roleData.baserole then
			availableSubRolesAmount = availableSubRolesAmount + 1

			availableSubRolesTbl[availableSubRolesAmount] = roleData
		else
			availableBaseRolesAmount = availableBaseRolesAmount + 1

			availableBaseRolesTbl[availableBaseRolesAmount] = roleData
		end
	end

	local selectableRoles = {}

	-- first of all, we need to select the baseroles. Otherwise, we would select subroles that never gonna be choosen because if the missing baserole
	for i = 1, availableBaseRolesAmount do
		if maxRoles and maxRoles <= curRoles or maxBaseroles and maxBaseroles <= curBaseroles then break end -- if the limit is reached, stop selection

		local rnd = math.random(#availableBaseRolesTbl)
		local roleData = availableBaseRolesTbl[rnd]

		table.remove(availableBaseRolesTbl, rnd) -- selected roleData shouldn't get selected multiple times

		selectableRoles[roleData] = rolesAmountList[roleData]

		curRoles = curRoles + 1
		curBaseroles = curBaseroles + 1
	end

	-- now we need to select the subroles
	for i = 1, availableSubRolesAmount do
		if maxRoles and maxRoles <= curRoles then break end -- if the limit is reached, stop selection

		local rnd = math.random(#availableSubRolesTbl)
		local roleData = availableSubRolesTbl[rnd]

		table.remove(availableSubRolesTbl, rnd) -- selected roleData shouldn't get selected multiple times

		selectableRoles[roleData] = rolesAmountList[roleData]

		curRoles = curRoles + 1
	end

	hook.Run("TTT2ModifySelectableRoles", selectableRoles)

	roleselection.selectableRoles = selectableRoles

	return selectableRoles
end

---
-- if possible, give plys the available roles
local function SetSubRoles(plys, prevRoles, availableRoles, selectableRoles)
	local plysAmount = #plys
	local availableRolesAmount = #availableRoles
	local tmpSelectableRoles = table.Copy(selectableRoles)

	while plysAmount > 0 and availableRolesAmount > 0 do
		local pick = math.random(plysAmount)
		local ply = plys[pick]

		local rolePick = math.random(availableRolesAmount)
		local roleData = availableRoles[rolePick]
		local roleCount = tmpSelectableRoles[roleData]

		local minKarmaCVar = GetConVar("ttt_" .. roleData.name .. "_karma_min")
		local minKarma = minKarmaCVar and minKarmaCVar:GetInt() or 0

		-- give this player the role if
		if plysAmount <= roleCount -- or there aren't enough players anymore to have a greater role variety
			or ply:GetBaseKarma() > minKarma -- or the player has enough karma
				and table.HasValue(prevRoles[ROLE_INNOCENT], ply) -- and the player was innocent before
				and not ply:GetAvoidRole(roleData.index) -- and the player doesn't avoid this role
			or math.random(3) == 2 -- or if the randomness decides
		then
			table.remove(plys, pick)

			roleselection.finalRoles[ply] = roleData.index

			plysAmount = plysAmount - 1
			roleCount = roleCount - 1

			tmpSelectableRoles[roleData] = roleCount -- update the available roles

			if roleCount < 1 then
				table.remove(availableRoles, rolePick)

				availableRolesAmount = availableRolesAmount - 1
			end
		end
	end
end

local function SelectForcedRoles(plys, selectableRoles)
	local transformed = {}
	local selectedPlys = {}

	-- filter and restructure the forcedRoles table
	for id, subrole in pairs(roleselection.forcedRoles) do
		local ply = player.GetBySteamID64(id)

		if not IsValid(ply) then
			roleselection.forcedRoles[id] = nil
		elseif table.HasValue(plys, ply) then
			transformed[subrole] = transformed[subrole] or {}
			transformed[subrole][#transformed[subrole] + 1] = ply
		end
	end

	for subrole, forcedPlys in pairs(transformed) do
		local rd = roles.GetByIndex(subrole)

		local roleCount = selectableRoles[rd]

		-- if it's not a selectable role, continue
		if not roleCount then continue end

		local curCount = 0
		local amount = #forcedPlys

		for i = 1, amount do
			local pick = math.random(#forcedPlys)
			local ply = forcedPlys[pick]

			if roleCount <= curCount then break end -- if the limit is reached, stop selection for this role

			table.remove(forcedPlys, pick) -- remove selected player to avoid multiple selection

			roleselection.forcedRoles[tostring(ply:SteamID64())] = nil

			if roleselection.finalRoles[ply] then continue end -- we don't need to set a final role if this player already has a final role

			roleselection.finalRoles[ply] = subrole
			curCount = curCount + 1

			hook.Run("TTT2ReceivedForcedRole", ply, rd)

			selectedPlys[ply] = true
		end
	end

	roleselection.forcedRoles = {}

	return selectedPlys
end

local function UpgradeRoles(plys, prevRoles, roleData, selectableRoles)
	local availableRoles = {}

	-- now upgrade this role if there are other subroles
	for v in pairs(selectableRoles) do
		if v.baserole == roleData.index then
			availableRoles[#availableRoles + 1] = v
		end
	end

	SetSubRoles(plys, prevRoles, availableRoles, selectableRoles)
end

---
-- This function modifies the given `plys` var
local function SelectBaseRolePlayers(plys, prevRoles, roleData, roleAmount)
	local curRoles = 0
	local plysList = {}

	local minKarmaCVar = GetConVar("ttt_" .. roleData.name .. "_karma_min")
	local min_karmas = minKarmaCVar and minKarmaCVar:GetInt() or 0

	while curRoles < roleAmount and #plys > 0 do
		-- select random index in plys table
		local pick = math.random(#plys)

		-- the player we consider
		local ply = plys[pick]

		-- give this player the role if
		if roleData == INNOCENT -- this role is an innocent role
			or #plys <= roleAmount -- or there aren't enough players anymore to have a greater role variety
			or ply:GetBaseKarma() > min_karmas -- or the player has enough karma
				and table.HasValue(prevRoles[ROLE_INNOCENT], ply) -- and the player was innocent before
				and not ply:GetAvoidRole(roleData.index) -- and the player doesn't avoid this role
			or math.random(3) == 2 -- or if the randomness decides
		then
			table.remove(plys, pick)

			curRoles = curRoles + 1
			plysList[curRoles] = ply

			roleselection.finalRoles[ply] = roleData.index -- give the player the final baserole (maybe he will receive his subrole later)
		end
	end

	return plysList
end

---
-- Select selectable @{ROLE}s for a given list of @{Player}s
-- @note This automatically synces with every connected @{Player}
-- @param ?table plys list of @{Player}s. `nil` to calculate automatically
-- @param ?number maxPlys amount of maximum @{Player}s. `nil` to calculate automatically
-- @realm server
function roleselection.SelectRoles(plys, maxPlys)
	roleselection.selectableRoles = nil -- reset to enable recalculation

	local prevRoles = {}

	GAMEMODE.LastRole = GAMEMODE.LastRole or {}

	plys = roleselection.GetSelectablePlayers(plys or player.GetAll())

	-- save previous roles
	for i = 1, #plys do
		local v = plys[i]
		local r = GAMEMODE.LastRole[v:SteamID64()] or v:GetSubRole()

		prevRoles[r] = prevRoles[r] or {}
		prevRoles[r][#prevRoles[r] + 1] = v
	end

	maxPlys = maxPlys or #plys

	if maxPlys < 2 then return end -- we don't need to select anything if there is just one player

	local allAvailableRoles = roleselection.GetAllSelectableRolesList(maxPlys)
	local selectableRoles = roleselection.GetSelectableRolesList(maxPlys, allAvailableRoles) -- update roleselection.selectableRoles table

	-- Select forced roles at first
	local selectedForcedPlys = SelectForcedRoles(plys, selectableRoles) -- this updates roleselection.finalRoles table and returns a key based list of selected players

	-- We need to remove already selected players
	local tmpPlys = {} -- modified player table

	for i = 1, #plys do
		local ply = plys[i]

		if not selectedForcedPlys[ply] then
			tmpPlys[#tmpPlys + 1] = ply
		end
	end

	-- if there are still available players
	if #tmpPlys > 0 then
		-- first select traitors, then innos, then the other roles
		local list = {
			[1] = TRAITOR,
			[2] = INNOCENT
		}

		-- insert selectable roles into the list. The order doesn't matter, players are choosen randomly and the roles are already filtered and limited
		for roleData in pairs(selectableRoles) do
			if roleData == TRAITOR or roleData == INNOCENT then continue end

			list[#list + 1] = roleData
		end

		for i = 1, #list do
			local roleData = list[i]
			local baseRolePlys = SelectBaseRolePlayers(tmpPlys, prevRoles, roleData, selectableRoles[roleData])

			-- upgrade innos and players without any role later
			if roleData ~= INNOCENT then
				UpgradeRoles(baseRolePlys, prevRoles, roleData, selectableRoles)
			end
		end

		-- last but not least, upgrade the innos and players without any role to special/normal innos
		local innos = {}

		for i = 1, #tmpPlys do
			local ply = tmpPlys[i]

			roleselection.finalRoles[ply] = roleselection.finalRoles[ply] or ROLE_INNOCENT

			if roleselection.finalRoles[ply] ~= ROLE_INNOCENT then continue end

			innos[#innos + 1] = ply
		end

		UpgradeRoles(innos, prevRoles, INNOCENT, selectableRoles)
	end

	GAMEMODE.LastRole = {}

	for i = 1, #plys do
		local ply = plys[i]
		local subrole = roleselection.finalRoles[ply] or ROLE_INNOCENT

		ply:SetRole(subrole, nil, true)

		-- store a steamid -> role map
		GAMEMODE.LastRole[ply:SteamID64()] = subrole
	end

	-- just set the credits after all roles were selected (to fix alone traitor bug)
	for i = 1, #plys do
		plys[i]:SetDefaultCredits()
	end

	roleselection.finalRoles = {}

	SendFullStateUpdate()
end
