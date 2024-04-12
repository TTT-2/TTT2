---
-- A load of function handling the weapon spawn
-- @author Mineotopia
-- @module entspawn

if CLIENT then
    return
end -- this is a serverside-ony module

---
-- @realm server
-- stylua: ignore
local cvSpawnWaveInterval = CreateConVar("ttt_spawn_wave_interval", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

local pairs = pairs
local Vector = Vector
local VectorRand = VectorRand
local mathRand = math.Rand
local mathMin = math.min
local timerCreate = timer.Create
local timerRemove = timer.Remove

local allowForcedRandomSpawn = false

entspawn = entspawn or {}

---
-- Enable or disable forced random spawns for 'env_entity_maker' spawning non available
-- random spawns at map start.
-- @note see: https://developer.valvesoftware.com/wiki/Env_entity_maker
-- @param boolean enable The state to set it to.
-- @realm server
function entspawn.SetForcedRandomSpawn(enable)
    allowForcedRandomSpawn = enable
end

---
-- To check if forced random spawns are available.
-- @return boolean if forced random spawns are enabled
-- @realm server
function entspawn.IsForcedRandomSpawnEnabled()
    return allowForcedRandomSpawn
end

---
-- Spawns a random weapon with the given data of the random spawn entity.
-- @param Entity ent the entity holding the random weapon data
-- @realm server
function entspawn.SpawnRandomWeapon(ent)
    local spawns = {
        [WEAPON_TYPE_RANDOM] = {
            [1] = {
                pos = ent:GetPos(),
                ang = ent:GetAngles(),
                ammo = ent.autoAmmoAmount or 0,
            },
        },
    }

    local wepsForTypes, weps = WEPS.GetWeaponsForSpawnTypes()
    entspawn.SpawnEntities(spawns, wepsForTypes, weps, WEAPON_TYPE_RANDOM)
end

---
-- Spawns a random ammo box with the given data of the random spawn entity.
-- @param Entity ent the entity holding the random ammo data
-- @realm server
function entspawn.SpawnRandomAmmo(ent)
    local spawns = {
        [AMMO_TYPE_RANDOM] = {
            [1] = {
                pos = ent:GetPos(),
                ang = ent:GetAngles(),
                ammo = 1,
            },
        },
    }

    local ammoForTypes, ammo = WEPS.GetAmmoForSpawnTypes()
    entspawn.SpawnEntities(spawns, ammoForTypes, ammo, AMMO_TYPE_RANDOM)
end

local function RemoveEntities(entTable, spawnTable, spawnType)
    local useDefaultSpawns = not entspawnscript.ShouldUseCustomSpawns()

    for _, ents in pairs(entTable) do
        for i = 1, #ents do
            local ent = ents[i]

            -- do not remove entity if no custom spawns are used
            if useDefaultSpawns then
                if map.IsDefaultTerrortownMapEntity(ent) then
                    continue
                end

                -- since some obscure spawn entities are valid for multiple different spawn types,
                -- they can be used to spawn different types of entities. Therefore this is a table.
                local entType, data = map.GetDataFromSpawnEntity(ent, spawnType)

                spawnTable[spawnType] = spawnTable[spawnType] or {}
                spawnTable[spawnType][entType] = spawnTable[spawnType][entType] or {}

                spawnTable[spawnType][entType][#spawnTable[spawnType][entType] + 1] = data
            end

            ent:Remove()
        end
    end
end

local function GetRandomEntityFromTable(ents)
    if not ents then
        return
    end

    return ents[math.random(#ents)]
end

---
-- Removes all spawn entities that are found on the map. It also returns a table
-- of all special entities that might be defined in a classic TTT spawn script if
-- classic spawn mode is enabled. These retuned entities are then spawned with the
-- new spawn system.
-- @return table spawnTable A table of entities that should be spawned additionally
-- @realm server
function entspawn.RemoveMapEntities()
    local spawnTable = entspawnscript.GetEmptySpawnTableStructure()

    RemoveEntities(map.GetWeaponSpawnEntities(), spawnTable, SPAWN_TYPE_WEAPON)
    RemoveEntities(map.GetAmmoSpawnEntities(), spawnTable, SPAWN_TYPE_AMMO)
    RemoveEntities(map.GetPlayerSpawnEntities(), spawnTable, SPAWN_TYPE_PLAYER)

    return spawnTable
end

---
-- Spawns weapon and ammo entities on provided spawn point table. The spawn point table already
-- has the entity types defined.
-- @param table spawns A table that contains the spawns where entities should be spawned
-- @param table entsForTypes A table that assigns the ent types to a list of possible entities
-- @param table entTable A single indexed list that contains all entites without type grouping
-- @param number randomType The spawn type that should be used as random
-- @realm server
function entspawn.SpawnEntities(spawns, entsForTypes, entTable, randomType)
    if not spawns then
        return
    end

    for entType, spawnTable in pairs(spawns) do
        for i = 1, #spawnTable do
            local spawn = spawnTable[i]
            --Check if spawn.pos is valid
            if not spawn or not spawn.pos then
                continue
            end
            -- if the weapon spawn is a random weapon spawn, select any spawnable weapon
            local selectedEnt
            if entType == randomType then
                selectedEnt = GetRandomEntityFromTable(entTable)
            else
                selectedEnt = GetRandomEntityFromTable(entsForTypes[entType])
            end

            if not selectedEnt then
                continue
            end

            -- create the weapon entity
            local spawnedEnt = ents.Create(WEPS.GetClass(selectedEnt))

            if not IsValid(spawnedEnt) then
                continue
            end

            -- set the position and angle of the spawned weapon entity
            spawnedEnt:SetPos(spawn.pos)
            spawnedEnt:SetAngles(spawn.ang)
            spawnedEnt:Spawn()
            spawnedEnt:PhysWake()

            -- if the spawn has a defined auto ammo spawn, the ammo should be spawned now
            if spawn.ammo == 0 or not spawnedEnt.AmmoEnt then
                continue
            end

            for k = 1, spawn.ammo do
                local ammoEnt = ents.Create(spawnedEnt.AmmoEnt)

                if not IsValid(ammoEnt) then
                    continue
                end

                local pos = spawn.pos + Vector(mathRand(-35, 35), mathRand(-35, 35), 25)

                ammoEnt:SetPos(pos)
                ammoEnt:SetAngles(VectorRand():Angle())
                ammoEnt:Spawn()
                ammoEnt:PhysWake()
            end
        end
    end
end

---
-- Spawns all available players.
-- @param[opt] boolean deadOnly Set to true to only respawn dead players
-- @realm server
function entspawn.SpawnPlayers(deadOnly)
    local waveDelay = cvSpawnWaveInterval:GetFloat()
    local plys = player.GetAll()

    -- simple method, spawn everybody at once
    if waveDelay <= 0 or deadOnly then
        for i = 1, #plys do
            plys[i]:SpawnForRound(deadOnly)
        end
    else
        -- wave method
        local amountSpawnPoints = #plyspawn.GetPlayerSpawnPoints()
        local playersToSpawn = {}

        for _, ply in RandomPairs(plys) do
            if ply:ShouldSpawn() then
                playersToSpawn[#playersToSpawn + 1] = ply

                GAMEMODE:PlayerSpawnAsSpectator(ply)
            end
        end

        local spawnFunction = function()
            local sizePlayersToSpawn = #playersToSpawn
            local sizeSpawnWave = mathMin(amountSpawnPoints, sizePlayersToSpawn)

            -- fill the available spawnpoints with players that need spawning
            for i = 1, sizeSpawnWave do
                playersToSpawn[i]:SpawnForRound(deadOnly)

                playersToSpawn[i] = nil -- mark for deletion
            end

            -- clean up table
            table.RemoveEmptyEntries(playersToSpawn, sizePlayersToSpawn)

            Dev(1, "Spawned " .. sizeSpawnWave .. " players in spawn wave.")

            if #playersToSpawn == 0 then
                timerRemove("spawnwave")

                Dev(1, "Spawn waves ending, all players spawned.")
            end
        end

        Dev(1, "Spawn waves starting.")

        timerCreate("spawnwave", waveDelay, 0, spawnFunction)

        -- already run one wave, which may stop the timer if everyone is spawned in one go
        spawnFunction()
    end
end

---
-- Handles the spawn of player, ammo and weapon entites. Normaly called in
-- @{GM:PostCleanupMap}.
-- @internal
-- @realm server
function entspawn.HandleSpawns()
    -- in a first pass, all weapon entities are removed; if in classic spawn mode, a few
    -- spawn points that should be replaced are returned
    local spawnTable = entspawn.RemoveMapEntities()

    -- if in classic mode, set those spawn points to data table
    if not entspawnscript.ShouldUseCustomSpawns() then
        entspawnscript.SetSpawns(spawnTable)
    end

    -- in the next tick the new entities are spawned
    timer.Simple(0, function()
        -- SPAWN WEAPONS
        local wepSpawns = entspawnscript.GetSpawnsForSpawnType(SPAWN_TYPE_WEAPON)
        -- This function returns two tables, the first is ordered by weapon spawn types,
        -- the second is just a normal indexed list with all spawnable weapons. This is
        -- done like this to improve the performance for random weapon spawns.
        local wepsForTypes, weps = WEPS.GetWeaponsForSpawnTypes()

        entspawn.SpawnEntities(wepSpawns, wepsForTypes, weps, WEAPON_TYPE_RANDOM)

        -- SPAWN AMMO
        local ammoSpawns = entspawnscript.GetSpawnsForSpawnType(SPAWN_TYPE_AMMO)
        -- This function returns two tables, the first is ordered by weapon spawn types,
        -- the second is just a normal indexed list with all spawnable weapons. This is
        -- done like this to improve the performance for random weapon spawns.
        local ammoForTypes, ammo = WEPS.GetAmmoForSpawnTypes()

        entspawn.SpawnEntities(ammoSpawns, ammoForTypes, ammo, AMMO_TYPE_RANDOM)

        -- SPAWN PLAYER
        entspawn.SpawnPlayers(false)
    end)
end
