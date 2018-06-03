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
	local rd = GetRoleByIndex(r)
	local equip = GetEquipmentFileName(net.ReadString())
	
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
net.Receive("shopFallback", function(len, ply)
	local role = net.ReadUInt(ROLE_BITS) + 1
	local fallback = net.ReadString()
	
	local rd = GetRoleByIndex(role)
	
	GetConVar("ttt_" .. rd.abbr .. "_shop_fallback"):SetString(fallback)
end)