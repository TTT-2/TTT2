--- @ignore
-- Sample Migration file for server
-- Shows the use of migration commands
local version = "0.12.3b"

local states = {endMessage = "This is the end of all migration changes."}
local function Upgrade(cmd)
	print("You successfully upgraded to a system with migrations.")
end

local function Downgrade(cmd)
	print(cmd.endMessage)
end

migrations.add(version,
	migrations.CreateCommand(
		states,
		Upgrade,
		Downgrade
	)
)
