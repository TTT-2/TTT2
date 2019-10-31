util.AddNetworkString("ttt2_switch_weapon")

net.Receive("ttt2_switch_weapon", function(_, ply)
	-- player and wepaon must be valid
	if not IsValid(ply) or not ply:IsTerror() or not ply:Alive() then return end

	-- handle weapon switch
	local tracedWeapon = ply:GetEyeTrace().Entity

	if not IsValid(tracedWeapon) or not tracedWeapon:IsWeapon() then return end

	-- do not pickup weapon if too far away
	if ply:GetPos():Distance(tracedWeapon:GetPos()) > 100 then return end

	local throwWeapon = ply:GetActiveWeapon()

	if not IsValid(throwWeapon) or not throwWeapon.AllowDrop or throwWeapon.Kind ~= tracedWeapon.Kind then
		local weps = ply.inventory[MakeKindValid(tracedWeapon.Kind)]

		throwWeapon = weps[1]
	end

	-- if current weapon should be dropped, make dure this weapon is allowed to be dropped
	if IsValid(throwWeapon) and not throwWeapon.AllowDrop then return end

	-- only throw active weapon when weapon is switched and no slot is free
	if IsValid(throwWeapon) and not InventorySlotFree(ply, throwWeapon.Kind) then
		ply:DropWeapon(throwWeapon)
	end

	local wepCls = tracedWeapon:GetClass()
	local clip1 = isfunction(tracedWeapon.Clip1) and tracedWeapon:Clip1() or 0

	tracedWeapon:Remove()

	local newWep = ply:Give(wepCls)
	if not IsValid(newWep) then return end

	if isfunction(newWep.SetClip1) then
		newWep:SetClip1(clip1)
	end

	ply:SelectWeapon(wepCls)
end)
