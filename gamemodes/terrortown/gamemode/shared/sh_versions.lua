---
-- Shared list of versions
-- @note Used for migrations to get version order
-- @author ZenBre4ker
-- @class versions

versions = {}
versions.databaseName = "ttt2_last_version"
versions.orm = nil
versions.savingKeys = {}

---
-- Gets the orm of versions
-- If the table is not existing, it also creates it
-- @return ORMMODEL Returns the model of the versions database table
-- @realm client
local function GetORM()

	if istable(versions.orm) then
		return versions.orm
	end

	local wasExisting = sql.TableExists(versions.databaseName)

	-- Create Sql and orm table if not already done or savingKeys were changed
	sql.CreateSqlTable(versions.databaseName, versions.savingKeys)
	versions.orm = orm.Make(versions.databaseName)

	if not wasExisting then
		versions.orm:New({
			name = GAMEMODE.Version,
		}):Save()
	end

	return versions.orm
end

function versions.GetLastVersion()
	local firstEntry = GetORM():All()[1]
	return firstEntry and firstEntry.name or GAMEMODE.Version
end

---
-- Gets an ordered list of version changes since the last update
-- This order is reversed in case a downgrade was done
-- @note Returns `nil` and an empty list if version unknown
-- @param string|nil The version name you want to get the change list for, current one if `nil`
-- @return bool|nil True if TTT2 was upgraded aka the current version is newer than the last one, `nil` on error
-- @return table A table containing all last versions, that were not installed
function versions.GetLastVersionChanges(currentVersion)
	local lastVersion = versions.GetLastVersion()
	local lastVersionIndex = versions.names[lastVersion]

	-- In case we have an unknown version number
	-- Return an empty list as there is no order determinable
	if not lastVersionIndex then
		return nil, {}
	end

	local maxIndex
	if not currentVersion or currentVersion == GAMEMODE.Version then
		maxIndex = #versions.names
	else
		for i = 1, #versions.names do
			if currentVersion == versions.names[i] then
				maxIndex = i

				break
			end
		end
	end

	if not maxIndex then
		return nil, {}
	end

	local isUpgrade = maxIndex >= lastVersionIndex

	local changeList = {}
	if isUpgrade then
		for i = lastVersionIndex, maxIndex, 1 do
			changeList[#changeList + 1] = versions.names[i]
		end
	else
		for i = maxIndex, lastVersionIndex, -1 do
			changeList[#changeList + 1] = versions.names[i]
		end
	end

	return isUpgrade, changeList
end

---
-- Updates the saved version in the database to the current one
-- @warning Dont use this manually as this could disable all migrations
-- This should only be used by migrations after all changes were handled
function versions.UpdateDatabase()
	local lastVersion = versions.GetLastVersion()

	if lastVersion == GAMEMODE.Version then return end

	local lastORM = GetORM():Find(lastVersion)

	if lastORM then
		lastORM:Delete()
	end

	GetORM():New({
		name = GAMEMODE.Version,
	}):Save()
end

versions.names = {
	"0.12.3b",
}