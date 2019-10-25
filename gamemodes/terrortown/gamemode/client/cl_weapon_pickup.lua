local cv_draw_halo = CreateClientConVar("ttt_weapon_switch_draw_halo", "1", true, false)
local defaultCol = Color(250, 210, 210)

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

local function DrawWeaponOutlines()
	local tracedWeapon = GetPickableWeaponInFront()
	if tracedWeapon == nil then return end

	outline.Add({tracedWeapon}, LocalPlayer():GetRoleColor() or defaultCol, OUTLINE_MODE_VISIBLE)
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
