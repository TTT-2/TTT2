---
-- A class to handle all shop requirements
-- @author ZenBre4ker
-- @class Shop

shop = shop or {}

util.AddNetworkString("TTT2CreditTransferUpdate")

---
-- Called whenever a @{Player} tries to order an @{ITEM} or @{Weapon}.
-- @param Player ply The player that attempts to buy something
-- @param string id id of the @{ITEM} or @{Weapon}, old id for @{ITEM} and class for @{Weapon}
-- @param boolean isItem True if item, false if weapon
-- @return[default=true] boolean return true to allow buying of an equipment item, false to disallow
-- @hook
-- @realm server
function GM:TTTCanOrderEquipment(ply, id, isItem)
    return true
end

---
-- Called whenever a @{Player} tries to order an @{ITEM} or @{Weapon}.
-- @param Player ply The player that attempts to buy something
-- @param string cls The class of the @{ITEM} or @{Weapon}
-- @param boolean isItem True if item, false if weapon
-- @param number credits The purchase price of the @{ITEM} or @{Weapon}
-- @return boolean Return false to block buying of an equipment item
-- @return boolean Return true to make the purchase free
-- @hook
-- @realm server
function GM:TTT2CanOrderEquipment(ply, cls, isItem, credits)
    return true, false
end

---
-- Called whenever a @{Player} ordered an @{ITEM} or @{Weapon}.
-- @param Player ply The player that bought something
-- @param string id id of the @{ITEM} or @{Weapon}, old id for @{ITEM} and class for @{Weapon}
-- @param boolean isItem True if item, false if weapon
-- @hook
-- @realm server
function GM:TTTOrderedEquipment(ply, id, isItem) end

---
-- Called whenever a @{Player} ordered an @{ITEM} or @{Weapon}.
-- @param Player ply The player that bought something
-- @param string equipmentName The name of the @{ITEM} or @{Weapon}
-- @param boolean isItem True if item, false if weapon
-- @param number credits The purchase price of the @{ITEM} or @{Weapon}
-- @param boolean ignoreCost True if the cost was ignored and received for free
-- @hook
-- @realm server
function GM:TTT2OrderedEquipment(ply, equipmentName, isItem, credits, ignoreCost) end

-- Equipment buying

local function HandleErrorMessage(ply, equipmentName, statusCode)
    if statusCode == shop.statusCode.SUCCESS then
        return
    elseif statusCode == shop.statusCode.PENDINGORDER then
        LANG.Msg(ply, "buy_pending", nil, MSG_MSTACK_ROLE)
    elseif statusCode == shop.statusCode.NOTEXISTING then
        Dev(1, ply:Nick() .. " tried to buy equip that doesn't exist: " .. equipmentName)
    elseif statusCode == shop.statusCode.NOTENOUGHCREDITS then
        Dev(1, ply:Nick() .. " tried to buy item/weapon, but didn't have enough credits.")
    elseif statusCode == shop.statusCode.INVALIDID then
        ErrorNoHaltWithStack("[TTT2][ERROR] Equipment without ID was requested by:", ply:Nick())
    elseif statusCode == shop.statusCode.NOTBUYABLE then
        LANG.Msg(ply, "This equipment cannot be bought.", nil, MSG_MSTACK_ROLE)
    elseif statusCode == shop.statusCode.NOTENOUGHPLAYERS then
        LANG.Msg(ply, "Minimum amount of active players needed.", nil, MSG_MSTACK_ROLE)
    elseif statusCode == shop.statusCode.LIMITEDBOUGHT then
        LANG.Msg(ply, "This equipment is limited and is already bought.", nil, MSG_MSTACK_ROLE)
    elseif statusCode == shop.statusCode.NOTBUYABLEFORROLE then
        LANG.Msg(ply, "Your role can't buy this equipment.", nil, MSG_MSTACK_ROLE)
    end
end

---
-- This skips restrictions and forces a reroll of the shop
-- @param Player ply The player to reroll the shop for
-- @realm server
function shop.ForceRerollShop(ply)
    if GetGlobalBool("ttt2_random_team_shops") then
        ResetRandomShopsForRole(ply:GetSubRole(), GetGlobalInt("ttt2_random_shop_items"), true)
    else
        UpdateRandomShops({ ply }, GetGlobalInt("ttt2_random_shop_items"), false)
    end
end

local function NetOrderEquipment(len, ply)
    local equipmentName = net.ReadString()

    local isSuccess, statusCode = shop.BuyEquipment(ply, equipmentName)

    if not isSuccess then
        HandleErrorMessage(ply, equipmentName, statusCode)
    end
end
net.Receive("TTT2OrderEquipment", NetOrderEquipment)

---
-- Broadcast a globally bought equipment
-- @param string equipmentName The bought equipment
-- @realm server
function shop.BroadcastEquipmentGlobalBought(equipmentName)
    net.Start("TTT2ReceiveGBEq")
    net.WriteString(equipmentName)
    net.Broadcast()
end

---
-- Sends all bought equipments to players as globally bought
-- @param Player ply The player to send it to
-- @realm shared
function shop.SendAllEquipmentGlobalBought(ply)
    for equipmentName in pairs(shop.globalBuyTable) do
        net.Start("TTT2ReceiveGBEq")
        net.WriteString(equipmentName)
        net.Send(ply)
    end
end

---
-- Sends all bought equipments to players of the same team
-- @param Player ply The player to get the team of
-- @realm shared
function shop.SendEquipmentTeamBought(ply)
    local team = ply:GetTeam()

    if team and shop.teamBuyTable[team] then
        local filter = GetTeamFilter(team)

        for equipmentName in pairs(shop.teamBuyTable[team]) do
            net.Start("TTT2ReceiveTBEq")
            net.WriteString(equipmentName)
            net.Send(filter)
        end
    end
end

local function TTT2SyncShopsWithServer(len, ply)
    -- reset and set if it's a fallback
    net.Start("shopFallbackReset")
    net.Send(ply)

    SyncEquipment(ply)

    shop.SendAllEquipmentGlobalBought(ply)
    shop.SendEquipmentTeamBought(ply)
end
net.Receive("TTT2SyncShopsWithServer", TTT2SyncShopsWithServer)

local function ConCommandOrderEquipment(ply, cmd, args)
    if #args ~= 1 then
        return
    end

    local isSuccess, statusCode = shop.BuyEquipment(ply, args[1])

    if not isSuccess then
        HandleErrorMessage(ply, args[1], statusCode)
    end
end
concommand.Add("ttt_order_equipment", ConCommandOrderEquipment)

local function CheatCredits(ply)
    if not IsValid(ply) then
        return
    end

    ply:AddCredits(10)
end
concommand.Add("ttt_cheat_credits", CheatCredits, nil, nil, FCVAR_CHEAT)

---
-- Called to check if a transaction between two players is allowed.
-- @param Player sender that wants to send credits
-- @param Player recipient that would receive the credits
-- @param number credits_per_xfer that would be transferred
-- @return[default=nil] boolean which disallows a transaction when false
-- @return[default=nil] string for the client which offers info related to the transaction
-- @hook
-- @realm server
function GM:TTT2CanTransferCredits(sender, recipient, credits_per_xfer) end

---
-- Called when a player has successfully transfered a credit to another player.
-- @param Player sender Player that has sent the credits.
-- @param Player recipient Player that has received the credits.
-- @param number credits Amount of credits that have been transferred.
-- @param boolean isRecipientDead If the recipient is dead or not.
-- @hook
-- @realm server
function GM:TTT2OnTransferCredits(sender, recipient, credits, isRecipientDead) end

local function TransferCredits(ply, cmd, args)
    if #args ~= 2 then
        return
    end

    local plyId64 = tostring(args[1])
    local credits = tonumber(args[2])

    shop.TransferCredits(ply, plyId64, credits)
end
concommand.Add("ttt_transfer_credits", TransferCredits)

local function RerollShopForCredit(ply, cmd, args)
    shop.TryRerollShop(ply)
end
concommand.Add("ttt2_reroll_shop", RerollShopForCredit)
