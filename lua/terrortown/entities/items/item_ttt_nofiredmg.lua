if SERVER then
    AddCSLuaFile()
end

ITEM.EquipMenuData = {
    type = "item_passive",
    name = "item_no_fire_damage",
    desc = "item_no_fire_damage_desc",
}
ITEM.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }

ITEM.hud = Material("vgui/ttt/perks/hud_nofiredmg.png")
ITEM.material = "vgui/ttt/icon_nofiredmg"
ITEM.builtin = true

if SERVER then
    hook.Add("EntityTakeDamage", "TTT2NoFireDmg", function(target, dmginfo)
        if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsDamageType(DMG_BURN) then
            return
        end

        if
            target:Alive()
            and target:IsTerror()
            and target:HasEquipmentItem("item_ttt_nofiredmg")
        then
            dmginfo:ScaleDamage(0)
        end
    end)
end
