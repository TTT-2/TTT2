---
-- A load of function handling the weapon spawn
-- @author Mineotopia
-- @module entspawn

if CLIENT then return end -- this is a serverside-ony module

local pairs = pairs
local Vector = Vector
local VectorRand = VectorRand
local mathRand = math.Rand

entspawn = entspawn or {}

local function RemoveEntities(entTable)
	for _, ents in pairs(entTable) do
		for i = 1, #ents do
			ents[i]:Remove()
		end
	end
end

local function GetRandomEntityFromTable(ents)
	if not ents then return end

	return ents[math.random(#ents)]
end

function entspawn.RemoveMapEntities()
	RemoveEntities(map.GetWeaponSpawnEntities())
	RemoveEntities(map.GetAmmoSpawnEntities())
	--ToDo Player Spawns
end

function entspawn.SpawnEntities(spawns, entsForTypes, entTable, randomType)
	for entType, spawnTable in pairs(spawns) do
		for i = 1, #spawnTable do
			local spawn = spawnTable[i]

			-- if the weapon spawn is a random weapon spawn, select any spawnable weapon
			local selectedEnt
			if entType == randomType then
				selectedEnt = GetRandomEntityFromTable(entTable)
			else
				selectedEnt = GetRandomEntityFromTable(entsForTypes[entType])
			end

			if not selectedEnt then continue end

			-- create the weapon entity
			local spawnedEnt = ents.Create(WEPS.GetClass(selectedEnt))

			if not IsValid(spawnedEnt) then continue end

			-- set the position and angle of the spawned weapon entity
			spawnedEnt:SetPos(spawn.pos)
			spawnedEnt:SetAngles(spawn.ang)
			spawnedEnt:Spawn()
			spawnedEnt:PhysWake()

			-- if the spawn has a defined auto ammo spawn, the ammo should be spawned now
			if spawn.ammo == 0 or not spawnedEnt.AmmoEnt then continue end

			for k = 1, spawn.ammo do
				local ammoEnt = ents.Create(spawnedEnt.AmmoEnt)

				if not IsValid(ammoEnt) then continue end

				local pos = spawn.pos + Vector(mathRand(-35, 35), mathRand(-35, 35), 25)

				ammoEnt:SetPos(pos)
				ammoEnt:SetAngles(VectorRand():Angle())
				ammoEnt:Spawn()
				ammoEnt:PhysWake()
			end
		end
	end
end

function entspawn.HandleSpawns()
	-- in a first pass, all weapon entities are removed
	entspawn.RemoveMapEntities()

	-- in the next tick the new weapons are spawned
	timer.Simple(0, function()
		local wepSpawns = entspawnscript.GetSpawnEntitiesForSpawnType(SPAWN_TYPE_WEAPON)
		-- This function returns two tables, the first is ordered by weapon spawn types,
		-- the second is just a normal indexed list with all spawnable weapons. This is
		-- done like this to improve the performance for random weapon spawns.
		local wepsForTypes, weps = WEPS.GetWeaponsForSpawnTypes()

		entspawn.SpawnEntities(wepSpawns, wepsForTypes, weps, WEAPON_TYPE_RANDOM)

		local ammoSpawns = entspawnscript.GetSpawnEntitiesForSpawnType(SPAWN_TYPE_AMMO)
		-- This function returns two tables, the first is ordered by weapon spawn types,
		-- the second is just a normal indexed list with all spawnable weapons. This is
		-- done like this to improve the performance for random weapon spawns.
		local ammoForTypes, ammo = WEPS.GetAmmoForSpawnTypes()

		entspawn.SpawnEntities(ammoSpawns, ammoForTypes, ammo, AMMO_TYPE_RANDOM)
	end)
end
