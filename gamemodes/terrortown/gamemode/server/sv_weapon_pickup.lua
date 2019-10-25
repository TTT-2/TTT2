util.AddNetworkString("ttt2_switch_weapon")

net.Receive("ttt2_switch_weapon", function(_, ply)
	-- player and wepaon must be valid
	if not IsValid(ply) or not ply:IsTerror() or not ply:Alive() then return end

	local activeWeapon = ply:GetActiveWeapon()

	if not IsValid(activeWeapon) or not activeWeapon.AllowDrop then return end

	-- handle weapon switch
	local tracedWeapon = ply:GetEyeTrace().Entity

	if not IsValid(tracedWeapon) or not tracedWeapon:IsWeapon()
	or ply:GetPos():Distance(tracedWeapon:GetPos()) > 100
	or tracedWeapon.Kind ~= activeWeapon.Kind then
		return
	end

	ply:DropWeapon(activeWeapon)

	local wepCls = tracedWeapon:GetClass()
	local clip1 = tracedWeapon:Clip1()

	tracedWeapon:Remove()

	local newWep = ply:Give(wepCls)
	newWep:SetClip1(clip1)

	ply:SelectWeapon(wepCls)
end)
