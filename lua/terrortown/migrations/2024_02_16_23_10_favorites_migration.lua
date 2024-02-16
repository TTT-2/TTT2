--- @ignore
-- Migration file for favorites
if SERVER then
    return function() end
end

local oldDatabaseName = "ttt_bem_fav"
local newDatabaseName = "ttt2_shop_favorites"
local savingKeys = {}

---
-- Checks old favorites table and merges them into the new table
-- @realm client
return function()
    local sqlCommand = "CREATE TABLE " .. newDatabaseName .. " (name TEXT PRIMARY KEY)"

    if not sql.TableExists(newDatabaseName) and sql.Query(sqlCommand) == false then
        error("[TTT2] Couldn't create sql table in migrations. Query failed.")
    end

    if not sql.TableExists(oldDatabaseName) then
        return
    end

    local retrieveOldSqlDataCommand = "SELECT * FROM ttt_bem_fav"
    local oldFavoriteEquipments = sql.Query(retrieveOldSqlDataCommand)

    if oldFavoriteEquipments == false then
        return
    end

    oldFavoriteEquipmentsSorted = {}
    for _, row in pairs(oldFavoriteEquipments) do
        local equipmentName = row["weapon_id"]

        if not equipmentName then
            continue
        end

        oldFavoriteEquipmentsSorted[equipmentName] = true
    end

    local counter = 0
    for equipmentName in pairs(oldFavoriteEquipmentsSorted) do
        counter = counter + 1
        sql.Query("INSERT INTO " .. newDatabaseName .. " VALUES('" .. equipmentName .. "')")
    end

    Dev(1, "Succesfully migrated " .. counter .. " TTT BEM shop favorites.")
end
