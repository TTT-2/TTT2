---
-- @author Alf21
-- @module ShopEditor

ShopEditor = ShopEditor or {}
ShopEditor.savingKeys = {
	credits = {typ = "number", bits = 8, default = 1}, -- from 0 to 255 (2^8 - 1)
	minPlayers = {typ = "number", bits = 6}, -- from 0 to 63 (2^6 - 1)
	globalLimited = {typ = "bool"}, -- 0 and 1
	limited = {typ = "bool"}, -- 0 and 1
	NoRandom = {typ = "bool"}, -- 0 and 1
	notBuyable = {typ = "bool"}, -- 0 and 1
	teamLimited = {typ = "bool"} -- 0 and 1
}

ShopEditor.cvars = {
	ttt2_random_shops = {
		order = 1, typ = "bool", default = 0,
		name = "random_shops", b_desc = true
	},
	ttt2_random_shop_items = {
		order = 2, typ = "number", bits = 6, default = 10, min = 1, max = 60,
		name = "random_shop_items", b_desc = true
	},
	ttt2_random_team_shops = {
		order = 3, typ = "bool", default = 1,
		name = "random_team_shops", b_desc = false
	},
	ttt2_random_shop_reroll = {
		order = 4, typ = "bool", default = 1,
		name = "random_shop_reroll", b_desc = false
	},
	ttt2_random_shop_reroll_cost = {
		order = 5, typ = "number", bits = 4, default = 1, min = 0, max = 10,
		name = "random_shop_reroll_cost", b_desc = false
	},
	ttt2_random_shop_reroll_per_buy = {
		order = 6, typ = "bool", default = 0,
		name = "random_shop_reroll_per_buy", b_desc = false
	}
}

local net = net
local pairs = pairs

---
-- Initializes the default data for an @{ITEM} or @{Weapon}
-- @param ITEM|Weapon item
-- @realm shared
function ShopEditor.InitDefaultData(item)
	if not item then return end

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

	for key, data in pairs(ShopEditor.savingKeys) do
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

	for key, data in pairs(ShopEditor.savingKeys) do
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
