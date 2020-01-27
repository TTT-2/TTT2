-- just server file

local math = math
local chargetime = 30

local net = net
local table = table
local IsValid = IsValid
local hook = hook

local function GetSubRoleForRadar(ply, pl)
	local subrole = -1

	if not pl:IsPlayer() then
		-- Decoys appear as innocents for players from other teams
		if pl:GetNWString("decoy_owner_team", "none") ~= ply:GetTeam() then
			subrole = ROLE_INNOCENT
		else
			subrole = -1
		end
	else
		local tmp = hook.Run("TTT2ModifyRadarRole", ply, pl)

		if tmp then
			subrole = tmp
		elseif not ply:HasTeam(TEAM_TRAITOR) then
			subrole = ROLE_INNOCENT
		else
			subrole = (pl:IsInTeam(ply) or pl:GetSubRoleData().visibleForTraitors) and pl:GetSubRole() or ROLE_INNOCENT
		end
	end

	return subrole
end

local function ttt_radar_scan(ply, cmd, args)
	if not IsValid(ply) or not ply:IsTerror() then return end

	if not ply:HasEquipmentItem("item_ttt_radar") then
		LANG.Msg(ply, "radar_not_owned", nil, MSG_CHAT_WARN)

		return
	end

	if ply.radar_charge > CurTime() then
		LANG.Msg(ply, "radar_charging", nil, MSG_CHAT_WARN)

		return
	end

	ply.radar_charge = CurTime() + chargetime

	local targets, customradar

	if ply:GetSubRoleData() and ply:GetSubRoleData().CustomRadar then
		customradar = ply:GetSubRoleData().CustomRadar(ply)
	end

	if istable(customradar) then
		targets = table.Copy(customradar)
	else -- if we get no value we use default radar
		targets = {}

		local scan_ents = player.GetAll()

		table.Add(scan_ents, ents.FindByClass("ttt_decoy"))

		for i = 1, #scan_ents do
			local pl = scan_ents[i]

			if not IsValid(pl) or ply == pl or pl:IsPlayer() and (not pl:IsTerror() or pl:GetNWBool("disguised", false)) then continue end

			local pos = pl:LocalToWorld(pl:OBBCenter())

			-- Round off, easier to send and inaccuracy does not matter
			pos.x = math.Round(pos.x)
			pos.y = math.Round(pos.y)
			pos.z = math.Round(pos.z)

			local subrole = GetSubRoleForRadar(ply, pl)
			local _tmp = {subrole = subrole, pos = pos}

			targets[#targets + 1] = _tmp
		end
	end

	net.Start("TTT_Radar")
	net.WriteUInt(#targets, 8)

	for i = 1, #targets do
		local tgt = targets[i]

		net.WriteUInt(tgt.subrole, ROLE_BITS)
		net.WriteInt(tgt.pos.x, 32)
		net.WriteInt(tgt.pos.y, 32)
		net.WriteInt(tgt.pos.z, 32)
	end

	net.Send(ply)
end
concommand.Add("ttt_radar_scan", ttt_radar_scan)
