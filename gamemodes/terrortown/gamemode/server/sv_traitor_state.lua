---- Role state communication
TTT2NETTABLE = {}

local net = net
local table = table
local pairs = pairs
local ipairs = ipairs
local IsValid = IsValid
local player = player
local hook = hook

-- TODO improve, e.g. if sending every role to everyone on RoundEnd()!
function SendRoleListMessage(subrole, team, sids, ply_or_rf)
	-- TODO add role hacking

	local tmp = ply_or_rf or player.GetAll()

	if not istable(tmp) then
		tmp = {ply_or_rf}
	end

	for _, ply in ipairs(tmp) do
		local adds = {}
		local localPly = false
		local num_ids = #sids

		TTT2NETTABLE[ply] = TTT2NETTABLE[ply] or {}

		for i = 1, num_ids do
			local eidx = sids[i]
			local p = Entity(eidx)

			if not TTT2NETTABLE[ply][p] or TTT2NETTABLE[ply][p][1] ~= subrole or TTT2NETTABLE[ply][p][2] ~= team then
				TTT2NETTABLE[ply][p] = {subrole, team}

				if p ~= ply then
					local rs = GetRoundState()

					if p:GetSubRoleData().disableSync
					and rs == ROUND_ACTIVE
					and not p:GetNWBool("body_found", false)
					and not hook.Run("TTT2OverrideDisabledSync", ply, p)
					then continue end

					table.insert(adds, eidx)
				else
					localPly = true
				end
			end
		end

		num_ids = #adds

		if num_ids > 0 then
			net.Start("TTT_RoleList")
			net.WriteUInt(subrole, ROLE_BITS)
			net.WriteString(team)

			-- list contents
			net.WriteUInt(num_ids, 8)

			for i = 1, num_ids do
				net.WriteUInt(adds[i] - 1, 7)
			end

			net.Send(ply)
		end

		if localPly then
			net.Start("TTT_Role")
			net.WriteUInt(subrole, ROLE_BITS)
			net.WriteString(team)
			net.Send(ply)
		end
	end
end

function SendSubRoleList(subrole, ply_or_rf, pred)
	local team_ids = {}

	for _, v in ipairs(player.GetAll()) do
		if v:GetSubRole() == subrole and (not pred or (pred and pred(v))) then
			local team = v:GetTeam()
			if team ~= TEAM_NONE and not TEAMS[team].alone then
				team_ids[team] = team_ids[team] or {} -- create table if it does not exists

				table.insert(team_ids[team], v:EntIndex())
			end
		end
	end

	for team, ids in pairs(team_ids) do
		SendRoleListMessage(subrole, team, ids, ply_or_rf)
	end
end

function SendRoleList(subrole, ply_or_rf, pred)
	local team_ids = {}

	for _, v in ipairs(player.GetAll()) do
		if v:IsRole(subrole) and (not pred or (pred and pred(v))) then
			local team = v:GetTeam()
			if team ~= TEAM_NONE and not TEAMS[team].alone then
				team_ids[team] = team_ids[team] or {} -- create table if it does not exists

				table.insert(team_ids[team], v:EntIndex())
			end
		end
	end

	for team, ids in pairs(team_ids) do
		SendRoleListMessage(subrole, team, ids, ply_or_rf)
	end
end

function SendTeamList(team, ply_or_rf, pred)
	if team == TEAM_NONE or TEAMS[team].alone then return end

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
	if team == TEAM_NONE or TEAMS[team].alone then return end

	local _func = function(p)
		return p:GetNWBool("body_found")
	end

	return SendTeamList(team, ply_or_rf, _func)
end

function SendPlayerToEveryone(ply, ply_or_rf)
	return SendRoleListMessage(ply:GetSubRole(), ply:GetTeam(), {ply:EntIndex()}, ply_or_rf)
end

-- TODO Improve, merging data to send netmsg for players that will receive same data
function SendFullStateUpdate()
	local syncTbl = {}
	local localPly = false
	local players = player.GetAll()

	for _, ply in ipairs(players) do
		local tmp = {}
		local team = ply:GetTeam()
		local roleData = ply:GetSubRoleData()

		for _, v in ipairs(players) do
			local rd = v:GetSubRoleData()

			if not roleData.unknownTeam and v:HasTeam(team)
			or v:GetNWBool("body_found")
			or team == TEAM_TRAITOR and rd.visibleForTraitors
			or roleData.networkRoles and table.HasValue(roleData.networkRoles, rd)
			or v:GetBaseRole() == ROLE_DETECTIVE
			or ply == v
			then
				tmp[v] = {v:GetSubRole() or ROLE_INNOCENT, v:GetTeam() or TEAM_INNOCENT}
			else
				tmp[v] = {ROLE_INNOCENT, TEAM_INNOCENT}
			end
		end

		hook.Run("TTT2SpecialRoleSyncing", ply, tmp) -- maybe some networking for custom roles or role hacking

		syncTbl[ply] = {}

		TTT2NETTABLE[ply] = TTT2NETTABLE[ply] or {}

		for p, t in pairs(tmp) do
			if p ~= ply then
				syncTbl[ply][t[2]] = syncTbl[ply][t[2]] or {}
				syncTbl[ply][t[2]][t[1]] = syncTbl[ply][t[2]][t[1]] or {}

				table.insert(syncTbl[ply][t[2]][t[1]], p:EntIndex())
			elseif not TTT2NETTABLE[ply][p] or TTT2NETTABLE[ply][p][1] ~= t[1] or TTT2NETTABLE[ply][p][2] ~= t[2] then
				localPly = true
			end
		end

		for tm, t in pairs(syncTbl[ply]) do
			for sr, sids in pairs(t) do
				SendRoleListMessage(sr, tm, sids, ply)
			end
		end

		-- update own subrole for ply
		if localPly then
			TTT2NETTABLE[ply][ply] = {tmp[ply][1], tmp[ply][2]}

			net.Start("TTT_Role")
			net.WriteUInt(tmp[ply][1], ROLE_BITS)
			net.WriteString(tmp[ply][2])
			net.Send(ply)
		end
	end
end

function SendRoleReset(ply_or_rf)
	local players = player.GetAll()

	for _, ply in ipairs(players) do
		TTT2NETTABLE[ply] = TTT2NETTABLE[ply] or {}

		for _, p in ipairs(players) do
			TTT2NETTABLE[ply][p] = {ROLE_INNOCENT, TEAM_INNOCENT}
		end
	end

	net.Start("TTT_RoleReset")

	if ply_or_rf then
		net.Send(ply_or_rf)
	else
		net.Broadcast()
	end
end

---- Console commands
local function ttt_request_rolelist(ply)
	-- Client requested a state update. Note that the client can only use this
	-- information after entities have been initialized (e.g. in InitPostEntity).
	if GetRoundState() ~= ROUND_WAIT then
		local localPly = false
		local tmp = {}
		local team = ply:GetTeam()
		local roleData = ply:GetSubRoleData()

		for _, v in ipairs(player.GetAll()) do
			local rd = v:GetSubRoleData()

			if not ply:GetSubRoleData().unknownTeam and v:HasTeam(team)
			or v:GetNWBool("body_found")
			or team == TEAM_TRAITOR and rd.visibleForTraitors
			or roleData.networkRoles and table.HasValue(roleData.networkRoles, rd)
			or v:GetBaseRole() == ROLE_DETECTIVE
			or ply == v
			then
				tmp[v] = {v:GetSubRole(), v:GetTeam()}
			else
				tmp[v] = {ROLE_INNOCENT, TEAM_INNOCENT}
			end
		end

		hook.Run("TTT2SpecialRoleSyncing", ply, tmp) -- maybe some networking for custom roles or role hacking

		local tbl = {}

		TTT2NETTABLE[ply] = TTT2NETTABLE[ply] or {}

		for p, t in pairs(tmp) do
			if p ~= ply then
				tbl[t[2]] = tbl[t[2]] or {}
				tbl[t[2]][t[1]] = tbl[t[2]][t[1]] or {}

				table.insert(tbl[t[2]][t[1]], p:EntIndex())
			elseif not TTT2NETTABLE[ply][p] or TTT2NETTABLE[ply][p][1] ~= t[1] or TTT2NETTABLE[ply][p][2] ~= t[2] then
				localPly = true
			end
		end

		for tm, t in pairs(tbl) do
			for sr, sids in pairs(t) do
				SendRoleListMessage(sr, tm, sids, ply)
			end
		end

		-- update own subrole for ply
		if localPly then
			TTT2NETTABLE[ply][ply] = {tmp[ply][1], tmp[ply][2]}

			net.Start("TTT_Role")
			net.WriteUInt(tmp[ply][1], ROLE_BITS)
			net.WriteString(tmp[ply][2])
			net.Send(ply)
		end
	end
end
concommand.Add("_ttt_request_rolelist", ttt_request_rolelist)

local function ttt_force_terror(ply)
	ply:SetRole(ROLE_INNOCENT)
	ply:UnSpectate()
	ply:SetTeam(TEAM_TERROR)

	ply:StripAll()

	ply:Spawn()
	ply:PrintMessage(HUD_PRINTTALK, "You are now on the terrorist team.")

	SendFullStateUpdate()
end
concommand.Add("ttt_force_terror", ttt_force_terror, nil, nil, FCVAR_CHEAT)

local function ttt_force_traitor(ply)
	ply:SetRole(ROLE_TRAITOR)

	SendFullStateUpdate()
end
concommand.Add("ttt_force_traitor", ttt_force_traitor, nil, nil, FCVAR_CHEAT)

local function ttt_force_detective(ply)
	ply:SetRole(ROLE_DETECTIVE)

	SendFullStateUpdate()
end
concommand.Add("ttt_force_detective", ttt_force_detective, nil, nil, FCVAR_CHEAT)

local function ttt_force_role(ply, cmd, args, argStr)
	local role = tonumber(args[1])

	if not role then return end

	local rd

	for _, v in ipairs(roles.GetList()) do
		if v.index == role then
			rd = v

			break
		end
	end

	if rd and not rd.notSelectable then
		ply:SetRole(role)

		SendFullStateUpdate()

		ply:ChatPrint("You changed to '" .. rd.name .. "' (index: " .. role .. ")")
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
		local roleData = roles.GetByIndex(role)
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

		for _, v in ipairs(roles.GetSortedRoles()) do
			ply:ChatPrint(v.name .. " | " .. v.index)
		end

		ply:ChatPrint("----------------")
	end
end
concommand.Add("ttt_roles_index", ttt_roles_index)
