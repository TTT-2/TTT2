if SERVER then
    AddCSLuaFile()
end

ITEM.EquipMenuData = {
    type = "item_passive",
    name = "item_no_explosion_damage",
    desc = "item_no_explosion_damage_desc",
}
ITEM.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }

ITEM.hud = Material("vgui/ttt/perks/hud_noexplosiondmg.png")
ITEM.material = "vgui/ttt/icon_noexplosiondmg"
ITEM.builtin = true

if SERVER then
    hook.Add("EntityTakeDamage", "TTT2NoExplosionDmg", function(target, dmginfo)
        if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsExplosionDamage() then
            return
        end

        if
            target:Alive()
            and target:IsTerror()
            and target:HasEquipmentItem("item_ttt_noexplosiondmg")
        then
            dmginfo:ScaleDamage(0)
        end
    end)
end
