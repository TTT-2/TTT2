---
-- A TTT2 version migrations library
-- @author ZenBre4ker
-- @module migrations

if SERVER then
	AddCSLuaFile()
end

migrations = {}
migrations.folderPath = "terrortown/migrations/"
migrations.baseFolderPath = migrations.folderPath .. "base/"
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
-- Checks if this class should inherit from the baseClass
-- In this case only looks up, if the class is the base
-- @param table class The class that inherits
-- @param table base The class to inherit from
-- @return boolean If the class is the base
local function ShouldInherit(class, baseClass)
	return class.base ~= class.type
end

---
-- Run on Initialization of a class after building it
-- @param table class The Class that got initialized
-- @param string path The path the file was found in
-- @param string name The name of the class
local function OnInitialization(class, path, name)
	class.type = name
	class.base = class.base or "migration_base"

	MsgN("Added TTT2 Migration file: ", path, name)
end

---
-- Run after inheriting to set as final baseclass
-- @param table class The Class that got initialized
-- @param string path The path the file was found in
-- @param string name The name of the class
local function PostInherit(class, path, name)
	baseclass.Set(name, class)
end

---
-- Loads migration-files and starts inheriting from base files
-- @realm shared
function migrations.Load()
	MsgN("[TTT2] Loading base Migrations for inheritance ...")
	local baseClasses = classbuilder.BuildFromFolder(migrations.baseFolderPath, SHARED_FILE, "MIGRATION", OnInitialization, true, ShouldInherit, {}, PostInherit)

	MsgN("[TTT2] Loading Migrations ...")
	migrations.migrations = classbuilder.BuildFromFolder(migrations.folderPath, SHARED_FILE, "MIGRATION", OnInitialization, true, ShouldInherit, baseClasses, PostInherit)

	migrations.isLoaded = true
end
