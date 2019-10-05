---
-- @module ShopEditor
-- @author Alf21

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
	[1] = {name = "ttt2_random_shops", typ = "number", bits = 8},
	[2] = {name = "ttt2_random_team_shops",  typ = "bool"},
	[3] = {name = "ttt2_random_shop_reroll", typ = "bool"},
	[4] = {name = "ttt2_random_shop_reroll_cost", typ = "number", bits = 8},
	[5] = {name = "ttt2_random_shop_reroll_per_buy", typ = "bool"}
}

local net = net
local pairs = pairs
local ipairs = ipairs

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

		for k, tbl in ipairs(CHANGED_EQUIPMENT) do
			if tbl[1] == name then
				matched = true
			end
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
