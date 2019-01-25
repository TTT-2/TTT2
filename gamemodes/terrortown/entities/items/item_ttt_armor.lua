if SERVER then
	AddCSLuaFile()
end

ITEM.Base = "item_base"

ITEM.Icon = "vgui/ttt/icon_armor"
ITEM.EquipMenuData = {
	type = "item_passive",
	name = "item_armor",
	desc = "item_armor_desc"
}
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}

if SERVER then
	hook.Add("ScalePlayerDamage", "TTTItemArmor", function(ply, hitgroup, dmginfo)
		if dmginfo:IsBulletDamage() and ply:HasEquipmentItem(EQUIP_ARMOR) then
			dmginfo:ScaleDamage(0.7)
		end
	end)
end
