---
-- @class MIGRATION
-- @section migration_create_database
local base = "migration_base"

DEFINE_BASECLASS(base)

MIGRATION.base = base

MIGRATION.databaseName = nil
MIGRATION.savingKeys = nil

---
-- Checks if baseclass is valid and a name for the database and necessary savingKeys are given
-- @return boolean
-- @realm shared
function MIGRATION:IsValid()
	return BaseClass.IsValid(self) and isstring(self.databaseName) and istable(self.savingKeys)
end

---
-- Creates an sql table with corresponding databaseName and savingKeys
-- @realm shared
function MIGRATION:Upgrade()
	sql.CreateSqlTable(self.databaseName, self.savingKeys)
end

---
-- Drops an sql table with corresponding databaseName
-- @realm shared
function MIGRATION:Downgrade()
	-- Insert sql.Drop here
end
