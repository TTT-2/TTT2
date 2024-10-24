---
-- @module HUDManager

---
-- @realm client
local current_hud_cvar = CreateConVar(
    "ttt2_current_hud",
    ttt2net.GetGlobal({ "hud_manager", "defaultHUD" }) or "pure_skin",
    { FCVAR_ARCHIVE, FCVAR_USERINFO }
)

local current_hud_table = nil

HUDManager = {}

---
-- Draws the current selected HUD
-- @realm client
function HUDManager.DrawHUD()
    if not current_hud_table or not current_hud_table.Draw then
        return
    end

    current_hud_table:Draw()
end

---
-- Called whenever the HUD should be drawn. Called right before @{GM:HUDDrawScoreBoard} and after @{GM:HUDPaintBackground}.
-- Not called when the Camera SWEP is equipped. See also @{GM:DrawOverlay}.<br />
-- Paints @{Player} status HUD element in the bottom left
-- @note Only be called when r_drawvgui is enabled and the game is not paused.
-- @2D
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:HUDPaint
-- @local
function GM:HUDPaint()
    local client = LocalPlayer()

    ---
    -- @realm client
    if hook.Run("HUDShouldDraw", "TTTTButton") then
        TBHUD:Draw(client)
    end

    ---
    -- @realm client
    if hook.Run("HUDShouldDraw", "TTTTargetID") then
        ---
        -- @realm client
        hook.Run("HUDDrawTargetID")
    end

    ---
    -- @realm client
    if hook.Run("HUDShouldDraw", "TTT2HUD") then
        HUDManager.DrawHUD()
    end

    ---
    -- @realm client
    if hook.Run("HUDShouldDraw", "TTT2KeyHelp") then
        keyhelp.Draw()
    end

    ---
    -- @realm client
    if hook.Run("HUDShouldDraw", "TTT2MarkerVision") then
        markerVision.Draw()
    end

    ---
    -- @realm client
    if hook.Run("HUDShouldDraw", "TTTRadar") then
        RADAR:Draw(client)
    end
end

---
-- Called after @{GM:PreDrawHUD}, @{GM:HUDPaintBackground} and @{GM:HUDPaint} but before @{GM:DrawOverlay}.
-- @2D
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:PostDrawHUD
-- @local
function GM:PostDrawHUD()
    vguihandler.DrawBackground()
end

---
-- Called after all other 2D draw hooks are called. Draws over all VGUI Panels and HUDs.
-- @2D
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:DrawOverlay
function GM:DrawOverlay()
    loadingscreen.Handler()
end

---
-- Called when the player's screen resolution of the game changes.
-- ScrW and ScrH will return the new values when this hook is called.
-- This hook is also called if the resolution was changed while not
-- ingame after @{GM:TTT2PlayerReady} is called.
-- @param number oldScrW The old screen width
-- @param number oldScrH The old screen height
-- @hook
-- @ref https://wiki.facepunch.com/gmod/GM:OnScreenSizeChanged
-- @realm client
function GM:OnScreenSizeChanged(oldScrW, oldScrH)
    -- resolution has changed, update resolution in appearance
    -- to handle dynamic resolution changes
    appearance.UpdateResolution(ScrW(), ScrH())
end

-- Hide the standard HUD stuff
local gmodhud = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["CHudDamageIndicator"] = true,
}

---
-- Called when the Gamemode is about to draw a given element on the client's HUD (heads-up display).
-- @note This hook is called HUNDREDS of times per second (more than 5 times per frame on average).
-- You shouldn't be performing any computationally intensive operations.
-- @param string name The name of the HUD element. You can find a full list of HUD elements for this hook
-- <a href="https://wiki.facepunch.com/gmod/HUD_Element_List">here</a>.
-- @return boolean Return false to prevent the given element from being drawn on the client's screen.
-- @hook
-- @realm client
-- @ref https://wiki.facepunch.com/gmod/GM:HUDShouldDraw
-- @local
function GM:HUDShouldDraw(name)
    if gmodhud[name] then
        return false
    end

    return self.BaseClass.HUDShouldDraw(self, name)
end

local function UpdateHUD(name)
    local hudEl = huds.GetStored(name)
    if not hudEl then
        ErrorNoHaltWithStack("Error: HUD with name " .. name .. " was not found!")

        return
    end

    HUDEditor.StopEditHUD()

    -- save the old HUDs values
    if current_hud_table then
        current_hud_table:SaveData()
    end

    current_hud_cvar:SetString(name)

    current_hud_table = hudEl

    -- Initialize elements
    hudEl:Initialize()
    hudEl:LoadData()

    ---
    -- Call all listeners
    -- @realm client
    hook.Run("TTT2HUDUpdated", name)
end

---
-- Returns the current selected @{HUD}
-- @return string
-- @realm client
function HUDManager.GetHUD()
    local hudvar = current_hud_cvar:GetString()

    if not huds.GetStored(hudvar) then
        hudvar = ttt2net.GetGlobal({ "hud_manager", "defaultHUD" }) or "pure_skin"
    end

    return hudvar
end

---
-- Sets the @{HUD} (if possible)
-- @note This will fail silently if the @{HUD} is not available or is
-- restricted by the server
-- @param string name The name of the HUD
-- @realm client
function HUDManager.SetHUD(name)
    local currentHUD = HUDManager.GetHUD()

    net.Start("TTT2RequestHUD")
    net.WriteString(name or currentHUD)
    net.WriteString(currentHUD)
    net.SendToServer()
end

---
-- Resets the current HUD if possible
-- @realm client
function HUDManager.ResetHUD()
    local hud = huds.GetStored(HUDManager.GetHUD())

    if not hud then
        return
    end

    hud:Reset()
    hud:SaveData()
end

---
-- Initializes all @{HUD}s and loads the SQL stored data
-- @realm client
function HUDManager.LoadAllHUDS()
    local hudsTbl = huds.GetList()

    for i = 1, #hudsTbl do
        local hud = hudsTbl[i]

        hud:Initialize()
        hud:LoadData()
    end
end

-- if forced or requested, modified by server restrictions
net.Receive("TTT2ReceiveHUD", function()
    UpdateHUD(net.ReadString())
end)

---
-- This hook is called after the HUD was updated and the HUD change
-- was confirmed by the server.
-- @param string name The name of the new HUD
-- @hook
-- @realm client
function GM:TTT2HUDUpdated(name) end
