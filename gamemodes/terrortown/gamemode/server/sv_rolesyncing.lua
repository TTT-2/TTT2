---
-- Role state communication
-- @section networking

local net = net
local IsValid = IsValid
local player = player
local hook = hook

---
-- Synces each @{Player} with all the other @{Player}.
-- Based on the @{ROLE} each @{Player} has, not every @{Player} is aware of the @{ROLE} of each other
-- @note This should just be used on changing a @{Player}'s @{ROLE} if the current round is active
-- @todo Improve, merging data to send netmsg for players that will receive same data
-- @realm server
function SendFullStateUpdate()
	local plys = player.GetAll()
	local plyCount = #plys
	local rs = GetRoundState()

	for i = 1, plyCount do
		local ply = plys[i]

		for k = 1, plyCount do
			local v = plys[k]

			-- if the round has end, sync the real role of every player
			if rs == ROUND_POST then
				ply:TTT2NETSetUInt("subrole", v:GetSubRole(), ROLE_BITS, v)
				ply:TTT2NETSetString("team", v:GetTeam(), v)

				continue
			end

			---
			-- @realm server
			if hook.Run("TTT2SpecialRoleSyncing", ply, v) then continue end

			-- if player is the current player
			if ply == v then
				ply:TTT2NETSetUInt("subrole", v:GetSubRole(), ROLE_BITS, v)
				ply:TTT2NETSetString("team", v:GetTeam(), v)
			else
				ply:TTT2NETSetUInt("subrole", ROLE_NONE, ROLE_BITS, v)
				ply:TTT2NETSetString("team", TEAM_NONE, v)
			end
		end
	end
end

---
-- Console commands
---

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

	local rd = roles.GetByIndex(role)

	if rd.notSelectable then return end

	ply:SetRole(role)

	SendFullStateUpdate()

	ply:ChatPrint("You changed to '" .. rd.name .. "' (index: " .. role .. ")")
end
concommand.Add("ttt_force_role", ttt_force_role, nil, nil, FCVAR_CHEAT)

local function get_role(ply)
	net.Start("TTT2TestRole")
	net.Send(ply)
end
concommand.Add("get_role", get_role)

local function ttt_toggle_role(ply, cmd, args, argStr)
	if not ply:IsAdmin() then return end

	local role = tonumber(args[1])
	local roleData = roles.GetByIndex(role)
	local currentState = not GetConVar("ttt_" .. roleData.name .. "_enabled"):GetBool()

	local word = currentState and "disabled" or "enabled"

	RunConsoleCommand("ttt_" .. roleData.name .. "_enabled", currentState and "1" or "0")

	ply:ChatPrint("You " .. word .. " role with index '" .. role .. "(" .. roleData.name .. ")'. This will take effect in the next role selection!")
end
concommand.Add("ttt_toggle_role", ttt_toggle_role)

local function force_spectate(ply, cmd, arg)
	if not IsValid(ply) then return end

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
concommand.Add("ttt_spectate", force_spectate)

local function TTT_Spectate(_, ply)
	force_spectate(ply, nil, {net.ReadBool() and 1 or 0})
end
net.Receive("TTT_Spectate", TTT_Spectate)

local function ttt_roles_index(ply)
	if not ply:IsAdmin() then return end

	ply:ChatPrint("[TTT2] roles_index...")
	ply:ChatPrint("----------------")
	ply:ChatPrint("[Role] | [Index]")

	local rlsList = roles.GetSortedRoles()

	for i = 1, #rlsList do
		local v = rlsList[i]

		ply:ChatPrint(v.name .. " | " .. v.index)
	end

	ply:ChatPrint("----------------")
end
concommand.Add("ttt_roles_index", ttt_roles_index)
