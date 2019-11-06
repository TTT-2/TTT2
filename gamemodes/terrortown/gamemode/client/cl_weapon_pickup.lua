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

local lastRequest = 0

local function AttemptWeaponSwitch()
	if GetPickableWeaponInFront() == nil or lastRequest + 0.5 > CurTime() then return end

	net.Start("ttt2_switch_weapon")
	net.SendToServer()

	lastRequest = CurTime()
end

-- picking up a weapon should update the client weapon cache
net.Receive("ttt2_switch_weapon_update_cache", function()
	WSWITCH:UpdateWeaponCache()
end)

-- register a binding for the weapon switch, the default should be the use key
bind.Register("ttt2_weaponswitch", AttemptWeaponSwitch, nil, "TTT2 Bindings", "f1_bind_weaponswitch", input.GetKeyCode(input.LookupBinding("+use")))

SWITCHMODE_PICKUP = 0
SWITCHMODE_SWITCH = 1
SWITCHMODE_NOSPACE = 2

function GetPickupMode(wep)
	local client = LocalPlayer()
	local throwWeapon = client:GetActiveWeapon()

	-- this variable defines if the dropped weapon is the currently selected weapon
	-- it is needed to determine weather or not hidden pickup/drop is possible
	local isActiveWepon = true

	-- while iterating over the inventory this variable is set to true, if a slow was found
	-- regardless of the dropability of the selected weapon
	local found_any_slot = false

	if not IsValid(throwWeapon) or not throwWeapon.AllowDrop or throwWeapon.Kind ~= wep.Kind then
		local weps = client.inventory[MakeKindValid(wep.Kind)]

		-- the currently selected weapon will not be dropped, therefore this is set to false
		isActiveWepon = false

		-- reset throwWeapon, will be set to a weapon, if throwable weapon is found
		throwWeapon = nil

		-- get droppable weapon from given slot
		for i = 1, #weps do
			-- found a weapon that is allowed to be dropped
			if IsValid(weps[i]) then
				found_any_slot = true

				if weps[i].AllowDrop then
					throwWeapon = weps[i]

					break
				end
			end
		end
	end

	local ret_dropwep_mode = SWITCHMODE_PICKUP

	if IsValid(throwWeapon) then
		ret_dropwep_mode = SWITCHMODE_SWITCH
	elseif found_any_slot then
		ret_dropwep_mode = SWITCHMODE_NOSPACE
	end

	return ret_dropwep_mode, throwWeapon, isActiveWepon
end
