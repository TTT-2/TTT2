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
local gameGetMap = game.GetMap
local stringFormat = string.format
local pairs = pairs
local tableRemove = table.remove

local spawnEntList = {}

local spawnColors = {
	[SPAWN_TYPE_WEAPON] = Color(0, 175, 175, 255),
	[SPAWN_TYPE_AMMO] = Color(175, 75, 75, 255),
	[SPAWN_TYPE_PLAYER] = Color(75, 175, 50, 255)
}

local materialSpawn = {
	[SPAWN_TYPE_WEAPON] = {
		[WEAPON_TYPE_RANDOM] = Material("vgui/ttt/tid/tid_big_weapon_random"),
		[WEAPON_TYPE_MELEE] = Material("vgui/ttt/tid/tid_big_weapon_melee"),
		[WEAPON_TYPE_NADE] = Material("vgui/ttt/tid/tid_big_weapon_nade"),
		[WEAPON_TYPE_SHOTGUN] = Material("vgui/ttt/tid/tid_big_weapon_shotgun"),
		[WEAPON_TYPE_ASSAULT] = Material("vgui/ttt/tid/tid_big_weapon_assault"),
		[WEAPON_TYPE_SNIPER] = Material("vgui/ttt/tid/tid_big_weapon_sniper"),
		[WEAPON_TYPE_PISTOL] = Material("vgui/ttt/tid/tid_big_weapon_pistol"),
		[WEAPON_TYPE_SPECIAL] = Material("vgui/ttt/tid/tid_big_weapon_special")
	},
	[SPAWN_TYPE_AMMO] = {
		[AMMO_TYPE_RANDOM] = Material("vgui/ttt/tid/tid_big_weapon_random"),
		[AMMO_TYPE_DEAGLE] = Material("vgui/ttt/tid/tid_big_weapon_random"),
		[AMMO_TYPE_PISTOL] = Material("vgui/ttt/tid/tid_big_weapon_random"),
		[AMMO_TYPE_MAC10] = Material("vgui/ttt/tid/tid_big_weapon_random"),
		[AMMO_TYPE_RIFLE] = Material("vgui/ttt/tid/tid_big_weapon_random"),
		[AMMO_TYPE_SHOTGUN] = Material("vgui/ttt/tid/tid_big_weapon_random")
	},
	[SPAWN_TYPE_PLAYER] = {
		[PLAYER_TYPE_RANDOM] = Material("vgui/ttt/tid/tid_big_weapon_random")
	}
}

entspawnscript = entspawnscript or {}

if SERVER then
	util.AddNetworkString("ttt2_remove_spawn_ent")
	util.AddNetworkString("ttt2_add_spawn_ent")
	util.AddNetworkString("ttt2_update_spawn_ent")

	local spawndir = "ttt/weaponspawnscripts/"

	function entspawnscript.Exists()
		local mapname = gameGetMap()

		return fileExists(spawndir .. mapname .. ".txt", "DATA")
	end

	function entspawnscript.InitMap()
		local content = ""
		local mapname = gameGetMap()
		local weaponspawns = map.GetWeaponSpawnEntities()
		local ammospawns = map.GetAmmoSpawnEntities()

		fileCreateDir(spawndir)

		content = content .. "\n# weapons\n\n"

		for entType, spawns in pairs(weaponspawns) do
			for i = 1, #spawns do
				local spawn = spawns[i]

				local pos = spawn.pos
				local ang = spawn.ang

				content = content .. stringFormat("%d\t%f %f %f\t%f %f %f", entType, pos.x, pos.y, pos.z, ang.p, ang.y, ang.r) .. "\n"
			end
		end

		content = content .. "\n# ammo\n\n"

		for entType, spawns in pairs(ammospawns) do
			for i = 1, #spawns do
				local spawn = spawns[i]

				local pos = spawn.pos
				local ang = spawn.ang

				content = content .. stringFormat("%d\t%f %f %f\t%f %f %f", entType, pos.x, pos.y, pos.z, ang.p, ang.y, ang.r) .. "\n"
			end
		end

		fileWrite(spawndir .. mapname .. ".txt", content)

		return {
			[SPAWN_TYPE_WEAPON] = weaponspawns,
			[SPAWN_TYPE_AMMO] = ammospawns
		}
	end

	function entspawnscript.Init(forceReinit)
		if forceReinit or not entspawnscript.Exists() then
			spawnEntList = entspawnscript.InitMap()
		else
			spawnEntList = entspawnscript.ReadFile()
		end
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
end

if CLIENT then
	local isEditing = false
	local focusedSpawn = nil
	local spawnInfoEnt = nil

	function entspawnscript.SetEditing(state)
		isEditing = state
	end

	function entspawnscript.IsEditing()
		return isEditing == true
	end

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

	function entspawnscript.GetLangIdentifierFromSpawnType(spawnType, entType)
		if spawnType == SPAWN_TYPE_WEAPON then
			if entType == WEAPON_TYPE_RANDOM then
				return "spawn_weapon_random"
			elseif entType == WEAPON_TYPE_MELEE then
				return "spawn_weapon_melee"
			elseif entType == WEAPON_TYPE_NADE then
				return "spawn_weapon_nade"
			elseif entType == WEAPON_TYPE_SHOTGUN then
				return "spawn_weapon_shotgun"
			elseif entType == WEAPON_TYPE_ASSAULT then
				return "spawn_weapon_assault"
			elseif entType == WEAPON_TYPE_SNIPER then
				return "spawn_weapon_sniper"
			elseif entType == WEAPON_TYPE_PISTOL then
				return "spawn_weapon_pistol"
			elseif entType == WEAPON_TYPE_SPECIAL then
				return "spawn_weapon_special"
			end
		end
	end

	function entspawnscript.GetColorFromSpawnType(spawnType)
		return spawnColors[spawnType]
	end

	function entspawnscript.GetIconFromSpawnType(spawnType, entType)
		return materialSpawn[spawnType][entType]
	end

	net.ReceiveStream("TTT2_WeaponSpawnEntities", function(spawnEnts)
		spawnEntList = spawnEnts
	end)
end

function entspawnscript.GetSpawnEntities()
	return spawnEntList
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
