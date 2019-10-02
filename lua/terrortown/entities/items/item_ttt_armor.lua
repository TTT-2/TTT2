if SERVER then
	AddCSLuaFile()
end

ITEM.EquipMenuData = {
	type = "item_passive",
	name = "item_armor",
	desc = "item_armor_desc"
}

ITEM.material = "vgui/ttt/icon_armor"
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
ITEM.oldId = EQUIP_ARMOR or 1
ITEM.limited = false

function ITEM:Equip(buyer)
	if SERVER then
		buyer:GiveArmor(GetConVar("ttt_item_armor_value"):GetInt())
	end
end

function ITEM:Reset(buyer)
	if SERVER then
		buyer:RemoveArmor(GetConVar("ttt_item_armor_value"):GetInt())
	end
end

-- HANDLE ITEM CLASSIC MODE
if CLIENT then
	hook.Add("TTTBeginRound", "ttt2_base_register_armor_text", function()
		if GetGlobalBool("ttt_armor_classic") then
			local item = items.GetStored("item_ttt_armor")
			if not item then return end

			-- limit item when in classic mode
			item.limited = true
		end
	end)
end
