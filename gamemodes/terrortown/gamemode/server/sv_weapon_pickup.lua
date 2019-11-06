util.AddNetworkString("ttt2_switch_weapon")
util.AddNetworkString("ttt2_switch_weapon_update_cache")

local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

---
-- A simple handler to get the weapon blocking a new weapon from beeing picked up
-- @param Weapon wep The new weapon that should be added to the player inventory
-- @return Weapon, boolean The blocking weapon, active weapon?
function plymeta:GetBlockingWeapon(wep)
	-- no weapon is blocking if there is an inventory slot free
	if InventorySlotFree(self, wep.Kind) then
		return nil, false
	end

	-- start the drop weapon check by checking the active weapon
	local throwWeapon = self:GetActiveWeapon()

	-- if the currently selected weapon is the blocking weapon, return this one
	if IsValid(throwWeapon) and throwWeapon.AllowDrop and throwWeapon.Kind == wep.Kind then
		return throwWeapon, true
	end

	-- the slot of the selected weapon is not blocking the pickup, check the other slots
	-- as well
	local weps = self.inventory[MakeKindValid(wep.Kind)]

	-- reset throwWeapon, will be set to a weapon, if throwable weapon is found
	throwWeapon = nil

	-- get droppable weapon from given slot
	for i = 1, #weps do
		local wep_iter = weps[i]

		-- found a weapon that is allowed to be dropped
		if IsValid(wep_iter) and wep_iter.AllowDrop then
			throwWeapon = wep_iter

			break
		end
	end

	return throwWeapon, false
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

net.Receive("ttt2_switch_weapon", function(_, ply)
	-- player and wepaon must be valid
	if not IsValid(ply) or not ply:IsTerror() or not ply:Alive() then return end

	-- handle weapon switch
	local tracedWeapon = ply:GetEyeTrace().Entity

	if not IsValid(tracedWeapon) or not tracedWeapon:IsWeapon() then return end

	-- do not pickup weapon if too far away
	if ply:GetPos():Distance(tracedWeapon:GetPos()) > 100 then return end

	if not IsValid(ply:PickupWeapon(tracedWeapon, true)) then
		LANG.Msg(activator, "pickup_no_room")
	end
end)
