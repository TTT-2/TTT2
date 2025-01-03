---
-- A load of function handling the weapon spawn scripts
-- @author Mineotopia
-- @module entspawnscript

if SERVER then
    AddCSLuaFile()
end

local fileExists = file.Exists
local fileCreateDir = file.CreateDir
local fileWrite = file.Write
local fileRead = file.Read
local fileDelete = file.Delete
local gameGetMap = game.GetMap
local pairs = pairs
local tableRemove = table.remove
local tableAdd = table.Add
local tableCopy = table.Copy
local utilTableToJSON = util.TableToJSON
local utilJSONToTable = util.JSONToTable
local playerGetAll = player.GetAll

local spawnPointList = {}
local settingsList = {}

local defaultSettings = {
    ["blacklisted"] = 0,
}

local spawndir = "terrortown/entityspawns/spawnpoints/"
local settingsdir = "terrortown/entityspawns/settings/"

local spawnTypeNameKeys = {
    [SPAWN_TYPE_WEAPON] = "SPAWN_TYPE_WEAPON",
    [SPAWN_TYPE_AMMO] = "SPAWN_TYPE_AMMO",
    [SPAWN_TYPE_PLAYER] = "SPAWN_TYPE_PLAYER",
}

local spawnTypes = {
    SPAWN_TYPE_WEAPON,
    SPAWN_TYPE_AMMO,
    SPAWN_TYPE_PLAYER,
}

local spawnColors = {
    [SPAWN_TYPE_WEAPON] = Color(0, 175, 175, 255),
    [SPAWN_TYPE_AMMO] = Color(175, 75, 75, 255),
    [SPAWN_TYPE_PLAYER] = Color(75, 175, 50, 255),
}

local spawnData = {
    [SPAWN_TYPE_WEAPON] = {
        [WEAPON_TYPE_RANDOM] = {
            material = Material("vgui/ttt/tid/tid_big_weapon_random"),
            name = "spawn_weapon_random",
            var = "WEAPON_TYPE_RANDOM",
        },
        [WEAPON_TYPE_MELEE] = {
            material = Material("vgui/ttt/tid/tid_big_weapon_melee"),
            name = "spawn_weapon_melee",
            var = "WEAPON_TYPE_MELEE",
        },
        [WEAPON_TYPE_NADE] = {
            material = Material("vgui/ttt/tid/tid_big_weapon_nade"),
            name = "spawn_weapon_nade",
            var = "WEAPON_TYPE_NADE",
        },
        [WEAPON_TYPE_SHOTGUN] = {
            material = Material("vgui/ttt/tid/tid_big_weapon_shotgun"),
            name = "spawn_weapon_shotgun",
            var = "WEAPON_TYPE_SHOTGUN",
        },
        [WEAPON_TYPE_HEAVY] = {
            material = Material("vgui/ttt/tid/tid_big_weapon_assault"),
            name = "spawn_weapon_heavy",
            var = "WEAPON_TYPE_HEAVY",
        },
        [WEAPON_TYPE_SNIPER] = {
            material = Material("vgui/ttt/tid/tid_big_weapon_sniper"),
            name = "spawn_weapon_sniper",
            var = "WEAPON_TYPE_SNIPER",
        },
        [WEAPON_TYPE_PISTOL] = {
            material = Material("vgui/ttt/tid/tid_big_weapon_pistol"),
            name = "spawn_weapon_pistol",
            var = "WEAPON_TYPE_PISTOL",
        },
        [WEAPON_TYPE_SPECIAL] = {
            material = Material("vgui/ttt/tid/tid_big_weapon_special"),
            name = "spawn_weapon_special",
            var = "WEAPON_TYPE_SPECIAL",
        },
    },
    [SPAWN_TYPE_AMMO] = {
        [AMMO_TYPE_RANDOM] = {
            material = Material("vgui/ttt/tid/tid_big_ammo_random"),
            name = "spawn_ammo_random",
            var = "AMMO_TYPE_RANDOM",
        },
        [AMMO_TYPE_DEAGLE] = {
            material = Material("vgui/ttt/tid/tid_big_ammo_deagle"),
            name = "spawn_ammo_deagle",
            var = "AMMO_TYPE_DEAGLE",
        },
        [AMMO_TYPE_PISTOL] = {
            material = Material("vgui/ttt/tid/tid_big_ammo_pistol"),
            name = "spawn_ammo_pistol",
            var = "AMMO_TYPE_PISTOL",
        },
        [AMMO_TYPE_MAC10] = {
            material = Material("vgui/ttt/tid/tid_big_ammo_mac10"),
            name = "spawn_ammo_mac10",
            var = "AMMO_TYPE_MAC10",
        },
        [AMMO_TYPE_RIFLE] = {
            material = Material("vgui/ttt/tid/tid_big_ammo_rifle"),
            name = "spawn_ammo_rifle",
            var = "AMMO_TYPE_RIFLE",
        },
        [AMMO_TYPE_SHOTGUN] = {
            material = Material("vgui/ttt/tid/tid_big_ammo_shotgun"),
            name = "spawn_ammo_shotgun",
            var = "AMMO_TYPE_SHOTGUN",
        },
    },
    [SPAWN_TYPE_PLAYER] = {
        [PLAYER_TYPE_RANDOM] = {
            material = Material("vgui/ttt/tid/tid_big_player"),
            name = "spawn_player_random",
            var = "PLAYER_TYPE_RANDOM",
        },
    },
}

local kindToSpawnType = {
    [WEAPON_PISTOL] = WEAPON_TYPE_PISTOL,
    [WEAPON_HEAVY] = WEAPON_TYPE_HEAVY,
    [WEAPON_NADE] = WEAPON_TYPE_NADE,
    [WEAPON_EQUIP1] = WEAPON_TYPE_SPECIAL,
    [WEAPON_EQUIP2] = WEAPON_TYPE_SPECIAL,
    [WEAPON_ROLE] = WEAPON_TYPE_SPECIAL,
    [WEAPON_MELEE] = WEAPON_TYPE_MELEE,
    [WEAPON_CARRY] = WEAPON_TYPE_MELEE,
}

entspawnscript = entspawnscript or {}

if SERVER then
    entspawnscript.defaultSpawnsSaved = entspawnscript.defaultSpawnsSaved or false
    entspawnscript.defaultSpawnTable = entspawnscript.defaultSpawnTable or {}
    entspawnscript.editingPlayers = entspawnscript.editingPlayers or {}

    ---
    -- @realm server
    local cvUseWeaponSpawnScript = CreateConVar("ttt_use_weapon_spawn_scripts", "1")
    ---
    -- Called when the entities on the map are available and the spawn entities can be read..
    -- @realm server
    function entspawnscript.OnLoaded()
        -- save default map data in memory
        if not entspawnscript.defaultSpawnsSaved then
            entspawnscript.defaultSpawnsSaved = true
            entspawnscript.SaveMapStateAsDefault()
        end

        if not entspawnscript.SpawnFileExists() or not entspawnscript.SettingsFileExists() then
            -- if the map was never changed, check if there is an old spawn script and convert it to the new system
            local spawnPoints, settings = entspawnscript.InitOldWeaponSpawnScript()

            entspawnscript.SetSpawns(spawnPoints)
            entspawnscript.SetSettings(settings)
        end

        if entspawnscript.SpawnFileExists() then
            entspawnscript.SetSpawns(entspawnscript.ReadSpawnFile())
        end

        if entspawnscript.SettingsFileExists() then
            entspawnscript.SetSettings(entspawnscript.ReadSettingsFile())
        end

        -- Most of the time this set up is done before the player is ready. However to make sure the update
        -- is called at least once after the data is generated, it is also called here.

        -- trigger a sync of the settings table
        entspawnscript.UpdateSettingsOnClients()

        -- trigger a sync of the spawn amount info
        entspawnscript.UpdateSpawnCountOnClients()
    end

    ---
    -- Saves the current map state as default map state in memory only
    -- @realm server
    function entspawnscript.SaveMapStateAsDefault()
        entspawnscript.defaultSpawnTable = {
            [SPAWN_TYPE_WEAPON] = map.GetWeaponSpawns(),
            [SPAWN_TYPE_AMMO] = map.GetAmmoSpawns(),
            [SPAWN_TYPE_PLAYER] = map.GetPlayerSpawns(),
        }
    end

    ---
    -- Initializes the map and generates all spawn points from the old weaponspawnscripts. This does
    -- not save those values automatically, but returns the data to be saved.
    -- @note Called on first load of a map if there is no existing spawn file.
    -- @warning This can break the weapon spawn files if called at any time after the initial spawn wave.
    -- @return table A table with the default spawn points provided by the map
    -- @return table A table with the default settings provided by the map
    -- @realm server
    function entspawnscript.InitOldWeaponSpawnScript()
        local mapName = gameGetMap()
        local spawnTable = tableCopy(entspawnscript.defaultSpawnTable)
        local settingsTable = tableCopy(defaultSettings)

        -- check if there is a deprecated ttt weapon spawn script and convert the data to
        -- the new ttt2 system as well
        if ents.TTT.CanImportEntities(mapName) then
            local spawns, settings = ents.TTT.ImportEntities(mapName)
            local importSpawnTable = map.GetSpawnsFromClassTable(spawns)

            if settings.replacespawns == 1 then
                spawnTable = importSpawnTable
            else
                -- add new spawns to existing table
                for spawnType, typeTable in pairs(importSpawnTable) do
                    for entType, addSpawns in pairs(typeTable) do
                        spawnTable[spawnType][entType] = spawnTable[spawnType][entType] or {}

                        tableAdd(spawnTable[spawnType][entType], addSpawns)
                    end
                end
            end
        end

        return spawnTable, settingsTable
    end

    ---
    -- Updates the spawn file. Used to save changes done in the spawn editor.
    -- @realm server
    function entspawnscript.UpdateSpawnFile()
        local spawnPoints = entspawnscript.GetSpawns()
        local jsonSaveTable = {}

        for spawnType, spawnTypeName in pairs(spawnTypeNameKeys) do
            jsonSaveTable[spawnTypeName] = {}

            for entType, spawns in pairs(spawnPoints[spawnType]) do
                local entTypeName = entspawnscript.GetVarNameFromSpawnType(spawnType, entType)

                jsonSaveTable[spawnTypeName][entTypeName] = spawns
            end
        end

        entspawnscript.WriteFile(spawndir, jsonSaveTable)
    end

    ---
    -- Updates the settings file if some map settings were changed on the server.
    -- @realm server
    function entspawnscript.UpdateSettingsFile()
        entspawnscript.WriteFile(settingsdir, entspawnscript.GetSettings())
    end

    ---
    -- Reads the spawn point file on the server. Returns a table with the read data.
    -- @note Make sure the file exists first.
    -- @return table The spawn point table
    -- @realm server
    function entspawnscript.ReadSpawnFile()
        local jsonSaveTable = entspawnscript.ReadFile(spawndir)
        local spawnPoints = {}

        for spawnType, spawnTypeName in pairs(spawnTypeNameKeys) do
            spawnPoints[spawnType] = {}

            for entTypeName, spawns in pairs(jsonSaveTable[spawnTypeName]) do
                spawnPoints[spawnType][_G[entTypeName]] = spawns
            end
        end

        return spawnPoints
    end

    ---
    -- Reads the settings file on the server. Returns a table with the read data.
    -- @note Make sure the file exists first.
    -- @return table The settings table
    -- @realm server
    function entspawnscript.ReadSettingsFile()
        return entspawnscript.ReadFile(settingsdir)
    end

    ---
    -- Removes the spawn file from the spawn file directory.
    -- @realm server
    function entspawnscript.RemoveSpawnFile()
        entspawnscript.RemoveFile(spawndir)
    end

    ---
    -- Removes the settings file from the settings file directory
    -- @realm server
    function entspawnscript.RemoveSettingsFile()
        entspawnscript.RemoveFile(settingsdir)
    end

    ---
    -- Checks whether a spawn file for the current map exists.
    -- @return boolean Returns true if a spawn file exists
    -- @realm server
    function entspawnscript.SpawnFileExists()
        return entspawnscript.Exists(spawndir)
    end

    ---
    -- Checks whether a settings file for the current map exists.
    -- @return boolean Returns true if a settings file exists
    -- @realm server
    function entspawnscript.SettingsFileExists()
        return entspawnscript.Exists(settingsdir)
    end

    ---
    -- Checks wether a file for the currently selected map exists.
    -- @param string dir The directory where the file is expected
    -- @return boolean Returns true if the spawnn script already exists
    -- @realm server
    function entspawnscript.Exists(dir)
        local fullDir = dir .. gameGetMap() .. ".json"
        return fileExists(fullDir, "DATA") or fileExists("data_static/" .. fullDir, "GAME")
    end

    ---
    -- Writes the spawn script data to the disc. Is used for the initial file, the default data
    -- and to save changes done to the spawn data.
    -- @note If the directory does not already exist, it is automatically created.
    -- @param string dir The directory where the file is expected
    -- @param table dataTable The table with the data that should be stored
    -- @internal
    -- @realm server
    function entspawnscript.WriteFile(dir, dataTable)
        fileCreateDir(dir)

        fileWrite(dir .. gameGetMap() .. ".json", utilTableToJSON(dataTable, true))
    end

    ---
    -- Reads the spawn file and returns the read data.
    -- @param string dir The directory where the file is expected
    -- @return table The table with the data read from the file
    -- @internal
    -- @realm server
    function entspawnscript.ReadFile(dir)
        local fullDir = dir .. gameGetMap() .. ".json"
        if fileExists(fullDir, "DATA") then
            return utilJSONToTable(fileRead(fullDir, "DATA"))
        else
            return utilJSONToTable(fileRead("data_static/" .. fullDir, "GAME"))
        end
    end

    ---
    -- Removes the spawn file of the current map and returns if it existed
    -- @param string dir The directory where the file is expected
    -- @return boolean if the file existed and was therefore successfully deleted
    -- @internal
    -- @realm server
    function entspawnscript.RemoveFile(dir)
        local fileExisted = entspawnscript.Exists(dir)

        if fileExisted then
            fileDelete(dir .. gameGetMap() .. ".json", "DATA")
        end

        return fileExisted
    end

    ---
    -- Returns the table of all currently defined settings.
    -- @return table The settings table
    -- @realm server
    function entspawnscript.GetSettings()
        return settingsList
    end

    ---
    -- Returns a specific setting defined by the key.
    -- @param string key The key of the requested setting
    -- @return[default=0] number The setting value
    -- @realm server
    function entspawnscript.GetSetting(key)
        return settingsList[key] or 0
    end

    ---
    -- Sets the whole settings table to the provided table
    -- @param table settings The new settings table
    -- @realm server
    function entspawnscript.SetSettings(settings)
        settingsList = settings
    end

    ---
    -- Proxy function to directly set the `blacklisted` setting to disable custom spawns
    -- for the currently loaded map.
    -- @param boolean Set to true if custom spawns should be used
    -- @realm server
    function entspawnscript.SetUseCustomSpawns(state)
        entspawnscript.SetSetting("blacklisted", not state, false)
    end

    ---
    -- Returns if the currently selected map should use custom spawns. Takes the map specific
    -- setting `blacklisted` and the convar `ttt_use_weapon_spawn_scripts` into consideration.
    -- @return boolean Returns true if custom spawns should be used for the map
    -- @realm server
    function entspawnscript.ShouldUseCustomSpawns()
        return not tobool(entspawnscript.GetSetting("blacklisted"))
            and cvUseWeaponSpawnScript:GetBool()
    end

    ---
    -- Sets the player editing state and syncs it to the client. Also, when setting the state to true,
    -- the current spawn types are synced to the client.
    -- @param Player ply The playser whose state should be changed
    -- @param boolean state The new editing state
    -- @realm server
    function entspawnscript.SetEditing(ply, state)
        ply:SetNWBool("is_spawn_editing", state)

        local playerIndex = nil

        for i = 1, #entspawnscript.editingPlayers do
            if entspawnscript.editingPlayers[i] ~= ply then
                continue
            end

            playerIndex = i

            break
        end

        if state then
            if not playerIndex then
                entspawnscript.editingPlayers[#entspawnscript.editingPlayers + 1] = ply
            end

            net.SendStream("TTT2_WeaponSpawnEntities", entspawnscript.GetSpawns(), ply)
        elseif playerIndex then
            tableRemove(entspawnscript.editingPlayers, playerIndex)
        end
    end

    ---
    -- Returns a list of all players that currently are in the spawn editing mode.
    -- @return table Returns an indexed table of all players currently editing the spawn points
    -- @realm server
    function entspawnscript.GetEditingPlayers()
        return entspawnscript.editingPlayers
    end

    ---
    -- Gets a list of all players that should receive a spawn point update. These are all
    -- editing players besides the player that made the change.
    -- @param Player ply The player that made the change
    -- @return table An indexed list with all receiving players
    -- @realm server
    function entspawnscript.GetReceivingPlayers(ply)
        local recPlys = {}

        for i = 1, #entspawnscript.editingPlayers do
            local editPly = entspawnscript.editingPlayers[i]

            if editPly == ply then
                continue
            end

            recPlys[#recPlys + 1] = editPly
        end

        return recPlys
    end

    ---
    -- Updates the map settings for the provided players. If no player table is
    -- provided, the update is done on all clients.
    -- @param table plys A table of players that should be updated
    -- @realm server
    function entspawnscript.UpdateSettingsOnClients(plys)
        plys = plys or playerGetAll()
        for i = 1, #plys do
            local ply = plys[i]

            if not admin.IsAdmin(ply) then
                continue
            end

            for key, value in pairs(entspawnscript.GetSettings()) do
                ttt2net.Set(
                    { "entspawnscript", "settings", key },
                    { type = "int", bits = 16 },
                    entspawnscript.GetSetting(key),
                    ply
                )
            end
        end
    end

    ---
    -- Updates the amount of spawns for the provided players. If no player table is
    -- provided, the update is done on all clients.
    -- @param table plys A table of players that should be updated
    -- @realm server
    function entspawnscript.UpdateSpawnCountOnClients(plys)
        local amountSpawns = {
            [SPAWN_TYPE_WEAPON] = 0,
            [SPAWN_TYPE_AMMO] = 0,
            [SPAWN_TYPE_PLAYER] = 0,
        }

        local spawnList = entspawnscript.GetSpawns()

        for spawnType, spawnTables in pairs(spawnList) do
            for entType, spawns in pairs(spawnTables) do
                amountSpawns[spawnType] = amountSpawns[spawnType] + #spawns
            end
        end

        plys = plys or playerGetAll()
        for i = 1, #plys do
            local ply = plys[i]

            if not admin.IsAdmin(ply) then
                continue
            end

            ttt2net.Set(
                { "entspawnscript", "spawnamount", "weapon" },
                { type = "int", bits = 16 },
                amountSpawns[SPAWN_TYPE_WEAPON],
                ply
            )
            ttt2net.Set(
                { "entspawnscript", "spawnamount", "ammo" },
                { type = "int", bits = 16 },
                amountSpawns[SPAWN_TYPE_AMMO],
                ply
            )
            ttt2net.Set(
                { "entspawnscript", "spawnamount", "player" },
                { type = "int", bits = 16 },
                amountSpawns[SPAWN_TYPE_PLAYER],
                ply
            )

            ttt2net.Set(
                { "entspawnscript", "spawnamount", "weaponrandom" },
                { type = "int", bits = 16 },
                #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_RANDOM] or {}),
                ply
            )
            ttt2net.Set(
                { "entspawnscript", "spawnamount", "weaponmelee" },
                { type = "int", bits = 16 },
                #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_MELEE] or {}),
                ply
            )
            ttt2net.Set(
                { "entspawnscript", "spawnamount", "weaponnade" },
                { type = "int", bits = 16 },
                #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_NADE] or {}),
                ply
            )
            ttt2net.Set(
                { "entspawnscript", "spawnamount", "weaponshotgun" },
                { type = "int", bits = 16 },
                #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_SHOTGUN] or {}),
                ply
            )
            ttt2net.Set(
                { "entspawnscript", "spawnamount", "weaponheavy" },
                { type = "int", bits = 16 },
                #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_HEAVY] or {}),
                ply
            )
            ttt2net.Set(
                { "entspawnscript", "spawnamount", "weaponsniper" },
                { type = "int", bits = 16 },
                #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_SNIPER] or {}),
                ply
            )
            ttt2net.Set(
                { "entspawnscript", "spawnamount", "weaponpistol" },
                { type = "int", bits = 16 },
                #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_PISTOL] or {}),
                ply
            )
            ttt2net.Set(
                { "entspawnscript", "spawnamount", "weaponspecial" },
                { type = "int", bits = 16 },
                #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_SPECIAL] or {}),
                ply
            )

            ttt2net.Set(
                { "entspawnscript", "spawnamount", "ammorandom" },
                { type = "int", bits = 16 },
                #(spawnList[SPAWN_TYPE_AMMO][AMMO_TYPE_RANDOM] or {}),
                ply
            )
            ttt2net.Set(
                { "entspawnscript", "spawnamount", "ammodeagle" },
                { type = "int", bits = 16 },
                #(spawnList[SPAWN_TYPE_AMMO][AMMO_TYPE_DEAGLE] or {}),
                ply
            )
            ttt2net.Set(
                { "entspawnscript", "spawnamount", "ammopistol" },
                { type = "int", bits = 16 },
                #(spawnList[SPAWN_TYPE_AMMO][AMMO_TYPE_PISTOL] or {}),
                ply
            )
            ttt2net.Set(
                { "entspawnscript", "spawnamount", "ammomac10" },
                { type = "int", bits = 16 },
                #(spawnList[SPAWN_TYPE_AMMO][AMMO_TYPE_MAC10] or {}),
                ply
            )
            ttt2net.Set(
                { "entspawnscript", "spawnamount", "ammorifle" },
                { type = "int", bits = 16 },
                #(spawnList[SPAWN_TYPE_AMMO][AMMO_TYPE_RIFLE] or {}),
                ply
            )
            ttt2net.Set(
                { "entspawnscript", "spawnamount", "ammoshotgun" },
                { type = "int", bits = 16 },
                #(spawnList[SPAWN_TYPE_AMMO][AMMO_TYPE_SHOTGUN] or {}),
                ply
            )

            ttt2net.Set(
                { "entspawnscript", "spawnamount", "playerrandom" },
                { type = "int", bits = 16 },
                #(spawnList[SPAWN_TYPE_PLAYER][PLAYER_TYPE_RANDOM] or {}),
                ply
            )
        end
    end

    ---
    -- Transmits the settings and the spawn point amount to the provided player.
    -- This function is called in @{GM:TTT2PlayerReady}.
    -- @param Player ply The player who should receive the update
    -- @realm server
    function entspawnscript.TransmitToPlayer(ply)
        -- trigger a sync of the settings table
        entspawnscript.UpdateSettingsOnClients({ ply })

        -- trigger a sync of the spawn amount info
        entspawnscript.UpdateSpawnCountOnClients({ ply })
    end

    ---
    -- Reloads the spawn points from either the spawn files or from the defaults. Is mostly used after
    -- switching from classic TTT weapon spawns to dynamic TTT2 weapons spawns.
    -- @realm server
    function entspawnscript.ReloadSpawns()
        -- if switched back to custom spawn loading, we want to load again the spawn file to restore the spawn points
        if entspawnscript.SpawnFileExists() then
            entspawnscript.SetSpawns(entspawnscript.ReadSpawnFile())
        else
            -- if the map was never changed, check if there is an old spawn script and convert it to the new system
            local spawnPoints = entspawnscript.InitOldWeaponSpawnScript()

            entspawnscript.SetSpawns(spawnPoints)
        end
    end

    cvars.AddChangeCallback(cvUseWeaponSpawnScript:GetName(), function(_, _, new)
        if tobool(new) then
            entspawnscript.ReloadSpawns()
        end
    end)
end

if CLIENT then
    local focusedSpawn = nil
    local spawnInfoEnt = nil

    ---
    -- Sets the focused spawn point to be used elsewhere (like in targetID).
    -- @param number spawnType The type of the spawn, set to nil to reset
    -- @param number entType The specific entity type for the specific spawn type
    -- @param number id The unique ID of the spawn point
    -- @param table spawn The spawn point data table
    -- @realm client
    function entspawnscript.SetFocusedSpawn(spawnType, entType, id, spawn)
        if not spawnType then
            focusedSpawn = nil
        else
            focusedSpawn = {
                spawnType = spawnType,
                entType = entType,
                id = id,
                spawn = spawn,
            }
        end
    end

    ---
    -- Returns the table with the focused spawn data.
    -- @return table Returns the focused spawn data table
    -- @realm client
    function entspawnscript.GetFocusedSpawn()
        return focusedSpawn
    end

    ---
    -- Sets the spawn info entity that is used for all spawn points in targetID.
    -- @param Entity ent The spawn info entity
    -- @realm client
    function entspawnscript.SetSpawnInfoEntity(ent)
        spawnInfoEnt = ent
    end

    ---
    -- Returns the spawn info entity that is used for all spawn points in targetID.
    -- @return Entity Returns the spawn info entity
    -- @realm client
    function entspawnscript.GetSpawnInfoEntity()
        return spawnInfoEnt
    end

    ---
    -- Clears the local spawn point table cache.
    -- @realm client
    function entspawnscript.ClearLocalCache()
        entspawnscript.SetSpawns(entspawnscript.GetEmptySpawnTableStructure())
    end
end

---
-- Sets the spawn point list.
-- @param table spawnPoints The new spawnPoints table
-- @realm server
function entspawnscript.SetSpawns(spawnPoints)
    spawnPointList = spawnPoints
end

---
-- Updates a map specific setting. If called on the client, it will be automatically
-- networked to the server. It then is stored on the server and updated on all connected
-- clients.
-- @param string key The key where the setting will be stored
-- @param number|boolean value The value of the setting
-- @param[default=false] boolean omitSaving If set to true, the setting will not be saved
-- @realm shared
function entspawnscript.SetSetting(key, value, omitSaving)
    omitSaving = omitSaving or false

    if isbool(value) then
        value = value and 1 or 0
    end

    if not isnumber(value) then
        ErrorNoHaltWithStack("WARNING: Only number and boolean values for map settings allowed.")

        return
    end

    if SERVER then
        -- only continue if the value has changed
        if settingsList[key] == value then
            return
        end

        settingsList[key] = value

        if not omitSaving then
            entspawnscript.UpdateSettingsFile()
        end

        -- trigger an update of the synced settings table
        entspawnscript.UpdateSettingsOnClients()

        -- special handling for some settings
        if key == "blacklisted" and value == 0 then
            entspawnscript.ReloadSpawns()
        end
    else -- CLIENT
        net.Start("ttt2_entspawn_setting_update")
        net.WriteString(key)
        net.WriteInt(value, 16)
        net.WriteBool(omitSaving)
        net.SendToServer()
    end
end

---
-- Checks wether a given player is currently editing spawn points.
-- @param Player ply The player who might be editing
-- @return boolean Returns true if the player is editing
-- @realm shared
function entspawnscript.IsEditing(ply)
    return ply:GetNWBool("is_spawn_editing", false)
end

---
-- Returns an indexed table of all available spawn types.
-- @return table An indexed table of all spawn types
-- @realm shared
function entspawnscript.GetSpawnTypes()
    return spawnTypes
end

---
-- Returns the language identifier for a specific spawnType/entType combination.
-- @param number spawnType The type of the spawn
-- @param number entType The specific entity type for the specific spawn type
-- @return string Returns the language identifier
-- @realm shared
function entspawnscript.GetLangIdentifierFromSpawnType(spawnType, entType)
    return spawnData[spawnType][entType].name or "undefined_lang_identifier"
end

---
-- Returns the storage var name for a specific spawnType/entType combination.
-- @param number spawnType The type of the spawn
-- @param number entType The specific entity type for the specific spawn type
-- @return string Returns the storage variable name
-- @realm shared
function entspawnscript.GetVarNameFromSpawnType(spawnType, entType)
    return spawnData[spawnType][entType].var or "UNDEFINED"
end

---
-- Returns the color for a specific spawnType.
-- @param number spawnType The type of the spawn
-- @return[default=COLOR_WHITE] Color Returns the color for the spawn type
-- @realm shared
function entspawnscript.GetColorFromSpawnType(spawnType)
    return spawnColors[spawnType] or COLOR_WHITE
end

---
-- Returns the icon material for a specific spawnType/entType combination.
-- @param number spawnType The type of the spawn
-- @param number entType The specific entity type for the specific spawn type
-- @return Material Returns the icon material
-- @realm shared
function entspawnscript.GetIconFromSpawnType(spawnType, entType)
    return spawnData[spawnType][entType].material
end

---
-- Returns a list of entity types for a given spawn type. Can exclude some
-- predefined entity types.
-- @param number spawnType The specidic spawn type
-- @param table excludeTypes A key-boolean table with the excluded types
-- @return table Returns an indexed table with the available entity Types
-- @realm shared
function entspawnscript.GetEntTypeList(spawnType, excludeTypes)
    local indexedTable = {}

    local spawns = spawnData[spawnType]

    for entType in pairs(spawns) do
        if excludeTypes[entType] then
            continue
        end

        indexedTable[#indexedTable + 1] = entType
    end

    return indexedTable
end

---
-- Returns a indexed table with all available spawn type / entity type combinations.
-- @return table An indexed table with all available spawn type / entity type combinations
-- @realm shared
function entspawnscript.GetSpawnTypeList()
    local indexedTable = {}

    for spawnType, spawns in pairs(spawnData) do
        for entType in pairs(spawns) do
            indexedTable[#indexedTable + 1] = {
                spawnType = spawnType,
                entType = entType,
            }
        end
    end

    return indexedTable
end

---
-- A compatibility feature for the weapon spawn type definition via the
-- weapon kind. Is used as a default value if undefined.
-- @param number kind The weapon kind
-- @return number The weapon spawn type assosiated with a weapon kind
-- @realm shared
function entspawnscript.GetSpawnTypeFromKind(kind)
    return kindToSpawnType[kind]
end

---
-- Returns a table sorted by spawn types and ent types with indexed tables as sub tables with
-- all spawn points defined on the map.
-- @return table A table with all spawns
-- @realm shared
function entspawnscript.GetSpawns()
    return spawnPointList
end

---
-- Returns a table sorted by end types with indexed tables as sub tables with
-- all spawn points defined on the map.
-- @param number spawnType The spawn type
-- @return table A table with all spawns
-- @realm shared
function entspawnscript.GetSpawnsForSpawnType(spawnType)
    return spawnPointList[spawnType]
end

---
-- Removes a specific spawn point from the spawn table. If enabled,
-- it is automatically synced to the server / client.
-- @note Changes are not automatically written to disk. This is done once the spawn edit is done. Use
-- {entspawnscript.UpdateSpawnFile} to trigger it manually.
-- @param number spawnType The spawn type of the spawn that should be removed
-- @param number entType The entity type of the spawn that should be removed
-- @param number id The numeric id of the spawn that should be removed
-- @param boolean shouldSync Set to true if it should be synced, set to false if it shouldn't
-- @param Player ply The player that attempts to delete the spawn. Only relevant if synced from
-- the server to the client for net performance reasons
-- @realm shared
function entspawnscript.RemoveSpawnById(spawnType, entType, id, shouldSync, ply)
    local spawnPoints = entspawnscript.GetSpawns()

    if not spawnPoints or not spawnPoints[spawnType] or not spawnPoints[spawnType][entType] then
        return
    end

    local list = spawnPoints[spawnType][entType]

    tableRemove(list, id)

    if SERVER then
        -- update amount of spawns on clients
        entspawnscript.UpdateSpawnCountOnClients()
    end

    if not shouldSync then
        return
    end

    net.Start("ttt2_remove_spawn_ent")
    net.WriteUInt(spawnType, 4)
    net.WriteUInt(entType, 4)
    net.WriteUInt(id, 32)

    if SERVER then
        net.Send(entspawnscript.GetReceivingPlayers(ply))
    else -- CLIENT
        net.SendToServer()
    end
end

---
-- Adds a new spawn point to the spawn type table. If enabled,
-- it is automatically synced to the server / client.
-- @note Changes are not automatically written to disk. This is done once the spawn edit is done. Use
-- {entspawnscript.UpdateSpawnFile} to trigger it manually.
-- @param number spawnType The spawn type of the spawn that should be added
-- @param number entType The entity type of the spawn that should be added
-- @param Vector pos The position vector of the spawn that should be added
-- @param Angle ang The angle of the spawn that should be added
-- @param[default=0] number ammo The amount of ammo of the spawn that should be added,
-- only relevant to weapon spawns
-- @param boolean shouldSync Set to true if it should be synced, set to false if it shouldn't
-- @param Player ply The player that attempts to add the spawn. Only relevant if synced from
-- the server to the client for net performance reasons
-- @realm shared
function entspawnscript.AddSpawn(spawnType, entType, pos, ang, ammo, shouldSync, ply)
    local spawnPoints = entspawnscript.GetSpawns()

    ammo = ammo or 0

    spawnPoints = spawnPoints or {}
    spawnPoints[spawnType] = spawnPoints[spawnType] or {}
    spawnPoints[spawnType][entType] = spawnPoints[spawnType][entType] or {}

    local list = spawnPoints[spawnType][entType]

    list[#list + 1] = {
        pos = pos,
        ang = ang,
        ammo = ammo,
    }

    if SERVER then
        -- update amount of spawns on clients
        entspawnscript.UpdateSpawnCountOnClients()
    end

    if not shouldSync then
        return
    end

    net.Start("ttt2_add_spawn_ent")
    net.WriteUInt(spawnType, 4)
    net.WriteUInt(entType, 4)
    net.WriteVector(pos)
    net.WriteAngle(ang)
    net.WriteUInt(ammo, 8)

    if SERVER then
        net.Send(entspawnscript.GetReceivingPlayers(ply))
    else -- CLIENT
        net.SendToServer()
    end
end

---
-- Updates an existing spawn point in the spawn point table. Does nothing if the
-- spawn point does not exist. If enabled, it is automatically synced to the server / client.
-- @note Changes are not automatically written to disk. This is done once the spawn edit is done. Use
-- {entspawnscript.UpdateSpawnFile} to trigger it manually.
-- @param number spawnType The spawn type of the spawn that should be updated
-- @param number entType The entity type of the spawn that should be updated
-- @param number id The numeric id of the spawn that should be removed
-- @param Vector pos The position vector of the spawn that should be updated
-- @param Angle ang The angle of the spawn that should be updated
-- @param[default=0] number ammo The amount of ammo of the spawn that should be updated,
-- only relevant to weapon spawns
-- @param boolean shouldSync Set to true if it should be synced, set to false if it shouldn't
-- @param Player ply The player that attempts to add the spawn. Only relevant if synced from
-- the server to the client for net performance reasons
-- @realm shared
function entspawnscript.UpdateSpawn(spawnType, entType, id, pos, ang, ammo, shouldSync, ply)
    local spawnPoints = entspawnscript.GetSpawns()

    if not spawnPoints or not spawnPoints[spawnType] or not spawnPoints[spawnType][entType] then
        return
    end

    local listEntry = spawnPoints[spawnType][entType]

    if not listEntry[id] then
        return
    end

    pos = pos or listEntry[id].pos
    ang = ang or listEntry[id].ang
    ammo = ammo or listEntry[id].ammo

    listEntry[id] = {
        pos = pos,
        ang = ang,
        ammo = ammo,
    }

    if not shouldSync then
        return
    end

    net.Start("ttt2_update_spawn_ent")
    net.WriteUInt(spawnType, 4)
    net.WriteUInt(entType, 4)
    net.WriteUInt(id, 32)
    net.WriteVector(pos)
    net.WriteAngle(ang)
    net.WriteUInt(ammo, 8)

    if SERVER then
        net.Send(entspawnscript.GetReceivingPlayers(ply))
    else -- CLIENT
        net.SendToServer()
    end
end

---
-- Deletes all spawn points on the map. Automatically syncs between client and server.
-- @note Deleting all spawns does update the weapon spawn file immediately. Be careful.
-- @realm shared
function entspawnscript.DeleteAllSpawns()
    if CLIENT then
        net.Start("ttt2_delete_all_spawns")
        net.SendToServer()
    else
        entspawnscript.SetSpawns(entspawnscript.GetEmptySpawnTableStructure())

        entspawnscript.UpdateSpawnFile()

        net.SendStream(
            "TTT2_WeaponSpawnEntities",
            entspawnscript.GetSpawns(),
            entspawnscript.editingPlayers
        )

        -- update amount of spawns on clients
        entspawnscript.UpdateSpawnCountOnClients()
    end
end

---
-- Called when a player starts the spawn editing mode. Sets everything up needed
-- for the spawn editing. Can be called on client or server, it is automatically synced.
-- @param Player ply The player that starts editing; only relevant on the server
-- @realm shared
function entspawnscript.StartEditing(ply)
    if CLIENT then
        net.Start("ttt2_toggle_entspawn_editing")
        net.WriteBool(true)
        net.SendToServer()
    else
        if entspawnscript.IsEditing(ply) then
            return
        end

        ply:CacheAndStripWeapons(true)
        ply:CacheAndStripItems()

        timer.Simple(0, function()
            if not IsValid(ply) then
                return
            end

            local wep = ply:Give("weapon_ttt_spawneditor")

            wep:Equip()

            entspawnscript.SetEditing(ply, true)
        end)
    end
end

---
-- Called when a player stops the spawn editing mode. Resets everything changed by the
-- spawn editing. Can be called on client or server, it is automatically synced.
-- @param Player ply The player that stops editing; only relevant on the server
-- @realm shared
function entspawnscript.StopEditing(ply)
    if CLIENT then
        net.Start("ttt2_toggle_entspawn_editing")
        net.WriteBool(false)
        net.SendToServer()
    else
        if not entspawnscript.IsEditing(ply) then
            return
        end

        ply:RestoreCachedWeapons()
        ply:RestoreCachedItems()
        ply:StripWeapon("weapon_ttt_spawneditor")

        entspawnscript.SetEditing(ply, false)
    end
end

---
-- Call to reset the map to its default state.
-- Can be called on the server and the client as it is automatically synced.
-- @note default state includes old weapon scripts
-- @realm shared
function entspawnscript.ResetMapToDefault()
    if CLIENT then
        net.Start("ttt2_entspawn_reset")
        net.SendToServer()
    else
        -- delete the changed files
        entspawnscript.RemoveSpawnFile()
        entspawnscript.RemoveSettingsFile()

        -- load old weapon scripts and reset to default
        local spawnPoints, settings = entspawnscript.InitOldWeaponSpawnScript()

        entspawnscript.SetSpawns(spawnPoints)
        entspawnscript.SetSettings(settings)

        -- Most of the time this set up is done before the player is ready. However to make sure the update
        -- is called at least once after the data is generated, it is also called here.

        -- trigger a sync of the settings table
        entspawnscript.UpdateSettingsOnClients()

        -- trigger a sync of the spawn amount info
        entspawnscript.UpdateSpawnCountOnClients()
    end
end

---
-- Returns a copy of the general spawn table structure. This is used for initialization
-- of this table.
-- @return table An empty spawn table
-- @realm shared
function entspawnscript.GetEmptySpawnTableStructure()
    return tableCopy({
        [SPAWN_TYPE_WEAPON] = {},
        [SPAWN_TYPE_AMMO] = {},
        [SPAWN_TYPE_PLAYER] = {},
    })
end

-- SYNCING

if SERVER then
    util.AddNetworkString("ttt2_remove_spawn_ent")
    util.AddNetworkString("ttt2_add_spawn_ent")
    util.AddNetworkString("ttt2_update_spawn_ent")
    util.AddNetworkString("ttt2_delete_all_spawns")
    util.AddNetworkString("ttt2_toggle_entspawn_editing")
    util.AddNetworkString("ttt2_entspawn_reset")
    util.AddNetworkString("ttt2_entspawn_setting_update")

    net.Receive("ttt2_remove_spawn_ent", function(_, ply)
        if not admin.IsAdmin(ply) then
            return
        end

        entspawnscript.RemoveSpawnById(
            net.ReadUInt(4),
            net.ReadUInt(4),
            net.ReadUInt(32),
            false,
            ply
        )
    end)

    net.Receive("ttt2_add_spawn_ent", function(_, ply)
        if not admin.IsAdmin(ply) then
            return
        end

        entspawnscript.AddSpawn(
            net.ReadUInt(4),
            net.ReadUInt(4),
            net.ReadVector(),
            net.ReadAngle(),
            net.ReadUInt(8),
            false,
            ply
        )
    end)

    net.Receive("ttt2_update_spawn_ent", function(_, ply)
        if not admin.IsAdmin(ply) then
            return
        end

        entspawnscript.UpdateSpawn(
            net.ReadUInt(4),
            net.ReadUInt(4),
            net.ReadUInt(32),
            net.ReadVector(),
            net.ReadAngle(),
            net.ReadUInt(8),
            false,
            ply
        )
    end)

    net.Receive("ttt2_delete_all_spawns", function(_, ply)
        if not admin.IsAdmin(ply) then
            return
        end

        entspawnscript.DeleteAllSpawns()
    end)

    net.Receive("ttt2_entspawn_setting_update", function(_, ply)
        if not admin.IsAdmin(ply) then
            return
        end

        entspawnscript.SetSetting(net.ReadString(), net.ReadInt(16), net.ReadBool())
    end)

    net.Receive("ttt2_entspawn_reset", function(_, ply)
        if not admin.IsAdmin(ply) then
            return
        end

        entspawnscript.ResetMapToDefault()
    end)

    net.Receive("ttt2_toggle_entspawn_editing", function(_, ply)
        if not admin.IsAdmin(ply) then
            return
        end

        if net.ReadBool() then
            entspawnscript.StartEditing(ply)
        else
            entspawnscript.StopEditing(ply)
        end
    end)
end

if CLIENT then
    net.ReceiveStream("TTT2_WeaponSpawnEntities", function(spawnPoints)
        entspawnscript.SetSpawns(spawnPoints)
    end)

    net.Receive("ttt2_remove_spawn_ent", function()
        entspawnscript.RemoveSpawnById(net.ReadUInt(4), net.ReadUInt(4), net.ReadUInt(32), false)
    end)

    net.Receive("ttt2_add_spawn_ent", function()
        entspawnscript.AddSpawn(
            net.ReadUInt(4),
            net.ReadUInt(4),
            net.ReadVector(),
            net.ReadAngle(),
            net.ReadUInt(8),
            false
        )
    end)

    net.Receive("ttt2_update_spawn_ent", function()
        entspawnscript.UpdateSpawn(
            net.ReadUInt(4),
            net.ReadUInt(4),
            net.ReadUInt(32),
            net.ReadVector(),
            net.ReadAngle(),
            net.ReadUInt(8),
            false
        )
    end)
end
