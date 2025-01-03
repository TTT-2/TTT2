---
-- This is the map module to have some short access functions
-- @author Mineotopia
-- @module map

if SERVER then
    AddCSLuaFile()

    util.AddNetworkString("TTT2ChangeServerLevel")
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
    "item_ammo_revolver",
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
    ["weapon_ttt_glock"] = WEAPON_TYPE_PISTOL,
}

local ttt_ammo_spawns = {
    ["ttt_random_ammo"] = AMMO_TYPE_RANDOM,
    ["item_ammo_pistol_ttt"] = AMMO_TYPE_PISTOL,
    ["item_ammo_smg1_ttt"] = AMMO_TYPE_MAC10,
    ["item_ammo_357_ttt"] = AMMO_TYPE_RIFLE,
    ["item_box_buckshot_ttt"] = AMMO_TYPE_SHOTGUN,
    ["item_ammo_revolver_ttt"] = AMMO_TYPE_DEAGLE,
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
    ["item_ammo_crate"] = WEAPON_TYPE_NADE,
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
    ["item_item_crate"] = AMMO_TYPE_RANDOM,
}

local css_weapon_spawns = {
    ["info_player_terrorist"] = WEAPON_TYPE_RANDOM,
    ["info_player_counterterrorist"] = WEAPON_TYPE_RANDOM,
    ["hostage_entity"] = WEAPON_TYPE_RANDOM,
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
    ["info_observer_point"] = WEAPON_TYPE_RANDOM,
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
    ["info_player_teamspawn"] = PLAYER_TYPE_RANDOM,
}

local ttt_player_spawns_fallback = {
    ["info_player_start"] = PLAYER_TYPE_RANDOM,
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
                ammo = spn.autoAmmoAmount or 0,
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
        ammo = spawn.ammo or 0,
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
            IsWeaponDummy = true,
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

    local hook_weapon_spawns = {}

    -- @realm shared
    hook.Run("TTT2MapRegisterWeaponSpawns", hook_weapon_spawns)

    FindSpawnEntities(spawns, hook_weapon_spawns)

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

    local hook_ammo_spawns = {}

    -- @realm shared
    hook.Run("TTT2MapRegisterAmmoSpawns", hook_ammo_spawns)

    FindSpawnEntities(spawns, hook_ammo_spawns)

    return spawns
end

---
-- Finds and returns player spawn entities found on a map.
-- @return table A table with all the player spawn entities grouped by ent types
-- @realm shared
function map.GetPlayerSpawnEntities()
    local spawns = {}
    local hook_player_spawns = {}

    -- @realm shared
    hook.Run("TTT2MapRegisterPlayerSpawns", hook_player_spawns)

    FindSpawnEntities(spawns, hook_player_spawns)
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
        local hook_player_spawns = {}

        -- @realm shared
        hook.Run("TTT2MapRegisterPlayerSpawns", hook_player_spawns)

        local plyType = ttt_player_spawns[cls]
            or hook_player_spawns[cls]
            or ttt_player_spawns_fallback[cls]

        if plyType then
            AddData(spawnTable[SPAWN_TYPE_PLAYER], plyType, spawn)

            continue
        end

        -- next check if it is an ammo spawn
        local hook_ammo_spawns = {}

        -- @realm shared
        hook.Run("TTT2MapRegisterAmmoSpawns", hook_ammo_spawns)

        local ammoType = ttt_ammo_spawns[cls] or hl2_ammo_spawns[cls] or hook_ammo_spawns[cls]

        if ammoType then
            AddData(spawnTable[SPAWN_TYPE_AMMO], ammoType, spawn)

            continue
        end

        -- next check if it is a weapon spawn
        local hook_weapon_spawns = {}
        -- @realm shared
        hook.Run("TTT2MapRegisterWeaponSpawns", hook_weapon_spawns)

        local wepType = ttt_weapon_spawns[cls]
            or hl2_weapon_spawns[cls]
            or css_weapon_spawns[cls]
            or tf2_weapon_spawns[cls]
            or hook_weapon_spawns[cls]

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
        ammo = ent.autoAmmoAmount or 0,
    }

    if spawnType == SPAWN_TYPE_WEAPON then
        local hook_weapon_spawns = {}
        -- @realm shared
        hook.Run("TTT2MapRegisterWeaponSpawns", hook_weapon_spawns)

        return ttt_weapon_spawns[cls]
            or hl2_weapon_spawns[cls]
            or css_weapon_spawns[cls]
            or tf2_weapon_spawns[cls]
            or hook_weapon_spawns[cls],
            data
    end

    if spawnType == SPAWN_TYPE_AMMO then
        local hook_ammo_spawns = {}

        -- @realm shared
        hook.Run("TTT2MapRegisterAmmoSpawns", hook_ammo_spawns)

        return ttt_ammo_spawns[cls] or hl2_ammo_spawns[cls] or hook_ammo_spawns[cls], data
    end

    if spawnType == SPAWN_TYPE_PLAYER then
        local hook_player_spawns = {}

        -- @realm shared
        hook.Run("TTT2MapRegisterPlayerSpawns", hook_player_spawns)

        return ttt_player_spawns[cls] or hook_player_spawns[cls] or ttt_player_spawns_fallback[cls],
            data
    end
end

local mapsAll = {}
local mapsPrefixes = {}
local mapsWSIDs = {}

if SERVER then
    -- by default cs, de, gm and test maps should be hidden
    -- while ttt and ttt2 maps should be shown

    ---
    -- @realm server
    CreateConVar("ttt2_enable_map_prefix_cs", "0", { FCVAR_ARCHIVE })

    ---
    -- @realm server
    CreateConVar("ttt2_enable_map_prefix_de", "0", { FCVAR_ARCHIVE })

    ---
    -- @realm server
    CreateConVar("ttt2_enable_map_prefix_gm", "0", { FCVAR_ARCHIVE })

    ---
    -- @realm server
    CreateConVar("ttt2_enable_map_prefix_test", "0", { FCVAR_ARCHIVE })

    ---
    -- @realm server
    CreateConVar("ttt2_enable_map_prefix_ttt", "1", { FCVAR_ARCHIVE })

    ---
    -- @realm server
    CreateConVar("ttt2_enable_map_prefix_ttt2", "1", { FCVAR_ARCHIVE })

    ---
    -- Initializes the map list. Searches the file system for available maps, scans those maps
    -- for their different prefixes and tries to associate a workshop ID with each map.
    -- @internal
    -- @realm server
    function map.InitializeList()
        mapsAll = {}
        mapsPrefixes = {}
        mapsWSIDs = {}

        local addons = engine.GetAddons()

        -- as a first step we create a mapname-wsid lookup table that can be used to later on
        -- assign wsids to maps that were found
        for i = 1, #addons do
            local addon = addons[i]

            if not string.find(string.lower(addon.tags), "map") then
                continue
            end

            local mapFound = file.Find("maps/*.bsp", addon.title)

            if not mapFound or #mapFound == 0 then
                continue
            end

            mapsWSIDs[string.sub(mapFound[1], 1, -5)] = addon.wsid
        end

        -- the next step is to find all maps that are installed on the server
        -- based on these found maps the prefixes and the base list is generated
        local mapsFound = file.Find("maps/*.bsp", "GAME")

        for i = 1, #mapsFound do
            mapsAll[i] = string.sub(mapsFound[i], 1, -5)

            local prefix = map.GetPrefix(mapsAll[i])

            if not prefix then
                continue
            end

            mapsPrefixes[prefix] = true
        end

        for prefix, _ in pairs(mapsPrefixes) do
            local convarName = "ttt2_enable_map_prefix_" .. prefix

            -- note: creating a convar which already exists does nothing
            -- the existing value will not be overwritten

            ---
            -- @realm server
            CreateConVar(convarName, "0", { FCVAR_ARCHIVE })

            -- because these convars are generated dynamically, replicated convars do not work here
            SetGlobalBool(convarName, GetConVar(convarName):GetBool())

            cvars.RemoveChangeCallback(convarName, convarName)
            cvars.AddChangeCallback(convarName, function(convar, _, new)
                SetGlobalBool(convar, tobool(new))
            end, convarName)
        end
    end

    ---
    -- Syncs the map data to a given client.
    -- @param Player ply The player that should receive the update
    -- @internal
    -- @realm server
    function map.SyncToClient(ply)
        if #mapsAll == 0 then
            map.InitializeList()
        end

        net.SendStream(
            "InitializeMapList",
            { maps = mapsAll, prefixes = mapsPrefixes, wsid = mapsWSIDs },
            ply
        )
    end

    net.Receive("TTT2ChangeServerLevel", function(_, ply)
        if not admin.IsAdmin(ply) then
            return
        end

        map.ChangeLevel(net.ReadString())
    end)
end

if CLIENT then
    local mapsIcons = {}

    net.ReceiveStream("InitializeMapList", function(sharedMapList)
        mapsAll = sharedMapList.maps
        mapsPrefixes = sharedMapList.prefixes
        mapsWSIDs = sharedMapList.wsid

        for i = 1, #mapsAll do
            map.PrecacheIcon(mapsAll[i])
        end

        map.DownloadIcons()
    end)

    ---
    -- Downloads map icons from the steam workshop on connect and server reload.
    -- @note This skips maps that already have a locally available icon.
    -- @internal
    -- @realm client
    function map.DownloadIcons()
        for mapName, wsid in pairs(mapsWSIDs) do
            if mapsIcons[mapName] then
                continue
            end

            steamworks.FileInfo(wsid, function(result)
                steamworks.Download(result.previewid, true, function(name)
                    mapsIcons[mapName] = AddonMaterial(name)
                end)
            end)
        end
    end

    ---
    -- Precaches the map icons on connect and server reload.
    -- @param string name The map name
    -- @internal
    -- @realm client
    function map.PrecacheIcon(name)
        if file.Exists("maps/thumb/" .. name .. ".png", "GAME") then
            mapsIcons[name] = Material("maps/thumb/" .. name .. ".png")
        elseif file.Exists("maps/" .. name .. ".png", "GAME") then
            mapsIcons[name] = Material("maps/" .. name .. ".png")
        end
    end

    ---
    -- Returns the cached icon of a map if there is an icon available.
    -- @note This not only uses the icons available on the client through addons, it also
    -- searches the workshop and tries to assign the corrent workshop icon if there
    -- is no locally available map icon.
    -- @param string name The map name
    -- @return nil|IMaterial Returns the cached material if available
    -- @realm client
    function map.GetIcon(name)
        return mapsIcons[name]
    end
end

---
-- Returns all available map prefixes found in the raw map table.
-- @return table Returns the table with all map prefixes
-- @realm shared
function map.GetPrefixes()
    return table.GetKeys(mapsPrefixes)
end

---
-- Returns the raw map table. This contains the names of all maps on the server. This
-- list is automatically synced between the server and all clients.
-- @return table Returns a table with the map names
-- @realm shared
function map.GetRawMapList()
    return mapsAll
end

---
-- Returns a sanitized list of maps installed on the server. Sanitized means that only
-- valid maps with a prefix that is enabled are listed here. This list is automatically
-- synced between the server and all clients.
-- @return table Returns a table with the map names
-- @realm shared
function map.GetList()
    local cleanedList = {}

    for i = 1, #mapsAll do
        local mapName = mapsAll[i]
        local mapNameSplit = string.Split(mapName, "_")

        if
            #mapNameSplit > 1
            and not GetGlobalBool("ttt2_enable_map_prefix_" .. mapNameSplit[1], false)
        then
            continue
        end

        cleanedList[#cleanedList + 1] = mapName
    end

    return cleanedList
end

---
-- Returns the map prefix (e.g. ttt) for a given name.
-- @param string name The map name
-- @return nil|string Returns the prefix or nil if there is none
-- @realm shared
function map.GetPrefix(name)
    local mapNameSplit = string.Split(name, "_")

    if #mapNameSplit <= 1 then
        return
    end

    return mapNameSplit[1]
end

---
-- Changes the currently played level (map) to the given name.
-- @note This does not check if this map exists on the server
-- @note When this function is run on the client, it is automatically
-- networked to the server while also making sure the client is a super admin.
-- @param string name The level name to switch to
-- @realm shared
function map.ChangeLevel(name)
    if SERVER then
        game.ConsoleCommand("changelevel " .. name .. "\n")
    else
        net.Start("TTT2ChangeServerLevel")
        net.WriteString(name)
        net.SendToServer()
    end
end

-- HOOKS --

---
-- This hook can be used to register additional ammo spawn entities that TTT2 should use.
-- @param table spawns Table keyed by entity name, values are AMMO_TYPE_* constants.
-- @hook
-- @realm shared
function GM:TTT2MapRegisterAmmoSpawns(spawns) end

---
-- This hook can be used to register additional weapon spawn entities that TTT2 should use.
-- @param table spawns Table keyed by entity name, values are WEAPON_TYPE_* constants.
-- @hook
-- @realm shared
function GM:TTT2MapRegisterWeaponSpawns(spawns) end

---
-- This hook can be used to register additional player spawn entities that TTT2 should use.
-- @param table spawns Table keyed by entity name, values are SPAWN_TYPE_* constants.
-- @hook
-- @realm shared
function GM:TTT2MapRegisterPlayerSpawns(spawns) end
