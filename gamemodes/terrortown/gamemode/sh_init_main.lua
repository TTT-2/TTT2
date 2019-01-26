-- This file contains all shared gamemode hooks needed when the gamemode initializes
local IsValid = IsValid
local hook = hook
local team = team

function GM:TTT2Initialize()
	hook.Run("TTT2BaseRoleInit")

	DefaultEquipment = GetDefaultEquipment()

	for subrole, tbl in pairs(EquipmentItems or {}) do
		for _, v in ipairs(tbl) do
			if tonumber(v.id) then
				local name = (v.ClassName or v.name or WEPS.GetClass(v))
				if name then
					local item = items.GetStored(name)
					if not item then
						local ITEMDATA = table.Copy(v)
						ITEMDATA.oldId = v.id
						ITEMDATA.id = name
						ITEMDATA.EquipMenuData = v.EquipMenuData or {
							type = v.type,
							name = v.name,
							desc = v.desc
						}
						ITEMDATA.type = nil
						ITEMDATA.desc = nil
						ITEMDATA.name = name
						ITEMDATA.material = v.material
						ITEMDATA.CanBuy = {subrole}

						if ITEMDATA.hud == true then
							ITEMDATA.hud = nil
						end
					else
						item.CanBuy = item.CanBuy or {}

						if not table.HasValue(item.CanBuy, subrole) then
							item.CanBuy[#item.CanBuy + 1] = subrole
						end
					end

					items.Register(ITEMDATA, name)
				end
			end
		end
	end

	items.OnLoaded() -- init baseclasses

	-- reset this old var to print errors for incompatible add-ons
	local itemMt = {
		__newindex = function(tbl, key, val)
			ErrorNoHalt("\n[TTT2][WARNING] You are using an add-on that is trying to add a new item ('" .. key .. "' = '" .. val .. "') in the wrong way. This will not be available in the shop and lead to errors!\n\n")
		end
	}

	EquipmentItems = setmetatable(
		{
			[ROLE_TRAITOR] = setmetatable({}, itemMt),
			[ROLE_DETECTIVE] = setmetatable({}, itemMt)
		},
		{
			__index = function(tbl, key)
				ErrorNoHalt("\n[TTT2][WARNING] You are using an add-on that is trying to access an unsupported var ('" .. key .. "'). This will lead to errors!\n\n")
			end,
			__newindex = function(tbl, key, val)
				ErrorNoHalt("\n[TTT2][WARNING] You are using an add-on that is trying to add a new role ('" .. key .. "' = '" .. val .. "') to an unsupported var. This will lead to errors!\n\n")

				if istable(val) then
					tbl[key] = setmetatable(val, itemMt)
				end
			end
		}
	)
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

		local noLag = {1}

		local mul = hook.Call("TTTPlayerSpeedModifier", GAMEMODE, ply, slowed, mv, noLag) or 1
		mul = basemul * mul * noLag[1]

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

local colormode = CreateConVar("ttt_playercolor_mode", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
function GM:TTTPlayerColor(model)
	local mode = colormode:GetInt()

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
