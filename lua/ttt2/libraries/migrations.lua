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
		default = ""
	}
}

sql.CreateSqlTable(migrations.databaseName, migrations.savingKeys)
migrations.orm = orm.Make(migrations.databaseName)

---
-- Runs all missing forward gamemode migrations.
-- @realm shared
function migrations.Apply()
	local files = file.Find(migrations.folderPath .. "*.lua", "LUA", "nameasc") or {}

	local fileExecutionCounter = 0

	-- Add Hook to OnLuaError to catch if migrations fail
	local isSuccess = true
	local hookName = "OnLuaError"
	local hookIdentifier = "TTT2MigrationErrorCatcher"
	hook.Add(hookName, hookIdentifier, function(error, realm, stack, name, id)
		isSuccess = false
	end)

	for i = 1, #files do
		local fileName = files[i]
		local fullPath = migrations.folderPath .. files[i]

		local fileInfo = migrations.orm:Find(fileName)

		if fileInfo then continue end

		MsgN("[TTT2] Migrating: ", fileName)

		if SERVER then
			AddCSLuaFile(fullPath)
		end
		include(fullPath)

		if not isSuccess then
			Error("\n[TTT2] Migration failed.\n\n")

			return
		end

		local executedAt = os.date("%Y/%m/%d - %H:%M:%S", os.time())

		migrations.orm:New({
			name = fileName,
			executedAt = executedAt,
		}):Save()

		fileExecutionCounter = fileExecutionCounter + 1
	end

	hook.Remove(hookName, hookIdentifier)

	MsgN("[TTT2] Successfully migrated ", fileExecutionCounter, " Files.")
end
