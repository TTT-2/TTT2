local TryTranslation = LANG.TryTranslation
local math = math
local table = table
local pairs = pairs
local IsValid = IsValid

PICKUP = {}
PICKUP.items = {}
PICKUP.last = 0

function GM:HUDWeaponPickedUp(wep)
	if not IsValid(wep) then return end

	local client = LocalPlayer()

	if not IsValid(client) or not client:Alive() then return end

	local name = GetEquipmentTranslation(wep:GetClass(), (wep.GetPrintName and wep:GetPrintName()) or wep:GetClass())
	--local name = TryTranslation(wep.GetPrintName and wep:GetPrintName() or wep:GetClass() or "Unknown Weapon Name")

	local pickup = {}
	pickup.time = CurTime()
	pickup.name = string.upper(name)
	pickup.holdtime = 5
	pickup.fadein = 0.04
	pickup.fadeout = 0.3
	pickup.color = client.GetRoleColor and client:GetRoleColor() or INNOCENT.color

	if PICKUP.last >= pickup.time then
		pickup.time = PICKUP.last + 0.05
	end

	local index = table.insert(PICKUP.items, pickup)

	PICKUP.last = pickup.time
end

function GM:HUDItemPickedUp(itemname)
	local client = LocalPlayer()

	if not IsValid(client) or not client:Alive() then return end

	local pickup = {}
	pickup.time = CurTime()
	-- as far as I'm aware TTT does not use any "items", so better leave this to
	-- source's localisation
	pickup.name = "#" .. itemname
	pickup.holdtime = 5
	pickup.fadein = 0.04
	pickup.fadeout = 0.3
	pickup.color = Color(255, 255, 255, 255)

	if PICKUP.last >= pickup.time then
		pickup.time = PICKUP.last + 0.05
	end

	table.insert(PICKUP.items, pickup)

	PICKUP.last = pickup.time
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

	local pickup = {}
	pickup.time = CurTime()
	pickup.firstTime = CurTime()
	pickup.name = string.upper(itemname_trans)
	pickup.holdtime = 5
	pickup.fadein = 0.04
	pickup.fadeout = 0.3
	pickup.color = Color(205, 155, 0, 255)
	pickup.amount = tostring(amount)

	if PICKUP.last >= pickup.time then
		pickup.time = PICKUP.last + 0.05
	end

	table.insert(PICKUP.items, pickup)

	PICKUP.last = pickup.time
end

function PICKUP.RemoveOutdatedValues()
	local itemCount = #PICKUP.items

	local j = 1
	for i=1, itemCount do
		if not PICKUP.items[i].remove then
		    if (i ~= j) then
			-- Keep i's value, move it to j's pos.
			PICKUP.items[j] = PICKUP.items[i];
			PICKUP.items[i] = nil;
		    else
			-- Keep i's value, already at j's pos.
		    end
		    j = j + 1;
		else
			PICKUP.items[i] = nil;
		end
	end
end
