-- This file contains all shared gamemode hooks needed when the gamemode initializes

function GM:TTT2Initialize()
	hook.Run("TTT2BaseRoleInit")

	DefaultEquipment = GetDefaultEquipment()

	SetupEquipment()

	-- setup weapon ConVars and similar things
	for _, wep in ipairs(weapons.GetList()) do
		if not wep.Doublicated then
			RegisterNormalWeapon(wep)
		end
	end
end

-- Create teams
function GM:CreateTeams()
	team.SetUp(TEAM_TERROR, "Terrorists", Color(0, 200, 0, 255), false)
	team.SetUp(TEAM_SPEC, "Spectators", Color(200, 200, 0, 255), true)

	-- Not that we use this, but feels good
	team.SetSpawnPoint(TEAM_TERROR, "info_player_deathmatch")
	team.SetSpawnPoint(TEAM_SPEC, "info_player_deathmatch")
end

-- Kill footsteps on player and client
function GM:PlayerFootstep(ply, pos, foot, sound, volume, rf)
	if IsValid(ply) and (ply:Crouching() or ply:GetMaxSpeed() < 150 or ply:IsSpec()) then
		-- do not play anything, just prevent normal sounds from playing
		return true
	end
end

-- Predicted move speed changes
function GM:Move(ply, mv)
	if ply:IsTerror() then
		local basemul = 1
		local slowed = false

		-- Slow down ironsighters
		local wep = ply:GetActiveWeapon()

		if IsValid(wep) and wep.GetIronsights and wep:GetIronsights() then
			basemul = 120 / 220
			slowed = true
		end

		local mul = hook.Call("TTTPlayerSpeedModifier", GAMEMODE, ply, slowed, mv) or 1
		mul = basemul * mul

		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * mul)
		mv:SetMaxSpeed(mv:GetMaxSpeed() * mul)
	end
end

local ttt_playercolors = {
	all = {
		COLOR_WHITE,
		COLOR_BLACK,
		COLOR_GREEN,
		COLOR_DGREEN,
		COLOR_RED,
		COLOR_YELLOW,
		COLOR_LGRAY,
		COLOR_BLUE,
		COLOR_NAVY,
		COLOR_PINK,
		COLOR_OLIVE,
		COLOR_ORANGE
	},
	serious = {
		COLOR_WHITE,
		COLOR_BLACK,
		COLOR_NAVY,
		COLOR_LGRAY,
		COLOR_DGREEN,
		COLOR_OLIVE
	}
}
local ttt_playercolors_all_count = #ttt_playercolors.all
local ttt_playercolors_serious_count = #ttt_playercolors.serious

CreateConVar("ttt_playercolor_mode", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
function GM:TTTPlayerColor(model)
	local mode = (ConVarExists("ttt_playercolor_mode") and GetConVar("ttt_playercolor_mode"):GetInt() or 0)

	if mode == 1 then
		return ttt_playercolors.serious[math.random(1, ttt_playercolors_serious_count)]
	elseif mode == 2 then
		return ttt_playercolors.all[math.random(1, ttt_playercolors_all_count)]
	elseif mode == 3 then
		-- Full randomness
		return Color(math.random(0, 255), math.random(0, 255), math.random(0, 255))
	end

	-- No coloring
	return COLOR_WHITE
end
