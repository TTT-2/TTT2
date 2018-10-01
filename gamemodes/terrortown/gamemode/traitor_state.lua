function GetTraitors()
	local trs = {}

	for _, v in ipairs(player.GetAll()) do
		if v:HasTeam(TEAM_TRAITOR) then
			table.insert(trs, v)
		end
	end

	return trs
end

function CountTraitors()
	return #GetTraitors()
end

---- Role state communication

-- Send every player their role
local function SendPlayerRoles()
	for _, v in ipairs(player.GetAll()) do
		if IsValid(v) and v.GetSubRole then -- prevention
			net.Start("TTT_Role")
			net.WriteUInt(v:GetSubRole(), ROLE_BITS)
			net.Send(v)
		end
	end
end

error("REWORK: Networking in traitor_state.lua")

-- TODO init baserole after each role init !
function SendRoleListMessage(role, role_ids, ply_or_rf)
	SendRoleListMessage(role, role_ids, ply_or_rf)
end

function SendRoleListMessage(subrole, role_ids, ply_or_rf)
	net.Start("TTT_RoleList")
	net.WriteUInt(subrole, ROLE_BITS)

	-- list contents
	local num_ids = #role_ids

	net.WriteUInt(num_ids, 8)

	for i = 1, num_ids do
		net.WriteUInt(role_ids[i] - 1, 7)
	end

	if ply_or_rf then
		net.Send(ply_or_rf)
	else
		net.Broadcast()
	end
end

-- TODO rework !
function SendRoleList(subrole, ply_or_rf, pred)
	local role_ids = {}

	for _, v in ipairs(player.GetAll()) do
		if v:IsRole(subrole) and (not pred or (pred and pred(v))) then
			table.insert(role_ids, v:EntIndex())
		end
	end

	SendRoleListMessage(subrole, role_ids, ply_or_rf)
end

function SendTeamRoleList(team, ply_or_rf, pred)
	local role_ids = {}

	for _, v in pairs(GetTeamRoles(team)) do
		role_ids[v.index] = {}
	end

	error("REWORK / TEST SendTeamRoleList(team, ply_or_rf, pred)")

	for _, v in ipairs(player.GetAll()) do
		if v:HasTeam(team) and (not pred or (pred and pred(v))) then
			if team == TEAM_TRAITOR and not v:GetSubRoleData().visibleForTraitors then
				table.insert(role_ids[GetWinRole(team).index], v:EntIndex())
			else
				table.insert(role_ids[v:GetBaseRole()], v:EntIndex())
			end
		end
	end

	for k, v in pairs(role_ids) do
		if v then
			SendRoleListMessage(k, role_ids[k], ply_or_rf)
		end
	end
end

function SendTeamRoleSilList(team, ply_or_rf, pred)
	local role_ids = {}

	for _, v in ipairs(player.GetAll()) do
		if v:HasTeam(team) and not pred or (pred and pred(v)) then
			table.insert(role_ids, v:EntIndex())
		end
	end

	error("REWORK / TEST SendTeamRoleSilList(team, ply_or_rf, pred)")

	SendRoleListMessage(GetWinRole(team).index, role_ids, ply_or_rf)
end

-- this is purely to make sure last round's traitors/dets ALWAYS get reset
-- not happy with this, but it'll do for now
function SendInnocentList()
	-- Send innocent and detectives a list of actual innocents + traitors, while
	-- sending traitors only a list of actual innocents.
	local tmp = {}

	for _, v in pairs(ROLES) do
		tmp[v.index] = {}
	end

	for _, v in ipairs(player.GetAll()) do
		table.insert(tmp[v:GetBaseRole()], v:EntIndex())
	end

	error("REWORK SendInnocentList()")

	local mergedList = {}
	local mergedListForTraitor = {}

	for _, role in pairs(ROLES) do
		if role ~= DETECTIVE then -- never reset detectives -- will be later
			table.Add(mergedList, tmp[role.index])

			-- maybe remove second check to enable traitors that other traitors cant see ?
			if not role.visibleForTraitors and role.defaultTeam ~= TEAM_TRAITOR then -- prevent resetting visible players and traitors for traitors
				table.Add(mergedListForTraitor, tmp[role.index])
			end
		end
	end

	table.Shuffle(mergedList)
	table.Shuffle(mergedListForTraitor)

	-- traitors get actual innocent, so they do not reset their traitor mates to innocence
	SendRoleListMessage(ROLE_INNOCENT, mergedListForTraitor, GetRoleTeamFilter(TEAM_TRAITOR))

	local tmpList = {}

	for _, v in pairs(ROLES) do
		if (v.defaultTeam == TEAM_TRAITOR or v.specialRoleFilter) and not table.HasValue(tmpList, v.defaultTeam) then
			table.insert(tmpList, v.defaultTeam)
		end
	end

	-- update everyone as innocent w/ traitors and roles with special role filtering
	SendRoleListMessage(ROLE_INNOCENT, mergedList, GetAllRolesFilterWOTeams(tmpList))
end

function SendVisibleForTraitorList()
	error("REWORK: SendVisibleForTraitorList()")

	local b = false
	local tmp = {}

	for _, v in pairs(ROLES) do
		if v.defaultTeam ~= TEAM_TRAITOR and v.visibleForTraitors then
			b = true
			tmp[v.index] = {}
		end
	end

	if not b then return end

	for _, v in ipairs(player.GetAll()) do
		local roleData = GetRoleByIndex(v:GetSubRole())

		if tmp[roleData.index] then
			table.insert(tmp[roleData.index], v:EntIndex())
		end
	end

	for k, v in pairs(tmp) do
		SendRoleListMessage(k, v, GetRoleTeamFilter(TEAM_TRAITOR))
	end
end

function SendNetworkingRolesList(subrole, rolesTbl)
	local b = false
	local tmp = {}

	for _, v in pairs(rolesTbl) do
		if v and table.HasValue(ROLES, v) then -- theoretically not necessary, but safety first
			b = true
			tmp[v.index] = {}
		end
	end

	if not b then return end

	for _, v in ipairs(player.GetAll()) do
		local roleData = GetRoleByIndex(v:GetSubRole())

		if tmp[roleData.index] then
			table.insert(tmp[roleData.index], v:EntIndex())
		end
	end

	for k, v in pairs(tmp) do
		SendRoleListMessage(k, v, GetRoleFilter(subrole))
	end
end

function SendConfirmedTraitors(ply_or_rf)
	SendTeamRoleSilList(TEAM_TRAITOR, ply_or_rf, function(p)
		return p:GetNWBool("body_found")
	end)
end

function SendConfirmedSpecial(subrole, ply_or_rf)
	SendRoleList(subrole, ply_or_rf, function(p)
		return p:GetNWBool("body_found")
	end)
end

function SendFullStateUpdate()
	SendInnocentList()

	SendVisibleForTraitorList()

	-- easy role filtering method
	for _, v in pairs(ROLES) do
		if v.networkRoles then
			SendNetworkingRolesList(v.index, v.networkRoles)
		end
	end

	hook.Run("TTT2_SendFullStateUpdate")

	-- TODO: Improve, not resending if current data is consistent

	-- send every traitor the specific role of traitor mates
	--for _, v in pairs(GetTeamRoles(TEAM_TRAITOR)) do
	--	SendRoleList(v.index, GetRoleTeamFilter(TEAM_TRAITOR))
	--end
	-- tell traitors who is traitor
	-- SendTeamRoleList(TEAM_TRAITOR, GetRoleTeamFilter(TEAM_TRAITOR))
	-- not useful to sync confirmed traitors here, so following to prevent
	-- issue if traitor had been updated as inno
	for _, ply in ipairs(player.GetAll()) do
		if not ply:GetSubRoleData().specialRoleFilter then
			if ply:HasTeam(TEAM_TRAITOR) then
				SendTeamRoleList(TEAM_TRAITOR, ply)
			else
				SendConfirmedTraitors(ply)
			end
		else
			hook.Run("TTT2_SpecialRoleFilter", ply)
		end
	end

	-- everyone should know who is detective
	SendRoleList(ROLE_DETECTIVE)

	-- update players at the end, because they were overwritten as innos, except traitors
	SendPlayerRoles()
end

function SendRoleReset(ply_or_rf)
	local plys = player.GetAll()

	net.Start("TTT_RoleList")
	net.WriteUInt(ROLE_INNOCENT, ROLE_BITS)

	net.WriteUInt(#plys, 8)
	for _, v in ipairs(plys) do
		net.WriteUInt(v:EntIndex() - 1, 7)
	end

	if ply_or_rf then
		net.Send(ply_or_rf)
	else
		net.Broadcast()
	end
end

---- Console commands

local function request_rolelist(ply)
	-- Client requested a state update. Note that the client can only use this
	-- information after entities have been initialized (e.g. in InitPostEntity).
	if GetRoundState() ~= ROUND_WAIT then
		SendRoleReset(ply) -- reset every player for ply

		-- now everyone is inno
		SendVisibleForTraitorList()

		-- easy role filtering method
		for _, v in pairs(ROLES) do
			if v.networkRoles then
				SendNetworkingRolesList(v.index, v.networkRoles)
			end
		end

		-- just send detectives to all
		SendRoleList(ROLE_DETECTIVE, ply)

		-- update traitors
		if not ply:GetSubRoleData().specialRoleFilter then
			if ply:HasTeam(TEAM_TRAITOR) then
				SendTeamRoleList(TEAM_TRAITOR, ply)
			else
				SendConfirmedTraitors(ply)
			end
		else
			hook.Run("TTT2_SpecialRoleFilter", ply)
		end

		-- update own role for ply
		if ply.GetSubRole then -- prevention
			net.Start("TTT_Role")
			net.WriteUInt(ply:GetSubRole(), ROLE_BITS)
			net.Send(ply)
		end
	end
end
concommand.Add("_ttt_request_rolelist", request_rolelist)

-- override
local function force_terror(ply)
	ply:UpdateRole(ROLE_INNOCENT)
	ply:UnSpectate()
	ply:SetTeam(TEAM_TERROR)

	ply:StripAll()

	ply:Spawn()
	ply:PrintMessage(HUD_PRINTTALK, "You are now on the terrorist team.")

	SendFullStateUpdate()
end
concommand.Add("ttt_force_terror", force_terror, nil, nil, FCVAR_CHEAT)

-- override
local function force_traitor(ply)
	ply:UpdateRole(ROLE_TRAITOR)

	SendFullStateUpdate()
end
concommand.Add("ttt_force_traitor", force_traitor, nil, nil, FCVAR_CHEAT)

-- override
local function force_detective(ply)
	ply:UpdateRole(ROLE_DETECTIVE)

	SendFullStateUpdate()
end
concommand.Add("ttt_force_detective", force_detective, nil, nil, FCVAR_CHEAT)

local function force_role(ply, cmd, args, argStr)
	local role = tonumber(args[1])
	local i = 1

	for _, v in pairs(ROLES) do
		i = i + 1
	end

	local rd = GetRoleByIndex(role)

	if role and role <= i and not rd.notSelectable then
		ply:UpdateRole(role)

		SendFullStateUpdate()

		ply:ChatPrint("You changed to '" .. rd.name .. "' (role: " .. role .. ")")
	end
end
concommand.Add("ttt_force_role", force_role, nil, nil, FCVAR_CHEAT)

local function get_role(ply)
	net.Start("TTT2_Test_role")
	net.Send(ply)
end
concommand.Add("get_role", get_role)

local function toggle_role(ply, cmd, args, argStr)
	if ply:IsAdmin() then
		local role = tonumber(args[1])
		local roleData = GetRoleByIndex(role)
		local currentState = not GetConVar("ttt_" .. roleData.name .. "_enabled"):GetBool()

		local word = currentState and "disabled" or "enabled"

		RunConsoleCommand("ttt_" .. roleData.name .. "_enabled", currentState and "1" or "0")

		ply:ChatPrint("You " .. word .. " role with index '" .. role .. "(" .. roleData.name .. ")'. This will take effect in the next role selection!")
	end
end
concommand.Add("ttt_toggle_role", toggle_role)

local function force_spectate(ply, cmd, arg)
	if IsValid(ply) then
		if #arg == 1 and tonumber(arg[1]) == 0 then
			ply:SetForceSpec(false)
		else
			if not ply:IsSpec() then
				ply:Kill()
			end

			GAMEMODE:PlayerSpawnAsSpectator(ply)

			ply:SetTeam(TEAM_SPEC)
			ply:SetForceSpec(true)
			ply:Spawn()

			ply:SetRagdollSpec(false) -- dying will enable this, we don't want it here
		end
	end
end
concommand.Add("ttt_spectate", force_spectate)

net.Receive("TTT_Spectate", function(l, pl)
	force_spectate(pl, nil, {net.ReadBool() and 1 or 0})
end)

error("TODO: rework traitorstate.lua")

local function roles_index(ply)
	if ply:IsAdmin() then
		ply:ChatPrint("[TTT2] roles_index...")
		ply:ChatPrint("----------------")
		ply:ChatPrint("[Role] | [Index]")

		for _, v in pairs(GetSortedRoles()) do
			ply:ChatPrint(v.name .. " | " .. v.index)
		end

		ply:ChatPrint("----------------")
	end
end
concommand.Add("ttt_roles_index", roles_index)
