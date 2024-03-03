if SERVER then
    AddCSLuaFile()
end

ITEM.EquipMenuData = {
    type = "item_passive",
    name = "item_no_energy_damage",
    desc = "item_no_energy_damage_desc",
}
ITEM.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }

ITEM.hud = Material("vgui/ttt/perks/hud_noenergydmg.png")
ITEM.material = "vgui/ttt/icon_noenergydmg"
ITEM.builtin = true

if SERVER then
    hook.Add("EntityTakeDamage", "TTT2NoEnergyDmg", function(target, dmginfo)
        if
            not IsValid(target)
            or not target:IsPlayer()
            or not (
                dmginfo:IsDamageType(DMG_SHOCK)
                or dmginfo:IsDamageType(DMG_SONIC)
                or dmginfo:IsDamageType(DMG_ENERGYBEAM)
                or dmginfo:IsDamageType(DMG_PHYSGUN)
                or dmginfo:IsDamageType(DMG_PLASMA)
            )
        then
            return
        end

        if
            target:Alive()
            and target:IsTerror()
            and target:HasEquipmentItem("item_ttt_noenergydmg")
        then
            dmginfo:ScaleDamage(0)
        end
    end)
end
