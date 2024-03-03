local net = net

local plymeta = FindMetaTable("Player")
if not plymeta then
    ErrorNoHaltWithStack("FAILED TO FIND PLAYER TABLE")

    return
end

---
-- @realm client
-- stylua: ignore
local cvEnableBobbing = CreateConVar("ttt2_enable_bobbing", "1", FCVAR_ARCHIVE)

---
-- @realm client
-- stylua: ignore
local cvEnableBobbingStrafe = CreateConVar("ttt2_enable_bobbing_strafe", "1", FCVAR_ARCHIVE)

-- @realm client
-- stylua: ignore
local cvEnableDynamicFOV = CreateConVar("ttt2_enable_dynamic_fov", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

cvars.AddChangeCallback("ttt2_enable_dynamic_fov", function(_, _, valueNew)
    LocalPlayer():SetSettingOnServer("enable_dynamic_fov", tobool(valueNew))
end)

---
-- Applies a animation gesture
-- @param ACT act The @{ACT} or sequence that should be played
-- @param number weight The weight this slot should be set to. Value must be ranging from 0 to 1.
-- @realm client
-- @see https://wiki.facepunch.com/gmod/Player:AnimRestartGesture
-- @see https://wiki.facepunch.com/gmod/Player:AnimSetGestureWeight
function plymeta:AnimApplyGesture(act, weight)
    self:AnimRestartGesture(GESTURE_SLOT_CUSTOM, act, true) -- true = autokill
    self:AnimSetGestureWeight(GESTURE_SLOT_CUSTOM, weight)
end

local function MakeSimpleRunner(act)
    return function(ply, w)
        -- just let this gesture play itself and get out of its way
        if w == 0 then
            ply:AnimApplyGesture(act, 1)

            return 1
        else
            return 0
        end
    end
end

-- act -> gesture runner fn
local act_runner = {
    -- ear grab needs weight control
    -- sadly it's currently the only one
    [ACT_GMOD_IN_CHAT] = function(ply, w)
        local dest = ply:IsSpeaking() and 1 or 0

        w = math.Approach(w, dest, FrameTime() * 10)
        if w > 0 then
            ply:AnimApplyGesture(ACT_GMOD_IN_CHAT, w)
        end

        return w
    end,
}

-- Insert all the "simple" gestures that do not need weight control
local gestTbl = {
    ACT_GMOD_GESTURE_AGREE,
    ACT_GMOD_GESTURE_DISAGREE,
    ACT_GMOD_GESTURE_WAVE,
    ACT_GMOD_GESTURE_BECON,
    ACT_GMOD_GESTURE_BOW,
    ACT_GMOD_TAUNT_SALUTE,
    ACT_GMOD_TAUNT_CHEER,
    ACT_SIGNAL_FORWARD,
    ACT_SIGNAL_HALT,
    ACT_SIGNAL_GROUP,
    ACT_GMOD_GESTURE_ITEM_PLACE,
    ACT_GMOD_GESTURE_ITEM_DROP,
    ACT_GMOD_GESTURE_ITEM_GIVE,
}

for _i = 1, #gestTbl do
    local a = gestTbl[_i]

    act_runner[a] = MakeSimpleRunner(a)
end

---
-- @realm client
-- stylua: ignore
local cv_ttt_show_gestures = CreateConVar("ttt_show_gestures", "1", FCVAR_ARCHIVE)

---
-- Perform the gesture using the GestureRunner system. If custom_runner is
-- non-nil, it will be used instead of the default runner for the act.
-- @param ACT act The @{ACT} or sequence that should be played
-- @param table custom_runner
-- @return boolean success?
-- @realm client
function plymeta:AnimPerformGesture(act, custom_runner)
    if not cv_ttt_show_gestures or cv_ttt_show_gestures:GetInt() == 0 then
        return
    end

    local runner = custom_runner or act_runner[act]
    if not runner then
        return false
    end

    self.GestureWeight = 0
    self.GestureRunner = runner

    return true
end

---
-- Perform a gesture update
-- @realm client
function plymeta:AnimUpdateGesture()
    if not self.GestureRunner then
        return
    end

    self.GestureWeight = self:GestureRunner(self.GestureWeight)

    if self.GestureWeight <= 0 then
        self.GestureRunner = nil
    end
end

---
-- @hook
-- @param Player ply The player to update the animation info for.
-- @param Vector vel The player's velocity.
-- @param number maxseqgroundspeed Speed of the animation - used for playback rate scaling.
-- @return any ?
-- @realm client
function GM:UpdateAnimation(ply, vel, maxseqgroundspeed)
    ply:AnimUpdateGesture()

    return self.BaseClass.UpdateAnimation(self, ply, vel, maxseqgroundspeed)
end

---
-- @param Player ply
-- @hook
-- @realm client
function GM:GrabEarAnimation(ply) end

local function TTT_PerformGesture()
    local ply = net.ReadEntity()
    local act = net.ReadUInt(16)

    if not IsValid(ply) or act == nil then
        return
    end

    ply:AnimPerformGesture(act)
end
net.Receive("TTT_PerformGesture", TTT_PerformGesture)

local function StartDrowning()
    local client = LocalPlayer()
    if not IsValid(client) then
        return
    end

    local bool = net.ReadBool()

    client:StartDrowning(bool, bool and net.ReadUInt(16), bool and net.ReadUInt(16))
end
net.Receive("StartDrowning", StartDrowning)

local function TargetPlayer()
    local client = LocalPlayer()
    local target = net.ReadEntity()

    if not IsValid(client) then
        return
    end

    if not IsValid(target) or not target:IsPlayer() or target:IsWorld() then
        target = nil
    end

    if target == nil or IsValid(target) and target:IsActive() and target:Alive() then
        client:SetTargetPlayer(target)
    end
end
net.Receive("TTT2TargetPlayer", TargetPlayer)

local function UpdateCredits()
    local client = LocalPlayer()
    if not IsValid(client) then
        return
    end

    client.equipment_credits = net.ReadUInt(8)
end
net.Receive("TTT_Credits", UpdateCredits)

local function UpdateEquipment()
    local client = LocalPlayer()
    if not IsValid(client) then
        return
    end

    local mode = net.ReadUInt(2)

    local equipItems = client:GetEquipmentItems()

    if mode == EQUIPITEMS_RESET then
        for i = #equipItems, 1, -1 do
            local itemName = equipItems[i]
            local item = items.GetStored(itemName)

            if item and isfunction(item.Reset) then
                item:Reset(client)
            end
        end

        table.Empty(equipItems)
    else
        local itemName = net.ReadString()
        local item = items.GetStored(itemName)

        if mode == EQUIPITEMS_ADD then
            equipItems[#equipItems + 1] = itemName

            if item and isfunction(item.Equip) then
                item:Equip(client)
            end
        elseif mode == EQUIPITEMS_REMOVE then
            table.RemoveByValue(equipItems, itemName)

            if item and isfunction(item.Reset) then
                item:Reset(client)
            end
        end
    end
end
net.Receive("TTT_Equipment", UpdateEquipment)

---
-- SetupMove is called before the engine process movements. This allows us
-- to override the players movement.
-- @param Player ply The @{Player} that sets up its movement
-- @param CMoveData mv The move data to override/use
-- @param CUserCmd cmd The command data
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:SetupMove
-- @local
function GM:SetupMove(ply, mv, cmd)
    if not IsValid(ply) or ply:IsReady() then
        return
    end

    ply.isReady = true

    net.Start("TTT2SetPlayerReady")
    net.SendToServer()

    ---
    -- @realm shared
    -- stylua: ignore
    hook.Run("TTT2PlayerReady", ply)

    -- check if a resolution change happened while
    -- the gamemode was inactive
    oldScrW = appearance.GetLastWidth()
    oldScrH = appearance.GetLastHeight()

    if oldScrH ~= ScrH() or oldScrW ~= ScrW() then
        ---
        -- @realm client
        -- stylua: ignore
        hook.Run("OnScreenSizeChanged", oldScrW, oldScrH)
    end
end

---
-- Sets a revival reason that is displayed in the revival HUD element.
-- It supports a language identifier for translated strings.
-- @param[default=nil] string name The text or the language identifier, nil to reset
-- @param[opt] table params The params table used for @{LANG.GetParamTranslation}
-- @realm client
function plymeta:SetRevivalReason(name, params)
    self.revivalReason = {}
    self.revivalReason.name = name
    self.revivalReason.params = params
end

net.Receive("TTT2SetRevivalReason", function()
    local client = LocalPlayer()

    if not IsValid(client) then
        return
    end

    local isReset = net.ReadBool()
    local name, params

    if not isReset then
        name = net.ReadString()

        local paramsAmount = net.ReadUInt(8)

        if paramsAmount > 0 then
            params = {}

            for i = 1, paramsAmount do
                params[net.ReadString()] = net.ReadString()
            end
        end
    end

    client:SetRevivalReason(name, params)
end)

-- plays an error sound only on the local player, not for all players
net.Receive("TTT2RevivalStopped", function()
    LocalPlayer():EmitSound("buttons/button8.wav")
end)

net.Receive("TTT2RevivalUpdate_IsReviving", function()
    local client = LocalPlayer()

    client.isReviving = net.ReadBool()

    if not client.isReviving then
        return
    end

    if not system.HasFocus() then
        system.FlashWindow()
    end
    client:EmitSound("items/smallmedkit1.wav")
end)

net.Receive("TTT2RevivalUpdate_RevivalBlockMode", function()
    LocalPlayer().revivalBlockMode = net.ReadUInt(REVIVAL_BITS)
end)

net.Receive("TTT2RevivalUpdate_RevivalStartTime", function()
    LocalPlayer().revivalStartTime = net.ReadFloat()
end)

net.Receive("TTT2RevivalUpdate_RevivalDuration", function()
    LocalPlayer().revivalDurarion = net.ReadFloat()
end)

---
-- Returns if a player has a revival reason set.
-- @return[default=false] boolean Returns if a player has a revival reason
-- @realm client
function plymeta:HasRevivalReason()
    return (self.revivalReason and self.revivalReason.name and self.revivalReason.name ~= "")
        or false
end

---
-- Returns the current revival reason.
-- @return[default={}] table The revival reason table
-- @realm client
function plymeta:GetRevivalReason()
    return self.revivalReason or {}
end

---
-- Sets a shared playersetting from the client on both server and client. Make sure the
-- variable is registered with `RegisterSettingOnServer` as the setting is otherwise discarded.
-- @param string identifier The identifier of the shared setting
-- @param any value The setting's value, it is parsed as a string before transmitting
-- @realm client
function plymeta:SetSettingOnServer(identifier, value)
    self.playerSettings = self.playerSettings or {}

    if self.playerSettings[identifier] == value then
        return
    end

    local oldValue = self.playerSettings[identifier]

    self.playerSettings[identifier] = value

    net.Start("ttt2_set_player_setting")
    net.WriteString(identifier)
    net.WriteString(tostring(value))
    net.SendToServer()

    ---
    -- @realm shared
    -- stylua: ignore
    hook.Run("TTT2PlayerSettingChanged", self, identifier, oldValue, self.playerSettings[identifier])
end

local airtime = 0
local velocity = 0
local position = 0

local frameCount = 10

local lastStrafeValue = 0

local cvHostTimescale = GetConVar("host_timescale")

-- handles dynamic camera features such as view bobbing, stafe tilting and fov changes
-- parts of it are heavily inspired from V92's "Head Bobbing": https://steamcommunity.com/sharedfiles/filedetails/?id=572928034
hook.Add("CalcView", "TTT2DynamicCamera", function(ply, origin, angles, fov)
    local observerTarget = ply:GetObserverTarget()

    -- handle observing players
    if not ply:IsTerror() and IsValid(obersverTarget) and observerTarget:IsPlayer() then
        ply = observerTarget
    end

    if not ply:IsTerror() or ply:GetMoveType() == MOVETYPE_NOCLIP then
        return
    end

    local view = {
        ply = ply,
        origin = origin,
        angles = angles,
        fov = fov,
    }

    -- This variable is used to cache the last FOV falue on a frame by frame basis, it is used to
    -- achieve smooth transitions. It is not to be confused with the synced LastFOVValue as this only
    -- caches the FOV changes on a macro scale and has nothing to do with the animation on a frame
    -- by frame base.
    -- Also the lastFOVFrameValue variable is intentionally not always set to the current value to
    -- control the animation in such a way that FOV jumps are prohibited.
    ply.lastFOVFrameValue = ply.lastFOVFrameValue or fov

    local dynFOV = fov
    local mul = ply:GetSpeedMultiplier() * SPRINT:HandleSpeedMultiplierCalculation(ply)
    local desiredFOV = fov * mul ^ (1 / 6)

    -- fixed mode: when SetZoom is set to something different than 0, this value should be used
    -- without any custom modification
    if ply:GetFOVIsFixed() then
        dynFOV = fov

    -- dynamic mode: transition between different FOV values
    else
        local time = math.max(
            0,
            (CurTime() - ply:GetFOVTime()) * game.GetTimeScale() * cvHostTimescale:GetFloat()
        )

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
        view.fov = dynFOV
    end

    if (not ply:IsOnGround() and ply:WaterLevel() == 0) or ply:InVehicle() then
        airtime = math.Clamp(airtime + 1, 0, 300)

        return view
    end

    local eyeAngles = ply:EyeAngles()
    local strafeValue = 0

    -- handle landing on ground
    if airtime > 0 then
        airtime = airtime / frameCount

        view.angles.p = view.angles.p + airtime * 0.01 -- pitch cam shake on land
        view.angles.r = view.angles.r + airtime * 0.02 * math.Rand(-1, 1) -- roll cam shake on land
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
        view.angles.r = view.angles.r + math.sin(position * 0.5) * velocity * 0.001
        view.angles.p = view.angles.p + math.sin(position * 0.25) * velocity * 0.001
    end

    if cvEnableBobbingStrafe:GetBool() then
        view.angles.r = view.angles.r + lastStrafeValue
    end

    return view
end)
