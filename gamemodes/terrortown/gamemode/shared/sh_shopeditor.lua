---
-- @author Alf21
-- @module ShopEditor


ShopEditor = ShopEditor or {}

ShopEditor.MODE_DEFAULT = 1
ShopEditor.MODE_ADDED = 2
ShopEditor.MODE_INHERIT_ADDED = 3
ShopEditor.MODE_INHERIT_REMOVED = 4

ShopEditor.groupTitles = {
	[1] = "header_equipment_weapon_spawn_setup",
	[2] = "header_equipment_setup",
	[3] = "header_equipment_value_setup"
}

ShopEditor.savingKeys = {
	AutoSpawnable = {
		group = 1,
		order = 10,
		typ = "bool",
		default = false,
		name = "auto_spawnable",
		inverted = false,
		b_desc = true,
		showForItem = false,
		master = nil
	},
	spawnType = {
		group = 1,
		order = 20,
		typ = "number",
		subtype = "enum",
		bits = 5,
		default = WEAPON_TYPE_SPECIAL,
		choices = entspawnscript.GetEntTypeList(SPAWN_TYPE_WEAPON, {[WEAPON_TYPE_RANDOM] = true}),
		lookupNamesFunc = function(entType)
			return entspawnscript.GetLangIdentifierFromSpawnType(SPAWN_TYPE_WEAPON, entType)
		end,
		name = "spawn_type",
		b_desc = false,
		showForItem = false,
		master = "AutoSpawnable"
	},
	notBuyable = {
		group = 2,
		order = 30,
		typ = "bool",
		default = false,
		name = "not_buyable",
		inverted = true,
		b_desc = true,
		showForItem = true,
		master = nil
	},
	NoRandom = {
		group = 2,
		order = 40,
		typ = "bool",
		default = false,
		name = "not_random",
		inverted = false,
		b_desc = true,
		showForItem = true,
		master = "notBuyable"
	},
	globalLimited = {
		group = 2,
		order = 50,
		typ = "bool",
		default = false,
		name = "global_limited",
		inverted = false,
		b_desc = true,
		showForItem = true,
		master = "notBuyable"
	},
	teamLimited = {
		group = 2,
		order = 60,
		typ = "bool",
		default = false,
		name = "team_limited",
		inverted = false,
		b_desc = true,
		showForItem = true,
		master = "notBuyable"
	},
	limited = {
		group = 2,
		order = 70,
		typ = "bool",
		default = false,
		name = "player_limited",
		inverted = false,
		b_desc = true,
		showForItem = true,
		master = "notBuyable"
	},
	minPlayers = {
		group = 3,
		order = 80,
		typ = "number",
		bits = 6,
		default = 0,
		min = 0,
		max = 63,
		name = "min_players",
		b_desc = false,
		showForItem = true,
		master = "notBuyable"
	},
	credits = {
		group = 3,
		order = 90,
		typ = "number",
		bits = 5,
		default = 1,
		min = 0,
		max = 20,
		name = "credits",
		b_desc = false,
		showForItem = true,
		master = "notBuyable"
	},
	damageScaling = {
		group = 3,
		order = 100,
		typ = "float",
		bits = 8,
		default = 1,
		min = 0,
		max = 8,
		decimal = 2,
		name = "damage_scaling",
		b_desc = false,
		showForItem = true,
		master = nil
	},
	AllowDrop = {
		group = 2,
		order = 110,
		typ = "bool",
		default = true,
		name = "allow_drop",
		inverted = false,
		b_desc = true,
		showForItem = true,
		master = nil
	},
	overrideDropOnDeath = {
		group = 2,
		order = 120,
		typ = "number",
		subtype = "enum",
		bits = 5,
		default = DROP_ON_DEATH_TYPE_DEFAULT,
		choices = {
			DROP_ON_DEATH_TYPE_DEFAULT,
			DROP_ON_DEATH_TYPE_FORCE,
			DROP_ON_DEATH_TYPE_DENY,
		},
		lookupNamesFunc = function(dropOnDeathType)
			return ({
				[DROP_ON_DEATH_TYPE_DEFAULT] = "drop_on_death_type_default",
				[DROP_ON_DEATH_TYPE_FORCE] = "drop_on_death_type_force",
				[DROP_ON_DEATH_TYPE_DENY] = "drop_on_death_type_deny",
			})[dropOnDeathType]
		end,
		name = "drop_on_death_type",
		b_desc = true,
		showForItem = true,
		master = nil
	},
	Kind = {
		group = 2,
		order = 130,
		typ = "number",
		subtype = "enum",
		bits = 5,
		default = 3,
		choices = {
			WEAPON_MELEE,
			WEAPON_PISTOL,
			WEAPON_HEAVY,
			WEAPON_NADE,
			WEAPON_CARRY,
			WEAPON_UNARMED,
			WEAPON_SPECIAL,
			WEAPON_EXTRA,
			WEAPON_CLASS,
		},
		lookupNamesFunc = function(slotNum)
			return ({
				[WEAPON_MELEE] = "slot_weapon_melee",
				[WEAPON_PISTOL] = "slot_weapon_pistol",
				[WEAPON_HEAVY] = "slot_weapon_heavy",
				[WEAPON_NADE] = "slot_weapon_nade",
				[WEAPON_CARRY] = "slot_weapon_carry",
				[WEAPON_UNARMED] = "slot_weapon_unarmed",
				[WEAPON_SPECIAL] = "slot_weapon_special",
				[WEAPON_EXTRA] = "slot_weapon_extra",
				[WEAPON_CLASS] = "slot_weapon_class",
			})[slotNum]
		end,
		name = "kind",
		b_desc = true,
		showForItem = false,
		master = nil,
	},
}

ShopEditor.savingKeysCount = table.Count(ShopEditor.savingKeys)
ShopEditor.savingKeysBitCount = math.ceil(math.log(ShopEditor.savingKeysCount + 1, 2))

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

local function getDefaultValue(item, key, data)
	if key == "spawnType" then
		return entspawnscript.GetSpawnTypeFromKind(item.Kind) or data.default or WEAPON_TYPE_SPECIAL
	end

	if data.typ == "number" or data.typ == "float" then
		return data.default or 0
	elseif data.typ == "bool" then
		 return data.default or false
	else
		return data.default or ""
	end
end

---
-- Initializes the default data for an @{ITEM} or @{Weapon}
-- @param ITEM|Weapon item
-- @realm shared
function ShopEditor.InitDefaultData(item)
	if not item then return end

	item.defaultValues = item.defaultValues or {}

	for key, data in pairs(ShopEditor.savingKeys) do
		if item[key] == nil then
			item[key] = getDefaultValue(item, key, data)
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
		elseif data.typ == "float" then
			net.WriteFloat(data.decimal and math.Round(item[key], data.decimal or 0) or item[key])
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
		elseif data.typ == "float" then
			equip[key] = net.ReadFloat()
		elseif data.typ == "bool" then
			equip[key] = net.ReadBool()
		else
			equip[key] = net.ReadString()
		end
	end

	return name, equip
end
