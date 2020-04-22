local function GetPickableWeaponInFront()
	local client = LocalPlayer()

	if not IsValid(client) or not client:IsTerror() or not client:Alive() then return end

	local tracedWeapon = client:GetEyeTrace().Entity

	if not IsValid(tracedWeapon) or not tracedWeapon:IsWeapon()
	or client:GetPos():Distance(tracedWeapon:GetPos()) > 100 then
		return
	end

	return tracedWeapon
end

local lastRequest = 0

-- sends a request to the server that this client wants to pickup/switch a weapon
local function AttemptWeaponSwitch()
	if GetPickableWeaponInFront() == nil or lastRequest + 0.25 > CurTime() then return end

	net.Start("ttt2_switch_weapon")
	net.SendToServer()

	lastRequest = CurTime()
end

-- picking up a weapon should update the client weapon cache
net.Receive("ttt2_switch_weapon_update_cache", function()
	-- this for now is a workaround to test if the timing of the refresh is the problem
	timer.Simple(0.25, function()
		local client = LocalPlayer()

		if not IsValid(client) or not client:IsReady() then return end

		WSWITCH:UpdateWeaponCache()
	end)
end)

-- register a binding for the weapon switch, the default should be the use key
bind.Register("ttt2_weaponswitch", AttemptWeaponSwitch, nil, "header_bindings_ttt2", "label_bind_weaponswitch", input.GetKeyCode(input.LookupBinding("+use") or KEY_E))
