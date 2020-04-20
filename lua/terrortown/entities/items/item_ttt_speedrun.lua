if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/icon_speedrun.vmt")
	resource.AddFile("materials/vgui/ttt/perks/hud_speedrun.png")
end

ITEM.hud = Material("vgui/ttt/perks/hud_speedrun.png")
ITEM.EquipMenuData = {
	type = "item_passive",
	name = "Speedrun",
	desc = "You are 50% faster!"
}
ITEM.material = "vgui/ttt/icon_speedrun"
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}

hook.Add("TTTPlayerSpeedModifier", "SpeedrunModifySpeed", function(ply, _, _, refTbl)
	if not IsValid(ply) or not ply:HasEquipmentItem("item_ttt_speedrun") then return end

	refTbl[1] = refTbl[1] * 1.5 * (ply.speedrun_mul or 1)
end)
