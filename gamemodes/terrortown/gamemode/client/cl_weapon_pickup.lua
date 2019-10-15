local cv_draw_halo = CreateClientConVar("ttt_weapon_switch_draw_halo", "1", true, false)
local defaultCol = Color(250, 210, 210)

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

	outline.Add({tracedWeapon}, client:GetRoleColor() or defaultCol, OUTLINE_MODE_VISIBLE)
end

if cv_draw_halo:GetBool() then
	hook.Add("PreDrawOutlines", "WeaponDrawOutline", DrawWeaponOutlines)
end

cvars.AddChangeCallback(cv_draw_halo:GetName(), function(name, old, new)
	if tonumber(new) == 1 then
		hook.Add("PreDrawOutlines", "WeaponDrawOutline", DrawWeaponOutlines)
	else
		hook.Remove("PreDrawOutlines", "WeaponDrawOutline")
	end
end, cv_draw_halo:GetName())
