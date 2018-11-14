-- This table is used by the client to show items in the equipment menu, and by
-- the server to check if a certain role is allowed to buy a certain item.


-- If you have custom items you want to add, consider using a separate lua
-- script that uses table.insert to add an entry to this table. This method
-- means you won't have to add your code back in after every TTT update. Just
-- make sure the script is also run on the client.
--
-- For example:
--	table.insert(EquipmentItems[ROLE_DETECTIVE], { id = EQUIP_ARMOR, ... })
--
-- Note that for existing items you can just do:
--	table.insert(EquipmentItems[ROLE_DETECTIVE], GetEquipmentItem(ROLE_TRAITOR, EQUIP_ARMOR))

-- Special equipment bitflags. Every unique piece of equipment needs its own
-- id.
--
-- Use the GenerateNewEquipmentID function (see below) to get a unique ID for
-- your equipment. This is guaranteed not to clash with other addons (as long
-- as they use the same safe method).
--
-- Details you shouldn't need:
-- The number should increase by a factor of two for every item (ie. ids
-- should be powers of two).
EQUIP_NONE = 0
EQUIP_ARMOR = 1
EQUIP_RADAR = 2
EQUIP_DISGUISE = 4

EQUIP_MAX = 4

-- Icon doesn't have to be in this dir, but all default ones are in here
local mat_dir = "vgui/ttt/"

-- Stick to around 35 characters per description line, and add a "\n" where you
-- want a new line to start.

EquipmentItems = {}
SYNC_EQUIP = {}
ALL_ITEMS = {}

function SetupEquipment()
	local armor = {
		id = EQUIP_ARMOR,
		type = "item_passive",
		material = mat_dir .. "icon_armor",
		name = "item_armor",
		desc = "item_armor_desc"
	}

	local radar = {
		id = EQUIP_RADAR,
		type = "item_active",
		material = mat_dir .. "icon_radar",
		name = "item_radar",
		desc = "item_radar_desc"
	}

	local disguiser = {
		id = EQUIP_DISGUISE,
		type = "item_active",
		material = mat_dir .. "icon_disguise",
		name = "item_disg",
		desc = "item_disg_desc"
	}

	for _, v in pairs(GetRoles()) do
		if not EquipmentItems[v.index] then
			local br = GetBaseRole(v.index)
			if br == ROLE_TRAITOR then
				EquipmentItems[v.index] = {armor, radar, disguiser}
			elseif br == ROLE_DETECTIVE then
				EquipmentItems[v.index] = {armor, radar}
			else
				local eqIt = GetRoleByIndex(v.index).EquipmentItems
				if eqIt then
					EquipmentItems[v.index] = eqIt
				else
					EquipmentItems[v.index] = {}
				end
			end
		end
	end
end

SetupEquipment() -- pre init to support normal TTT addons

function CreateEquipmentWeapon(eq)
	if not eq.Doublicated then
		local data = eq.EquipMenuData or {}
		local name = WEPS.GetClass(eq)

		if name then
			local base = {
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
				desc = "No description specified."
			}

			-- Force material to nil so that model key is used when we are
			-- explicitly told to do so (ie. material is false rather than nil).
			if data.modelicon then
				base.material = nil
			end

			table.Merge(base, data)

			return base
		end
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

-- Search if an item is in the equipment table of a given subrole, and return it if
-- it exists, else return nil.
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

function GetEquipmentItemByID(id)
	for _, eq in pairs(ALL_ITEMS) do
		if eq.id == id then
			return eq
		end
	end
end

function GetEquipmentItemByName(name)
	for _, equip in pairs(ALL_ITEMS) do
		if string.lower(equip.name) == name then
			return equip
		end
	end
end

function GetEquipmentFileName(name)
	return string.gsub(string.lower(name), "[%W%s]", "_") -- clean string
end

function GetEquipmentItemByFileName(name)
	for _, equip in pairs(ALL_ITEMS) do
		if GetEquipmentFileName(equip.name) == name then
			return equip
		end
	end
end

-- Utility function to register a new Equipment ID
function GenerateNewEquipmentID()
	EQUIP_MAX = EQUIP_MAX * 2

	return EQUIP_MAX
end

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
	for _, v in pairs({TRAITOR, DETECTIVE}) do
		local fallback = GetShopFallbackTable(v.index)
		if fallback then
			for _, eq in ipairs(fallback) do
				local is_item = tonumber(eq.id)
				local swep_table = not is_item and weapons.GetStored(eq.id)

				if swep_table then
					swep_table.CanBuy = swep_table.CanBuy or {}

					if not table.HasValue(swep_table.CanBuy, v.index) then
						table.insert(swep_table.CanBuy, v.index)
					end
				elseif is_item then
					EquipmentItems[v.index] = EquipmentItems[v.index] or {}

					if not EquipmentTableHasValue(EquipmentItems[v.index], eq) then
						table.insert(EquipmentItems[v.index], eq)
					end
				end
			end
		end
	end
end

function InitFallbackShop(roleData, fallbackTable)
	roleData.fallbackTable = fallbackTable

	for _, eq in ipairs(roleData.fallbackTable) do
		local is_item = tonumber(eq.id)
		local swep_table = not is_item and weapons.GetStored(eq.id)

		if swep_table then
			swep_table.CanBuy = swep_table.CanBuy or {}

			if not table.HasValue(swep_table.CanBuy, roleData.index) then
				table.insert(swep_table.CanBuy, roleData.index)
			end
		elseif is_item then
			EquipmentItems[roleData.index] = EquipmentItems[roleData.index] or {}

			if not EquipmentTableHasValue(EquipmentItems[roleData.index], eq) then
				table.insert(EquipmentItems[roleData.index], eq)
			end
		end
	end
end

function AddToShopFallback(fallback, subrole, eq)
	if not table.HasValue(fallback, eq) then
		table.insert(fallback, eq)
	end

	if GetShopFallbackTable(subrole) then
		local is_item = tonumber(eq.id)
		local swep_table = not is_item and weapons.GetStored(eq.id)

		if swep_table then
			swep_table.CanBuy = swep_table.CanBuy or {}

			if not table.HasValue(swep_table.CanBuy, subrole) then
				table.insert(swep_table.CanBuy, subrole)
			end
		elseif is_item then
			EquipmentItems[subrole] = EquipmentItems[subrole] or {}

			if not EquipmentTableHasValue(EquipmentItems[subrole], eq) then
				table.insert(EquipmentItems[subrole], eq)
			end
		end
	end
end

function InitDefaultEquipment()
	-- set default equipment tables

	-- TRAITOR
	local tbl = table.Copy(EquipmentItems[ROLE_TRAITOR])

	-- find buyable weapons to load info from
	for _, v in ipairs(weapons.GetList()) do
		if v and not v.Doublicated and v.CanBuy and table.HasValue(v.CanBuy, ROLE_TRAITOR) then
			local data = v.EquipMenuData or {}
			local name = WEPS.GetClass(v)

			if name then
				local base = {
					id = name,
					name = name,
					PrintName = data.name or data.PrintName or v.PrintName or name,
					limited = v.LimitedStock,
					kind = v.Kind or WEAPON_NONE,
					slot = (v.Slot or 0) + 1,
					material = v.Icon or "vgui/ttt/icon_id",
					-- the below should be specified in EquipMenuData, in which case
					-- these values are overwritten
					type = "Type not specified",
					model = "models/weapons/w_bugbait.mdl",
					desc = "No description specified."
				}

				-- Force material to nil so that model key is used when we are
				-- explicitly told to do so (ie. material is false rather than nil).
				if data.modelicon then
					base.material = nil
				end

				table.Merge(base, data)
				table.insert(tbl, base)
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
	tbl = table.Copy(EquipmentItems[ROLE_DETECTIVE])

	-- find buyable weapons to load info from
	for _, v in ipairs(weapons.GetList()) do
		if v and not v.Doublicated and v.CanBuy and table.HasValue(v.CanBuy, ROLE_DETECTIVE) then
			local data = v.EquipMenuData or {}
			local name = WEPS.GetClass(v)

			if name then
				local base = {
					id = name,
					name = name,
					PrintName = data.name or data.PrintName or v.PrintName or name,
					limited = v.LimitedStock,
					kind = v.Kind or WEAPON_NONE,
					slot = (v.Slot or 0) + 1,
					material = v.Icon or "vgui/ttt/icon_id",
					-- the below should be specified in EquipMenuData, in which case
					-- these values are overwritten
					type = "Type not specified",
					model = "models/weapons/w_bugbait.mdl",
					desc = "No description specified."
				}

				-- Force material to nil so that model key is used when we are
				-- explicitly told to do so (ie. material is false rather than nil).
				if data.modelicon then
					base.material = nil
				end

				table.Merge(base, data)
				table.insert(tbl, base)
			end
		end
	end

	-- mark custom items
	for _, i in pairs(tbl) do
		if i and i.id then
			i.custom = not table.HasValue(DefaultEquipment[ROLE_DETECTIVE], i.id) -- TODO
		end
	end

	DETECTIVE.fallbackTable = tbl
end

function InitAllItems()
	for _, roleData in pairs(GetRoles()) do
		if EquipmentItems[roleData.index] then
			for _, eq in pairs(EquipmentItems[roleData.index]) do
				if not EquipmentTableHasValue(ALL_ITEMS, eq) then
					table.insert(ALL_ITEMS, eq)
				end
			end

			-- reset normal equipment tables
			EquipmentItems[roleData.index] = {}
		end
	end
end

if SERVER then
	util.AddNetworkString("TTT2SyncEquipment")

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

	function SyncEquipment(ply, add)
		add = add or true

		print("[TTT2][SHOP] Sending new SHOP list to " .. ply:Nick() .. "...")

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
		print("[TTT2][SHOP] Sending updated equipment '" .. equipTbl.equip .. "' to " .. ply:Nick() .. "...")

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

		-- init files
		local roleName = string.lower(roleData.name)
		local files = file.Find("roleweapons/" .. roleName .. "/*.txt", "DATA")

		for _, v in pairs(files) do -- TODO ipairs ?
			local name = string.sub(v, 1, #v - 4) -- cut #".txt"
			local is_item = GetEquipmentItemByFileName(name)
			local wep = not is_item and GetWeaponNameByFileName(name)

			local swep_table = wep and weapons.GetStored(wep)
			if swep_table then
				swep_table.CanBuy = swep_table.CanBuy or {}

				if not table.HasValue(swep_table.CanBuy, roleData.index) then
					table.insert(swep_table.CanBuy, roleData.index)
				end
				--

				SYNC_EQUIP[roleData.index] = SYNC_EQUIP[roleData.index] or {}

				local tbl = {equip = WEPS.GetClass(swep_table), type = 0}

				if not SyncTableHasValue(SYNC_EQUIP[roleData.index], tbl) then
					table.insert(SYNC_EQUIP[roleData.index], tbl)
				end
			elseif is_item then
				EquipmentItems[roleData.index] = EquipmentItems[roleData.index] or {}

				if not EquipmentTableHasValue(EquipmentItems[roleData.index], is_item) then
					table.insert(EquipmentItems[roleData.index], is_item)
				end

				SYNC_EQUIP[roleData.index] = SYNC_EQUIP[roleData.index] or {}

				local tbl = {equip = is_item.id, type = 1, name = is_item.name}

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

		local tbl = {equip = item.id, type = 1, name = item.name}

		if not SyncTableHasValue(SYNC_EQUIP[subrole], tbl) then
			table.insert(SYNC_EQUIP[subrole], tbl)
		end

		for _, v in pairs(player.GetAll()) do
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
			end
		end

		for _, v in ipairs(player.GetAll()) do
			SyncSingleEquipment(v, subrole, tbl, false)
		end
	end
else -- CLIENT
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
				local name = WEPS.GetClass(equip)

				if name then
					local base = {
						id = name,
						name = name,
						PrintName = data.name or data.PrintName or equip.PrintName or name,
						limited = equip.LimitedStock,
						kind = equip.Kind or WEAPON_NONE,
						slot = (equip.Slot or 0) + 1,
						material = equip.Icon or "vgui/ttt/icon_id",
						-- the below should be specified in EquipMenuData, in which case
						-- these values are overwritten
						type = "Type not specified",
						model = "models/weapons/w_bugbait.mdl",
						desc = "No description specified.",
						is_item = false
					}

					-- Force material to nil so that model key is used when we are
					-- explicitly told to do so (ie. material is false rather than nil).
					if data.modelicon then
						base.material = nil
					end

					table.Merge(base, data)

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
		print("[TTT2][SHOP] Received new SHOP list from server! Updating...")

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
