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
local stringExplode = string.Explode
local gameGetMap = game.GetMap
local stringFormat = string.format
local stringMatch = string.match
local stringByte = string.byte
local pairs = pairs
local unpack = unpack
local tableRemove = table.remove
local tableAdd = table.Add
local osDate = os.date
local osTime = os.time

local spawnEntList = {}
local settingsList = {}

local defaultSettings = {
	["blacklisted"] = 0
}

local spawndir = "ttt/weaponspawnscripts/"

local spawnColors = {
	[SPAWN_TYPE_WEAPON] = Color(0, 175, 175, 255),
	[SPAWN_TYPE_AMMO] = Color(175, 75, 75, 255),
	[SPAWN_TYPE_PLAYER] = Color(75, 175, 50, 255)
}

local spawnData = {
	[SPAWN_TYPE_WEAPON] = {
		[WEAPON_TYPE_RANDOM] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_random"),
			name = "spawn_weapon_random",
			var = "WEAPON_TYPE_RANDOM"
		},
		[WEAPON_TYPE_MELEE] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_melee"),
			name = "spawn_weapon_melee",
			var = "WEAPON_TYPE_MELEE"
		},
		[WEAPON_TYPE_NADE] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_nade"),
			name = "spawn_weapon_nade",
			var = "WEAPON_TYPE_NADE"
		},
		[WEAPON_TYPE_SHOTGUN] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_shotgun"),
			name = "spawn_weapon_shotgun",
			var = "WEAPON_TYPE_SHOTGUN"
		},
		[WEAPON_TYPE_HEAVY] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_assault"),
			name = "spawn_weapon_heavy",
			var = "WEAPON_TYPE_HEAVY"
		},
		[WEAPON_TYPE_SNIPER] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_sniper"),
			name = "spawn_weapon_sniper",
			var = "WEAPON_TYPE_SNIPER"
		},
		[WEAPON_TYPE_PISTOL] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_pistol"),
			name = "spawn_weapon_pistol",
			var = "WEAPON_TYPE_PISTOL"
		},
		[WEAPON_TYPE_SPECIAL] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_special"),
			name = "spawn_weapon_special",
			var = "WEAPON_TYPE_SPECIAL"
		}
	},
	[SPAWN_TYPE_AMMO] = {
		[AMMO_TYPE_RANDOM] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_random"),
			name = "ammo_type_random",
			var = "AMMO_TYPE_RANDOM"
		},
		[AMMO_TYPE_DEAGLE] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_random"),
			name = "ammo_type_deagle",
			var = "AMMO_TYPE_DEAGLE"
		},
		[AMMO_TYPE_PISTOL] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_random"),
			name = "ammo_type_pistol",
			var = "AMMO_TYPE_PISTOL"
		},
		[AMMO_TYPE_MAC10] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_random"),
			name = "ammo_type_mac10",
			var = "AMMO_TYPE_MAC10"
		},
		[AMMO_TYPE_RIFLE] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_random"),
			name = "ammo_type_rifle",
			var = "AMMO_TYPE_RIFLE"
		},
		[AMMO_TYPE_SHOTGUN] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_random"),
			name = "ammo_type_shotgun",
			var = "AMMO_TYPE_SHOTGUN"
		}
	},
	[SPAWN_TYPE_PLAYER] = {
		[PLAYER_TYPE_RANDOM] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_random"),
			name = "player_type_random",
			var = "PLAYER_TYPE_RANDOM"
		}
	}
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
entspawnscript.editingPlayers = entspawnscript.editingPlayers or {}

if SERVER then
	---
	-- @realm server
	local cvUseWeaponSpawnScript = CreateConVar("ttt_use_weapon_spawn_scripts", "1")

	function entspawnscript.Exists()
		return fileExists(spawndir .. gameGetMap() .. ".txt", "DATA")
	end

	function entspawnscript.InitMap()
		local mapName = gameGetMap()

		-- read the entities from the map at first
		local spawnTable = {
			[SPAWN_TYPE_WEAPON] = map.GetWeaponSpawns(),
			[SPAWN_TYPE_AMMO] = map.GetAmmoSpawns(),
			[SPAWN_TYPE_PLAYER] = map.GetPlayerSpawns()
		}

		-- now check if there is a deprectated ttt weapon spawn script and convert the data to
		-- the new ttt2 system as well
		if ents.TTT.CanImportEntities(mapName) then
			local spawns, settings = ents.TTT.ImportEntities(mapName)

			if settings.replacespawns == 1 then
				spawnTable = {
					[SPAWN_TYPE_WEAPON] = {},
					[SPAWN_TYPE_AMMO] = {},
					[SPAWN_TYPE_PLAYER] = {}
				}
			end

			local wepSpawns, ammoSpawns, plySpawns = map.GetSpawnsFromClassTable(spawns)

			-- add new spawns to existing table
			for entType, addSpawns in pairs(wepSpawns) do
				spawnTable[SPAWN_TYPE_WEAPON][entType] = spawnTable[SPAWN_TYPE_WEAPON][entType] or {}

				tableAdd(spawnTable[SPAWN_TYPE_WEAPON][entType], addSpawns)
			end

			for entType, addSpawns in pairs(ammoSpawns) do
				spawnTable[SPAWN_TYPE_AMMO][entType] = spawnTable[SPAWN_TYPE_AMMO][entType] or {}

				tableAdd(spawnTable[SPAWN_TYPE_AMMO][entType], addSpawns)
			end

			for entType, addSpawns in pairs(plySpawns) do
				spawnTable[SPAWN_TYPE_PLAYER][entType] = spawnTable[SPAWN_TYPE_PLAYER][entType] or {}

				tableAdd(spawnTable[SPAWN_TYPE_PLAYER][entType], addSpawns)
			end
		end

		entspawnscript.WriteFile(spawnTable, defaultSettings, spawndir .. mapName .. ".txt")
		entspawnscript.WriteFile(spawnTable, defaultSettings, spawndir .. mapName .. "_default.txt")

		return spawnTable, defaultSettings
	end

	function entspawnscript.UpdateSpawnFile()
		entspawnscript.WriteFile(spawnEntList, settingsList, spawndir .. gameGetMap() .. ".txt")
	end

	function entspawnscript.WriteFile(spawnTable, settingsTable, fileName)
		local weaponspawns = spawnTable[SPAWN_TYPE_WEAPON]
		local ammospawns = spawnTable[SPAWN_TYPE_AMMO]
		local playerspawns = spawnTable[SPAWN_TYPE_PLAYER]

		local content = ""

		fileCreateDir(spawndir)

		content = content .. "# Trouble in Terrorist Town 2 spawn entity placement file\n"
		content = content .. "# map: " .. gameGetMap() .. "\n"
		content = content .. "# date created: " .. osDate("%H:%M:%S - %d/%m/%Y" , osTime()) .. "\n"

		content = content .. "\n# -- SETTINGS --\n"

		for key, value in pairs(settingsTable) do
			content = content .. "setting:\t" .. key .. " " .. value .. "\n"
		end

		content = content .. "\n# -- SPAWNS --\n"

		content = content .. "\nSPAWN: SPAWN_TYPE_WEAPON\n"

		for entType, spawns in pairs(weaponspawns) do
			local name = entspawnscript.GetVarNameFromSpawnType(SPAWN_TYPE_WEAPON, entType)

			for i = 1, #spawns do
				local spawn = spawns[i]

				local pos = spawn.pos
				local ang = spawn.ang
				local ammo = spawn.ammo

				content = content .. stringFormat("TYPE: %s\tPOS: %012f|%012f|%012f\tANG: %010f|%010f|%010f\tAMMO: %d", name, pos.x, pos.y, pos.z, ang.p, ang.y, ang.r, ammo) .. "\n"
			end
		end

		content = content .. "\nSPAWN: SPAWN_TYPE_AMMO\n"

		for entType, spawns in pairs(ammospawns) do
			local name = entspawnscript.GetVarNameFromSpawnType(SPAWN_TYPE_AMMO, entType)

			for i = 1, #spawns do
				local spawn = spawns[i]

				local pos = spawn.pos
				local ang = spawn.ang

				content = content .. stringFormat("TYPE: %s\tPOS: %012f|%012f|%012f\tANG: %010f|%010f|%010f", name, pos.x, pos.y, pos.z, ang.p, ang.y, ang.r) .. "\n"
			end
		end

		content = content .. "\nSPAWN: SPAWN_TYPE_PLAYER\n"

		for entType, spawns in pairs(playerspawns) do
			local name = entspawnscript.GetVarNameFromSpawnType(SPAWN_TYPE_PLAYER, entType)

			for i = 1, #spawns do
				local spawn = spawns[i]

				local pos = spawn.pos
				local ang = spawn.ang

				content = content .. stringFormat("TYPE: %s\tPOS: %012f|%012f|%012f\tANG: %010f|%010f|%010f", name, pos.x, pos.y, pos.z, ang.p, ang.y, ang.r) .. "\n"
			end
		end

		fileWrite(fileName, content)
	end

	function entspawnscript.ReadFile(fileName)
		local lines = stringExplode("\n", fileRead(fileName, "DATA"))
		local spawnType = nil

		local spawnTable = {
			[SPAWN_TYPE_WEAPON] = {},
			[SPAWN_TYPE_AMMO] = {},
			[SPAWN_TYPE_PLAYER] = {}
		}
		local settingsTable = {}

		for i = 1, #lines do
			local line = lines[i]

			-- ignore comments or empty lines
			if stringMatch(line, "^#") or line == "" or stringByte(line) == 0 then continue end

			-- attempt to find settings in the file
			local key, val = stringMatch(line, "^setting:\t(%w*) ([0-9]*)")

			if key and val then
				settingsTable[key] = tonumber(val)

				continue
			end

			-- autodetect any spawn type change
			local newSpawnType = _G[stringMatch(line, "^SPAWN: ([%w_]*)")]

			spawnType = newSpawnType or spawnType

			if not spawnType or newSpawnType then continue end

			-- read spawns
			local stringEntType = stringMatch(line, "^TYPE: ([%w_]*)")
			local stringPos = stringMatch(line, "POS: ([%w.|%-]*)")
			local stringAng = stringMatch(line, "ANG: ([%w.|%-]*)")
			local stringAmmo = stringMatch(line, "AMMO: ([%w]*)")

			local entType = _G[stringEntType]

			if not isnumber(entType) then continue end

			spawnTable[spawnType][entType] = spawnTable[spawnType][entType] or {}

			spawnTable[spawnType][entType][#spawnTable[spawnType][entType] + 1] = {
				pos = Vector(unpack(stringExplode("|", stringPos))),
				ang = Angle(unpack(stringExplode("|", stringAng))),
				ammo = tonumber(stringAmmo or 0)
			}
		end

		return spawnTable, settingsTable
	end

	function entspawnscript.GetSettings()
		return settingsList
	end

	function entspawnscript.GetSetting(key)
		return settingsList[key] or 0
	end

	function entspawnscript.SetUseCustomSpawns(state)
		entspawnscript.SetSetting("blacklisted", not state, false)
	end

	function entspawnscript.ShouldUseCustomSpawns()
		return not tobool(entspawnscript.GetSetting("blacklisted")) and cvUseWeaponSpawnScript:GetBool()
	end

	function entspawnscript.SetSpawns(spawnEnts)
		spawnEntList = spawnEnts
	end

	function entspawnscript.SetEditing(ply, state)
		ply:SetNWBool("is_spawn_editing", state)

		if state then
			entspawnscript.editingPlayers[#entspawnscript.editingPlayers + 1] = ply

			net.SendStream("TTT2_WeaponSpawnEntities", spawnEntList, ply)
		else
			for i = 1, #entspawnscript.editingPlayers do
				if entspawnscript.editingPlayers[i] ~= ply then continue end

				tableRemove(entspawnscript.editingPlayers, i)

				break
			end
		end
	end

	function entspawnscript.GetEditingPlayers()
		return entspawnscript.editingPlayers
	end

	function entspawnscript.GetReceivingPlayers(ply)
		local recPlys = {}

		for i = 1, #entspawnscript.editingPlayers do
			local editPly = entspawnscript.editingPlayers[i]

			if editPly == ply then continue end

			recPlys[#recPlys + 1] = editPly
		end

		return recPlys
	end

	function entspawnscript.UpdateSettingsOnClients(plys)
		plys = plys or player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			if not ply:IsAdmin() then continue end

			for key, value in pairs(settingsList) do
				ttt2net.Set({"entspawnscript", "settings", key}, {type = "int", bits = 16}, entspawnscript.GetSetting(key), ply)
			end
		end
	end

	function entspawnscript.UpdateSpawnCountOnClients(plys)
		local amountSpawns = {
			[SPAWN_TYPE_WEAPON] = 0,
			[SPAWN_TYPE_AMMO] = 0,
			[SPAWN_TYPE_PLAYER] = 0
		}

		local spawnList = entspawnscript.GetSpawns()

		for spawnType, spawnTables in pairs(spawnList) do
			for entType, spawns in pairs(spawnTables) do
				amountSpawns[spawnType] = amountSpawns[spawnType] + #spawns
			end
		end

		plys = plys or player.GetAll()

		for i = 1, #plys do
			local ply = plys[i]

			if not ply:IsAdmin() then continue end

			ttt2net.Set({"entspawnscript", "spawnamount", "weapon"}, {type = "int", bits = 16}, amountSpawns[SPAWN_TYPE_WEAPON], ply)
			ttt2net.Set({"entspawnscript", "spawnamount", "ammo"}, {type = "int", bits = 16}, amountSpawns[SPAWN_TYPE_AMMO], ply)
			ttt2net.Set({"entspawnscript", "spawnamount", "player"}, {type = "int", bits = 16}, amountSpawns[SPAWN_TYPE_PLAYER], ply)

			ttt2net.Set({"entspawnscript", "spawnamount", "weaponrandom"}, {type = "int", bits = 16}, #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_RANDOM] or {}), ply)
			ttt2net.Set({"entspawnscript", "spawnamount", "weaponmelee"}, {type = "int", bits = 16}, #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_MELEE] or {}), ply)
			ttt2net.Set({"entspawnscript", "spawnamount", "weaponnade"}, {type = "int", bits = 16}, #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_NADE] or {}), ply)
			ttt2net.Set({"entspawnscript", "spawnamount", "weaponshotgun"}, {type = "int", bits = 16}, #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_SHOTGUN] or {}), ply)
			ttt2net.Set({"entspawnscript", "spawnamount", "weaponheavy"}, {type = "int", bits = 16}, #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_HEAVY] or {}), ply)
			ttt2net.Set({"entspawnscript", "spawnamount", "weaponsniper"}, {type = "int", bits = 16}, #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_SNIPER] or {}), ply)
			ttt2net.Set({"entspawnscript", "spawnamount", "weaponpistol"}, {type = "int", bits = 16}, #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_PISTOL] or {}), ply)
			ttt2net.Set({"entspawnscript", "spawnamount", "weaponspecial"}, {type = "int", bits = 16}, #(spawnList[SPAWN_TYPE_WEAPON][WEAPON_TYPE_SPECIAL] or {}), ply)

			ttt2net.Set({"entspawnscript", "spawnamount", "ammorandom"}, {type = "int", bits = 16}, #(spawnList[SPAWN_TYPE_AMMO][AMMO_TYPE_RANDOM] or {}), ply)
			ttt2net.Set({"entspawnscript", "spawnamount", "ammodeagle"}, {type = "int", bits = 16}, #(spawnList[SPAWN_TYPE_AMMO][AMMO_TYPE_DEAGLE] or {}), ply)
			ttt2net.Set({"entspawnscript", "spawnamount", "ammopistol"}, {type = "int", bits = 16}, #(spawnList[SPAWN_TYPE_AMMO][AMMO_TYPE_PISTOL] or {}), ply)
			ttt2net.Set({"entspawnscript", "spawnamount", "ammomac10"}, {type = "int", bits = 16}, #(spawnList[SPAWN_TYPE_AMMO][AMMO_TYPE_MAC10] or {}), ply)
			ttt2net.Set({"entspawnscript", "spawnamount", "ammorifle"}, {type = "int", bits = 16}, #(spawnList[SPAWN_TYPE_AMMO][AMMO_TYPE_RIFLE] or {}), ply)
			ttt2net.Set({"entspawnscript", "spawnamount", "ammoshotgun"}, {type = "int", bits = 16}, #(spawnList[SPAWN_TYPE_AMMO][AMMO_TYPE_SHOTGUN] or {}), ply)

			ttt2net.Set({"entspawnscript", "spawnamount", "playerrandom"}, {type = "int", bits = 16}, #(spawnList[SPAWN_TYPE_PLAYER][PLAYER_TYPE_RANDOM] or {}), ply)
		end
	end

	function entspawnscript.TransmitToPlayer(ply)
		-- trigger a sync of the settings table
		entspawnscript.UpdateSettingsOnClients({ply})

		-- trigger a sync of the spawn amount info
		entspawnscript.UpdateSpawnCountOnClients({ply})
	end
end

if CLIENT then
	local focusedSpawn = nil
	local spawnInfoEnt = nil

	function entspawnscript.SetFocusedSpawn(spawnType, entType, id, spawn)
		if not spawnType then
			focusedSpawn = nil
		else
			focusedSpawn = {
				spawnType = spawnType,
				entType = entType,
				id = id,
				spawn = spawn
			}
		end
	end

	function entspawnscript.GetFocusedSpawn()
		return focusedSpawn
	end

	function entspawnscript.SetSpawnInfoEntity(ent)
		spawnInfoEnt = ent
	end

	function entspawnscript.GetSpawnInfoEntity()
		return spawnInfoEnt
	end
end

function entspawnscript.SetSetting(key, value, omitSaving)
	if isbool(value) then
		value = value and 1 or 0
	end

	if not isnumber(value) then
		ErrorNoHalt("WARNING: Only number and boolean values for map settings allowed.")

		return
	end

	if SERVER then
		settingsList[key] = value

		if not omitSaving then
			local path = spawndir .. gameGetMap() .. ".txt"

			-- since we can only write the whole file, but we still want to keep the spawns untouched, we have to
			-- read those first to write them again. Depending on the spawn mode the cached spawns in this module
			-- might be completely different than those in the file. We do not want to overwrite them!
			local currentSpawns = entspawnscript.ReadFile(spawndir .. gameGetMap() .. ".txt")

			entspawnscript.WriteFile(currentSpawns, entspawnscript.GetSettings(), path)
		end

		-- trigger an update of the synced settings table
		entspawnscript.UpdateSettingsOnClients()

		-- special handling for some settings
		if key == "blacklisted" and value == 0 then
			-- if switched back to custom spawn loading, we want to load again the spawn file to restore the spawn points
			entspawnscript.SetSpawns(entspawnscript.ReadFile(spawndir .. gameGetMap() .. ".txt"))
		end
	else -- CLIENT
		net.Start("ttt2_entspawn_setting_update")
		net.WriteString(key)
		net.WriteInt(value, 16)
		net.WriteBool(omitSaving)
		net.SendToServer()
	end
end

function entspawnscript.IsEditing(ply)
	return ply:GetNWBool("is_spawn_editing", false)
end

function entspawnscript.GetLangIdentifierFromSpawnType(spawnType, entType)
	return spawnData[spawnType][entType].name
end

function entspawnscript.GetVarNameFromSpawnType(spawnType, entType)
	return spawnData[spawnType][entType].var
end

function entspawnscript.GetColorFromSpawnType(spawnType)
	return spawnColors[spawnType]
end

function entspawnscript.GetIconFromSpawnType(spawnType, entType)
	return spawnData[spawnType][entType].material
end

function entspawnscript.GetEntTypeList(spawnType, excludeTypes)
	local indexedTable = {}

	local spawns = spawnData[spawnType]

	for entType in pairs(spawns) do
		if excludeTypes[entType] then continue end

		indexedTable[#indexedTable + 1] = entType
	end

	return indexedTable
end

function entspawnscript.GetSpawnTypeList()
	local indexedTable = {}

	for spawnType, spawns in pairs(spawnData) do
		for entType in pairs(spawns) do
			indexedTable[#indexedTable + 1] = {
				spawnType = spawnType,
				entType = entType
			}
		end
	end

	return indexedTable
end

function entspawnscript.GetSpawnTypeFromKind(kind)
	return kindToSpawnType[kind]
end

function entspawnscript.GetSpawns()
	return spawnEntList
end

function entspawnscript.GetSpawnsForSpawnType(spawnType)
	return spawnEntList[spawnType]
end

function entspawnscript.RemoveSpawnById(spawnType, entType, id, shouldSync, ply)
	if not spawnEntList or not spawnEntList[spawnType] or not spawnEntList[spawnType][entType] then return end

	local list = spawnEntList[spawnType][entType]

	tableRemove(list, id)

	if SERVER then
		-- update amount of spawns on clients
		entspawnscript.UpdateSpawnCountOnClients()
	end

	if not shouldSync then return end

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

function entspawnscript.AddSpawn(spawnType, entType, pos, ang, ammo, shouldSync, ply)
	spawnEntList = spawnEntList or {}
	spawnEntList[spawnType] = spawnEntList[spawnType] or {}
	spawnEntList[spawnType][entType] = spawnEntList[spawnType][entType] or {}

	local list = spawnEntList[spawnType][entType]

	list[#list + 1] = {
		pos = pos,
		ang = ang,
		ammo = ammo
	}

	if SERVER then
		-- update amount of spawns on clients
		entspawnscript.UpdateSpawnCountOnClients()
	end

	if not shouldSync then return end

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

function entspawnscript.UpdateSpawn(spawnType, entType, id, pos, ang, ammo, shouldSync, ply)
	if not spawnEntList or not spawnEntList[spawnType] or not spawnEntList[spawnType][entType] then return end

	local listEntry = spawnEntList[spawnType][entType]

	if not listEntry[id] then return end

	pos = pos or listEntry[id].pos
	ang = ang or listEntry[id].ang
	ammo = ammo or listEntry[id].ammo

	listEntry[id] = {
		pos = pos,
		ang = ang,
		ammo = ammo
	}

	if not shouldSync then return end

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

function entspawnscript.DeleteAllSpawns()
	if CLIENT then
		net.Start("ttt2_delete_all_spawns")
		net.SendToServer()
	else
		entspawnscript.SetSpawns({
			[SPAWN_TYPE_WEAPON] = {},
			[SPAWN_TYPE_AMMO] = {},
			[SPAWN_TYPE_PLAYER] = {}
		})

		entspawnscript.WriteFile(spawnEntList, settingsList, spawndir .. gameGetMap() .. ".txt")

		net.SendStream("TTT2_WeaponSpawnEntities", spawnEntList, entspawnscript.editingPlayers)

		-- update amount of spawns on clients
		entspawnscript.UpdateSpawnCountOnClients()
	end
end

function entspawnscript.StartEditing(ply)
	if CLIENT then
		net.Start("ttt2_toggle_entspawn_editing")
		net.WriteBool(true)
		net.SendToServer()
	else
		if entspawnscript.IsEditing(ply) then return end

		ply:CacheAndStripWeapons()

		local wep = ply:Give("weapon_ttt_spawneditor")

		wep:Equip()

		entspawnscript.SetEditing(ply, true)
	end
end

function entspawnscript.StopEditing(ply)
	if CLIENT then
		net.Start("ttt2_toggle_entspawn_editing")
		net.WriteBool(false)
		net.SendToServer()
	else
		if not entspawnscript.IsEditing(ply) then return end

		ply:RestoreCachedWeapons()
		ply:StripWeapon("weapon_ttt_spawneditor")

		entspawnscript.SetEditing(ply, false)
	end
end

function entspawnscript.OnLoaded(forceReinit)
	if CLIENT then
		net.Start("ttt2_entspawn_init")
		net.WriteBool(forceReinit or false)
		net.SendToServer()
	else
		if not entspawnscript.Exists() then
			-- if the map should be initialized and was never loaded, the spawn files are created
			spawnEntList, settingsList = entspawnscript.InitMap()
		elseif forceReinit then
			-- if the map should be reinit, the spawns are loaded from the defaults file
			spawnEntList, settingsList = entspawnscript.ReadFile(spawndir .. gameGetMap() .. "_default.txt")

			-- also these spawns should be written to the file
			entspawnscript.WriteFile(spawnEntList, settingsList, spawndir .. gameGetMap() .. ".txt")
		else
			-- in normal usecases the spawns are loaded from the current spawn file
			spawnEntList, settingsList = entspawnscript.ReadFile(spawndir .. gameGetMap() .. ".txt")
		end

		-- Most of the time this set up is done before the player is ready. However to make sure the update
		-- is called at least once after the data is generated, it is also called here.

		-- trigger a sync of the settings table
		entspawnscript.UpdateSettingsOnClients()

		-- trigger a sync of the spawn amount info
		entspawnscript.UpdateSpawnCountOnClients()
	end
end

-- SYNCING

if SERVER then
	util.AddNetworkString("ttt2_remove_spawn_ent")
	util.AddNetworkString("ttt2_add_spawn_ent")
	util.AddNetworkString("ttt2_update_spawn_ent")
	util.AddNetworkString("ttt2_delete_all_spawns")
	util.AddNetworkString("ttt2_toggle_entspawn_editing")
	util.AddNetworkString("ttt2_entspawn_init")
	util.AddNetworkString("ttt2_entspawn_setting_update")

	net.Receive("ttt2_remove_spawn_ent", function(_, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		entspawnscript.RemoveSpawnById(net.ReadUInt(4), net.ReadUInt(4), net.ReadUInt(32), false, ply)
	end)

	net.Receive("ttt2_add_spawn_ent", function(_, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		entspawnscript.AddSpawn(net.ReadUInt(4), net.ReadUInt(4), net.ReadVector(), net.ReadAngle(), net.ReadUInt(8), false, ply)
	end)

	net.Receive("ttt2_update_spawn_ent", function(_, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		entspawnscript.UpdateSpawn(net.ReadUInt(4), net.ReadUInt(4), net.ReadUInt(32), net.ReadVector(), net.ReadAngle(), net.ReadUInt(8), false, ply)
	end)

	net.Receive("ttt2_delete_all_spawns", function(_, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		entspawnscript.DeleteAllSpawns()
	end)

	net.Receive("ttt2_entspawn_setting_update", function(_, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		entspawnscript.SetSetting(net.ReadString(), net.ReadInt(16), net.ReadBool())
	end)

	net.Receive("ttt2_entspawn_init", function(_, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		entspawnscript.OnLoaded(net.ReadBool())
	end)

	net.Receive("ttt2_toggle_entspawn_editing", function(_, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		if net.ReadBool() then
			entspawnscript.StartEditing(ply)
		else
			entspawnscript.StopEditing(ply)
		end
	end)
end

if CLIENT then
	net.ReceiveStream("TTT2_WeaponSpawnEntities", function(spawnEnts)
		spawnEntList = spawnEnts
	end)

	net.Receive("ttt2_remove_spawn_ent", function()
		entspawnscript.RemoveSpawnById(net.ReadUInt(4), net.ReadUInt(4), net.ReadUInt(32), false)
	end)

	net.Receive("ttt2_add_spawn_ent", function()
		entspawnscript.AddSpawn(net.ReadUInt(4), net.ReadUInt(4), net.ReadVector(), net.ReadAngle(), net.ReadUInt(8), false)
	end)

	net.Receive("ttt2_update_spawn_ent", function()
		entspawnscript.UpdateSpawn(net.ReadUInt(4), net.ReadUInt(4), net.ReadUInt(32), net.ReadVector(), net.ReadAngle(), net.ReadUInt(8), false)
	end)
end
