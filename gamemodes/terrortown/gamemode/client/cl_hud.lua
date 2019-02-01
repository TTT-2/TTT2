function GM:HUDPaint()
	local client = LocalPlayer()

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTTargetID") then
		hook.Call("HUDDrawTargetID", GAMEMODE)
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTMStack") then
		MSTACK:Draw(client)
	end

	local hud = huds.GetStored(ply:GetHUD())
	if hud then
		for _, hudmodule in pairs(hud.hudmodules) do
			if hook.Call("HUDShouldDraw", GAMEMODE, hudmodule.shouldDrawHook) then
				hudmodule:Draw()
			end
		end
	end

	if not client:Alive() or client:Team() == TEAM_SPEC then
		if hook.Call("HUDShouldDraw", GAMEMODE, "TTTSpecHUD") then
			SpecHUDPaint(client)
		end

		return
	end

	-- Draw owned Item info
	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTItemHUDDisplay") then
		ItemInfo(client)
	end

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

	-- Draw bottom left info panel
	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTInfoPanel") then
		InfoPaint(client)
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
