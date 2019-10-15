local cv_draw_halo = CreateClientConVar("ttt_weapon_switch_draw_halo", "1", true, false)

bind.Register("ttt2_weaponswitch", function()
	net.Start("ttt2_switch_weapon")
	net.WriteString(GetRoundState())
	net.SendToServer()
end, nil, "TTT2 Bindings", "f1_bind_weaponswitch", KEY_E)

local function DrawWeaponOutlines()
	local client = LocalPlayer()

	if not IsValid(client) or not client:IsTerror() or not client:Alive() then return end

	local tracedWeapon = client:GetEyeTrace().Entity

	if not IsValid(tracedWeapon) or not tracedWeapon:IsWeapon()
	or client:GetPos():Distance(tracedWeapon:GetPos()) > 100 then return end

	halo.Add({tracedWeapon}, Color(250, 210, 210), 3, 3, 2)
end

if cv_draw_halo:GetBool() then
	hook.Add("PreDrawHalos", "WeaponDrawHalo", DrawWeaponOutlines)
end

cvars.AddChangeCallback(cv_draw_halo:GetName(), function(name, old, new)
	if tonumber(new) == 1 then
		hook.Add("PreDrawHalos", "WeaponDrawHalo", DrawWeaponOutlines)
	else
		hook.Remove("PreDrawHalos", "WeaponDrawHalo")
	end
end, cv_draw_halo:GetName())
