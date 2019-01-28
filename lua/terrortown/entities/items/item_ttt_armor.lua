if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/icon_armor.vmt")
	resource.AddFile("materials/vgui/ttt/perks/hud_armor.png")
end

ITEM.hud = Material("vgui/ttt/perks/hud_armor.png")
ITEM.EquipMenuData = {
	type = "item_passive",
	name = "item_armor",
	desc = "item_armor_desc"
}
ITEM.material = "vgui/ttt/icon_armor"
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
ITEM.oldId = EQUIP_ARMOR or 1

if SERVER then
	hook.Add("ScalePlayerDamage", "TTTItemArmor", function(ply, _, dmginfo)
		if dmginfo:IsBulletDamage() and ply:HasEquipmentItem("item_ttt_armor") then
			dmginfo:ScaleDamage(0.7)
		end
	end)
end
