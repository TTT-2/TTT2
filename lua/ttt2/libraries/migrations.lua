---
-- A TTT2 version migrations library
-- @author ZenBre4ker
-- @module migrations

if SERVER then
	AddCSLuaFile()
end

migrations = {}
migrations.commands = {}

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

function migrations.Add(version, command)
	if not isstring(version) or not (istable(command) and command.isCommand) then
		ErrorNoHalt("[TTT2] Couldn't add migration command. Missing version or command.\n")
		return false
	end

	local commandsList = migrations.commands
	commandsList[version] = commandsList[version] or {}
	commandsList[version][#commandsList[version] + 1] = command

	return true
end

---
-- Runs or reverts gamemode migrations with the given version.
-- @param string|nil newVersion The desired version of the Gamemode to migrate to, uses current one if `nil`.
-- @return boolean `true` if the desired version was successfully migrated and `false` in case of an error.
-- @realm shared
function migrations.MigrateToVersion(newVersion)
	local isUpgrade, changeList = versions.GetLastVersionChanges(newVersion)

	if isUpgrade == nil then
		ErrorNoHalt("[TTT2] Migration failed. This Version " .. tostring(newVersion)
		.. " or the last saved version " .. tostring(versions.GetLastVersion())
		.. " could not be valid.\n")
		return false
	end

	commandsList = {}

	local migrationSuccess = true
	local errorMessage = ""

	for i = 1, #changeList do
		local version = changeList[i]
		local commands = migrations.commands[version]

		if not commands then continue end

		if isUpgrade then
			for j = 1, #commands do
				migrationSuccess, errorMessage = pcall(commands[j].Upgrade, commands[j])

				if not migrationSuccess then break end
			end
		else
			-- In case of a downgrade do it the other way around
			for j = #commands, 1, -1 do
				migrationSuccess, errorMessage = pcall(commands[j].Downgrade, commands[j])

				if not migrationSuccess then break end
			end
		end

		if not migrationSuccess then break end
	end

	if not migrationSuccess then
		ErrorNoHalt("[TTT2] Migration failed. Error: " .. tostring(errorMessage) .. "\n")
	end

	return migrationSuccess
end