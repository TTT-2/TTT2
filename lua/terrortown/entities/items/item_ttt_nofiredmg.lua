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
	hook.Add("ScalePlayerDamage", "TTTNoFireDmg", function(ply, _, dmginfo)
		if ply:IsActive() and ply:HasEquipmentItem("item_ttt_nofiredmg") and dmginfo:IsDamageType(DMG_BURN) then
			dmginfo:ScaleDamage(0) -- no dmg
		end
	end)

	hook.Add("EntityTakeDamage", "TTTNoFireDmg", function(target, dmginfo)
		if not target or not IsValid(target) or not target:IsPlayer() then return end

		if target:IsActive() and target:HasEquipmentItem("item_ttt_nofiredmg") and dmginfo:IsDamageType(DMG_BURN) then -- check its fire dmg.
			dmginfo:ScaleDamage(0) -- no dmg
		end
	end)
end
