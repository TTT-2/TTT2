---
-- Handles the loading screen that is shown on map reload.
-- @author Mineotopia

if SERVER then
    AddCSLuaFile()

    util.AddNetworkString("TTT2LoadingScreenActive")
end

---
-- @realm server
-- stylua: ignore
local cvLoadingScreenEnabled = CreateConVar("ttt2_enable_loadingscreen_server", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED })

---
-- @realm server
-- stylua: ignore
local cvLoadingScreenMinDuration = CreateConVar("ttt2_loadingscreen_min_duration", "4", { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED })

loadingscreen = loadingscreen or {}

loadingscreen.isShown = false
loadingscreen.wasShown = false

loadingscreen.disableSounds = false

---
-- Called when the loading screen should begin.
-- @note Syncs it to the client when called on the server.
-- @internal
-- @realm shared
function loadingscreen.Begin()
    if not cvLoadingScreenEnabled:GetBool() then
        return
    end

    -- add manual syncing so that the loading screen starts as soon as the
    -- cleanup map is started
    if SERVER then
        loadingscreen.timeBegin = SysTime()

        timer.Remove("TTT2LoadingscreenEndTime")

        net.Start("TTT2LoadingScreenActive")
        net.WriteBool(true)
        net.Broadcast()
    end

    if CLIENT then
        timer.Remove("TTT2LoadingscreenShow")
        timer.Remove("TTT2LoadingscreenHide")

        loadingscreen.currentTipText, loadingscreen.currentTipKeys = tips.GetRandomTip()

        MSTACK:ClearMessages()
    end

    loadingscreen.isShown = true
    loadingscreen.disableSounds = true
end

---
-- Called when the loading screen should end.
-- @internal
-- @realm shared
function loadingscreen.End()
    if CLIENT then
        loadingscreen.isShown = false
    end

    if SERVER then
        local duration = loadingscreen.timeBegin - SysTime() + loadingscreen.GetDuration()

        -- this timer makes sure the loading screen is displayed for at least the
        -- time that is set as the minimum time
        timer.Create("TTT2LoadingscreenEndTime", duration, 1, function()
            loadingscreen.isShown = false

            net.Start("TTT2LoadingScreenActive")
            net.WriteBool(false)
            net.Broadcast()

            -- disables sounds a while longer so it stays muted
            timer.Simple(1.5, function()
                loadingscreen.disableSounds = false
            end)
        end)
    end
end

if SERVER then
    -- mutes the sound while the loading screen is shown
    -- this makes it so that you can't hear weapons spawning
    hook.Add("EntityEmitSound", "TTT2PreventReloadingSound", function(data)
        if loadingscreen.disableSounds then
            return false
        end
    end)

    ---
    -- Reads the minimum time that a loadingscreen should have.
    -- @return number The minimum time
    -- @realm server
    function loadingscreen.GetDuration()
        return cvLoadingScreenMinDuration:GetFloat()
    end
end

if CLIENT then
    local LS_HIDDEN = 0
    local LS_FADE_IN = 1
    local LS_SHOWN = 2
    local LS_FADE_OUT = 3

    local durationStateChange = 0.35

    ---
    -- @realm client
    -- stylua: ignore
    local cvLoadingScreen = CreateConVar("ttt2_enable_loadingscreen", "1", {FCVAR_ARCHIVE})

    ---
    -- @realm client
    -- stylua: ignore
    local cvLoadingScreenTips = CreateConVar("ttt_tips_enable", "1", {FCVAR_ARCHIVE})

    loadingscreen.state = LS_HIDDEN
    loadingscreen.timeStateChange = SysTime()

    net.Receive("TTT2LoadingScreenActive", function()
        if net.ReadBool() then
            loadingscreen.Begin()
        else
            loadingscreen.End()
        end
    end)

    ---
    -- Handles the loading screen transistions and drawing.
    -- @internal
    -- @realm client
    function loadingscreen.Handler()
        -- start loadingscreen
        if loadingscreen.isShown and not loadingscreen.wasShown then
            loadingscreen.state = LS_FADE_IN
            loadingscreen.timeStateChange = SysTime()

            if cvLoadingScreen:GetBool() then
                surface.PlaySound("ttt/loadingscreen.wav")
            end

            timer.Create("TTT2LoadingscreenShow", durationStateChange, 1, function()
                loadingscreen.state = LS_SHOWN
                loadingscreen.timeStateChange = SysTime()
            end)

            loadingscreen.wasShown = true

        -- stop loadingscreen
        elseif not loadingscreen.isShown and loadingscreen.wasShown then
            loadingscreen.state = LS_FADE_OUT
            loadingscreen.timeStateChange = SysTime()

            timer.Create("TTT2LoadingscreenHide", durationStateChange * 2, 1, function()
                loadingscreen.state = LS_HIDDEN
                loadingscreen.timeStateChange = SysTime()

                timer.Remove("TTT2LoadingscreenShow")
            end)

            loadingscreen.wasShown = false
        end

        loadingscreen.Draw()
    end

    ---
    -- Handles the loading screen drawing.
    -- @internal
    -- @realm client
    function loadingscreen.Draw()
        if not cvLoadingScreen:GetBool() or loadingscreen.state == LS_HIDDEN then
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

        -- stop rendering the loadingscreen if the progress is close to 0, this removes
        -- an ugly step when transitioning from blurry to sharp
        if progress < 0.01 then
            return
        end

        local c = util.ColorDarken(vskin.GetDarkAccentColor(), 90)

        local colorLoadingScreen = Color(c.r, c.g, c.b, 235 * progress)
        local colorTip = table.Copy(util.GetDefaultColor(colorLoadingScreen))
        colorTip.a = 255 * progress

        draw.BlurredBox(0, 0, ScrW(), ScrH(), progress * 10)
        draw.BlurredBox(0, 0, ScrW(), ScrH(), progress * 3)
        draw.Box(0, 0, ScrW(), ScrH(), colorLoadingScreen)

        draw.AdvancedText(
            LANG.TryTranslation("loadingscreen_round_restart_title"),
            "PureSkinPopupTitle",
            0.5 * ScrW(),
            0.15 * ScrH(),
            colorTip,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER,
            true,
            appearance.GetGlobalScale()
        )

        local text = ""

        if gameloop.HasLevelLimits() then
            local roundsLeft, timeLeft = gameloop.UntilMapChange()

            text = LANG.GetParamTranslation(
                "loadingscreen_round_restart_subtitle_limits",
                { map = game.GetMap(), rounds = roundsLeft, time = timeLeft }
            )
        else
            text = LANG.TryTranslation("loadingscreen_round_restart_subtitle")
        end

        draw.AdvancedText(
            text,
            "PureSkinPopupText",
            0.5 * ScrW(),
            0.2 * ScrH(),
            colorTip,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER,
            true,
            appearance.GetGlobalScale()
        )

        if not cvLoadingScreenTips:GetBool() then
            return
        end

        local textWrapped, _, heightText = draw.GetWrappedText(
            LANG.TryTranslation("tips_panel_tip")
                .. " "
                .. LANG.GetParamTranslation(
                    loadingscreen.currentTipText,
                    loadingscreen.currentTipKeys
                ),
            0.6 * ScrW(),
            "PureSkinRole",
            appearance.GetGlobalScale()
        )

        local heightLine = heightText / #textWrapped

        for i = 1, #textWrapped do
            draw.AdvancedText(
                textWrapped[i],
                "PureSkinRole",
                0.5 * ScrW(),
                0.85 * ScrH() + i * heightLine,
                colorTip,
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER,
                true,
                appearance.GetGlobalScale()
            )
        end
    end
end
