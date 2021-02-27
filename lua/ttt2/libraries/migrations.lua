---
-- A database schema migrations library
-- @author Histalek
-- @module migrations

if SERVER then
	AddCSLuaFile()
end

migrations = migrations or {}

local sql = sql

if not sql.TableExists("migration_master") then
	sql.Query("CREATE TABLE \"migration_master\" ( \"identifier\" TEXT, \"version\" INTEGER, \"up\" TEXT, \"down\" TEXT, \"created_at\" TEXT, \"executed_at\" TEXT, PRIMARY KEY(\"identifier\",\"version\"));")
end

---
-- Adds a migration to the database and also runs the migration.
-- @param string identifier The unique identifier for a series of migrations. Together with `version` used to control the sequence of migrations.
-- @param number version The unique version in the series of migrations. Together with `identifier` used to control the sequence of migrations.
-- @param string upQuery The sqlQuery to execute.
-- @param string downQuery The sqlQuery used to revert the `upQuery`.
-- @return boolean|nil Returns `true` if the migration succeeded, `nil` if the migration was already executed and `false` in case of an error.
-- @realm shared
function migrations.Add(identifier, version, upQuery, downQuery)

	local checkQuery = "SELECT \"executed_at\" FROM \"migration_master\""
						.. " WHERE \"identifier\"=" .. sql.SQLStr(identifier)
						.. " AND \"version\"=" .. sql.SQLStr(version)
	local checkResult = sql.Query(checkQuery)

	if istable(checkResult) then return end -- migration was already executed

	if checkResult == false then
		return false
	end

	local masterQuery = "INSERT OR IGNORE INTO \"migration_master\" (\"identifier\", \"version\", \"up\", \"down\", \"created_at\") VALUES ("
						.. sql.SQLStr(identifier) .. ", "
						.. sql.SQLStr(version) .. ", "
						.. sql.SQLStr(upQuery) .. ", "
						.. sql.SQLStr(downQuery) .. ", "
						.. sql.SQLStr(os.time()) .. ")"

	if sql.Query(masterQuery) == false then
		return false
	end

	sql.Begin()
	if sql.Query(upQuery) == false then
		sql.Query("Rollback;")
		return false
	end
	sql.Commit()

	local setExecutedQuery = "UPDATE \"migration_master\" SET \"executed_at\"=" .. sql.SQLStr(os.time())
							.. " WHERE \"identifier\"=" .. sql.SQLStr(identifier)
							.. " AND \"version\"=" .. sql.SQLStr(version)

	if sql.Query(setExecutedQuery) == false then
		return false
	end

	return true
end

---
-- Runs all unrun migrations with the given identifier.
-- @param string identifier The identifier for which all migrations should be run.
-- @return boolean|nil Returns `true` if at least one migration was run, `nil` if all migrations were already run and `false` in case of an error.
-- @realm shared
function migrations.MigrateAll(identifier)
end

---
-- Reverts all run migrations with the given identifier.
-- @param string identifier The identifier for which all migrations should be reverted.
-- @return boolean|nil Returns `true` if at least one migration was reverted, `nil` if no migration was reverted and `false` in case of an error.
-- @realm shared
function migrations.RevertAll(identifier)
end

---
-- Runs or reverts migrations with the given identifier to the given version (the state after the upQuery of the specified version).
-- @param string identifier The identifier for the migrations which should be set.
-- @param number version The desired version of the databaseschema.
-- @return boolean|nil Returns `true` if at least one migration was run or reverted, `nil` if no migrations were run or reverted and `false` in case of an error.
-- @realm shared
function migrations.MigrateToVersion(identifier, version)
end
