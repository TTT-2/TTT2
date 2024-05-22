---
-- Handles the loading screen that is shown on map reload.
-- @author Mineotopia

if SERVER then
    AddCSLuaFile()

    util.AddNetworkString("TTT2LoadingscreenStart")
end

loadingscreen = loadingscreen or {}

loadingscreen.isInReloading = false
loadingscreen.wasInReloading = false

loadingscreen.disableSounds = false

function loadingscreen.Begin()
    loadingscreen.isInReloading = true
    loadingscreen.disableSounds = true

    -- add manual syncing so that the loading screen starts as soon as the
    -- cleanup map is started
    if SERVER then
        net.Start("TTT2LoadingscreenStart")
        net.Broadcast()
    end
end

function loadingscreen.End()
    loadingscreen.isInReloading = false

    if SERVER then
        -- disables sounds a while longer so it stays muted
        timer.Simple(2, function()
            loadingscreen.disableSounds = false
        end)
    end
end

function loadingscreen.IsInReloading()
    return loadingscreen.isInReloading or false
end

if SERVER then
    -- mutes the sound while the loading screen is shown
    -- this makes it so that you can't hear weapons spawning
    hook.Add("EntityEmitSound", "TTT2PreventReloadingSound", function(data)
        if loadingscreen.disableSounds then
            return false
        end
    end)
end

if CLIENT then
    local LS_HIDDEN = 0
    local LS_FADE_IN = 1
    local LS_SHOWN = 2
    local LS_FADE_OUT = 3

    local durationStateChange = 0.35

    local colorLoadingScreen = Color(170, 210, 245, 255)

    loadingscreen.state = LS_HIDDEN
    loadingscreen.timeStateChange = SysTime()

    net.Receive("TTT2LoadingscreenStart", function()
        loadingscreen.Begin()
    end)

    function loadingscreen.Handler()
        -- start reloading screen
        if loadingscreen.isInReloading and not loadingscreen.wasInReloading then
            loadingscreen.state = LS_FADE_IN
            loadingscreen.timeStateChange = SysTime()

            timer.Simple(durationStateChange, function()
                loadingscreen.state = LS_SHOWN
                loadingscreen.timeStateChange = SysTime()
            end)

            loadingscreen.wasInReloading = true

        -- stop reloading screen
        elseif not loadingscreen.isInReloading and loadingscreen.wasInReloading then
            loadingscreen.state = LS_FADE_OUT
            loadingscreen.timeStateChange = SysTime()

            timer.Simple(durationStateChange * 2, function()
                loadingscreen.state = LS_HIDDEN
                loadingscreen.timeStateChange = SysTime()
            end)

            loadingscreen.wasInReloading = false
        end

        loadingscreen.Draw()
    end

    function loadingscreen.Draw()
        if loadingscreen.state == LS_HIDDEN then
            return
        end

        local progress = 1

        if loadingscreen.state == LS_FADE_IN then
            progress =
                math.min((SysTime() - loadingscreen.timeStateChange) / durationStateChange, 1.0)
        elseif loadingscreen.state == LS_FADE_OUT then
            progress = 1
                - math.min((SysTime() - loadingscreen.timeStateChange) / durationStateChange, 1.0)
        end

        colorLoadingScreen.a = 160 * progress

        draw.BlurredBox(0, 0, ScrW(), ScrH(), progress * 5)
        draw.Box(0, 0, ScrW(), ScrH(), colorLoadingScreen)
    end
end
