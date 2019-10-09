if SERVER then
	util.AddNetworkString("ttt2_switch_weapon")

	net.Receive("ttt2_switch_weapon", function(len, ply)
		-- do not allow weapon switch when the weaon switch was started in the previous round
		local roundstate_client = net.ReadString()

		if roundstate_client == ROUND_POST and roundstate_client ~= GetRoundState() then return end

		-- player and wepaon must be valid
		if not IsValid(ply) or not ply:IsTerror() then return end

		local activeWeapon = ply:GetActiveWeapon()

		if not IsValid(activeWeapon) then return end
		if not activeWeapon.AllowDrop then return end

		-- handle weapon switch
		local tracedWeapon = ply:GetEyeTrace().Entity

		if not IsValid(tracedWeapon) or not tracedWeapon:IsWeapon() then return end
		if ply:GetPos():Distance(tracedWeapon:GetPos()) > 100 then return end
		if tracedWeapon.Kind ~= activeWeapon.Kind then return end

		ply:DropWeapon(activeWeapon)
		ply:Give(tracedWeapon:GetClass())
		ply:SelectWeapon(tracedWeapon:GetClass())

		local newActive = ply:GetActiveWeapon()
		local clip1 = tracedWeapon:Clip1()

		newActive:SetClip1(clip1)
		tracedWeapon:Remove()
	end)
end


if CLIENT then
	bind.Register("ttt2_weaponswitch", function()
		net.Start("ttt2_switch_weapon")
		net.WriteString(GetRoundState())
		net.SendToServer()
	end, nil, "TTT2 Bindings", "f1_bind_weaponswitch", KEY_E)

	hook.Add("PreDrawHalos", "WeaponDrawHalo", function()
		local client = LocalPlayer()

		if not IsValid(client) or not client:IsTerror() then return end

		local tracedWeapon = client:GetEyeTrace().Entity

		if not IsValid(tracedWeapon) or not tracedWeapon:IsWeapon() then return end

		local distance = client:GetPos():Distance(tracedWeapon:GetPos())

		if distance > 100 then return end

		halo.Add({tracedWeapon}, Color(250, 210, 210), 3, 3, 2)
	end)
end