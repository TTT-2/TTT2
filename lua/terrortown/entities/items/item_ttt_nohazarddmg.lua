if SERVER then
    AddCSLuaFile()
end

ITEM.EquipMenuData = {
    type = "item_passive",
    name = "item_no_hazard_damage",
    desc = "item_no_hazard_damage_desc",
}
ITEM.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }

ITEM.hud = Material("vgui/ttt/perks/hud_nohazarddmg.png")
ITEM.material = "vgui/ttt/icon_nohazarddmg"
ITEM.builtin = true

if SERVER then
    hook.Add("EntityTakeDamage", "TTT2NoHazardDmg", function(target, dmginfo)
        if
            not IsValid(target)
            or not target:IsPlayer()
            or not (
                dmginfo:IsDamageType(DMG_POISON)
                or dmginfo:IsDamageType(DMG_NERVEGAS)
                or dmginfo:IsDamageType(DMG_RADIATION)
                or dmginfo:IsDamageType(DMG_ACID)
                or dmginfo:IsDamageType(DMG_DISSOLVE)
            )
        then
            return
        end

        if
            target:Alive()
            and target:IsTerror()
            and target:HasEquipmentItem("item_ttt_nohazarddmg")
        then
            dmginfo:ScaleDamage(0)
        end
    end)
end
