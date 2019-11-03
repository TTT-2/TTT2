util.AddNetworkString("ttt2_switch_weapon")
util.AddNetworkString("ttt2_switch_weapon_update_cache")

local plymeta = FindMetaTable("Player")
if not plymeta then
	Error("FAILED TO FIND PLAYER TABLE")

	return
end

function plymeta:PickupWeapon(wep)
	local throwWeapon = self:GetActiveWeapon()

	-- this variable defines if the dropped weapon is the currently selected weapon
	-- it is needed to determine weather or not hidden pickup/drop is possible
	local isActiveWepon = true

	if not IsValid(throwWeapon) or not throwWeapon.AllowDrop or throwWeapon.Kind ~= wep.Kind then
		local weps = self.inventory[MakeKindValid(wep.Kind)]

		-- the currently selected weapon will not be dropped, therefore this is set to false
		isActiveWepon = false

		-- reset throwWeapon, will be set to a weapon, if throwable weapon is found
		throwWeapon = nil

		-- get droppable weapon from given slot
		for i = 1, #weps do
			throwWeapon = weps[i]

			-- found a weapon that is allowed to be dropped
			if IsValid(throwWeapon) and throwWeapon.AllowDrop then
				break
			end
		end
	end

	-- make sure the found weapon is allowed to be dropped. If no droppable weapon
	-- was found and no slot is free, the weapon switch can not proceed
	if not InventorySlotFree(self, wep.Kind) and IsValid(throwWeapon) and not throwWeapon.AllowDrop then return end

	-- check if weapon pickup/switch is possible
	self.WeaponSwitchFlag = true

	if not self:CanPickupWeapon(wep) then return end

	-- only throw active weapon when weapon is switched and no slot is free
	if IsValid(throwWeapon) and not InventorySlotFree(self, throwWeapon.Kind) then
		-- prepare the weapon for the drop (move ammo etc)
		if isfunction(throwWeapon.PreDrop) then
			throwWeapon:PreDrop()
		end

		-- PreDrop sometimes makes the weapon non-valid, therefore we have to check again
		if IsValid(throwWeapon) then
			-- set IsDropped to true to prevent auto pickup of equipitems
			throwWeapon.IsDropped = true

			-- drop the old weapon
			self:DropWeapon(throwWeapon)

			-- wake the pysics of the dropped weapon
			throwWeapon:PhysWake()
		end
	end

	-- get and cache data of weapon that has to be picked up
	local wepCls = wep:GetClass()
	local clip1 = isfunction(wep.Clip1) and wep:Clip1() or 0
	local ammo_num = wep.StoredAmmo or 0
	local ammo_type = wep:GetPrimaryAmmoType()

	-- remove the weapon since it will be placed in the player inventory
	wep:Remove()

	-- give the weapon to the player
	local newWep = self:Give(wepCls)

	if not IsValid(newWep) then return end

	-- copy data from picked up weapon
	if isfunction(newWep.SetClip1) then
		newWep:SetClip1(clip1)
	end

	self:GiveAmmo(ammo_num, ammo_type)

	-- auto select newly picked up weapon when alt is not pressed
	-- but autoselect weapon if picked up weapon is dropped
	if isActiveWepon or not self:KeyDown(IN_WALK) and not self:KeyDownLast(IN_WALK) then
		self:SelectWeapon(wepCls)
	end

	-- there is a glitch that picking up a weapon does not refresh the weapon cache on
	-- the client. Therefore the client has to be notified to updated its cache
	net.Start("ttt2_switch_weapon_update_cache")
	net.Send(self)

	return newWep
end

function plymeta:PickupWeaponClass(wepCls)
	local wep = ents.Create(wepCls)

	if not IsValid(wep) or not wep:IsWeapon() then return end

	return self:PickupWeapon(wep)
end

net.Receive("ttt2_switch_weapon", function(_, ply)
	-- player and wepaon must be valid
	if not IsValid(ply) or not ply:IsTerror() or not ply:Alive() then return end

	-- handle weapon switch
	local tracedWeapon = ply:GetEyeTrace().Entity

	if not IsValid(tracedWeapon) or not tracedWeapon:IsWeapon() then return end

	-- do not pickup weapon if too far away
	if ply:GetPos():Distance(tracedWeapon:GetPos()) > 100 then return end

	if not IsValid(ply:PickupWeapon(tracedWeapon)) then
		LANG.Msg(activator, "pickup_no_room")
	end
end)
