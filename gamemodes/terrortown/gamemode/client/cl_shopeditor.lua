---
-- @module ShopEditor

local materialFallback = Material("vgui/ttt/missing_equip_icon")

local equipmentCache

local net = net

ShopEditor = ShopEditor or {}

-- Contains fallback data inbetween rebuilds and if custom shop needs a refresh or data is updated
ShopEditor.fallback = {}
ShopEditor.customShopRefresh = false

---
-- Generates and returns a list of all equipment items and weapons on the server that can be loaded.
-- This means that they have an ID and are not a base for other weapons. This list also contains
-- disabled or ejected equipment.
-- @return table The table with all equipment
-- @realm client
function ShopEditor.GetInstalledEquipment()
    local installedEquipment = {}

    local equipmentItems = items.GetList()

    -- find buyable items to load info from
    for i = 1, #equipmentItems do
        local equipment = equipmentItems[i]
        local name = WEPS.GetClass(equipment)

        if name and not equipment.Duplicated and not string.match(name, "base") then
            if equipment.id then
                installedEquipment[#installedEquipment + 1] = equipment
            else
                ErrorNoHaltWithStack("[TTT2][SHOPEDITOR][ERROR] Item without id:\n")

                PrintTable(equipment)
            end
        end
    end

    -- find buyable weapons to load info from
    local equipmentWeapons = weapons.GetList()

    for i = 1, #equipmentWeapons do
        local equipment = equipmentWeapons[i]
        local name = WEPS.GetClass(equipment)

        if
            name
            and not equipment.Duplicated
            and not string.match(name, "base")
            and not string.match(name, "event")
        then
            -- @realm client
            if hook.Run("TTT2RegisterWeaponID", equipment) then
                installedEquipment[#installedEquipment + 1] = equipment
            else
                ErrorNoHaltWithStack("[TTT2][SHOPEDITOR][ERROR] Weapon without id.\n")
            end
        end
    end

    return installedEquipment
end

---
-- Builts the clientside equipment cache with the cached icons; only caches weapons that are
-- deemed valid and not ejected.
-- @realm client
function ShopEditor.BuildValidEquipmentCache()
    equipmentCache = {}

    local eject = {
        weapon_fists = true,
        weapon_ttt_unarmed = true,
        bobs_blacklisted = true,
    }

    ---
    -- @realm client
    hook.Run("TTT2ModifyShopEditorIgnoreEquip", eject)

    local installedEquipment = ShopEditor.GetInstalledEquipment()

    for i = 1, #installedEquipment do
        local equipment = installedEquipment[i]
        local name = WEPS.GetClass(equipment)

        -- caching should always happen, even if the weapon is not added to the list
        if equipment.material then
            equipment.iconMaterial = Material(equipment.material)

            if equipment.iconMaterial:IsError() then
                -- setting fallback error material
                equipment.iconMaterial = materialFallback
            end
        elseif equipment.model then
            -- do not use fallback mat and use model instead
            equipment.itemModel = equipment.model
        end

        if eject[name] then
            continue
        end

        --if there is no sensible material and model, the equipment should probably not be
        -- editable in the equipment editor or being added to the shop
        if
            equipment.material == "vgui/ttt/icon_id"
            and equipment.model == "models/weapons/w_bugbait.mdl"
        then
            continue
        end

        equipmentCache[#equipmentCache + 1] = equipment
    end
end

---
-- Returns the cached equipment list that is built on every (re-)load of the game.
-- @return table The cached equipment table
-- @realm client
function ShopEditor.GetEquipmentForRoleAll()
    return equipmentCache or {}
end

local function shopFallbackAnsw(len)
    local subrole = net.ReadUInt(ROLE_BITS)
    local fallback = net.ReadString()
    local roleData = roles.GetByIndex(subrole)

    ShopEditor.fallback[roleData.name] = fallback

    -- reset everything
    Equipment[subrole] = {}

    local equipmentItems = items.GetList()

    for i = 1, #equipmentItems do
        local v = equipmentItems[i]
        local canBuy = v.CanBuy

        if not canBuy then
            continue
        end

        canBuy[subrole] = nil
    end

    local equipmentWeapons = weapons.GetList()

    for i = 1, #equipmentWeapons do
        local v = equipmentWeapons[i]
        local canBuy = v.CanBuy

        if not canBuy then
            continue
        end

        canBuy[subrole] = nil
    end

    if fallback == SHOP_UNSET then
        local flbTbl = roleData.fallbackTable

        if not flbTbl then
            return
        end

        -- set everything
        for i = 1, #flbTbl do
            local eq = flbTbl[i]

            local equip = not items.IsItem(eq.id) and weapons.GetStored(eq.id)
                or items.GetStored(eq.id)
            if equip then
                equip.CanBuy = equip.CanBuy or {}
                equip.CanBuy[subrole] = subrole
            end

            Equipment[subrole][#Equipment[subrole] + 1] = eq
        end
    end
end
net.Receive("shopFallbackAnsw", shopFallbackAnsw)

local function shopFallbackReset(len)
    local equipmentItems = items.GetList()

    for i = 1, #equipmentItems do
        equipmentItems[i].CanBuy = {}
    end

    local equipmentWeapons = weapons.GetList()

    for i = 1, #equipmentWeapons do
        equipmentWeapons[i].CanBuy = {}
    end

    local rlsList = roles.GetList()

    for i = 1, #rlsList do
        local rd = rlsList[i]
        local subrole = rd.index
        local fb = GetGlobalString("ttt_" .. rd.abbr .. "_shop_fallback")

        -- reset everything
        Equipment[subrole] = {}

        if fb == SHOP_UNSET then
            local roleData = roles.GetByIndex(subrole)
            local flbTbl = roleData.fallbackTable

            if not flbTbl then
                continue
            end

            -- set everything
            for k = 1, #flbTbl do
                local eq = flbTbl[k]

                local equip = not items.IsItem(eq.id) and weapons.GetStored(eq.id)
                    or items.GetStored(eq.id)
                if equip then
                    equip.CanBuy = equip.CanBuy or {}
                    equip.CanBuy[subrole] = subrole
                end

                Equipment[subrole][#Equipment[subrole] + 1] = eq
            end
        end
    end
end
net.Receive("shopFallbackReset", shopFallbackReset)

local function shopFallbackRefresh()
    -- Refresh F1 menu to show actual custom shop after ShopFallbackRefresh
    if ShopEditor.customShopRefresh then
        ShopEditor.customShopRefresh = false
        vguihandler.Rebuild()
    end
end
net.Receive("shopFallbackRefresh", shopFallbackRefresh)

---
-- This hook can be used to hinder weapons from being rendered in the shopeditor.
-- @param table blockedWeapons A hashtable with the classnames of blocked weapons
-- @hook
-- @realm client
function GM:TTT2ModifyShopEditorIgnoreEquip(blockedWeapons) end
