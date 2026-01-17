---
-- The main file. Some GAMEMODE hooks and internal @{function}s

local math = math
local net = net
local player = player
local timer = timer
local IsValid = IsValid
local surface = surface
local hook = hook
local playerGetAll = player.GetAll

-- Define GM12 fonts for compatibility
surface.CreateFont("DefaultBold", { font = "Tahoma", size = 13, weight = 1000 })
surface.CreateFont(
    "TabLarge",
    { font = "Tahoma", size = 13, weight = 700, shadow = true, antialias = false }
)
surface.CreateFont("Trebuchet22", { font = "Trebuchet MS", size = 22, weight = 900 })

ttt_include("sh_init")

ttt_include("sh_cvar_handler")

ttt_include("sh_network_sync")
ttt_include("sh_sprint")
ttt_include("sh_main")
ttt_include("sh_shop")
ttt_include("sh_shopeditor")
ttt_include("sh_rolelayering")
ttt_include("sh_scoring")
ttt_include("sh_corpse")
ttt_include("sh_player_ext")
ttt_include("sh_weaponry")
ttt_include("sh_inventory")
ttt_include("sh_door")
ttt_include("sh_entity")
ttt_include("sh_voice")
ttt_include("sh_printmessage_override")
ttt_include("sh_speed")
ttt_include("sh_marker_vision_element")

ttt_include("vgui__cl_coloredbox")
ttt_include("vgui__cl_droleimage")
ttt_include("vgui__cl_simpleroleicon")
ttt_include("vgui__cl_simpleicon")
ttt_include("vgui__cl_simpleclickicon")
ttt_include("vgui__cl_progressbar")
ttt_include("vgui__cl_scrolllabel")

ttt_include("cl_vskin__default_skin")
ttt_include("cl_vskin__vgui__dpanel")
ttt_include("cl_vskin__vgui__dframe")
ttt_include("cl_vskin__vgui__dimagecheckbox")
ttt_include("cl_vskin__vgui__droleimage")
ttt_include("cl_vskin__vgui__dmenubutton")
ttt_include("cl_vskin__vgui__dsubmenubutton")
ttt_include("cl_vskin__vgui__dnavpanel")
ttt_include("cl_vskin__vgui__dcontentpanel")
ttt_include("cl_vskin__vgui__dshopcard")
ttt_include("cl_vskin__vgui__dcombocard")
ttt_include("cl_vskin__vgui__dbuttonpanel")
ttt_include("cl_vskin__vgui__dcategoryheader")
ttt_include("cl_vskin__vgui__dcategorycollapse")
ttt_include("cl_vskin__vgui__dform")
ttt_include("cl_vskin__vgui__dbutton")
ttt_include("cl_vskin__vgui__dbinder")
ttt_include("cl_vskin__vgui__dlabel")
ttt_include("cl_vskin__vgui__dcombobox")
ttt_include("cl_vskin__vgui__dcheckboxlabel")
ttt_include("cl_vskin__vgui__dnumslider")
ttt_include("cl_vskin__vgui__dtextentry")
ttt_include("cl_vskin__vgui__dbinderpanel")
ttt_include("cl_vskin__vgui__dscrollpanel")
ttt_include("cl_vskin__vgui__dvscrollbar")
ttt_include("cl_vskin__vgui__dcoloredbox")
ttt_include("cl_vskin__vgui__dcoloredtextbox")
ttt_include("cl_vskin__vgui__dtooltip")
ttt_include("cl_vskin__vgui__deventbox")
ttt_include("cl_vskin__vgui__ddragbase")
ttt_include("cl_vskin__vgui__drolelayeringreceiver")
ttt_include("cl_vskin__vgui__drolelayeringsender")
ttt_include("cl_vskin__vgui__dsearchbar")
ttt_include("cl_vskin__vgui__dprofilepanel")
ttt_include("cl_vskin__vgui__dinfoitem")
ttt_include("cl_vskin__vgui__dsubmenulist")
ttt_include("cl_vskin__vgui__dweaponpreview")
ttt_include("cl_vskin__vgui__dpippanel")
ttt_include("cl_vskin__vgui__dplayergraph")

ttt_include("cl_changes")
ttt_include("cl_network_sync")
ttt_include("cl_hud_editor")
ttt_include("cl_hud_manager")
ttt_include("cl_karma")
ttt_include("cl_tradio")
ttt_include("cl_transfer")
ttt_include("cl_reroll")
ttt_include("cl_targetid")
ttt_include("cl_target_data")
ttt_include("cl_marker_vision_data")
ttt_include("cl_search")
ttt_include("cl_tbuttons")
ttt_include("cl_scoreboard")
ttt_include("cl_msgstack")
ttt_include("cl_eventpopup")
ttt_include("cl_hudpickup")
ttt_include("cl_keys")
ttt_include("cl_wepswitch")
ttt_include("cl_scoring")
ttt_include("cl_popups")
ttt_include("cl_shop")
ttt_include("cl_equip")
ttt_include("cl_shopeditor")
ttt_include("cl_chat")
ttt_include("cl_radio")
ttt_include("cl_inventory")
ttt_include("cl_status")
ttt_include("cl_player_ext")
ttt_include("cl_voice")

ttt_include("cl_armor")
ttt_include("cl_damage_indicator")
ttt_include("sh_armor")
ttt_include("cl_weapon_pickup")

ttt_include("cl_help") -- Creates Menus which depend on other client files. Should be loaded as late as possible

fileloader.LoadFolder("terrortown/autorun/client/", false, CLIENT_FILE, function(path)
    Dev(1, "Added TTT2 client autorun file: ", path)
end)

fileloader.LoadFolder("terrortown/autorun/shared/", false, SHARED_FILE, function(path)
    Dev(1, "Added TTT2 shared autorun file: ", path)
end)

-- all files are loaded
local TryT = LANG.TryTranslation

---
-- @realm client
local cvEnableBobbing = CreateConVar("ttt2_enable_bobbing", "1", FCVAR_ARCHIVE)

---
-- @realm client
local cvEnableBobbingStrafe = CreateConVar("ttt2_enable_bobbing_strafe", "1", FCVAR_ARCHIVE)

-- @realm client
local cvEnableDynamicFOV =
    CreateConVar("ttt2_enable_dynamic_fov", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE })

cvars.AddChangeCallback("ttt2_enable_dynamic_fov", function(_, _, valueNew)
    LocalPlayer():SetSettingOnServer("enable_dynamic_fov", tobool(valueNew))
end)

---
-- Called after the gamemode loads and starts.
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:Initialize
-- @local
function GM:Initialize()
    Dev(1, "TTT2 Client initializing...")

    -- Migrate all changes of TTT2
    migrations.Apply()

    ---
    -- @realm client
    hook.Run("TTT2Initialize")

    -- load default TTT2 language files or mark them as downloadable on the server
    -- load addon language files in a second pass, the core language files are loaded earlier
    fileloader.LoadFolder("terrortown/lang/", true, CLIENT_FILE, function(path)
        Dev(1, "Added TTT2 language file: ", path)
    end)

    fileloader.LoadFolder("lang/", true, CLIENT_FILE, function(path)
        ErrorNoHaltWithStack(
            "[DEPRECATION WARNING]: Loaded language file from 'lang/', this folder is deprecated. Please switch to 'terrortown/lang/'. Source: \""
                .. path
                .. "\""
        )
        Dev(1, "Added TTT2 language file: ", path)
    end)

    -- load vskin files
    fileloader.LoadFolder("terrortown/vskin/", false, CLIENT_FILE, function(path)
        Dev(1, "Added TTT2 vskin file: ", path)
    end)

    -- initialize scale callbacks
    appearance.RegisterScaleChangeCallback(HUDManager.ResetHUD)

    LANG.Init()

    self.BaseClass:Initialize()

    ARMOR:Initialize()
    SPEED:Initialize()

    local skinName = vskin.GetVSkinName()

    vskin.UpdatedVSkin(skinName, skinName)

    keyhelp.InitializeBasicKeys()

    tips.Initialize()

    ---
    -- @realm shared
    hook.Run("TTT2FinishedLoading")

    ---
    -- @realm client
    hook.Run("PostInitialize")
end

---
-- Called right after the map has cleaned up (usually because game.CleanUpMap was called)
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:PostCleanupMap
-- @local
function GM:PostCleanupMap()
    ---
    -- @realm client
    hook.Run("TTT2PostCleanupMap")
end

---
-- This hook is used to initialize @{ITEM}s, @{Weapon}s and the shops.
-- Called after all the entities are initialized.
-- @note At this point the client only knows about the entities that are within the spawnpoints' PVS.
-- For instance, if the server sends an entity that is not within this
-- <a href="https://en.wikipedia.org/wiki/Potentially_visible_set">PVS</a>,
-- the client will receive it as NULL entity.
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:InitPostEntity
-- @local
function GM:InitPostEntity()
    Dev(1, "TTT Client post-init...")

    ---
    -- @realm client
    hook.Run("TTTInitPostEntity")

    items.MigrateLegacyItems()
    items.OnLoaded()

    -- load all HUDs
    huds.OnLoaded()

    -- load all HUD elements
    hudelements.OnLoaded()

    HUDManager.LoadAllHUDS()
    HUDManager.SetHUD()

    local sweps = weapons.GetList()

    -- load sweps
    for i = 1, #sweps do
        local eq = sweps[i]

        -- Check if an equipment has an id or ignore it
        -- @realm server
        if not hook.Run("TTT2RegisterWeaponID", eq) then
            continue
        end

        -- Insert data into role fallback tables
        InitDefaultEquipment(eq)

        eq.CanBuy = {} -- reset normal weapons equipment
    end

    local roleList = roles.GetList()

    -- reset normal equipment tables
    for i = 1, #roleList do
        Equipment[roleList[i].index] = {}
    end

    -- initialize fallback shops
    InitFallbackShops()

    ShopEditor.BuildValidEquipmentCache()

    ---
    -- @realm client
    hook.Run("PostInitPostEntity")

    ---
    -- @realm client
    hook.Run("InitFallbackShops")

    ---
    -- @realm client
    hook.Run("LoadedFallbackShops")

    net.Start("TTT2SyncShopsWithServer")
    net.SendToServer()
    TTT2ShopFallbackInitialized = true

    net.Start("TTT_Spectate")
    net.WriteBool(GetConVar("ttt_spectator_mode"):GetBool())
    net.SendToServer()

    if not game.SinglePlayer() then
        timer.Create("idlecheck", 5, 0, CheckIdle)
    end

    local client = LocalPlayer()

    client:SetSettingOnServer("enable_dynamic_fov", GetConVar("ttt2_enable_dynamic_fov"):GetBool())

    -- make sure player class extensions are loaded up, and then do some
    -- initialization on them
    if IsValid(client) and client.GetTraitor then
        self:ClearClientState()
    end

    timer.Create("cache_ents", 1, 0, function()
        self:DoCacheEnts()
    end)

    RunConsoleCommand("_ttt_request_serverlang")
    RunConsoleCommand("_ttt_request_rolelist")
end

---
-- Called when gamemode has been reloaded by auto refresh.
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:OnReloaded
function GM:OnReloaded()
    -- load all roles
    roles.OnLoaded()

    ---
    -- @realm shared
    hook.Run("TTT2RolesLoaded")

    ---
    -- @realm shared
    hook.Run("TTT2BaseRoleInit")

    -- load all items
    items.OnLoaded()

    -- load all HUDs
    huds.OnLoaded()

    -- load all HUD elements
    hudelements.OnLoaded()

    -- re-request the HUD to be loaded
    HUDManager.LoadAllHUDS()
    HUDManager.SetHUD()

    ARMOR:Initialize()
    SPEED:Initialize()

    -- rebuild menues on game reload
    vguihandler.Rebuild()

    local skinName = vskin.GetVSkinName()
    vskin.UpdatedVSkin(skinName, skinName)

    keyhelp.InitializeBasicKeys()

    ShopEditor.BuildValidEquipmentCache()

    tips.Initialize()

    LocalPlayer():SetSettingOnServer(
        "enable_dynamic_fov",
        GetConVar("ttt2_enable_dynamic_fov"):GetBool()
    )

    -- notify the server that the client finished reloading
    net.Start("TTT2FinishedReloading")
    net.SendToServer()

    ---
    -- @realm shared
    hook.Run("TTT2FinishedLoading")
end

---
-- Caches the @{RADAR} and @{TBHUD} @{Entity}
-- @note Called every second by the "cache_ents" timer
-- @hook
-- @realm client
function GM:DoCacheEnts()
    RADAR:CacheEnts()
    TBHUD:CacheEnts()
end

---
-- Clears the @{RADAR} and @{TBHUD} @{Entity}
-- @note Called by the @{GM:ClearClientState} hook
-- @hook
-- @realm client
function GM:HUDClear()
    RADAR:Clear()
    TBHUD:Clear()
end

local function ttt_print_playercount()
    Dev(2, GAMEMODE.StartingPlayers)
end
concommand.Add("ttt_print_playercount", ttt_print_playercount)

-- usermessages

local function ReceiveRole()
    local client = LocalPlayer()
    if not IsValid(client) then
        return
    end

    local subrole = net.ReadUInt(ROLE_BITS)
    local team = net.ReadString()

    -- after a mapswitch, server might have sent us this before we are even done
    -- loading our code
    if not isfunction(client.SetRole) then
        return
    end

    client:SetRole(subrole, team)
end
net.Receive("TTT_Role", ReceiveRole)

-- role test
local function TTT2TestRole()
    local client = LocalPlayer()
    if not IsValid(client) then
        return
    end

    client:ChatPrint("Your current role is: '" .. client:GetSubRoleData().name .. "'")
end
net.Receive("TTT2TestRole", TTT2TestRole)

local function ReceiveRoleList()
    local subrole = net.ReadUInt(ROLE_BITS)
    local team = net.ReadString()
    local num_ids = net.ReadUInt(8)

    for i = 1, num_ids do
        local eidx = net.ReadUInt(7) + 1 -- we - 1 worldspawn=0
        local ply = player.GetByID(eidx)

        if IsValid(ply) and ply.SetRole then
            ply:SetRole(subrole, team)

            local plyrd = ply:GetSubRoleData()

            if
                team ~= TEAM_NONE
                and not plyrd.unknownTeam
                and not plyrd.disabledTeamVoice
                and not TEAMS[team].alone
            then
                ply[team .. "_gvoice"] = false -- assume role's chat by default
            end
        end
    end
end
net.Receive("TTT_RoleList", ReceiveRoleList)

---
-- Cleanup at start of new round
-- @note Called if a new round begins (round state changes to <code>ROUND_PREP</code>)
-- @hook
-- @realm client
function GM:ClearClientState()
    self:HUDClear()

    -- todo: stuff like this should be in their respective files inside the hooks
    -- maybe even the prepare round hook? this mess has to go

    local client = LocalPlayer()

    if not IsValid(client) or not client:IsReady() then
        return
    end

    client.equipmentItems = {}
    client.equipment_credits = 0
    client.bought = {}
    client.last_id = nil
    client.radio = nil
    client.called_corpses = {}

    client:SetTargetPlayer(nil)

    voicebattery.InitBattery()

    local plys = playerGetAll()

    for i = 1, #plys do
        local ply = plys[i]

        ply.sb_tag = nil

        bodysearch.ResetSearchResult(ply)
    end

    VOICE.CycleMuteState(MUTE_NONE)

    RunConsoleCommand("ttt_mute_team_check", "0")

    if not self.ForcedMouse then
        return
    end

    gui.EnableScreenClicker(false)
end

local color_trans = Color(0, 0, 0, 0)

---
-- Cleanup the map at start of new round
-- @note Called if a new round begins (round state changes to <code>ROUND_PREP</code>)
-- @hook
-- @realm client
function GM:CleanUpMap()
    --remove thermal vision
    thermalvision.Clear()

    -- Ragdolls sometimes stay around on clients. Deleting them can create issues
    -- so all we can do is try to hide them.
    local ragdolls = ents.FindByClass("prop_ragdoll")

    for i = 1, #ragdolls do
        local ent = ragdolls[i]

        if not IsValid(ent) or not ent:IsPlayerRagdoll() then
            continue
        end

        ent:SetNoDraw(true)
        ent:SetSolid(SOLID_NONE)
        ent:SetColor(color_trans)

        -- Horrible hack to make targetid ignore this ent, because we can't
        -- modify the collision group clientside.
        ent.NoTarget = true
    end
end

---
-- Called to determine if the LocalPlayer should be drawn.
-- @note If you're using this hook to draw a @{Player} for a @{GM:CalcView} hook,
-- then you may want to consider using the drawviewer variable you can use in your
-- <a href="https://wiki.facepunch.com/gmod/Structures/CamData">CamData structure</a>
-- table instead.
-- @important You should visit the linked reference, there could be related issues
-- @param Player ply The @{Player}
-- @return[default=false] boolean True to draw the @{Player}, false to hide
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:ShouldDrawLocalPlayer
-- @local
function GM:ShouldDrawLocalPlayer(ply)
    return false
end

local view = { origin = vector_origin, angles = angle_zero, fov = 0 }

---
-- Allows override of the default view.
-- @param Player ply The local @{Player}
-- @param Vector origin The @{Player}'s view position
-- @param Angle angles The @{Player}'s view angles
-- @param number fov Field of view
-- @param number znear Distance to near clipping plane
-- @param number zfar Distance to far clipping plane
-- @return table View data table. See
-- <a href="https://wiki.facepunch.com/gmod/Structures/CamData">CamData structure</a>
-- structure
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:CalcView
-- @local
function GM:CalcView(ply, origin, angles, fov, znear, zfar)
    view.origin = origin
    view.angles = angles
    view.fov = fov

    -- first person ragdolling
    if ply:Team() == TEAM_SPEC and ply:GetObserverMode() == OBS_MODE_IN_EYE then
        local tgt = ply:GetObserverTarget()

        if IsValid(tgt) and not tgt:IsPlayer() then
            -- assume if we are in_eye and not speccing a player, we spec a ragdoll
            local eyes = tgt:LookupAttachment("eyes") or 0
            eyes = tgt:GetAttachment(eyes)

            if eyes then
                view.origin = eyes.Pos
                view.angles = eyes.Ang
            end
        end
    end

    local wep = ply:GetActiveWeapon()

    if IsValid(wep) then
        local func = wep.CalcView
        if func then
            local wepOrigin, wepAngles, wepFov = func(wep, ply, origin * 1, angles * 1, fov)

            view.origin = wepOrigin or view.origin
            view.angles = wepAngles or view.angles
            view.fov = wepFov or view.fov
        end
    end

    self:DynamicCamera(view, ply)

    return view
end

local airtime = 0
local velocity = 0
local position = 0

local frameCount = 10

local lastStrafeValue = 0
local lastFovTimeValue = 0
local curTimeShift = 0

local cvHostTimescale = GetConVar("host_timescale")

-- Handles dynamic camera features such as view bobbing, stafe tilting and fov changes.
-- @note: Parts of it are heavily inspired from V92's "Head Bobbing":
-- https://steamcommunity.com/sharedfiles/filedetails/?id=572928034
-- @param table viewTable The view table that is modified in this function
-- @param Player ply The player who's view should be modified
-- @hook
-- @realm client
function GM:DynamicCamera(viewTable, ply)
    local observerTarget = ply:GetObserverTarget()

    -- handle observing players if obs mode is OBS_MODE_FIXED, OBS_MODE_IN_EYE, OBS_MODE_CHASE or OBS_MODE_ROAMING
    if
        not ply:IsTerror()
        and IsValid(observerTarget)
        and observerTarget:IsPlayer()
        and observerTarget:GetObserverMode() >= OBS_MODE_FIXED
    then
        ply = observerTarget

    -- if something else then a player is observed, nothing should be applied here
    elseif IsValid(observerTarget) and not observerTarget:IsPlayer() then
        return
    end

    if not ply:IsTerror() or ply:GetMoveType() == MOVETYPE_NOCLIP then
        return
    end

    -- This variable is used to cache the last FOV falue on a frame by frame basis, it is used to
    -- achieve smooth transitions. It is not to be confused with the synced LastFOVValue as this only
    -- caches the FOV changes on a macro scale and has nothing to do with the animation on a frame
    -- by frame base.
    -- Also the lastFOVFrameValue variable is intentionally not always set to the current value to
    -- control the animation in such a way that FOV jumps are prohibited.
    ply.lastFOVFrameValue = ply.lastFOVFrameValue or viewTable.fov

    local dynFOV = viewTable.fov
    local mul = ply:GetSpeedMultiplier() * SPRINT:HandleSpeedMultiplierCalculation(ply)
    local desiredFOV = viewTable.fov * mul ^ (1 / 6)

    -- fixed mode: when SetZoom is set to something different than 0, this value should be used
    -- without any custom modification
    if ply:GetFOVIsFixed() then
        dynFOV = viewTable.fov

    -- dynamic mode: transition between different FOV values
    else
        local fovTime = ply:GetFOVTime()

        if lastFovTimeValue ~= fovTime then
            lastFovTimeValue = fovTime
            curTimeShift = 0
        end

        local curTime = CurTime() + curTimeShift

        -- GetFOVTime ends up in the future with lag, causing a delay in the transition (the bigger your lag, the longer the delay)
        -- shift curTime by the difference to correct it
        if curTime < fovTime then
            curTimeShift = fovTime - curTime
            curTime = curTime + curTimeShift
        end

        local time =
            math.max(0, (curTime - fovTime) * game.GetTimeScale() * cvHostTimescale:GetFloat())

        local progressTransition = math.min(1.0, time / ply:GetFOVTransitionTime())

        -- if the transition progress has reached 100%, we should enable the sprint
        -- FOV smoothing algorithm; the value 40 was determined by trying different values
        -- until it looked like a smooth transition
        if progressTransition >= 1.0 then
            if desiredFOV > ply.lastFOVFrameValue then
                desiredFOV = math.min(desiredFOV, ply.lastFOVFrameValue + FrameTime() * 40)
            elseif desiredFOV < ply.lastFOVFrameValue then
                desiredFOV = math.max(desiredFOV, ply.lastFOVFrameValue - FrameTime() * 40)
            end

            ply.lastFOVFrameValue = desiredFOV
        end

        -- make sure that FOV values of 0 are mapped to the desired FOV value
        -- which is based on the base FOV value set in the GMOD settings
        local fovNext = ply:GetFOVValue()
        local fovLast = ply:GetFOVLastValue()

        if fovNext == 0 then
            fovNext = desiredFOV
        end

        if fovLast == 0 then
            fovLast = desiredFOV
        end

        dynFOV = fovLast - (fovLast - fovNext) * progressTransition
    end

    if cvEnableDynamicFOV:GetBool() then
        viewTable.fov = dynFOV
    end

    if (not ply:IsOnGround() and ply:WaterLevel() == 0) or ply:InVehicle() then
        airtime = math.Clamp(airtime + 1, 0, 300)
    end

    local eyeAngles = ply:EyeAngles()
    local strafeValue = 0

    -- handle landing on ground
    if airtime > 0 then
        airtime = airtime / frameCount

        viewTable.angles.p = viewTable.angles.p + airtime * 0.01 -- pitch cam shake on land
        viewTable.angles.r = viewTable.angles.r + airtime * 0.02 * math.Rand(-1, 1) -- roll cam shake on land
    end

    -- handle crouching
    if ply:Crouching() then
        local velocityMultiplier = ply:GetVelocity() * 2

        velocity = velocity * 0.9 + velocityMultiplier:Length() * 0.1
        position = position + velocity * FrameTime() * 0.1

        strafeValue = eyeAngles:Right():Dot(velocityMultiplier) * 0.015

    -- handle swimming
    elseif ply:WaterLevel() > 0 then
        local velocityMultiplier = ply:GetVelocity() * 1.5

        velocity = velocity * 0.9 + velocityMultiplier:Length() * 0.1
        position = position + velocity * FrameTime() * 0.1

        strafeValue = eyeAngles:Right():Dot(velocityMultiplier) * 0.005

    -- handle walking
    else
        local velocityMultiplier = ply:GetVelocity() * 0.75

        velocity = velocity * 0.9 + velocityMultiplier:Length() * 0.1
        position = position + velocity * FrameTime() * 0.1

        strafeValue = eyeAngles:Right():Dot(velocityMultiplier) * 0.006
    end

    strafeValue = math.Round(strafeValue, 2)
    lastStrafeValue = math.Round(lastStrafeValue, 2)

    if strafeValue > lastStrafeValue then
        lastStrafeValue = math.min(strafeValue, lastStrafeValue + FrameTime() * 35.0)
    elseif strafeValue < lastStrafeValue then
        lastStrafeValue = math.max(strafeValue, lastStrafeValue - FrameTime() * 35.0)
    else
        lastStrafeValue = strafeValue
    end

    if cvEnableBobbing:GetBool() then
        viewTable.angles.r = viewTable.angles.r + math.sin(position * 0.5) * velocity * 0.001
        viewTable.angles.p = viewTable.angles.p + math.sin(position * 0.25) * velocity * 0.001
    end

    if cvEnableBobbingStrafe:GetBool() then
        viewTable.angles.r = viewTable.angles.r + lastStrafeValue
    end
end

---
-- Adds a death notice entry.
-- @param string attacker The name of the attacker
-- @param number attackerTeam The team of the attacker
-- @param string inflictor Class name of the @{Entity} inflicting the damage
-- @param string victim Name of the victim
-- @param string victimTeam Team of the victim
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:AddDeathNotice
-- @local
function GM:AddDeathNotice(attacker, attackerTeam, inflictor, victim, victimTeam) end

---
-- This hook is called every frame to draw all of the current death notices.
-- @param number x X position to draw death notices as a ratio
-- @param number y Y position to draw death notices as a ratio
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:DrawDeathNotice
-- @local
function GM:DrawDeathNotice(x, y) end

-- Simple client-based idle checking
local idle = {
    btn = 0,
    mx = 0,
    my = 0,
    t = 0,
    last_check = 0,
}

---
-- Sniff for any button inputs to prevent scamming the AFK timer.
-- @realm client
hook.Add("SetupMove", "TTT2IdleCheck", function(_, mv)
    if not GetGlobalBool("ttt_idle", false) then
        return
    end

    if mv:GetButtons() ~= idle.btn then
        idle.t = CurTime()
    end

    idle.btn = mv:GetButtons()
end)

---
-- Checks whether a the local @{Player} is idle and handles everything on it's own
-- @note This is doing every 5 seconds by the "idlecheck" timer
-- @realm client
-- @internal
function CheckIdle()
    local client = LocalPlayer()

    if
        GetGlobalBool("ttt_idle", false)
        and IsValid(client)
        and gameloop.GetRoundState() == ROUND_ACTIVE
        and client:IsTerror()
        and client:Alive()
        and client:IsFullySignedOn()
    then
        local idle_limit = GetGlobalInt("ttt_idle_limit", 300) or 300

        if idle_limit <= 0 then -- networking sucks sometimes
            idle_limit = 300
        end

        if gui.MouseX() ~= idle.mx or gui.MouseY() ~= idle.my then
            -- Players in eg. the Help will move their mouse occasionally
            idle.mx = gui.MouseX()
            idle.my = gui.MouseY()
            idle.t = CurTime()
        elseif CurTime() > idle.t + idle_limit then
            RunConsoleCommand("say", TryT("automoved_to_spec"))

            timer.Simple(0, function() -- move client into the spectator team in the next frame
                RunConsoleCommand("ttt_spectator_mode", 1)

                net.Start("TTT_Spectate")
                net.WriteBool(true)
                net.SendToServer()

                RunConsoleCommand("ttt_cl_idlepopup")
            end)
        elseif CurTime() > idle.t + (idle_limit * 0.5) then
            -- will repeat
            LANG.Msg("idle_warning")
        end
    else
        idle.t = CurTime()
    end
end

---
-- Called when the entity is created.
-- @note Some entities on initial map spawn are passed through this hook, and then removed in the same frame.
-- This is used by the engine to precache things like models and sounds, so always check their validity with @{IsValid}.
-- @warning Removing the created entity during this event can lead to unexpected problems.
-- Use <code>@{timer.Simple}( 0, .... )</code> to safely remove the entity.
-- @param Entity ent The @{Entity}
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:OnEntityCreated
-- @local
function GM:OnEntityCreated(ent)
    -- Make ragdolls look like the player that has died
    if ent:IsPlayerRagdoll() then
        local ply = CORPSE.GetPlayer(ent)

        if IsValid(ply) then
            -- Only copy any decals if this ragdoll was recently created
            if ent:GetCreationTime() > CurTime() - 1 then
                ent:SnatchModelInstance(ply)
            end

            -- Copy the color for the PlayerColor matproxy
            local playerColor = ply:GetPlayerColor()

            ent.GetPlayerColor = function()
                return playerColor
            end
        end
    end

    return self.BaseClass.OnEntityCreated(self, ent)
end

net.Receive("TTT2PlayerAuthedShared", function(len)
    local steamid64 = net.ReadString()
    local name = net.ReadString()

    -- checking for bots
    if steamid64 == "" then
        steamid64 = nil
    end

    ---
    -- @realm shared
    hook.Run("TTT2PlayerAuthed", steamid64, name)
end)

---
-- This hook is called once after the player authentificated. It is a mirror of
-- @{GM:PlayerAuthed} that relays this information for every player to the client.
-- @param string steamID64 The player's steamID64
-- @param string name The player's name
-- @hook
-- @realm client
function GM:TTT2PlayerAuthed(steamID64, name) end
