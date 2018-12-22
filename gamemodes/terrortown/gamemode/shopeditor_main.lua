util.AddNetworkString("newshop")

function ShopEditor.ShopEditor(ply, cmd, args)
	if ply:IsAdmin() then
		net.Start("newshop")
		net.Send(ply)
	end
end
concommand.Add("shopeditor", ShopEditor.ShopEditor)

-- TODO rebuild with database handling instead of dini file creation like
function ShopEditor.ShopEditorHasEquipment(roleData, equip)
	local rolename = string.lower(roleData.name)
	local filename = "roleweapons/" .. rolename .. "/" .. equip .. ".txt"

	return file.Exists(filename, "DATA")
end

function ShopEditor.AddToShopEditor(ply, roleData, equip)
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

function ShopEditor.RemoveFromShopEditor(ply, roleData, equip)
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
local function shop(len, ply)
	local add = net.ReadBool()
	local subrole = net.ReadUInt(ROLE_BITS)
	local eq = net.ReadString()

	local equip = GetEquipmentFileName(eq)
	local rd = GetRoleByIndex(subrole)

	if add then
		ShopEditor.AddToShopEditor(ply, rd, equip)
	else
		ShopEditor.RemoveFromShopEditor(ply, rd, equip)
	end
end
net.Receive("shop", shop)

util.AddNetworkString("TTT2SESaveItem")
local function TTT2SESaveItem(_, ply)
	local name, item = ShopEditor.ReadItemData()

	if not item then return end

	ShopEditor.WriteItemData("TTT2SESaveItem", item)
	ShopEditor.SaveItem(name, item, ShopEditor.savingKeys)
end
net.Receive("TTT2SESaveItem", TTT2SESaveItem)

util.AddNetworkString("shopFallback")
util.AddNetworkString("shopFallbackAnsw")
util.AddNetworkString("shopFallbackReset")
util.AddNetworkString("shopFallbackRefresh")
local function shopFallback(len, ply)
	local subrole = net.ReadUInt(ROLE_BITS)
	local fallback = net.ReadString()

	local rd = GetRoleByIndex(subrole)

	RunConsoleCommand("ttt_" .. rd.abbr .. "_shop_fallback", fallback)
end
net.Receive("shopFallback", shopFallback)

function ShopEditor.OnChangeWSCVar(subrole, fallback, ply_or_rf)
	local rd = GetRoleByIndex(subrole)

	-- reset equipment
	EquipmentItems[subrole] = {}
	SYNC_EQUIP[subrole] = {}

	for _, v in ipairs(weapons.GetList()) do
		if v.CanBuy then
			for k, vi in ipairs(v.CanBuy) do
				if vi == subrole then
					table.remove(v.CanBuy, k) -- TODO does it work?

					break
				end
			end
		end
	end

	-- reset and set if it's a fallback
	net.Start("shopFallbackAnsw")
	net.WriteUInt(subrole, ROLE_BITS)
	net.WriteString(fallback)

	if ply_or_rf then
		net.Send(ply_or_rf)
	else
		net.Broadcast()
	end

	if fallback ~= SHOP_DISABLED then
		if fallback ~= SHOP_UNSET and fallback == rd.name then
			LoadSingleShopEquipment(rd)

			ply_or_rf = ply_or_rf or player.GetAll()

			if not istable(ply_or_rf) then
				ply_or_rf = {ply_or_rf}
			end

			for _, ply in ipairs(ply_or_rf) do
				SyncEquipment(ply)
			end

			net.Start("shopFallbackRefresh")

			if ply_or_rf then
				net.Send(ply_or_rf)
			else
				net.Broadcast()
			end
		elseif fallback == SHOP_UNSET then
			if rd.fallbackTable then
				-- set everything
				for _, eq in ipairs(rd.fallbackTable) do
					local is_item = tonumber(eq.id)
					if is_item then
						table.insert(EquipmentItems[subrole], eq)
					else
						local wepTbl = weapons.GetStored(eq.id)
						if wepTbl then
							wepTbl.CanBuy = wepTbl.CanBuy or {}

							table.insert(wepTbl.CanBuy, subrole)
						end
					end
				end
			end
		end
	end
end

function ShopEditor.SetupShopEditorCVars()
	for _, v in pairs(GetRoles()) do
		local _func = function(convar_name, value_old, value_new)
			if value_old ~= value_new then
				print(convar_name .. ": Changing fallback from " .. value_old .. " to " .. value_new)
				SetGlobalString("ttt_" .. v.abbr .. "_shop_fallback", value_new)
				ShopEditor.OnChangeWSCVar(v.index, value_new)
			end
		end

		cvars.AddChangeCallback("ttt_" .. v.abbr .. "_shop_fallback", _func)
	end
end
