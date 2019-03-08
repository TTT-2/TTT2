local maxMeleeSlots = CreateConVar("ttt2_max_melee_slots", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of melee weapons, a player can carry (-1 = infinite)")
local maxSecondarySlots = CreateConVar("ttt2_max_secondary_slots", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of secondary weapons, a player can carry (-1 = infinite)")
local maxPrimarySlots = CreateConVar("ttt2_max_primary_slots", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of primary weapons, a player can carry (-1 = infinite)")
local maxNadeSlots = CreateConVar("ttt2_max_nade_slots", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of grenades, a player can carry (-1 = infinite)")
local maxCarrySlots = CreateConVar("ttt2_max_carry_slots", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of carry tools, a player can carry (-1 = infinite)")
local maxUnarmedSlots = CreateConVar("ttt2_max_unarmed_slots", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of unarmed slots, a player can have (-1 = infinite)")
local maxSpecialSlots = CreateConVar("ttt2_max_special_slots", "2", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of special weapons, a player can carry (-1 = infinite)")
local maxExtraSlots = CreateConVar("ttt2_max_extra_slots", "-1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum amount of extra weapons, a player can carry (-1 = infinite)")

hook.Add("TTT2SyncGlobals", "AddInventoryGlobals", function()
	SetGlobalInt(maxMeleeSlots:GetName(), maxMeleeSlots:GetInt())
	SetGlobalInt(maxSecondarySlots:GetName(), maxSecondarySlots:GetInt())
	SetGlobalInt(maxPrimarySlots:GetName(), maxPrimarySlots:GetInt())
	SetGlobalInt(maxNadeSlots:GetName(), maxNadeSlots:GetInt())
	SetGlobalInt(maxCarrySlots:GetName(), maxCarrySlots:GetInt())
	SetGlobalInt(maxUnarmedSlots:GetName(), maxUnarmedSlots:GetInt())
	SetGlobalInt(maxSpecialSlots:GetName(), maxSpecialSlots:GetInt())
	SetGlobalInt(maxExtraSlots:GetName(), maxExtraSlots:GetInt())
end)

cvars.AddChangeCallback(maxMeleeSlots:GetName(), function(name, old, new)
	SetGlobalInt(name, tonumber(new))
end, "TTT2MaxMeleeSlotsChange")

cvars.AddChangeCallback(maxSecondarySlots:GetName(), function(name, old, new)
	SetGlobalInt(name, tonumber(new))
end, "TTT2MaxSecondarySlotsChange")

cvars.AddChangeCallback(maxPrimarySlots:GetName(), function(name, old, new)
	SetGlobalInt(name, tonumber(new))
end, "TTT2MaxPrimarySlotsChange")

cvars.AddChangeCallback(maxNadeSlots:GetName(), function(name, old, new)
	SetGlobalInt(name, tonumber(new))
end, "TTT2MaxNadeSlotsChange")

cvars.AddChangeCallback(maxCarrySlots:GetName(), function(name, old, new)
	SetGlobalInt(name, tonumber(new))
end, "TTT2MaxCarrySlotsChange")

cvars.AddChangeCallback(maxUnarmedSlots:GetName(), function(name, old, new)
	SetGlobalInt(name, tonumber(new))
end, "TTT2MaxUnarmedSlotsChange")

cvars.AddChangeCallback(maxSpecialSlots:GetName(), function(name, old, new)
	SetGlobalInt(name, tonumber(new))
end, "TTT2MaxSpecialSlotsChange")

cvars.AddChangeCallback(maxExtraSlots:GetName(), function(name, old, new)
	SetGlobalInt(name, tonumber(new))
end, "TTT2MaxExtraSlotsChange")

ORDERED_SLOT_TABLE = {
	[WEAPON_MELEE] = "ttt2_max_melee_slots",
	[WEAPON_PISTOL] = "ttt2_max_secondary_slots",
	[WEAPON_HEAVY] = "ttt2_max_primary_slots",
	[WEAPON_NADE] = "ttt2_max_nade_slots",
	[WEAPON_CARRY] = "ttt2_max_carry_slots",
	[WEAPON_UNARMED] = "ttt2_max_unarmed_slots",
	[WEAPON_SPECIAL] = "ttt2_max_special_slots",
	[WEAPON_EXTRA] = "ttt2_max_extra_slots"
}

function MakeKindValid(kind)
	if kind > WEAPON_EXTRA or kind < WEAPON_MELEE then
		return WEAPON_EXTRA
	else
		return kind
	end
end

--we appeareantly need to have that, because added and removed entities are sometimes broken on client side and need to get updated later
--additionally spawn can be called when a player is alive in which case he doesn't loose weapons beforehand
function CleanupInventoryIfDirty(ply)
	if not ply.inventory or ply.refresh_inventory_cache then
		CleanupInventory(ply)
	end
end

function CleanupInventory(ply)
	if not IsValid(ply) then return end
	ply.refresh_inventory_cache = false
	
	ply.inventory = {}
	for k, v in pairs(ORDERED_SLOT_TABLE) do
		ply.inventory[k] = {}
	end
	
	--add weapons which are already in inventory
	for k, v in pairs( ply:GetWeapons() ) do
		if v.Kind then
			AddWeaponToInventory(ply, v)
		end
	end
end

function InventorySlotFree(ply, kind)
	if not IsValid(ply) then return false end
	
	CleanupInventoryIfDirty(ply)

	local invSlot = MakeKindValid(kind)
	
	local slotCount = GetGlobalInt(ORDERED_SLOT_TABLE[invSlot])

	return slotCount < 0 or #ply.inventory[invSlot] < slotCount
end

function AddWeaponToInventory(ply, wep)	
	if not IsValid(ply) then return false end
	
	CleanupInventoryIfDirty(ply)

	local invSlot = MakeKindValid(wep.Kind)
	
	table.insert(ply.inventory[invSlot], wep)
end

function RemoveWeaponFromInventory(ply, wep)
	if not IsValid(ply) then return false end

	CleanupInventoryIfDirty(ply)

	local invSlot = MakeKindValid(wep.Kind)

	table.RemoveByValue(ply.inventory[invSlot], wep)
end