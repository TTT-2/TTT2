if SERVER then
    AddCSLuaFile()
end

ITEM.EquipMenuData = {
    type = "item_passive",
    name = "item_no_prop_damage",
    desc = "item_no_prop_damage_desc",
}
ITEM.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }

ITEM.hud = Material("vgui/ttt/perks/hud_nopropdmg.png")
ITEM.material = "vgui/ttt/icon_nopropdmg"
ITEM.builtin = true

if SERVER then
    hook.Add("EntityTakeDamage", "TTT2NoPropDmg", function(target, dmginfo)
        if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsDamageType(DMG_CRUSH) then
            return
        end

        if
            target:Alive()
            and target:IsTerror()
            and target:HasEquipmentItem("item_ttt_nopropdmg")
        then
            dmginfo:ScaleDamage(0)
        end
    end)
end
