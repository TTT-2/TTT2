-- just server file

local chargetime = 30

local math = math

concommand.Add("ttt_radar_scan", function(ply, cmd, args)
	if IsValid(ply) and ply:IsTerror() then
	if ply:HasEquipmentItem(EQUIP_RADAR) then
		if ply.radar_charge > CurTime() then
			LANG.Msg(ply, "radar_charging")

			return
		end

		ply.radar_charge = CurTime() + chargetime

		local scan_ents = player.GetAll()
		table.Add(scan_ents, ents.FindByClass("ttt_decoy"))

		local targets = {}

		for _, p in ipairs(scan_ents) do
			if IsValid(p) and ply ~= p and (p:IsPlayer() and p:IsTerror() and not p:GetNWBool("disguised", false) or not p:IsPlayer()) then
				local pos = p:LocalToWorld(p:OBBCenter())

				-- Round off, easier to send and inaccuracy does not matter
				pos.x = math.Round(pos.x)
				pos.y = math.Round(pos.y)
				pos.z = math.Round(pos.z)

				local role = p:IsPlayer() and p:GetRole() or 0

				if not p:IsPlayer() then
					-- Decoys appear as innocents for non-traitors
					if ply:GetRoleData().team ~= TEAM_TRAITOR then
						role = ROLE_INNOCENT
					end
				elseif role ~= ROLE_INNOCENT then
					local rd = GetRoleByIndex(role)

					if ply:GetRoleData().team ~= TEAM_TRAITOR then
						role = ROLE_INNOCENT
					elseif not rd.visibleForTraitors then
						role = rd.team == TEAM_TRAITOR and ROLE_TRAITOR or ROLE_INNOCENT
					end
				end

				table.insert(targets, {role = role, pos = pos})
			end
		end

		net.Start("TTT_Radar")
		net.WriteUInt(#targets, 8)

		for _, tgt in ipairs(targets) do
			net.WriteUInt(tgt.role, ROLE_BITS)
			net.WriteInt(tgt.pos.x, 32)
			net.WriteInt(tgt.pos.y, 32)
			net.WriteInt(tgt.pos.z, 32)
		end

		net.Send(ply)
	else
		LANG.Msg(ply, "radar_not_owned")
	end
end
end)
