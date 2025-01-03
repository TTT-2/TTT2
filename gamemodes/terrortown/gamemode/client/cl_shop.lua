---
-- A class to handle all shop requirements
-- @author ZenBre4ker
-- @class Shop

shop = shop or {}

shop.favorites = shop.favorites or {}
shop.favorites.databaseName = "ttt2_shop_favorites"

---
-- Looks for equipment id in favorites table
-- @param number equipmentId id of the @{WEAPON} or @{ITEM}
-- @return boolean
-- @realm client
function shop.IsFavorite(equipmentId)
    return shop.favorites.orm:Find(equipmentId) ~= nil
end

---
-- Get all favorites of the LocalPlayer
-- @return table list of all favorites
-- @realm client
function shop.GetFavorites()
    return shop.favorites.orm:All()
end

---
-- Adds a @{WEAPON} or an @{ITEM} into the fav table
-- @param string equipmentId the @{WEAPON} or @{ITEM} id
-- @param boolean isFavorite If the equipmentId is a favorite
-- @realm client
function shop.SetFavoriteState(equipmentId, isFavorite)
    local favOrm = shop.favorites.orm
    local favoriteItem = favOrm:Find(equipmentId)

    if isFavorite and not favoriteItem then
        favoriteItem = favOrm:New({
            name = equipmentId,
        })
        favoriteItem:Save()
    elseif favoriteItem then
        favoriteItem:Delete()
    end
end

local function ResetTeambuyEquipment()
    local team = net.ReadString()

    shop.ResetTeamBuy(LocalPlayer(), team)
end
net.Receive("TTT2ResetTBEq", ResetTeambuyEquipment)

local function ReceiveTeambuyEquipment()
    local equipmentName = net.ReadString()

    shop.SetEquipmentTeamBought(LocalPlayer(), equipmentName)
end
net.Receive("TTT2ReceiveTBEq", ReceiveTeambuyEquipment)

local function ReceiveGlobalbuyEquipment()
    local equipmentName = net.ReadString()

    shop.SetEquipmentGlobalBought(equipmentName)
end
net.Receive("TTT2ReceiveGBEq", ReceiveGlobalbuyEquipment)
