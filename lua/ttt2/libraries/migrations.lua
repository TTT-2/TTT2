---
-- A database schema migrations library
-- @author Histalek
-- @module migrations

if SERVER then
	AddCSLuaFile()
end

migrations = migrations or {}

local sql = sql
local tonumber = tonumber
local isnumber = isnumber

if not sql.TableExists("migration_master") then
	sql.Query("CREATE TABLE \"migration_master\" ( \"identifier\" TEXT, \"version\" INTEGER, \"up\" TEXT, \"down\" TEXT, \"created_at\" INTEGER, \"executed_at\" INTEGER, PRIMARY KEY(\"identifier\",\"version\"));")
end

---
-- Adds a migration to the database. Use @{migrations.MigrateToVersion()} once after all migrations are added.
-- @note This should be used in an extra file at `terrortown/migrations/<realm>/<identifier>.lua`.
-- @param string identifier The unique identifier for a series of migrations.
-- @param number version The unique version in the series of migrations. Should incremented by 1 for each new version.
-- @param string upQuery The sqlQuery to execute.
-- @param [opt]string downQuery The sqlQuery used to revert the `upQuery`.
-- @param [opt]string existingTable The name of the database table to port to the 'migrations' library.
-- @return boolean|nil Returns `false` in case of an error and `nil` otherwise.
-- @realm shared
function migrations.Add(identifier, version, upQuery, downQuery, existingTable)

	local checkQuery = "SELECT \"executed_at\" FROM \"migration_master\""
						.. " WHERE \"identifier\"=" .. sql.SQLStr(identifier)
						.. " AND \"version\"=" .. sql.SQLStr(version)

	local checkResult = sql.Query(checkQuery)

	if istable(checkResult) then return end -- migration was already executed

	if checkResult == false then
		return false
	end

	local masterQuery = "INSERT OR IGNORE INTO \"migration_master\" (\"identifier\", \"version\", \"up\", \"down\", \"created_at\", \"executed_at\") VALUES ("
						.. sql.SQLStr(identifier) .. ", "
						.. sql.SQLStr(version) .. ", "
						.. sql.SQLStr(upQuery) .. ", "
						.. sql.SQLStr(downQuery) .. ", "
						.. sql.SQLStr(os.time()) .. ", "
						.. sql.SQLStr(0) .. ")"

	if sql.Query(masterQuery) == false then
		return false
	end

	if not existingTable then return end

	local setExecutedQuery = "UPDATE \"migration_master\" SET \"executed_at\"=" .. sql.SQLStr(os.time())
						.. " WHERE \"identifier\"=" .. sql.SQLStr(identifier)
						.. " AND \"version\"=" .. sql.SQLStr(version)

	if sql.Query(setExecutedQuery) == false then
		return false
	end
end

---
-- Runs or reverts migrations with the given identifier to the given version (the state after the upQuery of the specified version).
-- @param string identifier The identifier for the migrations which should be run.
-- @param number version The desired version of the databaseschema.
-- @return boolean Returns `true` if the desired version was successfully migrated and `false` in case of an error.
-- @realm shared
function migrations.MigrateToVersion(identifier, version)

	local currentVersion = tonumber(sql.QueryValue("SELECT max(\"version\") FROM \"migration_master\" WHERE \"executed_at\">0"))

	if isnumber(currentVersion) and currentVersion == version then
		return true
	end

	local migrationTable

	if isnumber(currentVersion) and currentVersion > version then -- higher versin than desired -> execute down queries
		local getMigrationQuery = "SELECT \"version\", \"down\" as query FROM \"migration_master\""
						.. " WHERE \"identifier\"=" .. sql.SQLStr(identifier)
						.. " AND \"version\"<" .. sql.SQLStr(currentVersion)
						.. " ORDER BY \"version\" DESC"

		migrationTable = sql.Query(getMigrationQuery)
	else -- lower version or no version -> execute up queries
		local getMigrationQuery = "SELECT \"version\", \"up\" as query FROM \"migration_master\""
						.. " WHERE \"identifier\"=" .. sql.SQLStr(identifier)
						.. " AND \"version\">" .. sql.SQLStr(currentVersion)
						.. " ORDER BY \"version\" ASC"

		migrationTable = sql.Query(getMigrationQuery)
	end

	-- loop through migrationTable and execute queries
	for _, value in ipairs(migrationTable) do

		sql.Begin()
		if sql.Query(value.query) == false then
			sql.Query("Rollback;")
			return false
		end

		local setExecutedQuery = "UPDATE \"migration_master\" SET \"executed_at\"=" .. sql.SQLStr(os.time())
								.. " WHERE \"identifier\"=" .. sql.SQLStr(identifier)
								.. " AND \"version\"=" .. sql.SQLStr(version)

		if sql.Query(setExecutedQuery) == false then
			sql.Query("Rollback;")
			return false
		end
		sql.Commit()
	end

	return true
end
