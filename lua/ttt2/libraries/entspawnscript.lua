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
local osDate = os.date
local osTime = os.time

local spawnEntList = {}

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
		[WEAPON_TYPE_ASSAULT] = {
			material = Material("vgui/ttt/tid/tid_big_weapon_assault"),
			name = "spawn_weapon_assault",
			var = "WEAPON_TYPE_ASSAULT"
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

entspawnscript = entspawnscript or {}

if SERVER then
	util.AddNetworkString("ttt2_remove_spawn_ent")
	util.AddNetworkString("ttt2_add_spawn_ent")
	util.AddNetworkString("ttt2_update_spawn_ent")
	util.AddNetworkString("ttt2_toggle_entspawn_editing")
	util.AddNetworkString("ttt2_entspawn_init")

	local spawndir = "ttt/weaponspawnscripts/"

	function entspawnscript.Exists()
		local mapname = gameGetMap()

		return fileExists(spawndir .. mapname .. ".txt", "DATA")
	end

	function entspawnscript.InitMap()
		local spawnTable = {
			[SPAWN_TYPE_WEAPON] = map.GetWeaponSpawns(),
			[SPAWN_TYPE_AMMO] = map.GetAmmoSpawns(),
			[SPAWN_TYPE_PLAYER] = {}
		}

		entspawnscript.WriteFile(spawnTable)

		return spawnTable
	end

	function entspawnscript.UpdateSpawnFile()
		entspawnscript.WriteFile(spawnEntList)
	end

	function entspawnscript.WriteFile(spawnTable)
		local weaponspawns = spawnTable[SPAWN_TYPE_WEAPON]
		local ammospawns = spawnTable[SPAWN_TYPE_AMMO]
		local playerspawns = spawnTable[SPAWN_TYPE_PLAYER]

		local content = ""
		local mapname = gameGetMap()

		fileCreateDir(spawndir)

		content = content .. "# Trouble in Terrorist Town 2 spawn entity placement file\n"
		content = content .. "# map: " .. mapname .. "\n"
		content = content .. "# date created: " .. osDate("%H:%M:%S - %d/%m/%Y" , osTime()) .. "\n"

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

		fileWrite(spawndir .. mapname .. ".txt", content)
	end

	function entspawnscript.ReadFile()
		local mapname = gameGetMap()
		local lines = stringExplode("\n", fileRead(spawndir .. mapname .. ".txt", "DATA"))
		local spawnType = nil

		local spawnTable = {
			[SPAWN_TYPE_WEAPON] = {},
			[SPAWN_TYPE_AMMO] = {},
			[SPAWN_TYPE_PLAYER] = {}
		}

		for i = 1, #lines do
			local line = lines[i]

			-- ignore comments or empty lines
			if stringMatch(line, "^#") or line == "" or stringByte(line) == 0 then continue end

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

		return spawnTable
	end

	function entspawnscript.SetEditing(ply, state)
		ply:SetNWBool("is_spawn_editing", state)
	end

	function entspawnscript.StreamToClient(ply)
		net.SendStream("TTT2_WeaponSpawnEntities", spawnEntList, ply)
	end

	net.Receive("ttt2_remove_spawn_ent", function(_, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		entspawnscript.RemoveSpawnById(net.ReadUInt(4), net.ReadUInt(4), net.ReadUInt(32))
	end)

	net.Receive("ttt2_add_spawn_ent", function(_, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		entspawnscript.AddSpawn(net.ReadUInt(4), net.ReadUInt(4), net.ReadVector(), net.ReadAngle(), net.ReadUInt(8))
	end)

	net.Receive("ttt2_update_spawn_ent", function(_, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		entspawnscript.UpdateSpawn(net.ReadUInt(4), net.ReadUInt(4), net.ReadUInt(32), net.ReadVector(), net.ReadAngle(), net.ReadUInt(8))
	end)

	net.Receive("ttt2_entspawn_init", function(_, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		entspawnscript.Init(net.ReadBool())
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

	net.ReceiveStream("TTT2_WeaponSpawnEntities", function(spawnEnts)
		spawnEntList = spawnEnts
	end)
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

function entspawnscript.GetSpawnEntities()
	return spawnEntList
end

function entspawnscript.GetSpawnEntitiesForSpawnType(spawnType)
	return spawnEntList[spawnType]
end

function entspawnscript.RemoveSpawnById(spawnType, entType, id)
	if not spawnEntList or not spawnEntList[spawnType] or not spawnEntList[spawnType][entType] then return end

	local list = spawnEntList[spawnType][entType]

	tableRemove(list, id)

	if CLIENT then
		net.Start("ttt2_remove_spawn_ent")
		net.WriteUInt(spawnType, 4)
		net.WriteUInt(entType, 4)
		net.WriteUInt(id, 32)
		net.SendToServer()
	end
end

function entspawnscript.AddSpawn(spawnType, entType, pos, ang, ammo)
	spawnEntList = spawnEntList or {}
	spawnEntList[spawnType] = spawnEntList[spawnType] or {}
	spawnEntList[spawnType][entType] = spawnEntList[spawnType][entType] or {}

	local list = spawnEntList[spawnType][entType]

	list[#list + 1] = {
		pos = pos,
		ang = ang,
		ammo = ammo
	}

	if CLIENT then
		net.Start("ttt2_add_spawn_ent")
		net.WriteUInt(spawnType, 4)
		net.WriteUInt(entType, 4)
		net.WriteVector(pos)
		net.WriteAngle(ang)
		net.WriteUInt(ammo, 8)
		net.SendToServer()
	end
end

function entspawnscript.UpdateSpawn(spawnType, entType, id, pos, ang, ammo)
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

	if CLIENT then
		net.Start("ttt2_update_spawn_ent")
		net.WriteUInt(spawnType, 4)
		net.WriteUInt(entType, 4)
		net.WriteUInt(id, 32)
		net.WriteVector(pos)
		net.WriteAngle(ang)
		net.WriteUInt(ammo, 8)
		net.SendToServer()
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

function entspawnscript.Init(forceReinit)
	if CLIENT then
		net.Start("ttt2_entspawn_init")
		net.WriteBool(forceReinit or false)
		net.SendToServer()
	else
		if forceReinit or not entspawnscript.Exists() then
			spawnEntList = entspawnscript.InitMap()
		else
			spawnEntList = entspawnscript.ReadFile()
		end
	end
end
