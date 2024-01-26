---
-- A TTT2 version migrations library
-- @author ZenBre4ker
-- @module migrations

if SERVER then
	AddCSLuaFile()
end

migrations = {}
migrations.databaseName = "ttt2_migrations"
migrations.savingKeys = {
	executedAt = {
		typ = "string",
		default = ""
	},
	statusMessage = {
		typ = "string",
		default = "Success"
	},
}

sql.CreateSqlTable(migrations.databaseName, migrations.savingKeys)
migrations.orm = orm.Make(migrations.databaseName)

migrations.folderPath = "terrortown/migrations/"
migrations.migrations = {}
migrations.isLoaded = false

---
-- Runs all missing forward gamemode migrations.
-- @return boolean `true` if the desired version was successfully migrated and `false` in case of an error.
-- @realm shared
function migrations.Apply()
	if not migrations.isLoaded then
		migrations.Load()
	end

	local migrationSuccess = true
	local errorMessage = ""

	for fileName, migration in SortedPairs(migrations.migrations) do
		if not IsValid(migration) then continue end

		local fileInfo = migrations.orm:Find(fileName)

		-- As ORM currently gives out strings check it
		if fileInfo and (fileInfo.wasSuccess == true or fileInfo.wasSuccess == "true") then continue end

		MsgN("[TTT2] Migrating: ", fileName)

		migrationSuccess, errorMessage = pcall(migration.Upgrade, migration)

		local executedAt = os.date("%Y/%m/%d - %H:%M:%S", os.time())

		if fileInfo then
			fileInfo.executedAt = executedAt
			fileInfo.statusMessage = migrationSuccess and "Success" or errorMessage
			fileInfo:Save()
		else
			migrations.orm:New({
				name = fileName,
				executedAt = executedAt,
				statusMessage = migrationSuccess and "Success" or errorMessage,
			}):Save()
		end

		if not migrationSuccess then
			ErrorNoHalt("[TTT2] Migration failed. Error:\n" .. tostring(errorMessage) .. "\n")
			break;
		else
			MsgN("[TTT2] Successfully migrated: ", fileName)
		end
	end

	return migrationSuccess
end

---
-- Once all the scripts are loaded we can set up the baseclass
-- we have to wait until they're all setup because load order
-- could cause some entities to load before their bases!
-- @local
-- @realm shared
function migrations.OnLoaded()
	for migrationName in pairs(migrations.migrations) do
		local newTable = migrations.Get(migrationName)
		migrations.migrations[migrationName] = newTable

		baseclass.Set(migrationName, newTable)
	end
end

---
-- Get a migration by name (a copy)
-- @param string name migration name
-- @return table returns the new migration table
-- @realm shared
function migrations.Get(name)
	local stored = migrations.migrations[name]
	if not stored then return end

	local newTable = table.Copy(stored)
	newTable.Base = newTable.Base or "migration_base"

	-- If we're not derived from ourselves (a base migration)
	-- then derive from our 'Base' Migration.
	if newTable.Base ~= name then
		local base = migrations.Get(newTable.Base)

		if not base then
			ErrorNoHalt("ERROR: Trying to derive Migration", tostring(name), " from non existant Migration " .. tostring(newTable.Base) .. "!\n")
		else
			newTable = table.Inherit(newTable, base)
		end
	end

	return newTable
end

---
-- Loads migration-files and starts inheriting from base files
-- @realm shared
function migrations.Load()
	MsgN("[TTT2] Loading Migrations ...")
	MIGRATION = {}

	local function insertMigration(filePath)
		MsgN("Added TTT2 shared migration file: ", filePath)

		local folderTable = string.Split(filePath, '/')
		local fileName = string.TrimRight(folderTable[#folderTable], ".lua")
		migrations.migrations[fileName] = MIGRATION

		-- Empty table for next file
		MIGRATION = {}
	end

	-- @note Until fileloader does not do a real deepsearch we have to use two calls
	-- Load base migrations
	fileloader.LoadFolder(migrations.folderPath, true, SHARED_FILE, function(filePath)
		insertMigration(filePath)
	end)

	-- Load actual migrations
	fileloader.LoadFolder(migrations.folderPath, false, SHARED_FILE, function(filePath)
		insertMigration(filePath)
	end)

	migrations.OnLoaded()

	migrations.isLoaded = true
end
