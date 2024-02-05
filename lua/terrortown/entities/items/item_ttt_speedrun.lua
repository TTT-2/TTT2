if SERVER then
    AddCSLuaFile()
end

ITEM.EquipMenuData = {
    type = "item_passive",
    name = "item_speedrun",
    desc = "item_speedrun_desc",
}
ITEM.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }

ITEM.material = "vgui/ttt/icon_speedrun"
ITEM.builtin = true

hook.Add("TTTPlayerSpeedModifier", "TTT2SpeedRun", function(ply, _, _, speedMultiplierModifier)
    if not IsValid(ply) or not ply:HasEquipmentItem("item_ttt_speedrun") then
        return
    end

    speedMultiplierModifier[1] = speedMultiplierModifier[1] * 1.5
end)
