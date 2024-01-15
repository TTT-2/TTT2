---
-- A class to handle all shop requirements
-- @author ZenBre4ker
-- @class Shop

shop = shop or {}

shop.favorites = shop.favorites or {}
shop.favorites.databaseName = "ttt2_shop_favorites"
shop.favorites.orm = nil
shop.favorites.savingKeys = {}

local function GetFavoritesORM()
	local favorites = shop.favorites

	if istable(favorites.orm) then
		return favorites.orm
	end

	-- Create Sql and orm table if not already done
	sql.CreateSqlTable(favorites.databaseName, favorites.savingKeys)
	favorites.orm = orm.Make(favorites.databaseName)

	return favorites.orm
end

---
-- Looks for equipment id in favorites table
-- @param number equipmentId id of the @{WEAPON} or @{ITEM}
-- @return boolean
-- @realm client
function shop.IsFavorite(equipmentId)
	return GetFavoritesORM():Find(equipmentId) ~= nil
end

---
-- Get all favorites of the LocalPlayer
-- @return table list of all favorites
-- @realm client
function shop.GetFavorites()
	return GetFavoritesORM():All()
end

---
-- Adds a @{WEAPON} or an @{ITEM} into the fav table
-- @param string equipmentId the @{WEAPON} or @{ITEM} id
-- @param bool isFavorite If the equipmentId is a favorite
-- @realm client
function shop.SetFavoriteState(equipmentId, isFavorite)
	local favOrm = GetFavoritesORM()
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
