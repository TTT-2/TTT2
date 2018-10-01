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

function SendRoleListMessage(subrole, team, subrole_ids, ply_or_rf)
	net.Start("TTT_RoleList")
	net.WriteUInt(subrole, ROLE_BITS)
	net.WriteString(team)

	-- list contents
	local num_ids = #subrole_ids

	net.WriteUInt(num_ids, 8)

	for i = 1, num_ids do
		net.WriteUInt(subrole_ids[i] - 1, 7)
	end

	if ply_or_rf then
		net.Send(ply_or_rf)
	else
		net.Broadcast()
	end
end

function SendRoleList(subrole, ply_or_rf, pred)
	local subrole_ids = {}

	for _, v in ipairs(player.GetAll()) do
		if v:IsRole(subrole) and (not pred or (pred and pred(v))) then
			local team = v:GetTeam()

			subrole_ids[team] = subrole_ids[team] or {} -- create table if it does not exists

			table.insert(subrole_ids[team], v:EntIndex())
		end
	end

	for team, ids in pairs(subrole_ids) do
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

	local filter = GetTeamFilter(team)

	for subrole, ids in pairs(team_ids) do
		SendRoleListMessage(subrole, team, ids, filter)
	end
end

function SendVisibleForTeamList(team, ply_or_rf)
	local tmp = {}

	for _, v in ipairs(player.GetAll()) do
		if v:HasTeam(team) then
			local subrole = v:GetSubRole()

			tmp[subrole] = tmp[subrole] or {} -- create table if it does not exists

			table.insert(tmp[subrole], v:EntIndex())
		end
	end

	for k, v in pairs(tmp) do
		SendRoleListMessage(k, team, v, ply_or_rf or GetTeamFilter(team))
	end
end

function SendConfirmedTeam(team, ply_or_rf)
	return SendTeamList(team, ply_or_rf, function(p)
		return p:GetNWBool("body_found")
	end)
end

-- TODO Improve, not resending if current data is consistent
function SendFullStateUpdate()
	SendRoleReset() -- reset every player; now everyone is inno
	SendVisibleForTeamList(TEAM_TRAITOR) -- send traitors
	SendRoleList(ROLE_DETECTIVE) -- everyone should know who is detective

	hook.Run("TTT2SpecialRoleFilter") -- maybe some networking for a custom role

	SendPlayerRoles() -- update players at the end, because they were overwritten as innos
end

function SendRoleReset(ply_or_rf)
	SendRoleListMessage(ROLE_INNOCENT, TEAM_INNO, player.GetAll(), ply_or_rf)
end

---- Console commands
concommand.Add("_ttt_request_rolelist", function(ply)
	-- Client requested a state update. Note that the client can only use this
	-- information after entities have been initialized (e.g. in InitPostEntity).
	if GetRoundState() ~= ROUND_WAIT then
		SendRoleReset(ply) -- reset every player for ply; now everyone is inno
		SendVisibleForTeamList(TEAM_TRAITOR, ply) -- send traitors to ply
		SendRoleList(ROLE_DETECTIVE, ply) -- just send detectives to ply

		hook.Run("TTT2SpecialRoleFilter", ply) -- maybe some networking for a custom role

		-- update own role for ply because they was overwritten as innos
		net.Start("TTT_Role")
		net.WriteUInt(ply:GetSubRole(), ROLE_BITS)
		net.WriteString(ply:GetTeam())
		net.Send(ply)
	end
end)

concommand.Add("ttt_force_terror", function(ply)
	ply:UpdateRole(ROLE_INNOCENT)
	ply:UnSpectate()
	ply:SetTeam(TEAM_TERROR)

	ply:StripAll()

	ply:Spawn()
	ply:PrintMessage(HUD_PRINTTALK, "You are now on the terrorist team.")

	SendFullStateUpdate()
end, nil, nil, FCVAR_CHEAT)

concommand.Add("ttt_force_traitor", function(ply)
	ply:UpdateRole(ROLE_TRAITOR)

	SendFullStateUpdate()
end, nil, nil, FCVAR_CHEAT)

concommand.Add("ttt_force_detective", function(ply)
	ply:UpdateRole(ROLE_DETECTIVE)

	SendFullStateUpdate()
end, nil, nil, FCVAR_CHEAT)

concommand.Add("ttt_force_role", function(ply, cmd, args, argStr)
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
end, nil, nil, FCVAR_CHEAT)

concommand.Add("get_role", function(ply)
	net.Start("TTT2TestRole")
	net.Send(ply)
end)

concommand.Add("ttt_toggle_role", function(ply, cmd, args, argStr)
	if ply:IsAdmin() then
		local role = tonumber(args[1])
		local roleData = GetRoleByIndex(role)
		local currentState = not GetConVar("ttt_" .. roleData.name .. "_enabled"):GetBool()

		local word = currentState and "disabled" or "enabled"

		RunConsoleCommand("ttt_" .. roleData.name .. "_enabled", currentState and "1" or "0")

		ply:ChatPrint("You " .. word .. " role with index '" .. role .. "(" .. roleData.name .. ")'. This will take effect in the next role selection!")
	end
end)

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

concommand.Add("ttt_roles_index", function(ply)
	if ply:IsAdmin() then
		ply:ChatPrint("[TTT2] roles_index...")
		ply:ChatPrint("----------------")
		ply:ChatPrint("[Role] | [Index]")

		for _, v in pairs(GetSortedRoles()) do
			ply:ChatPrint(v.name .. " | " .. v.index)
		end

		ply:ChatPrint("----------------")
	end
end)
