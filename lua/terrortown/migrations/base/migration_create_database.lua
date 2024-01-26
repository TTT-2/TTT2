---
-- @class MIGRATION
-- @section migration_create_database

local base = "migration_base"

DEFINE_BASECLASS(base)

MIGRATION.Base = base

MIGRATION.databaseName = nil
MIGRATION.savingKeys = nil

function MIGRATION:IsValid()
	return BaseClass.IsValid(self) and isstring(self.databaseName) and istable(self.savingKeys)
end

function MIGRATION:Upgrade()
	sql.CreateSqlTable(self.databaseName, self.savingKeys)
end

function MIGRATION:Downgrade()
	-- Insert sql.Drop here
end
