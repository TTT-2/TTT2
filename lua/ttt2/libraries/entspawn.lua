---
-- A load of function handling the weapon spawn
-- @author Mineotopia
-- @module entspawn

if CLIENT then return end -- this is a serverside-ony module

entspawn = entspawn or {}

function entspawn.PopulateWeapons()
	-- TODO: Handle weapon spawn scrips


end

concommand.Add("entspawn", function(ply, cmd, args)
	if args[1] == "rebuild" then
		print("rebuilding weapon spawn list...")

		entspawnscript.Init(true)
	end
end)
