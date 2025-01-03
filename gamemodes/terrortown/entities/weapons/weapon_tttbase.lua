---
-- @class SWEP
-- @desc Custom weapon base, used to derive from CS one, still very similar.
-- See <a href="https://wiki.facepunch.com/gmod/Weapon">Weapon</a>
-- @section weapon_tttbase

local math = math
local table = table
local util = util
local IsValid = IsValid
local surface = surface
local draw = draw

local weaponMetaTable = FindMetaTable("Weapon")

if SERVER then
    AddCSLuaFile()
end

if CLIENT then
    -- hud help font
    surface.CreateAdvancedFont(
        "weapon_hud_help",
        { font = "Tahoma", size = 16, weight = 600, extended = true }
    )
    surface.CreateAdvancedFont(
        "weapon_hud_help_key",
        { font = "Tahoma", size = 13, weight = 1200, extended = true }
    )
end

--   TTT SPECIAL EQUIPMENT FIELDS

-- This must be set to one of the WEAPON_ types in TTT weapons for weapon
-- carrying limits to work properly. See /gamemode/shared.lua for all possible
-- weapon categories.
SWEP.Kind = WEAPON_NONE

-- If CanBuy is a table that contains ROLE_TRAITOR and/or ROLE_DETECTIVE, those
-- players are allowed to purchase it and it will appear in their Equipment Menu
-- for that purpose. If CanBuy is nil this weapon cannot be bought.
--	Example: SWEP.CanBuy = { ROLE_TRAITOR }
-- (just setting to nil here to document its existence, don't make this buyable)
SWEP.CanBuy = nil

-- By default a weapon is buyable. Set this to true if the weapon should not be buyable.
SWEP.notBuyable = false

if CLIENT then
    -- If this is a buyable weapon (ie. CanBuy is not nil) EquipMenuData must be
    -- a table containing some information to show in the Equipment Menu. See
    -- default equipment weapons for real-world examples.
    SWEP.EquipMenuData = nil

    -- Example data:
    -- SWEP.EquipMenuData = {
    --
    --   Type tells players if it's a weapon or item
    --	 type = "Weapon",
    --
    --   Desc is the description in the menu. Needs manual linebreaks (via \n).
    --	 desc = "Text."
    -- }

    -- This sets the icon shown for the weapon in the DNA sampler, search window,
    -- equipment menu (if buyable), etc.
    SWEP.Icon = "vgui/ttt/icon_nades" -- most generic icon I guess

    -- You can make your own weapon icon using the template in:
    --	/garrysmod/gamemodes/terrortown/template/

    -- Open one of TTT's icons with VTFEdit to see what kind of settings to use
    -- when exporting to VTF. Once you have a VTF and VMT, you can
    -- resource.AddFile("materials/vgui/...") them here. GIVE YOUR ICON A UNIQUE
    -- FILENAME, or it WILL be overwritten by other servers! Gmod does not check
    -- if the files are different, it only looks at the name. I recommend you
    -- create your own directory so that this does not happen,
    -- eg. /materials/vgui/ttt/mycoolserver/mygun.vmt

    -- Set this to true ONLY if a weapon uses CS:S viewmodels that fail to recenter after firing.
    -- Also requires SWEP.IdleAnim to be set to the appropriate animation, usually ACT_VM_IDLE or ACT_VM_IDLE_SILENCED.
    SWEP.idleResetFix = false

    -- It set to true, hands are drawn in the view model
    SWEP.UseHands = false

    -- If set to true, the default world model of the weapon is drawn. If set to false
    -- the hands are still drawn in the position of the SWEP.HoldType.
    SWEP.ShowDefaultWorldModel = true

    -- If set to true, the default view model of the weapon is drawn, otherwise it
    -- is hidden and no view model is drawn. Set SWEP.UseHands to true to only hide
    -- the weapon but still draw the hands holding it.
    SWEP.ShowDefaultViewModel = true
end

--   MISC TTT-SPECIFIC BEHAVIOUR CONFIGURATION

-- ALL weapons in TTT must have weapon_tttbase as their SWEP.Base. It provides
-- some functions that TTT expects, and you will get errors without them.
-- Of course this is weapon_tttbase itself, so I comment this out here.
--	SWEP.Base = "weapon_tttbase"

-- If true AND SWEP.Kind is not WEAPON_EQUIP, then this gun can be spawned as
-- random weapon by a ttt_random_weapon entity.
SWEP.AutoSpawnable = false

-- Set to one of the WEAPON_TYPE_ flags to define on which spawn this waeapon should
-- spawn. The flag AutoSpawnable has to be true to make this weapon spawnable on
-- the map.
SWEP.spawnType = nil

-- Set to true if weapon can be manually dropped by players (with Q)
SWEP.AllowDrop = true

-- Set to true if weapon kills silently (no death scream)
SWEP.IsSilent = false

-- Set this to a number greater than 0 if you want to autospawn random ammo
-- in close proximity to this weapon when spawned.
SWEP.autoAmmoAmount = 0

-- It this is set to true, there will be no pickup notification when receiving this weapon.
SWEP.silentPickup = false

-- Set Keys like { "HeadshotMultiplier", "Weight", { "Primary", "Recoil" }, { "Secondary", "Ammo" } } if you want the data to be persistent after hotreloads
-- Empty it before a hotreload to reset data after a hotreload, otherwise this data keep persisting until you do a map reload or restart your server
-- Can be useful if you have multiple instances, that rely on global variables stored via weapons.GetStored()
SWEP.HotReloadableKeys = {}

-- Set this to true if the weapon should have a custom clip size on buy that can be set in the equipment editor
SWEP.EnableConfigurableClip = false

-- The default clip on buy if `SWEP.EnableConfigurableClip` is set to true
SWEP.ConfigurableClip = 1

-- If this weapon should be given to players upon spawning, set a table of the
-- roles this should happen for here
--	SWEP.InLoadoutFor = {ROLE_TRAITOR, ROLE_DETECTIVE, ROLE_INNOCENT}
-- use the Initialize hook to be able to use custom ROLE_XXX vars

-- DO NOT set SWEP.WeaponID. Only the standard TTT weapons can have it. Custom
-- SWEPs do not need it for anything.
--	SWEP.WeaponID = nil

--   YE OLDE SWEP STUFF

if CLIENT then
    SWEP.DrawCrosshair = false
    SWEP.ViewModelFOV = 82
    SWEP.ViewModelFlip = true
    SWEP.CSMuzzleFlashes = true
end

SWEP.Base = "weapon_base"

SWEP.Category = "TTT"
SWEP.Spawnable = false

SWEP.IsGrenade = false

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Primary.Sound = Sound("Weapon_Pistol.Empty")
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Damage = 1
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = 0.15

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipMax = -1

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipMax = -1

SWEP.HeadshotMultiplier = 2.7

SWEP.DryFireSound = ")weapons/pistol/pistol_empty.wav"

SWEP.StoredAmmo = 0
SWEP.IsDropped = false

SWEP.DeploySpeed = 1.4

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD
SWEP.IdleAnim = ACT_VM_IDLE

SWEP.fingerprints = {}

--[[
    -- The position offset applied when entering the ironsight
    SWEP.IronSightsPos = Vector(0, 0, 0)
    -- The rotational offset applied when entering the ironsight
    SWEP.IronSightsAng = Vector(0, 0, 0)
--]]

local skipWeapons = {}

---
-- Checks if the weapon should be skipped. Skips all weapons not based on weapon_tttbase
-- @param Weapon swep the weapon to check
-- @realm shared
-- @internal
local function shouldSkipWeapon(swep)
    local className = swep:GetClass()
    local skipWeapon = skipWeapons[className]

    if skipWeapon == nil then
        skipWeapon = not weapons.IsBasedOn(className, "weapon_tttbase")
        skipWeapons[className] = skipWeapon
    end

    return skipWeapon
end

-- The original Remove is not saved in the weaponMetaTable, it only exists on Entity.
local oldRemove = FindMetaTable("Entity").Remove

---
-- This changes the function Remove of all weapons, but only affects ones that implement ShouldRemove
-- This enables changing weapon drop behavior against a convention of being removed
-- @param any ... A variable amount of arguments passed to this event
-- @realm shared
function weaponMetaTable:Remove(...)
    if self.ShouldRemove and isfunction(self.ShouldRemove) then
        local res = self:ShouldRemove(...)
        if not res then
            return res
        end
    end

    return oldRemove(self, ...)
end

-- The original SetNextPrimaryFire saved in the weaponMetaTable
local oldSetNextPrimaryFire = weaponMetaTable.SetNextPrimaryFire
local tickInterval = engine.TickInterval()

---
-- This changes the function SetNextPrimaryFire of all weapons, but filters out all weapons not based on the weapon_tttbase
-- This compensates for weapons not having the same timesteps as the serverside-tickrate, which otherwise would lead to a lower firerate on average
-- @param number nextTime The time you want to have the next primary attack available
-- @param[opt] boolean skipTickrateFix If you want to use the old function and just SetNextPrimaryFire without Tickrate Fix
-- @realm shared
function weaponMetaTable:SetNextPrimaryFire(nextTime, skipTickrateFix)
    if not skipTickrateFix and not shouldSkipWeapon(self) then
        local diff = CurTime() - self:GetNextPrimaryFire()

        if diff > 0 and diff < tickInterval then
            nextTime = nextTime - diff
        end
    end

    oldSetNextPrimaryFire(self, nextTime)
end

---
-- @realm client
local sparkle = CLIENT
        and CreateConVar(
            "ttt_crazy_sparks",
            "0",
            FCVAR_ARCHIVE,
            "Toggles whether the `cball_bounce` Effect should get triggered on the hit position"
        )
    or nil

---
-- @realm client
local ttt2_hold_aim = CLIENT
        and CreateConVar(
            "ttt2_hold_aim",
            0,
            FCVAR_ARCHIVE,
            "Toogles whether you have to hold the key to aim",
            0,
            1
        )
    or nil

-- crosshair
if CLIENT then
    local TryT = LANG.TryTranslation
    local ParT = LANG.GetParamTranslation

    local mathRound = math.Round
    local mathClamp = math.Clamp
    local mathCeil = math.ceil
    local mathMax = math.max

    local CROSSHAIR_MODE_DOT_AND_LINES = 0
    local CROSSHAIR_MODE_LINES_ONLY = 1
    local CROSSHAIR_MODE_DOT_ONLY = 2

    ---
    -- @realm client
    local cvOpacitySights = CreateConVar("ttt_ironsights_crosshair_opacity", "0.8", FCVAR_ARCHIVE)

    ---
    -- @realm client
    local cvSizeLineCrosshair = CreateConVar("ttt_crosshair_size", "1.0", FCVAR_ARCHIVE)

    ---
    -- @realm client
    local cvSizeGapCrosshair = CreateConVar("ttt_crosshair_size_gap", "1.0", FCVAR_ARCHIVE)

    ---
    -- @realm client
    local cvEnableCrosshair = CreateConVar("ttt_enable_crosshair", "1", FCVAR_ARCHIVE)

    ---
    -- @realm client
    local cvOpacityCrosshair = CreateConVar("ttt_crosshair_opacity", "1", FCVAR_ARCHIVE)

    ---
    -- @realm client
    local cvCrosshairUseWeaponscale = CreateConVar("ttt_crosshair_weaponscale", "1", FCVAR_ARCHIVE)

    ---
    -- @realm client
    local cvCrosshairStaticLength = CreateConVar("ttt_crosshair_static_length", "0", FCVAR_ARCHIVE)

    ---
    -- @realm client
    local cvCrosshairStaticGapLength =
        CreateConVar("ttt_crosshair_static_gap_length", "0", FCVAR_ARCHIVE)

    ---
    -- @realm client
    local cvThicknessCrosshair = CreateConVar("ttt_crosshair_thickness", "1", FCVAR_ARCHIVE)

    ---
    -- @realm client
    local cvEnableOutlineCrosshair =
        CreateConVar("ttt_crosshair_outline_enable", "0", FCVAR_ARCHIVE)

    ---
    -- @realm client
    local cvThicknessOutlineCrosshair =
        CreateConVar("ttt_crosshair_outline_thickness", "1", FCVAR_ARCHIVE)

    ---
    -- @realm client
    local cvHighContrastOutlineCrosshair =
        CreateConVar("ttt_crosshair_outline_high_contrast", "0", FCVAR_ARCHIVE)

    ---
    -- @realm client
    local cvCrosshairMode = CreateConVar("ttt_crosshair_mode", "0", FCVAR_ARCHIVE)

    local cvEnableHUDBoxBlur = GetConVar("ttt2_hud_enable_box_blur")

    local materialKeyLMB = Material("vgui/ttt/hudhelp/lmb")
    local materialKeyRMB = Material("vgui/ttt/hudhelp/rmb")

    local animData = {
        timeStart = 0,
        timeEnd = 0,
        valueStart = 0,
        valueEnd = 0,
    }

    ---
    -- @see https://wiki.facepunch.com/gmod/WEAPON:DrawHUD
    -- @realm client
    function SWEP:DrawHUD()
        if self.HUDHelp then
            self:DrawHelp()
        end

        self:DoDrawCrosshair(mathCeil(ScrW() * 0.5), mathCeil(ScrH() * 0.5), true)
    end

    ---
    -- Called when the crosshair is about to get drawn, and allows you to override it.
    -- @note This is a hook that is used to draw the crosshair. We use the function to prevent
    -- the crosshair from being drawn and then use the same hook to draw our own custom
    -- crosshair. The third parameter has therefore be set to true if the crosshair should
    -- actually be drawn, otherwise the function only returns true to prevent the default one.
    -- @param number xCenter The x center position of the crosshair
    -- @param number yCenter The y center position of the crosshair
    -- @param boolean shouldDraw Should the crosshair be drawn
    -- @return boolean Return true to prevent the default crosshair from being drawn
    -- @ref https://wiki.facepunch.com/gmod/WEAPON:DoDrawCrosshair
    -- @hook
    -- @realm client
    function SWEP:DoDrawCrosshair(xCenter, yCenter, shouldDraw)
        if not shouldDraw or not cvEnableCrosshair:GetBool() then
            return true
        end

        local client = LocalPlayer()
        local sights = not self.NoSights and self:GetIronsights()

        local scale = appearance.GetGlobalScale()
        local baseConeWeapon = mathMax(0.2, 10 * self:GetPrimaryConeBase())
        local scaleWeapon = cvCrosshairUseWeaponscale:GetBool()
                and math.max(0.2, 10 * self:GetPrimaryCone())
            or 1
        local timescale = 2 - mathClamp((CurTime() - self:LastShootTime()) * 5, 0.0, 1.0)

        -- handle size animation
        if scaleWeapon ~= animData.valueEnd then
            animData = {
                timeStart = CurTime(),
                timeEnd = CurTime() + 0.25,
                valueStart = animData.valueEnd,
                valueEnd = scaleWeapon,
            }
        end

        scaleWeapon = Lerp(
            math.ease.OutQuint(math.TimeFraction(animData.timeStart, animData.timeEnd, CurTime())),
            animData.valueStart,
            animData.valueEnd
        )

        local alpha = sights and cvOpacitySights:GetFloat() or cvOpacityCrosshair:GetFloat()
        local thicknessLine = mathCeil(cvThicknessCrosshair:GetFloat() * scale)
        local thicknessOutline = mathCeil(cvThicknessOutlineCrosshair:GetFloat() * scale)
        local gap = mathCeil(
            25
                * cvSizeGapCrosshair:GetFloat()
                * (cvCrosshairStaticGapLength:GetBool() and baseConeWeapon or scaleWeapon * timescale)
                * scale
        )
        local lengthLine = mathCeil(
            gap
                + 25
                    * cvSizeLineCrosshair:GetFloat()
                    * (cvCrosshairStaticLength:GetBool() and baseConeWeapon or scaleWeapon * timescale)
                    * scale
        )
        local offsetLine = mathCeil(thicknessLine * 0.5)

        -- set up crosshair color
        local color = appearance.SelectFocusColor(
            client.GetRoleColor and client:GetRoleColor() or roles.INNOCENT.color
        )
        local colorOutline = cvHighContrastOutlineCrosshair:GetBool()
                and util.GetDefaultColor(color)
            or COLOR_BLACK

        -- draw crosshair dot
        if
            cvCrosshairMode:GetInt() == CROSSHAIR_MODE_DOT_AND_LINES
            or cvCrosshairMode:GetInt() == CROSSHAIR_MODE_DOT_ONLY
        then
            local xDot = xCenter - offsetLine
            local yDot = yCenter - offsetLine

            if cvEnableOutlineCrosshair:GetBool() then
                surface.SetDrawColor(
                    colorOutline.r,
                    colorOutline.g,
                    colorOutline.b,
                    colorOutline.a * alpha
                )

                surface.DrawRect(
                    xDot - thicknessOutline,
                    yDot - thicknessOutline,
                    thicknessLine + thicknessOutline * 2,
                    thicknessLine + thicknessOutline * 2
                )
            end

            surface.SetDrawColor(color.r, color.g, color.b, color.a * alpha)

            surface.DrawRect(xDot, yDot, thicknessLine, thicknessLine)
        end

        -- draw crosshair lines
        if
            cvCrosshairMode:GetInt() == CROSSHAIR_MODE_DOT_AND_LINES
            or cvCrosshairMode:GetInt() == CROSSHAIR_MODE_LINES_ONLY
        then
            if cvEnableOutlineCrosshair:GetBool() then
                surface.SetDrawColor(
                    colorOutline.r,
                    colorOutline.g,
                    colorOutline.b,
                    colorOutline.a * alpha
                )

                surface.DrawRect(
                    xCenter - lengthLine - thicknessOutline,
                    yCenter - offsetLine - thicknessOutline,
                    lengthLine - gap + thicknessOutline * 2,
                    thicknessLine + thicknessOutline * 2
                )
                surface.DrawRect(
                    xCenter + gap - thicknessOutline,
                    yCenter - offsetLine - thicknessOutline,
                    lengthLine - gap + thicknessOutline * 2,
                    thicknessLine + thicknessOutline * 2
                )
                surface.DrawRect(
                    xCenter - offsetLine - thicknessOutline,
                    yCenter - lengthLine - thicknessOutline,
                    thicknessLine + thicknessOutline * 2,
                    lengthLine - gap + thicknessOutline * 2
                )
                surface.DrawRect(
                    xCenter - offsetLine - thicknessOutline,
                    yCenter + gap - thicknessOutline,
                    thicknessLine + thicknessOutline * 2,
                    lengthLine - gap + thicknessOutline * 2
                )
            end

            surface.SetDrawColor(color.r, color.g, color.b, color.a * alpha)

            surface.DrawRect(
                xCenter - lengthLine,
                yCenter - offsetLine,
                lengthLine - gap,
                thicknessLine
            )
            surface.DrawRect(xCenter + gap, yCenter - offsetLine, lengthLine - gap, thicknessLine)
            surface.DrawRect(
                xCenter - offsetLine,
                yCenter - lengthLine,
                thicknessLine,
                lengthLine - gap
            )
            surface.DrawRect(xCenter - offsetLine, yCenter + gap, thicknessLine, lengthLine - gap)
        end

        return true
    end

    local colorBox = Color(0, 0, 0, 100)
    local colorDarkBox = Color(0, 0, 0, 150)

    local sizeIcon = 16
    local padYKey = 3
    local padXKey = 5

    local function ProcessHelpText(lines, scale)
        local widthBinding, widthDescription = 0, 0
        local processedData = {}

        for i = 1, #lines do
            local line = lines[i]
            local binding = line.binding -- can be an icon or key
            local description = line.text

            local wBinding, hBinding = 0, 0
            local isIcon = false

            if isstring(binding) then
                -- attempt to translate binding in case it can be translated
                bindig = TryT(binding)

                local wKey, hKey = draw.GetTextSize(binding, "weapon_hud_help_key", scale)

                wBinding = wKey + 2 * padXKey * scale
                hBinding = hKey + 2 * padYKey * scale

                isIcon = false
            elseif binding then
                wBinding = sizeIcon * scale
                hBinding = sizeIcon * scale
                isIcon = true
            else
                continue
            end

            local translatedDescription = TryT(description)
            local wDescription = draw.GetTextSize(translatedDescription, "weapon_hud_help", scale)

            processedData[i] = {
                w = wBinding,
                h = hBinding,
                isIcon = isIcon,
                binding = binding,
                description = translatedDescription,
                wDescription = wDescription,
            }

            widthBinding = math.max(widthBinding, wBinding)
            widthDescription = math.max(widthDescription, wDescription)
        end

        return widthBinding, widthDescription, processedData
    end

    ---
    -- Draws the help text to the bottom of the screen
    -- @realm client
    function SWEP:DrawHelp()
        if not self.HUDHelp or not #self.HUDHelp.bindingLines then
            return
        end
        local scale = appearance.GetGlobalScale()

        local baseWidthBinding, baseWidthDescription, processedData =
            ProcessHelpText(self.HUDHelp.bindingLines, scale)

        local padding = 10 * scale
        local hLine = 23 * scale

        local wBox = baseWidthBinding + baseWidthDescription + 4 * padding
        local hBox = hLine * #processedData + 2 * padding
        local xBox = 0.5 * (ScrW() - wBox)
        local yBox = ScrH() - hBox
        local xDivider = xBox + baseWidthBinding + 2 * padding
        local yDividerStart = yBox + padding
        local yLine = yDividerStart + 10 * scale
        local xDescription = xDivider + padding

        if cvEnableHUDBoxBlur:GetBool() then
            draw.BlurredBox(xBox, yBox, wBox, hBox)
            draw.Box(xBox, yBox, wBox, hBox, colorBox) -- background color
            draw.Box(xBox, yBox, wBox, mathRound(1 * scale), colorBox) -- top line shadow
            draw.Box(xBox, yBox, wBox, mathRound(2 * scale), colorBox) -- top line shadow
            draw.Box(xBox, yBox - mathRound(2 * scale), wBox, mathRound(2 * scale), COLOR_WHITE) -- white top line
        end

        draw.ShadowedBox(
            xDivider,
            yDividerStart,
            mathRound(scale),
            hBox - 2 * padding,
            COLOR_WHITE,
            scale
        )

        for i = 1, #processedData do
            local line = processedData[i]

            local w = line.w
            local h = line.h
            local xBinding = xDivider - padding - w
            local yBinding = yLine - 0.5 * h

            if line.isIcon then
                draw.FilteredShadowedTexture(
                    xBinding,
                    yBinding,
                    w,
                    h,
                    line.binding,
                    255,
                    COLOR_WHITE,
                    scale
                )
            else
                draw.Box(xBinding, yBinding + 1, w, h, colorDarkBox)
                draw.OutlinedShadowedBox(xBinding, yBinding + 1, w, h, 1, COLOR_WHITE)

                draw.AdvancedText(
                    line.binding,
                    "weapon_hud_help_key",
                    xBinding + 0.5 * w,
                    yLine,
                    COLOR_WHITE,
                    TEXT_ALIGN_CENTER,
                    TEXT_ALIGN_CENTER,
                    true,
                    scale
                )
            end

            draw.AdvancedText(
                line.description,
                "weapon_hud_help",
                xDescription,
                yLine,
                COLOR_WHITE,
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_CENTER,
                true,
                scale
            )

            yLine = yLine + hLine
        end
    end

    -- mousebuttons are enough for most weapons
    local defaultKeyParams = {
        primaryfire = Key("+attack", "MOUSE1"),
        secondaryfire = Key("+attack2", "MOUSE2"),
        usekey = Key("+use", "USE"),
    }

    ---
    -- Adds a help text for the weapon to the HUD.
    -- @deprecated TTT legacy function. Do not use for new addons!
    -- @param[opt] string primary_text first line of the help text
    -- @param[optchain] string secondary_text second line of the help text
    -- @param[optchain][default=false] boolean translate should the text get translated
    -- @param[optchain] table extraKeyParams parameters for @{Lang.GetParamTranslation}
    -- @realm client
    function SWEP:AddHUDHelp(primary_text, secondary_text, translate, extraKeyParams)
        local primary = primary_text
        local secondary = secondary_text

        if translate then
            extraKeyParams = extraKeyParams or {}
            translate_params = table.Merge(extraKeyParams, defaultKeyParams)
            primary = primary and ParT(primary, translate_params)
            secondary = secondary and ParT(secondary, translate_params)
        end

        self:ClearHUDHelp()

        if primary then
            self:AddHUDHelpLine(primary, Key("+attack", "undefined_key"))
        end

        if secondary then
            self:AddHUDHelpLine(secondary, Key("+attack2", "undefined_key"))
        end
    end

    ---
    -- Adds a help text for the weapon to the HUD.
    -- @param[opt] string primary_text description for primaryfire
    -- @param[optchain] string secondary_text description for secondaryfire
    -- @realm client
    function SWEP:AddTTT2HUDHelp(primary, secondary)
        self:ClearHUDHelp()

        if primary then
            self:AddHUDHelpLine(primary, Key("+attack", "undefined_key"))
        end

        if secondary then
            self:AddHUDHelpLine(secondary, Key("+attack2", "undefined_key"))
        end
    end

    ---
    -- Utility for removing all existing help lines so more can be added.
    -- This can be useful for dynamically updating help text.
    -- @realm client
    function SWEP:ClearHUDHelp()
        self.HUDHelp = {
            bindingLines = {},
            max_length = 0,
        }
    end

    ---
    -- Adds an additional line to the help text.
    -- @{SWEP:AddTTT2HUDHelp} needs to be called first
    -- @param string text text to be displayed on the line
    -- @param[opt] Material|string materialOrBinding icon or description for the concerning key
    -- @realm client
    function SWEP:AddHUDHelpLine(text, materialOrBinding)
        if not self.HUDHelp then
            return
        end

        --replace MOUSE1/MOUSE2 strings with respective icons
        if isstring(materialOrBinding) then
            if materialOrBinding == "MOUSE1" then
                materialOrBinding = materialKeyLMB
            elseif materialOrBinding == "MOUSE2" then
                materialOrBinding = materialKeyRMB
            end
        end

        local width = draw.GetTextSize(text, "weapon_hud_help")

        self.HUDHelp.bindingLines[#self.HUDHelp.bindingLines + 1] =
            { text = text, binding = materialOrBinding }
        self.HUDHelp.max_length = math.max(self.HUDHelp.max_length or 0, width)
    end

    ---
    -- This hook draws the selection icon in the weapon selection menu.
    -- @see https://wiki.facepunch.com/gmod/WEAPON:DrawWeaponSelection
    -- @realm client
    function SWEP:DrawWeaponSelection() end

    ---
    -- @realm client
    function SWEP:CalcViewModel()
        if not IsFirstTimePredicted() then
            return
        end

        self.bIron = self:GetIronsights()
        self.fIronTime = self:GetIronsightsTime()
        self.fCurrentTime = CurTime()
        self.fCurrentSysTime = SysTime()
    end

    ---
    -- Adds a custom view model.
    -- @note Multiple view models can be added, they are all rendered at once.
    -- @note Call this in @{SWEP:InitializeCustomModels}.
    -- @param string identifier The name of the added view model
    -- @param ModelData modelData The model data table
    -- @realm client
    function SWEP:AddCustomViewModel(identifier, modelData)
        self.customViewModelElements = self.customViewModelElements or {}

        self.customViewModelElements[identifier] = weaponrenderer.CreateModel(self, modelData)
    end

    ---
    -- Adds a custom world model.
    -- @note Multiple world models can be added, they are all rendered at once.
    -- @note Call this in @{SWEP:InitializeCustomModels}.
    -- @param string identifier The name of the added world model
    -- @param ModelData modelData The model data table
    -- @realm client
    function SWEP:AddCustomWorldModel(identifier, modelData)
        self.customWorldModelElements = self.customWorldModelElements or {}

        self.customWorldModelElements[identifier] = weaponrenderer.CreateModel(self, modelData)
    end

    ---
    -- Adds modifications to view model bones.
    -- @param string identifier The identifier for this bone
    -- @param BoneData boneData The bone data table
    -- @realm client
    function SWEP:ApplyViewModelBoneMods(identifier, boneData)
        self.customViewModelBoneMods = self.customViewModelBoneMods or {}
        self.customViewModelBoneMods[identifier] = boneData
    end

    ---
    -- Initialization function that is only used to initialize custom view and world models with
    -- @{SWEP:AddCustomViewModel} and @{SWEP:AddCustomWorldModel}.
    -- @warning This function is also called in the setup for clientside weapon entities for the UI.
    -- Therefore this function should only contain the setup calls for custom view and world models.
    -- Entity specific function calls might throw errors in this function.
    -- @realm client
    function SWEP:InitializeCustomModels() end

    ---
    -- Called straight after the view model has been drawn. This is called before
    -- @{GM:PostDrawViewModel} and @{WEAPON:PostDrawViewModel}.
    -- @warning If you override ViewModelDrawn in your SWEP and you are using a custom world or
    -- view model, you should call BaseClass.ViewModelDrawn(self) so as not to break viewmodels.
    -- @param Entity viewModel Player's view model
    -- @see https://wiki.facepunch.com/gmod/WEAPON:ViewModelDrawn
    -- @realm client
    function SWEP:ViewModelDrawn(viewModel)
        weaponrenderer.RenderViewModel(self, self.customViewModelElements, viewModel)
    end

    ---
    -- Called when we are about to draw the world model.
    -- @realm client
    function SWEP:DrawWorldModel()
        local client = LocalPlayer()

        -- draw view model when spectating player
        if
            client:GetObserverMode() == OBS_MODE_IN_EYE
            and client:GetObserverTarget() == self:GetOwner()
        then
            return
        end

        weaponrenderer.RenderWorldModel(self, self, self.customWorldModelElements, self:GetOwner())
    end

    local weaponIsHidden = false

    ---
    -- Allows you to modify the viewmodel of the weapon in use before it is drawn.
    -- @param Entity viewModel This is the view model entity before it is drawn
    -- @param Player ply The the owner of the view model
    -- @param Weapon wep This is the weapon that is from the view model
    -- @return boolean Return true to prevent the default view model rendering. This also
    -- affects @{GM:PostDrawViewModel}
    -- @realm client
    hook.Add("PreDrawViewModel", "TTT2ViewModelHider", function(viewModel, ply, wep)
        -- note: while ShowDefaultViewModel is set to true in the weapon base, addons such as TFA
        -- do not use the weapon base and only implement parts of it to work with TTT. In a perfect
        -- world TFA would be updated to fix this issue, but we can also prevent it by explicitly
        -- checking for false here.
        -- This means that `nil` (when the weapon isn't based on our base) counts as `true` as well.

        -- special case: Hands should be shown, but the view model weapon shouldn't be; in this
        -- case we have to apply this debug material to make it invisible because returning true
        -- in this hook would prevent both the hands and the weapon from rendering
        if wep.UseHands and wep.ShowDefaultViewModel == false then
            viewModel:SetMaterial("vgui/hsv")

            -- trigger a texture reset after the view model is drawn
            weaponIsHidden = true

            return
        end

        -- only return something if we actually want to hide it because otherwise the SWEP
        -- hook is never called even if the view model is rendered
        if wep.ShowDefaultViewModel == false then
            return true
        end
    end)

    ---
    -- Allows you to modify the viewmodel of the weapon in use after it is drawn.
    -- @param Entity viewModel This is the view model entity before it is drawn
    -- @param Player ply The the owner of the view model
    -- @param Weapon wep This is the weapon that is from the view model
    -- @realm client
    hook.Add("PostDrawViewModel", "TTT2ViewModelHiderReset", function(viewModel, ply, wep)
        -- default case: Normal view model texture is used and view model draw is defined
        -- with the SWEP.ShowDefaultViewModel variable

        -- note: we only reset the material to the default material if it was previously set to
        -- the invisible debug material. That way it is only applied to view models that are
        -- intended to be invisible where it doesn't matter if it messes up their materials.
        -- This is done because some weapons set custom materials to the view model (e.g. the
        -- zombie perk bottles) and always resetting it makes the texture the error texture.
        if weaponIsHidden then
            viewModel:SetMaterial("")

            weaponIsHidden = false
        end
    end)

    ---
    -- This hook can be used by swep addons to populate the equipment settings page
    -- with custom convars. The parent is the submenu, where a new form has to
    -- be added.
    -- @param DPanel parent The parent panel which is the submenu
    -- @hook
    -- @realm client
    function SWEP:AddToSettingsMenu(parent) end
end

---
-- Called if the player presses IN_ATTACK (Default: Left Mouse Button)
-- Shooting functions largely copied from weapon_cs_base
-- @param boolean worldsnd
-- @see https://wiki.facepunch.com/gmod/WEAPON:PrimaryAttack
-- @realm shared
function SWEP:PrimaryAttack(worldsnd)
    self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    if not self:CanPrimaryAttack() then
        return
    end

    if not worldsnd then
        self:EmitSound(self.Primary.Sound, self.Primary.SoundLevel)
    elseif SERVER then
        sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
    end

    self:ShootBullet(
        self.Primary.Damage,
        self:GetPrimaryRecoil(),
        self.Primary.NumShots,
        self:GetPrimaryCone()
    )
    self:TakePrimaryAmmo(1)

    local owner = self:GetOwner()

    if not IsValid(owner) or owner:IsNPC() or not owner.ViewPunch then
        return
    end

    owner:ViewPunch(
        Angle(
            util.SharedRandom(self:GetClass(), -0.2, -0.1, 0) * self:GetPrimaryRecoil(),
            util.SharedRandom(self:GetClass(), -0.1, 0.1, 1) * self:GetPrimaryRecoil(),
            0
        )
    )
end

---
-- @param function setnext
-- @realm shared
function SWEP:DryFire(setnext)
    if CLIENT and LocalPlayer() == self:GetOwner() then
        self:EmitSound(self.DryFireSound, 75, 100, 0.7, CHAN_ITEM)
    end

    setnext(self, CurTime() + 0.2)

    self:Reload()
end

---
-- Helper function for checking for no ammo.
-- @return boolean
-- @see https://wiki.facepunch.com/gmod/WEAPON:CanPrimaryAttack
-- @realm shared
function SWEP:CanPrimaryAttack()
    if not IsValid(self:GetOwner()) then
        return
    end

    if self:Clip1() <= 0 then
        self:DryFire(self.SetNextPrimaryFire)

        return false
    end

    return true
end

---
-- Helper function for checking for no ammo.
-- @return boolean
-- @see https://wiki.facepunch.com/gmod/WEAPON:CanSecondaryAttack
-- @realm shared
function SWEP:CanSecondaryAttack()
    if not IsValid(self:GetOwner()) then
        return
    end

    if self:Clip2() <= 0 then
        self:DryFire(self.SetNextSecondaryFire)

        return false
    end

    return true
end

local function Sparklies(attacker, tr, dmginfo)
    if not tr.HitWorld or tr.MatType ~= MAT_METAL then
        return
    end

    local eff = EffectData()
    eff:SetOrigin(tr.HitPos)
    eff:SetNormal(tr.HitNormal)

    util.Effect("cball_bounce", eff)
end

---
-- A convenience function to shoot bullets
-- @param CTakeDamageInfo dmg
-- @param number recoil
-- @param number numbul
-- @param number cone
-- @see https://wiki.facepunch.com/gmod/WEAPON:ShootBullet
-- @realm shared
function SWEP:ShootBullet(dmg, recoil, numbul, cone)
    local owner = self:GetOwner()

    if not IsValid(owner) then
        return
    end

    self:SendWeaponAnim(self.PrimaryAnim)

    owner:MuzzleFlash()
    owner:SetAnimation(PLAYER_ATTACK1)

    numbul = numbul or 1
    cone = cone or 0.02

    local bullet = {}
    bullet.Num = numbul
    bullet.Src = owner:GetShootPos()
    bullet.Dir = owner:GetAimVector()
    bullet.Spread = Vector(cone, cone, 0)
    bullet.Tracer = 1
    bullet.TracerName = self.Tracer or "Tracer"
    bullet.Force = 10
    bullet.Damage = dmg * (self.damageScaling or 1)

    if CLIENT and sparkle:GetBool() then
        bullet.Callback = Sparklies
    end

    owner:FireBullets(bullet)

    -- Owner can die after firebullets
    if not IsValid(owner) or owner:IsNPC() or not owner:Alive() then
        return
    end

    if
        SERVER and game.SinglePlayer()
        or CLIENT and not game.SinglePlayer() and IsFirstTimePredicted()
    then
        local eyeang = owner:EyeAngles()
        eyeang.pitch = eyeang.pitch - recoil

        owner:SetEyeAngles(eyeang)
    end
end

---
-- @return number
-- @realm shared
function SWEP:GetPrimaryConeFactor()
    local owner = self:GetOwner()

    if not IsValid(owner) then
        return 1
    end

    if SPRINT:IsSprinting(owner) and not owner:IsOnGround() then
        return 2.0
    elseif SPRINT:IsSprinting(owner) or not owner:IsOnGround() then
        return 1.6
    elseif self:GetIronsights() then
        return 0.8
    else
        return 1
    end
end

---
-- @return number
-- @realm shared
function SWEP:GetPrimaryRecoilFactor()
    local owner = self:GetOwner()

    if not IsValid(owner) then
        return 1
    end

    if SPRINT:IsSprinting(owner) and not owner:IsOnGround() then
        return 2.8
    elseif SPRINT:IsSprinting(owner) or not owner:IsOnGround() then
        return 2.2
    elseif self:GetIronsights() then
        return 0.6
    else
        return 1
    end
end

---
-- @return number
-- @realm shared
function SWEP:GetPrimaryCone()
    return self:GetPrimaryConeBase() * self:GetPrimaryConeFactor()
end

---
-- @return number
-- @realm shared
function SWEP:GetPrimaryConeBase()
    return self.Primary.Cone or 0.02
end

---
-- @return number
-- @realm shared
function SWEP:GetPrimaryRecoil()
    return self:GetPrimaryRecoilBase() * self:GetPrimaryRecoilFactor()
end

---
-- @return number
-- @realm shared
function SWEP:GetPrimaryRecoilBase()
    return self.Primary.Recoil or 1.5
end

---
-- @param Player victim
-- @param CTakeDamageInfo dmginfo
-- @return number
-- @realm shared
function SWEP:GetHeadshotMultiplier(victim, dmginfo)
    return self.HeadshotMultiplier
end

---
-- @return boolean
-- @realm shared
function SWEP:IsEquipment()
    return WEPS.IsEquipment(self)
end

---
-- Called if the player presses IN_ATTACK2 (Default: Right mouse button).
-- You can override it to implement special attacks, but it is usually reserved for aiming with ironsights.
-- @see https://wiki.facepunch.com/gmod/WEAPON:SecondaryAttack
-- @realm shared
function SWEP:SecondaryAttack()
    if self.NoSights or not self.IronSightsPos then
        return
    end

    local bNotIronsights = not self:GetIronsights()

    self:SetIronsights(bNotIronsights)
    self:SetZoom(bNotIronsights)

    self:SetNextSecondaryFire(CurTime() + 0.3)
end

---
-- Called when player has just switched to this weapon.
-- @return[default=true] boolean
-- @see https://wiki.facepunch.com/gmod/WEAPON:Deploy
-- @realm shared
function SWEP:Deploy()
    self:SetIronsights(false)
    self:SetZoom(false)

    return true
end

---
-- Called if the player presses IN_RELOAD
-- @see https://wiki.facepunch.com/gmod/WEAPON:Reload
-- @realm shared
function SWEP:Reload()
    if
        self:Clip1() == self.Primary.ClipSize
        or self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0
    then
        return
    end

    self:DefaultReload(self.ReloadAnim)

    self:SetIronsights(false)
    self:SetZoom(false)
end

---
-- Called when the weapon entity is about to be removed
-- @see https://wiki.facepunch.com/gmod/WEAPON:OnRemove
-- @realm shared
function SWEP:OnRemove()
    if CLIENT then
        local owner = self:GetOwner()

        if IsValid(owner) and owner == LocalPlayer() and owner:IsTerror() then
            RunConsoleCommand("lastinv")
        end
    end

    self:SetZoom(false)
end

---
-- Called when the weapon entity is reloaded on a changelevel event
-- @see https://wiki.facepunch.com/gmod/WEAPON:OnRestore
-- @realm shared
function SWEP:OnRestore()
    self.NextSecondaryAttack = 0

    self:SetIronsights(false)
    self:SetZoom(false)
end

---
-- Returns how much of primary ammo the player has
-- @return number|boolean
-- @see https://wiki.facepunch.com/gmod/WEAPON:Ammo1
-- @realm shared
function SWEP:Ammo1()
    return IsValid(self:GetOwner()) and self:GetOwner():GetAmmoCount(self.Primary.Ammo) or false
end

if SERVER then
    ---
    -- This allows us to override behavior of PreDrop/OnDrop calls that request equipment be dropped.
    -- @realm server
    function SWEP:ShouldRemove()
        local should_force = self.overrideDropOnDeath
            and self.overrideDropOnDeath == DROP_ON_DEATH_TYPE_FORCE
        local deathDrop = self.IsDroppedBecauseDeath
        if deathDrop and should_force then
            return false
        end

        return true
    end

    ---
    -- The OnDrop() hook is useless for this as it happens AFTER the drop. OwnerChange
    -- does not occur when a drop happens for some reason. Hence this thing.
    -- @realm server
    function SWEP:PreDrop()
        local owner = self:GetOwner()
        if not IsValid(owner) or self.Primary.Ammo == "none" then
            return
        end

        local ammo = self:Ammo1()

        -- Do not drop ammo if we have another gun that uses this type
        local weps = owner:GetWeapons()

        for i = 1, #weps do
            local w = weps[i]

            if
                not IsValid(w)
                or w == self
                or w:GetPrimaryAmmoType() ~= self:GetPrimaryAmmoType()
            then
                continue
            end

            ammo = 0
        end

        self.StoredAmmo = ammo

        if ammo > 0 then
            owner:RemoveAmmo(ammo, self.Primary.Ammo)
        end
    end

    ---
    -- Helper function to slow down dropped weapons
    -- @realm server
    function SWEP:DampenDrop()
        -- For some reason gmod drops guns on death at a speed of 400 units, which
        -- catapults them away from the body. Here we want people to actually be able
        -- to find a given corpse's weapon, so we override the velocity here and call
        -- this when dropping guns on death.
        local phys = self:GetPhysicsObject()

        if IsValid(phys) then
            phys:SetVelocityInstantaneous(Vector(0, 0, -75) + phys:GetVelocity() * 0.001)
            phys:AddAngleVelocity(phys:GetAngleVelocity() * -0.99)
        end
    end

    local SF_WEAPON_START_CONSTRAINED = 1

    ---
    -- Called when a player has picked the weapon up
    -- Transfers the currently stored ammo to the new player and updates the fingerprints
    -- @param Player newowner
    -- @see https://wiki.facepunch.com/gmod/WEAPON:Equip
    -- @realm server
    function SWEP:Equip(newowner)
        if self:IsOnFire() then
            self:Extinguish()
        end

        self.fingerprints = self.fingerprints or {}

        if not table.HasValue(self.fingerprints, newowner) then
            self.fingerprints[#self.fingerprints + 1] = newowner
        end

        if self:HasSpawnFlags(SF_WEAPON_START_CONSTRAINED) then
            -- If this weapon started constrained, unset that spawnflag, or the
            -- weapon will be re-constrained and float
            local flags = self:GetSpawnFlags()
            local newflags = bit.band(flags, bit.bnot(SF_WEAPON_START_CONSTRAINED))

            self:SetKeyValue("spawnflags", newflags)
        end

        if IsValid(newowner) and self.StoredAmmo > 0 and self.Primary.Ammo ~= "none" then
            local ammo = newowner:GetAmmoCount(self.Primary.Ammo)
            local given = math.min(self.StoredAmmo, self.Primary.ClipMax - ammo)

            newowner:GiveAmmo(given, self.Primary.Ammo)

            self.StoredAmmo = 0
        end
    end

    ---
    -- We were bought as special equipment, some weapons will want to do something
    -- extra for their buyer
    -- @param Player buyer
    -- @realm server
    function SWEP:WasBought(buyer) end

    ---
    -- Experimental. Enables a feature that causes a player who is using his ironsights and is killed (by a gun, and not a headshot) to fire an inaccurate dying shot.
    -- @return boolean
    -- @see http://www.troubleinterroristtown.com/config-and-commands/convars#TOC-Other-gameplay-settings
    -- @realm server
    function SWEP:DyingShot()
        if not self:GetIronsights() then
            return false
        end

        self:SetIronsights(false)
        self:SetZoom(false)

        if self:GetNextPrimaryFire() > CurTime() then
            return false
        end

        -- Owner should still be alive here
        local owner = self:GetOwner()
        if not IsValid(owner) then
            return false
        end

        local punch = self.Primary.Recoil or 5

        -- Punch view to disorient aim before firing dying shot
        local eyeang = owner:EyeAngles()
        eyeang.pitch = eyeang.pitch - math.Rand(-punch, punch)
        eyeang.yaw = eyeang.yaw - math.Rand(-punch, punch)

        owner:SetEyeAngles(eyeang)

        Dev(1, owner:Nick() .. " fired his DYING SHOT")

        owner.dying_wep = self

        self:PrimaryAttack(true)

        return true
    end
end

---
-- Zoom in or out. Use this in combination with SetIronsights.
-- Look at weapon_ttt_m16 for an example of how to use this.
-- @param boolean zoomIn
-- @realm shared
function SWEP:SetZoom(zoomIn) end

---
-- Sets the flag signaling whether or not the ironsights should be used
-- @param boolean b
-- @realm shared
function SWEP:SetIronsights(b)
    if b == self:GetIronsights() then
        return
    end

    self:SetIronsightsPredicted(b)
    self:SetIronsightsTime(CurTime())

    if CLIENT then
        self:CalcViewModel()
    end
end

---
-- Gets the flag signaling whether or not the ironsights should be used
-- @return boolean
-- @realm shared
function SWEP:GetIronsights()
    return self:GetIronsightsPredicted()
end

---
-- Dummy functions that will be replaced when SetupDataTables runs. These are
-- here for when that does not happen (due to e.g. stacking base classes)
-- @return[default=-1] number
-- @realm shared
function SWEP:GetIronsightsTime()
    return -1
end

---
-- Dummy functions that will be replaced when SetupDataTables runs. These are
-- here for when that does not happen (due to e.g. stacking base classes)
-- @realm shared
function SWEP:SetIronsightsTime() end

---
-- Dummy functions that will be replaced when SetupDataTables runs. These are
-- here for when that does not happen (due to e.g. stacking base classes)
-- @return[default=false] boolean
-- @realm shared
function SWEP:GetIronsightsPredicted()
    return false
end

---
-- Dummy functions that will be replaced when SetupDataTables runs. These are
-- here for when that does not happen (due to e.g. stacking base classes)
-- @realm shared
function SWEP:SetIronsightsPredicted() end

---
-- Called when the SWEP should set up its Data Tables.
-- Sets up the networked vars for ironsights.
-- @warning Weapons using their own DT vars will have to make sure they call this.
-- @see https://wiki.facepunch.com/gmod/WEAPON:SetupDataTables
-- @realm shared
function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 3, "IronsightsPredicted")
    self:NetworkVar("Float", 3, "IronsightsTime")
end

---
-- Called when the weapon entity is created.
-- @see https://wiki.facepunch.com/gmod/WEAPON:Initialize
-- @realm shared
function SWEP:Initialize()
    if CLIENT then
        self:InitializeCustomModels()
    end

    if self.EnableConfigurableClip then
        self.Primary.ClipSize = self.ConfigurableClip or self.Primary.DefaultClip

        self:SetClip1(self.ConfigurableClip or self.Primary.DefaultClip)
    end

    if CLIENT and self:Clip1() == -1 then
        self:SetClip1(self.Primary.DefaultClip)
    elseif SERVER then
        self.fingerprints = {}

        self:SetZoom(false)
        self:SetIronsights(false)
    end

    self:SetDeploySpeed(self.DeploySpeed)
    self:SetHoldType(self.HoldType or "pistol")
end

local idle_activities = {
    [ACT_VM_IDLE] = true,
    [ACT_VM_IDLE_TO_LOWERED] = true,
    [ACT_VM_IDLE_LOWERED] = true,
    [ACT_VM_IDLE_SILENCED] = true,
    [ACT_VM_IDLE_EMPTY_LEFT] = true,
    [ACT_VM_IDLE_EMPTY] = true,
    [ACT_VM_IDLE_DEPLOYED_EMPTY] = true,
    [ACT_VM_IDLE_8] = true,
    [ACT_VM_IDLE_7] = true,
    [ACT_VM_IDLE_6] = true,
    [ACT_VM_IDLE_5] = true,
    [ACT_VM_IDLE_4] = true,
    [ACT_VM_IDLE_3] = true,
    [ACT_VM_IDLE_2] = true,
    [ACT_VM_IDLE_1] = true,
    [ACT_VM_IDLE_DEPLOYED] = true,
    [ACT_VM_IDLE_DEPLOYED_8] = true,
    [ACT_VM_IDLE_DEPLOYED_7] = true,
    [ACT_VM_IDLE_DEPLOYED_6] = true,
    [ACT_VM_IDLE_DEPLOYED_5] = true,
    [ACT_VM_IDLE_DEPLOYED_4] = true,
    [ACT_VM_IDLE_DEPLOYED_3] = true,
    [ACT_VM_IDLE_DEPLOYED_2] = true,
    [ACT_VM_IDLE_DEPLOYED_1] = true,
    [ACT_VM_IDLE_M203] = true,
}

local function IsIdleActivity(vm)
    return idle_activities[vm:GetSequenceActivity(vm:GetSequence())] or false
end

---
-- Called when the swep thinks.
-- @warning If you override Think in your SWEP, you should call BaseClass.Think(self) so as not to break ironsights
-- @see https://wiki.facepunch.com/gmod/WEAPON:Think
-- @realm shared
function SWEP:Think()
    local viewModel = self:GetOwner():GetViewModel()

    if
        self.idleResetFix
        and self.ViewModel
        and viewModel:GetCycle() >= 1
        and not IsIdleActivity(viewModel)
    then
        self:SendWeaponAnim(self.IdleAnim or ACT_VM_IDLE)
    end

    if CLIENT then
        self:CalcViewModel()
    end
end

if CLIENT then
    ---
    -- @realm client
    local ttt_lowered = CreateConVar("ttt_ironsights_lowered", "1", FCVAR_ARCHIVE)

    local host_timescale = GetConVar("host_timescale")

    local LOWER_POS = Vector(0, 0, -2)
    local IRONSIGHT_TIME = 0.25

    ---
    -- This hook allows you to adjust view model position and angles.
    -- @param Vector pos
    -- @param Angle ang
    -- @return Vector
    -- @return Angle
    -- @see https://wiki.facepunch.com/gmod/WEAPON:GetViewModelPosition
    -- @realm client
    function SWEP:GetViewModelPosition(pos, ang)
        if not self.IronSightsPos or self.bIron == nil then
            return pos, ang
        end

        local bIron = self.bIron
        local time = self.fCurrentTime
            + (SysTime() - self.fCurrentSysTime)
                * game.GetTimeScale()
                * host_timescale:GetFloat()

        if bIron then
            self.SwayScale = 0.3
            self.BobScale = 0.1
        else
            self.SwayScale = 1.0
            self.BobScale = 1.0
        end

        local fIronTime = self.fIronTime

        if not bIron and fIronTime < time - IRONSIGHT_TIME then
            return pos, ang
        end

        local mul = 1.0

        if fIronTime > time - IRONSIGHT_TIME then
            mul = math.Clamp((time - fIronTime) / IRONSIGHT_TIME, 0, 1)

            if not bIron then
                mul = 1 - mul
            end
        end

        local offset = self.IronSightsPos + (ttt_lowered:GetBool() and LOWER_POS or vector_origin)

        if self.IronSightsAng then
            ang = Angle(ang)
            ang:RotateAroundAxis(ang:Right(), self.IronSightsAng.x * mul)
            ang:RotateAroundAxis(ang:Up(), self.IronSightsAng.y * mul)
            ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * mul)
        end

        pos = pos + offset.x * ang:Right() * mul
        pos = pos + offset.y * ang:Forward() * mul
        pos = pos + offset.z * ang:Up() * mul

        return pos, ang
    end
end

hook.Add("KeyRelease", "TTT2ResetIronSights", function(ply, key)
    if key ~= IN_ATTACK2 or not IsValid(ply) then
        return
    end

    if not (CLIENT and ttt2_hold_aim:GetBool() or SERVER and ply.holdAim) then
        return
    end

    local wep = ply:GetActiveWeapon()

    if not IsValid(wep) or (wep.GetIronsights and not wep:GetIronsights()) then
        return
    end

    wep:SetIronsights(false)
    wep:SetZoom(false)
end)

if CLIENT then
    ---
    -- Tell the server about the users preference regarding holding aim or toggle aim,
    -- necessary to avoid prediction issues
    local function UpdateHoldAimCV()
        net.Start("TTT2UpdateHoldAimConvar")
        net.WriteBool(ttt2_hold_aim:GetBool())
        net.SendToServer()
    end

    hook.Add("InitPostEntity", "TTT2InitHoldAimCV", UpdateHoldAimCV)

    cvars.AddChangeCallback("ttt2_hold_aim", UpdateHoldAimCV)
else
    net.Receive("TTT2UpdateHoldAimConvar", function(_, ply)
        ply.holdAim = net.ReadBool()
    end)
end
