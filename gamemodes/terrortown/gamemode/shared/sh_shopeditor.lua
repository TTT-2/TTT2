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

ShopEditor.savingKeys = {
    AutoSpawnable = {
        typ = "bool",
        default = false,
    },
    spawnType = {
        typ = "number",
        bits = 5,
        default = WEAPON_TYPE_SPECIAL,
    },
    notBuyable = {
        typ = "bool",
        default = false,
    },
    NoRandom = {
        typ = "bool",
        default = false,
    },
    globalLimited = {
        typ = "bool",
        default = false,
    },
    teamLimited = {
        typ = "bool",
        default = false,
    },
    limited = {
        typ = "bool",
        default = false,
    },
    minPlayers = {
        typ = "number",
        bits = 6,
        default = 0,
    },
    credits = {
        typ = "number",
        bits = 5,
        default = 1,
    },
    damageScaling = {
        typ = "float",
        bits = 8,
        default = 1,
    },
    ConfigurableClip = {
        typ = "number",
        bits = 8,
        default = 1,
    },
    AllowDrop = {
        typ = "bool",
        default = true,
    },
    overrideDropOnDeath = {
        typ = "number",
        bits = 5,
        default = DROP_ON_DEATH_TYPE_DEFAULT,
    },
    Kind = {
        typ = "number",
        bits = 5,
        default = 3,
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
        b_desc = true,
    },
    ttt2_random_shop_items = {
        order = 2,
        typ = "number",
        bits = 6,
        default = 10,
        min = 1,
        max = 60,
        name = "random_shop_items",
        b_desc = true,
    },
    ttt2_random_team_shops = {
        order = 3,
        typ = "bool",
        default = 1,
        name = "random_team_shops",
        b_desc = false,
    },
    ttt2_random_shop_reroll = {
        order = 4,
        typ = "bool",
        default = 1,
        name = "random_shop_reroll",
        b_desc = false,
    },
    ttt2_random_shop_reroll_cost = {
        order = 5,
        typ = "number",
        bits = 4,
        default = 1,
        min = 0,
        max = 10,
        name = "random_shop_reroll_cost",
        b_desc = false,
    },
    ttt2_random_shop_reroll_per_buy = {
        order = 6,
        typ = "bool",
        default = 0,
        name = "random_shop_reroll_per_buy",
        b_desc = false,
    },
}

-- Table which contains all equipment and is sorted by their translated equipment names
ShopEditor.sortedEquipmentList = {}

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
    if not item then
        return
    end

    item.defaultValues = item.defaultValues or {}

    for key, data in pairs(ShopEditor.savingKeys) do
        if item[key] == nil then
            item[key] = getDefaultValue(item, key, data)
        end

        item.defaultValues[key] = item[key]
    end
end
