-- This table is used by the client to show items in the equipment menu, and by
-- the server to check if a certain role is allowed to buy a certain item.local math = math
local table = table
local net = net
local player = player
local pairs = pairs
local ipairs = ipairs
local util = util
local hook = hook

-- Stick to around 35 characters per description line, and add a "\n" where you
-- want a new line to start.

Equipment = CLIENT and (Equipment or {}) or nil
SYNC_EQUIP = SYNC_EQUIP or {}
RANDOMSHOP = RANDOMSHOP or {}

function GetEquipmentWeaponBase(data, eq)
	if not eq or eq.inited then
		return eq
	end

	local name = WEPS.GetClass(eq)

	if not name then return end

	local tbl = {
		id = name,
		name = name,
		PrintName = data.name or data.PrintName or eq.PrintName or name,
		limited = eq.LimitedStock,
		kind = eq.Kind or WEAPON_NONE,
		slot = (eq.Slot or 0) + 1,
		material = eq.Icon or "vgui/ttt/icon_id",
		-- the below should be specified in EquipMenuData, in which case
		-- these values are overwritten
		type = "Type not specified",
		model = "models/weapons/w_bugbait.mdl",
		desc = "No description specified.",
		is_item = false,
		inited = true
	}

	-- Force material to nil so that model key is used when we are
	-- explicitly told to do so (ie. material is false rather than nil).
	if data.modelicon then
		tbl.material = nil
	end

	table.Merge(tbl, data)

	for key in pairs(ShopEditor.savingKeys) do
		if not tbl[key] then
			tbl[key] = eq[key]
		end
	end

	for k, v in pairs(tbl) do
		eq[k] = v
	end

	return eq
end

function CreateEquipmentWeapon(eq)
	if not eq.Doublicated then
		local data = eq.EquipMenuData or {}

		return GetEquipmentWeaponBase(data, eq)
	end
end

function AddWeaponIntoFallbackTable(wepClass, roleData)
	if not roleData.fallbackTable then return end

	local wep = weapons.GetStored(wepClass)
	if not wep then return end

	wep.CanBuy = wep.CanBuy or {}

	if not table.HasValue(wep.CanBuy, roleData.index) then
		table.insert(wep.CanBuy, roleData.index)
	end

	local eq = CreateEquipmentWeapon(wep)
	if not eq then return end

	if not table.HasValue(roleData.fallbackTable, eq) then
		table.insert(roleData.fallbackTable, eq)
	end
end

function GetShopFallback(subrole, tbl)
	local rd = GetRoleByIndex(subrole)
	local shopFallback = GetGlobalString("ttt_" .. rd.abbr .. "_shop_fallback")
	local fb = GetRoleByName(shopFallback).index

	if shopFallback == SHOP_UNSET or shopFallback == SHOP_DISABLED then
		return subrole, fb
	end

	if not tbl then
		tbl = {subrole, fb}

		fb, subrole = GetShopFallback(fb, tbl)
	elseif not table.HasValue(tbl, fb) then
		table.insert(tbl, fb)

		local nfb

		nfb, subrole = GetShopFallback(fb, tbl)

		if nfb ~= fb then
			subrole = fb
			fb = nfb
		end
	end

	return fb, subrole -- return deepest value and the value before the deepest value
end

function GetShopFallbackTable(subrole)
	local rd = GetRoleByIndex(subrole)

	local shopFallback = GetGlobalString("ttt_" .. rd.abbr .. "_shop_fallback")
	if shopFallback == SHOP_DISABLED then return end

	local fallback

	subrole, fallback = GetShopFallback(subrole)

	if fallback == ROLE_INNOCENT then -- fallback is SHOP_UNSET
		rd = GetRoleByIndex(subrole)

		if rd.fallbackTable then
			return rd.fallbackTable
		end
	end
end

if CLIENT then
	function GetEquipmentForRole(subrole, noModification)
		local fallbackTable = GetShopFallbackTable(subrole)

		if not noModification then
			fallbackTable = GetModifiedEquipment(subrole, fallbackTable)
		end

		if fallbackTable then
			return fallbackTable
		end

		local fallback = GetShopFallback(subrole)

		-- need to build equipment cache?
		if not Equipment[fallback] then
			local tbl = {}

			-- find buyable items to load info from
			for _, v in ipairs(items.GetList()) do
				if v and not v.Doublicated and v.CanBuy and table.HasValue(v.CanBuy, fallback) then
					local data = v.EquipMenuData or {}

					local base = GetEquipmentItemBase(data, v)
					if base then
						table.insert(tbl, base)
					end
				end
			end

			-- find buyable weapons to load info from
			for _, v in ipairs(weapons.GetList()) do
				if v and not v.Doublicated and v.CanBuy and table.HasValue(v.CanBuy, fallback) then
					local data = v.EquipMenuData or {}

					local base = GetEquipmentWeaponBase(data, v)
					if base then
						table.insert(tbl, base)
					end
				end
			end

			-- mark custom items
			for _, i in ipairs(tbl) do
				if i and i.id then
					i.custom = not table.HasValue(DefaultEquipment[fallback], i.id) -- TODO
				end
			end

			Equipment[fallback] = tbl
		end

		return not noModification and GetModifiedEquipment(fallback, Equipment[fallback]) or Equipment[fallback]
	end
end

-- Sync Equipment
local function EncodeForStream(tbl)
	-- may want to filter out data later
	-- just serialize for now

	local result = util.TableToJSON(tbl)
	if not result then
		ErrorNoHalt("Round report event encoding failed!\n")

		return false
	else
		return result
	end
end

-- Search if an item is in the equipment table of a given subrole, and return it if
-- it exists, else return nil.
if SERVER then
	local random_shops = CreateConVar("ttt2_random_shops", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE}, "Set to 0 to disable")

	util.AddNetworkString("TTT2SyncRandomShops")

	local function SyncRandomShops(plys)
		if not RANDOMSHOP then return end

		local tmp = {}

		for k, tbl in pairs(RANDOMSHOP) do
			tmp[k] = {}

			for _, equip in ipairs(tbl) do
				tmp[k][#tmp[k] + 1] = equip.id
			end
		end

		local s = EncodeForStream(tmp)
		if not s then return end

		-- divide into happy lil bits.
		-- this was necessary with user messages, now it's
		-- a just-in-case thing if a round somehow manages to be > 64K
		local cut = {}
		local max = 64000

		while #s ~= 0 do
			local bit = string.sub(s, 1, max - 1)

			table.insert(cut, bit)

			s = string.sub(s, max, - 1)
		end

		local parts = #cut

		for k, bit in ipairs(cut) do
			net.Start("TTT2SyncRandomShops")
			net.WriteBit(k ~= parts) -- continuation bit, 1 if there's more coming
			net.WriteString(bit)

			if plys then
				net.Send(plys)
			else
				net.Broadcast()
			end
		end
	end

	function UpdateRandomShops(plys, val)
		RANDOMSHOP = {} -- reset

		for _, rd in pairs(GetShopRoles()) do
			local amount = val
			local fallback = GetShopFallback(rd.index)

			if not RANDOMSHOP[fallback] then
				RANDOMSHOP[fallback] = {}

				local fallbackTable = GetShopFallbackTable(fallback)

				if not fallbackTable then
					fallbackTable = {}

					for _, equip in ipairs(items.GetList()) do
						if equip.CanBuy and table.HasValue(equip.CanBuy, fallback) then
							fallbackTable[#fallbackTable + 1] = equip
						end
					end

					for _, equip in ipairs(weapons.GetList()) do
						if equip.CanBuy and table.HasValue(equip.CanBuy, fallback) then
							fallbackTable[#fallbackTable + 1] = equip
						end
					end
				end

				local length = #fallbackTable

				if amount >= length then
					RANDOMSHOP[fallback] = fallbackTable
				else
					local tmp2 = {}

					for _, equip in ipairs(fallbackTable) do
						if not equip.notBuyable then
							if equip.NoRandom then
								amount = amount - 1

								RANDOMSHOP[fallback][#RANDOMSHOP[fallback] + 1] = equip
							else
								tmp2[#tmp2 + 1] = equip
							end
						end
					end

					if amount > 0 then
						for i = 1, amount do
							local rndm = math.random(1, #tmp2)

							RANDOMSHOP[fallback][#RANDOMSHOP[fallback] + 1] = tmp2[rndm]

							table.remove(tmp2, rndm)
						end
					end
				end
			end
		end

		SyncRandomShops(plys)
	end

	cvars.AddChangeCallback("ttt2_random_shops", function(name, old, new)
		local tmp = tonumber(new)

		SetGlobalInt("ttt2_random_shops", tmp)

		if tmp > 0 then
			UpdateRandomShops(nil, tmp)
		end
	end, "ttt2changeshops")

	hook.Add("TTTPrepareRound", "TTT2InitRandomShops", function()
		local amount = random_shops:GetInt()

		if amount > 0 then
			UpdateRandomShops(nil, amount)
		end
	end)

	hook.Add("PlayerInitialSpawn", "TTT2InitRandomShops", function(ply)
		local amount = random_shops:GetInt()

		SetGlobalInt("ttt2_random_shops", amount)

		if amount > 0 then
			SyncRandomShops(ply)
		end
	end)
else
	local buff = ""

	local function TTT2SyncRandomShops(len)
		local cont = net.ReadBit() == 1

		buff = buff .. net.ReadString()

		if cont then
			return
		else
			-- do stuff with buffer contents
			local json_shop = buff -- util.Decompress(buff)

			if not json_shop then
				ErrorNoHalt("RANDOMSHOP decompression failed!\n")
			else
				-- convert the json string back to a table
				local tmp = util.JSONToTable(json_shop)

				if istable(tmp) then
					local tmp2 = {}

					for k, tbl in pairs(tmp) do
						tmp2[k] = {}

						for _, id in ipairs(tbl) do
							local equip

							if tonumber(id) then
								equip = GetEquipmentItemByID(id)
							else
								equip = weapons.GetStored(id)
							end

							tmp2[k][#tmp2[k] + 1] = equip
						end
					end

					RANDOMSHOP = tmp2
				else
					ErrorNoHalt("RANDOMSHOP decoding failed!\n")
				end
			end

			-- flush
			buff = ""
		end
	end
	net.Receive("TTT2SyncRandomShops", TTT2SyncRandomShops)
end

function GetModifiedEquipment(subrole, fallback)
	local fb = GetShopFallback(subrole)

	if fallback and GetGlobalInt("ttt2_random_shops") > 0 and RANDOMSHOP[fb] then
		local tmp = {}

		for _, equip in ipairs(RANDOMSHOP[fb]) do
			for _, eq in pairs(fallback) do
				if eq.id == equip.id then
					tmp[#tmp + 1] = eq
				end
			end
		end

		if #tmp > 0 then
			return tmp
		end
	end

	return fallback
end

REM
function GetEquipmentItem(subrole, id)
	local tbl = GetShopFallbackTable(subrole)
	if not tbl then
		local fb = GetShopFallback(subrole)

		tbl = EquipmentItems[fb]

		if not tbl then return end
	end

	for _, v in pairs(tbl) do
		if v and v.id == id then
			return v
		end
	end
end

DAFUQ
function GetEquipmentItemByID(id)
	for _, eq in ipairs(items.GetList()) do
		if eq.id == id then
			return eq
		end
	end
end

function GetEquipmentFileName(name)
	return string.gsub(string.lower(name), "[%W%s]", "_") -- clean string
end

KAk
function GetEquipmentItemByName(name)
	name = GetEquipmentFileName(name)

	for _, equip in ipairs(items.GetList()) do
		if GetEquipmentFileName(equip.name) == name then
			return equip, name
		end
	end

	return nil, name
end

function GetEquipmentByName(name)
	local item, nm = GetEquipmentItemByName(name)
	if item then
		return item, nil, nm
	end

	return nil, GetWeaponByName(name), nm
end

REMREM
-- Utility function to register a new Equipment ID
function GenerateNewEquipmentID()
	EQUIP_MAX = EQUIP_MAX * 2

	return EQUIP_MAX
end

NOW
function EquipmentTableHasValue(tbl, equip)
	if not tbl then
		return false
	end

	for _, eq in pairs(tbl) do
		if eq.id == equip.id or eq.name == equip.name then
			return true
		end
	end

	return false
end

function SyncTableHasValue(tbl, equip)
	for _, v in pairs(tbl) do
		if (v.equip == equip.equip or v.name and equip.name and v.name == equip.name) and v.type == equip.type then
			return true
		end
	end

	return false
end

function InitFallbackShops()
	for _, v in ipairs({TRAITOR, DETECTIVE}) do
		local fallback = GetShopFallbackTable(v.index)
		if fallback then
			for _, eq in ipairs(fallback) do
				local item, wep = GetEquipmentByName(eq.id)

				if wep then
					wep.CanBuy = wep.CanBuy or {}

					if not table.HasValue(wep.CanBuy, v.index) then
						table.insert(wep.CanBuy, v.index)
					end
				elseif item then
					EquipmentItems[v.index] = EquipmentItems[v.index] or {}

					if not EquipmentTableHasValue(EquipmentItems[v.index], eq) then
						table.insert(EquipmentItems[v.index], eq)
					end
				end
			end
		end
	end
end

function InitFallbackShop(roleData, fallbackTable, avoidSet)
	if not avoidSet then
		roleData.fallbackTable = fallbackTable
	end

	local fallback = GetShopFallbackTable(roleData.index)
	if fallback then
		for _, eq in ipairs(fallbackTable) do
			local item, wep = GetEquipmentByName(eq.id)

			if wep then
				wep.CanBuy = wep.CanBuy or {}

				if not table.HasValue(wep.CanBuy, roleData.index) then
					table.insert(wep.CanBuy, roleData.index)
				end
			elseif item then
				EquipmentItems[roleData.index] = EquipmentItems[roleData.index] or {}

				if not EquipmentTableHasValue(EquipmentItems[roleData.index], eq) then
					table.insert(EquipmentItems[roleData.index], eq)
				end
			end
		end
	end
end

function AddToShopFallback(fallback, subrole, eq)
	if not table.HasValue(fallback, eq) then
		table.insert(fallback, eq)
	end

	if GetShopFallbackTable(subrole) then
		local item, wep = GetEquipmentByName(eq.id)

		if wep then
			wep.CanBuy = wep.CanBuy or {}

			if not table.HasValue(wep.CanBuy, subrole) then
				table.insert(wep.CanBuy, subrole)
			end
		elseif item then
			EquipmentItems[subrole] = EquipmentItems[subrole] or {}

			if not EquipmentTableHasValue(EquipmentItems[subrole], eq) then
				table.insert(EquipmentItems[subrole], eq)
			end
		end
	end
end

function InitDefaultEquipment()
	-- set default equipment tables
	local sweps = weapons.GetList()

	-- TRAITOR
	local tbl = {}

	for _, v in pairs(EquipmentItems[ROLE_TRAITOR]) do
		tbl[#tbl + 1] = v
	end

	-- find buyable weapons to load info from
	for _, v in ipairs(sweps) do
		if v and not v.Doublicated and v.CanBuy and table.HasValue(v.CanBuy, ROLE_TRAITOR) then
			local data = v.EquipMenuData or {}

			local base = GetEquipmentWeaponBase(data, v)
			if base then
				tbl[#tbl + 1] = base
			end
		end
	end

	-- mark custom items
	for _, i in pairs(tbl) do
		if i and i.id then
			i.custom = not table.HasValue(DefaultEquipment[ROLE_TRAITOR], i.id) -- TODO
		end
	end

	TRAITOR.fallbackTable = tbl

	-- DETECTIVE
	local tbl2 = {}

	for _, v in pairs(EquipmentItems[ROLE_DETECTIVE]) do
		tbl2[#tbl2 + 1] = v
	end

	-- find buyable weapons to load info from
	for _, v in ipairs(sweps) do
		if v and not v.Doublicated and v.CanBuy and table.HasValue(v.CanBuy, ROLE_DETECTIVE) then
			local data = v.EquipMenuData or {}

			local base = GetEquipmentWeaponBase(data, v)
			if base then
				tbl2[#tbl2 + 1] = base
			end
		end
	end

	-- mark custom items
	for _, i in ipairs(tbl2) do
		if i and i.id then
			i.custom = not table.HasValue(DefaultEquipment[ROLE_DETECTIVE], i.id) -- TODO
		end
	end

	DETECTIVE.fallbackTable = tbl2
end

KIIIIILL
function InitAllItems()
	for _, roleData in pairs(GetRoles()) do
		if EquipmentItems[roleData.index] then
			for _, eq in pairs(EquipmentItems[roleData.index]) do
				if not EquipmentTableHasValue(items.GetList(), eq) then
					ALL_ITEMS[#ALL_ITEMS + 1] = eq
				end
			end

			-- reset normal equipment tables
			EquipmentItems[roleData.index] = {}
		end
	end

	-- init weapons
	for _, wep in ipairs(weapons.GetList()) do
		CreateEquipmentWeapon(wep)
	end
end

if SERVER then
	util.AddNetworkString("TTT2SyncEquipment")

	function SyncEquipment(ply, add)
		add = add or true

		--print("[TTT2][SHOP] Sending new SHOP list to " .. ply:Nick() .. "...")

		local s = EncodeForStream(SYNC_EQUIP)
		if not s then return end

		-- divide into happy lil bits.
		-- this was necessary with user messages, now it's
		-- a just-in-case thing if a round somehow manages to be > 64K
		local cut = {}
		local max = 65499

		while #s ~= 0 do
			local bit = string.sub(s, 1, max - 1)

			table.insert(cut, bit)

			s = string.sub(s, max, - 1)
		end

		local parts = #cut

		for k, bit in ipairs(cut) do
			net.Start("TTT2SyncEquipment")
			net.WriteBool(add)
			net.WriteBit(k ~= parts) -- continuation bit, 1 if there's more coming
			net.WriteString(bit)
			net.Send(ply)
		end
	end

	function SyncSingleEquipment(ply, role, equipTbl, add)
		--print("[TTT2][SHOP] Sending updated equipment '" .. equipTbl.equip .. "' to " .. ply:Nick() .. "...")

		local s = EncodeForStream({[role] = {equipTbl}})
		if not s then return end

		-- divide into happy lil bits.
		-- this was necessary with user messages, now it's
		-- a just-in-case thing if a round somehow manages to be > 64K
		local cut = {}
		local max = 65498

		while #s ~= 0 do
			local bit = string.sub(s, 1, max - 1)

			table.insert(cut, bit)

			s = string.sub(s, max, - 1)
		end

		local parts = #cut

		for k, bit in ipairs(cut) do
			net.Start("TTT2SyncEquipment")
			net.WriteBool(add)
			net.WriteBit(k ~= parts) -- continuation bit, 1 if there's more coming
			net.WriteString(bit)
			net.Send(ply)
		end
	end

	function LoadSingleShopEquipment(roleData)
		local fallback = GetGlobalString("ttt_" .. roleData.abbr .. "_shop_fallback")

		if fallback ~= roleData.name then return end -- TODO why? remove and replace SHOP_UNSET with index of the current role

		hook.Run("TTT2LoadSingleShopEquipment", roleData)

		SYNC_EQUIP = SYNC_EQUIP or {}
		SYNC_EQUIP[roleData.index] = {} -- reset

		-- init equipment
		local result = ShopEditor.GetShopEquipments(roleData)

		for _, v in ipairs(result) do
			local item, wep = GetEquipmentByName(v.name)

			if wep then
				wep.CanBuy = wep.CanBuy or {}

				if not table.HasValue(wep.CanBuy, roleData.index) then
					table.insert(wep.CanBuy, roleData.index)
				end
				--

				SYNC_EQUIP[roleData.index] = SYNC_EQUIP[roleData.index] or {}

				local tbl = {equip = WEPS.GetClass(wep), type = 0}

				if not SyncTableHasValue(SYNC_EQUIP[roleData.index], tbl) then
					table.insert(SYNC_EQUIP[roleData.index], tbl)
				end
			elseif item then
				EquipmentItems[roleData.index] = EquipmentItems[roleData.index] or {}

				if not EquipmentTableHasValue(EquipmentItems[roleData.index], item) then
					table.insert(EquipmentItems[roleData.index], item)
				end

				SYNC_EQUIP[roleData.index] = SYNC_EQUIP[roleData.index] or {}

				local tbl = {equip = item.id, type = 1}

				if not SyncTableHasValue(SYNC_EQUIP[roleData.index], tbl) then
					table.insert(SYNC_EQUIP[roleData.index], tbl)
				end
			end
		end
	end

	function AddEquipmentItemToRole(subrole, item)
		EquipmentItems[subrole] = EquipmentItems[subrole] or {}

		if not EquipmentTableHasValue(EquipmentItems[subrole], item) then
			table.insert(EquipmentItems[subrole], item)
		end

		SYNC_EQUIP[subrole] = SYNC_EQUIP[subrole] or {}

		local tbl = {equip = item.id, type = 1}

		if not SyncTableHasValue(SYNC_EQUIP[subrole], tbl) then
			table.insert(SYNC_EQUIP[subrole], tbl)
		end

		for _, v in ipairs(player.GetAll()) do
			SyncSingleEquipment(v, subrole, tbl, true)
		end
	end

	function RemoveEquipmentItemFromRole(subrole, item)
		EquipmentItems[subrole] = EquipmentItems[subrole] or {}

		for k, eq in pairs(EquipmentItems[subrole]) do
			if eq.id == item.id then
				table.remove(EquipmentItems[subrole], k)

				break
			end
		end

		SYNC_EQUIP[subrole] = SYNC_EQUIP[subrole] or {}

		local tbl = {equip = item.id, type = 1}

		for k, v in pairs(SYNC_EQUIP[subrole]) do
			if v.equip == tbl.equip and v.type == tbl.type then
				table.remove(SYNC_EQUIP[subrole], k)

				break
			end
		end

		for _, v in ipairs(player.GetAll()) do
			SyncSingleEquipment(v, subrole, tbl, false)
		end
	end

	function AddEquipmentWeaponToRole(subrole, swep_table)
		swep_table.CanBuy = swep_table.CanBuy or {}

		if not table.HasValue(swep_table.CanBuy, subrole) then
			table.insert(swep_table.CanBuy, subrole)
		end
		--

		SYNC_EQUIP[subrole] = SYNC_EQUIP[subrole] or {}

		local tbl = {equip = WEPS.GetClass(swep_table), type = 0}

		if not SyncTableHasValue(SYNC_EQUIP[subrole], tbl) then
			table.insert(SYNC_EQUIP[subrole], tbl)
		end

		for _, v in ipairs(player.GetAll()) do
			SyncSingleEquipment(v, subrole, tbl, true)
		end
	end

	function RemoveEquipmentWeaponFromRole(subrole, swep_table)
		if not swep_table.CanBuy then
			swep_table.CanBuy = {}
		else
			for k, v in ipairs(swep_table.CanBuy) do
				if v == subrole then
					table.remove(swep_table.CanBuy, k)

					break
				end
			end
		end
		--

		SYNC_EQUIP[subrole] = SYNC_EQUIP[subrole] or {}

		local tbl = {equip = WEPS.GetClass(swep_table), type = 0}

		for k, v in pairs(SYNC_EQUIP[subrole]) do
			if v.equip == tbl.equip and v.type == tbl.type then
				table.remove(SYNC_EQUIP[subrole], k)

				break
			end
		end

		for _, v in ipairs(player.GetAll()) do
			SyncSingleEquipment(v, subrole, tbl, false)
		end
	end

	hook.Add("TTT2UpdateTeam", "TTT2SyncTeambuyEquipment", function(ply, oldTeam, team)
		if TEAMBUYTABLE then
			if oldTeam and oldTeam ~= TEAM_NONE then
				net.Start("TTT2ResetTBEq")
				net.WriteString(oldTeam)
				net.Send(ply)
			end

			if team and team ~= TEAM_NONE and not TEAMS[team].alone and TEAMBUYTABLE[team] then
				local filter = GetTeamFilter(team)

				for id in pairs(TEAMBUYTABLE[team]) do
					net.Start("TTT2ReceiveTBEq")
					net.WriteString(id)
					net.Send(filter)
				end
			end
		end
	end)
else -- CLIENT
	local function ReceiveTeambuyEquipment()
		local s = net.ReadString()
		local team = LocalPlayer():GetTeam()

		if team and team ~= TEAM_NONE and not TEAMS[team].alone then
			TEAMBUYTABLE[team] = TEAMBUYTABLE[team] or {}
			TEAMBUYTABLE[team][s] = true
		end
	end
	net.Receive("TTT2ReceiveTBEq", ReceiveTeambuyEquipment)

	local function ReceiveGlobalbuyEquipment()
		local s = net.ReadString()

		BUYTABLE[s] = true
	end
	net.Receive("TTT2ReceiveGBEq", ReceiveGlobalbuyEquipment)

	local function ResetTeambuyEquipment()
		local s = net.ReadString()

		if not s or s == TEAM_NONE then return end

		TEAMBUYTABLE[s] = nil
	end
	net.Receive("TTT2ResetTBEq", ResetTeambuyEquipment)

	function AddEquipmentToRoleEquipment(subrole, equip, item)
		-- start with all the non-weapon goodies
		local toadd

		-- find buyable weapons to load info from
		if not item then
			equip.CanBuy = equip.CanBuy or {}

			if not table.HasValue(equip.CanBuy, subrole) then
				table.insert(equip.CanBuy, subrole)
			end

			if equip and not equip.Doublicated then
				local data = equip.EquipMenuData or {}

				local base = GetEquipmentWeaponBase(data, equip)
				if base then
					toadd = base
				end
			end
		else
			toadd = equip

			EquipmentItems[subrole] = EquipmentItems[subrole] or {}

			if not EquipmentTableHasValue(EquipmentItems[subrole], toadd) then
				table.insert(EquipmentItems[subrole], toadd)
			end
		end

		-- mark custom items
		if toadd and toadd.id then
			toadd.custom = not table.HasValue(DefaultEquipment[subrole], toadd.id) -- TODO
		end

		Equipment[subrole] = Equipment[subrole] or {}

		if toadd and not EquipmentTableHasValue(Equipment[subrole], toadd) then
			table.insert(Equipment[subrole], toadd)
		end
	end

	function RemoveEquipmentFromRoleEquipment(subrole, equip, item)
		equip.id = equip.id or WEPS.GetClass(equip)

		if item then
			for k, eq in pairs(EquipmentItems[subrole]) do
				if eq.id == equip.id then
					table.remove(EquipmentItems[subrole], k)

					break
				end
			end
		else
			for k, v in ipairs(equip.CanBuy) do
				if v == subrole then
					table.remove(equip.CanBuy, k)

					break
				end
			end
		end

		for k, eq in pairs(Equipment[subrole]) do
			if eq.id == equip.id then
				table.remove(Equipment[subrole], k)

				break
			end
		end
	end

	-- sync GetRoles()
	local buff = ""

	local function TTT2SyncEquipment(len)
		--print("[TTT2][SHOP] Received new SHOP list from server! Updating...")

		local add = net.ReadBool()
		local cont = net.ReadBit() == 1

		buff = buff .. net.ReadString()

		if cont then
			return
		else
			-- do stuff with buffer contents
			local json_shop = buff -- util.Decompress(buff)

			if not json_shop then
				ErrorNoHalt("SHOP decompression failed!\n")
			else
				-- convert the json string back to a table
				local tmp = util.JSONToTable(json_shop)

				if istable(tmp) then
					for subrole, tbl in pairs(tmp) do
						EquipmentItems[subrole] = EquipmentItems[subrole] or {}

						-- init
						Equipment = Equipment or {}

						if not Equipment[subrole] then
							GetEquipmentForRole(subrole)
						end

						for _, equip in pairs(tbl) do
							if equip.type == 1 then
								local item = GetEquipmentItemByID(equip.equip)
								if item then
									if add then
										AddEquipmentToRoleEquipment(subrole, item, true)
									else
										RemoveEquipmentFromRoleEquipment(subrole, item, true)
									end
								end
							else
								local swep_table = weapons.GetStored(equip.equip)
								if swep_table then
									swep_table.CanBuy = swep_table.CanBuy or {}

									if add then
										AddEquipmentToRoleEquipment(subrole, swep_table, false)
									else
										RemoveEquipmentFromRoleEquipment(subrole, swep_table, false)
									end
								end
							end
						end
					end
				else
					ErrorNoHalt("SHOP decoding failed!\n")
				end
			end

			-- flush
			buff = ""
		end
	end
	net.Receive("TTT2SyncEquipment", TTT2SyncEquipment)
end
