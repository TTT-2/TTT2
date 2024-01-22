---
-- A TTT2 version migrations library
-- @author ZenBre4ker
-- @module migrations

if SERVER then
	AddCSLuaFile()
end

migrations = {}
migrations.orm = nil
migrations.databaseName = "ttt2_migrations"
migrations.savingKeys = {
	date = {
		typ = "string",
		default = ""
	},
	wasSuccess = {
		typ = "bool",
		default = false
	},
	wasUpgrade = {
		typ = "bool",
		default = true
	},
}
migrations.folderPath = "terrortown/migrations/"
migrations.commands = {}
migrations.cachedCommands = {}
migrations.isLoaded = false

function migrations.GetORM()
	if istable(migrations.orm) then
		return migrations.orm
	end

	-- Create Sql and orm table if not already done or savingKeys were changed
	sql.CreateSqlTable(migrations.databaseName, migrations.savingKeys)
	migrations.orm = orm.Make(migrations.databaseName)

	return migrations.orm
end

---
-- Creates a command with state information, an up- and downgrade function
-- @param table states The states that are needed to fulfill the upgrade
-- @param function upgrade The function that is used for forward operations
-- @param function downgrade The function that is used for reverting operations of this command
-- @return @{command} A command containing necessary functionality for forward and backward operations
-- @realm shared
function migrations.CreateCommand(states, upgrade, downgrade)
	if not istable(states) or not isfunction(upgrade) or not isfunction(downgrade) then
		ErrorNoHalt("[TTT2] Couldn't create migrations command. Missing states-table, upgrade- or downgrade-function.\n")
		states = {}
		upgrade = function(cmd) return end
		downgrade = function(cmd) return end
	end

	local command = {Upgrade = upgrade, Downgrade = downgrade, isCommand = true}
	table.Merge(command, states)

	return command
end

---
-- Adds a migration command for every version, that is executed on migration
-- @param string version The version to add the command for
-- @param @{command} The command to execute on migration
-- @return bool True, if adding was successful
-- @realm shared
function migrations.Add(command)
	if not istable(command) or not command.isCommand then
		ErrorNoHalt("[TTT2] Couldn't add migration command. Missing version or command.\n")
		return false
	end

	migrations.cachedCommands[#migrations.cachedCommands + 1] = command

	return true
end

---
-- Runs or reverts gamemode migrations with the given version.
-- @param string|nil newVersion The desired version of the Gamemode to migrate to, uses current one if `nil`.
-- @return boolean `true` if the desired version was successfully migrated and `false` in case of an error.
-- @realm shared
function migrations.Apply()
	if not migrations.isLoaded then
		migrations.Load()
	end

	local migrationSuccess = true
	local errorMessage = ""
	local databaseORM = migrations.GetORM()

	for fileName, commands in SortedPairs(migrations.commands) do
		local fileInfo = databaseORM:Find(fileName)

		if fileInfo and fileInfo.wasSuccess then continue end

		for j = 1, #commands do
			migrationSuccess, errorMessage = pcall(commands[j].Upgrade, commands[j])

			if not migrationSuccess then break end
		end

		local date = os.date("%Y/%m/%d - %H:%M:%S", os.time())

		if fileInfo then
			fileInfo.date = date
			fileInfo.wasSuccess = migrationSuccess
			fileInfo.wasUpgrade = true
			fileInfo:Save()
		else
			databaseORM:New({
				name = fileName,
				date = date,
				wasSuccess = migrationSuccess,
				wasUpgrade = true
			}):Save()
		end

		if not migrationSuccess then break end
	end

	if not migrationSuccess then
		ErrorNoHalt("[TTT2] Migration failed. Error: " .. tostring(errorMessage) .. "\n")
	end

	return migrationSuccess
end

local function fileIncludedCallback(filePath, folderPath)
	fileName = string.Trim(filePath, folderPath)

	migrations.commands[fileName] = migrations.cachedCommands

	-- Empty cache for next file
	migrations.cachedCommands = {}
end

function migrations.Load()
	migrations.cachedCommands = {}

	if CLIENT then
		fileloader.LoadFolder(migrations.folderPath .. "client/", true, CLIENT_FILE, function(filePath, folderPath)
			MsgN("Added TTT2 client migration file: ", filePath)
			fileIncludedCallback(filePath, folderPath)
		end)
	end

	if SERVER then
		fileloader.LoadFolder(migrations.folderPath .. "client/", true, CLIENT_FILE, function(filePath, folderPath)
			MsgN("Marked TTT2 client migration file for distribution: ", filePath)
		end)

		fileloader.LoadFolder(migrations.folderPath .. "server/", true, SERVER_FILE, function(filePath, folderPath)
			MsgN("Added TTT2 server migration file: ", filePath)
			fileIncludedCallback(filePath, folderPath)
		end)
	end

	fileloader.LoadFolder(migrations.folderPath .. "shared/", true, SHARED_FILE, function(filePath, folderPath)
		MsgN("Added TTT2 shared migration file: ", filePath)
		fileIncludedCallback(filePath, folderPath)
	end)

	migrations.isLoaded = true
end
