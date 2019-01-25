-- Variables that are used on both client and server

ITEM.PrintName = "Scripted Item" -- 'Nice' Item name (Shown on HUD)
ITEM.Author = ""
ITEM.Contact = ""
ITEM.Purpose = ""
ITEM.Instructions = ""

-- If CanBuy is a table that contains ROLE_TRAITOR and/or ROLE_DETECTIVE, those
-- players are allowed to purchase it and it will appear in their Equipment Menu
-- for that purpose. If CanBuy is nil this item cannot be bought.
--   Example: ITEM.CanBuy = { ROLE_TRAITOR }
-- (just setting to nil here to document its existence, don't make this buyable)
ITEM.CanBuy = nil

ITEM.Category = "TTT"

--[[---------------------------------------------------------
	Name: Reset
	Desc: Called just before entity is deleted
-----------------------------------------------------------]]
function ITEM:Reset()

end

--[[---------------------------------------------------------
	Name: Equip
	Desc: A player or NPC has picked the item up
-----------------------------------------------------------]]
function ITEM:Equip(newOwner)

end

function ITEM:IsEquipment()
	return WEPS.IsEquipment(self)
end
