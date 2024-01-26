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
migrations.baseFolderPath = "terrortown/migrations/base/"
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

-- load score menu pages
local function ShouldInherit(t, base)
	return t.base ~= t.type
end

local function OnInitialization(class, path, name)
	class.type = name
	class.base = class.base or "migration_base"

	MsgN("Added TTT2 Migration file: ", path, name)
end

local function PostInherit(class, path, name)
	baseclass.Set(name, class)
end

---
-- Loads migration-files and starts inheriting from base files
-- @realm shared
function migrations.Load()
	MsgN("\n\n[TTT2] Loading Base Migrations ...")

	local baseClasses = classbuilder.BuildFromFolder(migrations.baseFolderPath, SHARED_FILE, "MIGRATION", OnInitialization, true, ShouldInherit, {}, PostInherit)
	PrintTable(baseClasses)
	MsgN("[TTT2] Loading other Migrations ...")
	migrations.migrations = classbuilder.BuildFromFolder(migrations.folderPath, SHARED_FILE, "MIGRATION", OnInitialization, true, ShouldInherit, baseClasses, PostInherit)
	PrintTable(migrations.migrations)
	migrations.isLoaded = true
end
