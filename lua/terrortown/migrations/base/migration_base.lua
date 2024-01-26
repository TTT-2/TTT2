---
-- @class MIGRATION
-- @section migration_base
MIGRATION.Upgrade = nil
MIGRATION.Downgrade = nil

---
-- Checks if upgrade and downgrade functions are available
-- @return boolean
function MIGRATION:IsValid()
	return isfunction(self.Upgrade) and isfunction(self.Downgrade)
end
