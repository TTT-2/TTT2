---
-- Handling body search data and data processing. Is shared between the server and client
-- @author Mineotopia

if SERVER then
	AddCSLuaFile()
end

CORPSE_KILL_NONE = 0

CORPSE_KILL_POINT_BLANK = 1
CORPSE_KILL_CLOSE = 2
CORPSE_KILL_FAR = 3

CORPSE_KILL_FRONT = 1
CORPSE_KILL_BACK = 2
CORPSE_KILL_SIDE = 3

bodysearch = bodysearch or {}

if SERVER then

end

if CLIENT then
	-- cache functions
	local utilSimpleTime = util.SimpleTime
	local CurTime = CurTime
	local utilBitSet = util.BitSet
	local mathMax = math.max
	local table = table
	local IsValid = IsValid
	local pairs = pairs

	local damageToText = {
		["crush"] = DMG_CRUSH,
		["bullet"] = DMG_BULLET,
		["fall"] = DMG_FALL,
		["boom"] = DMG_BLAST,
		["club"] = DMG_CLUB,
		["drown"] = DMG_DROWN,
		["stab"] = DMG_SLASH,
		["burn"] = DMG_BURN,
		["tele"] = DMG_SONIC,
		["car"] = DMG_VEHICLE
	}

	local damageFromType = {
		["bullet"] = DMG_BULLET,
		["rock"] = DMG_CRUSH,
		["splode"] = DMG_BLAST,
		["fall"] = DMG_FALL,
		["fire"] = DMG_BURN,
		["drown"] = DMG_DROWN
	}

	local distanceToText = {
		[CORPSE_KILL_POINT_BLANK] = "kill_distance_point_blank",
		[CORPSE_KILL_CLOSE] = "kill_distance_close",
		[CORPSE_KILL_FAR] = "kill_distance_far"
	}

	local orientationToText = {
		[CORPSE_KILL_FRONT] = "kill_from_front",
		[CORPSE_KILL_BACK] = "kill_from_back",
		[CORPSE_KILL_SIDE] = "kill_from_side"
	}

	local floorIDToText = {
		[MAT_ANTLION] = "search_floor_antillions",
		[MAT_BLOODYFLESH] = "search_floor_bloodyflesh",
		[MAT_CONCRETE] = "search_floor_concrete",
		[MAT_DIRT] = "search_floor_dirt",
		[MAT_EGGSHELL] = "search_floor_eggshell",
		[MAT_FLESH] = "search_floor_flesh",
		[MAT_GRATE] = "search_floor_grate",
		[MAT_ALIENFLESH] = "search_floor_alienflesh",
		[MAT_SNOW] = "search_floor_snow",
		[MAT_PLASTIC] = "search_floor_plastic",
		[MAT_METAL] = "search_floor_metal",
		[MAT_SAND] = "search_floor_sand",
		[MAT_FOLIAGE] = "search_floor_foliage",
		[MAT_COMPUTER] = "search_floor_computer",
		[MAT_SLOSH] = "search_floor_slosh",
		[MAT_TILE] = "search_floor_tile",
		[MAT_GRASS] = "search_floor_grass",
		[MAT_VENT] = "search_floor_vent",
		[MAT_WOOD] = "search_floor_wood",
		[MAT_DEFAULT] = "search_floor_default",
		[MAT_GLASS] = "search_floor_glass",
		[MAT_WARPSHIELD] = "search_floor_warpshield"
	}

	local hitgroup_to_text = {
		[HITGROUP_HEAD] = "search_hitgroup_head",
		[HITGROUP_CHEST] = "search_hitgroup_chest",
		[HITGROUP_STOMACH] = "search_hitgroup_stomach",
		[HITGROUP_RIGHTARM] = "search_hitgroup_rightarm",
		[HITGROUP_LEFTARM] = "search_hitgroup_leftarm",
		[HITGROUP_RIGHTLEG] = "search_hitgroup_rightleg",
		[HITGROUP_LEFTLEG] = "search_hitgroup_leftleg",
		[HITGROUP_GEAR] = "search_hitgroup_gear"
	}

	local function DamageToText(dmg)
		for key, value in pairs(damageToText) do
			if utilBitSet(dmg, value) then
				return key
			end
		end

		if utilBitSet(dmg, DMG_DIRECT) then
			return "burn"
		end

		return "other"
	end

	local DataToText = {
		last_words = function(data)
			if not data.words or data.words == "" then return end

			-- only append "--" if there's no ending interpunction
			local final = string.match(data.words, "[\\.\\!\\?]$") ~= nil

			return {
				title = {
					body = "search_title_words",
					params = nil
				},
				text = {{
					body = "search_words",
					params = {lastwords = data.words .. (final and "" or "--.")}
				}}
			}
		end,
		c4_disarm = function(data)
			if data.c4 <= 0 then return end

			return {
				title = {
					body = "search_title_c4",
					params = nil
				},
				text = {{
					body = "search_c4",
					params = {num = data.c4}
				}}
			}
		end,
		dmg = function(data)
			local rawText = {
				title = {
					body = "search_title_dmg_" .. DamageToText(data.dmg),
					params = {amount = data.lastDamage}
				},
				text = {{
					body = "search_dmg_" .. DamageToText(data.dmg),
					params = nil
				}}
			}

			if (data.ori ~= CORPSE_KILL_NONE) then
				rawText.text[#rawText.text + 1] = {
					body = orientationToText[data.killOrientation],
					params = nil
				}
			end

			if (data.head) then
				rawText.text[#rawText.text + 1] = {
					body = "search_head",
					params = nil
				}
			end

			return rawText
		end,
		wep = function(data)
			local wep = util.WeaponForClass(data.wep)

			local wname = wep and wep.PrintName

			if not wname then return end

			local rawText = {
				title = {
					body = wname,
					params = nil
				},
				text = {{
					body = "search_weapon",
					params = {weapon = wname}
				}}
			}

			if data.dist ~= CORPSE_KILL_NONE then
				rawText.text[#rawText.text + 1] = {
					body = distanceToText[data.killDistance],
					params = nil
				}
			end

			if data.hitGroup > 0 then
				rawText.text[#rawText.text + 1] = {
					body = hitgroup_to_text[data.hitGroup],
					params = nil
				}
			end

			return rawText
		end,
		death_time = function(data)
			return {
				title = {
					body = "search_title_time",
					params = nil
				},
				text = {{
					body = "search_time",
					params = nil
				}}
			}
		end,
		dna_time = function(data)
			if data.stime - CurTime() <= 0 then return end

			return {
				title = {
					body = "search_title_dna",
					params = nil
				},
				text = {{
					body = "search_dna",
					params = nil
				}}
			}
		end,
		kill_list = function(data)
			if not data.kills then return end

			local num = table.Count(data.kills)

			if num == 1 then
				local vic = Entity(data.kills[1])
				local dc = data.kills[1] == -1 -- disconnected

				if dc or IsValid(vic) and vic:IsPlayer() then
					return {
						title = {
							body = "search_title_kills",
							params = nil
						},
						text = {{
							body = "search_kills1",
							params = {player = dc and "<Disconnected>" or vic:Nick()}
						}}
					}
				end
			elseif num > 1 then
				local nicks = {}

				for k, idx in pairs(data.kills) do
					local vic = Entity(idx)
					local dc = idx == -1

					if dc or IsValid(vic) and vic:IsPlayer() then
						nicks[#nicks + 1] = dc and "<Disconnected>" or vic:Nick()
					end
				end

				return {
					title = {
						body = "search_title_kills",
						params = nil
					},
					text = {{
						body = "search_kills2",
						params = {player = table.concat(nicks, "\n", 1, last)}
					}}
				}
			end
		end,
		last_id = function(data)
			if not data.idx or data.idx == -1 then return end

			local ent = Entity(data.idx)

			if not IsValid(ent) or not ent:IsPlayer() then return end

			return {
				title = {
					body = "search_title_eyes",
					params = nil
				},
				text = {{
					body = "search_eyes",
					params = {player = ent:Nick()}
				}}
			}
		end,
		floor_surface = function(data)
			if data.floorSurface == 0 or not floorIDToText[data.floorSurface] then return end

			return {
				title = {
					body = "search_title_floor",
					params = nil
				},
				text = {{
					body = floorIDToText[data.floorSurface],
					params = nil
				}}
			}
		end,
		credits = function(data)
			if data.credits == 0 then return end

			return {
				title = {
					body = "search_title_credits",
					params = {credits = data.credits}
				},
				text = {{
					body = "search_credits",
					params = {credits = data.credits}
				}}
			}
		end,
		water_level = function(data)
			if not data.waterLevel or data.waterLevel == 0 then return end

			return {
				title = {
					body = "search_title_water",
					params = {level = data.waterLevel}
				},
				text = {{
					body = "search_water_" .. data.waterLevel,
					params = nil
				}}
			}
		end
	}

	local materialDamage = {
		["bullet"] = Material("vgui/ttt/icon_bullet"),
		["rock"] = Material("vgui/ttt/icon_rock"),
		["splode"] = Material("vgui/ttt/icon_splode"),
		["fall"] = Material("vgui/ttt/icon_fall"),
		["fire"] = Material("vgui/ttt/icon_fire"),
		["drown"] = Material("vgui/ttt/icon_drown"),
		["generic"] = Material("vgui/ttt/icon_skull")
	}

	local materialWaterLevel = {
		[1] = Material("vgui/ttt/icon_water_1"),
		[2] = Material("vgui/ttt/icon_water_2"),
		[3] = Material("vgui/ttt/icon_water_3")
	}

	local materialHeadShot = Material("vgui/ttt/icon_head")
	local materialDeathTime = Material("vgui/ttt/icon_time")
	local materialCredits = Material("vgui/ttt/icon_credits")
	local materialDNA = Material("vgui/ttt/icon_wtester")
	local materialFloor = Material("vgui/ttt/icon_floor")
	local materialC4Disarm = Material("vgui/ttt/icon_code")
	local materialLastID = Material("vgui/ttt/icon_lastid")
	local materialKillList = Material("vgui/ttt/icon_list")
	local materialLastWords = Material("vgui/ttt/icon_halp")

	local function DamageToIconMaterial(data)
		-- handle headshots first
		if data.head then
			return materialHeadShot
		end

		-- the damage type
		local dmg = data.dmg

		-- handle most generic damage types
		for key, value in pairs(damageFromType) do
			if utilBitSet(dmg, value) then
				return materialDamage[key]
			end
		end

		-- special case handling with a fallback for generic damage
		if utilBitSet(dmg, DMG_DIRECT) then
			return materialDamage["fire"]
		else
			return materialDamage["generic"]
		end
	end

	local function TypeToMaterial(type, data)
		if type == "wep" then
			return util.WeaponForClass(data.wep).iconMaterial
		elseif type == "dmg" then
			return DamageToIconMaterial(data)
		elseif type == "death_time" then
			return materialDeathTime
		elseif type == "credits" then
			return materialCredits
		elseif type == "dna_time" then
			return materialDNA
		elseif type == "floor_surface" then
			return materialFloor
		elseif type == "water_level" then
			return materialWaterLevel[data.water_level]
		elseif type == "c4_disarm" then
			return materialC4Disarm
		elseif type == "last_id" then
			return materialLastID
		elseif type == "kill_list" then
			return materialKillList
		elseif type == "last_words" then
			return materialLastWords
		end
	end

	local function TypeToIconText(type, data)
		if type == "death_time" then
			return function()
				return utilSimpleTime(CurTime() - data.dtime, "%02i:%02i")
			end
		elseif type == "dna_time" then
			return function()
				return utilSimpleTime(mathMax(0, data.stime - CurTime()), "%02i:%02i")
			end
		end
	end

	local function TypeToColor(type, data)
		if type == "dna_time" then
			return roles.DETECTIVE.color
		elseif type == "credits" then
			return COLOR_GOLD
		end
	end

	bodysearch.searchResultOrder = {
		"wep",
		"dmg",
		"death_time",
		"credits",
		"dna_time",
		"floor_surface",
		"water_level",
		"c4_disarm",
		"last_id",
		"kill_list",
		"last_words"
	}

	function bodysearch.GetContentFromData(type, data)
		-- make sure type is valid
		if not isfunction(DataToText[type]) then return end

		local text = DataToText[type](data)

		-- DataToText checks if criteria for display is met, no box should be
		-- shown if criteria is not met.
		if not text then return end

		return {
			iconMaterial = TypeToMaterial(type, data),
			iconText = TypeToIconText(type, data),
			colorBox = TypeToColor(type, data),
			text = text
		}
	end

	---
	-- Creates a table with icons, text,... out of search_raw table
	-- @param table raw
	-- @return table a converted search data table
	-- @note This function is old and should be redone on a scoreboard rework
	-- @realm client
	function bodysearch.PreprocSearch(raw)
		local search = {}

		for i = 1, #bodysearch.searchResultOrder do
			local type = bodysearch.searchResultOrder[i]
			local searchData = bodysearch.GetContentFromData(type, raw)

			if not searchData then continue end

			-- a workaround to build the rext for the scoreboard
			local text = searchData.text.text
			local transText = ""

			-- only use the first text entry here
			local par = text[1].params
			if par then
				-- process params (translation)
				for k, v in pairs(par) do
					par[k] = LANG.TryTranslation(v)
				end

				transText = transText .. LANG.GetParamTranslation(text[1].body, par) .. " "
			else
				transText = transText .. LANG.TryTranslation(text[1].body) .. " "
			end

			search[type] = {
				img = searchData.iconMaterial:GetName(),
				text = transText,
				p = i -- sorting number
			}

			-- special cases with icon text
			search[type].text_icon = TypeToIconText(type, raw)()
		end

		---
		-- @realm client
		hook.Run("TTTBodySearchPopulate", search, raw)

		return search
	end

	-- HOOKS --

	---
	-- This hook can be used to populate the body search panel.
	-- @param table search The search data table
	-- @param table raw The raw search data
	-- @hook
	-- @realm client
	function GM:TTTBodySearchPopulate(search, raw)

	end

	---
	-- This hook can be used to modify the equipment info of a corpse.
	-- @param table search The search data table
	-- @param table equip The raw equipment table
	-- @hook
	-- @realm client
	function GM:TTTBodySearchEquipment(search, equip)

	end

	---
	-- This hook is called right before the killer found @{MSTACK} notification
	-- is added.
	-- @param string finder The nickname of the finder
	-- @param string victim The nickname of the victim
	-- @hook
	-- @realm client
	function GM:TTT2ConfirmedBody(finder, victim)

	end
end
