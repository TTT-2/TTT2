if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/icon_nofalldmg.vmt")
	resource.AddFile("materials/vgui/ttt/perks/hud_nofalldmg.png")
end

ITEM.hud = Material("vgui/ttt/perks/hud_nofalldmg.png")
ITEM.EquipMenuData = {
	type = "item_passive",
	name = "NoFallDamage",
	desc = "You don't get falldamage anymore!"
}
ITEM.material = "vgui/ttt/icon_nofalldmg"
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}

if SERVER then
	hook.Add("EntityTakeDamage", "TTT2NoFallDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsFallDamage() then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem("item_ttt_nofalldmg") then
			dmginfo:ScaleDamage(0) -- no dmg
		end
	end)

	hook.Add("OnPlayerHitGround", "TTT2NoFallDmg", function(ply)
		if ply:Alive() and ply:IsTerror() and ply:HasEquipmentItem("item_ttt_nofalldmg") then
			return false
		end
	end)
end
