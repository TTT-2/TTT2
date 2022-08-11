---
-- @author Alf21
-- @module ShopEditor


ShopEditor = ShopEditor or {}

ShopEditor.MODE_DEFAULT = 1
ShopEditor.MODE_ADDED = 2
ShopEditor.MODE_INHERIT_ADDED = 3
ShopEditor.MODE_INHERIT_REMOVED = 4

ShopEditor.sqlItemsName = "ttt2_items"
ShopEditor.accessName = "Items"

ShopEditor.groupTitles = {
	[1] = "header_equipment_weapon_spawn_setup",
	[2] = "header_equipment_setup",
	[3] = "header_equipment_value_setup"
}
ShopEditor.savingKeys = {
	AutoSpawnable = {
		typ = "bool",
		default = false
	},
	spawnType = {
		typ = "number",
		bits = 5,
		default = WEAPON_TYPE_SPECIAL
	},
	notBuyable = {
		typ = "bool",
		default = false
	},
	NoRandom = {
		typ = "bool",
		default = false
	},
	globalLimited = {
		typ = "bool",
		default = false
	},
	teamLimited = {
		typ = "bool",
		default = false
	},
	limited = {
		typ = "bool",
		default = false
	},
	minPlayers = {
		typ = "number",
		bits = 6,
		default = 0
	},
	credits = {
		typ = "number",
		bits = 5,
		default = 1
	}
}

ShopEditor.F1Menu = {
	AutoSpawnable = {
		group = 1,
		order = 10,
		name = "auto_spawnable",
		inverted = false,
		b_desc = true,
		showForItem = false,
		master = nil
	},
	spawnType = {
		group = 1,
		order = 20,
		subtype = "enum",
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
		name = "not_buyable",
		inverted = true,
		b_desc = true,
		showForItem = true,
		master = nil
	},
	NoRandom = {
		group = 2,
		order = 40,
		name = "not_random",
		inverted = false,
		b_desc = true,
		showForItem = true,
		master = "notBuyable"
	},
	globalLimited = {
		group = 2,
		order = 50,
		name = "global_limited",
		inverted = false,
		b_desc = true,
		showForItem = true,
		master = "notBuyable"
	},
	teamLimited = {
		group = 2,
		order = 60,
		name = "team_limited",
		inverted = false,
		b_desc = true,
		showForItem = true,
		master = "notBuyable"
	},
	limited = {
		group = 2,
		order = 70,
		name = "player_limited",
		inverted = false,
		b_desc = true,
		showForItem = true,
		master = "notBuyable"
	},
	minPlayers = {
		group = 3,
		order = 80,
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
		min = 0,
		max = 20,
		name = "credits",
		b_desc = false,
		showForItem = true,
		master = "notBuyable"
	}
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

	if data.typ == "number" then
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
