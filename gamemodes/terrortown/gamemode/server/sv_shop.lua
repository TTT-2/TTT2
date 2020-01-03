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
-- @param string id id of the @{ITEM} or @{Weapon}
-- @return[default=true] boolean return true to allow buying of an equipment item, false to disallow
-- @hook
-- @realm server
function GM:TTTCanOrderEquipment(ply, id)
	return true
end

-- Equipment buying
local function OrderEquipment(ply, cmd, args)
	if not IsValid(ply) or #args ~= 1 then return end

	local subrole = GetShopFallback(ply:GetSubRole())

	if not ply:IsActive() then return end

	local rd = roles.GetByIndex(subrole)

	local shopFallback = GetGlobalString("ttt_" .. rd.abbr .. "_shop_fallback")
	if shopFallback == SHOP_DISABLED then return end

	-- it's an item if the arg is an id instead of an ent name
	local id = args[1]

	if not hook.Run("TTTCanOrderEquipment", ply, id) then return end

	local is_item = items.IsItem(id)

	-- we use weapons.GetStored to save time on an unnecessary copy, we will not
	-- be modifying it
	local equip_table = not is_item and weapons.GetStored(id) or items.GetStored(id)

	-- some weapons can only be bought once per player per round, this used to be
	-- defined in a table here, but is now in the SWEP's table
	if equip_table and equip_table.limited and ply:HasBought(id) then
		LANG.Msg(ply, "buy_no_stock", nil, MSG_MSTACK_ROLE)

		return
	end

	local credits

	if equip_table then
		-- weapon whitelist check
		if not table.HasValue(equip_table.CanBuy, subrole) or equip_table.notBuyable then
			print(ply, "tried to buy equip his subrole is not permitted to buy")

			return
		end

		-- if we have a pending order because we are in a confined space, don't
		-- start a new one
		if HasPendingOrder(ply) then
			LANG.Msg(ply, "buy_pending", nil, MSG_MSTACK_ROLE)

			return
		end

		-- the item is just buyable if there is a special amount of players
		if not EquipmentIsBuyable(equip_table, ply:GetTeam()) then return end

		credits = equip_table.credits or 1

		if credits > ply:GetCredits() then
			print(ply, "tried to buy item/weapon, but didn't had enough credits")

			return
		end

		if GetGlobalInt("ttt2_random_shops") > 0 and RANDOMSHOP[ply] and #RANDOMSHOP[ply] > 0 then
			local key = false

			for i = 1, #RANDOMSHOP[ply] do
				if RANDOMSHOP[ply][i].id ~= id then continue end

				key = true

				break
			end

			if not key then
				print(ply, "tried to buy item/weapon, but didn't allowed to do so!")

				return
			end
		end

		-- no longer restricted to only WEAPON_EQUIP weapons, just anything that
		-- is whitelisted and carryable
		if not is_item then
			if ply:CanCarryWeapon(equip_table) then
				ply:GiveEquipmentWeapon(id)
			else
				return
			end
		else
			ply:GiveEquipmentItem(id)
		end
	else
		print(ply, "tried to buy equip that doesn't exists", id)

		return
	end

	ply:SubtractCredits(credits)

	LANG.Msg(ply, "buy_received", nil, MSG_MSTACK_ROLE)

	ply:AddBought(id)

	timer.Simple(0.5, function()
		if not IsValid(ply) then return end

		net.Start("TTT_BoughtItem")
		net.WriteString(id)
		net.Send(ply)
	end)

	if is_item and equip_table and isfunction(equip_table.Bought) then
		equip_table:Bought(ply)
	end

	-- still support old items
	local id2 = (is_item and equip_table.oldId or nil) or id

	hook.Call("TTTOrderedEquipment", GAMEMODE, ply, id2, is_item and id2 or false)

	if GetGlobalBool("ttt2_random_shop_reroll_per_buy") then
		RerollShop(ply)
	end
end
concommand.Add("ttt_order_equipment", OrderEquipment)

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
