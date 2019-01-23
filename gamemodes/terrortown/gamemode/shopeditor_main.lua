local net = net
local table = table
local pairs = pairs
local ipairs = ipairs
local sql = sql
local util = util

util.AddNetworkString("newshop")
util.AddNetworkString("TTT2UpdateCVar")

net.Receive("TTT2UpdateCVar", function()
	RunConsoleCommand(net.ReadString(), net.ReadString())
end)

ShopEditor.ShopTablePre = "ttt2_shop_"

function ShopEditor.ShopEditor(ply, cmd, args)
	if ply:IsAdmin() then
		net.Start("newshop")
		net.Send(ply)
	end
end
concommand.Add("shopeditor", ShopEditor.ShopEditor)

function ShopEditor.CreateShopDB(name)
	local result

	if not sql.TableExists(ShopEditor.ShopTablePre .. name) then
		result = sql.Query("CREATE TABLE " .. ShopEditor.ShopTablePre .. name .. " (name TEXT PRIMARY KEY)")
	end

	return result ~= false
end

function ShopEditor.CreateShopDBs()
	for _, v in pairs(GetRoles()) do
		if v ~= INNOCENT then
			ShopEditor.CreateShopDB(v.name)
		end
	end
end

function ShopEditor.GetShopEquipments(roleData)
	if roleData == INNOCENT then
		return {}
	end

	local result = sql.Query("SELECT * FROM " .. ShopEditor.ShopTablePre .. roleData.name)

	if not result or not istable(result) then
		result = {}
	end

	return result
end

function ShopEditor.AddToShopEditor(ply, roleData, equip)
	sql.Query("INSERT INTO " .. ShopEditor.ShopTablePre .. roleData.name .. " VALUES ('" .. equip .. "')")

	local eq = GetEquipmentByName(equip)

	AddEquipmentToRole(roleData.index, eq)

	-- last but not least, notify each player
	for _, v in ipairs(player.GetAll()) do
		v:ChatPrint("[TTT2][SHOP] " .. ply:Nick() .. " added '" .. equip .. "' into the shop of the " .. roleData.name)
	end
end

function ShopEditor.RemoveFromShopEditor(ply, roleData, equip)
	sql.Query("DELETE FROM " .. ShopEditor.ShopTablePre .. roleData.name .. " WHERE name='" .. equip .. "'")

	local eq = GetEquipmentByName(equip)

	RemoveEquipmentFromRole(roleData.index, eq)

	-- last but not least, notify each player
	for _, v in ipairs(player.GetAll()) do
		v:ChatPrint("[TTT2][SHOP] " .. ply:Nick() .. " removed '" .. equip .. "' from the shop of the " .. roleData.name)
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
local function TTT2SESaveItem()
	local name, item = ShopEditor.ReadItemData()

	if not item then return end

	ShopEditor.WriteItemData("TTT2SESaveItem", name, item)
	ShopEditor.SaveItem(name, item)
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

	SYNC_EQUIP[subrole] = {}

	-- reset equipment
	for _, v in ipairs(items.GetList()) do
		if v.CanBuy then
			for k, vi in ipairs(v.CanBuy) do
				if vi == subrole then
					table.remove(v.CanBuy, k)

					break
				end
			end
		end
	end

	for _, v in ipairs(weapons.GetList()) do
		if v.CanBuy then
			for k, vi in ipairs(v.CanBuy) do
				if vi == subrole then
					table.remove(v.CanBuy, k)

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
					local eqTbl = not items.IsItem(eq.id) and weapons.GetStored(eq.id) or items.GetStored(eq.id)
					if eqTbl then
						eqTbl.CanBuy = eqTbl.CanBuy or {}

						table.insert(eqTbl.CanBuy, subrole)
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
