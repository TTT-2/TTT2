util.AddNetworkString("ttt2_switch_weapon")
util.AddNetworkString("ttt2_switch_weapon_update_cache")

local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

net.Receive("ttt2_switch_weapon", function(_, ply)
	-- player and wepaon must be valid
	if not IsValid(ply) or not ply:IsTerror() or not ply:Alive() then return end

	-- handle weapon switch
	local tracedWeapon = ply:GetEyeTrace().Entity

	if not IsValid(tracedWeapon) or not tracedWeapon:IsWeapon() then return end

	-- do not pickup weapon if too far away
	if ply:GetPos():Distance(tracedWeapon:GetPos()) > 100 then return end

	ply:SafePickupWeapon(tracedWeapon, nil, nil, true) -- force pickup and drop blocking weapon as well
end)
