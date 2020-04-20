if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/icon_noexplosiondmg.vmt")
	resource.AddFile("materials/vgui/ttt/perks/hud_noexplosiondmg.png")
end

ITEM.hud = Material("vgui/ttt/perks/hud_noexplosiondmg.png")
ITEM.EquipMenuData = {
	type = "item_passive",
	name = "NoExplosionDamage",
	desc = "You don't get explosiondamage anymore!"
}
ITEM.material = "vgui/ttt/icon_noexplosiondmg"
ITEM.credits = 2
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}

if SERVER then
	hook.Add("EntityTakeDamage", "TTT2NoExplosionDmg", function(target, dmginfo)
		if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsExplosionDamage() then return end

		if target:Alive() and target:IsTerror() and target:HasEquipmentItem("item_ttt_noexplosiondmg") then
			dmginfo:ScaleDamage(0) -- no dmg
		end
	end)
end
