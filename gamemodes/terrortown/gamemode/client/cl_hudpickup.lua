local TryTranslation = LANG.TryTranslation
local math = math
local table = table
local pairs = pairs
local IsValid = IsValid

PICKUP = {}
PICKUP.items = {}
PICKUP.last = 0

PICKUP_WEAPON = 0
PICKUP_ITEM = 1
PICKUP_AMMO = 2

local function InsertNewPickupItem()
	local pickup = {}
	pickup.time = CurTime()
	pickup.holdtime = 5
	pickup.fadein = 0.04
	pickup.fadeout = 0.3
	if PICKUP.last >= pickup.time then
		pickup.time = PICKUP.last + 0.05
	end

	local index = table.insert(PICKUP.items, pickup)

	PICKUP.last = pickup.time

	return pickup
end

function GM:HUDWeaponPickedUp(wep)
	if not IsValid(wep) then return end

	local client = LocalPlayer()

	if not IsValid(client) or not client:Alive() then return end

	local name = GetEquipmentTranslation(wep:GetClass(), (wep.GetPrintName and wep:GetPrintName()) or wep:GetClass())

	local pickup = InsertNewPickupItem()
	pickup.name = string.upper(name)
	pickup.type = PICKUP_WEAPON
	pickup.kind = MakeKindValid(wep.Kind)
end

function GM:HUDItemPickedUp(itemname)
	local client = LocalPlayer()

	if not IsValid(client) or not client:Alive() then return end

	local pickup = InsertNewPickupItem()
	pickup.name = "#" .. itemname
	pickup.type = PICKUP_ITEM
end

function GM:HUDAmmoPickedUp(itemname, amount)
	local client = LocalPlayer()

	if not IsValid(client) or not client:Alive() then return end

	local itemname_trans = TryTranslation(string.lower("ammo_" .. itemname))

	if PICKUP.items then
		local localized_name = string.upper(itemname_trans)

		for _, v in pairs(PICKUP.items) do
			if v.name == localized_name and CurTime() - v.firstTime < 0.5 then
				v.amount = tostring(tonumber(v.amount) + amount)
				v.time = CurTime() - v.fadein

				return
			end
		end
	end

	local pickup = InsertNewPickupItem()
	pickup.firstTime = CurTime()
	pickup.name = string.upper(itemname_trans)
	pickup.amount = tostring(amount)
	pickup.type = PICKUP_AMMO
end

function PICKUP.RemoveOutdatedValues()
	local itemCount = #PICKUP.items

	local j = 1
	for i=1, itemCount do
		if not PICKUP.items[i].remove then
		    if (i ~= j) then
			-- Keep i's value, move it to j's pos.
			PICKUP.items[j] = PICKUP.items[i]
			PICKUP.items[i] = nil
		    end
		    j = j + 1
		else
			PICKUP.items[i] = nil
		end
	end
end
