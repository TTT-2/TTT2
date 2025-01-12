if SERVER then
    AddCSLuaFile()

    return
end

KEYHELP_INTERNAL = 1
KEYHELP_CORE = 2
KEYHELP_EXTRA = 3
KEYHELP_EQUIPMENT = 4
KEYHELP_SCOREBOARD = 5

local Key = Key
local stringUpper = string.upper
local inputGetKeyName = input.GetKeyName
local bindFind = bind.Find

local offsetCenter = 230
local height = 48
local width = 18
local padding = 5
local thicknessLine = 2

local heightScaled = 0
local widthScaled = 0
local paddingScaled = 0
local thicknessLineScaled = 0

local colorBox = Color(0, 0, 0, 100)

local materialSettings = Material("vgui/ttt/hudhelp/settings")
local materialMute = Material("vgui/ttt/hudhelp/mute")
local materialShoppingRole = Material("vgui/ttt/hudhelp/shopping_role")
local materialPosessing = Material("vgui/ttt/hudhelp/possessing")
local materialPlayer = Material("vgui/ttt/hudhelp/player")
local materialPlayerPrev = Material("vgui/ttt/hudhelp/player_prev")
local materialPlayerNext = Material("vgui/ttt/hudhelp/player_next")
local materialPlayerRandom = Material("vgui/ttt/hudhelp/player_random")
local materialPropJump = Material("vgui/ttt/hudhelp/prop_jump")
local materialPropLeft = Material("vgui/ttt/hudhelp/prop_left")
local materialPropRight = Material("vgui/ttt/hudhelp/prop_right")
local materialPropFront = Material("vgui/ttt/hudhelp/prop_front")
local materialPropBack = Material("vgui/ttt/hudhelp/prop_back")
local materialPropDash = Material("vgui/ttt/hudhelp/prop_dash")
local materialLeaveTarget = Material("vgui/ttt/hudhelp/leave_target")
local materialVoiceGlobal = Material("vgui/ttt/hudhelp/voice_global")
local materialVoiceTeam = Material("vgui/ttt/hudhelp/voice_team")
local materialChatGlobal = Material("vgui/ttt/hudhelp/chat_global")
local materialChatTeam = Material("vgui/ttt/hudhelp/chat_team")
local materialFlashlight = Material("vgui/ttt/hudhelp/flashlight")
local materialWeaponDrop = Material("vgui/ttt/hudhelp/weapon_drop")
local materialAmmoDrop = Material("vgui/ttt/hudhelp/ammo_drop")
local materialQuickchat = Material("vgui/ttt/hudhelp/quickchat")
local materialShowmore = Material("vgui/ttt/hudhelp/showmore")
local materialPointer = Material("vgui/ttt/hudhelp/pointer")
local materialThirdPerson = Material("vgui/ttt/hudhelp/third_person")
local materialSave = Material("vgui/ttt/hudhelp/save")
local materialLeaveVehicle = Material("vgui/ttt/hudhelp/leave_vehicle")

---
-- @realm client
local cvEnableCore = CreateConVar("ttt2_keyhelp_show_core", "1", FCVAR_ARCHIVE)

---
-- @realm client
local cvEnableExtra = CreateConVar("ttt2_keyhelp_show_extra", "0", FCVAR_ARCHIVE)

---
-- @realm client
local cvEnableEquipment = CreateConVar("ttt2_keyhelp_show_equipment", "1", FCVAR_ARCHIVE)

---
-- @realm client
local cvEnableBoxBlur = CreateConVar("ttt2_hud_enable_box_blur", "1", FCVAR_ARCHIVE)

---
-- @realm client
local cvEnableDescription = CreateConVar("ttt2_hud_enable_description", "1", FCVAR_ARCHIVE)

local cvPropspecToggle -- Cached later in the key register function

keyhelp = keyhelp or {}
keyhelp.keyHelpers = {}

local function DrawKeyContent(x, y, keyString, iconMaterial, bindingName, scoreboardShown, scale)
    local wKeyString = draw.GetTextSize(keyString, "weapon_hud_help_key", scale)
    local wBox = math.max(widthScaled, wKeyString) + 2 * paddingScaled
    local xIcon = x + 0.5 * (wBox - widthScaled)
    local yIcon = y + paddingScaled + thicknessLineScaled
    local xKeyString = x + math.floor(0.5 * wBox)
    local yKeyString = yIcon + widthScaled + paddingScaled

    if cvEnableBoxBlur:GetBool() then
        draw.BlurredBox(x, y, wBox, heightScaled + paddingScaled)
        draw.Box(x, y, wBox, heightScaled + paddingScaled, colorBox) -- background color
        draw.Box(x, y, wBox, math.Round(0.5 * thicknessLineScaled), colorBox) -- top line shadow
        draw.Box(x, y, wBox, thicknessLineScaled, colorBox) -- top line shadow
        draw.Box(x, y - thicknessLineScaled, wBox, thicknessLineScaled, COLOR_WHITE) -- white top line
    end

    draw.FilteredShadowedTexture(
        xIcon,
        yIcon,
        widthScaled,
        widthScaled,
        iconMaterial,
        255,
        COLOR_WHITE,
        scale
    )
    draw.AdvancedText(
        keyString,
        "weapon_hud_help_key",
        xKeyString,
        yKeyString,
        COLOR_WHITE,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_TOP,
        true,
        scale
    )

    if scoreboardShown and cvEnableDescription:GetBool() then
        draw.AdvancedText(
            LANG.TryTranslation(bindingName),
            "weapon_hud_help",
            xKeyString,
            y - 3 * paddingScaled,
            COLOR_WHITE,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER,
            true,
            scale,
            -45
        )
    end

    return wBox
end

local function DrawKey(client, xBase, yBase, keyHelper, scoreboardShown, scale)
    if not isfunction(keyHelper.callback) or not keyHelper.callback(client) then
        return
    end

    -- handles both internal GMod bindings and TTT2 bindings
    local key = Key(keyHelper.binding) or inputGetKeyName(bindFind(keyHelper.binding))

    if not key then
        return
    end

    return xBase
        + paddingScaled
        + DrawKeyContent(
            xBase,
            yBase,
            stringUpper(key),
            keyHelper.iconMaterial,
            keyHelper.bindingName,
            scoreboardShown,
            scale
        )
end

---
-- Registers a key helper that will be shown in the key helper area.
-- @note Addons will probaly set the binding type `KEYHELP_EQUIPMENT`.
-- @param string binding The binding that is used here, it is either the gmod or TTT2 binding name
-- @param Material iconMaterial The material for the icon used in the UI
-- @param number bindingType The category in which this binding is sorted
-- @param string bindingName The name for the binding, should be translateable
-- @param function callback The callback function that checks if this binding should be rendered on screen
-- @realm client
function keyhelp.RegisterKeyHelper(binding, iconMaterial, bindingType, bindingName, callback)
    keyhelp.keyHelpers[bindingType] = keyhelp.keyHelpers[bindingType] or {}

    keyhelp.keyHelpers[bindingType][#keyhelp.keyHelpers[bindingType] + 1] = {
        binding = binding,
        iconMaterial = iconMaterial,
        bindingType = bindingType,
        bindingName = bindingName,
        callback = callback,
    }
end

---
-- Draws the keyhelpers to the screen, is called from within @{GM:HUDPaint}.
-- @internal
-- @realm client
function keyhelp.Draw()
    local client = LocalPlayer()
    local scoreboardShown = GAMEMODE.ShowScoreboard

    local scale = appearance.GetGlobalScale()

    local xBase = 0.5 * ScrW() + offsetCenter * scale
    local yBase = ScrH() - height * scale

    heightScaled = height * scale
    widthScaled = width * scale
    paddingScaled = padding * scale
    thicknessLineScaled = math.Round(thicknessLine * scale)

    if cvEnableCore:GetBool() or scoreboardShown then
        for i = 1, #keyhelp.keyHelpers[KEYHELP_INTERNAL] do
            xBase = DrawKey(
                client,
                xBase,
                yBase,
                keyhelp.keyHelpers[KEYHELP_INTERNAL][i],
                scoreboardShown,
                scale
            ) or xBase
        end
    end

    if not util.EditingModeActive(client) then
        if keyhelp.keyHelpers[KEYHELP_CORE] and (cvEnableCore:GetBool() or scoreboardShown) then
            for i = 1, #keyhelp.keyHelpers[KEYHELP_CORE] do
                xBase = DrawKey(
                    client,
                    xBase,
                    yBase,
                    keyhelp.keyHelpers[KEYHELP_CORE][i],
                    scoreboardShown,
                    scale
                ) or xBase
            end
        end

        if
            keyhelp.keyHelpers[KEYHELP_EQUIPMENT]
            and (cvEnableEquipment:GetBool() or scoreboardShown)
        then
            for i = 1, #keyhelp.keyHelpers[KEYHELP_EQUIPMENT] do
                xBase = DrawKey(
                    client,
                    xBase,
                    yBase,
                    keyhelp.keyHelpers[KEYHELP_EQUIPMENT][i],
                    scoreboardShown,
                    scale
                ) or xBase
            end
        end

        if keyhelp.keyHelpers[KEYHELP_EXTRA] and (cvEnableExtra:GetBool() or scoreboardShown) then
            for i = 1, #keyhelp.keyHelpers[KEYHELP_EXTRA] do
                xBase = DrawKey(
                    client,
                    xBase,
                    yBase,
                    keyhelp.keyHelpers[KEYHELP_EXTRA][i],
                    scoreboardShown,
                    scale
                ) or xBase
            end
        end
    end

    -- if anyone of them is disabled, but not all, the show more option is shown
    local enbCount = cvEnableCore:GetInt() + cvEnableEquipment:GetInt() + cvEnableExtra:GetInt()

    if not scoreboardShown and enbCount > 0 and enbCount < 3 then
        xBase = DrawKey(
            client,
            xBase,
            yBase,
            keyhelp.keyHelpers[KEYHELP_SCOREBOARD][1],
            scoreboardShown,
            scale
        ) or xBase
    end
end

---
-- Initializes the basic keys that should be registered. Called from within @{GM:Initialize} and @{GM:OnReloaded}.
-- @internal
-- @realm client
function keyhelp.InitializeBasicKeys()
    -- core bindings that should be visible be default
    keyhelp.RegisterKeyHelper(
        "gm_showhelp",
        materialSettings,
        KEYHELP_INTERNAL,
        "label_keyhelper_help",
        function(client)
            if util.EditingModeActive(client) then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "gm_showhelp",
        materialSave,
        KEYHELP_INTERNAL,
        "label_keyhelper_save_exit",
        function(client)
            if not util.EditingModeActive(client) then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "gm_showteam",
        materialMute,
        KEYHELP_CORE,
        "label_keyhelper_mutespec",
        function(client)
            if not client:IsSpec() then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+menu_context",
        materialShoppingRole,
        KEYHELP_CORE,
        "label_keyhelper_shop",
        function(client)
            if client:IsSpec() or not client:IsShopper() then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+duck",
        materialPointer,
        KEYHELP_CORE,
        "label_keyhelper_show_pointer",
        function(client)
            if not client:IsSpec() or IsValid(client:GetObserverTarget()) then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+use",
        materialPosessing,
        KEYHELP_CORE,
        "label_keyhelper_possess_focus_entity",
        function(client)
            cvPropspecToggle = cvPropspecToggle or GetConVar("ttt_spec_prop_control")

            if
                not client:IsSpec()
                or IsValid(client:GetObserverTarget())
                or not cvPropspecToggle:GetBool()
            then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+use",
        materialPlayer,
        KEYHELP_CORE,
        "label_keyhelper_spec_focus_player",
        function(client)
            if not client:IsSpec() or IsValid(client:GetObserverTarget()) then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+attack",
        materialPlayerPrev,
        KEYHELP_CORE,
        "label_keyhelper_spec_previous_player",
        function(client)
            if not client:IsSpec() then
                return
            end

            local target = client:GetObserverTarget()

            if not IsValid(target) or not target:IsPlayer() then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+attack2",
        materialPlayerNext,
        KEYHELP_CORE,
        "label_keyhelper_spec_next_player",
        function(client)
            if not client:IsSpec() then
                return
            end

            local target = client:GetObserverTarget()

            if not IsValid(target) or not target:IsPlayer() then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+reload",
        materialThirdPerson,
        KEYHELP_CORE,
        "label_keyhelper_spec_third_person",
        function(client)
            if not client:IsSpec() then
                return
            end

            local target = client:GetObserverTarget()

            if not IsValid(target) or not target:IsPlayer() then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+attack2",
        materialPlayerRandom,
        KEYHELP_CORE,
        "label_keyhelper_spec_player",
        function(client)
            if not client:IsSpec() or IsValid(client:GetObserverTarget()) then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+jump",
        materialPropJump,
        KEYHELP_CORE,
        "label_keyhelper_possession_jump",
        function(client)
            if not client:IsSpec() then
                return
            end

            local target = client:GetObserverTarget()

            if
                not IsValid(target)
                or target:IsPlayer()
                or target:GetNWEntity("spec_owner", nil) ~= client
            then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+moveleft",
        materialPropLeft,
        KEYHELP_CORE,
        "label_keyhelper_possession_left",
        function(client)
            if not client:IsSpec() then
                return
            end

            local target = client:GetObserverTarget()

            if
                not IsValid(target)
                or target:IsPlayer()
                or target:GetNWEntity("spec_owner", nil) ~= client
            then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+moveright",
        materialPropRight,
        KEYHELP_CORE,
        "label_keyhelper_possession_right",
        function(client)
            if not client:IsSpec() then
                return
            end

            local target = client:GetObserverTarget()

            if
                not IsValid(target)
                or target:IsPlayer()
                or target:GetNWEntity("spec_owner", nil) ~= client
            then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+forward",
        materialPropFront,
        KEYHELP_CORE,
        "label_keyhelper_possession_forward",
        function(client)
            if not client:IsSpec() then
                return
            end

            local target = client:GetObserverTarget()

            if
                not IsValid(target)
                or target:IsPlayer()
                or target:GetNWEntity("spec_owner") ~= client
            then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+back",
        materialPropBack,
        KEYHELP_CORE,
        "label_keyhelper_possession_backward",
        function(client)
            if not client:IsSpec() then
                return
            end

            local target = client:GetObserverTarget()

            if
                not IsValid(target)
                or target:IsPlayer()
                or target:GetNWEntity("spec_owner") ~= client
            then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+speed",
        materialPropDash,
        KEYHELP_CORE,
        "label_keyhelper_possession_dash",
        function(client)
            if not client:IsSpec() then
                return
            end

            local target = client:GetObserverTarget()

            if
                not IsValid(target)
                or target:IsPlayer()
                or target:GetNWEntity("spec_owner", nil) ~= client
            then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+duck",
        materialLeaveTarget,
        KEYHELP_CORE,
        "label_keyhelper_free_roam",
        function(client)
            if not client:IsSpec() or not IsValid(client:GetObserverTarget()) then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+use",
        materialLeaveVehicle,
        KEYHELP_CORE,
        "label_keyhelper_leave_vehicle",
        function(client)
            if client:IsSpec() or not client:InVehicle() then
                return
            end

            return true
        end
    )

    -- extra bindings that are not that important but are there as well
    keyhelp.RegisterKeyHelper(
        "impulse 100",
        materialFlashlight,
        KEYHELP_EXTRA,
        "label_keyhelper_flashlight",
        function(client)
            if client:IsSpec() then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+menu",
        materialWeaponDrop,
        KEYHELP_EXTRA,
        "label_keyhelper_weapon_drop",
        function(client)
            if client:IsSpec() then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "gmod_undo",
        materialAmmoDrop,
        KEYHELP_EXTRA,
        "label_keyhelper_ammo_drop",
        function(client)
            if client:IsSpec() then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "+zoom",
        materialQuickchat,
        KEYHELP_EXTRA,
        "label_keyhelper_quickchat",
        function(client)
            if client:IsSpec() then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "ttt2_voice",
        materialVoiceGlobal,
        KEYHELP_EXTRA,
        "label_keyhelper_voice_global",
        function(client)
            if not VOICE.CanEnable() or not GetGlobalBool("sv_voiceenable", true) then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "ttt2_voice_team",
        materialVoiceTeam,
        KEYHELP_EXTRA,
        "label_keyhelper_voice_team",
        function(client)
            if not VOICE.CanTeamEnable() or not GetGlobalBool("sv_voiceenable", true) then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "messagemode",
        materialChatGlobal,
        KEYHELP_EXTRA,
        "label_keyhelper_chat_global",
        function(client)
            if client:GetSubRoleData().disabledGeneralChat then
                return
            end

            return true
        end
    )
    keyhelp.RegisterKeyHelper(
        "messagemode2",
        materialChatTeam,
        KEYHELP_EXTRA,
        "label_keyhelper_chat_team",
        function(client)
            if client:IsSpec() then
                return
            end

            local clientRoleData = client:GetSubRoleData()

            if clientRoleData.unknownTeam or clientRoleData.disabledTeamChat then
                return
            end

            return true
        end
    )

    -- internal bindings, there should only be this one
    keyhelp.RegisterKeyHelper(
        "+showscores",
        materialShowmore,
        KEYHELP_SCOREBOARD,
        "label_keyhelper_show_all",
        function(client)
            return true
        end
    )
end
