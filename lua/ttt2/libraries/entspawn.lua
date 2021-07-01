---
-- A load of function handling the weapon spawn
-- @author Mineotopia
-- @module entspawn

if CLIENT then return end -- this is a serverside-ony module

local pairs = pairs

entspawn = entspawn or {}

local function RemoveEntities(entTable)
	for _, ents in pairs(entTable) do
		for i = 1, #ents do
			print(ents[i])
			ents[i]:Remove()
		end
	end
end

function entspawn.RemoveMapEntities()
	RemoveEntities(map.GetWeaponSpawnEntities())
	RemoveEntities(map.GetAmmoSpawnEntities())
	--ToDo Player Spawns
end

function entspawn.HandleSpawns()
	-- in a first pass, all weapon entities are removed
	entspawn.RemoveMapEntities()
end
