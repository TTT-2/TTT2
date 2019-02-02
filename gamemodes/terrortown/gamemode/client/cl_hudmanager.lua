-- Paints player status HUD element in the bottom left
function GM:HUDPaint()
	local client = LocalPlayer()

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTTargetID") then
		hook.Call("HUDDrawTargetID", GAMEMODE)
	end

	if hook.Call("HUDShouldDraw", GAMEMODE, "TTTMStack") then
		MSTACK:Draw(client)
	end

	local hud = huds.GetStored(client:GetHUD())

	local checkedTbl = {}

	for hudelement, draw in pairs(hud:GetHUDElements()) do
		local el = hudelements.GetStored(hudelement)
		if el then
			if draw and el.type and hook.Call("HUDShouldDraw", GAMEMODE, el.type) then
				el:Draw()
			end

			checkedTbl[el.type] = true
		end
	end

	-- get all available element types
	for _, typ in ipairs(hudelements.GetElementTypes()) do
		if not checkedTbl[typ] then
			hudelements.GetTypeElement(typ):Draw()
		end
	end

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
