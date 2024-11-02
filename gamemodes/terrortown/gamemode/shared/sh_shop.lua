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
    TEAMLIMITEDBOUGHT = 10,
    GLOBALLIMITEDBOUGHT = 11,
    NOTBUYABLEFORROLE = 12,
    PENDINGORDER = 13,
    NOSHOP = 14,
    NORANDOMSHOP = 15,
    NOTINSHOP = 16,
    BLOCKEDBYOLDHOOK = 17,
    BLOCKEDBYTTT2HOOK = 18,
}

shop.buyTable = shop.buyTable or {}
shop.globalBuyTable = shop.globalBuyTable or {}
shop.teamBuyTable = shop.teamBuyTable or {}

---
-- Initializes all necessary variables for the shop
-- @realm shared
function shop.Initialize()
    if CLIENT then
        shop.favorites.orm = orm.Make(shop.favorites.databaseName)
    end
end

---
-- Resets buy tables of shop
-- @realm shared
function shop.Reset()
    shop.buyTable = {}
    shop.globalBuyTable = {}
    shop.teamBuyTable = {}
end

---
-- Resets team buy tables of shop
-- @param Player ply The player to reset the table of
-- @param string oldTeam The identifier of the old team
-- @realm shared
function shop.ResetTeamBuy(ply, oldTeam)
    if CLIENT then
        shop.teamBuyTable[oldTeam] = nil
    elseif SERVER and oldTeam and shop.teamBuyTable[oldTeam] then
        net.Start("TTT2ResetTBEq")
        net.WriteString(oldTeam)
        net.Send(ply)
    end
end

---
-- Returns if the equipment is already bought for the player
-- @param Player ply The player to check
-- @param string equipmentName The name of the equipment to check
-- @return boolean If the Equipment was bought
-- @realm shared
function shop.IsBoughtFor(ply, equipmentName)
    return shop.buyTable[ply] and shop.buyTable[ply][equipmentName]
end

---
-- Returns if the equipment is already globally bought by a player
-- @param string equipmentName The name of the equipment to check
-- @return boolean If the Equipment was globally bought
-- @realm shared
function shop.IsGlobalBought(equipmentName)
    return shop.globalBuyTable[equipmentName]
end

---
-- Returns if the equipment is already bought for the players team
-- @param Player ply The player to check the team of
-- @param string equipmentName The name of the equipment to check
-- @return boolean If the Equipment was bought by a teammate
-- @realm shared
function shop.IsTeamBoughtFor(ply, equipmentName)
    local team = ply:GetTeam()

    return team and shop.teamBuyTable[team] and shop.teamBuyTable[team][equipmentName]
end

---
-- Marks the equipment as already bought for the player
-- @param Player ply The player to set it for
-- @param string equipmentName The name of the equipment to set
-- @realm shared
function shop.SetEquipmentBought(ply, equipmentName)
    shop.buyTable[ply] = shop.buyTable[ply] or {}
    shop.buyTable[ply][equipmentName] = true

    if CLIENT then
        return
    end

    shop.BroadcastEquipmentGlobalBought(equipmentName)
end

---
-- Marks the equipment as already globally bought
-- @param string equipmentName The name of the equipment to set
-- @realm shared
function shop.SetEquipmentGlobalBought(equipmentName)
    shop.globalBuyTable[equipmentName] = true

    if CLIENT then
        return
    end

    shop.BroadcastEquipmentGlobalBought(equipmentName)
end

---
-- Marks the equipment as already bought for the team of the player
-- @param Player ply The player to set it for
-- @param string equipmentName The name of the equipment to set
-- @realm shared
function shop.SetEquipmentTeamBought(ply, equipmentName)
    local team = ply:GetTeam()

    if not team or team == TEAM_NONE or TEAMS[team].alone then
        return
    end

    shop.teamBuyTable[team] = shop.teamBuyTable[team] or {}
    shop.teamBuyTable[team][equipmentName] = true

    if SERVER then
        net.Start("TTT2ReceiveTBEq")
        net.WriteString(equipmentName)
        net.Send(GetTeamFilter(team))
    end
end

---
-- Check if an equipment is currently buyable for a player
-- @param Player ply The player to buy the equipment for
-- @param string equipmentName The name of the equipment to buy
-- @return boolean True, if equipment can be bought
-- @return number The shop.statusCode, that lead to the decision
-- @realm shared
function shop.CanBuyEquipment(ply, equipmentName)
    if not IsValid(ply) or not ply:IsActive() then
        return false, shop.statusCode.INVALIDPLAYER
    end

    if not equipmentName then
        return false, shop.statusCode.INVALIDID
    end

    local isItem = items.IsItem(equipmentName)

    -- we use weapons.GetStored to save time making an unnecessary copy, we will not be modifying it
    local equipment = isItem and items.GetStored(equipmentName) or weapons.GetStored(equipmentName)

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
            return false, shop.statusCode.NOTENOUGHPLAYERS
        end
    end

    if equipment.limited and shop.IsBoughtFor(ply, equipmentName) then
        return false, shop.statusCode.LIMITEDBOUGHT
    end

    if equipment.globalLimited and shop.IsGlobalBought(equipmentName) then
        return false, shop.statusCode.GLOBALLIMITEDBOUGHT
    end

    if equipment.teamLimited and shop.IsTeamBoughtFor(ply, equipmentName) then
        return false, shop.statusCode.TEAMLIMITEDBOUGHT
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
            if RANDOMSHOP[ply][i].id ~= equipmentName then
                continue
            end

            containedInRandomShop = true
        end

        if not containedInRandomShop then
            return false, shop.statusCode.NOTINSHOP
        end
    end

    -- Still support old items
    local oldId = isItem and equipment.oldId or equipmentName

    ---
    -- @note Keep compatibility with old addons
    -- @realm server
    if not hook.Run("TTTCanOrderEquipment", ply, oldId, isItem) then
        return false, shop.statusCode.BLOCKEDBYOLDHOOK
    end

    ---
    -- @note Add our own hook with more consistent class parameter and some more information
    -- @realm server
    local allow, ignoreCost = hook.Run("TTT2CanOrderEquipment", ply, equipmentName, isItem, credits)
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
-- @param string equipmentName The name of the equipment to buy
-- @return boolean True, if equipment can be bought
-- @return number The shop.statusCode, that lead to the decision
-- @realm shared
function shop.BuyEquipment(ply, equipmentName)
    local isBuyable, statusCode = shop.CanBuyEquipment(ply, equipmentName)
    if not isBuyable then
        return false, statusCode
    end

    if CLIENT then
        net.Start("TTT2OrderEquipment")
        net.WriteString(equipmentName)
        net.SendToServer()
    else
        local isItem = items.IsItem(equipmentName)

        -- we use weapons.GetStored to save time making an unnecessary copy, we will not be modifying it
        local equipment = isItem and items.GetStored(equipmentName)
            or weapons.GetStored(equipmentName)
        local credits = equipment.credits or 1
        local ignoreCost = statusCode == shop.statusCode.SUCCESSIGNORECOST

        if not ignoreCost then
            ply:SubtractCredits(credits)
        end

        ply:AddBought(equipmentName)

        -- no longer restricted to only WEAPON_EQUIP weapons, just anything that
        -- is whitelisted and carryable
        if isItem then
            local item = ply:GiveEquipmentItem(equipmentName)

            if isfunction(item.Bought) then
                item:Bought(ply)
            end
        else
            ply:GiveEquipmentWeapon(equipmentName, function(_ply, _equipmentName, _weapon)
                if isfunction(_weapon.WasBought) then
                    -- some weapons give extra ammo after being bought, etc
                    _weapon:WasBought(_ply)
                end
            end)
        end

        LANG.Msg(ply, "buy_received", nil, MSG_MSTACK_ROLE)

        timer.Simple(0.5, function()
            if not IsValid(ply) then
                return
            end

            net.Start("TTT_BoughtItem")
            net.WriteString(equipmentName)
            net.Send(ply)
        end)

        if GetGlobalBool("ttt2_random_shop_reroll_per_buy") then
            shop.ForceRerollShop(ply)
        end

        -- Still support old items
        local oldId = isItem and equipment.oldId or equipmentName

        ---
        -- @note Keep compatibility with old addons
        -- @realm server
        hook.Run("TTTOrderedEquipment", ply, oldId, isItem)

        ---
        -- @note Add our own hook with more consistent class parameter
        -- @realm server
        hook.Run("TTT2OrderedEquipment", ply, equipmentName, isItem, credits, ignoreCost)
    end

    return true, statusCode
end

---
-- Check if the player can reroll their shop
-- @param Player ply The player to reroll the shop for
-- @return boolean True, if shop can be rerolled
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
-- @return boolean True, if shop was successfully rerolled
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
        ---
        -- @realm server
        hook.Run(
            "TTT2OrderedEquipment",
            ply,
            "reroll_shop",
            false,
            GetGlobalInt("ttt2_random_shop_reroll_cost"),
            false
        )
    end

    return true
end

---
-- Transfer credits from one player to another
-- @param Player ply The player to transfer the credits from
-- @param string targetPlyId64 The SteamID64 of the player to transfer the credits to
-- @param number credits The number of credits to transfer
-- @realm shared
function shop.TransferCredits(ply, targetPlyId64, credits)
    if not IsValid(ply) or not isstring(targetPlyId64) or not isnumber(credits) or credits <= 0 then
        return
    end

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

        if credits == 0 then
            return
        end

        ---
        -- @realm server
        local allow, _ = hook.Run("TTT2CanTransferCredits", ply, target, credits)
        if allow == false then
            return
        end

        ply:SubtractCredits(credits)

        if target:IsTerror() and target:Alive() then
            target:AddCredits(credits)
            ---
            -- @realm server
            hook.Run("TTT2OnTransferCredits", ply, target, credits, false)
        else
            -- The would be recipient is dead, which the sender may not know.
            -- Instead attempt to send the credits to the target's corpse, where they can be picked up.
            local rag = target:FindCorpse()

            if IsValid(rag) then
                CORPSE.SetCredits(rag, CORPSE.GetCredits(rag, 0) + credits)
                ---
                -- @realm server
                hook.Run("TTT2OnTransferCredits", ply, target, credits, false)
            end
        end

        net.Start("TTT2CreditTransferUpdate")
        net.Send(ply)

        LANG.Msg(ply, "xfer_success", { player = target:Nick() }, MSG_MSTACK_ROLE)
        LANG.Msg(target, "xfer_received", { player = ply:Nick(), num = credits }, MSG_MSTACK_ROLE)
    end
end
