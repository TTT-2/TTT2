---
-- Some database functions of the ttt_bem shop add-on
-- @section BEM

if SERVER then
	AddCSLuaFile()

	return
end

---
-- Creates the fav table if it not already exists
-- @realm client
function CreateFavTable()
	if not sql.TableExists("ttt_bem_fav") then
		query = "CREATE TABLE ttt_bem_fav (guid TEXT, role TEXT, weapon_id TEXT)"
		result = sql.Query(query)
	else
		print("ALREADY EXISTS")
	end
end

---
-- Adds a @{WEAPON} or an @{ITEM} into the fav table
-- @param number steamid steamid of the @{Player}
-- @param number subrole subrole id
-- @param string id the @{WEAPON} or @{ITEM} id
-- @realm client
function AddFavorite(steamid, subrole, id)
	query = ("INSERT INTO ttt_bem_fav VALUES('" .. steamid .. "','" .. subrole .. "','" .. id .. "')")
	result = sql.Query(query)
end

---
-- Removes a @{WEAPON} or an @{ITEM} into the fav table
-- @param number steamid steamid of the @{Player}
-- @param number subrole subrole id
-- @param string id the @{WEAPON} or @{ITEM} id
-- @realm client
function RemoveFavorite(steamid, subrole, id)
	query = ("DELETE FROM ttt_bem_fav WHERE guid = '" .. steamid .. "' AND role = '" .. subrole .. "' AND weapon_id = '" .. id .. "'")
	result = sql.Query(query)
end

---
-- Get all favorites of a @{Player} based on the subrole
-- @param number steamid steamid of the @{Player}
-- @param number subrole subrole id
-- @return table list of all favorites based on the subrole
-- @realm client
function GetFavorites(steamid, subrole)
	query = ("SELECT weapon_id FROM ttt_bem_fav WHERE guid = '" .. steamid .. "' AND role = '" .. subrole .. "'")
	result = sql.Query(query)

	return result
end

---
-- Looks for weapon id in favorites table (result of GetFavorites)
-- @param table favorites favorites table
-- @param number id id of the @{WEAPON} or @{ITEM}
-- @return boolean
-- @realm client
function IsFavorite(favorites, id)
	for _, value in pairs(favorites) do
		local dbid = value["weapon_id"]

		if dbid == tostring(id) then
			return true
		end
	end

	return false
end
