if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/icon_armor.vmt")
	resource.AddFile("materials/vgui/ttt/perks/hud_armor.png")
end

ITEM.Icon = "vgui/ttt/perks/hud_armor.png"
ITEM.EquipMenuData = {
	type = "item_passive",
	name = "item_armor",
	desc = "item_armor_desc",
	material = "vgui/ttt/icon_armor"
}
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
ITEM.oldId = EQUIP_ARMOR

if SERVER then
	hook.Add("ScalePlayerDamage", "TTTItemArmor", function(ply, _, dmginfo)
		if dmginfo:IsBulletDamage() and ply:HasEquipmentItem("item_ttt_armor") then
			dmginfo:ScaleDamage(0.7)
		end
	end)
end
