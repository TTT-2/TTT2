---- Role state communication

-- Send every player the subrole
local function SendPlayerRoles()
	for _, v in ipairs(player.GetAll()) do
		if IsValid(v) and v.GetSubRole then -- prevention
			net.Start("TTT_Role")
			net.WriteUInt(v:GetSubRole(), ROLE_BITS)
			net.WriteString(v:GetTeam())
			net.Send(v)
		end
	end
end

function SendRoleListMessage(subrole, team, sids, ply_or_rf)
	net.Start("TTT_RoleList")
	net.WriteUInt(subrole, ROLE_BITS)
	net.WriteString(team)

	-- list contents
	local num_ids = #sids

	net.WriteUInt(num_ids, 8)

	for i = 1, num_ids do
		net.WriteUInt(sids[i] - 1, 7)
	end

	if ply_or_rf then
		net.Send(ply_or_rf)
	else
		net.Broadcast()
	end
end

function SendRoleList(subrole, ply_or_rf, pred)
	local team_ids = {}

	for _, v in ipairs(player.GetAll()) do
		if v:IsRole(subrole) and (not pred or (pred and pred(v))) then
			local team = v:GetTeam()

			team_ids[team] = team_ids[team] or {} -- create table if it does not exists

			table.insert(team_ids[team], v:EntIndex())
		end
	end

	for team, ids in pairs(team_ids) do
		SendRoleListMessage(subrole, team, ids, ply_or_rf)
	end
end

function SendTeamList(team, ply_or_rf, pred)
	local team_ids = {}

	for _, v in ipairs(player.GetAll()) do
		if v:HasTeam(team) and (not pred or (pred and pred(v))) then
			local subrole = v:GetSubRole()

			team_ids[subrole] = team_ids[subrole] or {} -- create table if it does not exists

			table.insert(team_ids[subrole], v:EntIndex())
		end
	end

	for subrole, ids in pairs(team_ids) do
		SendRoleListMessage(subrole, team, ids, ply_or_rf)
	end
end

function SendConfirmedTeam(team, ply_or_rf)
	local _func = function(p)
		return p:GetNWBool("body_found")
	end

	return SendTeamList(team, ply_or_rf, _func)
end

function SendPlayerToEveryone(ply, ply_or_rf)
	return SendRoleListMessage(ply:GetSubRole(), ply:GetTeam(), {ply:EntIndex()}, ply_or_rf)
end

-- TODO Improve, not resending if current data is consistent
function SendFullStateUpdate()
	SendRoleReset() -- reset every player; now everyone is inno

	for _, v in ipairs(GetAvailableTeams()) do
		if v ~= TEAM_INNO then
			SendTeamList(v, GetTeamFilter(v))
			SendConfirmedTeam(v)
		end
	end

	for _, v in pairs(GetRoles()) do
		if v.visibleForTraitors then
			SendRoleList(v.index, GetTeamFilter(TEAM_TRAITOR))
		end
	end

	SendRoleList(ROLE_DETECTIVE) -- everyone should know who is detective

	hook.Run("TTT2SpecialRoleSyncing") -- maybe some networking for a custom role

	SendPlayerRoles() -- update players at the end, because they were overwritten as innos
end

function SendRoleReset(ply_or_rf)
	local ids = {}

	for _, ply in ipairs(player.GetAll()) do
		table.insert(ids, ply:EntIndex())
	end

	SendRoleListMessage(ROLE_INNOCENT, TEAM_INNO, ids, ply_or_rf)
end

---- Console commands
local function ttt_request_rolelist(ply)
	-- Client requested a state update. Note that the client can only use this
	-- information after entities have been initialized (e.g. in InitPostEntity).
	if GetRoundState() ~= ROUND_WAIT then
		SendRoleReset(ply) -- reset every player for ply; now everyone is inno
		SendTeamList(ply:GetTeam(), ply) -- send list of team to ply

		for _, v in ipairs(GetAvailableTeams()) do
			if v ~= TEAM_INNO then
				SendConfirmedTeam(v, ply)
			end
		end

		for _, v in pairs(GetRoles()) do
			if v.visibleForTraitors then
				SendRoleList(v.index, ply)
			end
		end

		SendRoleList(ROLE_DETECTIVE, ply) -- just send detectives to ply

		hook.Run("TTT2SpecialRoleSyncing", ply) -- maybe some networking for a custom role

		-- update own role for ply because they were overwritten as innos
		net.Start("TTT_Role")
		net.WriteUInt(ply:GetSubRole(), ROLE_BITS)
		net.WriteString(ply:GetTeam())
		net.Send(ply)
	end
end
concommand.Add("_ttt_request_rolelist", ttt_request_rolelist)

local function ttt_force_terror(ply)
	ply:UpdateRole(ROLE_INNOCENT)
	ply:UnSpectate()
	ply:SetTeam(TEAM_TERROR)

	ply:StripAll()

	ply:Spawn()
	ply:PrintMessage(HUD_PRINTTALK, "You are now on the terrorist team.")

	SendFullStateUpdate()
end
concommand.Add("ttt_force_terror", ttt_force_terror, nil, nil, FCVAR_CHEAT)

local function ttt_force_traitor(ply)
	ply:UpdateRole(ROLE_TRAITOR)

	SendFullStateUpdate()
end
concommand.Add("ttt_force_traitor", ttt_force_traitor, nil, nil, FCVAR_CHEAT)

local function ttt_force_detective(ply)
	ply:UpdateRole(ROLE_DETECTIVE)

	SendFullStateUpdate()
end
concommand.Add("ttt_force_detective", ttt_force_detective, nil, nil, FCVAR_CHEAT)

local function ttt_force_role(ply, cmd, args, argStr)
	local role = tonumber(args[1])
	local i = 1

	for _, v in pairs(GetRoles()) do
		i = i + 1
	end

	local rd = GetRoleByIndex(role)

	if role and role <= i and not rd.notSelectable then
		ply:UpdateRole(role)

		SendFullStateUpdate()

		ply:ChatPrint("You changed to '" .. rd.name .. "' (role: " .. role .. ")")
	end
end
concommand.Add("ttt_force_role", ttt_force_role, nil, nil, FCVAR_CHEAT)

local function get_role(ply)
	net.Start("TTT2TestRole")
	net.Send(ply)
end
concommand.Add("get_role", get_role)

local function ttt_toggle_role(ply, cmd, args, argStr)
	if ply:IsAdmin() then
		local role = tonumber(args[1])
		local roleData = GetRoleByIndex(role)
		local currentState = not GetConVar("ttt_" .. roleData.name .. "_enabled"):GetBool()

		local word = currentState and "disabled" or "enabled"

		RunConsoleCommand("ttt_" .. roleData.name .. "_enabled", currentState and "1" or "0")

		ply:ChatPrint("You " .. word .. " role with index '" .. role .. "(" .. roleData.name .. ")'. This will take effect in the next role selection!")
	end
end
concommand.Add("ttt_toggle_role", ttt_toggle_role)

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

local function TTT_Spectate(l, pl)
	force_spectate(pl, nil, {net.ReadBool() and 1 or 0})
end
net.Receive("TTT_Spectate", TTT_Spectate)

local function ttt_roles_index(ply)
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
concommand.Add("ttt_roles_index", ttt_roles_index)
