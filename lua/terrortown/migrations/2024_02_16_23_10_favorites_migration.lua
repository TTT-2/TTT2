--- @ignore
-- Migration file for shop favorites
if SERVER then
    return function() end
end

local oldDatabaseName = "ttt_bem_fav"
local newDatabaseName = "ttt2_shop_favorites"

---
-- Drops an existing sql table with the same name and creates a new one for shop favorites
-- Then checks out old favorites table and merges them into the new table as good as possible
-- @realm client
return function()
    Dev(1, "Starting to migrate shop favorites.")

    -- Drop existing table
    local result = nil
    if sql.TableExists(newDatabaseName) then
        Dev(1, "SQL table", newDatabaseName, "already exists. It will be dropped!")
        result = sql.Query("DROP TABLE " .. sql.SQLStr(newDatabaseName))
    end

    -- Error migration in case the drop fails in any way
    if result == false or sql.TableExists(newDatabaseName) then
        error(
            "[TTT2] Failed to drop already existing SQL table "
                .. newDatabaseName
                .. ". Error:\n"
                .. sql.LastError()
        )
    end

    -- Create new sql table
    Dev(1, "Creating SQL table", newDatabaseName, ".")
    result = sql.Query("CREATE TABLE " .. sql.SQLStr(newDatabaseName) .. " (name TEXT PRIMARY KEY)")

    if result == false then
        error(
            "[TTT2] Couldn't create sql table "
                .. newDatabaseName
                .. ". Error:\n"
                .. sql.LastError()
        )
    end

    Dev(1, "Succesfully created SQL Table. Checking now for old favorites...")

    -- Try migrate old favorites if they exist
    if not sql.TableExists(oldDatabaseName) then
        Dev(1, "There are no old favorites.", oldDatabaseName, "doesnt exist.")
        return
    end

    Dev(1, "Trying to migrate old favorites from", oldDatabaseName, "to", newDatabaseName, ".")
    result = sql.Query("SELECT * FROM " .. sql.SQLStr(oldDatabaseName))

    if not istable(result) then
        return
    end

    -- Get all old favorites and store them once independent of steamID and subrole
    oldFavoriteEquipments = {}
    for _, row in pairs(result) do
        local equipmentName = row["weapon_id"]

        if not equipmentName then
            continue
        end

        oldFavoriteEquipments[equipmentName] = true
    end

    -- Save all found favorites in the new sql table
    local counter = 0
    for equipmentName in pairs(oldFavoriteEquipments) do
        result = sql.Query(
            "INSERT INTO "
                .. sql.SQLStr(newDatabaseName)
                .. " VALUES("
                .. sql.SQLStr(equipmentName)
                .. ")"
        )

        if result ~= false then
            counter = counter + 1
        else
            Dev(1, "Failed to insert", equipmentName, "to favorites.")
        end
    end

    Dev(
        1,
        "Succesfully migrated",
        counter,
        "shop favorites from",
        oldDatabaseName,
        "to",
        newDatabaseName
    )
end
