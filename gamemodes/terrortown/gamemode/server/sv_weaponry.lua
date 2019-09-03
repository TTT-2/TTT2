---
-- @section weapon_manager

ttt_include("sh_weaponry") -- inits WEPS tbl

util.AddNetworkString("TTT2CleanupInventory")
util.AddNetworkString("TTT2AddWeaponToInventory")
util.AddNetworkString("TTT2RemoveWeaponFromInventory")

-- Weapon system, pickup limits, etc
local ipairs = ipairs
local IsValid = IsValid
local table = table
local timer = timer
local net = net
local hook = hook

local IsEquipment = WEPS.IsEquipment

---
-- Returns whether or not a @{Player} is allowed to pick up a @{Weapon}
-- @note Prevent @{Player}s from picking up multiple @{Weapon}s of the same type etc
-- @param Player ply The @{Player} attempting to pick up the @{Weapon}
-- @param Weapon wep The @{Weapon} entity in question
-- @return boolean Allowed pick up or not
-- @hook
-- @realm server
-- @ref https://wiki.garrysmod.com/page/GM/PlayerCanPickupWeapon
-- @local
function GM:PlayerCanPickupWeapon(ply, wep)
	if not IsValid(wep) or not IsValid(ply) then return end

	if ply:IsSpec() then
		return false
	end

	local wepClass = WEPS.GetClass(wep)

	-- Disallow picking up for ammo
	if ply:HasWeapon(wepClass)
	or not ply:CanCarryWeapon(wep)
	or IsEquipment(wep) and wep.IsDropped and not ply:KeyDown(IN_USE)
	then
		return false
	end

	local tr = util.TraceEntity({start = wep:GetPos(), endpos = ply:GetShootPos(), mask = MASK_SOLID}, wep)

	if tr.Fraction == 1.0 or tr.Entity == ply then
		wep:SetPos(ply:GetShootPos())
	end

	return true
end

-- Cache subrole -> default-weapons table
local loadout_weapons = {}

local function GetLoadoutWeapons(subrole)
	if not loadout_weapons[subrole] then
		loadout_weapons[subrole] = {}

		for _, w in ipairs(weapons.GetList()) do
			if type(w.InLoadoutFor) == "table" and not w.Doublicated then
				local cls = WEPS.GetClass(w)

				if table.HasValue(w.InLoadoutFor, subrole) then
					if not table.HasValue(loadout_weapons[subrole], cls) then
						table.insert(loadout_weapons[subrole], cls)
					end
				elseif table.HasValue(w.InLoadoutFor, ROLE_INNOCENT) then -- setup for new roles
					table.insert(w.InLoadoutFor, subrole)

					if not table.HasValue(loadout_weapons[subrole], cls) then
						table.insert(loadout_weapons[subrole], cls)
					end
				end
			end
		end

		-- default loadout, insert it at the end
		local default = {
			"weapon_zm_carry",
			"weapon_ttt_unarmed",
			"weapon_zm_improvised"
		}

		for _, def in ipairs(default) do
			if not table.HasValue(loadout_weapons[subrole], def) then
				table.insert(loadout_weapons[subrole], def)
			end
		end

		hook.Run("TTT2ModifyDefaultLoadout", loadout_weapons, subrole)
	end

	return loadout_weapons[subrole]
end

-- Give player loadout weapons he should have for his subrole that he does not have
-- yet
local function GiveLoadoutWeapon(ply, cls)
	if not ply:HasWeapon(cls) and ply:CanCarryType(WEPS.TypeForWeapon(cls)) then
		local wep = ply:Give(cls)

		ply.loadoutWeps = ply.loadoutWeps or {}

		if not table.HasValue(ply.loadoutWeps, cls) then
			ply.loadoutWeps[#ply.loadoutWeps + 1] = cls
		end

		return wep
	end
end

local function GiveLoadoutWeapons(ply)
	local subrole = GetRoundState() == ROUND_PREP and ROLE_INNOCENT or ply:GetSubRole()
	local weps = GetLoadoutWeapons(subrole)

	if not weps then return end

	for _, cls in ipairs(weps) do
		if not ply:HasWeapon(cls) and ply:CanCarryType(WEPS.TypeForWeapon(cls)) then
			GiveLoadoutWeapon(ply, cls)
		end
	end
end

local function GetGiveLoadoutWeapons(ply)
	local subrole = GetRoundState() == ROUND_PREP and ROLE_INNOCENT or ply:GetSubRole()
	local weps = GetLoadoutWeapons(subrole)
	local tmp = {}

	if weps then
		for _, cls in ipairs(weps) do
			tmp[#tmp + 1] = cls
		end
	end

	return tmp
end

local function GetResetLoadoutWeapons(ply)
	local tmp = {}

	ply.loadoutWeps = ply.loadoutWeps or {}

	for _, wep in pairs(ply:GetWeapons()) do
		local cls = WEPS.GetClass(wep)

		if table.HasValue(ply.loadoutWeps, cls) and cls ~= "weapon_ttt_unarmed" then
			tmp[#tmp + 1] = cls
		end
	end

	return tmp
end

local function HasLoadoutWeapons(ply)
	if ply:IsSpec() then
		return true
	end

	local subrole = GetRoundState() == ROUND_PREP and ROLE_INNOCENT or ply:GetSubRole()
	local weps = GetLoadoutWeapons(subrole)

	if not weps then
		return true
	end

	for _, cls in ipairs(weps) do
		if not ply:HasWeapon(cls) and ply:CanCarryType(WEPS.TypeForWeapon(cls)) then
			return false
		end
	end

	return true
end

-- Cache subrole -> default-items table
local loadout_items = {}

-- Get loadout items.
local function GetLoadoutItems(subrole)
	if not loadout_items[subrole] then
		loadout_items[subrole] = {}

		for _, w in ipairs(items.GetList()) do
			if type(w.InLoadoutFor) == "table" and not w.Doublicated then
				local cls = w.id

				if table.HasValue(w.InLoadoutFor, subrole) then
					if not table.HasValue(loadout_items[subrole], cls) then
						table.insert(loadout_items[subrole], cls)
					end
				elseif table.HasValue(w.InLoadoutFor, ROLE_INNOCENT) then -- setup for new roles
					table.insert(w.InLoadoutFor, subrole)

					if not table.HasValue(loadout_items[subrole], cls) then
						table.insert(loadout_items[subrole], cls)
					end
				end
			end
		end

		hook.Run("TTT2ModifyDefaultLoadout", loadout_items, subrole)
	end

	return loadout_items[subrole]
end

-- Give player loadout items he should have for his subrole that he does not have
-- yet
local function GiveLoadoutItem(ply, cls)
	if not ply:HasEquipmentItem(cls) then
		local item = ply:GiveItem(cls)

		ply.loadoutItems = ply.loadoutItems or {}

		if not table.HasValue(ply.loadoutItems, cls) then
			ply.loadoutItems[#ply.loadoutItems + 1] = cls
		end

		return item
	end
end

local function GiveLoadoutItems(ply)
	local subrole = GetRoundState() == ROUND_PREP and ROLE_INNOCENT or ply:GetSubRole()
	local itms = GetLoadoutItems(subrole)

	if not itms then return end

	for _, cls in ipairs(itms) do
		if not ply:HasEquipmentItem(cls) then
			GiveLoadoutItem(ply, cls)
		end
	end
end

local function ResetLoadoutItems(ply)
	local itms = GetModifiedEquipment(ply, items.GetRoleItems(ply:GetSubRole()))
	if itms then
		for _, item in ipairs(itms) do
			if item.loadout then
				ply:RemoveItem(item.id)
			end
		end
	end
end

-- Quick hack to limit hats to models that fit them well
local Hattables = {
	"phoenix.mdl",
	"arctic.mdl",
	"Group01",
	"monk.mdl"
}

local function CanWearHat(ply)
	local path = string.Explode("/", ply:GetModel())

	if #path == 1 then
		path = string.Explode("\\", path)
	end

	return table.HasValue(Hattables, path[3])
end

CreateConVar("ttt_detective_hats", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

-- Just hats right now
local function GiveLoadoutSpecial(ply)
	if ply:IsActive() and ply:GetBaseRole() == ROLE_DETECTIVE and GetConVar("ttt_detective_hats"):GetBool() and CanWearHat(ply) then
		if not IsValid(ply.hat) then
			local hat = ents.Create("ttt_hat_deerstalker")

			if not IsValid(hat) then return end

			hat:SetPos(ply:GetPos() + Vector(0, 0, 70))
			hat:SetAngles(ply:GetAngles())
			hat:SetParent(ply)

			ply.hat = hat

			hat:Spawn()
		end
	else
		SafeRemoveEntity(ply.hat)

		ply.hat = nil
	end
end

---
-- Sometimes, in cramped map locations, giving players weapons fails. A timer
-- calling this function is used to get them the weapons anyway as soon as
-- possible.
local function LateLoadout(id)
	local ply = Entity(id)

	if not IsValid(ply) or not ply:IsPlayer() then
		timer.Remove("lateloadout" .. id)

		return
	end

	if not HasLoadoutWeapons(ply) then
		GiveLoadoutWeapons(ply)

		if HasLoadoutWeapons(ply) then
			timer.Remove("lateloadout" .. id)
		end
	else
		timer.Remove("lateloadout" .. id)
	end
end

---
-- Called to give @{Player}s the default set of @{Weapon}s.
-- @note This function may not work in your custom gamemode if you have overridden your
-- @{GM:PlayerSpawn} and you do not use self.BaseClass.PlayerSpawn or @{hook.Call}.
-- @param Player ply @{Player} to give @{Weapon}s to
-- @note Note that this is called both when a @{Player} spawns and when a round starts
-- @hook
-- @realm server
-- @ref https://wiki.garrysmod.com/page/GM/PlayerLoadout
-- @local
function GM:PlayerLoadout(ply)
	if IsValid(ply) and not ply:IsSpec() then
		CleanupInventoryAndNotifyClient(ply)

		ResetLoadoutItems(ply)

		-- give default items
		GiveLoadoutItems(ply)

		-- reset default loadout
		local reset = GetResetLoadoutWeapons(ply)

		-- hand out weaponry
		local give = GetGiveLoadoutWeapons(ply)

		local tmp = {}

		-- check which weapon the player should get/loose
		for k, cls in ipairs(reset) do
			local has = false

			for k2, cls2 in ipairs(give) do
				if cls == cls2 then
					has = true

					table.remove(give, k2)

					break
				end
			end

			if not has then
				tmp[#tmp + 1] = cls
			end
		end

		for _, cls in ipairs(tmp) do
			ply:StripWeapon(cls)

			for k, v in ipairs(ply.loadoutWeps) do
				if cls == v then
					table.remove(ply.loadoutWeps, k)

					break
				end
			end
		end

		for _, cls in ipairs(give) do
			GiveLoadoutWeapon(ply, cls)
		end

		GiveLoadoutSpecial(ply)

		if not HasLoadoutWeapons(ply) then
			MsgN("Could not spawn all loadout weapons for " .. ply:Nick() .. ", will retry.")

			local timerId = ply:EntIndex()

			timer.Create("lateloadout" .. timerId, 1, 0, function()
				LateLoadout(timerId)
			end)
		end
	end
end

---
-- Called whenever all @{Player}s' loadout should update
-- @note this internally calls @{GM:PlayerLoadout} for every @{Player}
-- @hook
-- @realm server
-- @ref https://wiki.garrysmod.com/page/GM/PlayerLoadout
function GM:UpdatePlayerLoadouts()
	for _, ply in ipairs(player.GetAll()) do
		hook.Call("PlayerLoadout", GAMEMODE, ply)
	end
end

---
-- Weapon switching
local function ForceWeaponSwitch(ply, cmd, args)
	if not ply:IsPlayer() then return end

	local wepname = args[1]
	if not wepname then return end

	-- Turns out even SelectWeapon refuses to switch to empty guns, gah.
	-- Worked around it by giving every weapon a single Clip2 round.
	-- Works because no weapon uses those.
	local wep = ply:GetWeapon(wepname)

	if IsValid(wep) then
		-- Weapons apparently not guaranteed to have this
		if wep.SetClip2 then
			wep:SetClip2(1)
		end

		ply:SelectWeapon(wepname)
	end
end
concommand.Add("wepswitch", ForceWeaponSwitch)

---
-- Weapon dropping

---
-- Called whenever a @{Player} drops a @{Weapon}, e.g. on death
-- @param Player ply
-- @param Weapon wep
-- @param boolean death_drop
-- @realm server
-- @module WEPS
function WEPS.DropNotifiedWeapon(ply, wep, death_drop)
	if IsValid(ply) and IsValid(wep) then
		-- Hack to tell the weapon it's about to be dropped and should do what it
		-- must right now
		if wep.PreDrop then
			wep:PreDrop(death_drop)
		end

		-- PreDrop might destroy weapon
		if not IsValid(wep) then return end

		-- Tag this weapon as dropped, so that if it's a special weapon we do not
		-- auto-pickup when nearby.
		wep.IsDropped = true

		ply:DropWeapon(wep)

		wep:PhysWake()

		-- After dropping a weapon, always switch to holstered, so that traitors
		-- will never accidentally pull out a traitor weapon
		ply:SelectWeapon("weapon_ttt_unarmed")
	end
end

local function DropActiveWeapon(ply)
	if not IsValid(ply) then return end

	local wep = ply:GetActiveWeapon()

	if not IsValid(wep) or not wep.AllowDrop then return end

	local tr = util.QuickTrace(ply:GetShootPos(), ply:GetAimVector() * 32, ply)

	if tr.HitWorld then
		LANG.Msg(ply, "drop_no_room")

		return
	end

	ply:AnimPerformGesture(ACT_GMOD_GESTURE_ITEM_PLACE)

	WEPS.DropNotifiedWeapon(ply, wep)
end
concommand.Add("ttt_dropweapon", DropActiveWeapon)

local function DropActiveAmmo(ply)
	if not IsValid(ply) then return end

	local wep = ply:GetActiveWeapon()

	if not IsValid(wep) then return end

	if not wep.AmmoEnt then return end

	local amt = wep:Clip1()

	if amt < 1 or amt <= wep.Primary.ClipSize * 0.25 then
		LANG.Msg(ply, "drop_no_ammo")

		return
	end

	local pos, ang = ply:GetShootPos(), ply:EyeAngles()
	local dir = ang:Forward() * 32 + ang:Right() * 6 + ang:Up() * -5
	local tr = util.QuickTrace(pos, dir, ply)

	if tr.HitWorld then return end

	wep:SetClip1(0)

	ply:AnimPerformGesture(ACT_GMOD_GESTURE_ITEM_GIVE)

	local box = ents.Create(wep.AmmoEnt)

	if not IsValid(box) then return end

	box:SetPos(pos + dir)
	box:SetOwner(ply)
	box:Spawn()
	box:PhysWake()

	local phys = box:GetPhysicsObject()

	if IsValid(phys) then
		phys:ApplyForceCenter(ang:Forward() * 1000)
		phys:ApplyForceOffset(VectorRand(), vector_origin)
	end

	box.AmmoAmount = amt

	timer.Simple(2, function()
		if IsValid(box) then
			box:SetOwner(nil)
		end
	end)
end
concommand.Add("ttt_dropammo", DropActiveAmmo)

---
-- Called as a @{Weapon} entity is picked up by a @{Player}.<br />
-- See also @{GM:PlayerDroppedWeapon}
-- @note At the time when this hook is called @{Entity:GetOwner} will return NULL.
-- The owner is set on the next frame
-- @note This will not be called when picking up a @{Weapon} you already have as
-- the @{Weapon} will be removed and @{WEAPON:EquipAmmo} will be called instead
-- @note Protect against non-TTT @{Weapon}s that may break the HUD
-- @param Weapon wep The equipped @{Weapon}
-- @param Player ply The @{Player} that is picking up the @{Weapon}
-- @hook
-- @realm server
-- @ref https://wiki.garrysmod.com/page/GM/WeaponEquip
-- @local
function GM:WeaponEquip(wep, ply)
	if IsValid(wep) and not wep.Kind then
		-- only remove if they lack critical stuff
		wep:Remove()

		ErrorNoHalt("Equipped weapon " .. wep:GetClass() .. " is not compatible with TTT\n")
	end

	if IsValid(ply) and wep.Kind then
		AddWeaponToInventoryAndNotifyClient(ply, wep)
	end
end

---
-- Called when a @{Weapon} is dropped by a @{Player} via @{Player:DropWeapon}.<br />
-- See also @{GM:WeaponEquip} for a hook when a @{Player} picks up a @{Weapon}.<br />
-- The @{Weapon}'s @{Entity:GetOwner} will be NULL at the time this hook is called.
-- @{Weapon:OnDrop} will be called before this hook is.
-- @param Player ply The @{Player} who owned this @{Weapon} before it was dropped
-- @param Weapon wep The @{Weapon} that was dropped
-- @hook
-- @realm server
-- @ref https://wiki.garrysmod.com/page/GM/PlayerDroppedWeapon
-- @local
function GM:PlayerDroppedWeapon(ply, wep)
	if IsValid(wep) and IsValid(ply) and wep.Kind then
		RemoveWeaponFromInventoryAndNotifyClient(ply, wep)
	end
end

---
-- Called right before the removal of an entity.
-- @param Entity ent @{Entity} being removed
-- @hook
-- @realm server
-- @ref https://wiki.garrysmod.com/page/GM/EntityRemoved
-- @local
function GM:EntityRemoved(ent)
	if IsValid(ent) and IsValid(ent:GetOwner()) and ent:IsWeapon() and ent.Kind then
		RemoveWeaponFromInventoryAndNotifyClient(ent:GetOwner(), ent)
	end
end

---
-- Forces a @{Model} pre-cache for each @{Weapon}
-- @note non-cheat developer commands can reveal precaching the first time equipment
-- is bought, so trigger it at the start of a round instead
-- @realm server
-- @module WEPS
function WEPS.ForcePrecache()
	for _, w in ipairs(weapons.GetList()) do
		if w.WorldModel then
			util.PrecacheModel(w.WorldModel)
		end

		if w.ViewModel then
			util.PrecacheModel(w.ViewModel)
		end
	end
end

--manipulate shove attack for all crowbar alikes
local crowbar_delay = CreateConVar("ttt2_crowbar_shove_delay", "1.0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

local function ChangeShoveDelay()
	for _, wep in ipairs(weapons.GetList()) do
		--all weapons on the WEAPON_MELEE slot should be Crowbars or Crowbar alikes
		if wep.Kind and wep.Kind == WEAPON_MELEE then
			wep.Secondary.Delay = crowbar_delay:GetFloat()
		end
	end
end

cvars.AddChangeCallback(crowbar_delay:GetName(), function(name, old, new)
	ChangeShoveDelay()
end, "TTT2CrowbarShoveDelay")

-- TODO remove this
hook.Add("TTT2Initialize", "TTT2ChangeMeleesSecondaryDelay", function()
	ChangeShoveDelay()
end)
