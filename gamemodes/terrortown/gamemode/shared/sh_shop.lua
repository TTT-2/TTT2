---
-- A class to handle all shop requirements
-- @author ZenBre4ker
-- @class Shop

shop = shop or {}

function shop.IsEquipmentBuyableFor(ply, equipmentId)
	if not GetGlobalBool("ttt2_random_shops") or not RANDOMSHOP[ply] or #RANDOMSHOP[ply] == 0 then
		return true
	end

	for i = 1, #RANDOMSHOP[ply] do
		if RANDOMSHOP[ply][i].id ~= equipmentId then continue end

		return true
	end

	return false
end


local function HasPendingOrder(ply)
	return timer.Exists("give_equipment" .. ply:UniqueID())
end

---
-- Buys the equipment with the corresponding Id
-- @param string equipmentId The name of the equipment to buy
-- @realm shared
function shop.BuyEquipment(ply, equipmentId)
	if not IsValid(ply) or not equipmentId or not ply:IsActive() then return end

	if CLIENT then
		net.Start("TTT2OrderEquipment")
		net.WriteString(equipmentId)
		net.SendToServer()
	else
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

		local isItem = items.IsItem(equipmentId)

		-- The item/weapon might not even be part of the current shop
		if not shop.IsEquipmentBuyableFor(ply, equipmentId) then return end

		-- we use weapons.GetStored to save time on an unnecessary copy, we will not be modifying it
		local equip_table = not isItem and weapons.GetStored(equipmentId) or items.GetStored(equipmentId)

		if not equip_table then
			print(ply, "tried to buy equip that doesn't exists", equipmentId)

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
		local idOrCls = (isItem and equip_table.oldId or nil) or equipmentId

		local credits = equip_table.credits or 1

		if credits > ply:GetCredits() then
			print(ply, "tried to buy item/weapon, but didn't have enough credits")

			return
		end

		---
		-- @note Keep compatibility with old addons
		-- @realm server
		if not hook.Run("TTTCanOrderEquipment", ply, idOrCls, isItem) then return end

		---
		-- @note Add our own hook with more consistent class parameter and some more information
		-- @realm server
		local allow, ignoreCost, message = hook.Run("TTT2CanOrderEquipment", ply, equipmentId, isItem, credits)

		if message then
			LANG.Msg(ply, message, nil, MSG_MSTACK_ROLE)
		end

		if allow == false then return end

		if not ignoreCost then
			ply:SubtractCredits(credits)
		end

		ply:AddBought(equipmentId)

		-- no longer restricted to only WEAPON_EQUIP weapons, just anything that
		-- is whitelisted and carryable
		if isItem then
			local item = ply:GiveEquipmentItem(equipmentId)

			if isfunction(item.Bought) then
				item:Bought(ply)
			end
		else
			ply:GiveEquipmentWeapon(equipmentId, function(p, c, w)
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
			net.WriteString(equipmentId)
			net.Send(ply)
		end)

		if GetGlobalBool("ttt2_random_shop_reroll_per_buy") then
			RerollShop(ply)
		end

		---
		-- @note Keep compatibility with old addons
		-- @realm server
		hook.Run("TTTOrderedEquipment", ply, idOrCls, isItem)

		---
		-- @note Add our own hook with more consistent class parameter
		-- @realm server
		hook.Run("TTT2OrderedEquipment", ply, equipmentId, isItem, credits, ignoreCost or false)
	end
end

function shop.CanRerollShop(ply)
	return GetGlobalBool("ttt2_random_shops")
		and GetGlobalBool("ttt2_random_shop_reroll")
		and IsValid(ply)
		and ply:IsActiveShopper()
		and ply:GetCredits() >= GetGlobalInt("ttt2_random_shop_reroll_cost")
end

function shop.RerollShop(ply)
	if not shop.CanRerollShop(ply) return end

	if CLIENT then
		RunConsoleCommand("ttt2_reroll_shop")
	else
		ply:SubtractCredits(GetGlobalInt("ttt2_random_shop_reroll_cost"))

		if GetGlobalBool("ttt2_random_team_shops") then
			ResetRandomShopsForRole(ply:GetSubRole(), GetGlobalInt("ttt2_random_shop_items"), true)
		else
			UpdateRandomShops({ply}, GetGlobalInt("ttt2_random_shop_items"), false)
		end
	end
end

function shop.TransferCredits(ply, targetPlyId64, credits)
	if not IsValid(ply) or not isstring(targetPlyId64) or not isnumber(credits) or credits <= 0 then return end

	if CLIENT then
		RunConsoleCommand("ttt_transfer_credits", targetPlyId64, credits)
	else
		local target = player.GetBySteamID64(targetPlyId64)

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

		---
		-- @realm server
		local allow, _ = hook.Run("TTT2CanTransferCredits", ply, target, credits)
		if allow == false then return end

		ply:SubtractCredits(credits)
		if target:IsTerror() and target:Alive() then
			target:AddCredits(credits)
		else
			-- The would be recipient is dead, which the sender may not know.
			-- Instead attempt to send the credits to the target's corpse, where they can be picked up.
			local rag = target:FindCorpse()
			if IsValid(rag) then
				CORPSE.SetCredits(rag, CORPSE.GetCredits(rag, 0) + credits)
			end
		end

		net.Start("TTT2CreditTransferUpdate")
		net.Send(ply)
		LANG.Msg(ply, "xfer_success", {player = target:Nick()}, MSG_MSTACK_ROLE)
		LANG.Msg(target, "xfer_received", {player = ply:Nick(), num = credits}, MSG_MSTACK_ROLE)
	end
end
