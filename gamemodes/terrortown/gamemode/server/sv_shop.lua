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
-- @return string Return a string that is shown in a @{MSTACK} message
-- @hook
-- @realm server
function GM:TTT2CanOrderEquipment(ply, cls, isItem, credits)

end

---
-- Called whenever a @{Player} ordered an @{ITEM} or @{Weapon}.
-- @param Player ply The player that bought something
-- @param string id id of the @{ITEM} or @{Weapon}, old id for @{ITEM} and class for @{Weapon}
-- @param boolean isItem True if item, false if weapon
-- @hook
-- @realm server
function GM:TTTOrderedEquipment(ply, id, isItem)

end

---
-- Called whenever a @{Player} ordered an @{ITEM} or @{Weapon}.
-- @param Player ply The player that bought something
-- @param string cls The class of the @{ITEM} or @{Weapon}
-- @param boolean isItem True if item, false if weapon
-- @param number credits The purchase price of the @{ITEM} or @{Weapon}
-- @param boolean ignoreCost True if the cost was ignored and received for free
-- @hook
-- @realm server
function GM:TTT2OrderedEquipment(ply, cls, isItem, credits, ignoreCost)

end

-- Equipment buying

local function NetOrderEquipment(len, ply)
	local equipmentId = net.ReadString()

	shop.BuyEquipment(ply, equipmentId)
end
net.Receive("TTT2OrderEquipment", NetOrderEquipment)

local function ConCommandOrderEquipment(ply, cmd, args)
	if #args ~= 1 then return end

	shop.BuyEquipment(ply, args[1])
end
concommand.Add("ttt_order_equipment", ConCommandOrderEquipment)

local function CheatCredits(ply)
	if not IsValid(ply) then return end

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
function GM:TTT2CanTransferCredits(sender, recipient, credits_per_xfer)

end

local function TransferCredits(ply, cmd, args)
	if #args ~= 2 then return end

	local plyId64 = tostring(args[1])
	local credits = tonumber(args[2])

	shop.TransferCredits(ply,plyId64,credits)
end
concommand.Add("ttt_transfer_credits", TransferCredits)

local function RerollShopForCredit(ply, cmd, args)
	shop.RerollShop(ply)
end
concommand.Add("ttt2_reroll_shop", RerollShopForCredit)
