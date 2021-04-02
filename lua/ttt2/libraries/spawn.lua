---
-- A load of function handling player spawn
-- @author Mineotopia
-- @module spawn

if CLIENT then return end -- this is a serverside-ony module

local Vector = Vector
local table = table
local mathSin = math.sin
local mathCos = math.cos
local entsFindByClass = ents.FindByClass

local spawnPointVariations = {Vector(0, 0, 0)}

for i = 0, 360, 22.5 do
	spawnPointVariations[#spawnPointVariations + 1] = Vector(mathCos(i), mathSin(i), 0)
end

local spawnTypes = {
	"info_player_deathmatch",
	"info_player_combine",
	"info_player_rebel",
	"info_player_counterterrorist",
	"info_player_terrorist",
	"info_player_axis",
	"info_player_allies",
	"gmod_player_start",
	"info_player_teamspawn"
}

-- returns the player size as a vector
local function GetPlayerSize(ply)
	local bottom, top = ply:GetHull()

	return top - bottom
end

spawn = spawn or {}
spawn.cachedSpawnEntities = spawn.cachedSpawnEntities or {}

---
-- Checks if a given spawn point is safe. Safe means that a player can spawn without
-- being stuck. Entities which are passable are ignored by the check.
-- @param Player ply The player entity that should spawn, this parameter is needed
-- to make sure there is enough space for this specific playermodel.
-- @param Vector pos The respawn position
-- @param[default=false] boolean force Should the respawn be forced? This means killing other players that block this position
-- @param[opt] table|Entity filter A table of entities or an entity that should be ignored by this check
-- @return boolean Returns if the spawn point is safe
-- @realm server
function spawn.IsSpawnPointSafe(ply, pos, force, filter)
	local sizePlayer = GetPlayerSize(ply)

	if not util.IsInWorld(pos) then
		return false
	end

	filter = istable(filter) and filter or {filter}

	-- the center pos is slightly shifted to the top to prevent ground
	-- collisions in the walltrace
	local posCenter = pos + Vector(0, 0, 0.525 * sizePlayer.z)

	-- Make sure there is enough space around the player
	local traceWalls = util.TraceHull({
		start = posCenter,
		endpos = posCenter,
		mins = -0.5 * sizePlayer,
		maxs = 0.5 * sizePlayer,
		filter = function(ent)
			if not IsValid(ent) or table.HasValue(filter, ent) then
				return false
			end

			if ent:HasPassableCollisionGrup() then
				return false
			end

			return true
		end,
		mask = MASK_SOLID
	})

	if traceWalls.Hit then
		return false
	end

	-- make sure the new position is on the ground
	local traceGround = util.TraceLine({
		start = posCenter,
		endpos = posCenter - Vector(0, 0, sizePlayer.z),
		filter = player.GetAll(),
		mask = MASK_SOLID
	})

	if not traceGround.Hit then
		return false
	end

	local blockingEntities = ents.FindInBox(
		pos + Vector(-0.5 * sizePlayer.x, -0.5 * sizePlayer.y, 0),
		pos + sizePlayer
	)

	for i = 1, #blockingEntities do
		local blockingEntity = blockingEntities[i]

		if not IsValid(blockingEntity) or not blockingEntity:IsPlayer()
			or not blockingEntity:IsTerror() or not blockingEntity:Alive()
		then continue end

		if table.HasValue(filter, blockingEntity) then continue end

		if force then
			blockingEntity:Kill()
		else
			return false
		end
	end

	return true
end

---
-- Returns a selection of points around the given position.
-- @param Player ply The player entity that should spawn, this parameter is needed
-- to make sure there is enough space for this specific playermodel.
-- @param Vector pos The given position
-- @param[default=1] number radiusMultiplier The radius multiplayer to calculate the new positions
-- @return table A table of position vectors
-- @realm server
function spawn.GetSpawnPointsAroundSpawn(ply, pos, radiusMultiplier)
	local sizePlayer = GetPlayerSize(ply)

	if not pos then return {} end

	local boundsPlayer = Vector(sizePlayer.x, sizePlayer.y, 0) * 1.5 * (radiusMultiplier or 1)
	local positions = {}

	for i = 1, #spawnPointVariations do
		positions[i] = pos + spawnPointVariations[i] * boundsPlayer
	end

	return positions
end

---
-- Tries to make spawn position valid by scanning surrounding area for
-- valid positions.
-- @param Player ply The player entity that should spawn, this parameter is needed
-- to make sure there is enough space for this specific playermodel.
-- @param Vector unsafePos The unsafe spawn position
-- @param[default=1] number radiusMultiplier The radius multiplayer to calculate the new positions
-- @return Vector|nil Returns the safe spawn position, nil if none was found
-- @realm server
function spawn.MakeSpawnPointSafe(ply, unsafePos, radiusMultiplier)
	local spawnPoints = spawn.GetSpawnPointsAroundSpawn(ply, unsafePos, radiusMultiplier)

	for i = 1, #spawnPoints do
		local spawnPoint = spawnPoints[i]

		if not spawn.IsSpawnPointSafe(ply, spawnPoint, false) then continue end

		return spawnPoint
	end
end

---
-- Returns a list of all spawn entities found on the map that are valid to spawn players.
-- @warning Don't use 'info_player_start' unless absolutely necessary, because eg. TF2 uses
-- it for observer starts that are in places where players cannot really spawn well.
-- Therefore by default 'info_player_start' is not included in the search. However if 'forceAll'
-- is set to true or no other map spawn was found, these spawn entities will be included.
-- @param boolean forceAll Shouldn't used unless absolutely necessary because it includes 'info_player_start' spawns
-- @return table Returns a table of unsafe spawn entities
-- @realm server
function spawn.GetPlayerSpawnEntities(forceAll)
	local processedSpawnEntities = {}

	for i = 1, #spawnTypes do
		local classname = spawnTypes[i]
		local spawnEntityTable = entsFindByClass(classname)

		for k = 1, #spawnEntityTable do
			local spawnEntityTableEntry = spawnEntityTable[k]

			if spawnEntityTableEntry.markAsRemoved then continue end

			processedSpawnEntities[#processedSpawnEntities + 1] = spawnEntityTableEntry
		end
	end

	-- Don't use info_player_start unless absolutely necessary, because eg. TF2
	-- uses it for observer starts that are in places where players cannot really
	-- spawn well. At all.
	if forceAll or #processedSpawnEntities == 0 then
		local startEntityTable = entsFindByClass("info_player_start")

		for k = 1, #startEntityTable do
			local startEntityTableEntry = startEntityTable[k]

			if startEntityTableEntry.markAsRemoved then continue end

			processedSpawnEntities[#processedSpawnEntities + 1] = startEntityTableEntry
		end
	end

	return processedSpawnEntities
end

---
-- Gets a table of spawnpoints on the map.
-- @note These spawn points are not shuffled.
-- @return table Returns a table of spawnpoints as @{Vector}s
-- @realm server
function spawn.GetPlayerSpawnPointTable()
	local spawnEnts = spawn.GetPlayerSpawnEntities(false)
	local spawnPoints = {}

	for i = 1, #spawnEnts do
		spawnPoints[i] = spawnEnts[i]:GetPos()
	end

	return spawnPoints
end

---
-- Gets a safe random player spawn entity. If no free and safe spawnpoint is found, it tries
-- to create its own by searching around existing ones.
-- @param Player ply The player that should receive their spawn point
-- @return Entity A safe spawn entity
-- @realm server
function spawn.GetRandomPlayerSpawnEntity(ply)
	-- One might think that we have to regenerate our spawnpoint
	-- cache. Otherwise, any riggedSpawnPoints spawn entities would not get reused, and
	-- MORE new entities would be made instead. In reality, the map cleanup at
	-- round start will remove our riggedSpawnPoints spawns, and we'll have to create new
	-- ones anyway.
	if #spawn.cachedSpawnEntities == 0 or not IsTableOfEntitiesValid(spawn.cachedSpawnEntities) then
		spawn.cachedSpawnEntities = spawn.GetPlayerSpawnEntities(false)
	end

	if #spawn.cachedSpawnEntities == 0 then
		Error("No spawn entity found!\n")

		return
	end

	-- the table should be shuffled for each spawn point calculation to improve randomness
	table.Shuffle(spawn.cachedSpawnEntities)

	if not IsValid(ply) or not ply:IsTerror() then
		return spawn.cachedSpawnEntities[1]
	end

	-- Optimistic attempt: assume there are sufficient spawns for all and one is free
	for i = 1, #spawn.cachedSpawnEntities do
		local spawnEntity = spawn.cachedSpawnEntities[i]

		if not spawn.IsSpawnPointSafe(ply, spawnEntity:GetPos(), false) then continue end

		return spawnEntity
	end

	-- That did not work, so now look around spawns
	local pickedSpawnEntity

	for i = 1, #spawn.cachedSpawnEntities do
		pickedSpawnEntity = spawn.cachedSpawnEntities[i]

		local riggedSpawnPoint = spawn.MakeSpawnPointSafe(ply, pickedSpawnEntity:GetPos())

		if not riggedSpawnPoint then continue end

		local riggedSpawnEntity = ents.Create("info_player_terrorist")

		riggedSpawnEntity:SetPos(riggedSpawnPoint)
		riggedSpawnEntity:Spawn()

		ErrorNoHalt("TTT2 WARNING: Map has too few spawn points, using a riggedSpawnPoints spawn for " .. tostring(ply) .. "\n")

		-- this is an old TTT flag that I will keep for compatibilities sake
		GAMEMODE.HaveRiggedSpawn = true

		return riggedSpawnEntity
	end

	-- Last attempt, force one
	for i = 1, #spawn.cachedSpawnEntities do
		local spawnEntity = spawn.cachedSpawnEntities[i]

		if not spawn.IsSpawnPointSafe(ply, spawnEntity:GetPos(), true) then continue end

		return spawnEntity
	end

	return pickedSpawnEntity
end

---
-- Removes all map spawn entities.
-- @warning Do not use this unless you know exactly what you are doing.
-- @realm server
function spawn.RemovePlayerSpawnEntities()
	local spawnableEnts = spawn.GetPlayerSpawnEntities(true)

	for i = 1, #spawnableEnts do
		local ent = spawnableEnts[i]

		-- they're not gone til next tick
		ent.markAsRemoved = true

		ent:Remove()
	end
end
