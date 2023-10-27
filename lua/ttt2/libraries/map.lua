---
-- This is the map module to have some short access functions
-- @author Mineotopia
-- @module map

if SERVER then
	AddCSLuaFile()
end

local scripedEntsRegister = scripted_ents.Register
local weaponsGetStored = weapons.GetStored
local tableAdd = table.Add

local pairs = pairs

local mapType = nil

local fallbackWepSpawnEnts = {
	-- CS:S
	"hostage_entity",
	-- TF2
	"item_ammopack_full",
	"item_ammopack_medium",
	"item_ammopack_small",
	"item_healthkit_full",
	"item_healthkit_medium",
	"item_healthkit_small",
	"item_teamflag",
	"game_intro_viewpoint",
	"info_observer_point",
	"team_control_point",
	"team_control_point_master",
	"team_control_point_round",
	-- ZM
	"item_ammo_revolver"
}

local ttt_weapon_spawns = {
	["ttt_random_weapon"] = WEAPON_TYPE_RANDOM,
	["weapon_zm_shotgun"] = WEAPON_TYPE_SHOTGUN,
	["weapon_zm_pistol"] = WEAPON_TYPE_PISTOL,
	["weapon_zm_rifle"] = WEAPON_TYPE_SNIPER,
	["weapon_zm_molotov"] = WEAPON_TYPE_NADE,
	["weapon_ttt_smokegrenade"] = WEAPON_TYPE_NADE,
	["weapon_ttt_confgrenade"] = WEAPON_TYPE_NADE,
	["weapon_zm_mac10"] = WEAPON_TYPE_HEAVY,
	["weapon_zm_revolver"] = WEAPON_TYPE_PISTOL,
	["weapon_zm_sledge"] = WEAPON_TYPE_HEAVY,
	["weapon_ttt_m16"] = WEAPON_TYPE_HEAVY,
	["weapon_ttt_glock"] = WEAPON_TYPE_PISTOL
}

local ttt_ammo_spawns = {
	["ttt_random_ammo"] = AMMO_TYPE_RANDOM,
	["item_ammo_pistol_ttt"] = AMMO_TYPE_PISTOL,
	["item_ammo_smg1_ttt"] = AMMO_TYPE_MAC10,
	["item_ammo_357_ttt"] = AMMO_TYPE_RIFLE,
	["item_box_buckshot_ttt"] = AMMO_TYPE_SHOTGUN,
	["item_ammo_revolver_ttt"] = AMMO_TYPE_DEAGLE
}

local hl2_weapon_spawns = {
	["weapon_smg1"] = WEAPON_TYPE_HEAVY,
	["weapon_shotgun"] = WEAPON_TYPE_SHOTGUN,
	["weapon_ar2"] = WEAPON_TYPE_HEAVY,
	["weapon_357"] = WEAPON_TYPE_SNIPER,
	["weapon_crossbow"] = WEAPON_TYPE_PISTOL,
	["weapon_rpg"] = WEAPON_TYPE_HEAVY,
	["weapon_frag"] = WEAPON_TYPE_PISTOL,
	["weapon_crowbar"] = WEAPON_TYPE_NADE,
	["item_ammo_smg1_grenade"] = WEAPON_TYPE_PISTOL,
	["item_healthkit"] = WEAPON_TYPE_SHOTGUN,
	["item_suitcharger"] = WEAPON_TYPE_HEAVY,
	["item_ammo_ar2_altfire"] = WEAPON_TYPE_HEAVY,
	["item_healthvial"] = WEAPON_TYPE_NADE,
	["item_ammo_crate"] = WEAPON_TYPE_NADE
}

local hl2_ammo_spawns = {
	["weapon_slam"] = AMMO_TYPE_PISTOL,
	["item_ammo_pistol"] = AMMO_TYPE_PISTOL,
	["item_box_buckshot"] = AMMO_TYPE_SHOTGUN,
	["item_ammo_smg1"] = AMMO_TYPE_MAC10,
	["item_ammo_357"] = AMMO_TYPE_RIFLE,
	["item_ammo_357_large"] = AMMO_TYPE_RIFLE,
	["item_ammo_revolver"] = AMMO_TYPE_DEAGLE, -- zm
	["item_ammo_ar2"] = AMMO_TYPE_PISTOL,
	["item_ammo_ar2_large"] = AMMO_TYPE_MAC10,
	["item_battery"] = AMMO_TYPE_RIFLE,
	["item_rpg_round"] = AMMO_TYPE_RIFLE,
	["item_ammo_crossbow"] = AMMO_TYPE_SHOTGUN,
	["item_healthcharger"] = AMMO_TYPE_DEAGLE,
	["item_item_crate"] = AMMO_TYPE_RANDOM
}

local css_weapon_spawns = {
	["info_player_terrorist"] = WEAPON_TYPE_RANDOM,
	["info_player_counterterrorist"] = WEAPON_TYPE_RANDOM,
	["hostage_entity"] = WEAPON_TYPE_RANDOM
}

local tf2_weapon_spawns = {
	["info_player_teamspawn"] = WEAPON_TYPE_RANDOM,
	["team_control_point"] = WEAPON_TYPE_RANDOM,
	["team_control_point_master"] = WEAPON_TYPE_RANDOM,
	["team_control_point_round"] = WEAPON_TYPE_RANDOM,
	["item_ammopack_full"] = WEAPON_TYPE_RANDOM,
	["item_ammopack_medium"] = WEAPON_TYPE_RANDOM,
	["item_ammopack_small"] = WEAPON_TYPE_RANDOM,
	["item_healthkit_full"] = WEAPON_TYPE_RANDOM,
	["item_healthkit_medium"] = WEAPON_TYPE_RANDOM,
	["item_healthkit_small"] = WEAPON_TYPE_RANDOM,
	["item_teamflag"] = WEAPON_TYPE_RANDOM,
	["game_intro_viewpoint"] = WEAPON_TYPE_RANDOM,
	["info_observer_point"] = WEAPON_TYPE_RANDOM
}

local ttt_player_spawns = {
	["info_player_deathmatch"] = PLAYER_TYPE_RANDOM,
	["info_player_combine"] = PLAYER_TYPE_RANDOM,
	["info_player_rebel"] = PLAYER_TYPE_RANDOM,
	["info_player_counterterrorist"] = PLAYER_TYPE_RANDOM,
	["info_player_terrorist"] = PLAYER_TYPE_RANDOM,
	["info_player_axis"] = PLAYER_TYPE_RANDOM,
	["info_player_allies"] = PLAYER_TYPE_RANDOM,
	["gmod_player_start"] = PLAYER_TYPE_RANDOM,
	["info_player_teamspawn"] = PLAYER_TYPE_RANDOM
}

local ttt_player_spawns_fallback = {
	["info_player_start"] = PLAYER_TYPE_RANDOM
}

local function FindSpawnEntities(spawns, classes)
	local amount = 0

	for class, entType in pairs(classes) do
		spawns[entType] = spawns[entType] or {}

		local spawnsFound = ents.FindByClass(class)

		tableAdd(spawns[entType], spawnsFound)

		amount = amount + #spawnsFound
	end

	return amount
end

local function DatafySpawnTable(spawnTable)
	local spawnDataTable = {}

	for entType, spawns in pairs(spawnTable) do
		for i = 1, #spawns do
			local spn = spawns[i]

			spawnDataTable[entType] = spawnDataTable[entType] or {}

			spawnDataTable[entType][#spawnDataTable[entType] + 1] = {
				pos = spn:GetPos(),
				ang = spn:GetAngles(),
				ammo = spn.autoAmmoAmount or 0
			}
		end
	end

	return spawnDataTable
end

local function AddData(spawnTable, entType, spawn)
	spawnTable[entType] = spawnTable[entType] or {}

	spawnTable[entType][#spawnTable[entType] + 1] = {
		pos = spawn.pos,
		ang = spawn.ang,
		ammo = spawn.ammo or 0
	}
end

map = map or {}

MAP_TYPE_TERRORTOWN = 1
MAP_TYPE_COUNTERSTRIKE = 2
MAP_TYPE_TEAMFORTRESS = 3

---
-- CS:S and TF2 maps have a bunch of ents we'd like to abuse for weapon spawns,
-- but to do that we need to register a SENT with their class name, else they
-- will just error out and we can't do anything with them.
-- @internal
-- @realm server
function map.DummifyFallbackWeaponEnts()
	for i = 1, #fallbackWepSpawnEnts do
		scripedEntsRegister({
			Type = "point",
			IsWeaponDummy = true
		}, fallbackWepSpawnEnts[i])
	end
end

-- automatically run the dummmify function
map.DummifyFallbackWeaponEnts()

---
-- Returns the exptected type of the current map.
-- @note This function uses caching to improve performance and only reads the
-- map entities on the first call of the function.
-- @return[default=MAP_TYPE_TERRORTOWN] number Returns the map type of the currently active map
-- @realm shared
function map.GetMapGameType()
	-- return cached map type if already cached
	if mapType then
		return mapType
	end

	if #ents.FindByClass("info_player_counterterrorist") ~= 0 then
		mapType = MAP_TYPE_COUNTERSTRIKE
	elseif #ents.FindByClass("info_player_teamspawn") ~= 0 then
		mapType = MAP_TYPE_TEAMFORTRESS
	else
		-- as a fallback use the terrortown map type since most maps are terrotown maps;
		-- they are identified with the class 'info_player_deathmatch'
		mapType = MAP_TYPE_TERRORTOWN
	end

	return mapType
end

---
-- Checks if the currently selected map is a terrortown map.
-- @note This function uses caching to improve performance and only reads the
-- map entities on the first call of the function.
-- @return boolean Returns true if it is a terrortown map
-- @realm shared
function map.IsTerrortownMap()
	return map.GetMapGameType() == MAP_TYPE_TERRORTOWN
end

---
-- Checks if the currently selected map is a counter strike source map.
-- @note This function uses caching to improve performance and only reads the
-- map entities on the first call of the function.
-- @return boolean Returns true if it is a counter strike source map
-- @realm shared
function map.IsCounterStrikeMap()
	return map.GetMapGameType() == MAP_TYPE_COUNTERSTRIKE
end

---
-- Checks if the currently selected map is a team fortress 2 map.
-- @note This function uses caching to improve performance and only reads the
-- map entities on the first call of the function.
-- @return boolean Returns true if it is a team fortress 2 map
-- @realm shared
function map.IsTeamFortressMap()
	return map.GetMapGameType() == MAP_TYPE_TEAMFORTRESS
end

---
-- Finds and returns all weapon entities found on a map depending on the
-- map type.
-- @note It always finds the spawns of TTT/HL2 weapons. If it is a Counter Strike
-- Source map, those spawns are added to the aforementioned spawns. The same holds
-- true to Team Fortress 2 maps.
-- @return table A table with all the weapon spawn entities grouped by ent types
-- @realm shared
function map.GetWeaponSpawnEntities()
	local spawns = {}

	FindSpawnEntities(spawns, ttt_weapon_spawns)
	FindSpawnEntities(spawns, hl2_weapon_spawns)

	if map.IsCounterStrikeMap() then
		FindSpawnEntities(spawns, css_weapon_spawns)
	elseif map.IsTeamFortressMap() then
		FindSpawnEntities(spawns, tf2_weapon_spawns)
	end

	return spawns
end

---
-- Finds and returns all ammo entities found on a map.
-- @return table A table with all the ammo spawn entities grouped by ent types
-- @realm shared
function map.GetAmmoSpawnEntities()
	local spawns = {}

	FindSpawnEntities(spawns, ttt_ammo_spawns)
	FindSpawnEntities(spawns, hl2_ammo_spawns)

	return spawns
end

---
-- Finds and returns player spawn entities found on a map.
-- @return table A table with all the player spawn entities grouped by ent types
-- @realm shared
function map.GetPlayerSpawnEntities()
	local spawns = {}

	if FindSpawnEntities(spawns, ttt_player_spawns) == 0 then
		FindSpawnEntities(spawns, ttt_player_spawns_fallback)
	end

	return spawns
end

---
-- Finds and returns all weapon spawns found on a map depending on the
-- map type.
-- @return table A table with all the weapon spawns grouped by ent types
-- @realm shared
function map.GetWeaponSpawns()
	return DatafySpawnTable(map.GetWeaponSpawnEntities())
end

---
-- Finds and returns all ammo spawns found on a map.
-- @return table A table with all the ammo spawns grouped by ent types
-- @realm shared
function map.GetAmmoSpawns()
	return DatafySpawnTable(map.GetAmmoSpawnEntities())
end

---
-- Finds and returns player spawns found on a map.
-- @return table A table with all the player spawns grouped by ent types
-- @realm shared
function map.GetPlayerSpawns()
	return DatafySpawnTable(map.GetPlayerSpawnEntities())
end

---
-- Is used to get a TTT2 style spawn table from the old TTT spawn script data.
-- @param table spawns The spawn table that should be converted
-- @return table A table with all weapon, ammo and player spawns sorted by ent types
-- @internal
-- @realm shared
function map.GetSpawnsFromClassTable(spawns)
	local spawnTable = entspawnscript.GetEmptySpawnTableStructure()

	for i = 1, #spawns do
		local spawn = spawns[i]
		local cls = spawn.class

		-- first check if it is a player spawn, this is independant from the map type
		local plyType = ttt_player_spawns[cls] or ttt_player_spawns_fallback[cls]

		if plyType then
			AddData(spawnTable[SPAWN_TYPE_PLAYER], plyType, spawn)

			continue
		end

		-- next check if it is an ammo spawn
		local ammoType = ttt_ammo_spawns[cls] or hl2_ammo_spawns[cls]

		if ammoType then
			AddData(spawnTable[SPAWN_TYPE_AMMO], ammoType, spawn)

			continue
		end

		-- next check if it is a weapon spawn
		local wepType = ttt_weapon_spawns[cls] or hl2_weapon_spawns[cls] or css_weapon_spawns[cls] or tf2_weapon_spawns[cls]

		if wepType then
			AddData(spawnTable[SPAWN_TYPE_WEAPON], wepType, spawn)

			continue
		end

		-- if it is still not found, see it as a weapon and check if it has a spawn type flag
		local wep = weaponsGetStored(cls)

		if wep and wep.spawnType then
			AddData(spawnTable[SPAWN_TYPE_WEAPON], wep.spawnType, spawn)

			continue
		end

		-- as a last fallback assume that it is a random spawn for a weapon
		AddData(spawnTable[SPAWN_TYPE_WEAPON], WEAPON_TYPE_RANDOM, spawn)
	end

	return spawnTable
end

---
-- Checks if a given entity is a default terrortown map entity. Can be used to determine if an entity
-- should be removed from the map prior to spawning with the custom spawn system.
-- @note Only spawn entities that spawn weapons or ammo (but no random weapons / ammo) are counted as
-- default TTT spawn entites. While player spawns would fall into this category as well, we use our
-- own custom player spawn system that relies on those entities being removed.
-- @param Entity ent The entity to check
-- @return boolean Returns true if the given entity is default terrortown entity
-- @realm shared
function map.IsDefaultTerrortownMapEntity(ent)
	local cls = ent:GetClass()

	local type = ttt_weapon_spawns[cls] ~= nil or ttt_ammo_spawns[cls] ~= nil

	if not type or type == WEAPON_TYPE_RANDOM or type == AMMO_TYPE_RANDOM then
		return false
	end

	return true
end

---
-- Get detailed data from a spawn entity.
-- @param Entity ent The spawn entity
-- @param number spawnType The spawn type of the entity
-- @return number The ent type
-- @return table The spawn data (pos, ang, ammo)
-- @realm shared
function map.GetDataFromSpawnEntity(ent, spawnType)
	local cls = ent:GetClass()
	local data = {
		pos = ent:GetPos(),
		ang = ent:GetAngles(),
		ammo = ent.autoAmmoAmount or 0
	}

	if spawnType == SPAWN_TYPE_WEAPON then
		return ttt_weapon_spawns[cls] or hl2_weapon_spawns[cls] or css_weapon_spawns[cls] or tf2_weapon_spawns[cls], data
	end

	if spawnType == SPAWN_TYPE_AMMO then
		return ttt_ammo_spawns[cls] or hl2_ammo_spawns[cls], data
	end

	if spawnType == SPAWN_TYPE_PLAYER then
		return ttt_player_spawns[cls] or ttt_player_spawns_fallback[cls], data
	end
end
