local maxSpecialSlots = CreateConVar("ttt2_max_special_slots", "2", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of special weapons, a player can carry (-1 = infinite)")
local maxExtraSlots = CreateConVar("ttt2_max_extra_slots", "-1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of extra weapons, a player can carry (-1 = infinite)")

local function InventorySlotFromKind(kind)
	if kind == WEAPON_EQUIP1 or kind == WEAPON_EQUIP2 then
		return WEAPON_SPECIAL
	elseif kind ==  WEAPON_ROLE or kind == WEAPON_NONE then
		return WEAPON_EXTRA
	elseif kind > WEAPON_NONE then
		return WEAPON_EXTRA
	else
		return kind
	end	
end

--we appeareantly need to have that, because added and removed entities are sometimes broken on client side and need to get updated later
--additionally spawn can be called when a player is alive in which case he doesn't loose weapons beforehand
function CleanupInventoryIfDirty(ply)
	if !ply.inventory || ply.refresh_inventory_cache then
		ply.refresh_inventory_cache = false
		CleanupInventory(ply)
	end
end

function CleanupInventory(ply)
	if !IsValid(ply) then return end
	
	ply.inventory = {}
	ply.inventory[WEAPON_SPECIAL] = {}
	ply.inventory[WEAPON_EXTRA] = {}
	
	--add weapons which are already in inventory
	for k, v in pairs( ply:GetWeapons() ) do
		if IsValid(v) then
			AddWeaponToInventory(ply, v)
		end
	end
end

function InventorySlotFree(ply, kind)
	if !IsValid(ply) then return false end
	
	CleanupInventoryIfDirty(ply)

	local invSlot = InventorySlotFromKind(kind)
	
	if invSlot == WEAPON_SPECIAL then 
		return maxSpecialSlots:GetInt() < 0 or #ply.inventory[WEAPON_SPECIAL] < maxSpecialSlots:GetInt()
	elseif invSlot == WEAPON_EXTRA then
		return maxExtraSlots:GetInt() < 0 or #ply.inventory[WEAPON_EXTRA] < maxExtraSlots:GetInt()
	else
		return ply.inventory[invSlot] == nil
	end
end

function AddWeaponToInventory(ply, wep)	
	if !IsValid(ply) then return false end
	
	CleanupInventoryIfDirty(ply)

	local invSlot = InventorySlotFromKind(wep.Kind)
	
	if istable(ply.inventory[invSlot]) then 
		table.Add(ply.inventory[invSlot], {wep})
	else
		ply.inventory[invSlot] = wep
	end
end

function RemoveWeaponFromInventory(ply, wep)
	if !IsValid(ply) then return false end

	CleanupInventoryIfDirty(ply)

	local invSlot = InventorySlotFromKind(wep.Kind)
	
	if istable(ply.inventory[invSlot]) then 
		table.RemoveByValue(ply.inventory[invSlot], wep)
	elseif ply.inventory[invSlot] then
		ply.inventory[invSlot] = nil
	end
end