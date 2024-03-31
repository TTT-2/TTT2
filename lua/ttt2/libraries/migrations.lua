---
-- A TTT2 version migrations library
-- @author ZenBre4ker
-- @module migrations

if SERVER then
    AddCSLuaFile()
end

migrations = {}
migrations.folderPath = "terrortown/migrations/"
migrations.databaseName = "ttt2_migrations"
migrations.savingKeys = {
    executedAt = {
        typ = "string",
        default = "",
    },
}

sql.CreateSqlTable(migrations.databaseName, migrations.savingKeys)
migrations.orm = orm.Make(migrations.databaseName)

---
-- Runs all missing forward gamemode migrations.
-- @note Folderpath is lua/terrortown/migrations/*.lua
-- @note Migrations shall be returned as anonymous functions inside those files
-- @note Migrations are shared, so use if CLIENT|SERVER for separation
-- @realm shared
function migrations.Apply()
    local files = file.Find(migrations.folderPath .. "*.lua", "LUA", "nameasc") or {}

    local fileExecutionCounter = 0
    for i = 1, #files do
        local fileName = files[i]
        local fullPath = migrations.folderPath .. files[i]

        if SERVER then
            AddCSLuaFile(fullPath)
        end

        local fileInfo = migrations.orm:Find(fileName)

        if fileInfo then
            continue
        end

        Dev(1, "Migrating: ", fileName)

        local isSuccess, errorMessage = pcall(include(fullPath))

        if not isSuccess then
            error("[TTT2] Migration failed.\n" .. errorMessage, 1)

            return
        end

        local executedAt = os.date("%Y/%m/%d - %H:%M:%S", os.time())

        migrations.orm
            :New({
                name = fileName,
                executedAt = executedAt,
            })
            :Save()

        fileExecutionCounter = fileExecutionCounter + 1
    end

    Dev(1, "[TTT2] Successfully migrated ", fileExecutionCounter, " Files.")
end
