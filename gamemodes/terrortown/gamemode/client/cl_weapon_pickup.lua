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

local function AttemptWeaponSwitch()
	if GetPickableWeaponInFront() == nil or lastRequest + 0.2 > CurTime() then return end

	net.Start("ttt2_switch_weapon")
	net.SendToServer()

	lastRequest = CurTime()
end

-- register a binding for the weapon switch, the default should be the use key
bind.Register("ttt2_weaponswitch", AttemptWeaponSwitch, nil, "TTT2 Bindings", "f1_bind_weaponswitch", input.GetKeyCode(input.LookupBinding("+use")))
