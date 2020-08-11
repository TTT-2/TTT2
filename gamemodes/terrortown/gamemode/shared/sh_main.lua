---
-- This file contains all shared gamemode hooks needed when the gamemode initializes

local IsValid = IsValid
local hook = hook
local team = team
local UpdateSprint = UpdateSprint

local MAX_DROWN_TIME = 8

---
-- Initializes TTT2
-- @hook
-- @register
-- @realm shared
function GM:TTT2Initialize()
	-- load all roles
	roles.OnLoaded()

	hook.Run("TTT2RolesLoaded")
	hook.Run("TTT2BaseRoleInit")

	-- load all HUDs
	huds.OnLoaded()

	-- load all HUD elements
	hudelements.OnLoaded()

	DefaultEquipment = GetDefaultEquipment()
end

---
-- Create teams
-- @hook
-- @internal
-- @realm shared
function GM:CreateTeams()
	team.SetUp(TEAM_TERROR, "Terrorists", Color(0, 200, 0, 255), false)
	team.SetUp(TEAM_SPEC, "Spectators", Color(200, 200, 0, 255), true)

	-- Not that we use this, but feels good
	team.SetSpawnPoint(TEAM_TERROR, "info_player_deathmatch")
	team.SetSpawnPoint(TEAM_SPEC, "info_player_deathmatch")
end

---
-- Kill footsteps on player and client
-- @hook
-- @realm shared
function GM:PlayerFootstep(ply, pos, foot, sound, volume, rf)
	if IsValid(ply) and (ply:Crouching() or ply:GetMaxSpeed() < 150 or ply:IsSpec()) then
		-- do not play anything, just prevent normal sounds from playing
		return true
	end
end

---
-- The Move hook is called for you to manipulate the player's MoveData.
-- You shouldn't adjust the player's position in any way in the move hook. This is due to
-- prediction errors, the netcode might run the move hook multiple times as packets arrive late.
-- Therefore you should only adjust the movedata construct in this hook.
-- @param Player ply The player
-- @param CMoveData moveData Movement information
-- @hook
-- @realm shared
function GM:Move(ply, moveData)
	SPEED:HandleSpeedCalculation(ply, moveData)

	local mul = ply:GetSpeedMultiplier()

	if ply.sprintMultiplier and (ply.sprintProgress or 0) > 0 then
		local sprintMultiplierModifier = {1}

		hook.Run("TTT2PlayerSprintMultiplier", ply, sprintMultiplierModifier)

		mul = mul * ply.sprintMultiplier * sprintMultiplierModifier[1]
	end

	moveData:SetMaxClientSpeed(moveData:GetMaxClientSpeed() * mul)
	moveData:SetMaxSpeed(moveData:GetMaxSpeed() * mul)
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

local colormode = CreateConVar("ttt_playercolor_mode", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

---
-- @hook
-- @register
-- @realm shared
function GM:TTTPlayerColor(model)
	local mode = colormode:GetInt()

	if mode == 1 then
		return ttt_playercolors.serious[math.random(ttt_playercolors_serious_count)]
	elseif mode == 2 then
		return ttt_playercolors.all[math.random(ttt_playercolors_all_count)]
	elseif mode == 3 then
		-- Full randomness
		return Color(math.random(0, 255), math.random(0, 255), math.random(0, 255))
	end

	-- No coloring
	return COLOR_WHITE
end

---
-- @hook
-- @realm shared
function GM:Think()
	UpdateSprint()

	if CLIENT then
		EPOP:Think()
	end
end

-- Drowning and such
local tm, ply, plys

---
-- @hook
-- @realm shared
function GM:Tick()
	local client = CLIENT and LocalPlayer()

	if client and not IsValid(client) then return end

	-- three cheers for micro-optimizations
	plys = client and {client} or player.GetAll()

	for i = 1, #plys do
		ply = plys[i]
		tm = ply:Team()

		if tm == TEAM_TERROR and ply:Alive() then
			if ply:WaterLevel() == 3 then -- Drowning
				if SERVER and ply:IsOnFire() then
					ply:Extinguish()
				end

				local drowningTime = ply.drowningTime or MAX_DROWN_TIME

				if ply.drowning then
					if ply:HasEquipmentItem("item_ttt_nodrowningdmg") then
						ply.drowningProgress = MAX_DROWN_TIME
						ply.drowning = CurTime() + MAX_DROWN_TIME
					else
						ply.drowningProgress = math.max(0, (ply.drowning - CurTime()) * (1 / drowningTime))
					end

					if SERVER and ply.drowning < CurTime() then
						local dmginfo = DamageInfo()

						dmginfo:SetDamage(15)
						dmginfo:SetDamageType(DMG_DROWN)
						dmginfo:SetAttacker(game.GetWorld())
						dmginfo:SetInflictor(game.GetWorld())
						dmginfo:SetDamageForce(Vector(0, 0, 1))

						ply:TakeDamageInfo(dmginfo)

						-- have started drowning properly
						ply:StartDrowning(true, 1, drowningTime)
					end
				elseif SERVER then
					ply:StartDrowning(true, drowningTime, drowningTime)
				end
			elseif SERVER then
				ply:StartDrowning(false)
			end

			-- Run DNA Scanner think also when it is not deployed
			if ply:HasWeapon("weapon_ttt_wtester") then
				ply:GetWeapon("weapon_ttt_wtester"):PassiveThink()
			end
		elseif SERVER and tm == TEAM_SPEC then
			if ply.propspec then
				PROPSPEC.Recharge(ply)

				if IsValid(ply:GetObserverTarget()) then
					ply:SetPos(ply:GetObserverTarget():GetPos())
				end
			end

			-- if spectators are alive, ie. they picked spectator mode, then
			-- DeathThink doesn't run, so we have to SpecThink here
			if ply:Alive() then
				self:SpectatorThink(ply)
			end
		end
	end

	if CLIENT then
		if client:Alive() and client:Team() ~= TEAM_SPEC then
			WSWITCH:Think()
			RADIO:StoreTarget()
		end

		VOICE.Tick()
	end
end

---
-- A hook that is called when the preparation phase starts.
-- @hook
-- @realm shared
function GM:TTTPrepareRound()
	BUYTABLE = {}
	TEAMBUYTABLE = {}
end

---
-- A hook that is called when the round begins.
-- @hook
-- @realm shared
function GM:TTTBeginRound()

end

-- A hook that is called when the round ends.
-- @hook
-- @realm shared
function GM:TTTEndRound()

end

---
-- Called right after the map has been cleaned up (usually because game.CleanUpMap was called).
-- This hook is called after the @{outputs} library is set up and map entity outputs can be
-- registered.
-- @hook
-- @realm shared
function GM:TTT2PostCleanupMap()

end

---
-- Called right after all doors are initialized on the map.
-- @param table doorsTable A table with the newly registered door entities
-- @hook
-- @realm shared
function GM:TTT2PostDoorSetup(doorsTable)

end
