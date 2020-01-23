---
-- section Equipment
-- @desc This table is used by the client to show items in the equipment menu, and by
-- the server to check if a certain role is allowed to buy a certain item.local math = math

local table = table
local net = net
local player = player
local pairs = pairs
local util = util
local hook = hook

-- Details you shouldn't need:
-- The number should increase by a factor of two for every item (ie. ids
-- should be powers of two).
EQUIP_NONE = 0
EQUIP_ARMOR = 1
EQUIP_RADAR = 2
EQUIP_DISGUISE = 4

EQUIP_MAX = 4

-- Stick to around 35 characters per description line, and add a "\n" where you
-- want a new line to start.

Equipment = CLIENT and (Equipment or {}) or nil
SYNC_EQUIP = SYNC_EQUIP or {}
RANDOMSHOP = RANDOMSHOP or {} -- player equipment
RANDOMTEAMSHOPS = RANDOMTEAMSHOPS or {} -- team equipment
RANDOMSAVEDSHOPS = RANDOMSAVEDSHOPS or {} -- saved random shops

-- JUST used to convert old items to new ones
local itemMt = {
	__newindex = function(tbl, key, val)
		print("[TTT2][INFO] You are using an add-on that is trying to add a new ITEM ('" .. key .. "' = '" .. val .. "') in the wrong way. This will not be available in the shop and lead to errors!")
	end
}

EquipmentItems = EquipmentItems or setmetatable(
	{
		[ROLE_TRAITOR] = setmetatable({}, itemMt),
		[ROLE_DETECTIVE] = setmetatable({}, itemMt)
	},
	{
		__index = function(tbl, key)
			ErrorNoHalt("\n[TTT2][WARNING] You are using an add-on that is trying to access an unsupported var ('" .. key .. "'). This will lead to errors!\n\n")
		end,
		__newindex = function(tbl, key, val)
			ErrorNoHalt("\n[TTT2][WARNING] You are using an add-on that is trying to add a new role ('" .. key .. "' = '" .. val .. "') to an unsupported var. This will lead to errors!\n\n")

			if istable(val) then
				tbl[key] = setmetatable(val, itemMt)
			end
		end
	}
)

---
-- Returns the equipment base table merged with the given data
-- @param table data
-- @param table eq
-- @return table
-- @todo improve description
-- @internal
-- @realm shared
function GetEquipmentBase(data, eq)
	if not eq or eq.inited then
		return eq
	end

	local name = WEPS.GetClass(eq)
	if not name then return end

	local tbl = {
		id = name,
		name = name,
		PrintName = data.name or data.PrintName or eq.PrintName or name,
		limited = eq.limited or eq.LimitedStock,
		kind = eq.Kind or WEAPON_NONE,
		slot = (eq.Slot or 0) + 1,
		material = eq.Icon or eq.material or "vgui/ttt/icon_id",
		-- the below should be specified in EquipMenuData, in which case
		-- these values are overwritten
		type = "Type not specified",
		model = "models/weapons/w_bugbait.mdl",
		desc = "No description specified.",
		inited = true
	}

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

---
-- Creates an equipment
-- @param eq
-- @return table equipment table
-- @internal
-- @realm shared
function CreateEquipment(eq)
	if not eq.Doublicated then
		return GetEquipmentBase(eq.EquipMenuData or {}, eq)
	end
end

---
-- Adds a @{Weapon} into a shop / fallback table
-- @param string wepClass
-- @param ROLE roleData
-- @realm shared
function AddWeaponIntoFallbackTable(wepClass, roleData)
	if not roleData.fallbackTable then return end

	local wep = weapons.GetStored(wepClass)
	if not wep then return end

	wep.CanBuy = wep.CanBuy or {}
	wep.CanBuy[roleData.index] = roleData.index

	local eq = CreateEquipment(wep)
	if not eq then return end

	if not table.HasValue(roleData.fallbackTable, eq) then
		roleData.fallbackTable[#roleData.fallbackTable + 1] = eq
	end
end

---
-- Returns a shop fallback / shop
-- @param number subrole id of @{ROLE}
-- @param[opt] table tbl this table will be modified
-- @return number subrole id of the connected fallback
-- @return number subrole id of role connected with the deepest fallback role (the value returned before)
-- @internal
-- @todo improve description
-- @realm shared
function GetShopFallback(subrole, tbl)
	local rd = roles.GetByIndex(subrole)
	local shopFallback = GetGlobalString("ttt_" .. rd.abbr .. "_shop_fallback")
	local fb = roles.GetStored(shopFallback)

	if fb then
		fb = fb.index
	else
		fb = ROLE_INNOCENT
	end

	if not fb or shopFallback == SHOP_UNSET or shopFallback == SHOP_DISABLED then
		return subrole, fb
	end

	if not tbl then
		tbl = {subrole, fb}

		fb, subrole = GetShopFallback(fb, tbl)
	elseif not table.HasValue(tbl, fb) then
		tbl[#tbl + 1] = fb

		local nfb

		nfb, subrole = GetShopFallback(fb, tbl)

		if nfb ~= fb then
			subrole = fb
			fb = nfb
		end
	end

	return fb, subrole -- return deepest value and the value before the deepest value
end

---
-- Returns a shop fallback / shop table
-- @param number subrole id of @{ROLE}
-- @return table fallback table
-- @internal
-- @todo improve description
-- @realm shared
function GetShopFallbackTable(subrole)
	local rd = roles.GetByIndex(subrole)

	local shopFallback = GetGlobalString("ttt_" .. rd.abbr .. "_shop_fallback")
	if shopFallback == SHOP_DISABLED then return end

	local fallback

	subrole, fallback = GetShopFallback(subrole)

	if fallback == ROLE_INNOCENT then -- fallback is SHOP_UNSET
		rd = roles.GetByIndex(subrole)

		if rd.fallbackTable then
			return rd.fallbackTable
		end
	end
end

if CLIENT then

	---
	-- Returns a list of equipment that is available for a @{ROLE}
	-- param Player ply
	-- @param number subrole id of @{ROLE}
	-- @param[opt] boolean noModification whether the modified equipment (e.g. randomshop) table should be returned or the original one
	-- @internal
	-- @todo improve description
	-- @realm client
	function GetEquipmentForRole(ply, subrole, noModification)
		local fallbackTable = GetShopFallbackTable(subrole)

		if not noModification then
			fallbackTable = GetModifiedEquipment(ply, fallbackTable)
		end

		if fallbackTable then
			return fallbackTable
		end

		local fallback = GetShopFallback(subrole)

		Equipment = Equipment or {}

		-- need to build equipment cache?
		if not Equipment[fallback] then
			local tbl = {}
			local v

			-- find buyable items to load info from
			local itms = items.GetList()

			for i = 1, #itms do
				v = itms[i]

				if v and not v.Doublicated and v.CanBuy and v.CanBuy[fallback] then
					local data = v.EquipMenuData or {}

					local base = GetEquipmentBase(data, v)
					if base then
						tbl[#tbl + 1] = base
					end
				end
			end

			-- find buyable weapons to load info from
			local weps = weapons.GetList()

			for i = 1, #weps do
				v = weps[i]

				if v and not v.Doublicated and v.CanBuy and v.CanBuy[fallback] then
					local data = v.EquipMenuData or {}

					local base = GetEquipmentBase(data, v)
					if base then
						tbl[#tbl + 1] = base
					end
				end
			end

			-- mark custom items
			for k = 1, #tbl do
				v = tbl[k]

				if not v or not v.id then continue end

				v.custom = not table.HasValue(DefaultEquipment[fallback], v.id) -- TODO
			end

			Equipment[fallback] = tbl
		end

		return not noModification and GetModifiedEquipment(ply, Equipment[fallback]) or Equipment[fallback]
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
	local random_team_shops = CreateConVar("ttt2_random_team_shops", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE}, "Set to 0 to disable")
	local random_shop_reroll = CreateConVar("ttt2_random_shop_reroll", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE}, "Set to 0 to disable")
	local random_shop_reroll_cost = CreateConVar("ttt2_random_shop_reroll_cost", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE}, "Credit cost per reroll")
	local random_shop_reroll_per_buy = CreateConVar("ttt2_random_shop_reroll_per_buy", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE}, "Should the random shop reroll after every purchase")

	util.AddNetworkString("TTT2SyncRandomShops")

	local function SyncRandomShops(plys)
		if not RANDOMSHOP then return end

		for ply, tbl in pairs(RANDOMSHOP) do
			if plys and not table.HasValue(plys, ply) then continue end

			local tmp = {}

			for i = 1, #tbl do
				tmp[#tmp + 1] = tbl[i].id
			end

			if #tmp <= 0 then continue end

			local s = EncodeForStream(tmp)
			if not s then continue end

			-- divide into happy lil bits.
			-- this was necessary with user messages, now it's
			-- a just-in-case thing if a round somehow manages to be > 64K
			local cut = {}
			local max = 64000

			while #s ~= 0 do
				local bit = string.sub(s, 1, max - 1)

				cut[#cut + 1] = bit

				s = string.sub(s, max, - 1)
			end

			local parts = #cut

			for k = 1, parts do
				net.Start("TTT2SyncRandomShops")
				net.WriteBit(k ~= parts) -- continuation bit, 1 if there's more coming
				net.WriteString(cut[k])
				net.Send(ply)
			end
		end
	end

	local function GetValidShopFallbackTable(fallback)
		local fallbackTable = GetShopFallbackTable(fallback)
		if not fallbackTable then
			fallbackTable = {}

			local itms = items.GetList()

			for i = 1, #itms do
				local equip = itms[i]

				if not equip.CanBuy or not equip.CanBuy[fallback] then continue end

				fallbackTable[#fallbackTable + 1] = equip
			end

			local weps = weapons.GetList()

			for i = 1, #weps do
				local equip = weps[i]

				if not equip.CanBuy or not equip.CanBuy[fallback] then continue end

				fallbackTable[#fallbackTable + 1] = equip
			end
		end

		return fallbackTable
	end

	local function GetValidTeamShops(fallback, amount, team, fallbackTable)
		local teamShops = RANDOMTEAMSHOPS

		if team and not teamShops[fallback] then
			local fallbackTblCount = #fallbackTable

			if amount < fallbackTblCount then
				teamShops[fallback] = {}

				local tmp2 = {}

				for i = 1, fallbackTblCount do
					local equip = fallbackTable[i]

					if equip.notBuyable then continue end

					if equip.NoRandom then
						amount = amount - 1

						teamShops[fallback][#teamShops[fallback] + 1] = equip
					else
						tmp2[#tmp2 + 1] = equip
					end
				end

				if amount > 0 then
					for i = 1, amount do
						local rndm = math.random(#tmp2)

						teamShops[fallback][#teamShops[fallback] + 1] = tmp2[rndm]

						table.remove(tmp2, rndm)
					end
				end
			else
				teamShops[fallback] = fallbackTable
			end
		end

		return teamShops
	end

	---
	-- Update the random shops
	-- @param table plys list of @{Player}
	-- @param number val
	-- @param string team @{ROLE} team
	-- @internal
	-- @realm server
	function UpdateRandomShops(plys, val, team)
		if plys then
			for i = 1, #plys do
				RANDOMSHOP[plys[i]] = {} -- reset ply
			end
		else
			RANDOMSHOP = {} -- reset everyone
			RANDOMTEAMSHOPS = {} -- reset team equipment
			RANDOMSAVEDSHOPS = {} -- reset saved shops
		end

		local tbl = roles.GetShopRoles()

		-- at first, get all available equipment per team
		for _, rd in pairs(tbl) do
			local fallback = GetShopFallback(rd.index)

			if not RANDOMSAVEDSHOPS[fallback] then
				local fallbackTable = GetValidShopFallbackTable(fallback)

				RANDOMSAVEDSHOPS[fallback] = fallbackTable
				RANDOMTEAMSHOPS = GetValidTeamShops(fallback, val, team, fallbackTable)
			end
		end

		local tmpTbl = plys or player.GetAll()

		local mathrandom = math.random
		local tableremove = table.remove

		-- now set the individual random shop
		if team then -- the shop is synced with the team
			for i = 1, #tmpTbl do
				local ply = tmpTbl[i]
				local srd = ply:GetSubRoleData()

				if not srd:IsShoppingRole() then continue end

				RANDOMSHOP[ply] = RANDOMTEAMSHOPS[GetShopFallback(srd.index)]
			end
		else -- every player has his own shop
			for i = 1, #tmpTbl do
				local ply = tmpTbl[i]
				local srd = ply:GetSubRoleData()

				if not srd:IsShoppingRole() then continue end

				local amount = val
				local tmp2 = {}

				RANDOMSHOP[ply] = {}

				local cachedTbl = RANDOMSAVEDSHOPS[GetShopFallback(srd.index)]

				for k = 1, #cachedTbl do
					local equip = cachedTbl[k]

					if equip.notBuyable then continue end

					if equip.NoRandom then
						amount = amount - 1

						RANDOMSHOP[ply][#RANDOMSHOP[ply] + 1] = equip
					else
						tmp2[#tmp2 + 1] = equip
					end
				end

				if amount > 0 then
					for k = 1, amount do
						local rndm = mathrandom(#tmp2)

						RANDOMSHOP[ply][#RANDOMSHOP[ply] + 1] = tmp2[rndm]

						tableremove(tmp2, rndm)
					end
				end
			end
		end

		SyncRandomShops(plys)
	end

	---
	-- Reset the random shops for a @{ROLE}
	-- @param number role subrole id of a @{ROLE}
	-- @param number amount
	-- @param string team @{ROLE} team
	-- @internal
	-- @realm server
	function ResetRandomShopsForRole(role, amount, team)
		local fallback = GetShopFallback(role)

		RANDOMTEAMSHOPS[fallback] = nil
		RANDOMSAVEDSHOPS[fallback] = nil

		local plys_with_fb = {}
		local plys = player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			if GetShopFallback(ply:GetSubRole()) ~= fallback then continue end

			plys_with_fb[#plys_with_fb + 1] = ply
		end

		UpdateRandomShops(plys_with_fb, amount, team)
	end

	cvars.AddChangeCallback("ttt2_random_shops", function(name, old, new)
		local tmp = tonumber(new)

		SetGlobalInt("ttt2_random_shops", tmp)

		if tmp > 0 then
			UpdateRandomShops(nil, tmp, GetGlobalBool("ttt2_random_team_shops", true))
		end
	end, "ttt2changeshops")

	cvars.AddChangeCallback("ttt2_random_team_shops", function(name, old, new)
		local tmp = tobool(new)
		local amount = GetGlobalInt("ttt2_random_shops")

		SetGlobalBool("ttt2_random_team_shops", tmp)

		if new ~= old and amount > 0 then
			UpdateRandomShops(nil, amount, tmp)
		end
	end, "ttt2changeteamshops")

	cvars.AddChangeCallback("ttt2_random_shop_reroll", function(name, old, new)
		SetGlobalBool("ttt2_random_shop_reroll", tobool(new))
	end, "ttt2updatererollglobal")

	cvars.AddChangeCallback("ttt2_random_shop_reroll_cost", function(name, old, new)
		SetGlobalInt("ttt2_random_shop_reroll_cost", tonumber(new))
	end, "ttt2updatererollcostglobal")

	cvars.AddChangeCallback("ttt2_random_shop_reroll_per_buy", function(name, old, new)
		SetGlobalBool("ttt2_random_shop_reroll_per_buy", tobool(new))
	end, "ttt2updatererollperbuyglobal")

	hook.Add("TTTPrepareRound", "TTT2InitRandomShops", function()
		local amount = GetGlobalInt("ttt2_random_shops")
		if amount <= 0 then return end

		UpdateRandomShops(nil, amount, GetGlobalBool("ttt2_random_team_shops", true))
	end)

	hook.Add("TTT2UpdateSubrole", "TTT2UpdateRandomShop", function(ply)
		local amount = GetGlobalInt("ttt2_random_shops")
		if amount <= 0 then return end

		UpdateRandomShops({ply}, amount, GetGlobalBool("ttt2_random_team_shops", true))
	end)

	hook.Add("PlayerInitialSpawn", "TTT2InitRandomShops", function(ply)
		local amount = random_shops:GetInt()

		SetGlobalInt("ttt2_random_shops", amount)
		SetGlobalBool("ttt2_random_team_shops", random_team_shops:GetBool())
		SetGlobalBool("ttt2_random_shop_reroll", random_shop_reroll:GetBool())
		SetGlobalInt("ttt2_random_shop_reroll_cost", random_shop_reroll_cost:GetInt())
		SetGlobalBool("ttt2_random_shop_reroll_per_buy", random_shop_reroll_per_buy:GetBool())

		if amount <= 0 then return end

		SyncRandomShops({ply})
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

					for i = 1, #tmp do
						local id = tmp[i]
						local equip = not items.IsItem(id) and weapons.GetStored(id) or items.GetStored(id)

						tmp2[#tmp2 + 1] = equip
					end

					RANDOMSHOP[LocalPlayer()] = tmp2
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

---
-- Returns the modified equipment table (e.g. randomshop table)
-- @param Player ply
-- @param table fallback
-- @return table
-- @internal
-- @realm shared
function GetModifiedEquipment(ply, fallback)
	if ply and fallback and RANDOMSHOP[ply] and GetGlobalInt("ttt2_random_shops") > 0 then
		local tmp = {}

		for i = 1, #RANDOMSHOP[ply] do
			local equip = RANDOMSHOP[ply][i]

			for _, eq in pairs(fallback) do
				if eq.id ~= equip.id then continue end

				tmp[#tmp + 1] = eq
			end
		end

		if #tmp > 0 then
			return tmp
		end
	end

	return fallback
end

---
-- Utility function to register a new Equipment ID. The ID is generated exponentially.
-- This functions shouldn't be called more than 13 times.
-- @note You should definitely use the new ITEM System instead!
-- @return number
-- @deprecated
-- @realm shared
function GenerateNewEquipmentID()
	EQUIP_MAX = EQUIP_MAX * 2

	local val = EQUIP_MAX

	timer.Simple(0, function()
		local itms = items.GetList()

		for i = 1, #itms do
			local v = itms[i]

			if v.oldId ~= val or not v.id then continue end

			print("[TTT2][WARNING] TTT2 doesn't support old items completely since they are limited to an amount of 16. If the item '" .. v.id .. "' with id '" .. val .. "' doesn't work as intended, modify the old item and use the new items system instead.")

			break
		end
	end)

	return EQUIP_MAX
end

---
-- Checks whether a equipment table has a specific equipment
-- @param table tbl
-- @param table equip
-- @return[default=false] boolean
-- @realm shared
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

---
-- Initializes the fallback shops
-- @internal
-- @realm shared
function InitFallbackShops()
	local tbl = {TRAITOR, DETECTIVE}

	for i = 1, #tbl do
		local v = tbl[i]

		local fallback = GetShopFallbackTable(v.index)
		if not fallback then continue end

		for k = 1, #fallback do
			local equip = GetEquipmentByName(fallback[k].id)
			if not equip then continue end

			equip.CanBuy = equip.CanBuy or {}
			equip.CanBuy[v.index] = v.index
		end
	end
end

---
-- Initializes the fallback shop for a @{ROLE}
-- @param Role roleData
-- @param table fallbackTable
-- @param[opt] boolean avoidSet
-- @internal
-- @realm shared
function InitFallbackShop(roleData, fallbackTable, avoidSet)
	if not avoidSet then
		roleData.fallbackTable = fallbackTable
	end

	local fallback = GetShopFallbackTable(roleData.index)
	if fallback then
		for i = 1, #fallbackTable do
			local equip = GetEquipmentByName(fallbackTable[i].id)
			if not equip then continue end

			equip.CanBuy = equip.CanBuy or {}
			equip.CanBuy[roleData.index] = roleData.index
		end
	end
end

---
-- Adds an equipment into a shop fallback table of a @{ROLE}
-- @param table fallback
-- @param number subrole subrole id of a @{ROLE}
-- @param table eq equipment
-- @internal
-- @realm shared
function AddToShopFallback(fallback, subrole, eq)
	if not table.HasValue(fallback, eq) then
		fallback[#fallback + 1] = eq
	end

	if GetShopFallbackTable(subrole) then
		local equip = GetEquipmentByName(eq.id)
		if not equip then return end

		equip.CanBuy = equip.CanBuy or {}
		equip.CanBuy[subrole] = subrole
	end
end

local function InitDefaultEquipmentForRole(roleData)
	-- set default equipment tables
	local itms = items.GetList()
	local sweps = weapons.GetList()

	-- TRAITOR
	local tbl = {}

	-- find buyable items to load info from
	for i = 1, #itms do
		local v = itms[i]

		if not v or v.Doublicated or not v.CanBuy or not v.CanBuy[roleData.index] then continue end

		local data = v.EquipMenuData or {}

		local base = GetEquipmentBase(data, v)
		if not base then continue end

		tbl[#tbl + 1] = base
	end

	-- find buyable weapons to load info from
	for i = 1, #sweps do
		local v = sweps[i]

		if not v or v.Doublicated or not v.CanBuy or not v.CanBuy[roleData.index] then continue end

		local data = v.EquipMenuData or {}

		local base = GetEquipmentBase(data, v)
		if not base then continue end

		tbl[#tbl + 1] = base
	end

	-- mark custom items
	for _, i in pairs(tbl) do
		if i and i.id then
			i.custom = not table.HasValue(DefaultEquipment[roleData.index], i.id) -- TODO
		end
	end

	roleData.fallbackTable = tbl
end


---
-- A table with structure tbl[key] = value is turned into tbl[value] = value by this function.
-- This allows you to easily access the table using the value as an index.
-- @warning This function is destructive! If you want to preserve the table, you have to copy it first.
local function ValueToKey(tbl)
	local tmp = tmp or {}

	for key, value in pairs(tbl) do
		tmp[value] = value
		tbl[key] = nil
	end

	for key in pairs(tmp) do
		tbl[key] = tmp[key]
	end
end

---
-- Cleans up the structure of the CanBuy table of all weapons and items.
-- After calling this, all keys will be equal to their value. This allows access in O(1) rather than O(n).
-- table.HasValue is still supported, but please just check if the key is not nil instead.
-- @internal
-- @realm shared
local function CleanUpDefaultCanBuyIndices()
	local itms = items.GetList()

	-- load items
	for i = 1, #itms do
		local itm = itms[i]
		itm.CanBuy = itm.CanBuy or {}
		ValueToKey(itm.CanBuy)
	end

	local sweps = weapons.GetList()

	-- load sweps
	for i = 1, #sweps do
		local wep = sweps[i]
		wep.CanBuy = wep.CanBuy or {}
		ValueToKey(wep.CanBuy)
	end
end

---
-- Initializes the default equipment for traitors and detectives
-- @internal
-- @realm shared
function InitDefaultEquipment()
	CleanUpDefaultCanBuyIndices()
	InitDefaultEquipmentForRole(TRAITOR)
	InitDefaultEquipmentForRole(DETECTIVE)
end

if SERVER then
	util.AddNetworkString("TTT2SyncEquipment")

	---
	-- Synces equipment with a @{Player}
	-- @param Player ply
	-- @param[opt=true] boolean add
	-- @internal
	-- @realm server
	function SyncEquipment(ply, add)
		--print("[TTT2][SHOP] Sending new SHOP list to " .. ply:Nick() .. "...")

		local s = EncodeForStream(SYNC_EQUIP)
		if not s then return end

		add = add == nil and true or add

		-- divide into happy lil bits.
		-- this was necessary with user messages, now it's
		-- a just-in-case thing if a round somehow manages to be > 64K
		local cut = {}
		local max = 65499

		while #s ~= 0 do
			local bit = string.sub(s, 1, max - 1)

			cut[#cut + 1] = bit

			s = string.sub(s, max, - 1)
		end

		local parts = #cut

		for k = 1, parts do
			net.Start("TTT2SyncEquipment")
			net.WriteBool(add)
			net.WriteBit(k ~= parts) -- continuation bit, 1 if there's more coming
			net.WriteString(cut[k])
			net.Send(ply)
		end
	end

	---
	-- Synces single equipment with a @{Player}
	-- @param Player ply
	-- @param number role subrole id of a @{ROLE}
	-- @param number equipId
	-- @param[opt=true] boolean add
	-- @internal
	-- @realm server
	function SyncSingleEquipment(ply, role, equipId, add)
		local s = EncodeForStream({[role] = {equipId}})
		if not s then return end

		add = add == nil and true or add

		-- divide into happy lil bits.
		-- this was necessary with user messages, now it's
		-- a just-in-case thing if a round somehow manages to be > 64K
		local cut = {}
		local max = 65498

		while #s ~= 0 do
			local bit = string.sub(s, 1, max - 1)

			cut[#cut + 1] = bit

			s = string.sub(s, max, - 1)
		end

		local parts = #cut

		for k = 1, parts do
			net.Start("TTT2SyncEquipment")
			net.WriteBool(add)
			net.WriteBit(k ~= parts) -- continuation bit, 1 if there's more coming
			net.WriteString(cut[k])
			net.Send(ply)
		end
	end

	---
	-- Loads a single shop of a @{ROLE}
	-- @param ROLE roleData
	-- @internal
	-- @realm server
	function LoadSingleShopEquipment(roleData)
		local fallback = GetGlobalString("ttt_" .. roleData.abbr .. "_shop_fallback")

		if fallback ~= roleData.name then return end -- TODO why? remove and replace SHOP_UNSET with index of the current role

		hook.Run("TTT2LoadSingleShopEquipment", roleData)

		SYNC_EQUIP = SYNC_EQUIP or {}
		SYNC_EQUIP[roleData.index] = {} -- reset

		-- init equipment
		local result = ShopEditor.GetShopEquipments(roleData)

		for i = 1, #result do
			local equip = GetEquipmentByName(result[i].name)
			if not equip then continue end

			equip.CanBuy = equip.CanBuy or {}
			equip.CanBuy[roleData.index] = roleData.index

			--

			SYNC_EQUIP[roleData.index] = SYNC_EQUIP[roleData.index] or {}

			if not table.HasValue(SYNC_EQUIP[roleData.index], equip.id) then
				SYNC_EQUIP[roleData.index][#SYNC_EQUIP[roleData.index] + 1] = equip.id
			end
		end
	end

	---
	-- Adds an equipment into a @{ROLE}'s equipment table
	-- @param number subrole subrole id
	-- @param table equip_table
	-- @realm server
	function AddEquipmentToRole(subrole, equip_table)
		equip_table.CanBuy = equip_table.CanBuy or {}
		equip_table.CanBuy[subrole] = subrole

		--

		SYNC_EQUIP[subrole] = SYNC_EQUIP[subrole] or {}

		if not table.HasValue(SYNC_EQUIP[subrole], equip_table.id) then
			SYNC_EQUIP[subrole][#SYNC_EQUIP[subrole] + 1] = equip_table.id
		end

		local plys = player.GetAll()

		for i = 1, #plys do
			SyncSingleEquipment(plys[i], subrole, equip_table.id, true)
		end
	end

	---
	-- Removes an equipment from a @{ROLE}'s equipment table
	-- @param number subrole subrole id
	-- @param table equip_table
	-- @realm server
	function RemoveEquipmentFromRole(subrole, equip_table)
		local tableremove = table.remove

		if not equip_table.CanBuy then
			equip_table.CanBuy = {}
		else
			equip_table.CanBuy[subrole] = nil
		end
		--

		SYNC_EQUIP[subrole] = SYNC_EQUIP[subrole] or {}

		for k, v in pairs(SYNC_EQUIP[subrole]) do
			if v ~= equip_table.id then continue end

			tableremove(SYNC_EQUIP[subrole], k)

			break
		end

		local plys = player.GetAll()

		for i = 1, #plys do
			SyncSingleEquipment(plys[i], subrole, equip_table.id, false)
		end
	end

	hook.Add("TTT2UpdateTeam", "TTT2SyncTeambuyEquipment", function(ply, oldTeam, team)
		if not TEAMBUYTABLE then return end

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

	---
	-- Adds an equipment into a @{ROLE}'s equipment table
	-- @param number subrole subrole id
	-- @param table equip
	-- @realm client
	function AddEquipmentToRoleEquipment(subrole, equip)
		-- start with all the non-weapon goodies
		local toadd

		-- find buyable equip to load info from
		equip.CanBuy = equip.CanBuy or {}
		equip.CanBuy[subrole] = subrole

		if equip and not equip.Doublicated then
			local data = equip.EquipMenuData or {}

			local base = GetEquipmentBase(data, equip)
			if base then
				toadd = base
			end
		end

		-- mark custom items
		if toadd and toadd.id then
			toadd.custom = not table.HasValue(DefaultEquipment[subrole], toadd.id) -- TODO
		end

		Equipment[subrole] = Equipment[subrole] or {}

		if toadd and not EquipmentTableHasValue(Equipment[subrole], toadd) then
			Equipment[subrole][#Equipment[subrole] + 1] = toadd
		end
	end

	---
	-- Removes an equipment from a @{ROLE}'s equipment table
	-- @param number subrole subrole id
	-- @param table equip
	-- @realm client
	function RemoveEquipmentFromRoleEquipment(subrole, equip)
		local tableremove = table.remove

		equip.CanBuy[subrole] = nil

		for k, eq in pairs(Equipment[subrole]) do
			if eq.id ~= equip.id then continue end

			tableremove(Equipment[subrole], k)

			break
		end
	end

	-- sync GetRoles()
	local buff = ""

	local function TTT2SyncEquipment(len)
		--print("[TTT2][SHOP] Received new SHOP list from server! Updating...")

		local add = net.ReadBool()
		local cont = net.ReadBit() == 1

		buff = buff .. net.ReadString()

		-- wait for the complete message
		if cont then return end

		-- do stuff with buffer contents
		local json_shop = buff -- util.Decompress(buff)

		-- flush
		buff = ""

		if not json_shop then
			ErrorNoHalt("SHOP decompression failed!\n")

			return
		end

		-- convert the json string back to a table
		local tmp = util.JSONToTable(json_shop)

		if not istable(tmp) then
			ErrorNoHalt("SHOP decoding failed!\n")

			return
		end

		for subrole, tbl in pairs(tmp) do
			-- init
			Equipment = Equipment or {}

			if not Equipment[subrole] then
				GetEquipmentForRole(nil, subrole, true) -- TODO test
			end

			for _, equip in pairs(tbl) do
				local equip_table = not items.IsItem(equip) and weapons.GetStored(equip) or items.GetStored(equip)
				if not equip_table then continue end

				equip_table.CanBuy = equip_table.CanBuy or {}

				if add then
					AddEquipmentToRoleEquipment(subrole, equip_table)
				else
					RemoveEquipmentFromRoleEquipment(subrole, equip_table)
				end
			end
		end
	end
	net.Receive("TTT2SyncEquipment", TTT2SyncEquipment)
end

---
-- Returns an @{ITEM} if it's available for a specific @{ROLE}
-- @param number role subrole id
-- @param string|number id item id / name
-- @see items.GetRoleItem
-- @deprecated
-- @realm shared
function GetEquipmentItem(role, id)
	return items.GetRoleItem(role, id)
end
