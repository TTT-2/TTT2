---
-- @section Utils
-- @desc Random stuff

if not util then return end

local math = math
local string = string
local table = table
local pairs = pairs
local ipairs = ipairs
local IsValid = IsValid
local weapons = weapons
local GetPlayers = player.GetAll

---
-- Attempts to get the weapon used from a DamageInfo instance needed because the
-- GetAmmoType value is useless and inflictor isn't properly set (yet)
-- @param CTakeDamageInfo dmg
-- @return Weapon
-- @realm shared
function util.WeaponFromDamage(dmg)
	local inf = dmg:GetInflictor()
	local wep

	if IsValid(inf) then
		if inf:IsWeapon() or inf.Projectile then
			wep = inf
		elseif dmg:IsDamageType(DMG_DIRECT) or dmg:IsDamageType(DMG_CRUSH) then
			-- DMG_DIRECT is the player burning, no weapon involved
			-- DMG_CRUSH is physics or falling on someone
			wep = nil
		elseif inf:IsPlayer() then
			wep = inf:GetActiveWeapon()

			if not IsValid(wep) then
				-- this may have been a dying shot, in which case we need a
				-- workaround to find the weapon because it was dropped on death
				wep = IsValid(inf.dying_wep) and inf.dying_wep or nil
			end
		end
	end

	return wep
end

---
-- Gets the table for a SWEP or a weapon-SENT (throwing knife), so not
-- equivalent to @{weapons.Get}. Do not modify the table returned by this, consider
-- as read-only.
-- @param string class of a @{Weapon}
-- @return Weapon
-- @realm shared
function util.WeaponForClass(cls)
	local wep = weapons.GetStored(cls)

	if not wep then
		wep = scripted_ents.GetStored(cls)
		if wep then

			-- don't like to rely on this, but the alternative is
			-- scripted_ents.Get which does a full table copy, so only do
			-- that as last resort
			wep = wep.t or scripted_ents.Get(cls)
		end
	end

	return wep
end

---
-- Returns a list of all @{Player}s filtered by a custom filter
-- @param function filterFn the filter function
-- @return table
-- @realm shared
function util.GetFilteredPlayers(filterFn)
	local plys = GetPlayers()

	if not isfunction(filterFn) then
		return plys
	end

	local tmp = {}

	for i = 1, #plys do
		if filterFn(plys[i]) then
			tmp[#tmp + 1] = plys[i]
		end
	end

	return tmp
end

---
-- Returns a list of all alive @{Player}s
-- @return table
-- @realm shared
function util.GetAlivePlayers()
	return util.GetFilteredPlayers(function(ply)
		return ply:Alive() and ply:IsTerror()
	end)
end

---
-- Returns the next available @{Player} based on the given @{Player} in the global list
-- @param Player ply
-- @return Player
-- @realm shared
function util.GetNextAlivePlayer(ply)
	local alive = util.GetAlivePlayers()

	if #alive < 1 then return end

	local prev = nil
	local choice = nil

	if IsValid(ply) then
		for _, p in pairs(alive) do
			if prev == ply then
				choice = p
			end

			prev = p
		end
	end

	if not IsValid(choice) then
		choice = alive[1]
	end

	return choice
end

---
-- Uppercases the first character only
-- @param string str
-- @return string
-- @realm shared
function string.Capitalize(str)
	return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
end

---
-- @function util.Capitalize(str)
-- @desc Uppercases the first character only
-- @param string str
-- @return string
-- @realm shared
-- @see string.Capitalize
util.Capitalize = string.Capitalize

---
-- Color unpacking
-- @param Color color
-- @return number red value of the given color
-- @return number green value of the given color
-- @return number blue value of the given color
-- @return number alpha value of the given color
-- @realm shared
function clr(color)
	return color.r, color.g, color.b, color.a
end

---
-- This @{function} creates a getter and a setter @{function} based on the name and the prefix "Get" and "Set"
-- @param table tbl the @{table} that should receive the Getter and Setter @{function}
-- @param string varname the name the tbl @{table} should have as key value
-- @param string name the name that should be concatenated to the prefix "Get" and "Set"
-- @realm shared
function AccessorFuncDT(tbl, varname, name)
	tbl["Get" .. name] = function(s)
		return s.dt and s.dt[varname]
	end

	tbl["Set" .. name] = function(s, v)
		if s.dt then
			s.dt[varname] = v
		end
	end
end

---
-- Darkens a given @{Color} value
-- @param Color color The original color value
-- @param number value The value to darken the color [0..255]
-- @return Color The darkened color
-- @realm shared
function util.ColorDarken(color, value)
	value = math.Clamp(value, 0, 255)

	return Color(
		math.max(color.r - value, 0),
		math.max(color.g - value, 0),
		math.max(color.b - value, 0),
		color.a
	)
end

---
-- Lightens a given @{Color} value
-- @param Color color The original color value
-- @param number value The value to lighten the color [0..255]
-- @return Color The lightened color
-- @realm shared
function util.ColorLighten(color, value)
	value = math.Clamp(value, 0, 255)

	return Color(
		math.min(color.r + value, 255),
		math.min(color.g + value, 255),
		math.min(color.b + value, 255),
		color.a
	)
end

-- shifts the hue
local function HueShift(hue, shift)
	hue = hue + shift

	while hue >= 360 do
		hue = hue - 360
	end

	while hue < 0 do
		hue = hue + 360
	end

	return hue
end

---
-- Returns the complementary value of a @{Color}
-- @param Color color The original color value
-- @return Color The complementary color
-- @realm shared
function util.ColorComplementary(color)
	local c_hsv, saturation, value = ColorToHSV(color)

	local c_new = HSVToColor(HueShift(c_hsv, 180), saturation, value)
	c_new.a = color.a

	return c_new
end

---
-- Returns white or black @{Color} based on the passed color value
-- @param Color bgcolor background color
-- @return Color The color based on the background color
-- @realm shared
function util.GetDefaultColor(bgcolor)
	if bgcolor.r + bgcolor.g + bgcolor.b < 500 then
		return COLOR_WHITE
	else
		return COLOR_BLACK
	end
end

local function DoBleed(ent)
	if not IsValid(ent) or (ent:IsPlayer() and (not ent:Alive() or not ent:IsTerror())) then return end

	local jitter = VectorRand() * 30
	jitter.z = 20

	util.PaintDown(ent:GetPos() + jitter, "Blood", ent)
end

---
-- Something hurt us, start bleeding for a bit depending on the amount
-- @param Entity ent
-- @param CTakeDamageInfo dmg
-- @param number t times
-- @realm shared
-- @todo improve description
function util.StartBleeding(ent, dmg, t)
	if dmg < 5 or not IsValid(ent) or ent:IsPlayer() and (not ent:Alive() or not ent:IsTerror()) then return end

	local times = math.Clamp(math.Round(dmg / 15), 1, 20)
	local delay = math.Clamp(t / times, 0.1, 2)

	if ent:IsPlayer() then
		times = times * 2
		delay = delay * 0.5
	end

	timer.Create("bleed" .. ent:EntIndex(), delay, times, function()
		if not IsValid(ent) then return end

		DoBleed(ent)
	end)
end

function util.StopBleeding(ent)
	timer.Remove("bleed" .. ent:EntIndex())
end

local zapsound = Sound("npc/assassin/ball_zap1.wav")

---
-- Creates a destruction sound on a given position
-- @param Vector pos
-- @realm shared
function util.EquipmentDestroyed(pos)
	local effect = EffectData()

	effect:SetOrigin(pos)

	util.Effect("cball_explode", effect)
	sound.Play(zapsound, pos)
end

---
-- Useful default behaviour for semi-modal DFrames
-- @param Panel pnl
-- @param KEY[https://wiki.garrysmod.com/page/Enums/BUTTON_CODE] kc key
-- @realm shared
-- @todo improve description
function util.BasicKeyHandler(pnl, kc)
	-- passthrough F5
	if kc == KEY_F5 then
		RunConsoleCommand("jpeg")
	else
		pnl:Close()
	end
end

---
-- Just for compatibility. All in all, a useless functions (hook.Remove already ignores not existing hooks automatically)
-- @param string event name of the hook event
-- @param string name unique name of the specific event hook
-- @realm shared
-- @deprecated
function util.SafeRemoveHook(event, name)
	local h = hook.GetTable()
	if h and h[event] and h[event][name] then
		hook.Remove(event, name)
	end
end

---
-- Just a noop @{function} that is doing NOTHING
-- @realm shared
function util.noop()

end

---
-- Just a passthrough @{function} that is doing NOTHING but returning the given value
-- @param any x
-- @return any the same as the given x
-- @realm shared
-- @see util.noop
function util.passthrough(x)
	return x
end

local rand = math.random

---
-- Nice Fisher-Yates implementation, from Wikipedia
-- Shuffles a @{table}
-- @param table t
-- @return table the given t, but sorted
-- @realm shared
function table.Shuffle(t)
	local n = #t

	while n > 2 do
		-- n is now the last pertinent index
		local k = rand(n) -- 1 <= k <= n

		-- Quick swap
		t[n], t[k] = t[k], t[n]
		n = n - 1
	end

	return t
end

---
-- Checks if a table has a value.
-- @note For optimization, functions that look for a value by sorting the table should never be needed if you work on a table that you built yourself.
-- @note Override of the original <a href="https://wiki.garrysmod.com/page/table/HasValue">table.HasValue</a> check with nil check
-- @warning This function is very inefficient for large tables (O(n)) and should probably not be called in things that run each frame. Instead, consider a table structure such as example 2 below.
-- @param table tbl Table to check
-- @param any val Value to search for
-- @return boolean Returns true if the table has that value, false otherwise
-- @usage local mytable = { "123", "test" }
-- print( table.HasValue( mytable, "apple" ), table.HasValue( mytable, "test" ) )
-- > false true
-- @usage local mytable = { ["123"] = true, test = true }
-- print( mytable["apple"], mytable["test"] )
-- > nil true
-- @realm shared
function table.HasValue(tbl, val)
	if not tbl then return end

	for _, v in pairs(tbl) do
		if v == val then
			return true
		end
	end

	return false
end

---
-- Value equality for tables
-- @param table a
-- @param table b
-- @return boolean
-- @realm shared
function table.EqualValues(a, b)
	if a == b then
		return true
	end

	for k, v in pairs(a) do
		if v ~= b[k] then
			return false
		end
	end

	return true
end

---
-- Basic table.HasValue pointer checks are insufficient when checking a table of
-- tables, so this uses table.EqualValues instead.
-- @param table tbl
-- @param table needle
-- @return boolean
-- @realm shared
function table.HasTable(tbl, needle)
	if not tbl then return end

	for _, v in pairs(tbl) do
		if v == needle then
			return true
		elseif table.EqualValues(v, needle) then
			return true
		end
	end

	return false
end

---
-- Returns copy of table with only specific keys copied
-- @param table tbl
-- @param table keys
-- @return table
-- @realm shared
function table.CopyKeys(tbl, keys)
	if not (tbl and keys) then return end

	local out = {}
	local val

	for _, k in pairs(keys) do
		val = tbl[k]

		if istable(val) then
			out[k] = table.Copy(val)
		else
			out[k] = val
		end
	end

	return out
end

---
-- This @{function} adds missing values into a table
-- @param table target
-- @param table source
-- @param boolean iterable
-- @realm shared
function table.AddMissing(target, source, iterable)
	if #source == 0 then return end

	local fn = not iterable and pairs or ipairs
	local index = #target + 1

	for _, v in fn(source) do
		if not table.HasValue(target, v) then
			target[index] = v
			index = index + 1
		end
	end
end

local gsub = string.gsub

---
-- Simple string interpolation:
-- string.Interp("{killer} killed {victim}", {killer = "Bob", victim = "Joe"})
-- returns "Bob killed Joe"
-- No spaces or special chars in parameter name, just alphanumerics.
-- @param string str
-- @param table tbl
-- @return string
-- @realm shared
function string.Interp(str, tbl)
	return gsub(str, "{(%w+)}", tbl)
end

---
-- Short helper for input.LookupBinding, returns capitalised key or a default
-- @param string binding
-- @param string default
-- @return string
-- @realm shared
-- @ref https://wiki.garrysmod.com/page/input/LookupBinding
function Key(binding, default)
	local b = input.LookupBinding(binding)
	if not b then
		return default
	end

	return string.upper(b)
end

local exp = math.exp

---
-- Equivalent to ExponentialDecay from Source's mathlib.
-- Convenient for falloff curves.
-- @param number halflife
-- @param number dt
-- @return number
-- @realm shared
function math.ExponentialDecay(halflife, dt)
	-- ln(0.5) = -0.69..
	return exp((-0.69314718 / halflife) * dt)
end

---
-- Debugging function
-- @param number level required level
-- @param any ... anything that should be printed
-- @realm shared
function Dev(level, ...)
	if not cvars or cvars.Number("developer", 0) < level then return end

	Msg("[TTT dev]")
	-- table.concat does not tostring, derp

	local params = {...}

	for i = 1, #params do
		Msg(" " .. tostring(params[i]))
	end

	Msg("\n")
end

---
-- A simple check whether an @{Entity} is a valid @{Player}
-- @param Entity ent
-- @return boolean
-- @realm shared
function IsPlayer(ent)
	return ent and IsValid(ent) and ent:IsPlayer()
end

---
-- A simple check whether an @{Entity} is a valid ragdoll
-- @param Entity ent
-- @return boolean
-- @realm shared
function IsRagdoll(ent)
	return ent and IsValid(ent) and ent:GetClass() == "prop_ragdoll"
end

local band = bit.band

---
-- Sets the bit of a given value
-- @param number|table val
-- @param number|string bit2
-- @return boolean
-- @realm shared
function util.BitSet(val, bit2)
	if istable(val) then
		return items.TableHasItem(val, bit2)
	end

	return band(val, bit2) == bit2
end

if CLIENT then
	local healthcolors = {
		healthy = Color(0, 255, 0, 255),
		hurt = Color(170, 230, 10, 255),
		wounded = Color(230, 215, 10, 255),
		badwound = Color(255, 140, 0, 255),
		death = Color(255, 0, 0, 255)
	}

	---
	-- Checks whether a given position is on screen
	-- @param table scrpos table with x and y attributes
	-- @return boolean
	-- @realm client
	function IsOffScreen(scrpos)
		return not scrpos.visible or scrpos.x < 0 or scrpos.y < 0 or scrpos.x > ScrW() or scrpos.y > ScrH()
	end

	---
	-- Creates a @{string} based on the given health and maxhealth
	-- @param number health
	-- @param number maxhealth
	-- @return string
	-- @realm client
	function util.HealthToString(health, maxhealth)
		maxhealth = maxhealth or 100

		if health > maxhealth * 0.9 then
			return "hp_healthy", healthcolors.healthy
		elseif health > maxhealth * 0.7 then
			return "hp_hurt", healthcolors.hurt
		elseif health > maxhealth * 0.45 then
			return "hp_wounded", healthcolors.wounded
		elseif health > maxhealth * 0.2 then
			return "hp_badwnd", healthcolors.badwound
		else
			return "hp_death", healthcolors.death
		end
	end

	local karmacolors = {
		max = COLOR_WHITE,
		high = Color(255, 240, 135, 255),
		med = Color(245, 220, 60, 255),
		low = Color(255, 180, 0, 255),
		min = Color(255, 130, 0, 255),
	}

	---
	-- Creates a @{string} based on the given karma and the ttt_karma_max cvar
	-- @param number karma
	-- @return string
	-- @realm client
	function util.KarmaToString(karma)
		local maxkarma = GetGlobalInt("ttt_karma_max", 1000)

		if karma > maxkarma * 0.89 then
			return "karma_max", karmacolors.max
		elseif karma > maxkarma * 0.8 then
			return "karma_high", karmacolors.high
		elseif karma > maxkarma * 0.65 then
			return "karma_med", karmacolors.med
		elseif karma > maxkarma * 0.5 then
			return "karma_low", karmacolors.low
		else
			return "karma_min", karmacolors.min
		end
	end

	---
	-- Draws a filtered textured rectangle / image / icon
	-- @param number x
	-- @param number y
	-- @param number w width
	-- @param number h height
	-- @param Material material
	-- @param number alpha
	-- @param Color col the alpha value will be ignored
	-- @deprecated draw.FilteredTexture should be used instead
	-- @realm client
	-- @author Mineotopia
	function util.DrawFilteredTexturedRect(x, y, w, h, material, alpha, col)
		--print("[TTT2][DEPRECATION][util.DrawFilteredTexturedRect] draw.FilteredTexture should be used instead")

		draw.FilteredTexture(x, y, w, h, material, alpha, col)
	end
end

---
-- Includes a file for a client
-- @param string file path
-- @realm shared
function util.IncludeClientFile(file)
	if CLIENT then
		include(file)
	else
		AddCSLuaFile(file)
	end
end

---
-- Like @{string.FormatTime} but simpler (and working), always a string, no hour support
-- @param number seconds
-- @param string fmt the <a href="https://wiki.garrysmod.com/page/string/format">format</a>
function util.SimpleTime(seconds, fmt)
	if not seconds then
		seconds = 0
	end

	local ms = (seconds - math.floor(seconds)) * 100

	seconds = math.floor(seconds)

	local s = seconds % 60

	seconds = (seconds - s) / 60

	local m = seconds % 60

	return string.format(fmt, m, s, ms)
end

---
-- When overwriting a gamefunction, the old one has to be cached in order to still use it.
-- This creates an infinite recursion problem (stack overflow). Registering the function with
-- this helper function fixes the problem.
-- @param string name The name of the original function
-- @return Function The pointer to the original functions
-- @realm shared
function util.OverwriteFunction(name)
	local str = string.Split(name, ".")

	if not _G[name .. "_backup"] then
		if #str == 1 then
			_G[name .. "_backup"] = _G[str[1]]
		elseif #str == 2 then
			_G[name .. "_backup"] = _G[str[1]][str[2]]
		end
	end

	return _G[name .. "_backup"]
end
