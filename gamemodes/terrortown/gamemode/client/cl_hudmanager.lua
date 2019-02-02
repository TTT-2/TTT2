if HUDManager then
	return
end

HUDManager = {}

HUDManager.currentHUD = "old_ttt"

function HUDManager:SetHUD( name )
	-- TODO add permission checks here

	local hud = huds.Get(name)

	if not hud then
		Msg("Error: HUD with name " .. name .. " was not found!\n")
		return
	end

	HUDManager.currentHUD = name

	-- Initialize elements default values
	for k, v in pairs(hud:GetElements()) do
		local elem = hudelements.Get(v)
		if elem then
			elem:Initialize()
		else
			Msg("Error: HUD has unkown element named " .. v .. "\n")
		end
	end

	-- Overwrite default values with HUDs adjustments
	hud:Initialize()
end

function HUDManager:DrawHUD()
	local hud = huds.GetStored(HUDManager.currentHUD)

	if not hud then return end

	local hudelems = hud:GetElements()

	-- loop through all types and if the hud does not provide an element take the first found instance for the type
	for _, type in ipairs(hudelements.GetElementTypes()) do
		local elem = hudelems[type] or hudelements.GetTypeElement(type)
		if hud:ShouldShow(elem) and hook.Call("HUDShouldDraw", GAMEMODE, type) then
			elem:Draw()
		end
	end

end



-- Paints player status HUD element in the bottom left
function GM:HUDPaint()
	local client = LocalPlayer()

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTTargetID") then
		hook.Call("HUDDrawTargetID", GAMEMODE)
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTMStack") then
		MSTACK:Draw(client)
	end

	HUDManager:DrawHUD()

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
