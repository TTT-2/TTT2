---
-- A bunch of random function bundled in the util module
-- @author Mineotopia
-- @author LeBroomer
-- @author Alf21
-- @author tkindanight
-- @module util

if SERVER then
    AddCSLuaFile()
end

local band = bit.band
local IsValid = IsValid
local isfunction = isfunction
local VectorRand = VectorRand
local HSVToColor = HSVToColor

local playerGetAll = player.GetAll
local stringSplit = string.Split
local tableConcat = table.concat
local weaponsGetStored = weapons.GetStored
local sentsGetStored = scripted_ents.GetStored
local sentsGet = scripted_ents.Get

local mathMax = math.max
local mathMin = math.min
local mathClamp = math.Clamp
local mathRound = math.Round
local mathFloor = math.floor

---
-- Attempts to get the weapon used from a DamageInfo instance needed because the
-- GetAmmoType value is useless and inflictor isn't properly set (yet)
-- @param CTakeDamageInfo dmg
-- @return Weapon
-- @realm shared
function util.WeaponFromDamage(dmg)
    local inf = dmg:GetInflictor()
    local wep = nil

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
    local wep = weaponsGetStored(cls)

    if not wep then
        wep = sentsGetStored(cls)
        if wep then
            -- don't like to rely on this, but the alternative is
            -- sentsGet which does a full table copy, so only do
            -- that as last resort
            wep = wep.t or sentsGet(cls)
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
    local plys = playerGetAll()

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
    local plys = playerGetAll()
    local tmp = {}

    for i = 1, #plys do
        local ply = plys[i]

        if ply:Alive() and ply:IsTerror() then
            tmp[#tmp + 1] = ply
        end
    end

    return tmp
end

---
-- Returns the next available @{Player} based on the given @{Player} in the global list
-- @param Player ply
-- @return Player
-- @realm shared
function util.GetNextAlivePlayer(ply)
    local alive = util.GetAlivePlayers()
    if #alive < 1 then
        return
    end

    if IsValid(ply) then
        local prev = nil

        for i = 1, #alive do
            if prev == ply then
                return alive[i]
            end

            prev = alive[i]
        end
    end

    return alive[1]
end

---
-- Returns the list of active @{Player}s that are not forced spectators
-- @return table List of active @{Player}s
-- @realm shared
function util.GetActivePlayers()
    return util.GetFilteredPlayers(function(ply)
        return IsValid(ply) and not ply:GetForceSpec()
    end)
end

---
-- Returns the previous available @{Player} based on the given @{Player} in the global list
-- @param Player ply
-- @return Player
-- @realm shared
function util.GetPreviousAlivePlayer(ply)
    local alive = util.GetAlivePlayers()
    if #alive < 1 then
        return
    end

    if IsValid(ply) then
        local prev = nil

        for i = #alive, 1, -1 do
            if prev == ply then
                return alive[i]
            end

            prev = alive[i]
        end
    end

    return alive[#alive]
end

---
-- Darkens a given @{Color} value
-- @param Color color The original color value
-- @param number value The value to darken the color [0..255]
-- @return Color The darkened color
-- @realm shared
function util.ColorDarken(color, value)
    value = mathClamp(value, 0, 255)

    return Color(
        mathMax(color.r - value, 0),
        mathMax(color.g - value, 0),
        mathMax(color.b - value, 0),
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
    value = mathClamp(value, 0, 255)

    return Color(
        mathMin(color.r + value, 255),
        mathMin(color.g + value, 255),
        mathMin(color.b + value, 255),
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
-- @param Color color background color
-- @return Color The color based on the background color
-- @realm shared
function util.GetDefaultColor(color)
    if color.r + color.g + color.b < 500 then
        return COLOR_WHITE
    else
        return COLOR_BLACK
    end
end

---
-- Returns the darkened or lightened color by the specified value
-- @param Color color The original color
-- @param number value The amount to change
-- @return Color The color based on the original color
-- @realm shared
function util.GetChangedColor(color, value)
    if color.r + color.g + color.b < 383 then
        return util.ColorLighten(color, value or 20)
    else
        return util.ColorDarken(color, value or 20)
    end
end

---
-- Returns a hovercolor which is just a lightened or darkened color based
-- on the sourcecolor
-- @param Color color The original color
-- @return Color The color based on the original color
-- @realm shared
function util.GetHoverColor(color)
    return util.GetChangedColor(color, 20)
end

---
-- Returns a activecolor which is just a lightened or darkened color based
-- on the sourcecolor
-- @param Color color The original color
-- @return Color The color based on the original color
-- @realm shared
function util.GetActiveColor(color)
    return util.GetChangedColor(color, 40)
end

local function DoBleed(ent)
    if not IsValid(ent) or (ent:IsPlayer() and (not ent:Alive() or not ent:IsTerror())) then
        return
    end

    local jitter = VectorRand() * 30
    jitter.z = 20

    util.PaintDown(ent:GetPos() + jitter, "Blood", ent)
end

---
-- Creates a color based on a given input string.
-- @param string str The input string, can be any text
-- @return Color The created color
-- @realm shared
function util.StringToColor(str)
    local hash = 0

    for i = 1, #str do
        hash = string.byte(str, i) + bit.lshift(hash, 8 - i) - hash
    end

    local r = bit.band(bit.rshift(hash, 16), 0xFF)
    local g = bit.band(bit.rshift(hash, 8), 0xFF)
    local b = bit.band(hash, 0xFF)

    return Color(r, g, b)
end

---
-- Something hurt us, start bleeding for a bit depending on the amount
-- @param Entity ent
-- @param CTakeDamageInfo dmg
-- @param number t times
-- @realm shared
-- @todo improve description
function util.StartBleeding(ent, dmg, t)
    if
        dmg < 5
        or not IsValid(ent)
        or ent:IsPlayer() and (not ent:Alive() or not ent:IsTerror())
    then
        return
    end

    local times = mathClamp(mathRound(dmg / 15), 1, 20)
    local delay = mathClamp(t / times, 0.1, 2)

    if ent:IsPlayer() then
        times = times * 2
        delay = delay * 0.5
    end

    timer.Create("bleed" .. ent:EntIndex(), delay, times, function()
        if not IsValid(ent) then
            return
        end

        DoBleed(ent)
    end)
end

---
-- Stops the bleeding effect
-- @param Entity ent
-- @realm shared
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
-- @param KEY kc key
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
-- @see util.passthrough
function util.noop() end

---
-- Just a passthrough @{function} that is doing NOTHING but returning the given value
-- @param any x
-- @return any the same as the given x
-- @realm shared
-- @see util.noop
function util.passthrough(x)
    return x
end

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
-- @param string fmt the <a href="https://wiki.facepunch.com/gmod/string.format">format</a>
-- @return string
-- @realm shared
function util.SimpleTime(seconds, fmt)
    if not seconds then
        seconds = 0
    end

    local ms = (seconds - mathFloor(seconds)) * 100

    seconds = mathFloor(seconds)

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
-- @return function The pointer to the original functions
-- @realm shared
function util.OverwriteFunction(name)
    local str = stringSplit(name, ".")

    if not _G[name .. "_backup"] then
        if #str == 1 then
            _G[name .. "_backup"] = _G[str[1]]
        elseif #str == 2 then
            _G[name .. "_backup"] = _G[str[1]][str[2]]
        end
    end

    return _G[name .. "_backup"]
end

---
-- Returns the file name by removing the file ending.
-- @param string name The file name with file ending
-- @return string The file name without file ending
-- @realm shared
function util.GetFileName(name)
    local splitString = stringSplit(name, ".")

    return tableConcat(splitString, ".", 1, #splitString - 1)
end

---
-- Uppercases the first character only.
-- @param string str
-- @return string
-- @realm shared
-- @see string.Capitalize
-- @function util.Capitalize(str)
util.Capitalize = string.Capitalize

---
-- Checks if the provided team is an evil team. By default all non innocents that aren't
-- `TEAM_NONE` are included.
-- @param string team The team that should be tested
-- @return boolean Returns if a team is evil
-- @realm shared
function util.IsEvilTeam(team)
    -- players without a team are counted as neutral
    if not team or team == TEAM_NONE then
        return false
    end

    -- all non inno roles are counted as evil
    return team ~= TEAM_INNOCENT
end

---
-- Checks whether a given vector is in bounds of the two other vectors.
-- @param Vector vec The vector that is checked
-- @param Vector lowerBound The lower bound vector
-- @param Vector upperBound The upper bound vector
-- @return boolean Returns true if the vector is bounded
-- @realm shared
function util.VectorInBounds(vec, lowerBound, upperBound)
    return vec.x > lowerBound.x
        and vec.x < upperBound.x
        and vec.y > lowerBound.y
        and vec.y < upperBound.y
        and vec.z > lowerBound.z
        and vec.z < upperBound.z
end

---
-- Adjusts a numeric value from one range to a different one in a relative transformation.
-- @param number value The value that should be mapped
-- @param number minValue The minimum value that 'value' can have
-- @param number maxValue The maximum value that 'value' can have
-- @param number minTargetValue The minimum value that the mapped value can have
-- @param number maxTargetValue The maximum value that the mapped value can have
-- @realm shared
function util.TransformToRange(value, minValue, maxValue, minTargetValue, maxTargetValue)
    value = mathMax(minValue, mathMin(maxValue, value))

    return minTargetValue
        + (maxTargetValue - minTargetValue) * (value - minValue) / (maxValue - minValue)
end

---
-- This is a helper function that checks if any of the current edit modes is active
-- that has to be left by pressing F1.
-- @param Player ply The player who might be editing
-- @return boolean Returns if an editing mode is active
-- @note Due to how the edit modes are implemented, some checks might only work in the client
-- realm. So make sure to check it not only on the server.
-- @realm shared
function util.EditingModeActive(ply)
    return (HUDEditor and HUDEditor.IsEditing) or entspawnscript.IsEditing(ply)
end

---
-- Converts hammer units to meters.
-- @param number value The value in hammer units
-- @return number The converted value in meters
-- @realm shared
-- @deprecated util.InchesToMeters should be used instead
function util.HammerUnitsToMeters(value)
    return util.InchesToMeters(value)
end

---
-- Converts inches to meters.
-- @param number value The value in inches
-- @return number The converted value in meters
-- @realm shared
function util.InchesToMeters(value)
    return value * 0.0254
end

---
-- Converts inches to yards.
-- @param number value The value in inches
-- @return number The converted value in yards
-- @realm shared
function util.InchesToYards(value)
    return value / 36
end

---
-- Converts inches to feet.
-- @param number value The value in inches
-- @return number The converted value in feet
-- @realm shared
function util.InchesToFeet(value)
    return value / 12
end

if CLIENT then
    ---
    -- @realm client
    local cvDistanceUnit = CreateConVar(
        "ttt2_distance_unit",
        "1",
        FCVAR_ARCHIVE,
        "Preferred unit of length (0 = inches, 1 = meters, 2 = yards, 3 = feet)"
    )

    local paramsLength = {}

    ---
    -- Produces a @{string} out of a length value based on the user's preferred unit of length.
    -- @param number value The length value in inches
    -- @param number decimals The decimal places to round to
    -- @return string The converted value with unit symbol as a text string
    -- @realm client
    function util.DistanceToString(value, decimals)
        local unit = cvDistanceUnit:GetInt()

        if unit == 1 then
            paramsLength.length = math.Round(util.InchesToMeters(value), decimals)

            return LANG.GetParamTranslation("length_in_meters", paramsLength)
        elseif unit == 2 then
            paramsLength.length = math.Round(util.InchesToYards(value), decimals)

            return LANG.GetParamTranslation("length_in_yards", paramsLength)
        elseif unit == 3 then
            paramsLength.length = math.Round(util.InchesToFeet(value), decimals)

            return LANG.GetParamTranslation("length_in_feet", paramsLength)
        end

        return tostring(math.Round(value))
    end

    local colorsHealth = {
        healthy = Color(0, 255, 0, 255),
        hurt = Color(170, 230, 10, 255),
        wounded = Color(230, 215, 10, 255),
        badwound = Color(255, 140, 0, 255),
        death = Color(255, 0, 0, 255),
    }

    ---
    -- Checks whether a given position is on screen
    -- @param table scrpos table with x and y attributes
    -- @return boolean
    -- @realm client
    function util.IsOffScreen(scrpos)
        return not scrpos.visible
            or scrpos.x < 0
            or scrpos.y < 0
            or scrpos.x > ScrW()
            or scrpos.y > ScrH()
    end

    -- Backward compatibility
    IsOffScreen = util.IsOffScreen

    ---
    -- Creates a @{string} based on the given health and maxhealth
    -- @param number health
    -- @param number maxhealth
    -- @return string
    -- @realm client
    function util.HealthToString(health, maxhealth)
        maxhealth = maxhealth or 100

        if health > maxhealth * 0.9 then
            return "hp_healthy", colorsHealth.healthy
        elseif health > maxhealth * 0.7 then
            return "hp_hurt", colorsHealth.hurt
        elseif health > maxhealth * 0.45 then
            return "hp_wounded", colorsHealth.wounded
        elseif health > maxhealth * 0.2 then
            return "hp_badwnd", colorsHealth.badwound
        else
            return "hp_death", colorsHealth.death
        end
    end

    local colorsKarma = {
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
            return "karma_max", colorsKarma.max
        elseif karma > maxkarma * 0.8 then
            return "karma_high", colorsKarma.high
        elseif karma > maxkarma * 0.65 then
            return "karma_med", colorsKarma.med
        elseif karma > maxkarma * 0.5 then
            return "karma_low", colorsKarma.low
        else
            return "karma_min", colorsKarma.min
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
        draw.FilteredTexture(x, y, w, h, material, alpha, col)
    end

    ---
    -- Checks recursively the parents until none is found and the highest parent is returned
    -- @ignore
    function util.getHighestPanelParent(panel)
        local parent = panel
        local checkParent = panel:GetParent()

        while ispanel(checkParent) do
            parent = checkParent
            checkParent = parent:GetParent()
        end

        return parent
    end

    ---
    -- Generates a table of choices for PANEL:MakeComboBox from the string keys of a table.
    -- @param table tbl A table where the keys are strings of all available choices
    -- @param string labelPrefix The prefix for all label translations, keys will be appended to this
    -- @param string default The default key value that should be selected
    -- @return table A choices table to be consumed by PANEL:MakeComboBox
    -- @realm client
    function util.ComboBoxChoicesFromKeys(tbl, labelPrefix, default)
        local choices = {}
        for key in pairs(tbl) do
            choices[#choices + 1] = {
                title = LANG.TryTranslation(labelPrefix .. key),
                value = key,
                select = key == default,
            }
        end
        return choices
    end
end
