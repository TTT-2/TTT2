util.AddNetworkString("ttt2_switch_weapon")
util.AddNetworkString("ttt2_switch_weapon_update_cache")

local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

---
-- This function handles the weapon drop including ammo handling, flags etc
-- @param Weapon wep The weapon to be dropped
-- @realm server
function plymeta:PrepareAndDropWeapon(wep)
	if not IsValid(wep) then return end

	if isfunction(wep.PreDrop) then
		wep:PreDrop()
	end

	-- PreDrop sometimes makes the weapon non-valid, therefore we have to check again
	if not IsValid(wep) then return end

	-- set IsDropped to true to prevent auto pickup of equipitems
	wep.IsDropped = true

	-- drop the old weapon
	self:DropWeapon(wep)

	-- wake the pysics of the dropped weapon
	wep:PhysWake()
end

function ResetWeapon(wep)
	if not IsValid(wep) then return end

	-- clearing the player flag of this weapon, freeing it to every other player
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
