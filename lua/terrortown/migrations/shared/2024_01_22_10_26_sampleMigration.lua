--- @ignore
-- Sample Migration file for server
-- Shows the use of migration commands
local states = {endMessage = "This is the end of all revert migration changes."}
local function Upgrade(cmd)
	print("You successfully upgraded to a system with migrations.")
end

local function Downgrade(cmd)
	print(cmd.endMessage)
end

migrations.Add(
	migrations.CreateCommand(
		states,
		Upgrade,
		Downgrade
	)
)
