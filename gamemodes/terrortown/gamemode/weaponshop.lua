util.AddNetworkString("newshop")
concommand.Add("Weaponshop", function(ply, cmd, args)
	net.Start("newshop")
	net.Send(ply)
end)

-- TODO rebuild with database handling instead of dini file creation like
util.AddNetworkString("shop")
net.Receive("shop", function(len, ply)
	local add = net.ReadBool()
	local r = net.ReadUInt(ROLE_BITS) + 1
	local eq = net.ReadString()
	
	local equip = GetEquipmentFileName(eq)
	local is_item = GetEquipmentItemByFileName(equip)
	
	equip = not is_item and eq or equip
	
	local rd = GetRoleByIndex(r)
	local role = string.lower(rd.name)
	
	local filename = "roleweapons/" .. role .. "/" .. equip .. ".txt"
	
	if add then
		if not file.Exists(filename, "DATA") then
			file.CreateDir("roleweapons") -- Create the directory
			file.CreateDir("roleweapons/" .. role) -- Create the directory
			file.Write(filename, "") -- Write to .txt
			
			local is_item = GetEquipmentItemByFileName(equip)
			local wep = not is_item and GetWeaponNameByFileName(equip)
			
			local wepTbl = wep and weapons.GetStored(wep)
			if wepTbl then
				AddEquipmentWeaponToRole(rd.index, wepTbl)
			elseif is_item then
				AddEquipmentItemToRole(rd.index, is_item)
			end
			
			-- last but not least, notify each player
			for _, v in pairs(player.GetAll()) do
				v:ChatPrint("[TTT2][SHOP] " .. ply:Nick() .. " added '" .. equip .. "' into the shop of the " .. role)
			end
		end
	else
		if file.Exists(filename, "DATA") then
			file.Delete(filename) -- Write to .txt
			
			local is_item = GetEquipmentItemByFileName(equip)
			local wep = not is_item and GetWeaponNameByFileName(equip)
			
			local wepTbl = wep and weapons.GetStored(wep)
			if wepTbl then
				RemoveEquipmentWeaponFromRole(rd.index, wepTbl)
			elseif is_item then
				RemoveEquipmentItemFromRole(rd.index, is_item)
			end
			
			-- last but not least, notify each player
			for _, v in pairs(player.GetAll()) do
				v:ChatPrint("[TTT2][SHOP] " .. ply:Nick() .. " removed '" .. equip .. "' from the shop of the " .. role)
			end
		end
	end
end)

util.AddNetworkString("shopFallback")
util.AddNetworkString("shopFallbackAnsw")
util.AddNetworkString("shopFallbackRefresh")
net.Receive("shopFallback", function(len, ply)
	local role = net.ReadUInt(ROLE_BITS) + 1
	local fallback = net.ReadString()
	
	local rd = GetRoleByIndex(role)
	
	RunConsoleCommand("ttt_" .. rd.abbr .. "_shop_fallback", fallback)
end)

local function OnChangeCVar(role, fallback)
	local rd = GetRoleByIndex(role)

	-- reset equipment
	EquipmentItems[role] = {}
	
	for _, v in ipairs(weapons.GetList()) do
		if v.CanBuy then
			for k, vi in ipairs(v.CanBuy) do
				if vi == role then
					table.remove(v.CanBuy, k) -- TODO does it work?
					
					break
				end
			end
		end
	end
	
	net.Start("shopFallbackAnsw")
	net.WriteUInt(role - 1, ROLE_BITS)
	net.Broadcast()
	
	if fallback ~= "DISABLED" then
		if fallback ~= "UNSET" and role == GetRoleByName(fallback).index then
			LoadSingleShopEquipment(rd)
			
			net.Start("shopFallbackRefresh")
			net.Broadcast()
		elseif fallback == "UNSET" then
			if role == ROLES.TRAITOR.index then
				-- set everything
				for _, eq in ipairs(EQUIPMENT_DEFAULT_TRAITOR) do
					local is_item = tonumber(eq.id)
					if is_item then
						table.insert(EquipmentItems[role], eq)
					else
						local wepTbl = weapons.GetStored(eq.id)
						if wepTbl then
							wepTbl.CanBuy = wepTbl.CanBuy or {}
							
							table.insert(wepTbl.CanBuy, role)
						end
					end
				end
			elseif role == ROLES.DETECTIVE.index then
				-- set everything
				for _, eq in ipairs(EQUIPMENT_DEFAULT_DETECTIVE) do
					local is_item = tonumber(eq.id)
					if is_item then
						table.insert(EquipmentItems[role], eq)
					else
						local wepTbl = weapons.GetStored(eq.id)
						if wepTbl then
							wepTbl.CanBuy = wepTbl.CanBuy or {}
							
							table.insert(wepTbl.CanBuy, role)
						end
					end
				end
			end
		end
	end
end

hook.Add("TTT2_FinishedSync", "WeaponShopChangeCVARInit", function(ply, first)
	if first then
		for _, v in pairs(ROLES) do
			cvars.AddChangeCallback("ttt_" .. v.abbr .. "_shop_fallback", function(convar_name, value_old, value_new)
				if value_old ~= value_new then
					OnChangeCVar(v.index, value_new)
				end
			end)
		end
	end
end)
