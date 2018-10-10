-- just server file

local math = math
local chargetime = 30

local function ttt_radar_scan(ply, cmd, args)
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

					local subrole

					if not p:IsPlayer() then
						-- Decoys appear as innocents for non-traitors
						if not ply:HasTeam(TEAM_TRAITOR) then
							subrole = ROLE_INNOCENT
						else
							subrole = -1
						end
					else
						subrole = p:GetBaseRole()

						if subrole ~= ROLE_INNOCENT then
							if not ply:HasTeam(TEAM_TRAITOR) then
								subrole = ROLE_INNOCENT
							elseif not ply:GetSubRoleData().visibleForTraitors then
								subrole = ROLE_TRAITOR
							else
								subrole = p:GetBaseRole()
							end
						end
					end

					local _tmp = {subrole = subrole, pos = pos}

					table.insert(targets, _tmp)
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
