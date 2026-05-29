---
-- This file contains all shared gamemode hooks needed when the gamemode initializes

local IsValid = IsValid
local hook = hook
local team = team
local playerGetAll = player.GetAll

local MAX_DROWN_TIME = 8

local sneakSpeedSquared = math.pow(150, 2)

TTT2ShopFallbackInitialized = false

local callbackIdentifier = "TTT2RegisteredSWEPCallback"

---
-- Add callback for equipment and insert changes in the given equipmentTable
-- @param string name the database-name of the equipment
-- @param table equipmentTable the table to insert changes to
-- @realm shared
local function AddCallbacks(name, equipmentTable)
    -- Make sure that on hot reloads old callbacks are removed before adding the new one
    database.RemoveChangeCallback(ShopEditor.accessName, name, nil, callbackIdentifier)
    database.AddChangeCallback(
        ShopEditor.accessName,
        name,
        nil,
        function(accessName, itemName, key, oldValue, newValue)
            if not istable(equipmentTable) then
                database.RemoveChangeCallback(ShopEditor.accessName, name, nil, callbackIdentifier)

                return
            end

            equipmentTable[key] = newValue
        end,
        callbackIdentifier
    )
end

---
-- Initializes the equipment with necessary data for ttt2
-- Also handles hotreload when called with the `PreRegisterSWEP` hook
-- @param table equipment equipment to register
-- @param string name equipment name
-- @param boolean initialize should the real weapon table be initialized and not hotreloaded?
-- @internal
-- @realm shared
local function TTT2RegisterSWEP(equipment, name, initialize)
    local doHotreload = TTT2ShopFallbackInitialized

    -- Handle first initialization or do hotreload
    if initialize then
        equipment = weapons.GetStored(name)
        doHotreload = false
    elseif not doHotreload then
        return
    end

    if doHotreload then
        Dev(1, "[TTT2] Trying to hotreload ", name, " .")
    end

    -- Initialize Equipment
    AddEquipmentKeyValues(equipment, name)
    ShopEditor.InitDefaultData(equipment)

    if doHotreload then
        local oldSWEP = weapons.GetStored(name)

        -- Keep custom changed data from the old SWEP if hotReloadableKeys are given
        if
            istable(equipment.HotReloadableKeys)
            and #equipment.HotReloadableKeys > 0
            and oldSWEP
        then
            Dev(
                1,
                "[TTT2] Hotreloading ",
                #equipment.HotReloadableKeys,
                " given Keys from old SWEP-file."
            )

            for _, keys in pairs(equipment.HotReloadableKeys) do
                local eqKeyField = equipment
                local oldKeyField = oldSWEP
                local keyString = ""

                -- If only a single key is given, not a table, convert it
                if isstring(keys) then
                    keys = { keys }
                end

                if not istable(keys) then
                    continue
                end

                local continueOuterLoop = false
                local counter = 0
                local saveKey = keys[1]

                for _, key in pairs(keys) do
                    if not isstring(key) or not oldKeyField then
                        continueOuterLoop = true

                        break
                    end

                    keyString = keyString .. "." .. key
                    counter = counter + 1
                    eqKeyField[key] = eqKeyField[key] or {}
                    oldKeyField = oldKeyField[key]

                    -- To keep eqKeyField as reference check for tables or create one
                    if counter < #keys and not istable(eqKeyField[key]) then
                        eqKeyField[key] = {}
                    elseif counter == #keys then
                        saveKey = key

                        break
                    end

                    eqKeyField = eqKeyField[key]
                end

                if continueOuterLoop then
                    continue
                end

                Dev(
                    1,
                    "[TTT2] Overwriting SWEP",
                    keyString,
                    " = ",
                    tostring(eqKeyField[saveKey]),
                    " with ",
                    tostring(oldKeyField)
                )

                eqKeyField[saveKey] = oldKeyField
            end
        end

        ResetDefaultEquipment(equipment)
    end

    if
        SERVER
        and database.Register(
            ShopEditor.sqlItemsName,
            ShopEditor.accessName,
            ShopEditor.savingKeys,
            TTT2_DATABASE_ACCESS_ANY
        )
    then
        database.SetDefaultValuesFromItem(ShopEditor.accessName, name, equipment)
        local databaseExists, itemTable = database.GetValue(ShopEditor.accessName, name)
        if databaseExists then
            table.Merge(equipment, itemTable)
        end
        AddCallbacks(name, equipment)
    elseif CLIENT then
        database.GetValue(ShopEditor.accessName, name, nil, function(databaseExists, itemTable)
            if databaseExists then
                table.Merge(equipment, itemTable)
                AddCallbacks(name, equipment)
            end
        end)
    end

    if not doHotreload then
        return
    end

    -- initialize fallback shops
    InitFallbackShops()

    if SERVER then
        LoadShopsEquipment()

        -- Force Precache Models
        if equipment.WorldModel then
            util.PrecacheModel(equipment.WorldModel)
        end

        if equipment.ViewModel then
            util.PrecacheModel(equipment.ViewModel)
        end
    elseif CLIENT then
        ShopEditor.BuildValidEquipmentCache()
        net.Start("TTT2SyncShopsWithServer")
        net.SendToServer()
    end

    Dev(1, "[TTT2] Hotreloading ", name, " was successful.")

    return
end

---
-- Runs before registering a weapon via the weapons module
-- Also runs, when a SWEP-file is hotreloaded
-- @realm shared
hook.Add("PreRegisterSWEP", "TTT2RegisterSWEP", TTT2RegisterSWEP)

---
-- Called in @{GM:Initialize} as first call right before the TTT2 fileloader
-- loads the vskin and language files.
-- @hook
-- @realm shared
function GM:TTT2Initialize()
    -- load all roles
    roles.OnLoaded()

    ---
    -- @realm shared
    hook.Run("TTT2RolesLoaded")

    ---
    -- @realm shared
    hook.Run("TTT2BaseRoleInit")

    DefaultEquipment = GetDefaultEquipment()

    shop.Initialize()
end

---
-- Called when TTT2 is finished loading on startup and hotreload.
-- @hook
-- @realm shared
function GM:TTT2FinishedLoading() end

---
-- Called after everything in the @{GM:Initialize} hook is called.
-- @hook
-- @realm shared
function GM:PostInitialize() end

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
-- Kill footsteps on player and client.
-- Called whenever a player steps. Return true to mute the normal sound.
-- @note This hook is called on all clients.
-- @param Player ply The stepping player
-- @param Vector pos The position of the step
-- @param number foot Foot that is stepped. 0 for left, 1 for right
-- @param string sound Sound that is going to play
-- @param number volume Volume of the footstep
-- @param RecipientFilter rf The Recipient filter of players who can hear the footstep
-- @return[default=true] boolean Prevent default step sound
-- @predicted
-- @hook
-- @realm shared
-- @ref https://wiki.facepunch.com/gmod/GM:PlayerFootstep
function GM:PlayerFootstep(ply, pos, foot, sound, volume, rf)
    if IsValid(ply) and (ply:GetVelocity():LengthSqr() < sneakSpeedSquared or ply:IsSpec()) then
        -- do not play anything, just prevent normal sounds from playing
        return true
    end
end

---
-- The Move hook is called for you to manipulate the player's MoveData.
-- You shouldn't adjust the player's position in any way in the move hook. This is due to
-- prediction errors, the netcode might run the move hook multiple times as packets arrive late.
-- Therefore you should only adjust the movedata construct in this hook.
-- Generally you shouldn't have to use this hook - if you want to make a custom move type you should look at the drive system.
-- This hook is called after @{GM:PlayerTick}.
-- See <a href="https://wiki.facepunch.com/gmod/Game_Movement">Game Movement</a> for an explanation on the move system.
-- @param Player ply The player
-- @param CMoveData moveData Movement information
-- @predicted
-- @hook
-- @realm shared
-- @ref https://wiki.facepunch.com/gmod/GM:Move
function GM:Move(ply, moveData)
    -- stop movement while in loading screen
    if loadingscreen.isShown then
        return true
    end

    SPEED:HandleSpeedCalculation(ply, moveData)

    local mul = ply:GetSpeedMultiplier()

    mul = mul * SPRINT:HandleSpeedMultiplierCalculation(ply)

    moveData:SetMaxClientSpeed(moveData:GetMaxClientSpeed() * mul)
    moveData:SetMaxSpeed(moveData:GetMaxSpeed() * mul)
end

-- @param Player ply The player
-- @param MoveData moveData Movement information
-- @predicted
-- @hook
-- @realm shared
-- @ref https://wiki.facepunch.com/gmod/GM:FinishMove
function GM:FinishMove(ply, moveData)
    SPRINT:HandleStaminaCalculation(ply)
end

---
-- This hook is called every time a connecting client advances progress to signing on.
-- @param number userID The userID of the player whose sign on state has changed.
-- @param number oldState The previous sign on state. See @{SIGNONSTATE} enums.
-- @param number newState The new/current sign on state. See @{SIGNONSTATE} enums.
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:ClientSignOnStateChanged
-- @local
function GM:ClientSignOnStateChanged(userID, oldState, newState)
    GAMEMODE.PlayerSignOnStates = GAMEMODE.PlayerSignOnStates or {}
    GAMEMODE.PlayerSignOnStates[userID] = newState
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
        COLOR_ORANGE,
    },
    serious = {
        COLOR_WHITE,
        COLOR_BLACK,
        COLOR_NAVY,
        COLOR_LGRAY,
        COLOR_DGREEN,
        COLOR_OLIVE,
    },
}
local ttt_playercolors_all_count = #ttt_playercolors.all
local ttt_playercolors_serious_count = #ttt_playercolors.serious

---
-- @realm shared
local colormode =
    CreateConVar("ttt_playercolor_mode", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED })

---
-- @param string model The selected (default) playermodel
-- @hook
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
-- Called every frame on client and server.
-- This will be the same as @{GM:Tick} on the server when there is no lag,
-- but will only be called once every processed server frame during lag.
-- See @{GM:Tick} for a hook that runs every tick on both the client and server.
-- @note This hook WILL NOT run if the server is empty, unless you set the @{ConVar} `sv_hibernate_think` to `1`
-- @hook
-- @realm shared
-- @ref https://wiki.facepunch.com/gmod/GM:Think
function GM:Think()
    if CLIENT then
        EPOP:Think()
    end
end

---
-- Used to modify the player sprint speed modifier.
-- @note This hook is predicted, it therefore hat to be run on the server and the client.
-- @param Player ply The player whose sprint speed should be changed
-- @param table sprintMultiplierModifier The modieable table with the sprint speed multiplier
-- @hook
-- @realm shared
function GM:TTT2PlayerSprintMultiplier(ply, sprintMultiplierModifier) end

-- Drowning and such
local tm, ply, plys

---
-- Called every server tick. Serverside, this is similar to @{GM:Think}.
-- @note This hook WILL NOT run if the server is empty, unless you set the @{ConVar} `sv_hibernate_think` to `1`
-- @hook
-- @realm shared
-- @ref https://wiki.facepunch.com/gmod/GM:Tick
function GM:Tick()
    local client = CLIENT and LocalPlayer()

    if client and not IsValid(client) then
        return
    end

    -- three cheers for micro-optimizations
    plys = client and { client } or playerGetAll()

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
                        ply.drowningProgress =
                            math.max(0, (ply.drowning - CurTime()) * (1 / drowningTime))
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

        voicebattery.Tick()
    end
end

---
-- A hook that is called when the preparation phase starts.
-- @hook
-- @realm shared
function GM:TTTPrepareRound()
    shop.Reset()
end

---
-- A hook that is called when the round begins.
-- @hook
-- @realm shared
function GM:TTTBeginRound() end

-- A hook that is called when the round ends.
-- @hook
-- @realm shared
function GM:TTTEndRound() end

---
-- Called right after the map has been cleaned up (usually because game.CleanUpMap was called).
-- This hook is called after the @{outputs} library is set up and map entity outputs can be
-- registered.
-- @hook
-- @realm shared
function GM:TTT2PostCleanupMap() end

---
-- This hook is run inside @{GM:InitPostEntity} prior to the initialization of items,
-- @hook
-- @realm shared
function GM:TTTInitPostEntity() end

---
-- This hook is run inside @{GM:InitPostEntity} after all items are initialized.
-- @hook
-- @realm shared
function GM:PostInitPostEntity() end

---
-- This hook is run on the initialization of the fallback shops.
-- @hook
-- @realm shared
function GM:InitFallbackShops() end

---
-- This hook is run after the initialization of the fallback shops.
-- @hook
-- @realm shared
function GM:LoadedFallbackShops() end

-- Called after all roles were loaded, @{ROLE:Preinitialize} and @{ROLE:Initialize} were called
-- and their convars were set up.
-- @hook
-- @realm shared
function GM:TTT2RolesLoaded() end

-- Called after all roles were loaded, @{ROLE:Preinitialize} and @{ROLE:Initialize} were called
-- and their convars were set up.
-- @hook
-- @realm shared
function GM:TTT2BaseRoleInit() end

---
-- Called to register equipment and assign an id. Returns true if it is successfully registered.
-- @param table eq the equipment copy to register with an id
-- @return boolean if the eq is succesfully registered
-- @hook
-- @realm shared
function GM:TTT2RegisterWeaponID(eq)
    if eq.id then
        return true
    end

    local class = WEPS.GetClass(eq)

    TTT2RegisterSWEP(eq, class, true)

    eq = weapons.Get(class)

    if eq.id then
        return true
    end

    local name = eq.PrintName or class

    if name then
        Dev(2, name .. " cant be assigned an id.")
    else
        Dev(2, "No id could be assigned. Equipment has no name.")
    end

    ErrorNoHaltWithStack(
        "[TTT2][IDCHECK][ERROR] Equipment is invalid after registration attempt and has no id.\n"
    )
    PrintTable(eq)

    return false
end
