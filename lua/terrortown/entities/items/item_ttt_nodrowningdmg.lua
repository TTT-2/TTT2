if SERVER then
    AddCSLuaFile()
end

ITEM.EquipMenuData = {
    type = "item_passive",
    name = "item_no_drown_damage",
    desc = "item_no_drown_damage_desc",
}
ITEM.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }

ITEM.hud = Material("vgui/ttt/perks/hud_nodrowningdmg.png")
ITEM.material = "vgui/ttt/icon_nodrowningdmg"
ITEM.builtin = true

if SERVER then
    hook.Add("EntityTakeDamage", "TTT2NoDrownDmg", function(target, dmginfo)
        if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsDamageType(DMG_DROWN) then
            return
        end

        if
            target:Alive()
            and target:IsTerror()
            and target:HasEquipmentItem("item_ttt_nodrowningdmg")
        then
            dmginfo:ScaleDamage(0)
        end
    end)
end
