---
-- @desc A load of function handling player spawn
-- @author Mineotopia

local Vector = Vector
local table = table
local mathSin = math.sin
local mathCos = math.cos
local entsFindByClass = ents.FindByClass

local spawnPointVariations = {Vector(0, 0, 0)}
for i = 0, 360, 22.5 do
	spawnPointVariations[#spawnPointVariations + 1] = Vector(mathCos(i), mathSin(i), 0)
end

local sizePlayer = Vector(32, 32, 72)

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



spawn = spawn or {}

spawn.cachedSpawnEntities = spawn.cachedSpawnEntities or {}

---
-- Checks if a given spawn point is safe. Safe means that a player can spawn without
-- being stuck. Entities which are passable are ignored by the check.
-- @param Vector pos The respawn position
-- @param [default=false]boolean force Should the respawn be forced? This means killing other players that block this position
-- @param [opt]table|Entity filter A table of entities or an entity that should be ignored by this check
-- @return boolean Returns if the spawn point is safe
-- @realm server
function spawn.IsSpawnPointSafe(pos, force, filter)
	if not util.IsInWorld(pos) then
		return false
	end

	filter = istable(filter) and filter or {filter}

	local posCenter = pos + Vector(0, 0, 0.5 * sizePlayer.z)

	-- Make sure there is enough space around the player
	local traceWalls = util.TraceHull({
		start = posCenter,
		endpos = posCenter,
		mins = -0.5 * sizePlayer,
		maxs = 0.5 * sizePlayer,
		filter = function(ent)
			if not IsValid(ent) or ent:IsPlayer() then
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
-- Returns a selection of points around a given point.
-- @param Vector pos The given position
-- @return table A table of position vectors
-- @realm server
function spawn.GetSpawnPointsAroundSpawn(pos)
	if not pos then return {} end

	local positions = {}

	for i = 1, #spawnPointVariations do
		positions[#positions + 1] = pos + spawnPointVariations[i] * Vector(sizePlayer.x, sizePlayer.y, 0) * 1.5
	end

	return positions
end

---
-- Tries to make spawn position valid by scanning surrounding area for
-- valid positions.
-- @param Vector unsafePos The unsafe spawn position
-- @return Vector|nil Returns the safe spawn position, nil if none was found
-- @realm server
function spawn.MakeSpawnPointSafe(unsafePos)
	local spawnPoints = spawn.GetSpawnPointsAroundSpawn(unsafePos)

	for i = 1, #spawnPoints do
		local spawnPoint = spawnPoints[i]

		if not spawn.IsSpawnPointSafe(spawnPoint, false) then continue end

		return spawnPoint
	end
end

---
-- Returns a list of all spawn entities
-- @param boolean shouldShuffle whether the table should be shuffled
-- @param boolean forceAll used unless absolutely necessary (includes info_player_start spawns)
-- @return table Returns a table of unsafe spawn entities
-- @realm server
function spawn.GetPlayerSpawnEntities(shouldShuffle, forceAll)
	local tbl = {}

	for i = 1, #spawnTypes do
		local classname = spawnTypes[i]
		local entsTbl = entsFindByClass(classname)

		for k = 1, #entsTbl do
			if entsTbl[k].markAsRemoved then continue end

			tbl[#tbl + 1] = entsTbl[k]
		end
	end

	-- Don't use info_player_start unless absolutely necessary, because eg. TF2
	-- uses it for observer starts that are in places where players cannot really
	-- spawn well. At all.
	if forceAll or #tbl == 0 then
		local startTbl = entsFindByClass("info_player_start")

		for k = 1, #startTbl do
			if startTbl[k].markAsRemoved then continue end

			tbl[#tbl + 1] = startTbl[k]
		end
	end

	if shouldShuffle then
		table.Shuffle(tbl)
	end

	return tbl
end

---
-- Gets a table of spawnpoints on the map.
-- @return table Returns a table of spawnpoints as @{Vector}s
-- @realm server
function spawn.GetPlayerSpawnPointTable()
	local spawnEnts = spawn.GetPlayerSpawnEntities(true, false)
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
		spawn.cachedSpawnEntities = spawn.GetPlayerSpawnEntities(true, false)
	end

	if #spawn.cachedSpawnEntities == 0 then
		Error("No spawn entity found!\n")

		return
	end

	-- the table should be shuffled for each spawn point calculation to improve randomness
	table.Shuffle(spawn.cachedSpawnEntities)

	-- Optimistic attempt: assume there are sufficient spawns for all and one is free
	for i = 1, #spawn.cachedSpawnEntities do
		local spawnEntity = spawn.cachedSpawnEntities[i]

		if not IsValid(ply) or not ply:IsTerror() then
			return spawnEntity
		end

		if not spawn.IsSpawnPointSafe(spawnEntity:GetPos(), false) then continue end

		return spawnEntity
	end

	-- That did not work, so now look around spawns
	local pickedSpawnEntity

	for i = 1, #spawn.cachedSpawnEntities do
		pickedSpawnEntity = spawn.cachedSpawnEntities[i]

		local riggedSpawnPoint = spawn.MakeSpawnPointSafe(pickedSpawnEntity:GetPos())

		if riggedSpawnPoint then
			local riggedSpawnEntity = ents.Create("info_player_terrorist")

			riggedSpawnEntity:SetPos(riggedSpawnPoint)
			riggedSpawnEntity:Spawn()

			ErrorNoHalt("TTT2 WARNING: Map has too few spawn points, using a riggedSpawnPoints spawn for " .. tostring(ply) .. "\n")

			-- this is an old TTT flag that I will keep for compatibilities sake
			GAMEMODE.HaveRiggedSpawn = true

			return riggedSpawnEntity
		end
	end

	-- Last attempt, force one
	for i = 1, #spawn.cachedSpawnEntities do
		local spawnEntity = spawn.cachedSpawnEntities[i]

		if not spawn.IsSpawnPointSafe(spawnEntity:GetPos(), true) then continue end

		return spawnEntity
	end

	return pickedSpawnEntity
end

---
-- Removes all map spawn entities, shouldn't be used except you know what you're doing.
-- @realm server
function spawn.RemovePlayerSpawnEntities()
	local spawnableEnts = spawn.GetPlayerSpawnEntities(false, true)

	for i = 1, #spawnableEnts do
		local ent = spawnableEnts[i]

		-- they're not gone til next tick
		ent.markAsRemoved = true

		ent:Remove()
	end
end
