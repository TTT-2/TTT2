util.AddNetworkString("newshop")
concommand.Add("Weaponshop", function(ply, cmd, args)
	net.Start("newshop")
	net.Send(ply)
end)

-- TODO rebuild with database handling instead of dini file creation like
function WeaponshopHasEquipment(roleData, equip)
	local rolename = string.lower(roleData.name)
	local filename = "roleweapons/" .. rolename .. "/" .. equip .. ".txt"

	return file.Exists(filename, "DATA")
end

function AddToWeaponshop(ply, roleData, equip)
	local rolename = string.lower(roleData.name)
	local filename = "roleweapons/" .. rolename .. "/" .. equip .. ".txt"

	if not file.Exists(filename, "DATA") then
		file.CreateDir("roleweapons") -- Create the directory
		file.CreateDir("roleweapons/" .. rolename) -- Create the directory
		file.Write(filename, "") -- Write to .txt

		local is_item = GetEquipmentItemByFileName(equip)
		local wep = not is_item and GetWeaponNameByFileName(equip)

		local wepTbl = wep and weapons.GetStored(wep)
		if wepTbl then
			AddEquipmentWeaponToRole(roleData.index, wepTbl)
		elseif is_item then
			AddEquipmentItemToRole(roleData.index, is_item)
		end

		-- last but not least, notify each player
		for _, v in ipairs(player.GetAll()) do
			v:ChatPrint("[TTT2][SHOP] " .. ply:Nick() .. " added '" .. equip .. "' into the shop of the " .. rolename)
		end
	end
end

function RemoveFromWeaponshop(ply, roleData, equip)
	local rolename = string.lower(roleData.name)
	local filename = "roleweapons/" .. rolename .. "/" .. equip .. ".txt"

	if file.Exists(filename, "DATA") then
		file.Delete(filename) -- Write to .txt

		local is_item = GetEquipmentItemByFileName(equip)
		local wep = not is_item and GetWeaponNameByFileName(equip)

		local wepTbl = wep and weapons.GetStored(wep)
		if wepTbl then
			RemoveEquipmentWeaponFromRole(roleData.index, wepTbl)
		elseif is_item then
			RemoveEquipmentItemFromRole(roleData.index, is_item)
		end

		-- last but not least, notify each player
		for _, v in ipairs(player.GetAll()) do
			v:ChatPrint("[TTT2][SHOP] " .. ply:Nick() .. " removed '" .. equip .. "' from the shop of the " .. rolename)
		end
	end
end

util.AddNetworkString("shop")
net.Receive("shop", function(len, ply)
	local add = net.ReadBool()
	local role = net.ReadUInt(ROLE_BITS)
	local eq = net.ReadString()

	local equip = GetEquipmentFileName(eq)
	local is_item = GetEquipmentItemByFileName(equip)

	equip = not is_item and eq or equip

	local rd = GetRoleByIndex(role)

	if add then
		AddToWeaponshop(ply, rd, equip)
	else
		RemoveFromWeaponshop(ply, rd, equip)
	end
end)

util.AddNetworkString("shopFallback")
util.AddNetworkString("shopFallbackAnsw")
util.AddNetworkString("shopFallbackRefresh")
net.Receive("shopFallback", function(len, ply)
	local role = net.ReadUInt(ROLE_BITS)
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
	net.WriteUInt(role, ROLE_BITS)
	net.Broadcast()

	if fallback ~= SHOP_DISABLED then
		if fallback ~= SHOP_UNSET and role == GetRoleByName(fallback).index then
			LoadSingleShopEquipment(rd)

			net.Start("shopFallbackRefresh")
			net.Broadcast()
		elseif fallback == SHOP_UNSET then
			if rd.fallbackTable then
				-- set everything
				for _, eq in ipairs(rd.fallbackTable) do
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
