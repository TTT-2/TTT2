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
local hook = hook

roleselection.forcedRoles = {}
roleselection.finalRoles = {}
roleselection.selectableRoles = nil
roleselection.baseroleLayers = {}
roleselection.subroleLayers = {}

-- Convars
roleselection.cv = {
	---
	-- @realm server
	ttt_max_roles = CreateConVar("ttt_max_roles", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different roles"),

	---
	-- @realm server
	ttt_max_roles_pct =  CreateConVar("ttt_max_roles_pct", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different roles based on player amount. ttt_max_roles needs to be 0"),

	---
	-- @realm server
	ttt_max_baseroles = CreateConVar("ttt_max_baseroles", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different baseroles"),

	---
	-- @realm server
	ttt_max_baseroles_pct = CreateConVar("ttt_max_baseroles_pct", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of different baseroles based on player amount. ttt_max_baseroles needs to be 0")
}

-- saving and loading
roleselection.sqltable = "ttt2_roleselection"
roleselection.savingKeys = {
	layer = {typ = "number", bits = ROLE_BITS, default = 0},
	depth = {typ = "number", bits = ROLE_BITS, default = 0}
}

---
-- Loads every layer from the SQL database
-- @realm server
function roleselection.LoadLayers()
	if not sql.CreateSqlTable(roleselection.sqltable, roleselection.savingKeys) then return end

	local roleList = roles.GetList()

	for i = 1, #roleList do
		local roleData = roleList[i]
		local dataTable = {
			layer = 0,
			depth = 0
		}

		local loaded, changed = sql.Load(roleselection.sqltable, roleData.name, dataTable, roleselection.savingKeys)

		if not loaded then
			-- automatically put the Detective into the first layer if the layering system is initialized the first time
			-- for that role (and there isn't any already existing layer) to keep the default TTT behavior
			if roleData.index == ROLE_DETECTIVE and roleselection.baseroleLayers[1] == nil then
				dataTable.layer = 1
				dataTable.depth = 1

				roleselection.baseroleLayers[1] = {}
				roleselection.baseroleLayers[1][1] = roleData.index
			end

			sql.Init(roleselection.sqltable, roleData.name, dataTable, roleselection.savingKeys)
		elseif changed then
			if dataTable.layer == 0 or dataTable.depth == 0 then continue end -- if (0, 0), exclude from layering

			if roleData:IsBaseRole() then
				roleselection.baseroleLayers[dataTable.layer] = roleselection.baseroleLayers[dataTable.layer] or {}
				roleselection.baseroleLayers[dataTable.layer][dataTable.depth] = roleData.index
			else
				local baserole = roleData:GetBaseRole()

				roleselection.subroleLayers[baserole] = roleselection.subroleLayers[baserole] or {}
				roleselection.subroleLayers[baserole][dataTable.layer] = roleselection.subroleLayers[baserole][dataTable.layer] or {}
				roleselection.subroleLayers[baserole][dataTable.layer][dataTable.depth] = roleData.index
			end
		end
	end

	-- validate layers, could be invalid if there are already uninstalled roles
	local layerCount = 0
	local depthCount = 0
	local validTbl = {}

	-- baseroles
	for _, currentLayerTbl in pairs(roleselection.baseroleLayers) do -- layer
		layerCount = layerCount + 1
		depthCount = 0
		validTbl[layerCount] = {}

		for _, entry in pairs(currentLayerTbl) do -- depth
			depthCount = depthCount + 1
			validTbl[layerCount][depthCount] = entry
		end
	end

	roleselection.baseroleLayers = validTbl

	validTbl = {}
	-- subroles
	for baserole, layerTbl in pairs(roleselection.subroleLayers) do -- baserole connection
		validTbl[baserole] = {}
		layerCount = 0

		for _, currentLayerTbl in pairs(layerTbl) do -- layer
			layerCount = layerCount + 1
			depthCount = 0
			validTbl[baserole][layerCount] = {}

			for _, entry in pairs(currentLayerTbl) do -- depth
				depthCount = depthCount + 1
				validTbl[baserole][layerCount][depthCount] = entry
			end
		end
	end

	roleselection.subroleLayers = validTbl
end

---
-- Saves every layer into the SQL database
-- @realm server
function roleselection.SaveLayers()
	local dataTable = {}

	-- baseroles
	for cLayer = 1, #roleselection.baseroleLayers do
		local currentLayerTbl = roleselection.baseroleLayers[cLayer]

		for cDepth = 1, #currentLayerTbl do
			dataTable[currentLayerTbl[cDepth]] = { -- role index
				["layer"] = cLayer,
				["depth"] = cDepth
			}
		end
	end

	-- subroles
	for baserole, layerTbl in pairs(roleselection.subroleLayers) do
		for cLayer = 1, #layerTbl do
			local currentLayerTbl = layerTbl[cLayer]

			for cDepth = 1, #currentLayerTbl do
				dataTable[currentLayerTbl[cDepth]] = { -- role index
					["layer"] = cLayer,
					["depth"] = cDepth
				}
			end
		end
	end

	-- if not in layer, set (0, 0) as default values
	local roleList = roles.GetList()

	for i = 1, #roleList do
		local roleData = roleList[i]

		sql.Save(roleselection.sqltable, roleData.name, dataTable[roleData.index] or {}, roleselection.savingKeys)
	end
end

---
-- Returns the current amount of selected/already selected @{ROLE}s.
--
-- @param number subrole subrole id of a @{ROLE}'s index
-- @return number amount
-- @realm server
function roleselection.GetCurrentRoleAmount(subrole)
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

---
-- Returns the amount of players, that can still receive this role.
-- This considers the random convar and the maximum amount of players with this role.
--
-- @param table roleData The actual ROLE table.
-- @param boolean forced Should the random pct be ignored?
-- @param number maxPlys The number of players, that this value should be calculated for.
-- @return number The amount of players, that can still be selected for this role.
-- @realm server
-- @internal
local function GetAvailableRoleAmount(roleData, forced, maxPlys)
	local bool = true

	if not forced then
		local randomCVar = GetConVar("ttt_" .. roleData.name .. "_random")

		bool = math.random(100) <= (randomCVar and randomCVar:GetInt() or 100)
	end

	if bool then
		return roleData:GetAvailableRoleCount(maxPlys) - roleselection.GetCurrentRoleAmount(roleData.index)
	end

	return 0
end

---
-- Returns a list of all selectable players
--
-- @param table plys list of @{Player}s that should be filtered.
-- @return table list of filtered players
-- @realm server
function roleselection.GetSelectablePlayers(plys)
	local tmp = {}

	for i = 1, #plys do
		local ply = plys[i]

		---
		-- Everyone on the spec team is in specmode
		-- @realm server
		if not ply:GetForceSpec() and not hook.Run("TTT2DisableRoleSelection", ply) then
			tmp[#tmp + 1] = ply
		end
	end

	return tmp
end

---
-- Returns all selectable @{ROLE}s based on the amount of @{Player}s
--
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
		[ROLE_INNOCENT] = GetAvailableRoleAmount(INNOCENT, true, maxPlys),
		[ROLE_TRAITOR] = GetAvailableRoleAmount(TRAITOR, true, maxPlys)
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

		-- if this is a subrole (a role that has a baserole is a subrole), check if the base role is available first
		if roleData.baserole and roleData.baserole ~= ROLE_INNOCENT and roleData.baserole ~= ROLE_TRAITOR then
			local baseRoleData = roles.GetByIndex(roleData.baserole)

			if not checked[baseRoleData.index] then
				checked[baseRoleData.index] = true

				local rolesCount = GetAvailableRoleAmount(baseRoleData, forcedRolesTbl[baseRoleData.index], maxPlys)

				if rolesCount > 0 then
					rolesCountTbl[baseRoleData.index] = rolesCount
				end
			end

			-- continue if baserole is not available
			if not rolesCountTbl[baseRoleData.index] then continue end
		end

		-- now check for subrole availability
		local rolesCount = GetAvailableRoleAmount(roleData, forcedRolesTbl[roleData.index], maxPlys)

		if rolesCount > 0 then
			rolesCountTbl[roleData.index] = rolesCount
		end
	end

	return rolesCountTbl
end

local function CleanupAvailableRolesLayerTbl(availableRolesTbl, currentIndexedLayer)
	local cleanedLayerTbl = {}

	for cDepth = 1, #currentIndexedLayer do
		local layerEntry = currentIndexedLayer[cDepth]

		for i = 1, #availableRolesTbl do
			if availableRolesTbl[i] == layerEntry then -- the role is still available / selectable
				cleanedLayerTbl[#cleanedLayerTbl + 1] = layerEntry

				-- remove the role from the available roles table. This also means, that even if a layered "or"-table is given and not every role in there was already selected, every role in the layered "or"-table will become unavailable
				table.remove(availableRolesTbl, i)

				break
			end
		end
	end

	return cleanedLayerTbl
end

---
-- Returns a list of selectable @{ROLE}s (already filtered by amount of maximum available roles) based on the amount of @{Player}s
-- @note This @{function} automatically saves the selectable @{ROLE}s after processing. If `roleselection.selectableRoles` is NOT `nil`, it will be returned WITHOUT processing
--
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

	-- we have to create a enumerable table to get random results easily
	local availableBaseRolesTbl = {}
	local availableSubRolesTbl = {}
	local availableBaseRolesAmount = 0

	for subrole in pairs(rolesAmountList) do
		local roleData = roles.GetByIndex(subrole)

		-- exclude innocents and traitors, as they are already included, see below def. of selectableRoles.
		if subrole == ROLE_INNOCENT or subrole == ROLE_TRAITOR then continue end

		if not roleData:IsBaseRole() then
			local baserole = roleData:GetBaseRole()

			availableSubRolesTbl[baserole] = availableSubRolesTbl[baserole] or {}
			availableSubRolesTbl[baserole][#availableSubRolesTbl[baserole] + 1] = subrole
		else
			availableBaseRolesAmount = availableBaseRolesAmount + 1

			availableBaseRolesTbl[availableBaseRolesAmount] = subrole
		end
	end

	local selectableRoles = {
		[ROLE_TRAITOR] = rolesAmountList[ROLE_TRAITOR],
		[ROLE_INNOCENT] = rolesAmountList[ROLE_INNOCENT]
	}
	local curRoles = 2 -- amount of roles, start with 2 because INNOCENT and TRAITOR are all the time available
	local curBaseroles = 2 -- amount of base roles, ...

	local layeredBaseRolesTbl = table.Copy(roleselection.baseroleLayers) -- layered roles list, the order defines the pick order. Just one role per layer is picked. Before a role is picked, the given layer is cleared (checked if the given roles are still selectable). Insert a table as a "or" list

	---
	-- @realm server
	hook.Run("TTT2ModifyLayeredBaseRoles", layeredBaseRolesTbl, availableBaseRolesTbl)

	local baseroleLoopTbl = { -- just contains available / selectable baseroles
		ROLE_TRAITOR,
		ROLE_INNOCENT
	}

	-- first of all, we need to select the baseroles. Otherwise, we would select subroles that never gonna be choosen because if the missing baserole
	for i = 1, availableBaseRolesAmount do
		if maxRoles and maxRoles <= curRoles or maxBaseroles and maxBaseroles <= curBaseroles or #availableBaseRolesTbl < 1 then break end -- if the limit is reached or no available roles left (could happen if removing available roles that weren't already selected in layered "or"-tables), stop selection

		-- the selected role
		local subrole = nil

		-- if there are still defined layer
		if #layeredBaseRolesTbl >= i then
			for j = i, #layeredBaseRolesTbl do
				local cleanedLayerTbl = CleanupAvailableRolesLayerTbl(availableBaseRolesTbl, layeredBaseRolesTbl[i]) -- clean the currently indexed layer (so that it just includes selectable roles), because we working with predefined layers that probably includes roles that aren't selectable with the current amount of players, etc.

				-- if there is no selectable role left in the current layer
				if #cleanedLayerTbl < 1 then
					table.remove(layeredBaseRolesTbl, i) -- remove the current layer

					-- redo the inner loop with the same index i
					continue
				end

				subrole = cleanedLayerTbl[math.random(#cleanedLayerTbl)]

				break
			end
		end

		-- if no subrole was selected (no layer left or no layer defined)
		if not subrole then
			local rnd = math.random(#availableBaseRolesTbl)
			subrole = availableBaseRolesTbl[rnd]

			table.remove(availableBaseRolesTbl, rnd) -- selected subrole shouldn't get selected multiple times
		end

		selectableRoles[subrole] = rolesAmountList[subrole]
		baseroleLoopTbl[#baseroleLoopTbl + 1] = subrole

		curRoles = curRoles + 1
		curBaseroles = curBaseroles + 1
	end

	local layeredSubRolesTbl = table.Copy(roleselection.subroleLayers) -- layered roles list, the order defines the pick order. Just one role per layer is picked. Before a role is picked, the given layer is cleared (checked if the given roles are still selectable). Insert a table as a "or" list

	---
	-- @realm server
	hook.Run("TTT2ModifyLayeredSubRoles", layeredSubRolesTbl, availableSubRolesTbl)

	-- now we need to select the subroles
	for cBase = 1, #baseroleLoopTbl do
		if maxRoles and maxRoles <= curRoles then break end -- if the limit is reached, stop selection

		local currentBaserole = baseroleLoopTbl[cBase]

		local currentSubroleTbl = availableSubRolesTbl[currentBaserole]
		if not currentSubroleTbl then continue end -- no subroles connected with this baserole

		local subroleTblCount = #currentSubroleTbl

		for i = 1, subroleTblCount do
			if maxRoles and maxRoles <= curRoles or #currentSubroleTbl < 1 then break end -- if the limit is reached or no available roles left (could happen if removing available roles that weren't already selected in layered "or"-tables), stop selection

			-- the selected role
			local subrole = nil
			local currentSubroleLayers = layeredSubRolesTbl[currentBaserole]

			-- if there are still defined layers
			if currentSubroleLayers ~= nil and #currentSubroleLayers >= i then
				for j = i, #currentSubroleLayers do
					local cleanedLayerTbl = CleanupAvailableRolesLayerTbl(currentSubroleTbl, currentSubroleLayers[i]) -- clean the currently indexed layer (so that it just includes selectable roles), because we working with predefined layers that probably includes roles that aren't selectable with the current amount of players, etc.

					-- if there is no selectable role left in the current layer
					if #cleanedLayerTbl < 1 then
						table.remove(layeredSubRolesTbl, i) -- remove the current layer

						-- redo the current loop with the same index
						continue
					end

					subrole = cleanedLayerTbl[math.random(#cleanedLayerTbl)]

					break
				end
			end

			-- if no subrole was selected (no layer left or no layer defined)
			if not subrole then
				local rnd = math.random(#currentSubroleTbl)
				subrole = currentSubroleTbl[rnd]

				table.remove(currentSubroleTbl, rnd) -- selected subrole shouldn't get selected multiple times
			end

			selectableRoles[subrole] = rolesAmountList[subrole]

			curRoles = curRoles + 1
		end
	end

	---
	-- @realm server
	hook.Run("TTT2ModifySelectableRoles", selectableRoles)

	roleselection.selectableRoles = selectableRoles

	return selectableRoles
end

---
-- If possible, give plys the available roles.
--
-- @param table plys The players that should receive roles.
-- @param table availableRoles The list of roles, that are available.
-- @param table selectableRoles The list of filtered selectable @{ROLE}s
-- @param table selectedForcedRoles The List with a count of forced @{ROLE}s
-- @realm server
-- @internal
local function SetSubRoles(plys, availableRoles, selectableRoles, selectedForcedRoles)
	local plysAmount = #plys
	local availableRolesAmount = #availableRoles
	local tmpSelectableRoles = table.Copy(selectableRoles)

	while plysAmount > 0 and availableRolesAmount > 0 do
		local pick = math.random(plysAmount)
		local ply = plys[pick]

		local rolePick = math.random(availableRolesAmount)
		local subrole = availableRoles[rolePick]
		local roleData = roles.GetByIndex(subrole)
		local roleCount = tmpSelectableRoles[subrole]

		if selectedForcedRoles[subrole] then
			roleCount = roleCount - selectedForcedRoles[subrole]
		end

		local minKarmaCVar = GetConVar("ttt_" .. roleData.name .. "_karma_min")
		local minKarma = minKarmaCVar and minKarmaCVar:GetInt() or 0

		-- give this player the role if
		if plysAmount <= roleCount -- or there aren't enough players anymore to have a greater role variety
			or ply:GetBaseKarma() > minKarma -- or the player has enough karma
				and not ply:GetAvoidRole(subrole) -- and the player doesn't avoid this role
			or math.random(3) == 2 -- or if the randomness decides
		then
			table.remove(plys, pick)

			roleselection.finalRoles[ply] = subrole

			plysAmount = plysAmount - 1
			roleCount = roleCount - 1

			tmpSelectableRoles[subrole] = roleCount -- update the available roles

			if roleCount < 1 then
				table.remove(availableRoles, rolePick)

				availableRolesAmount = availableRolesAmount - 1
			end
		end
	end
end

---
-- Ensure, that baseroles of hardforced subroles are accounted for (eg. received by ULX etc).
--
-- @return table List with a count of forced @{ROLE}s
-- @realm server
-- @internal
local function GetHardForcedBaseRoles()
	local selectedForcedRoles = {}

	for ply, subrole in pairs(roleselection.finalRoles) do
		local curRole = roles.GetByIndex(subrole)
		local isBaseRole = curRole:IsBaseRole()

		-- assign amount of forced players per baserole if this is only a subrole
		if not isBaseRole then
			local baserole = curRole.baserole
			selectedForcedRoles[baserole] = (selectedForcedRoles[baserole] or 0) + 1
		end
	end

	return selectedForcedRoles
end

---
-- Ensure, that players receive their forced role (eg. received by ULX etc).
--
-- @param table plys The players that should receive roles.
-- @param table selectableRoles The list of filtered selectable @{ROLE}s
-- @return table List with a count of forced @{ROLE}s
-- @realm server
-- @internal
local function SelectForcedRoles(plys, selectableRoles)
	local transformed = {}

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

	local selectedForcedRoles = GetHardForcedBaseRoles() -- this gets the hardforced amount of baseroles that are taken by subroles 

	for subrole, forcedPlys in pairs(transformed) do
		local roleCount = selectableRoles[subrole]

		-- if it's not a selectable role, continue
		if not roleCount then continue end

		local curRole = roles.GetByIndex(subrole)
		local isBaseRole = curRole:IsBaseRole()
		local baserole = nil

		-- Consider maximum number of roles, that are available to the corresponding baserole
		if not isBaseRole then
			baserole = curRole.baserole

			local baseroleCount = selectableRoles[baserole] - (selectedForcedRoles[baserole] or 0)

			-- take the minimum of baseroles or subroles, if baseroles are available, else continue
			if baseroleCount < 1 then continue end

			roleCount = math.min(baseroleCount, roleCount)
		end

		-- Consider number of roles, that were forced by other subroles
		local curCount = selectedForcedRoles[subrole] or 0
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

			---
			-- @realm server
			hook.Run("TTT2ReceivedForcedRole", ply, subrole)
		end

		-- assigning the amount of forced players per role
		selectedForcedRoles[subrole] = curCount

		-- now assign amount of forced players per baserole if this is only a subrole
		if not isBaseRole then
			selectedForcedRoles[baserole] = (selectedForcedRoles[baserole] or 0) + curCount
		end
	end
	roleselection.forcedRoles = {}

	return selectedForcedRoles
end

---
-- Upgrade a baserole to possible subroles.
-- @note The subrole replaces a previously selected baserole.
--
-- @param table plys The players that should receive roles.
-- @param number subrole The @{ROLE} index of the considered role.
-- @param table selectableRoles The list of filtered selectable @{ROLE}s
-- @param table selectedForcedRoles The List with a count of forced @{ROLE}s
-- @realm server
-- @internal
local function UpgradeRoles(plys, subrole, selectableRoles, selectedForcedRoles)
	local availableRoles = {}
	local roleAmount = 0

	-- now upgrade this role if there are other subroles
	for sub in pairs(selectableRoles) do
		if roles.GetByIndex(sub).baserole ~= subrole then continue end

		roleAmount = selectableRoles[sub]

		if selectedForcedRoles[sub] then
			roleAmount = roleAmount - selectedForcedRoles[sub]
		end

		if roleAmount > 0 then
			availableRoles[#availableRoles + 1] = sub
		end
	end

	SetSubRoles(plys, availableRoles, selectableRoles, selectedForcedRoles)
end

---
-- Update the roleselection.finalRoles table by removing all invalid players
--
-- @realm server
-- @internal
local function UpdateFinalRoles()
	local tbl = {}

	for ply, subrole in pairs(roleselection.finalRoles) do
		if IsValid(ply) then
			tbl[ply] = subrole
		end
	end

	roleselection.finalRoles = tbl
end

---
-- Select players for a given role.
-- @note This function modifies the given `plys` var.
--
-- @param table plys The players that can receive roles.
-- @param number subrole The @{ROLE} index of the considered role.
-- @param number roleAmount The amount of players that are allowed to receive this role.
-- @return table List of players, that received the role.
-- @realm server
-- @internal
local function SelectBaseRolePlayers(plys, subrole, roleAmount)
	local curRoles = 0
	local plysList = {}

	local minKarmaCVar = GetConVar("ttt_" .. roles.GetByIndex(subrole).name .. "_karma_min")
	local min_karmas = minKarmaCVar and minKarmaCVar:GetInt() or 0

	while curRoles < roleAmount and #plys > 0 do
		-- select random index in plys table
		local pick = math.random(#plys)

		-- the player we consider
		local ply = plys[pick]

		-- give this player the role if
		if subrole == ROLE_INNOCENT -- this role is an innocent role
			or #plys <= roleAmount -- or there aren't enough players anymore to have a greater role variety
			or ply:GetBaseKarma() > min_karmas -- or the player has enough karma
				and not ply:GetAvoidRole(subrole) -- and the player doesn't avoid this role
			or math.random(3) == 2 -- or if the randomness decides
		then
			table.remove(plys, pick)

			curRoles = curRoles + 1
			plysList[curRoles] = ply

			roleselection.finalRoles[ply] = subrole -- give the player the final baserole (maybe he will receive his subrole later)
		end
	end

	return plysList
end

---
-- Select selectable @{ROLE}s for a given list of @{Player}s
-- @note This automatically synces with every connected @{Player}
--
-- @param[opt] table plys list of @{Player}s. `nil` to calculate automatically (all players)
-- @param[optchain] number maxPlys amount of maximum @{Player}s. `nil` to calculate automatically
-- @realm server
function roleselection.SelectRoles(plys, maxPlys)
	roleselection.selectableRoles = nil -- reset to enable recalculation

	GAMEMODE.LastRole = GAMEMODE.LastRole or {}

	plys = roleselection.GetSelectablePlayers(plys or player.GetAll())

	maxPlys = maxPlys or #plys

	if maxPlys < 2 then return end -- we don't need to select anything if there is just one player

	local allAvailableRoles = roleselection.GetAllSelectableRolesList(maxPlys)
	local selectableRoles = roleselection.GetSelectableRolesList(maxPlys, allAvailableRoles) -- update roleselection.selectableRoles table

	UpdateFinalRoles() -- Update the roleselection.finalRoles table by removing all invalid players

	-- Select forced roles at first
	local selectedForcedRoles = SelectForcedRoles(plys, selectableRoles) -- this updates roleselection.finalRoles table with forced players

	-- We need to remove already selected players
	local plysFirstPass, plysSecondPass = {}, {} -- modified player table

	for i = 1, #plys do
		local ply = plys[i]

		if roleselection.finalRoles[ply] then continue end

		local pos = #plysFirstPass + 1

		plysFirstPass[pos] = ply
		plysSecondPass[pos] = ply
	end

	-- if there are still available players
	if #plysFirstPass > 0 then
		-- first select traitors, then innos, then the other roles
		local list = {
			[1] = ROLE_TRAITOR,
			[2] = ROLE_INNOCENT
		}

		-- insert selectable roles into the list. The order doesn't matter, players are chosen randomly and the roles are already filtered and limited
		for subrole in pairs(selectableRoles) do
			if subrole == ROLE_TRAITOR or subrole == ROLE_INNOCENT then continue end

			list[#list + 1] = subrole
		end

		-- Check all base roles, and assign players where possible.
		-- After that, this will also try to upgrade the selected players, to any applicable subrole, that might replace the baserole.
		-- But this will not upgrade Innocent subroles, as Innocents and players without any role are upgraded in the end.
		for i = 1, #list do
			local subrole = list[i]
			local roleData = roles.GetByIndex(subrole)

			if not roleData:IsBaseRole() or not selectableRoles[subrole] then continue end

			local amount = selectableRoles[subrole]

			if selectedForcedRoles[subrole] then
				amount = amount - selectedForcedRoles[subrole]
			end

			local baseRolePlys = SelectBaseRolePlayers(plysFirstPass, subrole, amount)

			-- upgrade innos and players without any role later
			if subrole ~= ROLE_INNOCENT then
				UpgradeRoles(baseRolePlys, subrole, selectableRoles, selectedForcedRoles)
			end
		end

		-- last but not least, upgrade the innos and players without any role to special/normal innos
		local innos = {}
		for i = 1, #plysSecondPass do
			local ply = plysSecondPass[i]

			roleselection.finalRoles[ply] = roleselection.finalRoles[ply] or ROLE_INNOCENT

			if roleselection.finalRoles[ply] ~= ROLE_INNOCENT then continue end

			innos[#innos + 1] = ply
		end

		UpgradeRoles(innos, ROLE_INNOCENT, selectableRoles, selectedForcedRoles)
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
