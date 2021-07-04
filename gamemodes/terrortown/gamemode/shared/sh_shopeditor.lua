---
-- @author Alf21
-- @module ShopEditor


ShopEditor = ShopEditor or {}

ShopEditor.MODE_DEFAULT = 1
ShopEditor.MODE_ADDED = 2
ShopEditor.MODE_INHERIT_ADDED = 3
ShopEditor.MODE_INHERIT_REMOVED = 4

ShopEditor.savingKeys = {
	notBuyable = {
		order = 1,
		typ = "bool",
		default = false,
		name = "not_buyable",
		inverted = true,
		b_desc = true
	},
	NoRandom = {
		order = 2,
		typ = "bool",
		default = false,
		name = "not_random",
		inverted = false,
		b_desc = true
	},
	globalLimited = {
		order = 3,
		typ = "bool",
		default = false,
		name = "global_limited",
		inverted = false,
		b_desc = true
	},
	teamLimited = {
		order = 4,
		typ = "bool",
		default = false,
		name = "team_limited",
		inverted = false,
		b_desc = true
	},
	limited = {
		order = 5,
		typ = "bool",
		default = false,
		name = "player_limited",
		inverted = false,
		b_desc = true
	},
	minPlayers = {
		order = 6,
		typ = "number",
		bits = 6,
		default = 0,
		min = 0,
		max = 63,
		name = "min_players",
		b_desc = false
	},
	credits = {
		order = 7,
		typ = "number",
		bits = 5,
		default = 1,
		min = 1,
		max = 20,
		name = "credits",
		b_desc = false
	}
}

ShopEditor.savingKeysCount = table.Count(ShopEditor.savingKeys)
ShopEditor.savingKeysBitCount = math.ceil(math.log(ShopEditor.savingKeysCount, 2))

ShopEditor.cvars = {
	ttt2_random_shops = {
		order = 1,
		typ = "bool",
		default = 0,
		name = "random_shops",
		b_desc = true
	},
	ttt2_random_shop_items = {
		order = 2,
		typ = "number",
		bits = 6,
		default = 10,
		min = 1,
		max = 60,
		name = "random_shop_items",
		b_desc = true
	},
	ttt2_random_team_shops = {
		order = 3,
		typ = "bool",
		default = 1,
		name = "random_team_shops",
		b_desc = false
	},
	ttt2_random_shop_reroll = {
		order = 4,
		typ = "bool",
		default = 1,
		name = "random_shop_reroll",
		b_desc = false
	},
	ttt2_random_shop_reroll_cost = {
		order = 5,
		typ = "number",
		bits = 4,
		default = 1,
		min = 0,
		max = 10,
		name = "random_shop_reroll_cost",
		b_desc = false
	},
	ttt2_random_shop_reroll_per_buy = {
		order = 6,
		typ = "bool",
		default = 0,
		name = "random_shop_reroll_per_buy",
		b_desc = false
	}
}

-- Table which contains all equipment and is sorted by their translated equipment names
ShopEditor.sortedEquipmentList = {}

local net = net
local pairs = pairs

---
-- Initializes the default data for an @{ITEM} or @{Weapon}
-- @param ITEM|Weapon item
-- @realm shared
function ShopEditor.InitDefaultData(item)
	if not item then return end

	item.defaultValues = item.defaultValues or {}

	for key, data in pairs(ShopEditor.savingKeys) do
		if item[key] == nil then
			if data.typ == "number" then
				item[key] = data.default or 0
			elseif data.typ == "bool" then
				item[key] = data.default or false
			else
				item[key] = data.default or ""
			end
		end

		item.defaultValues[key] = item[key]
	end
end

---
-- Writes the @{ITEM} or @{Weapon} data to the network
-- @param string messageName
-- @param string name
-- @param ITEM|Weapon item
-- @param table|Player plys
-- @realm shared
function ShopEditor.WriteItemData(messageName, name, item, plys)
	name = GetEquipmentFileName(name)

	if not name or not item then return end

	net.Start(messageName)
	net.WriteString(name)
	net.WriteUInt(ShopEditor.savingKeysCount, ShopEditor.savingKeysBitCount or 16)

	for key, data in pairs(ShopEditor.savingKeys) do
		net.WriteString(key)

		if data.typ == "number" then
			net.WriteUInt(item[key], data.bits or 16)
		elseif data.typ == "bool" then
			net.WriteBool(item[key])
		else
			net.WriteString(item[key])
		end
	end

	if SERVER then
		local matched = false

		for k = 1, #CHANGED_EQUIPMENT do
			if CHANGED_EQUIPMENT[k][1] ~= name then continue end

			matched = true
		end

		if not matched then
			CHANGED_EQUIPMENT[#CHANGED_EQUIPMENT + 1] = {name, item}
		end

		if plys then
			net.Send(plys)
		else
			net.Broadcast()
		end
	else
		net.SendToServer()
	end
end

---
-- Reads the @{ITEM} or @{Weapon} data from the network
-- @return string name of the equipment
-- @return ITEM|Weapon equipment table
-- @realm shared
function ShopEditor.ReadItemData()
	local equip, name = GetEquipmentByName(net.ReadString())

	if not equip then
		return name
	end

	local keyCount = net.ReadUInt(ShopEditor.savingKeysBitCount or 16)

	for i = 1, keyCount do
		local key = net.ReadString()
		local data = ShopEditor.savingKeys[key]

		if data.typ == "number" then
			equip[key] = net.ReadUInt(data.bits or 16)
		elseif data.typ == "bool" then
			equip[key] = net.ReadBool()
		else
			equip[key] = net.ReadString()
		end
	end

	return name, equip
end
