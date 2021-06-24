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

entspawnscript = entspawnscript or {}

if SERVER then
	util.AddNetworkString("ttt2_remove_spawn_ent")
	util.AddNetworkString("ttt2_add_spawn_ent")

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

		entspawnscript.RemoveSpawnById(net.ReadUInt(4), net.ReadUInt(4), net.ReadInt(32))
	end)

	net.Receive("ttt2_add_spawn_ent", function(_, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		entspawnscript.AddSpawn(net.ReadUInt(4), net.ReadUInt(4), net.ReadVector(), net.ReadAngle())
	end)
end

if CLIENT then
	local isEditing = false
	local focusedSpawn = nil

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
		net.WriteInt(id, 32)
		net.SendToServer()
	end
end

function entspawnscript.AddSpawn(spawnType, entType, pos, ang)
	spawnEntList = spawnEntList or {}
	spawnEntList[spawnType] = spawnEntList[spawnType] or {}
	spawnEntList[spawnType][entType] = spawnEntList[spawnType][entType] or {}

	local list = spawnEntList[spawnType][entType]

	list[#list + 1] = {
		pos = pos,
		ang = ang
	}

	if CLIENT then
		net.Start("ttt2_add_spawn_ent")
		net.WriteUInt(spawnType, 4)
		net.WriteUInt(entType, 4)
		net.WriteVector(pos)
		net.WriteAngle(ang)
		net.SendToServer()
	end
end
