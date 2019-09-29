-- just server file

local math = math
local chargetime = 30

local net = net
local table = table
local ipairs = ipairs
local IsValid = IsValid
local hook = hook

local function GetSubRoleForRadar(ply, p)
	local subrole = -1

	if not p:IsPlayer() then
		-- Decoys appear as innocents for non-traitors
		if not ply:HasTeam(TEAM_TRAITOR) then
			subrole = ROLE_INNOCENT
		else
			subrole = -1
		end
	else
		local tmp = hook.Run("TTT2ModifyRadarRole", ply, p)

		if tmp then
			subrole = tmp
		elseif not ply:HasTeam(TEAM_TRAITOR) then
			subrole = ROLE_INNOCENT
		else
			subrole = (p:IsInTeam(ply) or p:GetSubRoleData().visibleForTraitors) and p:GetSubRole() or ROLE_INNOCENT
		end
	end

	return subrole
end

local function ttt_radar_scan(ply, cmd, args)
	if IsValid(ply) and ply:IsTerror() then
		if ply:HasEquipmentItem("item_ttt_radar") then
			if ply.radar_charge > CurTime() then
				LANG.Msg(ply, "radar_charging")

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

				for _, p in ipairs(scan_ents) do
					if not IsValid(p) or ply == p or p:IsPlayer() and (not p:IsTerror() or p:GetNWBool("disguised", false)) then continue end

					local pos = p:LocalToWorld(p:OBBCenter())

					-- Round off, easier to send and inaccuracy does not matter
					pos.x = math.Round(pos.x)
					pos.y = math.Round(pos.y)
					pos.z = math.Round(pos.z)

					local subrole = GetSubRoleForRadar(ply, p)
					local _tmp = {subrole = subrole, pos = pos}

					targets[#targets + 1] = _tmp
				end
			end

			net.Start("TTT_Radar")
			net.WriteUInt(#targets, 8)

			for _, tgt in ipairs(targets) do
				net.WriteUInt(tgt.subrole, ROLE_BITS)
				net.WriteInt(tgt.pos.x, 32)
				net.WriteInt(tgt.pos.y, 32)
				net.WriteInt(tgt.pos.z, 32)
			end

			net.Send(ply)
		else
			LANG.Msg(ply, "radar_not_owned")
		end
	end
end
concommand.Add("ttt_radar_scan", ttt_radar_scan)
