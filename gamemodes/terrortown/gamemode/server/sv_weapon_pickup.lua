util.AddNetworkString("ttt2_switch_weapon")
util.AddNetworkString("ttt2_switch_weapon_update_cache")

local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

function ResetWeapon(wep)
	if not IsValid(wep) then return end

	-- weapon is already reset, another cancel can cause problems
	if not wep.wpickup_player then return end

	-- removing timers
	timer.Remove(wep.name_timer_pos)
	timer.Remove(wep.name_timer_cancel)

	-- one important thing to know is, that timer.Remove is executed in the next
	-- frame, setting the variable to nil right after the call of timer.Remove
	-- causes an error since the identifier should never be nil
	-- GMOD - WTF?!
	timer.Simple(0, function()
		if not IsValid(wep) then return end

		wep.name_timer_pos = nil
		wep.name_timer_cancel = nil
	end)

	-- clearing the player/weapon flag of this weapon/player, freeing it to every other player
	wep.wpickup_player.wpickup_weapon = nil
	wep.wpickup_player = nil

	-- reenable the physics of the weapon to let it drop back to the ground
	wep:PhysicsInit(SOLID_VPHYSICS)
	wep:PhysWake()

	-- reset weapon collisions
	wep:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	-- make weapon visible again when dropped
	wep:SetNoDraw(false)
end

net.Receive("ttt2_switch_weapon", function(_, ply)
	-- player and wepaon must be valid
	if not IsValid(ply) or not ply:IsTerror() or not ply:Alive() then return end

	-- handle weapon switch
	local tracedWeapon = ply:GetEyeTrace().Entity

	if not IsValid(tracedWeapon) or not tracedWeapon:IsWeapon() then return end

	-- do not pickup weapon if too far away
	if ply:GetPos():Distance(tracedWeapon:GetPos()) > 100 then return end

	if not IsValid(ply:PickupWeapon(tracedWeapon, true)) then
		LANG.Msg(ply, "pickup_no_room")
	end
end)
