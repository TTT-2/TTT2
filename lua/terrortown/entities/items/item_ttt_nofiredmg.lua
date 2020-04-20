if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/icon_nofiredmg.vmt")
	resource.AddFile("materials/vgui/ttt/perks/hud_nofiredmg.png")
end

ITEM.hud = Material("vgui/ttt/perks/hud_nofiredmg.png")
ITEM.EquipMenuData = {
	type = "item_passive",
	name = "NoFireDamage",
	desc = "You don't get firedamage anymore!"
}
ITEM.material = "vgui/ttt/icon_nofiredmg"
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}

if SERVER then
	hook.Add("EntityTakeDamage", "TTT2NoFireDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsDamageType(DMG_BURN) then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem("item_ttt_nofiredmg") then
			dmginfo:ScaleDamage(0) -- no dmg
		end
	end)
end
