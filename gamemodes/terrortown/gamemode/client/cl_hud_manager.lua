---
-- @module HUDManager

ttt_include("vgui__cl_hudswitcher")

local current_hud_cvar = CreateClientConVar("ttt2_current_hud", ttt2net.GetGlobal({"hud_manager", "defaultHUD"}) or "pure_skin", true, true)
local current_hud_table = nil

HUDManager = {}

---
-- (Re)opens the HUDSwitcher
-- @realm client
function HUDManager.ShowHUDSwitcher()
	local client = LocalPlayer()

	if IsValid(client.hudswitcher) then
		client.hudswitcher.forceClosing = true

		client.hudswitcher:Remove()
	end

	client.hudswitcher = vgui.Create("HUDSwitcher")

	if client.hudswitcherSettingsF1 then
		client.settingsFrame = client.hudswitcher
	end

	client.hudswitcher:MakePopup()
end

---
-- Hides the HUDSwitcher
-- @realm client
function HUDManager.HideHUDSwitcher()
	local client = LocalPlayer()

	if IsValid(client.hudswitcher) then
		-- this will differentiate between user closed and closed by this method,
		-- so that this method is called when the user closed the frame by clicking on the X button
		client.hudswitcher.forceClosing = true

		client.hudswitcher:Remove()
	end

	if not client.settingsFrameForceClose and not HUDEditor.IsEditing then
		HELPSCRN:Show()
	end
end

---
-- Draws the current selected HUD
-- @realm client
function HUDManager.DrawHUD()
	if not current_hud_table or not current_hud_table.Draw then return end

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

	-- Perform Layout
	local scrW = ScrW()
	local scrH = ScrH()
	local changed = false

	if client.oldScrW and client.oldScrW ~= scrW and client.oldScrH and client.oldScrH ~= scrH then
		local hud = huds.GetStored(HUDManager.GetHUD())
		if hud then
			hud:Reset()
		end

		changed = true
	end

	if changed or not client.oldScrW or not client.oldScrH then
		client.oldScrW = scrW
		client.oldScrH = scrH
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTTargetID") then
		hook.Call("HUDDrawTargetID", GAMEMODE)
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTT2HUD") then
		HUDManager.DrawHUD()
	end

	if not client:Alive() or client:Team() == TEAM_SPEC then return end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTRadar") then
		RADAR:Draw(client)
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTTButton") then
		TBHUD:Draw(client)
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTVoice") then
		VOICE.Draw(client)
	end
end

-- Hide the standard HUD stuff
local gmodhud = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudDamageIndicator"] = true
}

---
-- Called when the Gamemode is about to draw a given element on the client's HUD (heads-up display).
-- @note This hook is called HUNDREDS of times per second (more than 5 times per frame on average).
-- You shouldn't be performing any computationally intensive operations.
-- @param string name The name of the HUD element. You can find a full list of HUD elements for this hook
-- <a href="https://wiki.garrysmod.com/page/HUD_Element_List">here</a>.
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
		MsgN("Error: HUD with name " .. name .. " was not found!")

		return
	end

	HUDEditor.StopEditHUD()

	-- save the old HUDs values
	if current_hud_table then current_hud_table:SaveData() end

	current_hud_cvar:SetString(name)

	current_hud_table = hudEl

	-- Initialize elements
	hudEl:Initialize()
	hudEl:LoadData()

	-- call all listeners
	hook.Run("TTT2HUDUpdated", name)
end

---
-- Returns the current selected @{HUD}
-- @return string
-- @realm client
function HUDManager.GetHUD()
	local hudvar = current_hud_cvar:GetString()

	if not huds.GetStored(hudvar) then
		hudvar = ttt2net.GetGlobal({"hud_manager", "defaultHUD"}) or "pure_skin"
	end

	return hudvar
end

---
-- Sets the @{HUD} (if possible)
-- @note This will fail if the @{HUD} is not available or restricted by the server
-- @param string name
-- @realm client
function HUDManager.SetHUD(name)
	local currentHUD = HUDManager.GetHUD()

	net.Start("TTT2RequestHUD")
	net.WriteString(name or currentHUD)
	net.WriteString(currentHUD)
	net.SendToServer()
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
