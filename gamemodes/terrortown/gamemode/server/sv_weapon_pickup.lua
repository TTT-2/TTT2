util.AddNetworkString("ttt2_switch_weapon")

net.Receive("ttt2_switch_weapon", function(_, ply)
	-- player and wepaon must be valid
	if not IsValid(ply) or not ply:IsTerror() or not ply:Alive() then return end

	-- handle weapon switch
	local tracedWeapon = ply:GetEyeTrace().Entity

	if not IsValid(tracedWeapon) or not tracedWeapon:IsWeapon() then return end

	local throwWeapon = ply:GetActiveWeapon()

	if not IsValid(throwWeapon) or not throwWeapon.AllowDrop or throwWeapon.Kind ~= tracedWeapon.Kind then
		local weps = ply.inventory[MakeKindValid(tracedWeapon.Kind)]
		if not weps or #weps == 0 then return end

		throwWeapon = weps[1]
	end

	if not IsValid(throwWeapon) or not throwWeapon.AllowDrop
	or ply:GetPos():Distance(tracedWeapon:GetPos()) > 100 then
		return
	end

	ply:DropWeapon(throwWeapon)

	local wepCls = tracedWeapon:GetClass()
	local clip1 = tracedWeapon:Clip1()

	tracedWeapon:Remove()

	local newWep = ply:Give(wepCls)
	newWep:SetClip1(clip1)

	ply:SelectWeapon(wepCls)
end)
