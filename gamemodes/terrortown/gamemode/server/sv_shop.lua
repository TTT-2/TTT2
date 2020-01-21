---
-- @section shop

local function RerollShop(ply)
	if GetGlobalBool("ttt2_random_team_shops") then
		ResetRandomShopsForRole(ply:GetSubRole(), GetGlobalInt("ttt2_random_shops"), true)
	else
		UpdateRandomShops({ply}, GetGlobalInt("ttt2_random_shops"), false)
	end
end

local function HasPendingOrder(ply)
	return timer.Exists("give_equipment" .. ply:UniqueID())
end

---
-- Called whenever a @{Player} tries to order an @{ITEM} or @{Weapon}
-- @param Player ply
-- @param string id id of the @{ITEM} or @{Weapon}, old id for @{ITEM} and class for @{Weapon}
-- @param bool is_item is id an @{ITEM} or @{Weapon}
-- @return[default=true] boolean return true to allow buying of an equipment item, false to disallow
-- @hook
-- @realm server
function GM:TTTCanOrderEquipment(ply, id, is_item)
	return true
end

local function IsPartOfShop(ply, cls)
	if GetGlobalInt("ttt2_random_shops") == 0 or not RANDOMSHOP[ply] or #RANDOMSHOP[ply] == 0 then
		return true
	end

	for i = 1, #RANDOMSHOP[ply] do
		if RANDOMSHOP[ply][i].id ~= cls then continue end

		return true
	end

	print(ply, "tried to buy a prohibited item/weapon!")

	return false
end

-- Equipment buying
local function OrderEquipment(ply, cls)
	if not IsValid(ply) or not cls or not ply:IsActive() then return end

	-- if we have a pending order because we are in a confined space, don't
	-- start a new one
	if HasPendingOrder(ply) then
		LANG.Msg(ply, "buy_pending", nil, MSG_MSTACK_ROLE)

		return
	end

	local subrole = GetShopFallback(ply:GetSubRole())
	local rd = roles.GetByIndex(subrole)

	local shopFallback = GetGlobalString("ttt_" .. rd.abbr .. "_shop_fallback")
	if shopFallback == SHOP_DISABLED then return end

	local is_item = items.IsItem(cls)

	-- The item/weapon might not even be part of the current shop
	if not IsPartOfShop(ply, cls) then return end

	-- we use weapons.GetStored to save time on an unnecessary copy, we will not be modifying it
	local equip_table = not is_item and weapons.GetStored(cls) or items.GetStored(cls)

	if not equip_table then
		print(ply, "tried to buy equip that doesn't exists", cls)

		return
	end

	-- Check for minimum players, global limit, team limit and player limit
	local buyable, _, reason = EquipmentIsBuyable(equip_table, ply)
	if not buyable then
		if reason then
			LANG.Msg(ply, reason, nil, MSG_MSTACK_ROLE)
		end

		return
	end

	-- still support old items
	local idOrCls = (is_item and equip_table.oldId or nil) or cls

	local credits = equip_table.credits or 1

	if credits > ply:GetCredits() then
		print(ply, "tried to buy item/weapon, but didn't have enough credits")

		return
	end

	-- keep compatibility with old addons
	if not hook.Run("TTTCanOrderEquipment", ply, idOrCls, is_item) then return end

	-- add our own hook with more consistent class parameter and some more information
	local allow, ignoreCost, message = hook.Run("TTT2CanOrderEquipment", ply, cls, is_item, credits)

	if message then
		LANG.Msg(ply, message, nil, MSG_MSTACK_ROLE)
	end

	if allow == false then return end

	if not ignoreCost then
		ply:SubtractCredits(credits)
	end

	ply:AddBought(cls)

	-- no longer restricted to only WEAPON_EQUIP weapons, just anything that
	-- is whitelisted and carryable
	if is_item then
		local item = ply:GiveEquipmentItem(cls)

		if isfunction(item.Bought) then
			item:Bought(ply)
		end
	else
		ply:GiveEquipmentWeapon(cls, function(p, c, w)
			if isfunction(w.WasBought) then
				-- some weapons give extra ammo after being bought, etc
				w:WasBought(p)
			end
		end)
	end

	LANG.Msg(ply, "buy_received", nil, MSG_MSTACK_ROLE)

	timer.Simple(0.5, function()
		if not IsValid(ply) then return end

		net.Start("TTT_BoughtItem")
		net.WriteString(cls)
		net.Send(ply)
	end)

	if GetGlobalBool("ttt2_random_shop_reroll_per_buy") then
		RerollShop(ply)
	end

	-- keep compatibility with old addons
	hook.Run("TTTOrderedEquipment", ply, idOrCls, is_item)

	-- add our own hook with more consistent class parameter
	hook.Run("TTT2OrderedEquipment", ply, cls, is_item, credits, ignoreCost or false)
end

local function NetOrderEquipment(len, ply)
	local cls = net.ReadString()

	OrderEquipment(ply, cls)
end
net.Receive("TTT2OrderEquipment", NetOrderEquipment)

local function ConCommandOrderEquipment(ply, cmd, args)
	if #args ~= 1 then return end

	OrderEquipment(ply, args[1])
end
concommand.Add("ttt_order_equipment", ConCommandOrderEquipment)

---
-- Called whenever a @{Player} toggles the disguiser state
-- @note Can be used to prevent players from using this button.
-- @param Player ply
-- @param boolean state
-- @return boolean return true to prevent using this button.
-- @hook
-- @realm server
function GM:TTTToggleDisguiser(ply, state)

end

local function CheatCredits(ply)
	if not IsValid(ply) then return end

	ply:AddCredits(10)
end
concommand.Add("ttt_cheat_credits", CheatCredits, nil, nil, FCVAR_CHEAT)

local function TransferCredits(ply, cmd, args)
	if not IsValid(ply) then return end

	if #args ~= 2 then return end

	local sid64 = tostring(args[1])
	local credits = tonumber(args[2])

	if sid64 == nil or not credits then return end

	local target = player.GetBySteamID64(sid64)

	if not IsValid(target)
	or target == ply
	then
		LANG.Msg(ply, "xfer_no_recip", nil, MSG_MSTACK_ROLE)

		return
	end

	if ply:GetCredits() < credits then
		LANG.Msg(ply, "xfer_no_credits", nil, MSG_MSTACK_ROLE)

		return
	end

	credits = math.Clamp(credits, 0, ply:GetCredits())

	if credits == 0 then return end

	ply:SubtractCredits(credits)
	target:AddCredits(credits)

	LANG.Msg(ply, "xfer_success", {player = target:Nick()}, MSG_MSTACK_ROLE)
	LANG.Msg(target, "xfer_received", {player = ply:Nick(), num = credits}, MSG_MSTACK_ROLE)
end
concommand.Add("ttt_transfer_credits", TransferCredits)

local function RerollShopForCredit(ply, cmd, args)
	if not IsValid(ply) or not ply:IsActiveShopper() or ply:GetCredits() < GetGlobalInt("ttt2_random_shop_reroll_cost") or not GetGlobalBool("ttt2_random_shop_reroll") then return end

	ply:SubtractCredits(GetGlobalInt("ttt2_random_shop_reroll_cost"))
	RerollShop(ply)
end
concommand.Add("ttt2_reroll_shop", RerollShopForCredit)
