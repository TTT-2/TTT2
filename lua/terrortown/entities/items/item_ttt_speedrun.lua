if SERVER then
	AddCSLuaFile()
end

ITEM.EquipMenuData = {
	type = "item_passive",
	name = "item_speedrun",
	desc = "item_speedrun_desc"
}
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}

ITEM.hud = Material("vgui/ttt/perks/hud_speedrun.png")
ITEM.material = "vgui/ttt/icon_speedrun"

hook.Add("TTTPlayerSpeedModifier", "SpeedrunModifySpeed", function(ply, _, _, refTbl)
	if not IsValid(ply) or not ply:HasEquipmentItem("item_ttt_speedrun") then return end

	refTbl[1] = refTbl[1] * 1.5 * (ply.speedrun_mul or 1)
end)
