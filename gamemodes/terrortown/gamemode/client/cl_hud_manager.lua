if not HUDManager then return end

local current_hud = CreateClientConVar("ttt2_current_hud", "__DEFAULT__", true, true)

local currentHUD = current_hud:GetString()
if currentHUD == "__DEFAULT__" then
	currentHUD = HUDManager.defaultHUD
end

function HUDManager.SetDefaultHUD()
	HUDManager.SetHUD(HUDManager.defaultHUD)
end

function HUDManager.GetHUD()
	if not huds.GetStored(currentHUD) then
		currentHUD = "old_ttt"
	end

	return currentHUD
end

local function SetLocalHUD(name)
	if name == currentHUD then return end

	local hud = huds.GetStored(name)

	if not hud then
		Msg("Error: HUD with name " .. name .. " was not found!\n")

		return
	end

	RunConsoleCommand(current_hud:GetName(), name)

	currentHUD = name

	-- Initialize elements
	hud:Initialize()
end

function HUDManager.SetHUD(name)
	if name == currentHUD then return end

	net.Start("TTT2RequestHUD")
	net.WriteString(name)
	net.WriteString(currentHUD)
	net.SendToServer()
end

function HUDManager.DrawHUD()
	local hud = huds.GetStored(currentHUD)

	if not hud then return end

	for _, elem in ipairs(hud:GetHUDElements()) do
		if hud:ShouldShow(elem.type) and hook.Call("HUDShouldDraw", GAMEMODE, elem.type) then
			elem:Draw()
		end
	end
end

-- Paints player status HUD element in the bottom left
function GM:HUDPaint()
	local client = LocalPlayer()

	-- Perform Layout
	local scrW = ScrW()
	local scrH = ScrH()
	local changed = false

	if client.oldScrW and client.oldScrW ~= scrW and client.oldScrH and client.oldScrH ~= scrH then
		local hud = huds.GetStored(currentHUD)
		if hud then
			for _, elem in ipairs(hud:GetHUDElements()) do
				elem:PerformLayout()
			end

			changed = true
		end
	end

	if changed or not client.oldScrW or not client.oldScrH then
		client.oldScrW = scrW
		client.oldScrH = scrH
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTTargetID") then
		hook.Call("HUDDrawTargetID", GAMEMODE)
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTMStack") then
		MSTACK:Draw(client)
	end

	HUDManager.DrawHUD()

	if not client:Alive() or client:Team() == TEAM_SPEC then return end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTRadar") then
		RADAR:Draw(client)
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTTButton") then
		TBHUD:Draw(client)
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTWSwitch") then
		WSWITCH:Draw(client)
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTVoice") then
		VOICE.Draw(client)
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTPickupHistory") then
		hook.Call("HUDDrawPickupHistory", GAMEMODE)
	end
end

-- Hide the standard HUD stuff
local hud = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true
}

function GM:HUDShouldDraw(name)
	if hud[name] then
		return false
	end

	return self.BaseClass.HUDShouldDraw(self, name)
end

-- if forced or requested, modified by server restrictions
net.Receive("TTT2RequestHUD", function(len)
	local newHUD = net.ReadString()

	SetLocalHUD(newHUD)
end)
