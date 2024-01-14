---
-- A class to handle all shop requirements
-- @author ZenBre4ker
-- @class Shop

shop = shop or {}

shop.statusCode = {
	SUCCESS = 1,
	SUCCESSIGNORECOST = 2,
	INVALIDPLAYER = 3,
	INVALIDID = 4,
	NOTEXISTING = 5,
	NOTENOUGHCREDITS = 6,
	NOTBUYABLE = 7,
	NOTENOUGHPLAYERS = 8,
	LIMITEDBOUGHT = 9,
	NOTBUYABLEFORROLE = 10,
	PENDINGORDER = 11,
	NOSHOP = 12,
	NORANDOMSHOP = 13,
	NOTINSHOP = 14,
	BLOCKEDBYOLDHOOK = 15,
	BLOCKEDBYTTT2HOOK = 16,
}

---
-- Check if an equipment is currently buyable for a player
-- @param Player ply The player to buy the equipment for
-- @param string equipmentId The name of the equipment to buy
-- @return bool True, if equipment can be bought
-- @return number The shop.statusCode, that lead to the decision
-- @realm shared
function shop.CanBuyEquipment(ply, equipmentId)
	if not IsValid(ply) or not ply:IsActive() then
		return false, shop.statusCode.INVALIDPLAYER
	end

	if not equipmentId then
		return false, shop.statusCode.INVALIDID
	end

	local isItem = items.IsItem(equipmentId)

	-- we use weapons.GetStored to save time making an unnecessary copy, we will not be modifying it
	local equipment = isItem and items.GetStored(equipmentId) or weapons.GetStored(equipmentId)

	if not istable(equipment) then
		return false, shop.statusCode.NOTEXISTING
	end

	local credits = equipment.credits or 1

	if credits > ply:GetCredits() then
		return false, shop.statusCode.NOTENOUGHCREDITS
	end

	if equipment.notBuyable then
		return false, shop.statusCode.NOTBUYABLE
	end

	if equipment.minPlayers and equipment.minPlayers > 1 then
		local activePlys = util.GetActivePlayers()

		if #activePlys < equipment.minPlayers then
			return false,  shop.statusCode.NOTENOUGHPLAYERS
		end
	end

	local team = ply:GetTeam()

	if equipment.globalLimited
		and BUYTABLE[equipment.id]
		or team
		and equipment.teamLimited
		and TEAMS[team]
		and not TEAMS[team].alone
		and TEAMBUYTABLE[team]
		and TEAMBUYTABLE[team][equipment.id]
		or equipment.limited
		and ply:HasBought(equipment.ClassName) then
		return false, shop.statusCode.LIMITEDBOUGHT
	end

	local subrole = GetShopFallback(ply:GetSubRole())

	-- weapon whitelist check
	if not equipment.CanBuy[subrole] then
		return false, shop.statusCode.NOTBUYABLEFORROLE
	end

	if CLIENT then
		return true, shop.statusCode.SUCCESS
	end

	-- if we have a pending order because we are in a confined space, don't
	-- start a new one
	if timer.Exists("give_equipment" .. ply:UniqueID()) then
		return false, shop.statusCode.PENDINGORDER
	end

	local rd = roles.GetByIndex(subrole)
	local shopFallback = GetGlobalString("ttt_" .. rd.abbr .. "_shop_fallback")

	if shopFallback == SHOP_DISABLED then
		return false, shop.statusCode.NOSHOP
	end

	if GetGlobalBool("ttt2_random_shops") then
		if not RANDOMSHOP[ply] or #RANDOMSHOP[ply] == 0 then
			return false, shop.statusCode.NORANDOMSHOP
		end

		local containedInRandomShop = false

		for i = 1, #RANDOMSHOP[ply] do
			if RANDOMSHOP[ply][i].id ~= equipmentId then continue end

			containedInRandomShop = true
		end

		if not containedInRandomShop then
			return false, shop.statusCode.NOTINSHOP
		end
	end

	-- Still support old items
	local oldId = isItem and equipment.oldId or equipmentId

	---
	-- @note Keep compatibility with old addons
	-- @realm server
	if not hook.Run("TTTCanOrderEquipment", ply, oldId, isItem) then
		return false, shop.statusCode.BLOCKEDBYOLDHOOK
	end

	---
	-- @note Add our own hook with more consistent class parameter and some more information
	-- @realm server
	local allow, ignoreCost = hook.Run("TTT2CanOrderEquipment", ply, equipmentId, isItem, credits)
	if not allow then
		return false, shop.statusCode.BLOCKEDBYTTT2HOOK
	end

	if ignoreCost then
		return true, shop.statusCode.SUCCESSIGNORECOST
	end

	return true, shop.statusCode.SUCCESS
end


---
-- Buys for player the equipment with the corresponding Id
-- @param Player ply The player to buy the equipment for
-- @param string equipmentId The name of the equipment to buy
-- @return bool True, if equipment can be bought
-- @return number The shop.statusCode, that lead to the decision
-- @realm shared
function shop.BuyEquipment(ply, equipmentId)
	local isBuyable, statusCode = shop.CanBuyEquipment(ply, equipmentId)
	if not isBuyable then
		return false, statusCode
	end

	if CLIENT then
		net.Start("TTT2OrderEquipment")
		net.WriteString(equipmentId)
		net.SendToServer()
	else
		local isItem = items.IsItem(equipmentId)

		-- we use weapons.GetStored to save time making an unnecessary copy, we will not be modifying it
		local equipment = isItem and items.GetStored(equipmentId) or weapons.GetStored(equipmentId)
		local credits = equipment.credits or 1
		local ignoreCost = statusCode == shop.statusCode.SUCCESSIGNORECOST

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
			ply:GiveEquipmentWeapon(equipmentId, function(_ply, _equipmentId, _weapon)
				if isfunction(_weapon.WasBought) then
					-- some weapons give extra ammo after being bought, etc
					_weapon:WasBought(_ply)
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
			shop.ForceRerollShop(ply)
		end

		-- Still support old items
		local oldId = isItem and equipment.oldId or equipmentId

		---
		-- @note Keep compatibility with old addons
		-- @realm server
		hook.Run("TTTOrderedEquipment", ply, oldId, isItem)

		---
		-- @note Add our own hook with more consistent class parameter
		-- @realm server
		hook.Run("TTT2OrderedEquipment", ply, equipmentId, isItem, credits, ignoreCost)
	end

	return true, statusCode
end

---
-- Check if the player can reroll their shop
-- @param Player ply The player to reroll the shop for
-- @return bool True, if shop can be rerolled
-- @realm shared
function shop.CanRerollShop(ply)
	return GetGlobalBool("ttt2_random_shops")
		and GetGlobalBool("ttt2_random_shop_reroll")
		and IsValid(ply)
		and ply:IsActiveShopper()
		and ply:GetCredits() >= GetGlobalInt("ttt2_random_shop_reroll_cost")
end

---
-- Reroll shop for player and subtract the credits of it
-- @note Use `shop.ForceRerollShop(ply)` to reroll without cost and restrictions
-- @param Player ply The player to reroll the shop for
-- @return bool True, if shop was successfully rerolled
-- @realm shared
function shop.TryRerollShop(ply)
	if not shop.CanRerollShop(ply) then
		return false
	end

	if CLIENT then
		RunConsoleCommand("ttt2_reroll_shop")
	else
		ply:SubtractCredits(GetGlobalInt("ttt2_random_shop_reroll_cost"))
		shop.ForceRerollShop(ply)
	end

	return true
end

---
-- Transfer credits from one player to another
-- @param Player The player to transfer the credits from
-- @param string The SteamID64 of the player to transfer the credits to
-- @param number The number of credits to transfer
-- @realm shared
function shop.TransferCredits(ply, targetPlyId64, credits)
	if not IsValid(ply) or not isstring(targetPlyId64) or not isnumber(credits) or credits <= 0 then return end

	if CLIENT then
		RunConsoleCommand("ttt_transfer_credits", targetPlyId64, credits)
	else
		local target = player.GetBySteamID64(targetPlyId64)

		if not IsValid(target) or target == ply then
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
