if SERVER then
    AddCSLuaFile()
end

ITEM.EquipMenuData = {
    type = "item_passive",
    name = "item_no_fall_damage",
    desc = "item_no_fall_damage_desc",
}
ITEM.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }

ITEM.hud = Material("vgui/ttt/perks/hud_nofalldmg.png")
ITEM.material = "vgui/ttt/icon_nofalldmg"
ITEM.builtin = true

if SERVER then
    hook.Add("EntityTakeDamage", "TTT2NoFallDmg", function(target, dmginfo)
        if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsFallDamage() then
            return
        end

        if
            target:Alive()
            and target:IsTerror()
            and target:HasEquipmentItem("item_ttt_nofalldmg")
        then
            dmginfo:ScaleDamage(0)
        end
    end)

    hook.Add("OnPlayerHitGround", "TTT2NoFallDmg", function(ply)
        if ply:Alive() and ply:IsTerror() and ply:HasEquipmentItem("item_ttt_nofalldmg") then
            return false
        end
    end)
end
