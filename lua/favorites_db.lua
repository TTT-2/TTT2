---
-- Some database functions of the ttt_bem shop add-on

---
-- Creates the fav table if it not already exists
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
-- @int steamid steamid of the <a href="https://wiki.garrysmod.com/page/Category:Player">Player</a>
-- @int subrole subrole id
-- @str id the @{WEAPON} or @{ITEM} id
function AddFavorite(steamid, subrole, id)
	query = ("INSERT INTO ttt_bem_fav VALUES('" .. steamid .. "','" .. subrole .. "','" .. id .. "')")
	result = sql.Query(query)
end

---
-- Removes a @{WEAPON} or an @{ITEM} into the fav table
-- @int steamid steamid of the <a href="https://wiki.garrysmod.com/page/Category:Player">Player</a>
-- @int subrole subrole id
-- @str id the @{WEAPON} or @{ITEM} id
function RemoveFavorite(steamid, subrole, id)
	query = ("DELETE FROM ttt_bem_fav WHERE guid = '" .. steamid .. "' AND role = '" .. subrole .. "' AND weapon_id = '" .. id .. "'")
	result = sql.Query(query)
end

---
-- Get all favorites of a <a href="https://wiki.garrysmod.com/page/Category:Player">Player</a> based on the subrole
-- @int steamid steamid of the <a href="https://wiki.garrysmod.com/page/Category:Player">Player</a>
-- @int subrole subrole id
-- @treturn table list of all favorites based on the subrole
function GetFavorites(steamid, subrole)
	query = ("SELECT weapon_id FROM ttt_bem_fav WHERE guid = '" .. steamid .. "' AND role = '" .. subrole .. "'")
	result = sql.Query(query)

	return result
end

---
-- Looks for weapon id in favorites table (result of GetFavorites)
-- @tab favorites favorites table
-- @int id id of the @{WEAPON} or @{ITEM}
function IsFavorite(favorites, id)
	for _, value in pairs(favorites) do
		local dbid = value["weapon_id"]

		if dbid == tostring(id) then
			return true
		end
	end

	return false
end
