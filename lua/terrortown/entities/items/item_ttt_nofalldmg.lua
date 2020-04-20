if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/icon_nofalldmg.vmt")
	resource.AddFile("materials/vgui/ttt/perks/hud_nofalldmg.png")
end

ITEM.hud = Material("vgui/ttt/perks/hud_nofalldmg.png")
ITEM.EquipMenuData = {
	type = "item_passive",
	name = "NoFallDamage",
	desc = "You don't get falldamage anymore!"
}
ITEM.material = "vgui/ttt/icon_nofalldmg"
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}

if SERVER then
	hook.Add("ScalePlayerDamage", "TTTNoFallDmg", function(ply, _, dmginfo)
        if ply:IsActive() and ply:HasEquipmentItem("item_ttt_nofalldmg") then
            if dmginfo:IsFallDamage() then
				dmginfo:ScaleDamage(0) -- no dmg
			end
        end
    end)

    hook.Add("EntityTakeDamage", "TTTNoFallDmg", function(target, dmginfo)
        if not target or not IsValid(target) or not target:IsPlayer() then return end
    
        if target:IsActive() and target:HasEquipmentItem("item_ttt_nofalldmg") then
            if dmginfo:IsFallDamage() then -- check its fall dmg.
                dmginfo:ScaleDamage(0) -- no dmg
            end
        end
    end)

    hook.Add("OnPlayerHitGround", "TTTNoFallDmg", function(ply)
        if ply:IsActive() and ply:HasEquipmentItem("item_ttt_nofalldmg") then
			return false
        end
	end)
end
