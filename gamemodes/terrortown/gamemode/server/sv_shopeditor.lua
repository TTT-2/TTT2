---
-- @module ShopEditor

local net = net
local sql = sql
local util = util
local playerGetAll = player.GetAll

util.AddNetworkString("TTT2UpdateCVar")

net.Receive("TTT2UpdateCVar", function(_, ply)
    if not admin.IsAdmin(ply) then
        return
    end

    local cvar = net.ReadString()

    if not ShopEditor.cvars[cvar] then
        return
    end

    RunConsoleCommand(cvar, net.ReadString())
end)

ShopEditor.ShopTablePre = "ttt2_shop_"

---
-- Initializes the SQL database for the ShopEditor
-- @param string name sql table name, e.g. the name of a certain @{ROLE}
-- @return boolean success?
-- @realm server
-- @internal
function ShopEditor.CreateShopDB(name)
    local result

    if not sql.TableExists(ShopEditor.ShopTablePre .. name) then
        result = sql.Query(
            "CREATE TABLE " .. ShopEditor.ShopTablePre .. name .. " (name TEXT PRIMARY KEY)"
        )
    end

    return result ~= false
end

---
-- Initializes a SQL database table for each @{ROLE}
-- @realm server
-- @internal
function ShopEditor.CreateShopDBs()
    local rlsList = roles.GetList()

    for i = 1, #rlsList do
        local rd = rlsList[i]

        if rd.index == ROLE_NONE then
            continue
        end

        ShopEditor.CreateShopDB(rd.name)
    end
end

---
-- Returns the equipments that are stored in the database for a specific @{ROLE}
-- @param ROLE roleData
-- @return table
-- @realm server
function ShopEditor.GetShopEquipments(roleData)
    if roleData.index == ROLE_NONE then
        return {}
    end

    local result = sql.Query("SELECT * FROM " .. ShopEditor.ShopTablePre .. roleData.name)

    if not result or not istable(result) then
        result = {}
    end

    return result
end

---
-- Adds an @{ITEM} or @{Weapon} into the shop of a given @{ROLE}
-- @param Player ply
-- @param ROLE roleData
-- @param ITEM|Weapon|table equip
-- @realm server
function ShopEditor.AddToShopEditor(ply, roleData, equip)
    sql.Query(
        "INSERT INTO " .. ShopEditor.ShopTablePre .. roleData.name .. " VALUES ('" .. equip .. "')"
    )

    local eq = GetEquipmentByName(equip)

    AddEquipmentToRole(roleData.index, eq)

    -- last but not least, notify each player
    local plys = playerGetAll()
    local nick = ply:Nick()
    local rdName = roleData.name

    for i = 1, #plys do
        plys[i]:ChatPrint(
            "[TTT2][SHOP] " .. nick .. " added '" .. equip .. "' into the shop of the " .. rdName
        )
    end
end

---
-- Removes an @{ITEM} or @{Weapon} from the shop of a given @{ROLE}
-- @param Player ply
-- @param ROLE roleData
-- @param ITEM|Weapon|table equip
-- @realm server
function ShopEditor.RemoveFromShopEditor(ply, roleData, equip)
    sql.Query(
        "DELETE FROM "
            .. ShopEditor.ShopTablePre
            .. roleData.name
            .. " WHERE name='"
            .. equip
            .. "'"
    )

    local eq = GetEquipmentByName(equip)

    RemoveEquipmentFromRole(roleData.index, eq)

    -- last but not least, notify each player
    local plys = playerGetAll()
    local nick = ply:Nick()
    local rdName = roleData.name

    for i = 1, #plys do
        plys[i]:ChatPrint(
            "[TTT2][SHOP] " .. nick .. " removed '" .. equip .. "' from the shop of the " .. rdName
        )
    end
end

util.AddNetworkString("shop")

local function shop(len, ply)
    if not admin.IsAdmin(ply) then
        return
    end

    local add = net.ReadBool()
    local subrole = net.ReadUInt(ROLE_BITS)
    local eq = net.ReadString()

    local equip = GetEquipmentFileName(eq)
    local rd = roles.GetByIndex(subrole)

    if add then
        ShopEditor.AddToShopEditor(ply, rd, equip)
    else
        ShopEditor.RemoveFromShopEditor(ply, rd, equip)
    end
end
net.Receive("shop", shop)

util.AddNetworkString("shopFallback")
util.AddNetworkString("shopFallbackAnsw")
util.AddNetworkString("shopFallbackReset")
util.AddNetworkString("shopFallbackRefresh")

local function shopFallback(len, ply)
    if not admin.IsAdmin(ply) then
        return
    end

    local subrole = net.ReadUInt(ROLE_BITS)
    local fallback = net.ReadString()

    local rd = roles.GetByIndex(subrole)

    RunConsoleCommand("ttt_" .. rd.abbr .. "_shop_fallback", fallback)
end
net.Receive("shopFallback", shopFallback)

---
-- Handles a change of a ConVar that is related to the ShopEditor and reinitializes
-- the shops if needed
-- @param number subrole subrole id of a @{ROLE}
-- @param string fallback the fallback @{ROLE}'s name
-- @param nil|Player|table ply_or_rf if this is nil, it will be broadcasted to every available @{Player}
-- @realm server
-- @internal
function ShopEditor.OnChangeWSCVar(subrole, fallback, ply_or_rf)
    local rd = roles.GetByIndex(subrole)

    SYNC_EQUIP[subrole] = {}

    -- reset equipment
    local itms = items.GetList()

    for i = 1, #itms do
        local v = itms[i]
        local canBuy = v.CanBuy

        if not canBuy then
            continue
        end

        canBuy[subrole] = nil
    end

    local weps = weapons.GetList()

    for i = 1, #weps do
        local v = weps[i]
        local canBuy = v.CanBuy

        if not canBuy then
            continue
        end

        canBuy[subrole] = nil
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

    if fallback == SHOP_DISABLED then
        return
    end

    if fallback ~= SHOP_UNSET and fallback == rd.name then
        LoadSingleShopEquipment(rd)

        ply_or_rf = ply_or_rf or playerGetAll()

        if not istable(ply_or_rf) then
            ply_or_rf = { ply_or_rf }
        end

        for i = 1, #ply_or_rf do
            SyncEquipment(ply_or_rf[i])
        end

        net.Start("shopFallbackRefresh")

        if ply_or_rf then
            net.Send(ply_or_rf)
        else
            net.Broadcast()
        end
    elseif fallback == SHOP_UNSET then
        local flbTbl = rd.fallbackTable
        if not flbTbl then
            return
        end

        -- set everything
        for i = 1, #flbTbl do
            local eq = flbTbl[i]

            local eqTbl = not items.IsItem(eq.id) and weapons.GetStored(eq.id)
                or items.GetStored(eq.id)
            if not eqTbl then
                continue
            end

            eqTbl.CanBuy = eqTbl.CanBuy or {}
            eqTbl.CanBuy[subrole] = subrole
        end
    end
end

---
-- Initializes the ConVars for each @{ROLE}
-- @realm server
-- @internal
function ShopEditor.SetupShopEditorCVars()
    local rlsList = roles.GetList()

    for i = 1, #rlsList do
        local v = rlsList[i]

        local _func = function(convar_name, value_old, value_new)
            if value_old == value_new then
                return
            end

            Dev(1, convar_name .. ": Changing fallback from " .. value_old .. " to " .. value_new)

            SetGlobalString("ttt_" .. v.abbr .. "_shop_fallback", value_new)
            ShopEditor.OnChangeWSCVar(v.index, value_new)
        end

        cvars.AddChangeCallback("ttt_" .. v.abbr .. "_shop_fallback", _func)
    end
end
