---
-- @class MIGRATION
-- @section migration_base

MIGRATION.Upgrade = nil
MIGRATION.Downgrade = nil

function MIGRATION:IsValid()
	return isfunction(self.Upgrade) and isfunction(self.Downgrade)
end
